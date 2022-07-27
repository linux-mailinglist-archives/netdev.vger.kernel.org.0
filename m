Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF885825BD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiG0Ljd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiG0LjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:39:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7816A4BD38
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 04:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658921924; x=1690457924;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BSm103/QDk8tIiaBbkJPkpOn+jK/0oZwmCPurYt2EMg=;
  b=AUe4P/Ufllv053WMfjUrcGzCZg9N1xbtb+nxyanXONgXeqElG2OfTuWB
   DBa9/0w6+1CEPYme28s1ge6YG1bN3aeQ/yHSV4o7ZzBcYOrPqgv63QkyB
   OPRtRwvqAOn3XUtmggGqMKU3BVUXR4xgEbROcxND8hcLrqrlyy2Jc3Opg
   EozRI3zczBtyqAk61hZTpaSdo5/6Jbtjnl8Fg18yuM1zifHGz9hDQpe6B
   S+aB8AUIcaI5pZtpqj8Lo2L0sY1Emjqa5HQs4ib+noGuxz0ZRkLHY+PvS
   7toVbv9RmJm/ImCfJwegsM1Zt7JYYCfazwVYp5x7M+SUJ+8sMSdPE66Ps
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="288221522"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="288221522"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:38:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="659161351"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.153]) ([10.249.171.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:38:29 -0700
Message-ID: <35d6c4e1-6d04-7e77-9060-bf7256a5b60d@intel.com>
Date:   Wed, 27 Jul 2022 19:38:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
 <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
 <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a1bb599c-63be-a85e-5cff-6eed28abd347@oracle.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <a1bb599c-63be-a85e-5cff-6eed28abd347@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 4:15 PM, Si-Wei Liu wrote:
>
>
> On 7/5/2022 4:56 AM, Parav Pandit via Virtualization wrote:
>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>> Sent: Tuesday, July 5, 2022 3:59 AM
>>>
>>>
>>> On 7/4/2022 8:53 PM, Parav Pandit wrote:
>>>>> From: Jason Wang <jasowang@redhat.com>
>>>>> Sent: Monday, July 4, 2022 12:47 AM
>>>>>
>>>>>
>>>>> 在 2022/7/2 06:02, Parav Pandit 写道:
>>>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>
>>>>>>> This commit adds a new vDPA netlink attribution
>>>>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>>>>> features
>>>>>>> of vDPA devices through this new attr.
>>>>>>>
>>>>>>> Fixes: a64917bc2e9b vdpa: (Provide interface to read driver
>>>>>>> feature)
>>>>>> Missing the "" in the line.
>>>>>> I reviewed the patches again.
>>>>>>
>>>>>> However, this is not the fix.
>>>>>> A fix cannot add a new UAPI.
>>>>>>
>>>>>> Code is already considering negotiated driver features to return the
>>>>>> device
>>>>> config space.
>>>>>> Hence it is fine.
>>>>>>
>>>>>> This patch intents to provide device features to user space.
>>>>>> First what vdpa device are capable of, are already returned by
>>>>>> features
>>>>> attribute on the management device.
>>>>>> This is done in commit [1].
>>>>>>
>>>>>> The only reason to have it is, when one management device indicates
>>>>>> that
>>>>> feature is supported, but device may end up not supporting this
>>>>> feature if such feature is shared with other devices on same 
>>>>> physical device.
>>>>>> For example all VFs may not be symmetric after large number of them
>>>>>> are
>>>>> in use. In such case features bit of management device can differ
>>>>> (more
>>>>> features) than the vdpa device of this VF.
>>>>>> Hence, showing on the device is useful.
>>>>>>
>>>>>> As mentioned before in V2, commit [1] has wrongly named the
>>>>>> attribute to
>>>>> VDPA_ATTR_DEV_SUPPORTED_FEATURES.
>>>>>> It should have been,
>>>>> VDPA_ATTR_DEV_MGMTDEV_SUPPORTED_FEATURES.
>>>>>> Because it is in UAPI, and since we don't want to break compilation
>>>>>> of iproute2, It cannot be renamed anymore.
>>>>>>
>>>>>> Given that, we do not want to start trend of naming device
>>>>>> attributes with
>>>>> additional _VDPA_ to it as done in this patch.
>>>>>> Error in commit [1] was exception.
>>>>>>
>>>>>> Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return
>>>>> for device features too.
>>>>>
>>>>>
>>>>> This will probably break or confuse the existing userspace?
>>>>>
>>>> It shouldn't break, because its new attribute on the device.
>>>> All attributes are per command, so old one will not be confused 
>>>> either.
>>> A netlink attr should has its own and unique purpose, that's why we 
>>> don't need
>>> locks for the attrs, only one consumer and only one producer.
>>> I am afraid re-using (for both management device and the vDPA 
>>> device) the attr
>>> VDPA_ATTR_DEV_SUPPORTED_FEATURES would lead to new race condition.
>>> E.g., There are possibilities of querying FEATURES of a management 
>>> device and
>>> a vDPA device simultaneously, or can there be a syncing issue in a 
>>> tick?
>> Both can be queried simultaneously. Each will return their own 
>> feature bits using same attribute.
>> It wont lead to the race.
> Agreed. Multiple userspace callers would do recv() calls on different 
> netlink sockets. Looks to me shouldn't involve any race.
oh yes, thanks for pointing this out, they are on different sockets 
belonging to different userspace programs.
>>
>>> IMHO, I don't see any advantages of re-using this attr.
>> We don’t want to continue this mess of VDPA_DEV prefix for new 
>> attributes due to previous wrong naming.
> Well, you can say it's a mess but since the attr name can be reused 
> for different command,  I didn't care that much while reviewing this. 
> Actually, it was initially named this way to show the device features 
> in "vdpa dev config ..." output, but later on it had been moved to 
> mgmtdev to show parent's capability.
yes there is a buggy commit, but we can not change it now, because we 
are not expected to break current uapi, so I think it is better to add a 
new attr, no benefits to reuse another attr.
>
> -Siwei
>> _______________________________________________
>> Virtualization mailing list
>> Virtualization@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

