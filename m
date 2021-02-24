Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5899323797
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 07:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhBXG5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 01:57:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhBXG4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 01:56:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614149723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//VjBrrX+diVQv6GNcoSTqGXAnitFixElwDMOSM+paQ=;
        b=BX6JADwZsPAAcZWb8oQR16gnxPybgBHjv0eGWzhGFiGVNXrJpljpbKJFnSkKKWAuVtSdaP
        kVLVL90rlbuk4o0SQPGtGL0COtLayJpiONLdfZ67nIFRYSuOFrlDlDctslZnkZtvvWhiaW
        8WDR6dy7f1kkCpHN2VLutDVnZmZ9gz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-n7LCUzJENcSl-At0g7dlDQ-1; Wed, 24 Feb 2021 01:55:21 -0500
X-MC-Unique: n7LCUzJENcSl-At0g7dlDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D73C6801965;
        Wed, 24 Feb 2021 06:55:19 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB2DE72F84;
        Wed, 24 Feb 2021 06:55:14 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <7e6291a4-30b1-6b59-a2bf-713e7b56826d@redhat.com>
 <20210224000528-mutt-send-email-mst@kernel.org>
 <20210224064520.GA204317@mtl-vdi-166.wap.labs.mlnx>
 <20210224014700-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ef775724-b5fb-ca70-ed2f-f23d8fbf4cd8@redhat.com>
Date:   Wed, 24 Feb 2021 14:55:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224014700-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/24 2:47 下午, Michael S. Tsirkin wrote:
> On Wed, Feb 24, 2021 at 08:45:20AM +0200, Eli Cohen wrote:
>> On Wed, Feb 24, 2021 at 12:17:58AM -0500, Michael S. Tsirkin wrote:
>>> On Wed, Feb 24, 2021 at 11:20:01AM +0800, Jason Wang wrote:
>>>> On 2021/2/24 3:35 上午, Si-Wei Liu wrote:
>>>>>
>>>>> On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
>>>>>> On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
>>>>>>> On 2021/2/23 9:12 上午, Si-Wei Liu wrote:
>>>>>>>> On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
>>>>>>>>>> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
>>>>>>>>>>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>>>>>>>>>>> for legacy") made an exception for legacy guests to reset
>>>>>>>>>>> features to 0, when config space is accessed before features
>>>>>>>>>>> are set. We should relieve the verify_min_features() check
>>>>>>>>>>> and allow features reset to 0 for this case.
>>>>>>>>>>>
>>>>>>>>>>> It's worth noting that not just legacy guests could access
>>>>>>>>>>> config space before features are set. For instance, when
>>>>>>>>>>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>>>>>>>>>>> will try to access and validate the MTU present in the config
>>>>>>>>>>> space before virtio features are set.
>>>>>>>>>> This looks like a spec violation:
>>>>>>>>>>
>>>>>>>>>> "
>>>>>>>>>>
>>>>>>>>>> The following driver-read-only field, mtu only exists if
>>>>>>>>>> VIRTIO_NET_F_MTU is
>>>>>>>>>> set.
>>>>>>>>>> This field specifies the maximum MTU for the driver to use.
>>>>>>>>>> "
>>>>>>>>>>
>>>>>>>>>> Do we really want to workaround this?
>>>>>>>>>>
>>>>>>>>>> Thanks
>>>>>>>>> And also:
>>>>>>>>>
>>>>>>>>> The driver MUST follow this sequence to initialize a device:
>>>>>>>>> 1. Reset the device.
>>>>>>>>> 2. Set the ACKNOWLEDGE status bit: the guest OS has
>>>>>>>>> noticed the device.
>>>>>>>>> 3. Set the DRIVER status bit: the guest OS knows how to drive the
>>>>>>>>> device.
>>>>>>>>> 4. Read device feature bits, and write the subset of feature bits
>>>>>>>>> understood by the OS and driver to the
>>>>>>>>> device. During this step the driver MAY read (but MUST NOT write)
>>>>>>>>> the device-specific configuration
>>>>>>>>> fields to check that it can support the device before accepting it.
>>>>>>>>> 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new
>>>>>>>>> feature bits after this step.
>>>>>>>>> 6. Re-read device status to ensure the FEATURES_OK bit is still set:
>>>>>>>>> otherwise, the device does not
>>>>>>>>> support our subset of features and the device is unusable.
>>>>>>>>> 7. Perform device-specific setup, including discovery of virtqueues
>>>>>>>>> for the device, optional per-bus setup,
>>>>>>>>> reading and possibly writing the device’s virtio configuration
>>>>>>>>> space, and population of virtqueues.
>>>>>>>>> 8. Set the DRIVER_OK status bit. At this point the device is “live”.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> so accessing config space before FEATURES_OK is a spec
>>>>>>>>> violation, right?
>>>>>>>> It is, but it's not relevant to what this commit tries to address. I
>>>>>>>> thought the legacy guest still needs to be supported.
>>>>>>>>
>>>>>>>> Having said, a separate patch has to be posted to fix the guest driver
>>>>>>>> issue where this discrepancy is introduced to
>>>>>>>> virtnet_validate() (since
>>>>>>>> commit fe36cbe067). But it's not technically related to this patch.
>>>>>>>>
>>>>>>>> -Siwei
>>>>>>> I think it's a bug to read config space in validate, we should
>>>>>>> move it to
>>>>>>> virtnet_probe().
>>>>>>>
>>>>>>> Thanks
>>>>>> I take it back, reading but not writing seems to be explicitly
>>>>>> allowed by spec.
>>>>>> So our way to detect a legacy guest is bogus, need to think what is
>>>>>> the best way to handle this.
>>>>> Then maybe revert commit fe36cbe067 and friends, and have QEMU detect
>>>>> legacy guest? Supposedly only config space write access needs to be
>>>>> guarded before setting FEATURES_OK.
>>>>
>>>> I agree. My understanding is that all vDPA must be modern device (since
>>>> VIRITO_F_ACCESS_PLATFORM is mandated) instead of transitional device.
>>>>
>>>> Thanks
>>> Well mlx5 has some code to handle legacy guests ...
>>> Eli, could you comment? Is that support unused right now?
>>>
>> If you mean support for version 1.0, well the knob is there but it's not
>> set in the firmware I use. Note sure if we will support this.
> Hmm you mean it's legacy only right now?
> Well at some point you will want advanced goodies like RSS
> and all that is gated on 1.0 ;)


So if my understanding is correct the device/firmware is legacy but 
require VIRTIO_F_ACCESS_PLATFORM semanic? Looks like a spec violation?

Thanks


>
>>>>> -Siwie
>>>>>
>>>>>>>>>>> Rejecting reset to 0
>>>>>>>>>>> prematurely causes correct MTU and link status unable to load
>>>>>>>>>>> for the very first config space access, rendering issues like
>>>>>>>>>>> guest showing inaccurate MTU value, or failure to reject
>>>>>>>>>>> out-of-range MTU.
>>>>>>>>>>>
>>>>>>>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for
>>>>>>>>>>> supported mlx5 devices")
>>>>>>>>>>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>>>>>>>>>> ---
>>>>>>>>>>>      drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>>>>>>>>>>>      1 file changed, 1 insertion(+), 14 deletions(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> index 7c1f789..540dd67 100644
>>>>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> @@ -1490,14 +1490,6 @@ static u64
>>>>>>>>>>> mlx5_vdpa_get_features(struct vdpa_device *vdev)
>>>>>>>>>>>          return mvdev->mlx_features;
>>>>>>>>>>>      }
>>>>>>>>>>> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev,
>>>>>>>>>>> u64 features)
>>>>>>>>>>> -{
>>>>>>>>>>> -    if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>>>>>>>>>>> -        return -EOPNOTSUPP;
>>>>>>>>>>> -
>>>>>>>>>>> -    return 0;
>>>>>>>>>>> -}
>>>>>>>>>>> -
>>>>>>>>>>>      static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>>>>>>>>>>>      {
>>>>>>>>>>>          int err;
>>>>>>>>>>> @@ -1558,18 +1550,13 @@ static int
>>>>>>>>>>> mlx5_vdpa_set_features(struct vdpa_device *vdev, u64
>>>>>>>>>>> features)
>>>>>>>>>>>      {
>>>>>>>>>>>          struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>>>>>>>>>>          struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>>>>>>>>>> -    int err;
>>>>>>>>>>>          print_features(mvdev, features, true);
>>>>>>>>>>> -    err = verify_min_features(mvdev, features);
>>>>>>>>>>> -    if (err)
>>>>>>>>>>> -        return err;
>>>>>>>>>>> -
>>>>>>>>>>>          ndev->mvdev.actual_features = features &
>>>>>>>>>>> ndev->mvdev.mlx_features;
>>>>>>>>>>>          ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>>>>>>>>>>>          ndev->config.status |= cpu_to_mlx5vdpa16(mvdev,
>>>>>>>>>>> VIRTIO_NET_S_LINK_UP);
>>>>>>>>>>> -    return err;
>>>>>>>>>>> +    return 0;
>>>>>>>>>>>      }
>>>>>>>>>>>      static void mlx5_vdpa_set_config_cb(struct vdpa_device
>>>>>>>>>>> *vdev, struct vdpa_callback *cb)

