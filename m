Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2E28753E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgJHNbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:31:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:12082 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbgJHNbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 09:31:21 -0400
IronPort-SDR: 6NqxCrgQyj0ACTMO22MoiAXMFUVjKbp2KjS40bFRWwO0cP1MgxNO5CvLBVKESbLR8/T2Gh320y
 OH4R02Koe3ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="145198616"
X-IronPort-AV: E=Sophos;i="5.77,350,1596524400"; 
   d="scan'208";a="145198616"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 06:31:20 -0700
IronPort-SDR: EDWXFozQHFQugMLk+t2v3OyALx6ntuphaaBF0B3QTsIyGXiDKUwLoWCds50m5lGqyVlFEZQU9B
 zBsNczW2IK+A==
X-IronPort-AV: E=Sophos;i="5.77,350,1596524400"; 
   d="scan'208";a="528494501"
Received: from kweisner-mobl.amr.corp.intel.com (HELO [10.212.230.16]) ([10.212.230.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 06:31:18 -0700
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     Parav Pandit <parav@nvidia.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <1e2a38ac-e259-f955-07ad-602431ad354b@linux.intel.com>
Date:   Thu, 8 Oct 2020 08:29:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>>> But ... since the init() function is performing both device_init and
>>>>> device_add - it should probably be called ancillary_device_register,
>>>>> and we are back to a single exported API for both register and
>>>>> unregister.
>>>>
>>>> Kind reminder that we introduced the two functions to allow the
>>>> caller to know if it needed to free memory when initialize() fails,
>>>> and it didn't need to free memory when add() failed since
>>>> put_device() takes care of it. If you have a single init() function
>>>> it's impossible to know which behavior to select on error.
>>>>
>>>> I also have a case with SoundWire where it's nice to first
>>>> initialize, then set some data and then add.
>>>>
>>>
>>> The flow as outlined by Parav above does an initialize as the first
>>> step, so every error path out of the function has to do a
>>> put_device(), so you would never need to manually free the memory in
>> the setup function.
>>> It would be freed in the release call.
>>
>> err = ancillary_device_initialize();
>> if (err)
>> 	return ret;
>>
>> where is the put_device() here? if the release function does any sort of
>> kfree, then you'd need to do it manually in this case.
> Since device_initialize() failed, put_device() cannot be done here.
> So yes, pseudo code should have shown,
> if (err) {
> 	kfree(adev);
> 	return err;
> }

This doesn't work if the adev is part of a larger structure allocated by 
the parent, which is pretty much the intent to extent the basic bus and 
pass additional information which can be accessed with container_of().

Only the parent can do the kfree() explicitly in that case. If the 
parent relies on devm_kzalloc, this also can make the .release callback 
with no memory free required at all.

See e.g. the code I cooked for the transition of SoundWire away from 
platform devices at

https://github.com/thesofproject/linux/pull/2484/commits/d0540ae3744f3a748d49c5fe61469d82ed816981#diff-ac8eb3d3951c024f52b1d463b5317f70R305

The allocation is done on an 'ldev' which contains 'adev'.

I really don't seen how an ancillary_device_register() could model the 
different ways to allocate memory, for maximum flexibility across 
different domains it seems more relevant to keep the initialize() and 
add() APIs separate. I will accept the argument that this puts more 
responsibility on the parent, but it also provides more flexibility to 
the parent.

If we go with the suggested solution above, that already prevents 
SoundWire from using this bus. Not so good.
