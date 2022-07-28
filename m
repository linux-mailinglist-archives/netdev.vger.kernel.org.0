Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC575837B4
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiG1DrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiG1DrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:47:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA0CCE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 20:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658980018; x=1690516018;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lP61Cf5svNuSgbvVW3mkJXEGsverSiGYJJMQODFGN2A=;
  b=d0H56rZvpY35VfbVq9Qey9mDNjL3VWTkYMncNn5dDno2v2SE2Rsf5plC
   Fa/uCXOQaGiZs5a/0A+NMy4PiRXzAngr5iMSG8wNhPOsMpZIgac2p7NdJ
   e7iJzpQGWxxrKUtH6PZCt59vso1wU1WTketShaHD/dBOULf4mZPxU6SUs
   YXKVlcBpyvS7e4qHLnthVnwhygjk6gvgivJTstcpe3ZYiPKPwY/2HIaQM
   nLVjbIYSbdlb9xP9x2yWGWYkzygTN0/tU+y/iPpA1hJ44kbpHZ3xSWH5I
   ugLqgl2IyLpt3BUyMYciIh1go1fbd+LmG4s3PznWPXv90WlHAI1TAncC8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="285960197"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="285960197"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 20:46:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="628674001"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.28.79]) ([10.255.28.79])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 20:46:55 -0700
Message-ID: <459524bc-0e21-422b-31c1-39745fd25fac@intel.com>
Date:   Thu, 28 Jul 2022 11:46:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
 <20220727050222-mutt-send-email-mst@kernel.org>
 <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
 <20220727114419-mutt-send-email-mst@kernel.org>
 <CACGkMEv80RTtuyw5RtwgTHUphS1s2oTeb94tc6Tx7LbJWKsEBw@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEv80RTtuyw5RtwgTHUphS1s2oTeb94tc6Tx7LbJWKsEBw@mail.gmail.com>
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



On 7/28/2022 9:21 AM, Jason Wang wrote:
> On Wed, Jul 27, 2022 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Wed, Jul 27, 2022 at 05:50:59PM +0800, Jason Wang wrote:
>>> On Wed, Jul 27, 2022 at 5:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>> On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
>>>>> On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>> Sent: Tuesday, July 26, 2022 10:53 PM
>>>>>>>>
>>>>>>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
>>>>>>>>>>
>>>>>>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>>>>>>>>>> When the user space which invokes netlink commands, detects that
>>>>>>>>>> _MQ
>>>>>>>>>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
>>>>>>>>>>>> I think the kernel module have all necessary information and it is
>>>>>>>>>>>> the only one which have precise information of a device, so it
>>>>>>>>>>>> should answer precisely than let the user space guess. The kernel
>>>>>>>>>>>> module should be reliable than stay silent, leave the question to
>>>>>>>>>>>> the user space
>>>>>>>>>> tool.
>>>>>>>>>>> Kernel is reliable. It doesn’t expose a config space field if the
>>>>>>>>>>> field doesn’t
>>>>>>>>>> exist regardless of field should have default or no default.
>>>>>>>>>> so when you know it is one queue pair, you should answer one, not try
>>>>>>>>>> to guess.
>>>>>>>>>>> User space should not guess either. User space gets to see if _MQ
>>>>>>>>>> present/not present. If _MQ present than get reliable data from kernel.
>>>>>>>>>>> If _MQ not present, it means this device has one VQ pair.
>>>>>>>>>> it is still a guess, right? And all user space tools implemented this
>>>>>>>>>> feature need to guess
>>>>>>>>> No. it is not a guess.
>>>>>>>>> It is explicitly checking the _MQ feature and deriving the value.
>>>>>>>>> The code you proposed will be present in the user space.
>>>>>>>>> It will be uniform for _MQ and 10 other features that are present now and
>>>>>>>> in the future.
>>>>>>>> MQ and other features like RSS are different. If there is no _RSS_XX, there
>>>>>>>> are no attributes like max_rss_key_size, and there is not a default value.
>>>>>>>> But for MQ, we know it has to be 1 wihtout _MQ.
>>>>>>> "we" = user space.
>>>>>>> To keep the consistency among all the config space fields.
>>>>>> Actually I looked and the code some more and I'm puzzled:
>>>>>>
>>>>>>
>>>>>>          struct virtio_net_config config = {};
>>>>>>          u64 features;
>>>>>>          u16 val_u16;
>>>>>>
>>>>>>          vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>>
>>>>>>          if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
>>>>>>                      config.mac))
>>>>>>                  return -EMSGSIZE;
>>>>>>
>>>>>>
>>>>>> Mac returned even without VIRTIO_NET_F_MAC
>>>>>>
>>>>>>
>>>>>>          val_u16 = le16_to_cpu(config.status);
>>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>>                  return -EMSGSIZE;
>>>>>>
>>>>>>
>>>>>> status returned even without VIRTIO_NET_F_STATUS
>>>>>>
>>>>>>          val_u16 = le16_to_cpu(config.mtu);
>>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>>                  return -EMSGSIZE;
>>>>>>
>>>>>>
>>>>>> MTU returned even without VIRTIO_NET_F_MTU
>>>>>>
>>>>>>
>>>>>> What's going on here?
>>>>> Probably too late to fix, but this should be fine as long as all
>>>>> parents support STATUS/MTU/MAC.
>>>> Why is this too late to fix.
>>> If we make this conditional on the features. This may break the
>>> userspace that always expects VDPA_ATTR_DEV_NET_CFG_MTU?
>>>
>>> Thanks
>> Well only on devices without MTU. I'm saying said userspace
>> was reading trash on such devices anyway.
> It depends on the parent actually. For example, mlx5 query the lower
> mtu unconditionally:
>
>          err = query_mtu(mdev, &mtu);
>          if (err)
>                  goto err_alloc;
>
>          ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, mtu);
>
> Supporting MTU features seems to be a must for real hardware.
> Otherwise the driver may not work correctly.
>
>> We don't generally maintain bug for bug compatiblity on a whim,
>> only if userspace is actually known to break if we fix a bug.
>   So I think it should be fine to make this conditional then we should
> have a consistent handling of other fields like MQ.
For some fields that have a default value, like MQ =1, we can return the 
default value.
For other fields without a default value, like MAC, we return nothing.

Does this sounds good? So, for MTU, if without _F_MTU, I think we can 
return 1500 by default.

Thanks,
Zhu Lingshan
>
> Thanks
>
>>
>>>>> I wonder if we can add a check in the core and fail the device
>>>>> registration in this case.
>>>>>
>>>>> Thanks
>>>>>
>>>>>>
>>>>>> --
>>>>>> MST
>>>>>>

