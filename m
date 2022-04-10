Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A824FAD0C
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 11:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbiDJJTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 05:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbiDJJTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 05:19:20 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE9A644EF
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 02:17:08 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lc2so4633529ejb.12
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 02:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xDEG9DCGNhiyNnwqXi2PmcI0m+dQfDJLPuApPCQyOSk=;
        b=k6bi5EbhhmZe+s2cvNexUNYH6JLZDVNvtWvAK2eJyvWRJdetKPYGrC72ZRJ+54NtuR
         bFuLjaWjoSRYDN/4pKyTxqYz0OEyhPxP7/JV0OshSCSqTkSVnHo+Qo5eMdme/qih53Wn
         wXS8c3i8jkSAWaAuDSp3qJJk+ycFfV+N7DmIjtk0nnlh/kKBUswPGNGSIFCDWNeKO6G7
         5PV3UdcKWTTHH7zYHq2pvWSnR+WVMHSTyl42U2+hVBhJENDUImodcnN+SSqg44oif6BA
         YTLSVh+zQc1EbxRptj1rTQY77uJ3NYVylOBGAg3hj5NbivFLNr8ACTvbFVCir/Gs793r
         h6kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xDEG9DCGNhiyNnwqXi2PmcI0m+dQfDJLPuApPCQyOSk=;
        b=dFxT4P91ho5wmz2xuYu/CIjuaQxWdNG3R/atJuuQSnd5d2EqT55TeW0bA4qUycLdLj
         R0iDaDw4HKrzzvIxNsUlr7tIgUo17Z1Kej98m0yzqmFE5jRGyarF3ot6op5KhVaaJSBK
         oz2bfEZ0DNfH9JFpwQ7bfq3gR1KKOgEg+bhv/16LEKR7+DhsXLhvEI13amC1HBG5uPj1
         emkGyEk2ACf6Os3n8pJLVEGQvvyCdjH39dzsmN6aO/lbu4g7zAf1RHl8Jj9LMrIO4zLx
         qMu7tnGds23k+O7PH7odX73D+HulwqP7XFS1XjRwKuWesNpkIW+9c+4vtxcdjIVrOIao
         KrrQ==
X-Gm-Message-State: AOAM5335rBU6UGohD+G1iJehHGhYaXLcgJNqPTNu7YP5nIT7ioaRW3aL
        RGv/uZTGKSkUyKKKFZtZFiAK0g==
X-Google-Smtp-Source: ABdhPJwNICCSEeBnv1QZlTUkTxZ8TBi3ZAzP/YtoHyubj7NN173CbazGSMp2YwE5Rw2saQzrEiDi5w==
X-Received: by 2002:a17:907:3ea3:b0:6e6:faf5:b8e with SMTP id hs35-20020a1709073ea300b006e6faf50b8emr26411655ejc.402.1649582227019;
        Sun, 10 Apr 2022 02:17:07 -0700 (PDT)
Received: from [192.168.0.188] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7dd43000000b00419db53ae65sm13155732edw.7.2022.04.10.02.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 02:17:06 -0700 (PDT)
Message-ID: <ac86bfc6-b2ca-0e9c-9e3d-2d59c22c5c7f@linaro.org>
Date:   Sun, 10 Apr 2022 11:17:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: nfc: nfcmrvl: fix UAF bug in
 nfcmrvl_nci_unregister_dev()
Content-Language: en-US
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alexander.deucher@amd.com, gregkh@linuxfoundation.org,
        davem@davemloft.net
References: <20220409135854.33333-1-duoming@zju.edu.cn>
 <7d3a5a6b-9772-a52a-fd18-2e07a8832e91@linaro.org>
 <37334368.2629.1801298f436.Coremail.duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <37334368.2629.1801298f436.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/04/2022 10:30, duoming@zju.edu.cn wrote:

(...)

> 
>    (FREE)                   |      (USE)
>                             | nfcmrvl_resume
>                             |  nfcmrvl_submit_bulk_urb
>                             |   nfcmrvl_bulk_complete
>                             |    nfcmrvl_nci_recv_frame
>                             |     nfcmrvl_fw_dnld_recv_frame
>                             |      queue_work
>                             |       fw_dnld_rx_work
>                             |        fw_dnld_over
>                             |         release_firmware
>                             |          kfree(fw); //(1)
> nfcmrvl_disconnect          |
>  nfcmrvl_nci_unregister_dev |
>   nfcmrvl_fw_dnld_abort     |
>    fw_dnld_over             |         ...
>     if (priv->fw_dnld.fw)   |
>     release_firmware        |
>      kfree(fw); //(2)       |
>      ...                    |         fw = NULL;
> 
> When nfcmrvl usb driver is resuming, we detach the device.
> The release_firmware() will deallocate firmware in position (1),
> but firmware will be deallocate again in position (2), which
> leads to double free.

Indeed. The code looks racy. It uses the fw_download_in_progress
variable which in core is partially protected with device_lock(). Moving
code around might not solve the issue entirely because there is no
synchronization here.

> 
>>> This patch reorders the nfcmrvl_fw_dnld_deinit after
>>> nci_unregister_device in order to prevent UAF. Because
>>> nci_unregister_device will not return until finish all
>>> operations from upper layer.
>>>
>>> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
>>> ---
>>>  drivers/nfc/nfcmrvl/main.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
>>> index 2fcf545012b..5ed17b23ee8 100644
>>> --- a/drivers/nfc/nfcmrvl/main.c
>>> +++ b/drivers/nfc/nfcmrvl/main.c
>>> @@ -186,12 +186,11 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
>>>  	if (priv->ndev->nfc_dev->fw_download_in_progress)
>>>  		nfcmrvl_fw_dnld_abort(priv);
>>>  
>>> -	nfcmrvl_fw_dnld_deinit(priv);
>>> -
>>>  	if (gpio_is_valid(priv->config.reset_n_io))
>>>  		gpio_free(priv->config.reset_n_io);
>>>  
>>>  	nci_unregister_device(ndev);
>>> +	nfcmrvl_fw_dnld_deinit(priv);
>>
>> The new order matches reverse-probe, so actually makes sense.
>>
>>>  	nci_free_device(ndev);
>>>  	kfree(priv);
>>>  }
> 
> I will send "[PATCH] drivers: nfc: nfcmrvl: fix double free bug in
> nfcmrvl_nci_unregister_dev()" as soon as possible.

Thanks!


Best regards,
Krzysztof
