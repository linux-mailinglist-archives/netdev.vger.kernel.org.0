Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53406572FA5
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiGMHwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiGMHwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:52:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFA1313A4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657698730; x=1689234730;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Bs0A0gwYjoIX5MVlA7mSCBBhrb0GLSFFVP1Pt4bJgNQ=;
  b=GTLfaYZB1HnXENd2Wz48od43u7a6DAFcy4Lfx5EUQp/Pdz7K5qT6GFpU
   Gi2D7xi1HuJW6o2jZg7AL1hSNh1A3aAJAf3ZojbuGfs4qRKbl1L8PkOF6
   vc/aeMkXrkqcgKEVNQyNWVWq5JB5rbPIBMzGXVv0L82InG2G9jzxhDisR
   frj+ZRQqpJlDUT80JRwDdkW2e2zPp9TaElXUHxCfrebomgrEW6b/Nwbc0
   +RQWg/TGi8h8L5CxecCIVnRS1BVexlFxuyQom/cjNwex+Z8iO1sMj9Au7
   TKp6w5DQlJQSVfwWb1NVxhtfmsDB9QeoBjg2gUyNtQMolhwyBcILGvQsJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="346822855"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="346822855"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:52:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="628207900"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.208.157]) ([10.254.208.157])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:52:08 -0700
Message-ID: <d7c1cc89-df6e-89ca-2da3-17fd8989e98d@intel.com>
Date:   Wed, 13 Jul 2022 15:52:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_config_size should return a value
 no greater than dev implementation
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-2-lingshan.zhu@intel.com>
 <CACGkMEvGo2urfPriS3f6dCxT+41KJ0E-KUd4-GvUrX81BVy8Og@mail.gmail.com>
 <b2b2fb5e-c1c2-84b6-0315-a6eef121cdac@intel.com>
 <20220713013141-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220713013141-mutt-send-email-mst@kernel.org>
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



On 7/13/2022 1:44 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 08, 2022 at 02:44:08PM +0800, Zhu, Lingshan wrote:
>>
>> On 7/4/2022 12:39 PM, Jason Wang wrote:
>>> On Fri, Jul 1, 2022 at 9:36 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>> ifcvf_get_config_size() should return a virtio device type specific value,
>>>> however the ret_value should not be greater than the onboard size of
>>>> the device implementation. E.g., for virtio_net, config_size should be
>>>> the minimum value of sizeof(struct virtio_net_config) and the onboard
>>>> cap size.
>>> Rethink of this, I wonder what's the value of exposing device
>>> implementation details to users? Anyhow the parent is in charge of
>>> "emulating" config space accessing.
>> This will not be exposed to the users, it is a ifcvf internal helper,
>> to get the actual device config space size.
>>
>> For example, if ifcvf drives an Intel virtio-net device,
>> if the device config space size is greater than sizeof(struct
>> virtio_net_cfg),
>> this means the device has something more than the spec, some private fields,
>> we don't want to expose these extra private fields to the users, so in this
>> case,
>> we only return what the spec defines.
> This is kind of already the case.
>
>> If the device config space size is less than sizeof(struct virtio_net_cfg),
>> means the device didn't implement all fields the spec defined, like no RSS.
>> In such cases, we only return what the device implemented.
>> So these are defensive programming.
> I think the issue you are describing is simply this.
>
>
> Driver must not access BAR outside capability length. Current code
> does not verify that it does not. Not the case for the current
> devices but it's best to be safe against the case where
> device does not implement some of the capability.
>
>
>  From that POV I think the patch is good, just fix the log.
sure, I will do

Thanks,
Zhu Lingshan
>
>
>
>>> If we do this, it's probably a blocker for cross vendor stuff.
>>>
>>> Thanks
>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>    drivers/vdpa/ifcvf/ifcvf_base.c | 13 +++++++++++--
>>>>    drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
>>>>    2 files changed, 13 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
>>>> index 48c4dadb0c7c..fb957b57941e 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>>>> @@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>>>>                           break;
>>>>                   case VIRTIO_PCI_CAP_DEVICE_CFG:
>>>>                           hw->dev_cfg = get_cap_addr(hw, &cap);
>>>> +                       hw->cap_dev_config_size = le32_to_cpu(cap.length);
>>>>                           IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
>>>>                           break;
>>>>                   }
>>>> @@ -233,15 +234,23 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
>>>>    u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
>>>>    {
>>>>           struct ifcvf_adapter *adapter;
>>>> +       u32 net_config_size = sizeof(struct virtio_net_config);
>>>> +       u32 blk_config_size = sizeof(struct virtio_blk_config);
>>>> +       u32 cap_size = hw->cap_dev_config_size;
>>>>           u32 config_size;
>>>>
>>>>           adapter = vf_to_adapter(hw);
>>>> +       /* If the onboard device config space size is greater than
>>>> +        * the size of struct virtio_net/blk_config, only the spec
>>>> +        * implementing contents size is returned, this is very
>>>> +        * unlikely, defensive programming.
>>>> +        */
>>>>           switch (hw->dev_type) {
>>>>           case VIRTIO_ID_NET:
>>>> -               config_size = sizeof(struct virtio_net_config);
>>>> +               config_size = cap_size >= net_config_size ? net_config_size : cap_size;
>>>>                   break;
>>>>           case VIRTIO_ID_BLOCK:
>>>> -               config_size = sizeof(struct virtio_blk_config);
>>>> +               config_size = cap_size >= blk_config_size ? blk_config_size : cap_size;
>>>>                   break;
>>>>           default:
>>>>                   config_size = 0;
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> index 115b61f4924b..f5563f665cc6 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> @@ -87,6 +87,8 @@ struct ifcvf_hw {
>>>>           int config_irq;
>>>>           int vqs_reused_irq;
>>>>           u16 nr_vring;
>>>> +       /* VIRTIO_PCI_CAP_DEVICE_CFG size */
>>>> +       u32 cap_dev_config_size;
>>>>    };
>>>>
>>>>    struct ifcvf_adapter {
>>>> --
>>>> 2.31.1
>>>>

