Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132E84D6B8D
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 01:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiCLAzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 19:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCLAzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 19:55:18 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412D046B1E
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:54:13 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z7so12085793iom.1
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=nbPWhFjlBXMXn9fPhGyhCVA7IkDK17ipjGA7YfuX3OU=;
        b=DtbG66XoBOAGGXnuc4DDogkW1Jof2SgBc6tldN41jFP19z1JJsT3IKLWg4DKS1W2U7
         IyQ1jOSvNZRQTMFdh+Zck0y8HJ5lUhvFQUNB4cvt2hJGz1PCs/p2eYuW0JyX1Kd5T1tm
         klUpg5hn5iWVL1kPG1nsQTsA1ok/UtcuvGxsql5AE20O+4oOuh5P0MLfUVywgVf+Yqon
         wu1hw7xkxBquFK5JSOh+d/GIU1BSnd4SE1QTAoPM67Cm0ppz9RD4+4onqt+iQZJrKVqU
         asadph3r80PxUlJ7oZy2X6nBqAELii8ionxZbHWHd7z5I45M8nof41MbpU+Ob/KZzStF
         CAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nbPWhFjlBXMXn9fPhGyhCVA7IkDK17ipjGA7YfuX3OU=;
        b=hyQA/WgZ3kBRYm3eEUAiwnarfciE9jf/Z0UAXNTVQ06jfg58qu1ztsxVzbnqiqC81Q
         BERdrwPb4FTA4Q7KGcHr/5kHLjPPH6Du+ymkgOFnN3iHE/o9UN6eJqdNiHA5eOuGkTEw
         8XY5f2u3AAwq/XpfPfOwSETNrtp0utQTDhsQnIaAZ3XHY/CSmbyWl0iOaALSnJDVY+Au
         PCCEUY37hpi0yWRm6iUsHc0tnSCYWiB8J1kc+S2RNYXy7dGS66k+9Va13cGHdZqd05T9
         WqxPCHBdW2pQKulujv5slAFQkfrV92TPntniO7VJgjUF6pPQ761EFMH9AziTvqylHw5I
         SAEw==
X-Gm-Message-State: AOAM531UxKSjzAv4D/1Ql+Gt0ushTCzMeJ/V+lpBIDBqnOW6kM9Oxzx0
        ctvdoTL6gwgGi6BoJrta9G1KAZfuyWzrRw==
X-Google-Smtp-Source: ABdhPJxcyFmaRh6JxofnAdGyGOxb1x4fjjKh2ch7rZ2GSPHA7Sowl4BBbYBkUekEXOwRyi3+0oZxBA==
X-Received: by 2002:a6b:8e91:0:b0:645:c11f:e322 with SMTP id q139-20020a6b8e91000000b00645c11fe322mr9823327iod.162.1647046453318;
        Fri, 11 Mar 2022 16:54:13 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id r9-20020a6b6009000000b006412abddbbbsm4913428iog.24.2022.03.11.16.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 16:54:12 -0800 (PST)
Message-ID: <25fbaad8-c491-0add-b60a-f06637df3a04@gmail.com>
Date:   Fri, 11 Mar 2022 17:54:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] vrf/mcast: Fix mcast routing when using vrf.
Content-Language: en-US
To:     greearb@candelatech.com, netdev@vger.kernel.org
References: <20220311172509.10992-1-greearb@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220311172509.10992-1-greearb@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/22 10:25 AM, greearb@candelatech.com wrote:
> @@ -2516,12 +2517,26 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
>  			flags &= ~RTCF_LOCAL;
>  		else
>  			do_cache = false;
> -		/* If multicast route do not exist use
> -		 * default one, but do not gateway in this case.
> +		/* If multicast route does not exist use
> +		 * default one, but do not use gateway in this case.
>  		 * Yes, it is hack.

I think I have a better way to do this. Let's see how the testing goes.

