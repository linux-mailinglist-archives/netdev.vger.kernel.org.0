Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F4250337A
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiDPFpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 01:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiDPFpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 01:45:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D2EB82C6;
        Fri, 15 Apr 2022 22:43:20 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so13236436pjb.2;
        Fri, 15 Apr 2022 22:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VveAaJQrLZTOJ5nAlkzPLuKBOVh4Qe7+DM8P2UVWRbk=;
        b=QfmDjH6eOlLf3j2i4pkM2EepKkmyIYSXcCF4uWtyyWSwG/P2fP9kgkqG+/lnDipyZd
         ZtA4FQsmZ20xKBLy6BACQskf4nF0rxdQtqQChS4ztgtMNuOeVolkCpenywOelDE5JgDi
         /CiWdn/DodF60EDj5WETb7BxDf4JLAx3j22DP5n1xzQoEINtyXvJO757fmmOKidUtmDm
         vPXOSe2GeS6GHREC/DKY5b9Ni8TbS+c0jMYpwjj/+7Iw5rRXqqNfvXjCzW/VxfhQmR/o
         I+H9eKefFIG03Ji8386GIw6f4i9SxWsxTODGCGPvGJCvWZoaFS6AO7lwAh4hRbwCvwQk
         LOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VveAaJQrLZTOJ5nAlkzPLuKBOVh4Qe7+DM8P2UVWRbk=;
        b=kdcAUGghyTpL8k9WQNxZE3nPo/UJqvJLm18iJJKpj6EMmMKqp9Mkkbk9207rQiJ1Mq
         bkvQn9gUfjofAoJUfLTRG1dYANwtUr0mRW7dzezl4TrLPYYR5iw/v8jfOitTuxf8CPJj
         dyqe5xeXhEnITaJ7P0qmQcE1adhE8M7R4426fSwyYFvywL+r4ZI2z16b/FSGVbqc/XYa
         iaOauQc9RMEpENvFt9zWcbkOG9T18rHtsruj9nCb4/NhW/+cGOMlFDQgUoQ0010HP/WL
         Xydp87OQW5VGFNm1sABksbgnGquDW+nf14yNu6+3q7cD1qV+L3BkOFyCfnL0YLdhZHnX
         1b7Q==
X-Gm-Message-State: AOAM533Dup0KXPRkbCM61E3Vvce481i7Qy3XU7+B+X6fbSuwChhZCIv4
        bRlLQsVAI/dzsYVWh4cVhBycC92pyC8=
X-Google-Smtp-Source: ABdhPJz5pMf0lbnwCwAmE2o47PXiM2SGhxBZ/XO8J7tcPxUbGCqY10WIqNNO5y5tK+BglEK5Pjw6+A==
X-Received: by 2002:a17:90a:a4e:b0:1cb:58a9:af2a with SMTP id o72-20020a17090a0a4e00b001cb58a9af2amr2410102pjo.101.1650087800170;
        Fri, 15 Apr 2022 22:43:20 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-90.three.co.id. [180.214.233.90])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7888b000000b00505bc0b970csm4837683pfe.181.2022.04.15.22.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 22:43:19 -0700 (PDT)
Message-ID: <642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com>
Date:   Sat, 16 Apr 2022 12:43:14 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v6] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
References: <20220415083402.39080-1-aajith@arista.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220415083402.39080-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/22 15:34, Arun Ajith S wrote:
> +accept_unsolicited_na - BOOLEAN
> +	Add a new neighbour cache entry in STALE state for routers on receiving an
> +	unsolicited neighbour advertisement with target link-layer address option
> +	specified. This is as per router-side behavior documented in RFC9131.
> +	This has lower precedence than drop_unsolicited_na.
> +
> +	 ====   ======  ======  ==============================================
> +	 drop   accept  fwding                   behaviour
> +	 ----   ------  ------  ----------------------------------------------
> +	    1        X       X  Drop NA packet and don't pass up the stack
> +	    0        0       X  Pass NA packet up the stack, don't update NC
> +	    0        1       0  Pass NA packet up the stack, don't update NC
> +	    0        1       1  Pass NA packet up the stack, and add a STALE
> +	                        NC entry
> +	 ====   ======  ======  ==============================================
> +
> +	This will optimize the return path for the initial off-link communication
> +	that is initiated by a directly connected host, by ensuring that
> +	the first-hop router which turns on this setting doesn't have to
> +	buffer the initial return packets to do neighbour-solicitation.
> +	The prerequisite is that the host is configured to send
> +	unsolicited neighbour advertisements on interface bringup.
> +	This setting should be used in conjunction with the ndisc_notify setting
> +	on the host to satisfy this prerequisite.
> +
> +	By default this is turned off.
> +

Looks good. htmldocs builds successfully and the table displayed properly.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

However, I remind you the following:

- The patch changelogs should be put between the dashes (---) and diffstat.
  I don't see the changelogs when I hit reply-all because you put them as
  message signature (at very bottom of patch message).
- DON'T DO top-posting, DO configure your MUA to make reply text below
  the quoted text instead.

-- 
An old man doll... just what I always wanted! - Clara
