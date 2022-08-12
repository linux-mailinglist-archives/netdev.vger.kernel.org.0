Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B2A591033
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiHLLlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiHLLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:41:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA28AE9D4;
        Fri, 12 Aug 2022 04:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660304496; x=1691840496;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0e2NNdr9TRqsvhl/nqvRfSFvCOuxTASVTIjG60GZejU=;
  b=F37Jr59Ag7ZMqbTg6jRhWRjtszC6oe1RNS0/L+BAebhPZd0Y/9PyoNy3
   AvJR8QHvKYaRf7g5fMIqjcmaDtiYlM1dPhRmnH4AOzZOG39DUJ5EyZGPq
   rp8Kh30nGDwVBxDe+A2bm5H/l8ExU0hp4Y3tf7JMeIri//YbU9Py9OSNN
   cVok6gcnCgtIqV2i45CdVsWrd+ryplgYAhMiuvq8JtQTdF+uCmpBDfQTe
   iltzs0S/vnuOwbykuHR+u601J1WjBk7CMcv9clHax3+rCYX7lA4pZhGxh
   W0wdzjewBLFM3DsxQjvNxfDBHmUVn1aYzlYNQXXlGmxJLLfhRh9yNLekI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="292372511"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="292372511"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 04:41:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665792934"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.174.213]) ([10.249.174.213])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 04:41:33 -0700
Message-ID: <d07dc70e-e97b-9b9e-3ef2-c3f648c57a05@intel.com>
Date:   Fri, 12 Aug 2022 19:41:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH V5 0/6] ifcvf/vDPA: support query device config space
 through netlink
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, parav@nvidia.com,
        xieyongji@bytedance.com, gautam.dawar@amd.com
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812071251-mutt-send-email-mst@kernel.org>
 <20220812071638-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220812071638-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2022 7:17 PM, Michael S. Tsirkin wrote:
> On Fri, Aug 12, 2022 at 07:14:39AM -0400, Michael S. Tsirkin wrote:
>> On Fri, Aug 12, 2022 at 06:44:54PM +0800, Zhu Lingshan wrote:
>>> This series allows userspace to query device config space of vDPA
>>> devices and the management devices through netlink,
>>> to get multi-queue, feature bits and etc.
>>>
>>> This series has introduced a new netlink attr
>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
>>> features of vDPA  devices than the management device.
>>>
>>> Please help review.
>> I can't merge this for this merge window.
>> Am I right when I say that the new thing here is patch 5/6 + new
>> comments?
>> If yes I can queue it out of the window, on top.
> So at this point, can you please send patches on top of the vhost
> tree? I think these are just patches 3 and 5 but please confirm.
I will rebase them on vhost tree and resend them soon, main changes are 
in patch 5,
we have made MTU, MAC, MQ conditional there. And there are some new 
comments as
you suggested.


Thanks,
Zhu Lingshan
>
>
>>> Thanks!
>>> Zhu Lingshan
>>>
>>> Changes rom V4:
>>> (1) Read MAC, MTU, MQ conditionally (Michael)
>>> (2) If VIRTIO_NET_F_MAC not set, don't report MAC to userspace
>>> (3) If VIRTIO_NET_F_MTU not set, report 1500 to userspace
>>> (4) Add comments to the new attr
>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES(Michael)
>>> (5) Add comments for reporting the device status as LE(Michael)
>>>
>>> Changes from V3:
>>> (1)drop the fixes tags(Parva)
>>> (2)better commit log for patch 1/6(Michael)
>>> (3)assign num_queues to max_supported_vqs than max_vq_pairs(Jason)
>>> (4)initialize virtio pci capabilities in the probe() function.
>>>
>>> Changes from V2:
>>> Add fixes tags(Parva)
>>>
>>> Changes from V1:
>>> (1) Use __virito16_to_cpu(true, xxx) for the le16 casting(Jason)
>>> (2) Add a comment in ifcvf_get_config_size(), to explain
>>> why we should return the minimum value of
>>> sizeof(struct virtio_net_config) and the onboard
>>> cap size(Jason)
>>> (3) Introduced a new attr VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES
>>> (4) Show the changes of iproute2 output before and after 5/6 patch(Jason)
>>> (5) Fix cast warning in vdpa_fill_stats_rec()
>>>
>>> Zhu Lingshan (6):
>>>    vDPA/ifcvf: get_config_size should return a value no greater than dev
>>>      implementation
>>>    vDPA/ifcvf: support userspace to query features and MQ of a management
>>>      device
>>>    vDPA: allow userspace to query features of a vDPA device
>>>    vDPA: !FEATURES_OK should not block querying device config space
>>>    vDPA: Conditionally read fields in virtio-net dev config space
>>>    fix 'cast to restricted le16' warnings in vdpa.c
>>>
>>>   drivers/vdpa/ifcvf/ifcvf_base.c |  13 ++-
>>>   drivers/vdpa/ifcvf/ifcvf_base.h |   2 +
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 142 +++++++++++++++++---------------
>>>   drivers/vdpa/vdpa.c             |  82 ++++++++++++------
>>>   include/uapi/linux/vdpa.h       |   3 +
>>>   5 files changed, 149 insertions(+), 93 deletions(-)
>>>
>>> -- 
>>> 2.31.1

