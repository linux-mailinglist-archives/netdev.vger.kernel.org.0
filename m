Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1495067E190
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjA0K11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjA0K10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:27:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD26222ED;
        Fri, 27 Jan 2023 02:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674815245; x=1706351245;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AnsrmHHoBOgvGeWy5Tq/LhGIJFaTmSKx2mxuUEhkpr4=;
  b=exGL/XvKFTiLezeGpGfNcjYhLXBkv5zFPq1oWXNdo8SuWD1kx6kaLomr
   DVrJA7QVWBoALuPDzg93lxMs07WMLq6tH12SyNhKdTf8izJlMrDfp2EaI
   0r3tuYdYDYGEUE0gcvKCs7Mk6uzuBWxKspsm2KV/CjEPSujSmnEvN9BT6
   gL0jEOh600YnbnGT56rOJ45y8T2DjqKneWXjzOURaGloIsLoEwcORMgdm
   rBjBkMDcogFg+8GpFMFS99/wPSvzrOud0MPEA7wHaDsfLFO3BB+E59NXA
   O7tEOC1UQSTKnjIOqhtg0bD1W6lwqou/Jl6y95TD5DNesOppwageMIGAY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="310681204"
X-IronPort-AV: E=Sophos;i="5.97,250,1669104000"; 
   d="scan'208";a="310681204"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 02:27:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="837068002"
X-IronPort-AV: E=Sophos;i="5.97,250,1669104000"; 
   d="scan'208";a="837068002"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.102.127]) ([10.213.102.127])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 02:27:19 -0800
Message-ID: <7f5be4cd-ae84-aa24-cf8f-8261c825fafd@linux.intel.com>
Date:   Fri, 27 Jan 2023 15:57:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 net-next 3/5] net: wwan: t7xx: PCIe reset rescan
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        linux-pci@vger.kernel.org
References: <20230126152552.GA1265322@bhelgaas>
Content-Language: en-US
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <20230126152552.GA1265322@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/2023 8:55 PM, Bjorn Helgaas wrote:
> On Tue, Jan 24, 2023 at 08:45:43PM -0800, Jakub Kicinski wrote:
>> Hi Bjorn,
>>
>> any objections to the kind of shenanigans this is playing?
> 
> Yes, thanks for asking.  Drivers definitely should not have to do this
> sort of thing.
> 
>> On Sat, 21 Jan 2023 19:03:23 +0530 m.chetan.kumar@linux.intel.com wrote:
>>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>>
>>> PCI rescan module implements "rescan work queue".
>>> In firmware flashing or coredump collection procedure
>>> WWAN device is programmed to boot in fastboot mode and
>>> a work item is scheduled for removal & detection.
>>>
>>> The WWAN device is reset using APCI call as part driver
>>> removal flow. Work queue rescans pci bus at fixed interval
>>> for device detection, later when device is detect work queue
>>> exits.
> 
> I'm not sure what's going on here.  Do we need to reset the device
> when the t7xx driver is loaded so the device will load new firmware
> when it comes out of reset?

Flow is, Reset the device to get into firmware download mode then update
the firmware and later reset it to go back to normal mode.

> 
> There are a few drivers that do that, e.g., with pci_reset_function().
> 

Thanks for the suggestion.
I will explore a bit and also try to use pci_reset_function() interface 
and see if it serves the purpose.


>>> +static struct remove_rescan_context t7xx_rescan_ctx;
> 
> Apparently this only supports a single t7xx instance in a system?  Not
> good.
> 
>>> +void t7xx_pci_dev_rescan(void)
>>> +{
>>> +	struct pci_bus *b = NULL;
>>> +
>>> +	pci_lock_rescan_remove();
>>> +	while ((b = pci_find_next_bus(b)))
>>> +		pci_rescan_bus(b);
> 
> No, this driver absolutely cannot rescan and assign unassigned
> resources for all the PCI buses in the system.

T7xx device falls off the bus due to ACPI reset.
Would you please suggest how we can bring device back on the bus without 
such changes inside driver ?  Will pci_reset_function() help in this 
regard ?

If there is no alternate option, then we shall try using remove and 
rescan from user space and drop this patch.

> 
> Bjorn

-- 
Chetan
