Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC683EEEF8
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhHQPLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbhHQPLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 11:11:49 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EABC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:11:16 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id h63-20020a9d14450000b02904ce97efee36so25291099oth.7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1sKTv9PiVeCh4lJL9T9Ku1bCSDbgIpIZR5CR9CbRKPc=;
        b=S+WFxWyj+n72lECR3JFKOcxwiuTWiooPatkbJ+lqZCjbtgvGx30fs45FZR7ykXh99K
         pnin5lnggJYRfxXnq5zijp5c9PIWg6kUTHTe9ahV0pIWOL9lB/29MOZcXhSweUDPjhDZ
         4pg8grmOr1xO4mqPv6uUfPN5IN4a1SZtINXQR8oQwICVU7aSPt2N7LLo24rQZzYXCisT
         xLE1plxrpsyl6k0VwjTZ3F1hEp/ZFU9W3xpKcW1jmRehQUv1fi1m8Fme1vgrajGgZPuf
         Io+S3Zor/RiTB5ETwD/FccyutNBwiO+HN0Hr4HlvSaXl/bJeYMY6y0BaIE8SEW6KwGQB
         LODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1sKTv9PiVeCh4lJL9T9Ku1bCSDbgIpIZR5CR9CbRKPc=;
        b=aS1UgzpW+Wdvz6W90ndVRmWTLGLSwbjpyOgoKHIc+tsOh/WEMJfdGxzkV1PkJYf2+W
         GaBEe2AEmoXUngWKy1A/gKHtTxCtU1ysZCwubeOI/MN35yZyzWXlszC5ggrJXWqcyKzL
         F7CoqpJIQZdCc599CxEGOhfqLXE3SEyfIDW+ddbmPyieJ2MKeA7v9M5tp330zlRW42XA
         +m+dVjO0iw2kuU54Qcs7CF36rA4gORgWrkWcg3moC8Ua/qaP4kSGRN6Bq/5cmhZEoXGw
         U4JOFYmfbbsA3ln2PflTrlclJv6+48TuUPwjI/evsQA2wqZju3ZTQ32MEJTzpio+YPW6
         Pfsw==
X-Gm-Message-State: AOAM532wA+Bh7HA2OCVGt8vKM9FMk9zwVnDrywzpbR5Q4sqUABxzl9Da
        FwAuEz4LmA87S3YNdp7Nqj8=
X-Google-Smtp-Source: ABdhPJzsE/RNSAcsDE9U7XlTMNdPUD2tkoAVi88oFC66GgzjzDyHkR894/cbpB93NXJhsxyBpJjGBQ==
X-Received: by 2002:a9d:6c19:: with SMTP id f25mr2946947otq.192.1629213074881;
        Tue, 17 Aug 2021 08:11:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.6.112.214])
        by smtp.googlemail.com with ESMTPSA id q62sm515866oih.57.2021.08.17.08.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 08:11:14 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 1/3] bridge: reorder cmd line arg parsing
 to let "-c" detected as "color" option
To:     Gokul Sivakumar <gokulkumar792@gmail.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210814184727.2405108-1-gokulkumar792@gmail.com>
 <20210814184727.2405108-2-gokulkumar792@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <97b96fce-29a0-b9ab-1049-33d50de912a7@gmail.com>
Date:   Tue, 17 Aug 2021 09:11:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210814184727.2405108-2-gokulkumar792@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/21 12:47 PM, Gokul Sivakumar wrote:
> As per the man/man8/bridge.8 page, the shorthand cmd line arg "-c" can be
> used to colorize the bridge cmd output. But while parsing the args in while
> loop, matches() detects "-c" as "-compressedvlans" instead of "-color", so
> fix this by doing the check for "-color" option first before checking for
> "-compressedvlans".
> 
> Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
> ---
>  bridge/bridge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/bridge/bridge.c b/bridge/bridge.c
> index f7bfe0b5..48b0e7f8 100644
> --- a/bridge/bridge.c
> +++ b/bridge/bridge.c
> @@ -149,9 +149,9 @@ main(int argc, char **argv)
>  			NEXT_ARG();
>  			if (netns_switch(argv[1]))
>  				exit(-1);
> +		} else if (matches_color(opt, &color)) {
>  		} else if (matches(opt, "-compressvlans") == 0) {
>  			++compress_vlans;
> -		} else if (matches_color(opt, &color)) {
>  		} else if (matches(opt, "-force") == 0) {
>  			++force;
>  		} else if (matches(opt, "-json") == 0) {
> 

Another example of why matches needs to be deprecated.

Re-assigned the set to Stephen for main tree.
