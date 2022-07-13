Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05A6572F89
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbiGMHsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbiGMHru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:47:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506D2E5DF3
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657698469; x=1689234469;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vj8X/LqF3f/wYRf5yzHwYjTsB4jiN9Wxyxci8qEo7z0=;
  b=ZgiftvX9Pezog6Ix/1H+EGHptgDYHk2jSJckxsTHWnvPZjDeCJtIgMcH
   q73UM1CSTpXDGBrQy2tskgRI+GmLCFNgO54at0ti9yNwA0kaiJfSvsj/y
   tb1zLYHnper6DEg1u7z41sKQ9Kko8Wgh0LiwDY/t+bTSSEFnxc7Xylo98
   cNijOZu+UqgdYpnk3U1YKUwSD9qS3YwNJnKIMkaLIF8B0ykPnswAM4OsS
   OFWsiGAIzVsrbNgC0kjz1gYkbOAo7UOBRmWtJBS2sOeMVu/eJQRV7YCO5
   Xk106ONos5bsT8x9BTBMDowjGSjmNhfZTbhsTEdOBGi6zli1IyxUxARQQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="346821857"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="346821857"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:47:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="628205970"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.208.157]) ([10.254.208.157])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:47:42 -0700
Message-ID: <d2aecbbd-ba6b-9613-e691-3b46c00af8bc@intel.com>
Date:   Wed, 13 Jul 2022 15:47:40 +0800
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
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220713011631-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220713011631-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2022 1:26 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 01, 2022 at 10:07:59PM +0000, Parav Pandit wrote:
>>
>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>> Sent: Friday, July 1, 2022 9:28 AM
>>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair, so
>>> when userspace querying queue pair numbers, it should return mq=1 than
>>> zero.
>>>
>>> Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
>>> devices, so that it should call vdpa_dev_net_mq_config_fill() so the
>>> parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
>>> feature_driver for the vDPA devices themselves
>>>
>>> Before this change, when MQ = 0, iproute2 output:
>>> $vdpa dev config show vdpa0
>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
>>> mtu 1500
>>>
>> The fix belongs to user space.
>> When a feature bit _MQ is not negotiated, vdpa kernel space will not add attribute VDPA_ATTR_DEV_NET_CFG_MAX_VQP.
>> When such attribute is not returned by kernel, max_vq_pairs should not be shown by the iproute2.
>>
>> We have many config space fields that depend on the feature bits and some of them do not have any defaults.
>> To keep consistency of existence of config space fields among all, we don't want to show default like below.
>>
>> Please fix the iproute2 to not print max_vq_pairs when it is not returned by the kernel.
> Parav I read the discussion and don't get your argument. From driver's POV
> _MQ with 1 VQ pair and !_MQ are exactly functionally equivalent.
>
> It's true that iproute probably needs to be fixed too, to handle old
> kernels. But iproute is not the only userspace, why not make it's life
> easier by fixing the kernel?
I will fix iproute2 once this series settles down

Thanks,
Zhu Lingshan

