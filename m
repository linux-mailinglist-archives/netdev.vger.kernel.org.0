Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B1B572E98
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 08:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiGMG5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 02:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiGMG5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 02:57:53 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F60913D6A
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 23:57:52 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 19so12437704ljz.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 23:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LzDcCOyz/oL/Atfc+DxoSYENFDlt7iDBa7JxdWJN6Pg=;
        b=zW3XIk4xCAluS7YJYHCruLMdLmB3lr7SulMprALEQ/L7GCtEhiZ4Sttthk2ih5h1JY
         NKIkFLa6A9sPs81NC1QyKOBASgXOLdbVhcv9KTXY1kFVvCrt7htRkl8WwvnNxqFQ0im8
         m25DR6KDePb8USlq+JdTV/5QQ8wsD11IDi1BBM7aDg/SUovyyoX3LiWYZy5fxB2S1/nQ
         cE4ws5g67LxE/58IfArGC5V8IOGQ0facYLF8IDaJyMesNBh++ztrTih/Vk6RHfzcwMH1
         d/Z+rvE4SuV2lnfN+TO54XZh90iLUu/sZgMoBkBKx7YH+7k6CmvDfTpY7yWtj0tANXnX
         +JIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LzDcCOyz/oL/Atfc+DxoSYENFDlt7iDBa7JxdWJN6Pg=;
        b=Eyco9H7ITsOpOQwVbaelPIUWiCuVCCZl9Sr2TT7le8V1qoVD3dYYSJUuy8Cbmt4iQF
         pcXQbTj9PFBcs51eyC9ni53+aCaCddDKcsBdC6kHpLRZZFQpI7mM6EvOHuxFaQla6jRs
         QGmXNNPlpbUU/H6pkdjdzYfkykHelafsxmGJg1eTmVf/gyozCog4j7W06DT8j/DB6P5R
         UgxKCYaiPoiXIWb8+SZdXskXPuNYkSZ0lohjkpdLXNl4bLTFbEHhAVBzL+pih5JqQ3qa
         WrsRYpXwwK1ZMRXS0B7qL+rZHVKNhf8xIat+3mZPnBYxYKBB8LLdkZaCH1e2VO72Ch71
         H9Hw==
X-Gm-Message-State: AJIora/bs7PZnIOp0AwArqp6E9PJsehIFiSZZ77/0lKBs7Qgvkn/vacY
        7ZB8fOvIXc4nbjg4gitXl+us6KdLoLo4/w==
X-Google-Smtp-Source: AGRyM1uLh+si39qAWrmJ/KpiKy/ip5jRoTk1XpWo/Cisq6DFMkunBJGszPzlFjVI0NndiDLp+d2yMg==
X-Received: by 2002:a2e:b538:0:b0:25d:881d:a10f with SMTP id z24-20020a2eb538000000b0025d881da10fmr734625ljm.65.1657695470468;
        Tue, 12 Jul 2022 23:57:50 -0700 (PDT)
Received: from [10.0.0.8] (fwa5da9-171.bb.online.no. [88.93.169.171])
        by smtp.gmail.com with ESMTPSA id be20-20020a05651c171400b0025d86b425e7sm300131ljb.89.2022.07.12.23.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 23:57:49 -0700 (PDT)
Message-ID: <f837b69d-b212-3107-504b-b5d716ab6878@linaro.org>
Date:   Wed, 13 Jul 2022 08:57:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] NFC: nxp-nci: fix deadlock during firmware update
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20220712152554.2909224-1-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220712152554.2909224-1-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/07/2022 17:25, Michael Walle wrote:
> During firmware update, both nxp_nci_i2c_irq_thread_fn() and
> nxp_nci_fw_work() will hold the info_lock mutex and one will wait
> for the other via a completion:
> 
> nxp_nci_fw_work()
>   mutex_lock(info_lock)
>   nxp_nci_fw_send()
>     wait_for_completion(cmd_completion)
>   mutex_unlock(info_lock)
> 
> nxp_nci_i2c_irq_thread_fn()
>   mutex_lock(info_lock)
>     nxp_nci_fw_recv_frame()
>       complete(cmd_completion)
>   mutex_unlock(info_lock)
> 
> This will result in a -ETIMEDOUT error during firmware update (note
> that the wait_for_completion() above is a variant with a timeout).
> 
> Drop the lock in nxp_nci_fw_work() and instead take it after the
> work is done in nxp_nci_fw_work_complete() when the NFC controller mode
> is switched and the info structure is updated.
> 
> Fixes: dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI chips")
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/nfc/nxp-nci/firmware.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
> index 119bf305c642..6a4d4aa7239f 100644
> --- a/drivers/nfc/nxp-nci/firmware.c
> +++ b/drivers/nfc/nxp-nci/firmware.c
> @@ -54,6 +54,7 @@ void nxp_nci_fw_work_complete(struct nxp_nci_info *info, int result)
>  	struct nxp_nci_fw_info *fw_info = &info->fw_info;
>  	int r;
>  
> +	mutex_lock(&info->info_lock);
>  	if (info->phy_ops->set_mode) {
>  		r = info->phy_ops->set_mode(info->phy_id, NXP_NCI_MODE_COLD);
>  		if (r < 0 && result == 0)
> @@ -66,6 +67,7 @@ void nxp_nci_fw_work_complete(struct nxp_nci_info *info, int result)
>  		release_firmware(fw_info->fw);
>  		fw_info->fw = NULL;
>  	}
> +	mutex_unlock(&info->info_lock);
>  
>  	nfc_fw_download_done(info->ndev->nfc_dev, fw_info->name, (u32) -result);
>  }
> @@ -172,8 +174,6 @@ void nxp_nci_fw_work(struct work_struct *work)
>  	fw_info = container_of(work, struct nxp_nci_fw_info, work);
>  	info = container_of(fw_info, struct nxp_nci_info, fw_info);
>  
> -	mutex_lock(&info->info_lock);
> -

I am not sure this is correct. info_lock should protect members of info
thus also info->fw_info. By removing the mutex the protection is gone.

Unless you are sure that fw_info cannot be modified concurrently?

Best regards,
Krzysztof
