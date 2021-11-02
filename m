Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B45442FC4
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhKBOIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhKBOIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:08:12 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1314C0613B9
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 07:05:34 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id b2-20020a1c8002000000b0032fb900951eso2029682wmd.4
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 07:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+IYXwWS8RTx2nLZKN578GTrttVorrBmCdGgRqqEdI34=;
        b=aDm24t85uRClN+XO1YGgcwD+8BAIZ3ICQ1+kxTfb0AC9ny1rPjXf71kfbXm7rFkw6M
         mlrAqcVe7aGX96UQRA9prWqVGWvRj+ZlyMGHS3sUa7X7015IG1Ky5fTWFVeB4fT2G4sO
         7eWEBF8QngyWKZpJzx4IXMGUX5JYeVk11faNoo34GcgiI2cQZqpLHWNIuziPzaygVoVE
         n4HaIva8ek3caSnNkpkYw6UPm5yMoq4FbYj8qAAN3fR3yhEVAJrOBHan4jMO9qpYBAS9
         9aXwFslzFJ6JLtT2+BGIOxNFDuICkdlFLtjweURXASUHpyifZ1eK1FRRXq5N59mO1pk+
         2nTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+IYXwWS8RTx2nLZKN578GTrttVorrBmCdGgRqqEdI34=;
        b=7KQNxuGAHViSPXsSSUe8fhnZx/4MZczEVi+0osdFqpMh7t7WXnzBvi5YSI2Gn/uXCG
         nFQ1+ZJcvgnBAveODROmYg5ttP1qfyAyH5xwGH04i7EwjsoXbkVtwVg7W1vk5bkgGstC
         O8c4tz7ZPBJ9zhoqE5zhW95axnKGsQTtaN3K8k5IrbGKxwwnQi1D7IZg8M5sQOQoNyM2
         lMoFf8J9Lvy3BpEDwIiLqhbot7LoH56pPmVka1yYjKbA76mrYE9nISBxszQiFOErcSQy
         5J1GQJMaqVOgdiqeVUWoaZ89iLZdd8GGaFHbfCGUTM9YuQRCt7Dxdn9qcVyln9HV8fiZ
         LTCQ==
X-Gm-Message-State: AOAM532rEY1IilFJVbgrs55aoIZFH7zdVDNN29xYDTvBe8S5Yly9yBmT
        0+hfuVivfBgrqC8m2FGy/KKeaQ==
X-Google-Smtp-Source: ABdhPJzxg0SHqhkEzFQ1UmuimY5KEsGE4OUHBHVSwXpPdDc44Og9JozAJKDqnW7UGZNY5rLd2HpfGQ==
X-Received: by 2002:a1c:a904:: with SMTP id s4mr7080812wme.163.1635861933267;
        Tue, 02 Nov 2021 07:05:33 -0700 (PDT)
Received: from [192.168.0.30] (cpc78119-cwma10-2-0-cust590.7-3.cable.virginm.net. [81.96.50.79])
        by smtp.gmail.com with ESMTPSA id z12sm12443417wrv.78.2021.11.02.07.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 07:05:32 -0700 (PDT)
Message-ID: <df3c0fd1-5ec1-5cf7-f94c-1b2db2882333@linaro.org>
Date:   Tue, 2 Nov 2021 14:05:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 00/15] create power sequencing subsystem
Content-Language: en-US
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <2h9GS3myO9uyX8sDYwU_43cDbBCW_SE1h5qolKQLKT9ZVvz0-K6z6cix50eVsgMsYLtgTLsW37DxF0lf78vxCA==@protonmail.internalid>
 <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
From:   Caleb Connolly <caleb.connolly@linaro.org>
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

On 06/10/2021 04:53, Dmitry Baryshkov wrote:
> This is a proposed power sequencer subsystem. This is a
> generification of the MMC pwrseq code. The subsystem tries to abstract
> the idea of complex power-up/power-down/reset of the devices.
> 
> The primary set of devices that promted me to create this patchset is
> the Qualcomm BT+WiFi family of chips. They reside on serial+platform
> or serial + SDIO interfaces (older generations) or on serial+PCIe (newer
> generations).  They require a set of external voltage regulators to be
> powered on and (some of them) have separate WiFi and Bluetooth enable
> GPIOs.
> 
> The major drawback for now is the lack of proper PCIe integration
> At this moment support for PCIe is hacked up to be able to test the
> PCIe part of qca6390. Proper PCIe support would require automatically
> powering up the devices before the scan basing on the proper device
> structure in the device tree. This two last patches are noted as WIP and
> are included into the patchset for the purpose of testing WiFi on newer
> chips (like qca6390/qca6391).
> 
> Changes since RFC v2:
>   - Add documentation for the pwrseq code. Document data structures,
>     macros and exported functions.
>   - Export of_pwrseq_xlate_onecell()
>   - Add separate pwrseq_set_drvdata() function to follow the typical API
>     design
>   - Remove pwrseq_get_optional()/devm_pwrseq_get_optional()
>   - Moved code to handle old mmc-pwrseq binding to the MMC patch
>   - Split of_pwrseq_xlate_onecell() support to a separate patch
> 
> Changes since RFC v1:
>   - Provider pwrseq fallback support
>   - Implement fallback support in pwrseq_qca.
>   - Mmove susclk handling to pwrseq_qca.
>   - Significantly simplify hci_qca.c changes, by dropping all legacy
>     code. Now hci_qca uses only pwrseq calls to power up/down bluetooth
>     parts of the chip.
> 
> 
> 
Tested-by: Caleb Connolly <caleb.connolly@linaro.org>
[Tested on the OnePlus 6]

-- 
Kind Regards,
Caleb (they/them)
