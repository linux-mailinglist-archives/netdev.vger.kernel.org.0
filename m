Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37721692624
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjBJTRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBJTRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:17:16 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038F37BFFD;
        Fri, 10 Feb 2023 11:17:15 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id p24-20020a056830131800b0068d4b30536aso1828963otq.9;
        Fri, 10 Feb 2023 11:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ6DYKUnRf2BvJitwrvxftxNENLVAP827kjQc4CoUtY=;
        b=fdVqb2hwUQlc/m9ZUVIrV6pmbnhZibkQ2U7ysVwIMPrRqPFndNxjiAmYj73XpBGuVn
         eYJGsPbEpyBLd0HqyWFNlJFTDyqnPuDLqcUe8ggkwbV3/wGAz+xEeZ6un1/PyWBMkx7U
         e/LPGHycnaJ6z3ht0b2pM0GZ63Mdw8xZ+6qb4eEWfyqsR1f8nV/Q+26+H6lRadMSUO0a
         jocZ/2Qkncq8ir91hMfvIT7Et7n4kpzcag1CWnsmWxk/mFsHXWBGe9SPJlE7rR5gyZVH
         6UEEYLIf8OdCgMUucomHAIRL2C5LMOvDAl7KNeuE2kH8mGmD6bxoRWnv2LYOCqyNWs0S
         6Dhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJ6DYKUnRf2BvJitwrvxftxNENLVAP827kjQc4CoUtY=;
        b=aJWf6O5iUOdKfEikIY8Jxl0gqAtWi9HrcEoBKEswY3KVImMRRSE9JT1KNh7zUDNpsn
         fHpxNENWW2yYKltKIsA1A/oqIust3TACWuT/EDVgs9x0rWrk7yU6wFtH6218iHtsCeNG
         tmxjd3W9D3a3dGAkqA+xPM8d/hgYs9mq3OM3fOQIuVeBEoc68UPtq0pVXJF2M84iy908
         oTTgI1kerDeVyJPQchs4RrSyjWvzA87yvVqomWIbub7/Eu9Z+QruyN4/mWIIGRo4rHQf
         j/sVTRaXPNaqFXESQKZHrb/lYLWRsp84uFFxpyW6jjD18GqEXThXCu2RCLJxirfxmz2+
         zNEA==
X-Gm-Message-State: AO0yUKXqeHPPjQ1QVVqgNWpeWYk0gVaf2HNHq+3I+qJWczFHQkO0Er6g
        xbqx2DFnUslegahC3hcTKlo=
X-Google-Smtp-Source: AK7set9lyfpUmyGz4vDvUCf6FFoxlWq8wxAHWdLJkut9mvUvTTeH3f5YgrtFDaHnZICx5Afik33WEQ==
X-Received: by 2002:a05:6830:690c:b0:68b:d30e:7a9f with SMTP id cx12-20020a056830690c00b0068bd30e7a9fmr7411124otb.28.1676056634241;
        Fri, 10 Feb 2023 11:17:14 -0800 (PST)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id v23-20020a9d5a17000000b0068bc8968753sm2310874oth.17.2023.02.10.11.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 11:17:13 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <ff977e8e-f832-d38d-a6d8-4510d08bf306@lwfinger.net>
Date:   Fri, 10 Feb 2023 13:17:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] b43legacy: Add checking for null for
 ssb_get_devtypedata(dev)
Content-Language: en-US
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20230210111228.370513-1-n.petrova@fintech.ru>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230210111228.370513-1-n.petrova@fintech.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 05:12, Natalia Petrova wrote:
> Function ssb_get_devtypedata(dev) may return null (next call
> B43legacy_WARN_ON(!wl) is used for error handling, including null-value).
> Therefore, a check is added before calling b43legacy_wireless_exit(),
> where the argument containing this value is expected to be dereferenced.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE
> 
> Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> ---
>   drivers/net/wireless/broadcom/b43legacy/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
> index 760136638a95..1ae65679d704 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/main.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/main.c
> @@ -3871,7 +3871,7 @@ static int b43legacy_probe(struct ssb_device *dev,
>   	return err;
>   
>   err_wireless_exit:
> -	if (first)
> +	if (first && wl)
>   		b43legacy_wireless_exit(dev, wl);
>   	return err;
>   }

Looks good to me.

Acked-by: Larry Finger <Larry.Finger@gmail.com>

Thanks,

Larry


