Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6504E2B9B98
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgKSTgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgKSTgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:36:38 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA881C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:36:37 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c9so8267531wml.5
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=lknzrUCAk5Msp7YC7WnSpD5mS+qkQIeeYcFnMotQIK4=;
        b=kDJy9M+SbIQJYo9RpbtEuRU4VA2M58aUuSZZwEhfmRFWWUS72WvmyttxZSG0tFrnMr
         knOy09ISy8SqUeG/tJMv1YDGW2p+M1hNB5n0d1rq3pd0sp6amRXD55n/9td0AweoGWa4
         BDJLSjvGh0XdSdMPl+aDMYsCUiRfhhhbg+Bq+ydYCQLCp5f1p47UiLYjXOsRBWuIGUlX
         IzPzi1qQLs94UKAFjAKadlA6rI+WAkL5SXxsc0PvPqoUzMk4DIzWv8ppGghTVn1ndv22
         ER9S/9dHZUfylrm3OJduYyD8kXdnpb1L+wqbQFDywxfTrvzt//oAkK4yXsRPpZrbd0v5
         9ikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=lknzrUCAk5Msp7YC7WnSpD5mS+qkQIeeYcFnMotQIK4=;
        b=dXMUFpsn353/tYkiLF0np6dmUtu/uYpBPjxYCmVj5e6LVJ4s70u0tgdoTMCCa6sHyQ
         akjyLQjPemtXj1nFktAxzJPAc7DYAuRqibvSrdNezA2K0XoO0b0HixO/ohoNu4I3Mj58
         J6A70ng5jQs80nefrpxVxqkTYzVtvixF6aM8LAsqxU+10uQn9RbVO+moIEoZZ0S/PrOf
         wtI5/LLVpPW4/zNXQBPf1bvORA0CLIVlsLQ/bkDnYMhBfZS//b/g7+A+/Al6/P+FSm9v
         8yDJDtgf1THKIlNcP9vN15tuVBcFx7qfeNPcV73w3fwVs3xIK8qYthsxtijeV7viFE73
         JkoA==
X-Gm-Message-State: AOAM530Ly/yh7Hckt6qrVlmETcftZtl8PzjRkoRhQpqo2R+Bir1fW88E
        8t8DCPw5v/Z8agwLgBkfmaI=
X-Google-Smtp-Source: ABdhPJwvMKYLAJA0PbqESH9gMsbv5E2p9KVRknCB6vC8M3xdvdHKh93IEanarsPqQRoAoMWtVYFA1g==
X-Received: by 2002:a7b:c349:: with SMTP id l9mr6500454wmj.129.1605814596547;
        Thu, 19 Nov 2020 11:36:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617? (p200300ea8f2328006d7c9ea3dfaad617.dip0.t-ipconnect.de. [2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617])
        by smtp.googlemail.com with ESMTPSA id y20sm1288327wma.15.2020.11.19.11.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 11:36:36 -0800 (PST)
Subject: Re: [PATCH V1 net 2/4] net: ena: set initial DMA width to avoid intel
 iommu issue
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, sameehj@amazon.com,
        ndagan@amazon.com, Mike Cui <mikecui@amazon.com>
References: <20201118215947.8970-1-shayagr@amazon.com>
 <20201118215947.8970-3-shayagr@amazon.com>
 <8bbad77f-03ad-b066-4715-0976141a687b@gmail.com>
 <c477aae1-31f0-8139-28b0-950d01abd182@gmail.com>
 <pj41zltutlnojd.fsf@u68c7b5b1d2d758.ant.amazon.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4fb1eb78-3746-752c-a38d-25783f674b26@gmail.com>
Date:   Thu, 19 Nov 2020 20:36:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <pj41zltutlnojd.fsf@u68c7b5b1d2d758.ant.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 19.11.2020 um 20:18 schrieb Shay Agroskin:
> 
> Heiner Kallweit <hkallweit1@gmail.com> writes:
> 
>> Am 18.11.2020 um 23:35 schrieb Heiner Kallweit:
>>> Am 18.11.2020 um 22:59 schrieb Shay Agroskin:
>>>> The ENA driver uses the readless mechanism, which uses DMA, to find
>>>> out what the DMA mask is supposed to be.
>>>>
>>>> If DMA is used without setting the dma_mask first, it causes the
>>>> Intel IOMMU driver to think that ENA is a 32-bit device and therefore
>>>> disables IOMMU passthrough permanently.
>>>>
>>>> This patch sets the dma_mask to be ENA_MAX_PHYS_ADDR_SIZE_BITS=48
>>>> before readless initialization in
>>>> ena_device_init()->ena_com_mmio_reg_read_request_init(),
>>>> which is large enough to workaround the intel_iommu issue.
>>>>
>>>> DMA mask is set again to the correct value after it's received from the
>>>> device after readless is initialized.
>>>>
>>>> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
>>>> Signed-off-by: Mike Cui <mikecui@amazon.com>
>>>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>>>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>>>> ---
>>>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 13  +++++++++++++
>>>>  1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>>> index 574c2b5ba21e..854a22e692bf 100644
>>>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>>> @@ -4146,6 +4146,19 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>          return rc;
>>>>      }
>>>>  
>>>> +    rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
>>>> +    if (rc) {
>>>> +        dev_err(&pdev->dev, "pci_set_dma_mask failed %d\n", rc);
>>>> +        goto err_disable_device;
>>>> +    }
>>>> +
>>>> +    rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
>>>> +    if (rc) {
>>>> +        dev_err(&pdev->dev, "err_pci_set_consistent_dma_mask failed %d\n",
>>>> +            rc);
>>>> +        goto err_disable_device;
>>>> +    }
>>>> +
>>>>      pci_set_master(pdev);
>>>>  
>>>>      ena_dev = vzalloc(sizeof(*ena_dev));
>>>>
>>>
>>> The old pci_ dma wrappers are being phased out and shouldn't be used in
>>> new code. See e.g. e059c6f340f6 ("tulip: switch from 'pci_' to 'dma_' API").
>>> So better use:
>>> dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
> 
> Thank you for reviewing these patches. We will switch to using dma_set_...() instead
> 
>>>
>>
>> However instead of dev_err(&pdev->dev, ..) you could use pci_err(pdev, ..).
> 
> I see that pci_err evaluates to dev_err. While I see how using pci_* log function helps code readability, I prefer using
> dev_err here to keep the code consistent with the rest of the driver. We'll discuss changing all log functions in future patches to net-next if that's okay.
> 
The comment was just meant to make you aware of pci_err(), there's no need
to switch to it.
