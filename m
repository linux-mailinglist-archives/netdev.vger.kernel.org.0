Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF974314054
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhBHUXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbhBHUW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:22:26 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3454AC061786;
        Mon,  8 Feb 2021 12:21:44 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id g10so18793784wrx.1;
        Mon, 08 Feb 2021 12:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vtCMCN6heQ0ZaJ85S8b5oAfnL6kyt6McH4Z8RZ7mgLA=;
        b=vKTRu6fjJjSTc+uIjmdl+uP8zSuI9QBmP9EYRhGl526AfX8yqjgt3RSvZMQ1MMx+J6
         UhFsNavUilJwc09MBpP6SBT2GcC0DTbOT/5j2d564VZP7QHi4M7koYHxtbyvbjSYE+nt
         fTd8CmTNvBgBSO/nfz9bG/KV9xxpHZwe1T2s+yh4BesunYWSvmo83XxT7qILRdHvgTCC
         kTOI0iCXa74hkRUDKRqO1rkT6DgM9fRtkugq2Nb8znCM1637TqqpylgX2U8u17wlE9Zv
         Cp/p5mdu9LC/MVxks1mVi1cwvbkIs6d2q4t3IrJ1OQK68klrWBq2f/Df/g7IE7jJBRbp
         HyAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vtCMCN6heQ0ZaJ85S8b5oAfnL6kyt6McH4Z8RZ7mgLA=;
        b=BvuoKpo9v5sh3SVGY/FuxnytYIbcPrRSw0Ud96cZYlZnbW/c+CmAA5d/fCDZgtzXmq
         EVYZEDP8kzZ2204mVEybB/ensPCVmHF4Y7aknpXFd8GnFr9R9KzZy4HhgPwpj/WJ8lsv
         ys/mFvPMRz9Cqw6hMfIlmUC6rE7fROV+3Jge5vU7GoyShdwFXjaUXMtbY86c1f2eqn5v
         4TwG0AVaBJF0r8FTLoDJFhH29PeAuFNpYWp5mm6SZ+8y70ZvH8Xhx2AVnCvgdKaUDXN0
         nN38CmE3NgO+89GxC6UHGp+gMe6e6cI11Cl0b+gVJ8g5ZSm4CD7i1rwbo0lHBEOjN+t0
         CwDw==
X-Gm-Message-State: AOAM530kHk5KJA72NlZAFat4Txe6flBgSKd1g+1B5SRhFJb9lTm8evA6
        df+IswulWYAut6zCtcZ/jtFr3ylCLWKKuQ==
X-Google-Smtp-Source: ABdhPJw17hMAqllGiRC4rR6/pMULDn8Fe03uwYTnQJ8eAURYu62GC1p561PNOroqLn0Q09KzDCWyLw==
X-Received: by 2002:adf:f512:: with SMTP id q18mr21539601wro.55.1612815702601;
        Mon, 08 Feb 2021 12:21:42 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:f9e7:a381:9de9:80df? (p200300ea8f1fad00f9e7a3819de980df.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:f9e7:a381:9de9:80df])
        by smtp.googlemail.com with ESMTPSA id a9sm16550077wrn.60.2021.02.08.12.21.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 12:21:42 -0800 (PST)
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Casey Leedom <leedom@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210205214621.GA198699@bjorn-Precision-5520>
 <6d05f72b-9a61-6da8-e70e-d4b3cdf3ca28@gmail.com>
 <20210208194740.GA24818@chelsio.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH resend net-next v2 2/3] PCI/VPD: Change Chelsio T4 quirk
 to provide access to full virtual address space
Message-ID: <62621fec-8967-597d-359e-caf12d4ec3b3@gmail.com>
Date:   Mon, 8 Feb 2021 21:21:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210208194740.GA24818@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.02.2021 20:47, Rahul Lakkireddy wrote:
> On Friday, February 02/05/21, 2021 at 23:31:24 +0100, Heiner Kallweit wrote:
>> On 05.02.2021 22:46, Bjorn Helgaas wrote:
>>> [+cc Casey, Rahul]
>>>
>>> On Fri, Feb 05, 2021 at 08:29:45PM +0100, Heiner Kallweit wrote:
>>>> cxgb4 uses the full VPD address space for accessing its EEPROM (with some
>>>> mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
>>>> VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
>>>> Having official (structured) and inofficial (unstructured) VPD data
>>>> violates the PCI spec, let's set VPD len according to all data that can be
>>>> accessed via PCI VPD access, no matter of its structure.
>>>
>>> s/inofficial/unofficial/
>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> ---
>>>>  drivers/pci/vpd.c | 7 +++----
>>>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
>>>> index 7915d10f9..06a7954d0 100644
>>>> --- a/drivers/pci/vpd.c
>>>> +++ b/drivers/pci/vpd.c
>>>> @@ -633,9 +633,8 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>>>>  	/*
>>>>  	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
>>>>  	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
>>>> -	 * later based adapter, the special VPD is at offset 0x400 for the
>>>> -	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
>>>> -	 * Capabilities).  The PCI VPD Access core routines will normally
>>>> +	 * later based adapter, provide access to the full virtual EEPROM
>>>> +	 * address space. The PCI VPD Access core routines will normally
>>>>  	 * compute the size of the VPD by parsing the VPD Data Structure at
>>>>  	 * offset 0x000.  This will result in silent failures when attempting
>>>>  	 * to accesses these other VPD areas which are beyond those computed
>>>> @@ -644,7 +643,7 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>>>>  	if (chip == 0x0 && prod >= 0x20)
>>>>  		pci_set_vpd_size(dev, 8192);
>>>>  	else if (chip >= 0x4 && func < 0x8)
>>>> -		pci_set_vpd_size(dev, 2048);
>>>> +		pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);
>>>
>>> This code was added by 7dcf688d4c78 ("PCI/cxgb4: Extend T3 PCI quirk
>>> to T4+ devices") [1].  Unfortunately that commit doesn't really have
>>> the details about what it fixes, other than the silent failures it
>>> mentions in the comment.
>>>
>>> Some devices hang if we try to read at the wrong VPD address, and this
>>> can be done via the sysfs "vpd" file.  Can you expand the commit log
>>> with an argument for why it is always safe to set the size to
>>> PCI_VPD_MAX_SIZE for these devices?
>>>
>>
>> Seeing t4_eeprom_ptov() there is data at the end of the VPD address
>> space, but there may be gaps in between. I don't have test hw,
>> therefore it would be good if Chelsio could confirm that accessing
>> any address in the VPD address space (32K) is ok. If a VPD address
>> isn't backed by EEPROM, it should return 0x00 or 0xff, and not hang
>> the device.
>>
> 
> We've tested the patches on T5 adapter. Although there are no crashes
> seen, the 32K VPD read from sysfs at certain chunks are getting wrapped
> around and overwritten. We're still analyzing this.
> 
>>> The fact that cudbg_collect_vpd_data() fiddles around with
>>> pci_set_vpd_size() suggests to me that there is *some* problem with
>>> reading parts of the VPD.  Otherwise, why would they bother?
>>>
>>> 940c9c458866 ("cxgb4: collect vpd info directly from hardware") [2]
>>> added the pci_set_vpd_size() usage, but doesn't say why it's needed.
>>> Maybe Rahul will remember?
>>>
> 
> If firmware has crashed, then it's not possible to collect the VPD info
> from firmware. So, the VPD info is fetched from EEPROM instead, which
> is unfortunately outside the VPD size of the PF.
> 
>>
>> In addition we have cb92148b58a4 ("PCI: Add pci_set_vpd_size() to set
>> VPD size"). To me it seems the VPD size quirks and this commit
>> try to achieve the same: allow to override the autodetected VPD len
>>
>> The quirk mechanism is well established, and if possible I'd like
>> to get rid of pci_set_vpd_size(). I don't like the idea that the
>> PCI core exposes API calls for accessing a proprietary VPD data
>> format of one specific vendor (cxgb4 is the only user of
>> pci_set_vpd_size()).
>>
> 
> There seems to be a way to get the Serial Configuration Version from
> some internal registers. I will send the patch soon. It should remove
> the call to pci_set_vpd_size() from cudbg_lib.c.
> 
Great, this would be the best solution. Then we can get rid of
pci_set_vpd_size() w/o impact on what is exposed via sysfs.

So for now I'll drop patches 2 and 3 and will resend patch 1
as a single patch. 

> Thanks,
> Rahul
> 
Heiner

>>> Bjorn
>>>
>>> [1] https://git.kernel.org/linus/7dcf688d4c78
>>> [2] https://git.kernel.org/linus/940c9c458866
>>>
>>>>  }
>>>>  
>>>>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
>>>> -- 
>>>> 2.30.0
>>>>
>>>>
>>>>
>>

