Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E460398D82
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhFBO61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:58:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhFBO60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622645802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMcD5cH8Gq97lrhqQCtDsFyiGiLKX1rySB5M/G3UShE=;
        b=NolTLwC7aFbQFLnktO1a+lUgeGx14Ltl5h+A1zLx6Jme7AL4BO9cncqsJZ7+afhGmVOTAI
        OhVE0OJsKVozYiEUlElqReY2z2MvN2WtdL/pynIt6nthClD9iGtZHy2v1vae2qSfJd+Osh
        D/Au77DlOUNNPKcImPg3rLTfu7DpNuo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-WCzaXDY5P1m6kg7oH-K6iA-1; Wed, 02 Jun 2021 10:56:40 -0400
X-MC-Unique: WCzaXDY5P1m6kg7oH-K6iA-1
Received: by mail-ed1-f69.google.com with SMTP id s18-20020a0564020372b029038febc2d475so1580472edw.3
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 07:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TMcD5cH8Gq97lrhqQCtDsFyiGiLKX1rySB5M/G3UShE=;
        b=bw4iJsO3RPuXDDOcnyQtTocaruEZOvOlsb3sacpam8k4zqs9poUFrG/sk5HaXXLJdy
         73m5wBhPlNc5UjCU2yg2xTWSdB7YL5eH7OZyRHxOjpzUraKshbbfLMaUrqU01UDMIPQj
         65/YgCGTfborCvPelDQl11LwniiXuctYJApZ96pybVlgj72iKyF5EN5atnKrKwudSmR6
         4HIIFqDZ2+BjwtzPFewne08xd7L6AVHNG5ZUtY1JIgHcyzojgVlgfRDOb3kNTfU6k6Nc
         xDs52axIFj1JyJEGDU3xwGVEwV5AoCXyp09oSHl512QDyFB48k0m6hiIGxRdhjrOskBz
         HfcA==
X-Gm-Message-State: AOAM532xfv58tTn8HReAEPrJYii+cf6fxi9joKZRRmvJNou+oRYhLQw/
        IfV/fC5SbVByGf8rg4LqjoQgjW6gp+Xc/AHUXaN0lsayVHemY/9MFNL5opOer/FoRxb+U+hRX/F
        8B7e35i98aXbir+5i
X-Received: by 2002:aa7:cd19:: with SMTP id b25mr37414310edw.84.1622645799651;
        Wed, 02 Jun 2021 07:56:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxETIGO2DZMJnum6q9KmB/yfISXhRFopOOUID+RlpBdT/IOOqIC9wTBVDUx7nYRfzZeiS6/GA==
X-Received: by 2002:aa7:cd19:: with SMTP id b25mr37414281edw.84.1622645799426;
        Wed, 02 Jun 2021 07:56:39 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id w14sm115661edj.6.2021.06.02.07.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 07:56:39 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Delete second brcm folder hierarchy
To:     matthias.bgg@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        netdev@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, Amar Shankar <amsr@cypress.com>,
        ivan.ivanov@suse.com, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Wright Feng <wright.feng@infineon.com>,
        Remi Depommier <rde@setrix.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>, dmueller@suse.de,
        Matthias Brugger <mbrugger@suse.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20210602144305.4481-1-matthias.bgg@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <be57da0c-bb2a-787b-caa2-843f7110c109@redhat.com>
Date:   Wed, 2 Jun 2021 16:56:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210602144305.4481-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 6/2/21 4:43 PM, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> BRCMF_FW_DEFAULT_PATH already defines the brcm folder, delete the second
> folder to match with Linux firmware repository layout.
> 
> Fixes: 75729e110e68 ("brcmfmac: expose firmware config files through modinfo")
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> 
> ---
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 16ed325795a8..b8788d7090a4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -626,8 +626,8 @@ BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>  BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>  
>  /* firmware config files */
> -MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-sdio.*.txt");
> -MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-pcie.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
>  
>  static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>  	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
> 

