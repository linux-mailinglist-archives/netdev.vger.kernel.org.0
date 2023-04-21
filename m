Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790E26EB483
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 00:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbjDUWPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 18:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjDUWOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 18:14:53 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384B8198B;
        Fri, 21 Apr 2023 15:14:22 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-545d82e1a1bso775317eaf.2;
        Fri, 21 Apr 2023 15:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682115261; x=1684707261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=43vS9Y9SxuHB8qIZkacOVEQ5kGycu1Gw9o9cTnjmisU=;
        b=blXUUO2nxUafWxpOZPEJusnDdC3YW964eDPfNn0gIkagxyQbHT6GIMQtTPtRmomCRU
         amm4THGe+EZubWQdzCjqG/2alIA6aSHe/aGhBb49AW8KH78Yni+E67bDG71j2HVpez0P
         OWKYKarqGQJya12oiVoj0aSRQODWPx5glSQAVrwrmiUF2sQr1YOFoLQI80pTEPiYw6mI
         3lR4l2lplibt7ZsAyU4IlYRG6ddbBMEzV8vVoB7nPVUaseA1dIyly6F5KRRt1t2UomyZ
         5sledeO6WnTuFGbjKbrRwyzU5rxJbknM8KJdCzp26VIpw+2MyFb9kFxRxkTDvMjsEXQ+
         is4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682115261; x=1684707261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=43vS9Y9SxuHB8qIZkacOVEQ5kGycu1Gw9o9cTnjmisU=;
        b=XMo+uNdVWYT5NAA/Sz0cTdVs08nzkh8RELw90eKkya9U/ABg+LXNT8xh1f366PmLc0
         k9KnzwQXFV3/G2WQHFTRLaEAiKduBCnoc3E8Py+vP9iAyKpamnPKb4UZnqG3DX+O4mU0
         osK7I/KQt2qOXy3HwfwMGNftXG0x1f7EOLOK8481gs86DhGwOgEjbIYNLlU3GxpKjOs7
         nelp8J7f+mEbMtnD9dkbHt9MuU+O/HdoL5zE/hUZeBSaLbv1Q29vweK6HH2TBg8GmK8v
         XkBO8VsqHazX/g2nOqMJHfCjjx3xQLXQ9x6nrFL/cl8rN3V7NUZYbBMuhXovmtNORYZV
         WhYg==
X-Gm-Message-State: AAQBX9db0+Oro6Cc97b2eXCIMt+zHYqjLMN3iEcvYW3IzxZDoLA3+4ef
        wPJPh+YlbHxtv+UXVvorBHM=
X-Google-Smtp-Source: AKy350aFIbs8T0WhQr+wXwjG2BRSCFKbA93BIe1GzhEkniAo+/ROudi5dT+Up1bYUDAOpw7Fgw13GQ==
X-Received: by 2002:a05:6870:8308:b0:16e:92d2:e810 with SMTP id p8-20020a056870830800b0016e92d2e810mr4628550oae.53.1682115261049;
        Fri, 21 Apr 2023 15:14:21 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id ec8-20020a0568708c0800b00183f77dcdadsm2181557oab.33.2023.04.21.15.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 15:14:20 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <95cff855-cb12-cf66-888f-b296a712d37d@lwfinger.net>
Date:   Fri, 21 Apr 2023 17:14:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] b43legacy: Add checking for null for
 ssb_get_devtypedata(dev)
Content-Language: en-US
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        Natalia Petrova <n.petrova@fintech.ru>
References: <20230418142918.70510-1-n.zhandarovich@fintech.ru>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230418142918.70510-1-n.zhandarovich@fintech.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/23 09:29, Nikita Zhandarovich wrote:
> Since second call of ssb_get_devtypedata() may fail as well as the
> first one, the NULL return value in 'wl' will be later dereferenced in
> calls to b43legacy_one_core_attach() and schedule_work().
> 
> Instead of merely warning about this failure with
> B43legacy_WARN_ON(), properly return with error to avoid any further
> NULL pointer dereferences.
> 
> Found by Linux Verification Center (linuxtesting.org) with static
> analysis tool SVACE.
> 
> Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
> Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
> ---
> v2: fix issues with overlooked null-ptr-dereferences pointed out by
> Simon Horman <simon.horman@corigine.com>
> Link: https://lore.kernel.org/all/Y+eb9mZntfe6rO3v@corigine.com/
> 
>   drivers/net/wireless/broadcom/b43legacy/main.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
> index 760136638a95..5a706dd0b1a4 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/main.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/main.c
> @@ -3857,7 +3857,11 @@ static int b43legacy_probe(struct ssb_device *dev,
>   		if (err)
>   			goto out;
>   		wl = ssb_get_devtypedata(dev);
> -		B43legacy_WARN_ON(!wl);
> +		if (!wl) {
> +			B43legacy_WARN_ON(!wl);
> +			err = -ENODEV;
> +			goto out;
> +		}
>   	}
>   	err = b43legacy_one_core_attach(dev, wl);
>   	if (err)

I do not recall seeing v1. One additional nitpick: The latest convention would 
have the subject as "wifi: b43legacy:...". Kalle may be able to fix this on 
merging, but it not, a v3 might be required. Otherwise, the patch is good.

Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry
