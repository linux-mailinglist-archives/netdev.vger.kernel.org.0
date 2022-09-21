Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D514B5BF601
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 07:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiIUF7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 01:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIUF7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 01:59:51 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F1312ADF;
        Tue, 20 Sep 2022 22:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663739990; x=1695275990;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YIc1SDWwYMnhaqOGzGYWUUC0Gg63lPxz+shtRIfe3Sc=;
  b=BMH73FcmozwtOe1gOx2m0gskxXuelcv8EpyCp97VxKAq0l/PPcCF2OF5
   JCw852nklq7TyHmE2CF9uPGGIl+cr1xubVFObs34bv47lpPg9hEbVaNCt
   64UPCAD4hzkewh+VaN2wjPVqAHYgkeKqMVoSgzWlRET0SNevsPg/HPyDC
   lWo+em3qX/EU6HY04A2kuKpu1U94vfnrttblbEMCM30fPhYsYEYiViJ41
   CkGk6QpeJao2BChzQyVacQMWgtL/IgXhMp8LJjQIZYuUKYueIr7ANfaOt
   a3w3Sbb0OUBmxN1cUno9trPv5zZZJPkOnUwG6OC45Ycc42DZG8JXK/WfX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="282955373"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="282955373"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 22:59:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="864284977"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.29.68]) ([10.255.29.68])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 22:59:48 -0700
Message-ID: <27b04293-2225-c78d-f6e3-ffe8a7472ea1@intel.com>
Date:   Wed, 21 Sep 2022 13:59:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH 1/4] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-2-lingshan.zhu@intel.com>
 <CACGkMEsq+weeO7i8KtNNAPhXGwN=cTwWt3RWfTtML-Xwj3K5Qg@mail.gmail.com>
 <e69b65e7-516f-55bd-cb99-863d7accbd32@intel.com>
 <CACGkMEv0++vmfzzmX47NhsaY5JTvbO2Ro7Taf8C0dxV6OVXTKw@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEv0++vmfzzmX47NhsaY5JTvbO2Ro7Taf8C0dxV6OVXTKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/2022 10:17 AM, Jason Wang wrote:
> On Tue, Sep 20, 2022 at 5:58 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 9/20/2022 10:02 AM, Jason Wang wrote:
>>> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>> This commit adds a new vDPA netlink attribution
>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>>>> features of vDPA devices through this new attr.
>>>>
>>>> This commit invokes vdpa_config_ops.get_config() than
>>>> vdpa_get_config_unlocked() to read the device config
>>>> spcae, so no raeces in vdpa_set_features_unlocked()
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> It's better to share the userspace code as well.
>> OK, will share it in V2.
>>>> ---
>>>>    drivers/vdpa/vdpa.c       | 19 ++++++++++++++-----
>>>>    include/uapi/linux/vdpa.h |  4 ++++
>>>>    2 files changed, 18 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>> index c06c02704461..798a02c7aa94 100644
>>>> --- a/drivers/vdpa/vdpa.c
>>>> +++ b/drivers/vdpa/vdpa.c
>>>> @@ -491,6 +491,8 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>>>>                   err = -EMSGSIZE;
>>>>                   goto msg_err;
>>>>           }
>>>> +
>>>> +       /* report features of a vDPA management device through VDPA_ATTR_DEV_SUPPORTED_FEATURES */
>>> The code explains itself, there's no need for the comment.
>> these comments are required in other discussions
> I think it's more than sufficient to clarify the semantic where it is defined.
OK, then only comments in the header file
>
>>>>           if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>>>>                                 mdev->supported_features, VDPA_ATTR_PAD)) {
>>>>                   err = -EMSGSIZE;
>>>> @@ -815,10 +817,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>>>    static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>>>>    {
>>>>           struct virtio_net_config config = {};
>>>> -       u64 features;
>>>> +       u64 features_device, features_driver;
>>>>           u16 val_u16;
>>>>
>>>> -       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>> +       vdev->config->get_config(vdev, 0, &config, sizeof(config));
>>>>
>>>>           if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
>>>>                       config.mac))
>>>> @@ -832,12 +834,19 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>           if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>                   return -EMSGSIZE;
>>>>
>>>> -       features = vdev->config->get_driver_features(vdev);
>>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>> +       features_driver = vdev->config->get_driver_features(vdev);
>>>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>> +                             VDPA_ATTR_PAD))
>>>> +               return -EMSGSIZE;
>>>> +
>>>> +       features_device = vdev->config->get_device_features(vdev);
>>>> +
>>>> +       /* report features of a vDPA device through VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES */
>>>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>>>>                                 VDPA_ATTR_PAD))
>>>>                   return -EMSGSIZE;
>>>>
>>>> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>>>> +       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>>>>    }
>>>>
>>>>    static int
>>>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
>>>> index 25c55cab3d7c..97531b52dcbe 100644
>>>> --- a/include/uapi/linux/vdpa.h
>>>> +++ b/include/uapi/linux/vdpa.h
>>>> @@ -46,12 +46,16 @@ enum vdpa_attr {
>>>>
>>>>           VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
>>>>           VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
>>>> +       /* features of a vDPA management device */
>>>>           VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */
>>>>
>>>>           VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>>>           VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>>>>           VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>>>>
>>>> +       /* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
>>>> +       VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */
>>> What's the difference between this and VDPA_ATTR_DEV_SUPPORTED_FEATURES?
>> This is to report a vDPA device features, and
>> VDPA_ATTR_DEV_SUPPORTED_FEATURES
>> is used for reporting the management device features, we have a long
>> discussion
>> on this before.
> Yes, but the comment is not clear in many ways:
>
> " features of a vDPA management device" sounds like features that is
> out of the scope of the virtio.
I think the term "vDPA device" implies that it is a virtio device.
So how about: "virtio features of a vDPA management device"
>
> And
>
> "/dev/vhost-vdpa0" is not a vDPA device but a vhost-vDPA device.
will remove this example here.

Thanks
>
> Thanks
>
>>> Thanks
>>>
>>>> +
>>>>           /* new attributes must be added above here */
>>>>           VDPA_ATTR_MAX,
>>>>    };
>>>> --
>>>> 2.31.1
>>>>

