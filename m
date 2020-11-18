Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A6E2B87CB
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgKRWfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRWfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:35:38 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EF9C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:35:38 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so4052469wrb.9
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=qOuMfHW9svZIKgcrVVeLX3/RrYdbFELY7o8JRKJFy/E=;
        b=AueA6R5OLwbMNFSYpOLTRIM7AkXn/r0SpKuA8SQud3MoZkvTXHbrQwvp0aqXSmeRhX
         sCBhQqIVTE8qFO0rWNkFk1XAK7ro4vHtjOPMCq4UuEevLXFVyL83TiDeLgnLHHwRj9+2
         rJ45YaO7BNeriXpVhlDbuTQmWjeZAZX/F/EAjP14uDgPxpVV/s3PMPhRkpL9N3XlAsaK
         LO+JbCckv+wU3zj0x8UTRPMOBA+MtsnVjGFdkpyi6Yw0vzc+31V85vFi8ivcgIO/JhW8
         0ZTL/Y5bLBHH4TDNc0118L8nDp1dmnEO8oxtYWZC0MLMLPuEm0qVojdyEJhSYsE8Rhoi
         phPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=qOuMfHW9svZIKgcrVVeLX3/RrYdbFELY7o8JRKJFy/E=;
        b=BeX0r0zs7GEzc2RpZkbVZw4KJMen6XGTvy3B/N3tIqGGyl0qH/wEpgqazxxz4tMK8c
         gX7Ocizp66Nu6JIBAzOS7z8jxzlv9TBeDcTtrjwA5RkhViTqWQYq3Wg1S/fbdjqV9IAx
         /IgvQpBNZN/jmWKBVpreEe5p0KT1S7nZYZoQeRBoyAKmZuJ+a9Ivo2RYqUdtTU54vxYb
         OzGMsxp/K0YjXKPUS/oADxlRciR8P5c7GZozojhywoyI5zgXvdlYb8vyxiLUVUL6e8Tz
         Exvh0jD1pxtzJV1Cwkuno2JUkIDafHYp13NNI6ZHZQ6wvIKaObUbci0NC494RfsPlL7L
         H6/A==
X-Gm-Message-State: AOAM530SHiowbF0issLbP9ZzREpoEPPt4sFSb4Gkn5R4MMZcvUuvyCaD
        UhJJeGX2ymO4IuPaMFAhfUA=
X-Google-Smtp-Source: ABdhPJwyctYd7sssViKiH24PL35LHHX9Som+U8XY59vrmcmE9/RW1a/d6hb/C1pClZe7VXyohBYMIQ==
X-Received: by 2002:a5d:670f:: with SMTP id o15mr7503200wru.204.1605738936775;
        Wed, 18 Nov 2020 14:35:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:8de0:6489:28e5:f210? (p200300ea8f2328008de0648928e5f210.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8de0:6489:28e5:f210])
        by smtp.googlemail.com with ESMTPSA id g186sm16012730wma.1.2020.11.18.14.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 14:35:36 -0800 (PST)
Subject: Re: [PATCH V1 net 2/4] net: ena: set initial DMA width to avoid intel
 iommu issue
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8bbad77f-03ad-b066-4715-0976141a687b@gmail.com>
Date:   Wed, 18 Nov 2020 23:35:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118215947.8970-3-shayagr@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 18.11.2020 um 22:59 schrieb Shay Agroskin:
> The ENA driver uses the readless mechanism, which uses DMA, to find
> out what the DMA mask is supposed to be.
> 
> If DMA is used without setting the dma_mask first, it causes the
> Intel IOMMU driver to think that ENA is a 32-bit device and therefore
> disables IOMMU passthrough permanently.
> 
> This patch sets the dma_mask to be ENA_MAX_PHYS_ADDR_SIZE_BITS=48
> before readless initialization in
> ena_device_init()->ena_com_mmio_reg_read_request_init(),
> which is large enough to workaround the intel_iommu issue.
> 
> DMA mask is set again to the correct value after it's received from the
> device after readless is initialized.
> 
> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
> Signed-off-by: Mike Cui <mikecui@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 574c2b5ba21e..854a22e692bf 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -4146,6 +4146,19 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		return rc;
>  	}
>  
> +	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
> +	if (rc) {
> +		dev_err(&pdev->dev, "pci_set_dma_mask failed %d\n", rc);
> +		goto err_disable_device;
> +	}
> +
> +	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
> +	if (rc) {
> +		dev_err(&pdev->dev, "err_pci_set_consistent_dma_mask failed %d\n",
> +			rc);
> +		goto err_disable_device;
> +	}
> +
>  	pci_set_master(pdev);
>  
>  	ena_dev = vzalloc(sizeof(*ena_dev));
> 

The old pci_ dma wrappers are being phased out and shouldn't be used in
new code. See e.g. e059c6f340f6 ("tulip: switch from 'pci_' to 'dma_' API").
So better use:
dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
