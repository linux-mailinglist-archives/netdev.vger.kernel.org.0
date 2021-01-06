Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD82EC3FD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbhAFTfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbhAFTfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:35:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51640C06134D;
        Wed,  6 Jan 2021 11:34:29 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a12so3432475wrv.8;
        Wed, 06 Jan 2021 11:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j/tPa+TosF4s6ZeUcfX5xJrxDDEIBvCx2esSOFMWJPA=;
        b=kOhlrN3fzZP4EarkM5nObQu4al+WTx+UiL1xrbrx7/1xiNxyF+qDN+khSBv8s9icg0
         fI/KhHZur15sGBNvSExuj2u2z3/6bZEkasKt+4UjSvXx7Bbh0BNzq/XdbM/72anjs4UL
         84dhK2Gs7v4wN+iAfwISVQUihD0Q/ack4MPGiDs5QHLdvCxBXtzBx4Oyo9qi0xSV72TP
         RHHt27mef5qb6UXx8iTFhQotn8I5qaGtAliy4hGHm/OwStWBjZjxlc6qhcWSGw1TqjEY
         vluJJXPcdws9/QBOqDyjkKuZ568kvCCa6qlOuSigDEgvZ7L0NQntrA0XbPdOHqKjHBTu
         iStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j/tPa+TosF4s6ZeUcfX5xJrxDDEIBvCx2esSOFMWJPA=;
        b=RNkpepe8bPkrUuH+2d6Syc4D7Rvi/4V4LL4oQiP7gZDbMVRNr7DixzBrfi00bpNiu3
         0j1TiaPqvH0df/HbNK/k0Rq+lCo6awCjKoHzPMWZ6AwUULzAVcgdp2GeqzvToCDlfRmu
         s7ntZZHdg6VoZNJzB8kERpoIIscm5QOy8f92cTqMD+Wx6m00rZOO3MF2s6IbgO9ElJdJ
         V8c40yV+aA6U/MfsqMlxH7WQC2/oe+IAd+cv9jl/W0jjACrqVH6wEMehiKXx/ljM7nvp
         bhe+rW7EIoYnQkPwbKC3FDXkyOQLe8UrxenUkZ2OLfjaZXKWBTLeYcuJ1EXelN54oCau
         9DFw==
X-Gm-Message-State: AOAM533m9oewzPnOItbixkuJTKeuamUJUEbXeOd10Da1Us4sZNW6EUEW
        tp02aagdtsm38m/Xo2TGh3vcaw8bcb4=
X-Google-Smtp-Source: ABdhPJyAzCNiTuU1Yx4cF42lFYMKljtIPeDqI2NtDSj1UO4tBbTJIw9rIm8uvHroLFRpnaBN4vFOfg==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr5696020wrt.425.1609961667725;
        Wed, 06 Jan 2021 11:34:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id 125sm4359403wmc.27.2021.01.06.11.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 11:34:27 -0800 (PST)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 1/3] PCI: Disable parity checking if broken_parity is
 set
Message-ID: <768d90a3-93ea-1f4e-f4e0-e039933bc17b@gmail.com>
Date:   Wed, 6 Jan 2021 20:34:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106192233.GA1329080@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 20:22, Bjorn Helgaas wrote:
> On Wed, Jan 06, 2021 at 06:50:22PM +0100, Heiner Kallweit wrote:
>> If we know that a device has broken parity checking, then disable it.
>> This avoids quirks like in r8169 where on the first parity error
>> interrupt parity checking will be disabled if broken_parity_status
>> is set. Make pci_quirk_broken_parity() public so that it can be used
>> by platform code, e.g. for Thecus N2100.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> This series should all go together.  Let me know if you want me to do
> anything more (would require acks for arm and r8169, of course).
> 
Right. For r8169 I'm the maintainer myself and agreed with Jakub that
the r8169 patch will go through the PCI tree.

Regarding the arm/iop32x part:
MAINTAINERS file lists Lennert as maintainer, let me add him.
Strange thing is that the MAINTAINERS entry for arm/iop32x has no
F entry, therefore the get_maintainers scripts will never list him
as addressee. The script lists Russell as "odd fixer".
@Lennert: Please provide a patch to add the missing F entry.

ARM/INTEL IOP32X ARM ARCHITECTURE
M:	Lennert Buytenhek <kernel@wantstofly.org>
L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
S:	Maintained


>> ---
>>  drivers/pci/quirks.c | 17 +++++++++++------
>>  include/linux/pci.h  |  2 ++
>>  2 files changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 653660e3b..ab54e26b8 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -205,17 +205,22 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>>  				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
>>  
>> +void pci_quirk_broken_parity(struct pci_dev *dev)
>> +{
>> +	u16 cmd;
>> +
>> +	dev->broken_parity_status = 1;	/* This device gives false positives */
>> +	pci_read_config_word(dev, PCI_COMMAND, &cmd);
>> +	pci_write_config_word(dev, PCI_COMMAND, cmd & ~PCI_COMMAND_PARITY);
>> +}
>> +
>>  /*
>>   * The Mellanox Tavor device gives false positive parity errors.  Mark this
>>   * device with a broken_parity_status to allow PCI scanning code to "skip"
>>   * this now blacklisted device.
>>   */
>> -static void quirk_mellanox_tavor(struct pci_dev *dev)
>> -{
>> -	dev->broken_parity_status = 1;	/* This device gives false positives */
>> -}
>> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, quirk_mellanox_tavor);
>> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, quirk_mellanox_tavor);
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, pci_quirk_broken_parity);
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, pci_quirk_broken_parity);
>>  
>>  /*
>>   * Deal with broken BIOSes that neglect to enable passive release,
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index b32126d26..161dcc474 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1916,6 +1916,8 @@ enum pci_fixup_pass {
>>  	pci_fixup_suspend_late,	/* pci_device_suspend_late() */
>>  };
>>  
>> +void pci_quirk_broken_parity(struct pci_dev *dev);
>> +
>>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
>>  #define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
>>  				    class_shift, hook)			\
>> -- 
>> 2.30.0
>>
>>
>>

