Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F5D567BD6
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 04:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiGFCZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 22:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGFCZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 22:25:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895F2BC1A
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 19:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657074320; x=1688610320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hxpHsSKapgGvhd56R7ArDgqAcj27D6MXu+2UL5Dynn4=;
  b=Fp4l0Apqs8EVhYFquBD9XXSbW1MunZbOfvQNbmVN+0GpgIgdFKpekieR
   bMCrT9/9fpXlz6+Zd2X1jvuS9dasphWT9ke0wpMZYNumpG2OHdbmhucED
   gr0n+aJKFGErJAT4MJhzfrh14ftp2/9N2yWSXoLWqyA01W8tH+NVuJwaQ
   ZlKdgQu7v9upgXzzGGZQkp3rVdUkiBawR0onv7/tqyPrKrU0UhkWfIVMv
   P1myDbj1o9GddRbs2fh1IOTMxt5H8ahQNABCst1hBDIFUcYI8WCt5dnAR
   uNHInXyorPXsYMzvk1Kj/8B541/ylNe4qLYPmhi6XnDAOMZZkF1HIqP5w
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="264040757"
X-IronPort-AV: E=Sophos;i="5.92,248,1650956400"; 
   d="scan'208";a="264040757"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 19:25:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,248,1650956400"; 
   d="scan'208";a="650443770"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.208.29]) ([10.254.208.29])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 19:25:18 -0700
Message-ID: <814143c9-b7ab-a1c7-c5e2-cff8b024fc2f@intel.com>
Date:   Wed, 6 Jul 2022 10:25:15 +0800
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
 <a59209f3-9005-b9f6-6f27-e136443aa3e1@intel.com>
 <PH0PR12MB54816A1864BADD420A2674E8DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54816A1864BADD420A2674E8DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2022 1:01 AM, Parav Pandit wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Tuesday, July 5, 2022 12:56 PM
>>> Both can be queried simultaneously. Each will return their own feature bits
>> using same attribute.
>>> It wont lead to the race.
>> How? It is just a piece of memory, xxxx[attr], do you see locks in
>> nla_put_u64_64bit()? It is a typical race condition, data accessed by multiple
>> producers / consumers.
> No. There is no race condition in here.
> And new attribute enum by no means avoid any race.
>
> Data put using nla_put cannot be accessed until they are transferred.
How this is guaranteed? Do you see errors when calling nla_put_xxx() twice?
>
>> And re-use a netlink attr is really confusing.
> Please put comment for this variable explaining why it is shared for the exception.
>
> Before that lets start, can you share a real world example of when this feature bitmap will have different value than the mgmt. device bitmap value?
For example,
1. When migrate the VM to a node which has a more resourceful device. If 
the source side device does not have MQ, RSS or TSO feature, the vDPA 
device assigned to the VM does not
have MQ, RSS or TSO as well. When migrating to a node which has a device 
with MQ, RSS or TSO, to provide a consistent network device to the 
guest, to be transparent to the guest,
we need to mask out MQ, RSS or TSO in the vDPA device when provisioning. 
This is an example that management device may have different feature 
bits than the vDPA device.

2.SIOV, if a virtio device is capable of managing SIOV devices, and it 
exposes this capability by a feature bit(Like what I am doing in the 
"transport virtqueue"),
we don't want the SIOV ADIs have SIOV features, so the ADIs don't have 
SIOV feature bit.

Thanks
>
>>>> IMHO, I don't see any advantages of re-using this attr.
>>> We don’t want to continue this mess of VDPA_DEV prefix for new
>> attributes due to previous wrong naming.
>> as you point out before, is is a wrong naming, we can't re-nmme it because
>> we don't want to break uAPI, so there needs a new attr, if you don't like the
>> name VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, it is more than
>> welcome to suggest a new one
>>
>> Thanks

