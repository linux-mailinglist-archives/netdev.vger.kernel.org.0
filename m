Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A935582017
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiG0G0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiG0G0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:26:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F4F1CFEC
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658903164; x=1690439164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gNJtEeCyrAaGczS0Y4wvzJRxruZgIrfolKBMXfos/oI=;
  b=ikQjIG3FiIS2L31VwADIJVMv8JyBfkg8Z6ul0aMxzKZdgxe4n0/lPyBN
   Sn3MnKplDWGxY8vYnB2h3GAx5LLcHc6JOeXJ7S07JbaJxWG+dip/gurRN
   npZ0GSoYx3ATwcpShMmLpuz149bhFlb8kJKpJUqcOjT4it00mxpS0+yyL
   onmQEU7li8ZWRw1m84kfPSmTauEpJxPCj1CgJBxXdjbI+9vFwfxhu4J42
   gC8eZLu8E5uDU0ZrHWaNYSFUXO8sj8iaAT3GaPs85Ik5zQJEnCHTi+l5Z
   UTch0p+o0QABlSJWXLzv+nfZvbnlMEQtIwhuWiqlznZVWEsi1dJem0gR9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="275030898"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="275030898"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 23:26:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="659057619"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.153]) ([10.249.171.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 23:26:02 -0700
Message-ID: <4925d1db-51d1-148a-72e0-2347b20e82f4@intel.com>
Date:   Wed, 27 Jul 2022 14:25:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220727015626-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 2:01 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>> Sent: Tuesday, July 26, 2022 10:53 PM
>>>
>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
>>>>>
>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>>>>> When the user space which invokes netlink commands, detects that
>>>>> _MQ
>>>>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
>>>>>>> I think the kernel module have all necessary information and it is
>>>>>>> the only one which have precise information of a device, so it
>>>>>>> should answer precisely than let the user space guess. The kernel
>>>>>>> module should be reliable than stay silent, leave the question to
>>>>>>> the user space
>>>>> tool.
>>>>>> Kernel is reliable. It doesn’t expose a config space field if the
>>>>>> field doesn’t
>>>>> exist regardless of field should have default or no default.
>>>>> so when you know it is one queue pair, you should answer one, not try
>>>>> to guess.
>>>>>> User space should not guess either. User space gets to see if _MQ
>>>>> present/not present. If _MQ present than get reliable data from kernel.
>>>>>> If _MQ not present, it means this device has one VQ pair.
>>>>> it is still a guess, right? And all user space tools implemented this
>>>>> feature need to guess
>>>> No. it is not a guess.
>>>> It is explicitly checking the _MQ feature and deriving the value.
>>>> The code you proposed will be present in the user space.
>>>> It will be uniform for _MQ and 10 other features that are present now and
>>> in the future.
>>> MQ and other features like RSS are different. If there is no _RSS_XX, there
>>> are no attributes like max_rss_key_size, and there is not a default value.
>>> But for MQ, we know it has to be 1 wihtout _MQ.
>> "we" = user space.
>> To keep the consistency among all the config space fields.
> Actually I looked and the code some more and I'm puzzled:
I can submit a fix in my next version patch for these issue.
>
>
> 	struct virtio_net_config config = {};
> 	u64 features;
> 	u16 val_u16;
>
> 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>
> 	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> 		    config.mac))
> 		return -EMSGSIZE;
>
>
> Mac returned even without VIRTIO_NET_F_MAC
if no VIRTIO_NET_F_MAC, we should not nla_put 
VDPA_ATTR_DEV_NET_CFG_MAC_ADDR, the spec says the driver should generate 
a random mac.
>
>
> 	val_u16 = le16_to_cpu(config.status);
> 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> 		return -EMSGSIZE;
>
>
> status returned even without VIRTIO_NET_F_STATUS
if no VIRTIO_NET_F_STATUS, we should not nla_put 
VDPA_ATTR_DEV_NET_STATUS, the spec says the driver should assume the 
link is active.
>
> 	val_u16 = le16_to_cpu(config.mtu);
> 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> 		return -EMSGSIZE;
>
>
> MTU returned even without VIRTIO_NET_F_MTU
same as above, the spec says config.mtu depends on VIRTIO_NET_F_MTU, so 
without this feature bit, we should not return MTU to the userspace.

Does these fix look good to you?

And I think we may need your adjudication for the two issues:
(1) Shall we answer max_vq_paris = 1 when _MQ not exist, I know you have 
agreed on this in a previous thread, its nice to clarify
(2) I think we should not re-use the netlink attr to report feature bits 
of both the management device and the vDPA device,
this can lead to a new race condition, there are no locks(especially 
distributed locks for kernel_space and user_space) in the nla_put
functions. Re-using the attr is some kind of breaking the netlink 
lockless design.

Thanks,
Zhu Lingshan
>
>
> What's going on here?
>
>

