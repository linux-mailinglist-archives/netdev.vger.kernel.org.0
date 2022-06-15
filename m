Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9A454C1F5
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353495AbiFOGeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354171AbiFOGeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:34:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96B94249F
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 23:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655274845; x=1686810845;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oQOVxfmwRoDsf8yHBy/zvML45O1b+2Lsf6BqQetBGCU=;
  b=SDSxaWhf3k4qpRYoMaI+qZ3egfmwzDRVd802kg+JoX4PZX34FrQvGJoG
   Pg09LxKL1BbCHahszuE327t6waKzv/ewQEety6EFEjPLlyXvONznOYOMX
   YMhV7c0dH9c/hK+jCa3bjCEdJOCOx/HNOi//QoTcMxy8Zypk68XClSxNj
   9f6fIMW0qmW6D569EUztz9ZF3SQy2Fj5jIh22zFRsQJtXUZe8JGI33KZw
   m5hMb9SkWpyXIYvK4rwcBwWEcsaNL0TYZjg7dF8xRKwNhNiyRkkObeLAT
   WvQoaPST/YXAOYN0x23AJcvHEK+FtKO5z2vm0BJ19gvT/rfM5/8OeE+8I
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="261883108"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="261883108"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 23:34:05 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="911455952"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.212.27]) ([10.254.212.27])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 23:34:03 -0700
Message-ID: <a2654716-4457-cd7a-251f-2ac662e47a8f@intel.com>
Date:   Wed, 15 Jun 2022 14:34:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace
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
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
 <20220613101652.195216-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481D2A01569549281D01411DCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <05c09bdd-278c-af18-e087-d74a511a4305@intel.com>
 <PH0PR12MB548194393655B8638A2FA4B2DCAA9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB548194393655B8638A2FA4B2DCAA9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/2022 3:26 AM, Parav Pandit wrote:
>
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Monday, June 13, 2022 10:33 PM
>>
>>
>> On 6/14/2022 4:36 AM, Parav Pandit wrote:
>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Monday, June 13, 2022 6:17 AM
>>>> To: jasowang@redhat.com; mst@redhat.com
>>>> Cc: virtualization@lists.linux-foundation.org;
>>>> netdev@vger.kernel.org; Parav Pandit <parav@nvidia.com>;
>>>> xieyongji@bytedance.com; gautam.dawar@amd.com; Zhu Lingshan
>>>> <lingshan.zhu@intel.com>
>>>> Subject: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to
>>>> userspace when VIRTIO_NET_F_MQ == 0
>>>>
>>>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue
>>>> pair, so when userspace querying queue pair numbers, it should return
>>>> mq=1 than zero.
>>>>
>>>> Function vdpa_dev_net_config_fill() fills the attributions of the
>>>> vDPA devices, so that it should call vdpa_dev_net_mq_config_fill() so
>>>> the parameter in vdpa_dev_net_mq_config_fill() should be
>>>> feature_device than feature_driver for the vDPA devices themselves
>>>>
>>>> Before this change, when MQ = 0, iproute2 output:
>>>> $vdpa dev config show vdpa0
>>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs
>>>> 0 mtu 1500
>>>>
>>> Max_vq_pairs should not be printed when _MQ feature is not negotiated.
>>> Existing code that returns 0 is correct following this line of the spec.
>>>
>>> " The following driver-read-only field, max_virtqueue_pairs only
>>> exists if VIRTIO_NET_F_MQ or VIRTIO_- NET_F_RSS is set."
>>> The field doesn't exist when _MQ is not there. Hence, it should not be
>> printed.
>>> Is _RSS offered and is that why you see it?
>>>
>>> If not a fix in the iproute2/vdpa should be done.
>> IMHO, The spec says:
>> The following driver-read-only field, max_virtqueue_pairs only exists if
>> VIRTIO_NET_F_MQ is *set*
>>
>> The spec doesn't say:
>> The following driver-read-only field, max_virtqueue_pairs only exists if
>> VIRTIO_NET_F_MQ is *negotiated*
>>
>> If a device is capable of of multi-queues, this capability does not depend on
>> the driver. We are querying the device, not the driver.
>>
>> If there is MQ, we print the onboard implemented total number of the
>> queue pairs.
>> If MQ is not set, we will not read the onboard mq number, because it is not
>> there as the spec says.
>> But there should be at least one queue pair to be a functional virtio-net, so 1
>> is printed.
> The commit [1] is supposed to show the device configuration layout as what device _offers_ as mentioned in the subject line of the commit [1] very clearly.
>
> The commit [2] changed the original intent of commit [1] even though commit [2] mentioned "fixes" in the patch without any fixes tag. :(
> commit [2] was bug.
>
> The right fix to restore [1] is to report the device features offered using get_device_features() callback instead of get_drivers_features().
already done in 3/6 patch in this series, see:
  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct 
sk_buff *msg)
  {
         struct virtio_net_config config = {};
-       u64 features;
+       u64 features_device, features_driver;
         u16 val_u16;

and
-       features = vdev->config->get_driver_features(vdev);
-       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, 
features,
+       features_driver = vdev->config->get_driver_features(vdev);
+       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, 
features_driver,
+                             VDPA_ATTR_PAD))
+               return -EMSGSIZE;
+
+       features_device = vdev->config->get_device_features(vdev);
+       if (nla_put_u64_64bit(msg, 
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
                               VDPA_ATTR_PAD))
                 return -EMSGSIZE;

Features of the device and the driver are reported separately.

>
> Once above fix is applied,
> when _MQ is not offered, max_queue_pairs should be treated as 1 by the driver.
Yes, it is done by this patch.
> We do not have a concept of management driver yet in the specification.
> So when _MQ is not offered by the device, either kernel driver can return max_queue_pairs = 1, or the user space caller can see that _MQ is not offered by the device hence treat max_vq_pairs = 1.
> (Like how it is described in the spec as - " Identify and initialize the receive and transmission virtqueues, up to N of each kind. If VIRTIO_NET_F_MQ feature bit is negotiated, N=max_virtqueue_pairs, otherwise identify N=1."
Yes, that's why I set max_queue_pairs = 1 if MQ = 0 in this patch.
>
> So let orchestration layer can certainly derive this N when _MQ feature is not offered, instead of coming from the vdpa management layer.
> I agree that this extra if() condition in the user space can be avoided if kernel always provides it.
> But better to avoid such assumption because we have more such config space attributes. i.e., they exist only when features are offered.
> So to keep it uniform, I prefer we avoid the exception for max_virtqueue_pairs.
>
> Please submit the fix for [2] to call get_device_features() for purpose of returning config space.
> Continue to use get_driver_features() to show VDPA_ATTR_DEV_NEGOTIATED_FEATURES.
This is already there in 3/6 patch, we have these code to report driver 
features:
         features_driver = vdev->config->get_driver_features(vdev);
         if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, 
features_driver,
                               VDPA_ATTR_PAD))
                 return -EMSGSIZE;

And these code to report device features:
         features_device = vdev->config->get_device_features(vdev);
         if (nla_put_u64_64bit(msg, 
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
                               VDPA_ATTR_PAD))
                 return -EMSGSIZE;



>
> I didn’t review these patches and it slipped through the cracks. :(
>
> [1] a64917bc2e9b ("vdpa: Introduce query of device config layout")
> [2] a64917bc2e9 ("vdpa: Provide interface to read driver features")

