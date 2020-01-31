Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D6614ECB5
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgAaMsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:48:52 -0500
Received: from foss.arm.com ([217.140.110.172]:35040 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgAaMsw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 07:48:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D63991063;
        Fri, 31 Jan 2020 04:48:50 -0800 (PST)
Received: from [192.168.1.123] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A9573F67D;
        Fri, 31 Jan 2020 04:48:46 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
To:     Jon Nettleton <jon@solid-run.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
Date:   Fri, 31 Jan 2020 12:48:48 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-31 12:28 pm, Jon Nettleton wrote:
> On Fri, Jan 31, 2020 at 1:02 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>>
>> On Fri, 31 Jan 2020 at 12:06, Marc Zyngier <maz@kernel.org> wrote:
>>>
>>> On 2020-01-31 10:35, Makarand Pawagi wrote:
>>>>> -----Original Message-----
>>>>> From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>>>>> Sent: Tuesday, January 28, 2020 4:39 PM
>>>>> To: Makarand Pawagi <makarand.pawagi@nxp.com>
>>>>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
>>>>> kernel@lists.infradead.org; linux-acpi@vger.kernel.org;
>>>>> linux@armlinux.org.uk;
>>>>> jon@solid-run.com; Cristi Sovaiala <cristian.sovaiala@nxp.com>;
>>>>> Laurentiu
>>>>> Tudor <laurentiu.tudor@nxp.com>; Ioana Ciornei
>>>>> <ioana.ciornei@nxp.com>;
>>>>> Varun Sethi <V.Sethi@nxp.com>; Calvin Johnson
>>>>> <calvin.johnson@nxp.com>;
>>>>> Pankaj Bansal <pankaj.bansal@nxp.com>; guohanjun@huawei.com;
>>>>> sudeep.holla@arm.com; rjw@rjwysocki.net; lenb@kernel.org;
>>>>> stuyoder@gmail.com; tglx@linutronix.de; jason@lakedaemon.net;
>>>>> maz@kernel.org; shameerali.kolothum.thodi@huawei.com; will@kernel.org;
>>>>> robin.murphy@arm.com; nleeder@codeaurora.org
>>>>> Subject: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
>>>>>
>>>>> Caution: EXT Email
>>>>>
>>>>> On Tue, Jan 28, 2020 at 01:38:45PM +0530, Makarand Pawagi wrote:
>>>>>> ACPI support is added in the fsl-mc driver. Driver will parse MC DSDT
>>>>>> table to extract memory and other resorces.
>>>>>>
>>>>>> Interrupt (GIC ITS) information will be extracted from MADT table by
>>>>>> drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c.
>>>>>>
>>>>>> IORT table will be parsed to configure DMA.
>>>>>>
>>>>>> Signed-off-by: Makarand Pawagi <makarand.pawagi@nxp.com>
>>>>>> ---
>>>>>>   drivers/acpi/arm64/iort.c                   | 53 +++++++++++++++++++++
>>>>>>   drivers/bus/fsl-mc/dprc-driver.c            |  3 +-
>>>>>>   drivers/bus/fsl-mc/fsl-mc-bus.c             | 48 +++++++++++++------
>>>>>>   drivers/bus/fsl-mc/fsl-mc-msi.c             | 10 +++-
>>>>>>   drivers/bus/fsl-mc/fsl-mc-private.h         |  4 +-
>>>>>>   drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c | 71
>>>>> ++++++++++++++++++++++++++++-
>>>>>>   include/linux/acpi_iort.h                   |  5 ++
>>>>>>   7 files changed, 174 insertions(+), 20 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
>>>>>> index 33f7198..beb9cd5 100644
>>>>>> --- a/drivers/acpi/arm64/iort.c
>>>>>> +++ b/drivers/acpi/arm64/iort.c
>>>>>> @@ -15,6 +15,7 @@
>>>>>>   #include <linux/kernel.h>
>>>>>>   #include <linux/list.h>
>>>>>>   #include <linux/pci.h>
>>>>>> +#include <linux/fsl/mc.h>
>>>>>>   #include <linux/platform_device.h>
>>>>>>   #include <linux/slab.h>
>>>>>>
>>>>>> @@ -622,6 +623,29 @@ static int iort_dev_find_its_id(struct device
>>>>>> *dev, u32 req_id,  }
>>>>>>
>>>>>>   /**
>>>>>> + * iort_get_fsl_mc_device_domain() - Find MSI domain related to a
>>>>>> +device
>>>>>> + * @dev: The device.
>>>>>> + * @mc_icid: ICID for the fsl_mc device.
>>>>>> + *
>>>>>> + * Returns: the MSI domain for this device, NULL otherwise  */ struct
>>>>>> +irq_domain *iort_get_fsl_mc_device_domain(struct device *dev,
>>>>>> +                                                     u32 mc_icid) {
>>>>>> +     struct fwnode_handle *handle;
>>>>>> +     int its_id;
>>>>>> +
>>>>>> +     if (iort_dev_find_its_id(dev, mc_icid, 0, &its_id))
>>>>>> +             return NULL;
>>>>>> +
>>>>>> +     handle = iort_find_domain_token(its_id);
>>>>>> +     if (!handle)
>>>>>> +             return NULL;
>>>>>> +
>>>>>> +     return irq_find_matching_fwnode(handle, DOMAIN_BUS_FSL_MC_MSI);
>>>>>> +}
>>>>>
>>>>> NAK
>>>>>
>>>>> I am not willing to take platform specific code in the generic IORT
>>>>> layer.
>>>>>
>>>>> ACPI on ARM64 works on platforms that comply with SBSA/SBBR
>>>>> guidelines:
>>>>>
>>>>>
>>>>> https://developer.arm.com/architectures/platform-design/server-systems
>>>>>
>>>>> Deviating from those requires butchering ACPI specifications (ie IORT)
>>>>> and
>>>>> related kernel code which goes totally against what ACPI is meant for
>>>>> on ARM64
>>>>> systems, so there is no upstream pathway for this code I am afraid.
>>>>>
>>>> Reason of adding this platform specific function in the generic IORT
>>>> layer is
>>>> That iort_get_device_domain() only deals with PCI bus
>>>> (DOMAIN_BUS_PCI_MSI).
>>>>
>>>> fsl-mc objects when probed, need to find irq_domain which is associated
>>>> with
>>>> the fsl-mc bus (DOMAIN_BUS_FSL_MC_MSI). It will not be possible to do
>>>> that
>>>> if we do not add this function because there are no other suitable APIs
>>>> exported
>>>> by IORT layer to do the job.
>>>
>>> I think we all understood the patch. What both Lorenzo and myself are
>>> saying is
>>> that we do not want non-PCI support in IORT.
>>>
>>
>> IORT supports platform devices (aka named components) as well, and
>> there is some support for platform MSIs in the GIC layer.
>>
>> So it may be possible to hide your exotic bus from the OS entirely,
>> and make the firmware instantiate a DSDT with device objects and
>> associated IORT nodes that describe whatever lives on that bus as
>> named components.
>>
>> That way, you will not have to change the OS at all, so your hardware
>> will not only be supported in linux v5.7+, it will also be supported
>> by OSes that commercial distro vendors are shipping today. *That* is
>> the whole point of using ACPI.
>>
>> If you are going to bother and modify the OS, you lose this advantage,
>> and ACPI gives you no benefit over DT at all.
> 
> You beat me to it, but thanks for the clarification Ard.  No where in
> the SBSA spec that I have read does it state that only PCIe devices
> are supported by the SMMU.  It uses PCIe devices as an example, but
> the SMMU section is very generic in term and only says "devices".
> 
> I feel the SBSA omission of SerDes best practices is an oversight in
> the standard and something that probably needs to be revisited.
> Forcing high speed networking interfaces to be hung off a bus just for
> the sake of having a "standard" PCIe interface seems like a step
> backward in this regard.  I would much rather have the Spec include a
> common standard that could be exposed in a consistent manner.  But
> this is a conversation for a different place.

Just to clarify further, it's not about serdes or high-speed networking 
per se - describing a fixed-function network adapter as a named 
component is entirely within scope. The issue is when the hardware is 
merely a pool of accelerator components that can be dynamically 
configured at runtime into something that looks like one or more 
'virtual' network adapters - there is no standard interface for *that* 
for SBSA to consider.

Robin.

> 
> I will work with NXP and find a better way to implement this.
> 
> -Jon
> 
