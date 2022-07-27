Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD9A581EB4
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 06:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbiG0EZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 00:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240355AbiG0EZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 00:25:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8718D3CBE1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 21:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658895901; x=1690431901;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ykXuGN9tXfR1GYX24SXU1dIc//I/xeev2072U9Lh8e0=;
  b=dhhIXJuhyjf7GuvMmduDJEJ6MEbPUBGrJu9XUu1M0UW53QG+Pm+FtFvR
   fg/zGsbxfeMofjGlPjt9BVyA8hUl5e16A494Kf+a9a9s2VaVV08zyDMzz
   8rl7E/v2q5do+KD6Pzhj3C8af5bT+1XKOILk4OpI2fS7slEMf/Vi6E0n6
   8qWQVECJEmykgHcnhCQYxO3QowoFGmciuuCEwfF0mVaSq/BUU4EJj2xJ7
   jfEoMe2T0a84VxP484aolOvwb5RDlvm5/5pmFZ+mzMaiz0uJdSTfifNrI
   vbPFqRRYs6eHb25hJeFLewOpHLn6zq7wxbgQJ9NhSoGkt1TIUf+Ij2ugl
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="267907752"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="267907752"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 21:25:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="659017249"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.153]) ([10.249.171.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 21:24:58 -0700
Message-ID: <5518a485-1ced-ec8f-9817-4303b0117f80@intel.com>
Date:   Wed, 27 Jul 2022 12:24:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
 <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 11:47 AM, Parav Pandit wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Tuesday, July 26, 2022 10:53 PM
>>
>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Tuesday, July 26, 2022 10:15 PM
>>>>
>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>>>> When the user space which invokes netlink commands, detects that
>>>> _MQ
>>>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
>>>>>> I think the kernel module have all necessary information and it is
>>>>>> the only one which have precise information of a device, so it
>>>>>> should answer precisely than let the user space guess. The kernel
>>>>>> module should be reliable than stay silent, leave the question to
>>>>>> the user space
>>>> tool.
>>>>> Kernel is reliable. It doesn’t expose a config space field if the
>>>>> field doesn’t
>>>> exist regardless of field should have default or no default.
>>>> so when you know it is one queue pair, you should answer one, not try
>>>> to guess.
>>>>> User space should not guess either. User space gets to see if _MQ
>>>> present/not present. If _MQ present than get reliable data from kernel.
>>>>> If _MQ not present, it means this device has one VQ pair.
>>>> it is still a guess, right? And all user space tools implemented this
>>>> feature need to guess
>>> No. it is not a guess.
>>> It is explicitly checking the _MQ feature and deriving the value.
>>> The code you proposed will be present in the user space.
>>> It will be uniform for _MQ and 10 other features that are present now and
>> in the future.
>> MQ and other features like RSS are different. If there is no _RSS_XX, there
>> are no attributes like max_rss_key_size, and there is not a default value.
>> But for MQ, we know it has to be 1 wihtout _MQ.
> "we" = user space.
> To keep the consistency among all the config space fields.
The user space tools asks for the number of vq pairs, not whether the 
device has _MQ.
_MQ and _RSS are not the same kind of concepts, as we have discussed above.
You have pointed out the logic: If there is _MQ, kernel answers 
max_vq_paris, if no _MQ, num_vq_paris=1.

So as MST pointed out, implementing this in kernel space can make our 
life easier, once for all.
>
>>> For feature X, kernel reports default and for feature Y, kernel skip
>> reporting it, because there is no default. <- This is what we are trying to
>> avoid here.
>> Kernel reports one queue pair because there is actually one.

