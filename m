Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF142B5B79
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgKQJBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgKQJBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:01:41 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF48C0613CF;
        Tue, 17 Nov 2020 01:01:40 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 10so2479851wml.2;
        Tue, 17 Nov 2020 01:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=5raLdf7B4TvIbmYn8Vn+fWUB4a35RkPUvlLZKikY920=;
        b=LiqIwar8Eo9wGvlsPcEOJLQfjsvLPMeDVyaOmhY3ZFODkPkfE9X5sOiJJzuZsnMK1L
         H2jHZm1Rx/Mynid4tdpWg59GEP00AiV94GS2SLmbviSuJHNKsP6ljAnUpvGMClROIHUv
         1Ap5KvWt6Rbp3PTmklkxsKQVsjnSFWUmF6a12tiLDz9CIRPZ9df+MR09R8j8EjRi6cvQ
         DERnwCwEwmLa3xthDja8zT6DQ9z4ZwtAVaBztLOvR9SXy7dp5LXYyyhPmxJJY939Rzv5
         VyBdUNZZrnKy6sz/XYDSw/YfpaPzbx5t4feKDTawJqZJJ00oprpwmmmPu23+0r1OIuGp
         tZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=5raLdf7B4TvIbmYn8Vn+fWUB4a35RkPUvlLZKikY920=;
        b=KxS3X4K155ZlXu1OgNpiU5pm/6fMR1+3gajMJOBmzVnjOn6ZeWZmlTOU7qs6TnPuEU
         BYkm5VBCbxbgSl5rkUdwuPv6eewah3b2nV895fnI/cbk8r/Fax2ApJzHiwrMGLPapRBJ
         U4lsSW78P3MNyz9uZfGmNWhKlvbYhC55SGR1ERuOcdui7P0AbFJrv5JI5i86kHpSZu3E
         Qokdct7F/XtWH7fwXDHrndd9AN31lHpfL8bdbHHNkrrVRohC05Y9IJRXwe7C+Be3k/vf
         ZxUMHj5Jo8hEvvOO465hot2xyol+KxlYBfcZWS9D1G+XFkR/RezKCBnBDF/69EQJFN9B
         Kv2Q==
X-Gm-Message-State: AOAM532yDjl7U/ra0J4kCCLFGvDEPHy7D9vgMuD1Fr6rKmGTmrEwWEBA
        q8bwtroDrD3QRWfuQ0qHDUB5YegHhUNTcw==
X-Google-Smtp-Source: ABdhPJyLHh1/PDp0wkJgvxiSn7piVBdua7eF08Px6miCKSoFgqa4v/YnhZGYEgN3npzDi4GjPMDJxA==
X-Received: by 2002:a05:600c:2949:: with SMTP id n9mr3062720wmd.29.1605603699143;
        Tue, 17 Nov 2020 01:01:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:703b:c7f4:f658:541b? (p200300ea8f232800703bc7f4f658541b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:703b:c7f4:f658:541b])
        by smtp.googlemail.com with ESMTPSA id v19sm27593925wrf.40.2020.11.17.01.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 01:01:38 -0800 (PST)
Subject: Re: [PATCH net] atl1c: fix error return code in atl1c_probe()
To:     Chris Snook <chris.snook@gmail.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, yanaijie@huawei.com,
        christophe.jaillet@wanadoo.fr, mst@redhat.com,
        Leon Romanovsky <leon@kernel.org>, jesse.brandeburg@intel.com,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
 <34800149-ce40-b993-1d82-5f26abc61b28@gmail.com>
 <CAMXMK6v+nAdcChQ4wkc8gRt6i1uwGHgnmqBvZf9k-HFmPkSWcQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7fae4733-570c-6cb1-5537-de6469afbea5@gmail.com>
Date:   Tue, 17 Nov 2020 10:01:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAMXMK6v+nAdcChQ4wkc8gRt6i1uwGHgnmqBvZf9k-HFmPkSWcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 17.11.2020 um 08:43 schrieb Chris Snook:
> The full text of the preceding comment explains the need:
> 
> /*
> * The atl1c chip can DMA to 64-bit addresses, but it uses a single
> * shared register for the high 32 bits, so only a single, aligned,
> * 4 GB physical address range can be used at a time.
> *
> * Supporting 64-bit DMA on this hardware is more trouble than it's
> * worth.  It is far easier to limit to 32-bit DMA than update
> * various kernel subsystems to support the mechanics required by a
> * fixed-high-32-bit system.
> */
> 
> Without this, we get data corruption and crashes on machines with 4 GB
> of RAM or more.
> 
> - Chris
> 
> On Mon, Nov 16, 2020 at 11:14 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Am 17.11.2020 um 03:55 schrieb Zhang Changzhong:
>>> Fix to return a negative error code from the error handling
>>> case instead of 0, as done elsewhere in this function.
>>>
>>> Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>>> ---
>>>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
>>> index 0c12cf7..3f65f2b 100644
>>> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
>>> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
>>> @@ -2543,8 +2543,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>        * various kernel subsystems to support the mechanics required by a
>>>        * fixed-high-32-bit system.
>>>        */
>>> -     if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
>>> -         (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
>>> +     err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>>
>> I wonder whether you need this call at all, because 32bit is the default.
>> See following
>>
>> "By default, the kernel assumes that your device can address 32-bits
>> of DMA addressing."
>>
>> in https://www.kernel.org/doc/Documentation/DMA-API-HOWTO.txt
>>
>>> +     if (err) {
>>>               dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
>>>               goto err_dma;
>>>       }
>>>
>>

Please don't top-post.
>From what I've seen the kernel configures 32bit as default DMA size.
See beginning of pci_device_add(), there the coherent mask is set to 32bit.

And in pci_setup_device() see the following:
  /*
         * Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
         * set this higher, assuming the system even supports it.
         */
        dev->dma_mask = 0xffffffff;


That means if you would like to use 64bit DMA then you'd need to configure this explicitly.
You could check to which mask dev->dma_mask and dev->coherent_dma_mask are set
w/o the call to dma_set_mask_and_coherent.

