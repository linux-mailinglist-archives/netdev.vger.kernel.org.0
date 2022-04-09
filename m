Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40B54FA927
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbiDIPMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 11:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbiDIPMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 11:12:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E87329A7
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 08:10:08 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id c64so998047edf.11
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 08:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7y2cVxHEzoCrOiJ5sN1pOk1AlLueO0oSPtWNPgRs8l4=;
        b=j33HbECkTOUchjYxpDTeMKLNDbEqcPTIyh7VK9Wk99RV2ziRLjmHN22EO75/h7mZ4q
         4dPm773YVzjdzuiPExStUOGD9YdV4RA/JRMRj8wNzIWb0mZ26hfm3uTsAWx9sjbPjVJE
         V2BCldjq+h1pOlRQKHJ87mCXBOBVmXuPimeCLPATrUvEiQ1k/XD4DSNTKQH79NMZpCdG
         zywN4az6IdJH/pZkVyXBzNoLwZ9JkPsjH+VC7wt/UFVBKryCqnzH87YI5wiUEh2q/EbW
         LRmbLalZHWh4b711BuUAGhn5BuGpKEzWykyRtYZVSwc3zTcX1/c5MeAcN85MNMJMTC4D
         VEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7y2cVxHEzoCrOiJ5sN1pOk1AlLueO0oSPtWNPgRs8l4=;
        b=gbStuoowZFdxiy3U+aCyMUCB/Ul2Hw8avsX13+PpPbz4s1SViVhVniTQVW8lvj1WVj
         JMBodzrIQcSIwgUsdjED11amu9VmFHZFc4Zye8u2Z4jLmNbnOGM68zw0Hw8rwHd0Nkvw
         imZB2KYw9PqNcK+KbYb7rxJVjRNO54RJdOj6tFt8N1Tl+2kH+BnDD8h7sjWEFCxi+9p5
         cF8rBGS6nEKuhqeUCGFdiBiujzRpVFDlOL+f4Y+QUwbW7/jUhNimSCTPevypmTX4+G0Z
         aMg33RD3DuH1QDiQEJ4j3OnrTSZD5ysuqYr/WoyspOH/zYE4mIOdkklKljq96CQ355a8
         obuQ==
X-Gm-Message-State: AOAM532gA9HzisKrDGjC21fAZCvN4pvi3HGXnxzKLwmkixyqhe10PEz7
        /PTbeonQ58A+g+03iphbqL6Dn/QCHjrCGwrg
X-Google-Smtp-Source: ABdhPJyOrHt83rUxND2YU3l83Y2eFK8l1xUSr+GW0m9DW2zmer53k6W/9VLPeOzn+KBG2m2Lks9XWQ==
X-Received: by 2002:a05:6402:22a5:b0:41c:c4ca:f19e with SMTP id cx5-20020a05640222a500b0041cc4caf19emr24243770edb.237.1649517007055;
        Sat, 09 Apr 2022 08:10:07 -0700 (PDT)
Received: from [192.168.0.188] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm5503567ejb.143.2022.04.09.08.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Apr 2022 08:10:06 -0700 (PDT)
Message-ID: <7d3a5a6b-9772-a52a-fd18-2e07a8832e91@linaro.org>
Date:   Sat, 9 Apr 2022 17:10:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: nfc: nfcmrvl: fix UAF bug in
 nfcmrvl_nci_unregister_dev()
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, alexander.deucher@amd.com,
        gregkh@linuxfoundation.org, davem@davemloft.net
References: <20220409135854.33333-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220409135854.33333-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/04/2022 15:58, Duoming Zhou wrote:
> There is a potential UAF bug in nfcmrvl usb driver between
> unregister and resume operation.
> 
> The race that cause that UAF can be shown as below:
> 
>    (FREE)                   |      (USE)
>                             | nfcmrvl_resume
>                             |  nfcmrvl_submit_bulk_urb
>                             |   nfcmrvl_bulk_complete
>                             |    nfcmrvl_nci_recv_frame
>                             |     nfcmrvl_fw_dnld_recv_frame
>                             |      skb_queue_tail
> nfcmrvl_disconnect          |
>  nfcmrvl_nci_unregister_dev |
>   nfcmrvl_fw_dnld_deinit    |      ...
>    destroy_workqueue //(1)  |
>    ...                      |      queue_work //(2)
> 
> When nfcmrvl usb driver is resuming, we detach the device.
> The workqueue is destroyed in position (1), but it will be
> latter used in position (2), which leads to data race.

I miss here something. How can you queue work on a destroyed workqueue?
When workqueue is destroyed, no more work should be executed. Unless you
mean the case that draining the work (during destroying, not after)
causes the (2) to happen?

> This patch reorders the nfcmrvl_fw_dnld_deinit after
> nci_unregister_device in order to prevent UAF. Because
> nci_unregister_device will not return until finish all
> operations from upper layer.
> 
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  drivers/nfc/nfcmrvl/main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
> index 2fcf545012b..5ed17b23ee8 100644
> --- a/drivers/nfc/nfcmrvl/main.c
> +++ b/drivers/nfc/nfcmrvl/main.c
> @@ -186,12 +186,11 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
>  	if (priv->ndev->nfc_dev->fw_download_in_progress)
>  		nfcmrvl_fw_dnld_abort(priv);
>  
> -	nfcmrvl_fw_dnld_deinit(priv);
> -
>  	if (gpio_is_valid(priv->config.reset_n_io))
>  		gpio_free(priv->config.reset_n_io);
>  
>  	nci_unregister_device(ndev);
> +	nfcmrvl_fw_dnld_deinit(priv);

The new order matches reverse-probe, so actually makes sense.

>  	nci_free_device(ndev);
>  	kfree(priv);
>  }


Best regards,
Krzysztof
