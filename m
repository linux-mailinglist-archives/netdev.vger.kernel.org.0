Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D472E6A1ED1
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjBXPpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBXPpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:45:17 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A5A2DE44;
        Fri, 24 Feb 2023 07:45:16 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id p6-20020a4ab386000000b005252182b0e0so700136ooo.6;
        Fri, 24 Feb 2023 07:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ILHKwugsc7/PYEQypjNaQsYhip75ahfJzQbdGzXmPUU=;
        b=loQIoOKFWd6mj62nHSXA4Aa/iG2Ks4lbm0DiMKuxiajGyQ2uQgYYAGJJQk8N54AErh
         KvQCuA8oCVg0k8NP1YRgxAHJn2wsGmqccM+7ELFXjkCTnKJDNQekNLGVs3yTCp66bIEI
         hHkUG4QFB2S7w66TlbS3J5HdulTiugIwglyHjzL+EW8MHgR9HKubJTFGYbnGIRbb9DJ8
         kjAxoTjn2PA8J1oH4ACyE3UO7AkUXZFmaxxSKbyqK0Rieel2iKCvPUNrIcjrVE+fqSdt
         HDCRPSxzQRPYl7lZQGmYL64/fy4kdnzTePA/Eud4CvLoT0lMI0y3aBzcLquRBOfs3WRW
         XOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ILHKwugsc7/PYEQypjNaQsYhip75ahfJzQbdGzXmPUU=;
        b=Lhh0/f3GIsFl+U4g+RdQzA/lW4G97+9R+44xLgWcaLHkQ28wsZioEkTFt0Z/231KrN
         9A+mMGuBeOPjpmoF2gsXK12OgAXMzeyP2PhHbnW2gzKYU+GjRxhMSu9g3qFA0jO8ZO0Z
         UhHvyGcO671NGJ3NoVtgOlwN3kBcX5W9e/I2CGPCqLAuLD4+zy+xPiBvkkKuIAJg0FqX
         TIvXXYWkzmbtT/yFz1Wi0PCXqwHcg/quFatVcDTqn2RyKGrxi0BA7ncjpuRETrpdF7wG
         4ZuEM5pOauqVTL5RINidWbnrDwfctV5oCywIoCaKc0rtNrk8fxAHTxijNiS+x8lgn8U6
         HCbQ==
X-Gm-Message-State: AO0yUKVvkhLdqqKEvaD4od3rxG+kt/S20DK0oYrr74MOL0tcdYmybeO+
        h7BOhGHxkFNe4u+37xajx3k=
X-Google-Smtp-Source: AK7set8yuPgcX8PYKB0LWNL/htEJD3pWcN90mI25rMqkzn36fIgihUlhlgkDnJcOBeWG+o/fGYcWaA==
X-Received: by 2002:a4a:52c4:0:b0:51a:7af8:457b with SMTP id d187-20020a4a52c4000000b0051a7af8457bmr7276901oob.1.1677253516026;
        Fri, 24 Feb 2023 07:45:16 -0800 (PST)
Received: from [192.168.0.156] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id c201-20020a4a4fd2000000b0049fd5c02d25sm4400618oob.12.2023.02.24.07.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 07:45:15 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <dff29d82-9c4b-1933-c1c1-a3becf2a0f1f@lwfinger.net>
Date:   Fri, 24 Feb 2023 09:45:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] wifi: wext: warn about usage only once
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 06:59, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Warn only once since the ratelimit parameters are still
> allowing too many messages to happen. This will no longer
> tell you all the different processes, but still gives a
> heads-up of sorts.
> 
> Also modify the message to note that wext stops working
> for future Wi-Fi 7 hardware, this is already implemented
> in commit 4ca69027691a ("wifi: wireless: deny wireless
> extensions on MLO-capable devices") and is maybe of more
> relevance to users than the fact that we'd like to have
> wireless extensions deprecated.
> 
> The issue with Wi-Fi 7 is that you can now have multiple
> connections to the same AP, so a whole bunch of things
> now become per link rather than per netdev, which can't
> really be handled in wireless extensions.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Not really sure I see a better solution ...
> 
>   - tracking it per task would be nice in a way I guess,
>     but is also awful;
>   - adjusting the rate limit will lead us into an endless
>     bikeshedding discussion about the parameters;
>   - removing the warning will leave us with no indiciation
>     of what happens with Wi-Fi 7 hardware, although most of
>     the processes using them now (like Chrome browser??)
>     probably ignore failures from it
>   - trying to support a 30+ year old technology on modern
>     Wi-Fi 7 hardware will be "interesting" and lead to all
>     kinds of hacks there
> ---
>   net/wireless/wext-core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
> index 13a72b17248e..a125fd1fa134 100644
> --- a/net/wireless/wext-core.c
> +++ b/net/wireless/wext-core.c
> @@ -641,8 +641,8 @@ static void wireless_warn_cfg80211_wext(void)
>   {
>   	char name[sizeof(current->comm)];
>   
> -	pr_warn_ratelimited("warning: `%s' uses wireless extensions that are deprecated for modern drivers; use nl80211\n",
> -			    get_task_comm(name, current));
> +	pr_warn_once("warning: `%s' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211\n",
> +		     get_task_comm(name, current));
>   }
>   #endif
>   

Johannes,

Although this patch will stop the log spamming that I see, it will not provide 
much information upstream for fixing the problems.

Even if this patch is applied to the kernel, I plan to keep my local, once per 
task, patch so that I can keep upstream informed, and perhaps get fixes applied 
there.

Larry

