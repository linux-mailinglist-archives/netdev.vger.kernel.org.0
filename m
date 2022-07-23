Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF4857EF07
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 13:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbiGWL1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 07:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiGWL1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 07:27:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7CC47BB2
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 04:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658575629; x=1690111629;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=QYDTXE486QN8SmWXzw9ENizQoUKgROx4sJt4GldQmKM=;
  b=ejm4Uh4H+ECqKK6uF/2iS5nshg7V12GBaTjAjdyr71u12mzBPg5AOjF3
   DKeTc5HowUysuB9zslOlH3HYdl42z5Vd5yNbTvXNfoiBmOhv+TLI4aSdU
   Aj+YUauBhC9r4c/7K9OlWJ6JUedhCup2Nq9nFSlLnOK0pvFcW0wpRGbnE
   ex0v4UOXJj6+qm79kAZILpk7noDoEDE/jrjXK1fUX8seZhjTq16+6r/JM
   /xZTkRKZW5TV3vw8LKlv+qMBzl0yOPYKYSjUx+ko3vX1s3R28CEJnj/tB
   By/2EvdhvPUCDlmrhthbWVC58QNIcm9rUznyFu0dhF+/kHTcdpYBp7C5E
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="349160933"
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="349160933"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 04:27:08 -0700
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="657530257"
Received: from qianyuwa-mobl2.ccr.corp.intel.com (HELO [10.249.169.178]) ([10.249.169.178])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 04:27:06 -0700
Message-ID: <cbd81bad-b188-2895-4606-326eac36b02f@intel.com>
Date:   Sat, 23 Jul 2022 19:27:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
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
 <a59209f3-9005-b9f6-6f27-e136443aa3e1@intel.com>
 <PH0PR12MB54816A1864BADD420A2674E8DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
 <814143c9-b7ab-a1c7-c5e2-cff8b024fc2f@intel.com>
In-Reply-To: <814143c9-b7ab-a1c7-c5e2-cff8b024fc2f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2022 10:25 AM, Zhu, Lingshan wrote:
>
>
> On 7/6/2022 1:01 AM, Parav Pandit wrote:
>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>> Sent: Tuesday, July 5, 2022 12:56 PM
>>>> Both can be queried simultaneously. Each will return their own 
>>>> feature bits
>>> using same attribute.
>>>> It wont lead to the race.
>>> How? It is just a piece of memory, xxxx[attr], do you see locks in
>>> nla_put_u64_64bit()? It is a typical race condition, data accessed 
>>> by multiple
>>> producers / consumers.
>> No. There is no race condition in here.
>> And new attribute enum by no means avoid any race.
>>
>> Data put using nla_put cannot be accessed until they are transferred.
> How this is guaranteed? Do you see errors when calling nla_put_xxx() 
> twice?
Parav, did you miss this?
>>
>>> And re-use a netlink attr is really confusing.
>> Please put comment for this variable explaining why it is shared for 
>> the exception.
>>
>> Before that lets start, can you share a real world example of when 
>> this feature bitmap will have different value than the mgmt. device 
>> bitmap value?
> For example,
> 1. When migrate the VM to a node which has a more resourceful device. 
> If the source side device does not have MQ, RSS or TSO feature, the 
> vDPA device assigned to the VM does not
> have MQ, RSS or TSO as well. When migrating to a node which has a 
> device with MQ, RSS or TSO, to provide a consistent network device to 
> the guest, to be transparent to the guest,
> we need to mask out MQ, RSS or TSO in the vDPA device when 
> provisioning. This is an example that management device may have 
> different feature bits than the vDPA device.
>
> 2.SIOV, if a virtio device is capable of managing SIOV devices, and it 
> exposes this capability by a feature bit(Like what I am doing in the 
> "transport virtqueue"),
> we don't want the SIOV ADIs have SIOV features, so the ADIs don't have 
> SIOV feature bit.
>
> Thanks
>>
>>>>> IMHO, I don't see any advantages of re-using this attr.
>>>> We don’t want to continue this mess of VDPA_DEV prefix for new
>>> attributes due to previous wrong naming.
>>> as you point out before, is is a wrong naming, we can't re-nmme it 
>>> because
>>> we don't want to break uAPI, so there needs a new attr, if you don't 
>>> like the
>>> name VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, it is more than
>>> welcome to suggest a new one
>>>
>>> Thanks
>

