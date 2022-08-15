Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE87592BD3
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiHOJhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 05:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiHOJhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 05:37:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEAE1EC61;
        Mon, 15 Aug 2022 02:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660556225; x=1692092225;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=AXXaTyZOIZGMRQ2mE61yr2DkSiSB1u9Ymvz6MvmMtos=;
  b=boN89XTPfLBM3RNle3vkDpcC1/jT932T8wECqafpUIBNVVGhyysSJv2R
   EEWqTBFkzx+JgtaR6hR/8z4JDjxRtjgbTOyl7Fo/aJ9w6KYV1fhfKLJgA
   HvCCEa056z7Q7+2OZhg/8UfS0575BPhstPGb2tggreqp/2dLv+wgp3mF8
   7d7oylrQLgHo2zY9o4Ze7Pg0ySPKE4X+L12gA2nvLaWmQEsuBFHDttQ8S
   /iGFSOyFK7xr81gxcp7Pn7ww/Oc6iQW4XY4ed+Zm9wHCe0bHQELD4yTdz
   24qrJ+sYAcsjP7Ms+KA4aubWzeqAnFFlpO0w+Bk/xe9iMMERyuSpJvBCk
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="289495385"
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="289495385"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 02:36:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="934423231"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.31.45]) ([10.255.31.45])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 02:36:52 -0700
Message-ID: <5cb5f67a-396c-ee04-cad3-1fdb44202e96@intel.com>
Date:   Mon, 15 Aug 2022 17:36:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH V5 0/6] ifcvf/vDPA: support query device config space
 through netlink
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, parav@nvidia.com,
        xieyongji@bytedance.com, gautam.dawar@amd.com
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812071251-mutt-send-email-mst@kernel.org>
 <20220812071638-mutt-send-email-mst@kernel.org>
 <d07dc70e-e97b-9b9e-3ef2-c3f648c57a05@intel.com>
In-Reply-To: <d07dc70e-e97b-9b9e-3ef2-c3f648c57a05@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2022 7:41 PM, Zhu, Lingshan wrote:
>
>
> On 8/12/2022 7:17 PM, Michael S. Tsirkin wrote:
>> On Fri, Aug 12, 2022 at 07:14:39AM -0400, Michael S. Tsirkin wrote:
>>> On Fri, Aug 12, 2022 at 06:44:54PM +0800, Zhu Lingshan wrote:
>>>> This series allows userspace to query device config space of vDPA
>>>> devices and the management devices through netlink,
>>>> to get multi-queue, feature bits and etc.
>>>>
>>>> This series has introduced a new netlink attr
>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
>>>> features of vDPA  devices than the management device.
>>>>
>>>> Please help review.
>>> I can't merge this for this merge window.
>>> Am I right when I say that the new thing here is patch 5/6 + new
>>> comments?
>>> If yes I can queue it out of the window, on top.
>> So at this point, can you please send patches on top of the vhost
>> tree? I think these are just patches 3 and 5 but please confirm.
> I will rebase them on vhost tree and resend them soon, main changes 
> are in patch 5,
> we have made MTU, MAC, MQ conditional there. And there are some new 
> comments as
> you suggested.
Hi Michael,

I have rebased patch 3/6 and 5/6, they can apply on both vhost tree
and Linus tree, the new series including these two patches are sent out.

Thanks,
Zhu Lingshan
>
>
> Thanks,
> Zhu Lingshan
>>
>>
>>>> Thanks!
>>>> Zhu Lingshan
>>>>
>>>> Changes rom V4:
>>>> (1) Read MAC, MTU, MQ conditionally (Michael)
>>>> (2) If VIRTIO_NET_F_MAC not set, don't report MAC to userspace
>>>> (3) If VIRTIO_NET_F_MTU not set, report 1500 to userspace
>>>> (4) Add comments to the new attr
>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES(Michael)
>>>> (5) Add comments for reporting the device status as LE(Michael)
>>>>
>>>> Changes from V3:
>>>> (1)drop the fixes tags(Parva)
>>>> (2)better commit log for patch 1/6(Michael)
>>>> (3)assign num_queues to max_supported_vqs than max_vq_pairs(Jason)
>>>> (4)initialize virtio pci capabilities in the probe() function.
>>>>
>>>> Changes from V2:
>>>> Add fixes tags(Parva)
>>>>
>>>> Changes from V1:
>>>> (1) Use __virito16_to_cpu(true, xxx) for the le16 casting(Jason)
>>>> (2) Add a comment in ifcvf_get_config_size(), to explain
>>>> why we should return the minimum value of
>>>> sizeof(struct virtio_net_config) and the onboard
>>>> cap size(Jason)
>>>> (3) Introduced a new attr VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES
>>>> (4) Show the changes of iproute2 output before and after 5/6 
>>>> patch(Jason)
>>>> (5) Fix cast warning in vdpa_fill_stats_rec()
>>>>
>>>> Zhu Lingshan (6):
>>>>    vDPA/ifcvf: get_config_size should return a value no greater 
>>>> than dev
>>>>      implementation
>>>>    vDPA/ifcvf: support userspace to query features and MQ of a 
>>>> management
>>>>      device
>>>>    vDPA: allow userspace to query features of a vDPA device
>>>>    vDPA: !FEATURES_OK should not block querying device config space
>>>>    vDPA: Conditionally read fields in virtio-net dev config space
>>>>    fix 'cast to restricted le16' warnings in vdpa.c
>>>>
>>>>   drivers/vdpa/ifcvf/ifcvf_base.c |  13 ++-
>>>>   drivers/vdpa/ifcvf/ifcvf_base.h |   2 +
>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 142 
>>>> +++++++++++++++++---------------
>>>>   drivers/vdpa/vdpa.c             |  82 ++++++++++++------
>>>>   include/uapi/linux/vdpa.h       |   3 +
>>>>   5 files changed, 149 insertions(+), 93 deletions(-)
>>>>
>>>> -- 
>>>> 2.31.1
>

