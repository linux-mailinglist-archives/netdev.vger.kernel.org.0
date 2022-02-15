Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE944B6326
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiBOFwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:52:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiBOFwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:52:16 -0500
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7B87660;
        Mon, 14 Feb 2022 21:52:06 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id z22so4923802edd.1;
        Mon, 14 Feb 2022 21:52:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/nwdQqGWMuoLKw2FCtFecdNjRci4zjN8KGSxzNh0v6c=;
        b=T9ascm511ZeaXbw6JIc9vjxQ1tG9u0MyKMyb8GXPWTd2kZflSDXPw//IK/fQ2ODn4J
         K9mt6k1kc+8TG3ck1PMls6/BWSuZ3+GCmeBpPd7tDQ+4eg5QdmqaaqcHl6qs9J0Cm/1e
         FrxR+IianNGLQKyZELTz3hhMp9ZsSXxmXTjz4sAIfmUQdEm7Ss9c/niqMtdVfC2fxXuP
         i0aRNt7oGIyIJI9w9+aKynX9lle1wmF6Hf8F6mE1KQGjyB9R862b7ali73p6O6TwcgI3
         MLYjmg1BprPptT0S9b8AmZEdgrD1TfgiQBodgJHRvdfGsBUEhlr3b2gSmCLrAxdEQKoX
         ujcw==
X-Gm-Message-State: AOAM532QNTRmTVWG3jF+2ggDtExdSkUXrGcqZMpMOCMgmn0j0fw/NoDR
        CXzFNBbx8/6D3UbgnQoAwow=
X-Google-Smtp-Source: ABdhPJyojxvvk2j3yDGePKUIH/TBjPV7KtcMWADsM3HlHGLiWSq0cMw+Nou13oAjTw0kCCfQrroEZA==
X-Received: by 2002:a05:6402:354d:: with SMTP id f13mr2230789edd.289.1644904325348;
        Mon, 14 Feb 2022 21:52:05 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id h27sm2982927ejb.13.2022.02.14.21.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 21:52:04 -0800 (PST)
Message-ID: <91301fc3-e121-8f73-700b-323f7a9f4706@kernel.org>
Date:   Tue, 15 Feb 2022 06:52:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2] ath5k: use swap() to make code cleaner
Content-Language: en-US
To:     davidcomponentone@gmail.com
Cc:     mickflemm@gmail.com, mcgrof@kernel.org, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <b6931732c22b074413e63151b93cfcf3f70fcaa5.1644891799.git.yang.guang5@zte.com.cn>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <b6931732c22b074413e63151b93cfcf3f70fcaa5.1644891799.git.yang.guang5@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15. 02. 22, 3:31, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.

Ah, v2 already. Why do people tend to send versions of patches in an 
hours interval? The comment from before few minutes on v1 still holds:
 > Why don't you include that file then?

And also I commented on this very same patch sent on Nov 4 2021 (you did 
it correctly on the first attempt back then) [1]:
 > Why not just use sort() instead of the double loop?

So you even skip reviewers' comments. Not good.

[1] 
https://lore.kernel.org/all/0c3acbd4-6ab2-5cc5-6293-54e30093cce2@kernel.org/

> Reported-by: Zeal Robot <zealci@zte.com.cn>

The mailbox does not seem to exist:
550 5.1.1 User unknown id=620B3CA9.000

So it's pointless to put it here to bother everyone with undeliverable 
e-mails.

> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>
> ---
> Changes from v1->v2:
> - Fix the typo "sort" to "swap"
> 
> ---
>   drivers/net/wireless/ath/ath5k/phy.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 00f9e347d414..08dc12611f8d 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1562,16 +1562,13 @@ static s16
>   ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
>   {
>   	s16 sort[ATH5K_NF_CAL_HIST_MAX];
> -	s16 tmp;
>   	int i, j;
>   
>   	memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
>   	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
>   		for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
>   			if (sort[j] > sort[j - 1]) {
> -				tmp = sort[j];
> -				sort[j] = sort[j - 1];
> -				sort[j - 1] = tmp;
> +				swap(sort[j], sort[j - 1]);
>   			}
>   		}
>   	}

Curly braces not needed now.

regards,
-- 
js
suse labs
