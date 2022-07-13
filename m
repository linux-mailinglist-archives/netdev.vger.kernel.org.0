Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12897572BA7
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiGMDD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiGMDD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:03:26 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5924ED64FE
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 20:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657681406; x=1689217406;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v1CVHKuZH+4s03K2tkbPaas/LJYgHgXU2wVKKk99URo=;
  b=bPX02BEgTfSmLG2K6X5vMP6kqr/czZDBnk4ZduPB4PViLDmX6/KbLpb8
   6UuX82Hv/6VH5ImP/WrKW8itkCQjh5kzyHFBrfpTsgWeGIErN8Ql7Z9W2
   x0gDm2MkGe8UK6KU5B+NRI/JcwsgBVpZMGUQwl0uygq5NP4TEgq7q5gsk
   HBtoxVJBsw7mCtUvAsTsU54vYGbH4TrDo57LXrmFqTAiEHEX8uqlg23y3
   a4vEHb0dHq9qAcDywxglKtF7Ed77TuDHY3QFlrgc1+3MOLJ5AJCcG0KGQ
   rP8jG4YZjuelewphnYVMEQn2uMB/nxxVHCM2d7YRQ6XTvT8HEgN6+vu3i
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="264885109"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="264885109"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 20:03:24 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="653178318"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.215.171]) ([10.254.215.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 20:03:22 -0700
Message-ID: <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
Date:   Wed, 13 Jul 2022 11:03:20 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2022 12:48 AM, Parav Pandit wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Sunday, July 10, 2022 10:30 PM
>>> Showing max_vq_pairs of 1 even when _MQ is not negotiated, incorrectly
>> says that max_vq_pairs is exposed to the guest, but it is not offered.
>>> So, please fix the iproute2 to not print max_vq_pairs when it is not
>> returned by the kernel.
>> iproute2 can report whether there is MQ feature in the device / driver
>> feature bits.
>> I think iproute2 only queries the number of max queues here.
>>
>> max_vq_pairs shows how many queue pairs there, this attribute's existence
>> does not depend on MQ, if no MQ, there are still one queue pair, so just
>> show one.
> This netlink attribute's existence is depending on the _MQ feature bit existence.
why? If no MQ, then no queues?
> We can break that and report the value, but if we break that there are many other config space bits who doesn’t have good default like max_vq_pairs.
max_vq_paris may not have a default value, but we know if there is no 
MQ, a virtio-net still have one queue pair to be functional.
> There is ambiguity for user space what to do with it and so in the kernel space..
> Instead of dealing with them differently in kernel, at present we attach each netlink attribute to a respective feature bit wherever applicable.
> And code in kernel and user space is uniform to handle them.
I get your point, but you see, by "max_vq_pairs", the user space tool is 
asking how many queue pairs there, it is not asking whether the device 
have MQ.
Even no _MQ, we still need to tell the users that there are one queue 
pair, or it is not a functional virtio-net,
we should detect this error earlier in the device initialization.

I think it is still uniform, it there is _MQ, we return 
cfg.max_queue_pair, if no _MQ, return 1, still by netlink.

Thanks

