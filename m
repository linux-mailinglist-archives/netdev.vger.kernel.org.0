Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34835581DBE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 04:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240135AbiG0CxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 22:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiG0CxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 22:53:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5573C8E8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 19:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658890386; x=1690426386;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UfvlPvw3b6+YY8/acxU6uUliWejd9uf4MqY5nyAccME=;
  b=PozANv0p4fxMDGJdDXT/nod1xnxG/ASe6hoUP5n634FOnId22QS5m6Mv
   52fl4q14YfD010VOxAErJP4E30OJLhmo28sbv73bsr10VutjPz2HDnIJQ
   rrRMuXCoS86COq46XTQLaYBpl5oWsuhfy9jtunjV1M2UbQ4aA1E3/DmrT
   cmIj3Nee127MoXXfzzYoysqtqtwH8KsJ7g4VsQignBy4S1oH9mRbZk6+M
   5n66OyhkFyl3/0GWnLLWSml+EgW4AzuQpwpI4S8EYF6Ghqu2SL/1WiI8P
   7X+BZQ/uBl1T2ZEZfGRZucVszOffeD97jy3y1xibdsIFUJ/oIlZ23M9+d
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="268514179"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="268514179"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 19:53:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="658991385"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.153]) ([10.249.171.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 19:53:04 -0700
Message-ID: <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
Date:   Wed, 27 Jul 2022 10:53:02 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 10:17 AM, Parav Pandit wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Tuesday, July 26, 2022 10:15 PM
>>
>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>> When the user space which invokes netlink commands, detects that
>> _MQ
>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
>>>> I think the kernel module have all necessary information and it is
>>>> the only one which have precise information of a device, so it should
>>>> answer precisely than let the user space guess. The kernel module
>>>> should be reliable than stay silent, leave the question to the user space
>> tool.
>>> Kernel is reliable. It doesn’t expose a config space field if the field doesn’t
>> exist regardless of field should have default or no default.
>> so when you know it is one queue pair, you should answer one, not try to
>> guess.
>>> User space should not guess either. User space gets to see if _MQ
>> present/not present. If _MQ present than get reliable data from kernel.
>>> If _MQ not present, it means this device has one VQ pair.
>> it is still a guess, right? And all user space tools implemented this feature
>> need to guess
> No. it is not a guess.
> It is explicitly checking the _MQ feature and deriving the value.
> The code you proposed will be present in the user space.
> It will be uniform for _MQ and 10 other features that are present now and in the future.
MQ and other features like RSS are different. If there is no _RSS_XX, 
there are no attributes like max_rss_key_size, and there is not a 
default value.
But for MQ, we know it has to be 1 wihtout _MQ.
> For feature X, kernel reports default and for feature Y, kernel skip reporting it, because there is no default. <- This is what we are trying to avoid here.
Kernel reports one queue pair because there is actually one.
>

