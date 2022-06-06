Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ADC53E1EE
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiFFIYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiFFIYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:24:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6A93FD8D
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 01:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654503879; x=1686039879;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jokcYOu/U5YusmKMGBAIDzK33d1WWrQ4/vwJAq5y0Zc=;
  b=b1FXuJzuTwiNQMVS3C9nSSahTc/IUmVItcOM6o1DF/HVHn4QCCXHyjuw
   eLwLIACgtJ0gnhXmtuqnDgnvJBjP78oxWcT46rUfEaVoWvIMtdNvsNmkg
   Tb6qipv9vkrpnRvUiYLYZGCogDa2TCta4B39dZw7FO2K/kVFwhmiKr1kJ
   urXRv3gKk4puafH6Krvw0gVPh93ows/Dfl07fF6jkBoVy2NC8QoEewVF7
   jVGzXTIhsuSoMH/mE/wA+QDaK9TW/AIyGLSaUAEW/X98EbhaDuUcBcQQ0
   dg56+9I0gikwKtjyixal45PSGjmpWwMWXoXGdi7J+H7na77QtpVX6vL5W
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276552415"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276552415"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:24:29 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="583514829"
Received: from fengjia-mobl2.ccr.corp.intel.com (HELO [10.254.210.182]) ([10.254.210.182])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:24:26 -0700
Message-ID: <52eedc6b-d5dc-538a-6380-361f5812a7ec@intel.com>
Date:   Mon, 6 Jun 2022 16:24:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 3/6] vDPA/ifcvf: support userspace to query device feature
 bits
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-4-lingshan.zhu@intel.com>
 <CACGkMEv9Vhe0+8DTotmGU1_9DseixTqA4CaYC1sXiNy0XYkBQw@mail.gmail.com>
 <DM8PR12MB5400F0F46CD4B0749A60FE8BABDE9@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <DM8PR12MB5400F0F46CD4B0749A60FE8BABDE9@DM8PR12MB5400.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2022 3:46 PM, Eli Cohen wrote:
>
>> -----Original Message-----
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Thursday, June 2, 2022 10:32 AM
>> To: Zhu Lingshan <lingshan.zhu@intel.com>
>> Cc: mst <mst@redhat.com>; virtualization <virtualization@lists.linux-foundation.org>; netdev <netdev@vger.kernel.org>; Eli Cohen
>> <elic@nvidia.com>; Parav Pandit <parav@nvidia.com>
>> Subject: Re: [PATCH 3/6] vDPA/ifcvf: support userspace to query device feature bits
>>
>> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>> This commit supports userspace to query device feature bits
>>> by filling the relevant netlink attribute.
>>>
>>> There are two types of netlink attributes:
>>> VDPA_ATTR_DEV_XXXX work for virtio devices config space, and
>>> VDPA_ATTR_MGMTDEV_XXXX work for the management devices.
>>>
>>> This commit fixes a misuse of VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>>> this attr is for a virtio device, not management devices.
>>>
>>> Thus VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES is introduced for
>>> reporting management device features, and VDPA_ATTR_DEV_SUPPORTED_FEATURES
>>> for virtio devices feature bits.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/vdpa.c       | 15 ++++++++++-----
>>>   include/uapi/linux/vdpa.h |  1 +
>>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>> index 2b75c00b1005..c820dd2b0307 100644
>>> --- a/drivers/vdpa/vdpa.c
>>> +++ b/drivers/vdpa/vdpa.c
>>> @@ -508,7 +508,7 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>>>                  err = -EMSGSIZE;
>>>                  goto msg_err;
>>>          }
>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES,
>> Adding Eli and Parav.
>>
>> If I understand correctly, we can't provision virtio features right
>> now. This means, the vDPA instance should have the same features as
>> its parent (management device).
> A management device should be read as "a management device capable of
> instantiating a virtio device". Thus, I see no reason to introduce another attribute.
> VDPA_ATTR_DEV_SUPPORTED_FEATURES is the capability of the management
> device to spawn a virtio device with certain features.
This may not be true because the "managed" device may have different 
feature bits than the "management" device.
E.g., we can choose not to provide MQ feature for a managed device.

As Jason said, it is about provisioning, and we need two different attrs 
anyway.

Thanks,
Zhu Lingshan
>
>> And it seems to me if we can do things like this, we need first allow
>> the features to be provisioned. (And this change breaks uABI)
>>
>> Thanks
>>
>>
>>>                                mdev->supported_features, VDPA_ATTR_PAD)) {
>>>                  err = -EMSGSIZE;
>>>                  goto msg_err;
>>> @@ -827,7 +827,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>>>   {
>>>          struct virtio_net_config config = {};
>>> -       u64 features;
>>> +       u64 features_device, features_driver;
>>>          u16 val_u16;
>>>
>>>          vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>> @@ -844,12 +844,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>                  return -EMSGSIZE;
>>>
>>> -       features = vdev->config->get_driver_features(vdev);
>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>> +       features_driver = vdev->config->get_driver_features(vdev);
>>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>                                VDPA_ATTR_PAD))
>>>                  return -EMSGSIZE;
>>>
>>> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>>> +       features_device = vdev->config->get_device_features(vdev);
>>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES, features_device,
>>> +                             VDPA_ATTR_PAD))
>>> +               return -EMSGSIZE;
>>> +
>>> +       return vdpa_dev_net_mq_config_fill(vdev, msg, features_device, &config);
>>>   }
>>>
>>>   static int
>>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
>>> index 1061d8d2d09d..70a3672c288f 100644
>>> --- a/include/uapi/linux/vdpa.h
>>> +++ b/include/uapi/linux/vdpa.h
>>> @@ -30,6 +30,7 @@ enum vdpa_attr {
>>>          VDPA_ATTR_MGMTDEV_BUS_NAME,             /* string */
>>>          VDPA_ATTR_MGMTDEV_DEV_NAME,             /* string */
>>>          VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,    /* u64 */
>>> +       VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES,   /* u64 */
>>>
>>>          VDPA_ATTR_DEV_NAME,                     /* string */
>>>          VDPA_ATTR_DEV_ID,                       /* u32 */
>>> --
>>> 2.31.1
>>>

