Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C775674E3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiGEQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiGEQ4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:56:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC3D13CC2
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 09:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657040175; x=1688576175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SgLVkSg1BfOnrrO9133QZJcaKuW3HMP/rPFbK2pRX0Y=;
  b=TIYRPomwHGyaahWlVnJP7aoUbZKUvi3gaWxozRxi+ENFQQalKGznOYp3
   o47sQzk8QXYoa6t3AXIHG3hYJQRS2cmonDISfNofoUVBrrytvHa0KbQ+J
   bDNkX+yJ61Jfpjs84QUW/Y5A+SnUGL6v7nQoLDjQbkFCBjdF/GGrU+/1k
   fKrFua4U+SGrGficT8l75yvtr1ef2wegxjMUzoGoP9pcC3SpO/UMf0u5E
   p0mP9dVSJqsLEf0JMxx//sIE7WhEtUmXs+NXxnM2Al3EW+jNrDHqZwDgZ
   tGDT7Kpr+UpCoYhm/3AJU/9/HC3/ypjtHMglDsBxcw5SoVFFRNbV9lKMC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="266432681"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="266432681"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 09:56:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="650245261"
Received: from rumengch-mobl.ccr.corp.intel.com (HELO [10.254.212.60]) ([10.254.212.60])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 09:56:12 -0700
Message-ID: <a59209f3-9005-b9f6-6f27-e136443aa3e1@intel.com>
Date:   Wed, 6 Jul 2022 00:56:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
 <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
 <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2022 7:56 PM, Parav Pandit wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Tuesday, July 5, 2022 3:59 AM
>>
>>
>> On 7/4/2022 8:53 PM, Parav Pandit wrote:
>>>> From: Jason Wang <jasowang@redhat.com>
>>>> Sent: Monday, July 4, 2022 12:47 AM
>>>>
>>>>
>>>> 在 2022/7/2 06:02, Parav Pandit 写道:
>>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>
>>>>>> This commit adds a new vDPA netlink attribution
>>>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>>>> features
>>>>>> of vDPA devices through this new attr.
>>>>>>
>>>>>> Fixes: a64917bc2e9b vdpa: (Provide interface to read driver
>>>>>> feature)
>>>>> Missing the "" in the line.
>>>>> I reviewed the patches again.
>>>>>
>>>>> However, this is not the fix.
>>>>> A fix cannot add a new UAPI.
>>>>>
>>>>> Code is already considering negotiated driver features to return the
>>>>> device
>>>> config space.
>>>>> Hence it is fine.
>>>>>
>>>>> This patch intents to provide device features to user space.
>>>>> First what vdpa device are capable of, are already returned by
>>>>> features
>>>> attribute on the management device.
>>>>> This is done in commit [1].
>>>>>
>>>>> The only reason to have it is, when one management device indicates
>>>>> that
>>>> feature is supported, but device may end up not supporting this
>>>> feature if such feature is shared with other devices on same physical device.
>>>>> For example all VFs may not be symmetric after large number of them
>>>>> are
>>>> in use. In such case features bit of management device can differ
>>>> (more
>>>> features) than the vdpa device of this VF.
>>>>> Hence, showing on the device is useful.
>>>>>
>>>>> As mentioned before in V2, commit [1] has wrongly named the
>>>>> attribute to
>>>> VDPA_ATTR_DEV_SUPPORTED_FEATURES.
>>>>> It should have been,
>>>> VDPA_ATTR_DEV_MGMTDEV_SUPPORTED_FEATURES.
>>>>> Because it is in UAPI, and since we don't want to break compilation
>>>>> of iproute2, It cannot be renamed anymore.
>>>>>
>>>>> Given that, we do not want to start trend of naming device
>>>>> attributes with
>>>> additional _VDPA_ to it as done in this patch.
>>>>> Error in commit [1] was exception.
>>>>>
>>>>> Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return
>>>> for device features too.
>>>>
>>>>
>>>> This will probably break or confuse the existing userspace?
>>>>
>>> It shouldn't break, because its new attribute on the device.
>>> All attributes are per command, so old one will not be confused either.
>> A netlink attr should has its own and unique purpose, that's why we don't need
>> locks for the attrs, only one consumer and only one producer.
>> I am afraid re-using (for both management device and the vDPA device) the attr
>> VDPA_ATTR_DEV_SUPPORTED_FEATURES would lead to new race condition.
>> E.g., There are possibilities of querying FEATURES of a management device and
>> a vDPA device simultaneously, or can there be a syncing issue in a tick?
> Both can be queried simultaneously. Each will return their own feature bits using same attribute.
> It wont lead to the race.
How? It is just a piece of memory, xxxx[attr], do you see locks in 
nla_put_u64_64bit()? It is a typical
race condition, data accessed by multiple producers / consumers.
And re-use a netlink attr is really confusing.
>
>> IMHO, I don't see any advantages of re-using this attr.
> We don’t want to continue this mess of VDPA_DEV prefix for new attributes due to previous wrong naming.
as you point out before, is is a wrong naming, we can't re-nmme it 
because we don't want to break uAPI,
so there needs a new attr, if you don't like the name 
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, it is more
than welcome to suggest a new one

Thanks

