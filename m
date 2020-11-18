Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8192B87E0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgKRWls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgKRWlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:41:47 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AC8C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:41:47 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 23so5053559wmg.1
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=0/oi4PHmkfW2q1I6/exKTlF9GcKFi3SECzeTrBbQebU=;
        b=jE3dK8BhvqpkqchBe/x8Sbz2gNy7Xw/JLYiS6OfA/dIkMuAnPipCzhwltMppMkUUnQ
         qrwvVCLw84xehJTDO8v6TXTb3UUJOEc5nd5XMCzcoikvi/+0WVTKMOnqJh5vIk1trMLy
         Uw8qVT8OS0rTL3L+SbZqnTGOcY/5alGARQuBxzJh7WsqcXrK5Mh7dDHCouv3uF1tObPd
         7bbOvYjlZ9mskdQPg5ikLjVM2vJPTDEPG1Hzd7PwXlyvhDLjLFCQ/B+TXKevEaTqUy4k
         25ZFoxUAeqktxTlRjXaTqX/IZgNN1F29lxTvlkYRuNaPrkN1AKSNoRSAkN+/fxtR+1Ca
         GHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=0/oi4PHmkfW2q1I6/exKTlF9GcKFi3SECzeTrBbQebU=;
        b=jEwQCYzooJZh1HXKR4+EuErK5/DgtWfBSwjrBFn4/2tpsyd3dJYuQcP16pTK3zLt13
         v2p6UKF4vybKbAFlUpe/IBsph02t7MqELthsVBbMjrA1Yd7xB2uxblaDVux1AAHNc0iS
         prRvW0Gb+XEASkHR3BFOM/2PFSKXbnX5pb8kzIhVH+eDUPAnphoxwzQnjHNP16H5QXwJ
         13Le24uoZh6a4VNicNHAvuklgDP33si6hh4ACrCcJKWAbWa9JucX3qYTG6eg1Tis2u6f
         ot0G9XJLxNbBhyQXm7RvvE7+uh7WQ+1KgHagmItxPfpxlAOFXtQQ0Ww5NPOfhJGYyKSX
         FfIQ==
X-Gm-Message-State: AOAM530PJO3SeLvd9T8hHvyaqY/NwpIoU9xzgSov3LjsyQfh2X7KGkNA
        Eb58ERArk0O3v4i9RP2woOZI+7eNTgnl+A==
X-Google-Smtp-Source: ABdhPJyCQ2Q+tc78opGlsXqh8q4kgiMu+fNBueXJBsVM8rmm7bmBB1SZhGKXNMzVPd60FOc1pQcqWQ==
X-Received: by 2002:a1c:1fcc:: with SMTP id f195mr1285555wmf.121.1605739306134;
        Wed, 18 Nov 2020 14:41:46 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:8de0:6489:28e5:f210? (p200300ea8f2328008de0648928e5f210.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8de0:6489:28e5:f210])
        by smtp.googlemail.com with ESMTPSA id k3sm15987757wrn.81.2020.11.18.14.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 14:41:45 -0800 (PST)
Subject: Re: [PATCH V1 net 2/4] net: ena: set initial DMA width to avoid intel
 iommu issue
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Shay Agroskin <shayagr@amazon.com>, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com,
        sameehj@amazon.com, ndagan@amazon.com,
        Mike Cui <mikecui@amazon.com>
References: <20201118215947.8970-1-shayagr@amazon.com>
 <20201118215947.8970-3-shayagr@amazon.com>
 <8bbad77f-03ad-b066-4715-0976141a687b@gmail.com>
Message-ID: <c477aae1-31f0-8139-28b0-950d01abd182@gmail.com>
Date:   Wed, 18 Nov 2020 23:41:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <8bbad77f-03ad-b066-4715-0976141a687b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 18.11.2020 um 23:35 schrieb Heiner Kallweit:
> Am 18.11.2020 um 22:59 schrieb Shay Agroskin:
>> The ENA driver uses the readless mechanism, which uses DMA, to find
>> out what the DMA mask is supposed to be.
>>
>> If DMA is used without setting the dma_mask first, it causes the
>> Intel IOMMU driver to think that ENA is a 32-bit device and therefore
>> disables IOMMU passthrough permanently.
>>
>> This patch sets the dma_mask to be ENA_MAX_PHYS_ADDR_SIZE_BITS=48
>> before readless initialization in
>> ena_device_init()->ena_com_mmio_reg_read_request_init(),
>> which is large enough to workaround the intel_iommu issue.
>>
>> DMA mask is set again to the correct value after it's received from the
>> device after readless is initialized.
>>
>> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
>> Signed-off-by: Mike Cui <mikecui@amazon.com>
>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>> ---
>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> index 574c2b5ba21e..854a22e692bf 100644
>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> @@ -4146,6 +4146,19 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  		return rc;
>>  	}
>>  
>> +	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "pci_set_dma_mask failed %d\n", rc);
>> +		goto err_disable_device;
>> +	}
>> +
>> +	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "err_pci_set_consistent_dma_mask failed %d\n",
>> +			rc);
>> +		goto err_disable_device;
>> +	}
>> +
>>  	pci_set_master(pdev);
>>  
>>  	ena_dev = vzalloc(sizeof(*ena_dev));
>>
> 
> The old pci_ dma wrappers are being phased out and shouldn't be used in
> new code. See e.g. e059c6f340f6 ("tulip: switch from 'pci_' to 'dma_' API").
> So better use:
> dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
> 

However instead of dev_err(&pdev->dev, ..) you could use pci_err(pdev, ..).
