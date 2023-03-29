Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5B6CEC27
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjC2OwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjC2OwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:52:04 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C583F2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:51:53 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h14so6869522ilj.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680101512;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IRLFVArb9YTeIujavBGhsrWcOeSWzavLVjHwZZ6E+c8=;
        b=mnTkw52FfCbZP5v4Ez4gzP2KNbYiEJrygBQ21P+me8r1Rxx7spJyUH2QYdtfxzxBTw
         nuzFs+OqYxQ5jDbAfFy2KBJca4rXDxVbplaJKvPIjnhpE6LSVl+6tU8++x95J++CA4eG
         bDEUmQklgLpMggPXkHpBt3Jr6TpF/vE0R7haWTujAUve8jBUq4aygLRs0nRG0JdfB85N
         ZYuTae3XD+2za23fQRFMgSFdo1SflY8LSngf+qH71Ezk4s3VouTn+BFwX1iZ8+51h9Rr
         ecNGetVjIHPcQJPecwIuy2vlG6EMotxaIQLfrQFRiw801yctCrqd3J/yz6kfns4kXUVO
         bIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680101512;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IRLFVArb9YTeIujavBGhsrWcOeSWzavLVjHwZZ6E+c8=;
        b=2ikcwC9ck/e1Oj3zLjKFS6MyXKEehQv0tKCYVsQ1DU2b8dHGvPBoXSNfsQdOUiIuas
         eiHkzIqBm564R0CrhlvA2eZe1p3INFe8N42tA0H3a4FkZrms5yX+wucUAUahQgm/2HB3
         rikog9zMfFIL4UtAuLsVGzAhlQUkbyGwaUGKEqBeM/Vj/xYfpDnlQAZaEIsiQqV1kMww
         wwsUFCnRrKSVri+hHWARhWTHiNyJsaZYP7j+CejeabD8IZIwO26geMEQEu6Gny9BQRAH
         il3EBCvLBDxj+u28mzYtjKE0N3hBBvU7Ow/DVmxmPIfFMqs9e3GXh3LMG2XbFeH5I00+
         OM0w==
X-Gm-Message-State: AAQBX9eXcKEu6wfH+Vw23d4l3BOuI4u96TMja98KmmQ/kuFCJnMBeWpn
        eVGkpC5VeO1S+Qhi/YT81RnnOgKOi4Ln0Q==
X-Google-Smtp-Source: AKy350atJUzA7z43aU90Nq0ei8OHdSfu3e5YuSg0RLrGDmHLioh4It33+h+JGy9Cu1+8znAwNz4cXw==
X-Received: by 2002:a05:6e02:4d2:b0:326:1cf1:a9ce with SMTP id f18-20020a056e0204d200b003261cf1a9cemr4833765ils.29.1680101512469;
        Wed, 29 Mar 2023 07:51:52 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:9428:49f2:b7cb:5336? ([2601:282:800:7ed0:9428:49f2:b7cb:5336])
        by smtp.googlemail.com with ESMTPSA id x3-20020a056638248300b003ee9720740esm10542938jat.153.2023.03.29.07.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 07:51:51 -0700 (PDT)
Message-ID: <b52bb122-b5e2-cff1-1c0a-ad8a855e278d@gmail.com>
Date:   Wed, 29 Mar 2023 08:51:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH iproute2-next] macvlan: Add bclim parameter
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
References: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
 <ZCJYxDy1fgCm+cbj@gondor.apana.org.au>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <ZCJYxDy1fgCm+cbj@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/23 9:02 PM, Herbert Xu wrote:
> @@ -67,6 +68,12 @@ static int bc_queue_len_arg(const char *arg)
>  	return -1;
>  }
>  
> +static int bclim_arg(const char *arg)
> +{
> +	fprintf(stderr, "Error: illegal value for \"bclen\": \"%s\"\n", arg);

s/bclen/bclim/?

> +	return -1;
> +}
> +
>  static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
>  			  struct nlmsghdr *n)
>  {
> @@ -168,6 +175,15 @@ static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
>  				return bc_queue_len_arg(*argv);
>  			}
>  			addattr32(n, 1024, IFLA_MACVLAN_BC_QUEUE_LEN, bc_queue_len);
> +		} else if (matches(*argv, "bclim") == 0) {

we stopped accepting new uses of `matches`; make this strcmp.



