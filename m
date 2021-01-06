Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620362EB700
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbhAFAoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbhAFAox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:44:53 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCF6C061796;
        Tue,  5 Jan 2021 16:44:13 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 190so1116311wmz.0;
        Tue, 05 Jan 2021 16:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+aMW43IZhOweNyfQdq3RrsIez7U9DouYQFivMqkSnzQ=;
        b=AvDD6nNiGb11qb5480K59zSzTDIzPKhKEpnXc9KQu2TzJzl2ELZGRPNHJYmcetbDOi
         4pa9VHigYBATlxcYL+m+DE1mAJStRz5oOLTuQIn13SfFRILuIvR2jOjQc87iQV+f3GKe
         2ij1LIH8RNuoMC7Ng9xvnmK3F1DvdGPSfQfBrOfSPb2SCvVNwhZbocLHUkAJkNTNwmbu
         Gclpk+COgBQ60goJbw6DtC4BR5NpympUofbXEAHtC2PhsLnrTc0kUnEQMsL6tMpgrVHy
         suRXx92QUaRR3fhq856bUKw84KhG29yej5nHbrgit5dqzgVB0gw957ac07F+ZDKlIXH9
         bddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+aMW43IZhOweNyfQdq3RrsIez7U9DouYQFivMqkSnzQ=;
        b=o4L7wGdpZf9NLJ9FlDr+uSElZl2CVUnJQDqNZzttsiLhSP+a5zwhHa/SKJKfbqyfoE
         Btdva5JZ0yp5gqu6lH6DvED7Qn7kT4KGR1Ew/BZvwAAldC55NIXFwf2VO/E4yjtZ7+H5
         5WdlV6IfelDxpLF+QuvO2MXSCjo3nsZXow9Qm3UPHAKHrIw43bvb70w4tNSSrP57B5i1
         ljVv1cFB73gzwvkFPmO99QOe5gzanWmL314EhaymWHqzMQcbyS5Wsydc+CP8piw3UCPU
         feBkD+m1g2/kHKLTf2M/cycb/jiEd7O1/y88vjDxcgxXTEvmQUMa3dLcXCVYv+yYl1Lm
         CDUA==
X-Gm-Message-State: AOAM530QoA7Z/aCkU5zS7Y+svdpVJ4o/TdXO3RT+FqAso9cXKZN6+dH8
        xoydAIC91RJqktR4b+pP2WZeHCdgkjE=
X-Google-Smtp-Source: ABdhPJxFXf+WJ0i6zhYIOFZK5nMMsxVY6A7dj9zpWGlfcf6AuyDvqJIyaqZ1YzGXrNKHWzsYbgBPtg==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr1384772wml.106.1609893851768;
        Tue, 05 Jan 2021 16:44:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:303d:91bf:ac5c:51a1? (p200300ea8f065500303d91bfac5c51a1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:303d:91bf:ac5c:51a1])
        by smtp.googlemail.com with ESMTPSA id b7sm884725wrv.47.2021.01.05.16.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 16:44:10 -0800 (PST)
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210106002833.GA1286114@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
Message-ID: <9d2d3d61-8866-f7d3-09e9-a43b05128689@gmail.com>
Date:   Wed, 6 Jan 2021 01:44:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106002833.GA1286114@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 01:28, Bjorn Helgaas wrote:
> On Tue, Jan 05, 2021 at 10:42:31AM +0100, Heiner Kallweit wrote:
>> Simplify the quirk by using new PCI core function
>> pci_quirk_broken_parity(). In addition make the quirk
>> more specific, use device id 0x8169 instead of PCI_ANY_ID.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  arch/arm/mach-iop32x/n2100.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
>> index 78b9a5ee4..24c3eec46 100644
>> --- a/arch/arm/mach-iop32x/n2100.c
>> +++ b/arch/arm/mach-iop32x/n2100.c
>> @@ -122,12 +122,10 @@ static struct hw_pci n2100_pci __initdata = {
>>   */
>>  static void n2100_fixup_r8169(struct pci_dev *dev)
>>  {
>> -	if (dev->bus->number == 0 &&
>> -	    (dev->devfn == PCI_DEVFN(1, 0) ||
>> -	     dev->devfn == PCI_DEVFN(2, 0)))
>> -		dev->broken_parity_status = 1;
>> +	if (machine_is_n2100())
>> +		pci_quirk_broken_parity(dev);
> 
> Whatever "machine_is_n2100()" is (I can't find the definition), it is
> surely not equivalent to "00:01.0 || 00:02.0".  That change probably
> should be a separate patch with some explanation.
> 
The machine_is_xxx() checks are dynamically created,
see arch/arm/tools/gen-mach-types.
Slots 1 and 2 are the two network cards, both are Realtek RTL8169.
The quirk (after this patch) applies for Realtek RTL8169 devices only,
therefore we don't need the slot checks any longer.
Actually the slot checks haven't been needed even before, because
only in slots 1 and 2 are Realtek devices.

The machine type check is there to protect from (theoretical) cases
where the n2100 code (incl. the RTL8169 quirk) may be compiled in,
but the kernel is used on another machine.

> If this makes the quirk safe to use in a generic kernel, that sounds
> like a good thing.
> 
> I guess a parity problem could be the result of a defect in either the
> device (e.g., 0x8169), which would be an issue in *all* platforms, or
> a platform-specific issue in the way it's wired up.  I assume it's the
> latter because the quirk is not in drivers/pci/quirks.c.
> 
I haven't seen any other report about RTL8169 parity problems.
Therefore I also think it's platform-specific.

> Why is it safe to restrict this to device ID 0x8169?  If this is
> platform issue, it might affect any device in the slot.
> 
So far the quirk was applied for all Realtek devices.
The parity problem is limited to the two RTL8169 network cards, and there
are no other Realtek PCI devices in the system. Supposedly PCI_ANY_ID
was just used because it was less work than looking for the device id.
Functionally it's the same on this system.

>>  }
>> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, PCI_ANY_ID, n2100_fixup_r8169);
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, 0x8169, n2100_fixup_r8169);
>>  
>>  static int __init n2100_pci_init(void)
>>  {
>> -- 
>> 2.30.0
>>
>>

