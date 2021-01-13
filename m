Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CC52F586A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbhANCTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbhAMUyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:54:54 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEE7C061786;
        Wed, 13 Jan 2021 12:52:31 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c124so2790851wma.5;
        Wed, 13 Jan 2021 12:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XzR+bZaWiVntItapmbJT7hixkAXKLBUEq7gHIsoczCo=;
        b=Dh8muhmAKWVRALQMPwOWhXVAd4O40LKtqtcoiGaw58Im+vayl6yRd3SOxBUi0aCZPp
         GYWW7ZHrnpd4gA9XUZkfMiPkhz9krKoUhUDB+25BSXZYC7prJqh6cVxhkpIHyp/7Q18N
         s6KDAdG2E/o9XNfrbefb/YSqXeGNAAsIrF3g8yotju61avWPCO/Yob+JWkzJCf/NWPxH
         mexpQ7rU5E7Kg3/10GBEzcflIdy++iJh6dbm1ptNiffnI72lp+skIcHDrURGdBTCVfIL
         LFYEmX0sohItYtHK5pn3DCMpelbz+FiKT+8I1QUXugRPLULKT/mc2uRbHSdGYcIvC7qS
         vYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XzR+bZaWiVntItapmbJT7hixkAXKLBUEq7gHIsoczCo=;
        b=Sr8XXqXD6W85XdIJHTcvqpPXMDRHjcebU+f+rmOzGvaltLerd7L6Z2AfpyaqmFhdhL
         OkBwUm2GhhRqKhiN8xEW0zCUmhZZeYUoZz0Jdw4AIYj6vRQW+jVjcHScmEvowo86Q4PM
         VpVCRiE9ABb+co+DNPbpcFrqnnOAdGOtzn56Lygt0rSSPF3B7us7TVQDEwZxHCg5xwCa
         tTdaSiOP+bcbJC98U7EXmqHc7Y44SLRS7jWnjqY6/Yyxl7x0h9WoCNK7jA/hLv6EOmaQ
         noQv7Vj4pt3FVc/VSlKI08f+wB6dY3nc/AZCpn3uU1XnXeHpZLk9XisXiD1RrRrXHH2g
         5L2g==
X-Gm-Message-State: AOAM531nuztABtYAg8WBeWpvuKO1vT7DK+PcO69rUFJVaGS/Vgb8WLj7
        HtAE6EfVwvbs2PGGzhq/At6yJXC0u7E=
X-Google-Smtp-Source: ABdhPJxkGmBTESYXWorIndm/GuiGjUhdjyALJag8TFWm+IY7xSWtIlt21TomtfAHyuWb0u90wZkehw==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr907463wml.11.1610571149816;
        Wed, 13 Jan 2021 12:52:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:391b:9f3f:c40b:cb6d? (p200300ea8f065500391b9f3fc40bcb6d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:391b:9f3f:c40b:cb6d])
        by smtp.googlemail.com with ESMTPSA id x66sm4686731wmg.26.2021.01.13.12.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 12:52:29 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210106192233.GA1329080@bjorn-Precision-5520>
 <768d90a3-93ea-1f4e-f4e0-e039933bc17b@gmail.com>
Subject: Re: [PATCH v3 1/3] PCI: Disable parity checking if broken_parity is
 set
Message-ID: <8e9c5b3a-f239-8d8d-08e5-015ec38dd3a0@gmail.com>
Date:   Wed, 13 Jan 2021 21:52:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <768d90a3-93ea-1f4e-f4e0-e039933bc17b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 20:34, Heiner Kallweit wrote:
> On 06.01.2021 20:22, Bjorn Helgaas wrote:
>> On Wed, Jan 06, 2021 at 06:50:22PM +0100, Heiner Kallweit wrote:
>>> If we know that a device has broken parity checking, then disable it.
>>> This avoids quirks like in r8169 where on the first parity error
>>> interrupt parity checking will be disabled if broken_parity_status
>>> is set. Make pci_quirk_broken_parity() public so that it can be used
>>> by platform code, e.g. for Thecus N2100.
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
>>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> This series should all go together.  Let me know if you want me to do
>> anything more (would require acks for arm and r8169, of course).
>>
> Right. For r8169 I'm the maintainer myself and agreed with Jakub that
> the r8169 patch will go through the PCI tree.
> 
> Regarding the arm/iop32x part:
> MAINTAINERS file lists Lennert as maintainer, let me add him.
> Strange thing is that the MAINTAINERS entry for arm/iop32x has no
> F entry, therefore the get_maintainers scripts will never list him
> as addressee. The script lists Russell as "odd fixer".
> @Lennert: Please provide a patch to add the missing F entry.
> 
> ARM/INTEL IOP32X ARM ARCHITECTURE
> M:	Lennert Buytenhek <kernel@wantstofly.org>
> L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> S:	Maintained
> 

Bjorn, I saw that you set the series to "not applicable". Is this because
of the missing ack for the arm part?
I checked and Lennert's last kernel contribution is from 2015. Having said
that the maintainer's entry may be outdated. Not sure who else would be
entitled to ack this patch. The change is simple enough, could you take
it w/o an ack? 
Alternatively, IIRC Russell has got such a device. Russell, would it
be possible that you test that there's still no false-positive parity
errors with this series?


> 
>>> ---
>>>  drivers/pci/quirks.c | 17 +++++++++++------
>>>  include/linux/pci.h  |  2 ++
>>>  2 files changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>>> index 653660e3b..ab54e26b8 100644
>>> --- a/drivers/pci/quirks.c
>>> +++ b/drivers/pci/quirks.c
>>> @@ -205,17 +205,22 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>>>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>>>  				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
>>>  
>>> +void pci_quirk_broken_parity(struct pci_dev *dev)
>>> +{
>>> +	u16 cmd;
>>> +
>>> +	dev->broken_parity_status = 1;	/* This device gives false positives */
>>> +	pci_read_config_word(dev, PCI_COMMAND, &cmd);
>>> +	pci_write_config_word(dev, PCI_COMMAND, cmd & ~PCI_COMMAND_PARITY);
>>> +}
>>> +
>>>  /*
>>>   * The Mellanox Tavor device gives false positive parity errors.  Mark this
>>>   * device with a broken_parity_status to allow PCI scanning code to "skip"
>>>   * this now blacklisted device.
>>>   */
>>> -static void quirk_mellanox_tavor(struct pci_dev *dev)
>>> -{
>>> -	dev->broken_parity_status = 1;	/* This device gives false positives */
>>> -}
>>> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, quirk_mellanox_tavor);
>>> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, quirk_mellanox_tavor);
>>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, pci_quirk_broken_parity);
>>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, pci_quirk_broken_parity);
>>>  
>>>  /*
>>>   * Deal with broken BIOSes that neglect to enable passive release,
>>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>>> index b32126d26..161dcc474 100644
>>> --- a/include/linux/pci.h
>>> +++ b/include/linux/pci.h
>>> @@ -1916,6 +1916,8 @@ enum pci_fixup_pass {
>>>  	pci_fixup_suspend_late,	/* pci_device_suspend_late() */
>>>  };
>>>  
>>> +void pci_quirk_broken_parity(struct pci_dev *dev);
>>> +
>>>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
>>>  #define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
>>>  				    class_shift, hook)			\
>>> -- 
>>> 2.30.0
>>>
>>>
>>>
> 

