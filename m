Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD5C2241AA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgGQRVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:21:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:22814 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgGQRVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 13:21:25 -0400
IronPort-SDR: 9lAoy/jO9vNg6lHb7gPgTGVFHtDcKboggP/O6fT7QkVvYu3Ha+mGsF9mGvHipjjyb1+AKGKul8
 cOFfJbn0uPJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="151015421"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="151015421"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 10:21:24 -0700
IronPort-SDR: GEkwdjtfR1h1VNY6Z8O+cbRVYBLKGSZdCnQkLTyrLI8XKMpQb0Al2Fwxfpbv9oVKLvVbl7E/Yy
 RyaeyXPu0FAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="326903323"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.94.160]) ([10.212.94.160])
  by orsmga007.jf.intel.com with ESMTP; 17 Jul 2020 10:21:24 -0700
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
To:     Jakub Kicinski <kubakici@wp.pl>, Tom Herbert <tom@herbertland.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
 <20200709212652.2785924-7-jacob.e.keller@intel.com>
 <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
 <20200710132516.24994a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0a12dbf7-58be-b0ad-53d7-61748b081b38@intel.com>
 <4c6a39f4-5ff2-b889-086a-f7c99990bd4c@intel.com>
 <20200715162329.4224fa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d8f88c91-57fa-9ca4-1838-5f63b6613c59@intel.com>
 <58840317-e818-af52-352a-19008b89bee7@intel.com>
 <20200716144208.4e602320@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2ce3eb56-69e3-91fe-96a2-e5e538846e9f@intel.com>
 <20200716151833.3b21d277@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <f8723b99-f514-7433-98de-1940dbe5bf8f@intel.com>
Date:   Fri, 17 Jul 2020 10:21:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716151833.3b21d277@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 3:18 PM, Jakub Kicinski wrote:
> On Thu, 16 Jul 2020 14:52:15 -0700 Jacob Keller wrote:
>> On 7/16/2020 2:42 PM, Jakub Kicinski wrote:
>>> Sorry but I'm still not 100% sure of what the use for this option is
>>> beyond an OEM. Is it possible to reset the VPD, board serial, MAC
>>> address etc. while flashing a FW image downloaded from a support site?
>>> Would that mean that if I flash a rack with one FW image all NICs will
>>> start reporting the same serial numbers and use the same MACs?
>>
>> I think the intent here is for OEMs which would generate/customize the
>> images, though I've also been told it may be useful to get a card out of
>> some situation where firmware preservation was broken.. (No, I don't
>> really have more details on what specifically the situation might be).
>> Obviously in most update cases I don't think we expect this to be used.
> 
> What I'm getting at is that this seems to inherently require a special
> FW image which will carry unique IDs, custom-selected for a particular
> board. So I was hoping we can infer the setting from the image being
> flashed. But perhaps that's risky.
> 


Hmm. I don't think we have any obvious way to tell this.

> Let's make sure the description of the option captures the fact that
> this is mostly useful in manufacturing and otherwise very rarely needed.
> 

Sure. I'll try to make that clear in the documentation and in the naming.

>>>> d) if we need it, a "default" that would be the current behavior of
>>>> doing whatever the driver default is? (since it's not clear to me what
>>>> other implementations do but perhaps they all behavior as either
>>>> "nothing" or "all"?  
>>>
>>> As a user I'd expect "nothing" to be the default. Same as your OS
>>> update does not wipe out your settings. I think it's also better 
>>> if the default is decided by Linux, not the drivers.
>>
>> Right, but I wasn't sure what other drivers/devices implement today and
>> didn't want  to end up in a "well we don't behave that way so you just
>> changed our behavior"..? Hmm. If they all behave this way today then
>> it's fine to make "nothing" the default and modify all implementations
>> to reject other options.
> 
> Understood. Let's make things clear in the submission and CC
> maintainers of all drivers which implement devlink flashing today.
> Let them complain. If we're too cautious we'll never arrive on sane
> defaults.

Yep.

I hope to have this out today, I got sidetracked yesterday.

Regards,
Jake
