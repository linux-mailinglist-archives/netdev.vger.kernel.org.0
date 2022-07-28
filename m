Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D75E5839B9
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbiG1HpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiG1HpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:45:19 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B2A13F31
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658994317; x=1690530317;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4PLRaN9ysIonkzrEvyWgRUgAz0nWrOsdRGashpmXLK8=;
  b=XPjkb7oMKVXeQmVluTiZXnTLCOhLZ84cWQK850/l+fqfq/AE8+V/D3aJ
   qHuhekk0bin/wjdCF+/LMUXX4P+zjoqzZ4gUz+SJ6Y0OP5ZO98YWWPNw9
   UHhqSSR0476Knhjx9gnUJ7Dmw6xtr7uEzwN/H7ExAPwTFDhS3DBdp96zD
   afAVUHmbXiRuwJIFIsVHzTQFP8Hq1YvWbI3ibfGU8caI0g2YLkTqWp7x6
   AsHzLOCmgyUII7Ewgqv4UsCQ3L2VSBC5dcpWY7dJtoHHqLPM6i04nHIOM
   I5QUxpuPxmwyUI9We6Ab/5an26rUOkdpdZdVKBIp8LKxDfr3L93/LIy5n
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="289642814"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="289642814"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 00:45:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="659596617"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.171]) ([10.255.30.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 00:44:57 -0700
Message-ID: <070d0099-405b-3517-3eab-c83b30906090@intel.com>
Date:   Thu, 28 Jul 2022 15:44:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Parav Pandit <parav@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00889067-50ac-d2cd-675f-748f171e5c83@oracle.com>
 <63242254-ba84-6810-dad8-34f900b97f2f@intel.com>
 <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
 <c8bd5396-84f2-e782-79d7-f493aca95781@redhat.com>
 <f3fd203d-a3ad-4c36-ddbc-01f061f4f99e@oracle.com>
 <CACGkMEtvVOtqAgY4Yzt_4=t8yfGJho4d9C=X8MQhW0ZKw1sDNA@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEtvVOtqAgY4Yzt_4=t8yfGJho4d9C=X8MQhW0ZKw1sDNA@mail.gmail.com>
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



On 7/28/2022 3:36 PM, Jason Wang wrote:
> On Thu, Jul 28, 2022 at 3:09 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 7/27/2022 7:06 PM, Jason Wang wrote:
>>> 在 2022/7/28 08:56, Si-Wei Liu 写道:
>>>>
>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>
>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>> Sorry to chime in late in the game. For some reason I couldn't get
>>>>>> to most emails for this discussion (I only subscribed to the
>>>>>> virtualization list), while I was taking off amongst the past few
>>>>>> weeks.
>>>>>>
>>>>>> It looks to me this patch is incomplete. Noted down the way in
>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>           features = vdev->config->get_driver_features(vdev);
>>>>>>           if (nla_put_u64_64bit(msg,
>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>                                 VDPA_ATTR_PAD))
>>>>>>                   return -EMSGSIZE;
>>>>>>
>>>>>> Making call to .get_driver_features() doesn't make sense when
>>>>>> feature negotiation isn't complete. Neither should present
>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>
>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill() probably
>>>>>> should not show before negotiation is done - it depends on driver
>>>>>> features negotiated.
>>>>> I have another patch in this series introduces device_features and
>>>>> will report device_features to the userspace even features
>>>>> negotiation not done. Because the spec says we should allow driver
>>>>> access the config space before FEATURES_OK.
>>>> The config space can be accessed by guest before features_ok doesn't
>>>> necessarily mean the value is valid.
>>>
>>> It's valid as long as the device offers the feature:
>>>
>>> "The device MUST allow reading of any device-specific configuration
>>> field before FEATURES_OK is set by the driver. This includes fields
>>> which are conditional on feature bits, as long as those feature bits
>>> are offered by the device."
>> I guess this statement only conveys that the field in config space can
>> be read before FEATURES_OK is set, though it does not *explicitly*
>> states the validity of field.
> My understanding is that it should be valid as long as the device
> offers the feature.
>
> For example, if _MQ is offered by device, the max_virt_queue_pairs is
> always valid and can be read from the driver no matter whether _MQ is
> negotiated.
agreed, that's also my understanding
>
>> And looking at:
>>
>> "The mac address field always exists (though is only valid if
>> VIRTIO_NET_F_MAC is set), and status only exists if VIRTIO_NET_F_STATUS
>> is set."
>>
>> It appears to me there's a border line set between "exist" and "valid".
>> If I understand the spec wording correctly, a spec-conforming device
>> implementation may or may not offer valid status value in the config
>> space when VIRTIO_NET_F_STATUS is offered, but before the feature is
>> negotiated.
> That's not what I read, maybe Michael can clarify this.
>
>> On the other hand, config space should contain valid mac
>> address the moment VIRTIO_NET_F_MAC feature is offered, regardless being
>> negotiated or not.
> I agree here.
>
>> By that, there seems to be leeway for the device
>> implementation to decide when config space field may become valid,
>> though for most of QEMU's software virtio devices, valid value is
>> present to config space the very first moment when feature is offered.
>>
>> "If the VIRTIO_NET_F_MAC feature bit is set, the configuration space mac
>> entry indicates the “physical” address of the network card, otherwise
>> the driver would typically generate a random local MAC address."
>> "If the VIRTIO_NET_F_STATUS feature bit is negotiated, the link status
>> comes from the bottom bit of status. Otherwise, the driver assumes it’s
>> active."
> This is mostly the way how drivers that don't support _F_STATUS work.
>
>> And also there are special cases where the read of specific
>> configuration space field MUST be deferred to until FEATURES_OK is set:
>>
>> "If the VIRTIO_BLK_F_CONFIG_WCE feature is negotiated, the cache mode
>> can be read or set through the writeback field. 0 corresponds to a
>> writethrough cache, 1 to a writeback cache11. The cache mode after reset
>> can be either writeback or writethrough. The actual mode can be
>> determined by reading writeback after feature negotiation."
>> "The driver MUST NOT read writeback before setting the FEATURES_OK
>> device status bit."
> This seems to conflict with the normatives I quoted above, and I don't
> get why we need this.
>
>> "If VIRTIO_BLK_F_CONFIG_WCE is negotiated but VIRTIO_BLK_F_FLUSH is not,
>> the device MUST initialize writeback to 0."
>>
>> Since the spec doesn't explicitly mandate the validity of each config
>> space field when feature of concern is offered, to be safer we'd have to
>> live with odd device implementation. I know for sure QEMU software
>> devices won't for 99% of these cases, but that's not what is currently
>> defined in the spec.
>>
>>>
>>>> You may want to double check with Michael for what he quoted earlier:
>>>>> Nope:
>>>>>
>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>
>>>>> ...
>>>>>
>>>>> For optional configuration space fields, the driver MUST check that
>>>>> the corresponding feature is offered
>>>>> before accessing that part of the configuration space.
>>>> and how many driver bugs taking wrong assumption of the validity of
>>>> config space field without features_ok. I am not sure what use case
>>>> you want to expose config resister values for before features_ok, if
>>>> it's mostly for live migration I guess it's probably heading a wrong
>>>> direction.
>>>
>>> I guess it's not for migration.
>> Then what's the other possible use case than live migration, were to
>> expose config space values? Troubleshooting config space discrepancy
>> between vDPA and the emulated virtio device in userspace? Or tracking
>> changes in config space across feature negotiation, but for what? It'd
>> be beneficial to the interface design if the specific use case can be
>> clearly described...
> Monitoring or debugging I guess.
>
> Thanks
>
>>
>>> For migration, a provision with the correct features/capability would
>>> be sufficient.
>> Right, that's what I thought too. It doesn't need to expose config space
>> values, simply exporting all attributes for vdpa device creation will do
>> the work.
>>
>> -Siwei
>>
>>> Thanks
>>>
>>>
>>>>
>>>>>>
>>>>>> Last but not the least, this "vdpa dev config" command was not
>>>>>> designed to display the real config space register values in the
>>>>>> first place. Quoting the vdpa-dev(8) man page:
>>>>>>
>>>>>>> vdpa dev config show - Show configuration of specific device or
>>>>>>> all devices.
>>>>>>> DEV - specifies the vdpa device to show its configuration. If this
>>>>>>> argument is omitted all devices configuration is listed.
>>>>>> It doesn't say anything about configuration space or register
>>>>>> values in config space. As long as it can convey the config
>>>>>> attribute when instantiating vDPA device instance, and more
>>>>>> importantly, the config can be easily imported from or exported to
>>>>>> userspace tools when trying to reconstruct vdpa instance intact on
>>>>>> destination host for live migration, IMHO in my personal
>>>>>> interpretation it doesn't matter what the config space may present.
>>>>>> It may be worth while adding a new debug command to expose the real
>>>>>> register value, but that's another story.
>>>>> I am not sure getting your points. vDPA now reports device feature
>>>>> bits(device_features) and negotiated feature bits(driver_features),
>>>>> and yes, the drivers features can be a subset of the device
>>>>> features; and the vDPA device features can be a subset of the
>>>>> management device features.
>>>> What I said is after unblocking the conditional check, you'd have to
>>>> handle the case for each of the vdpa attribute when feature
>>>> negotiation is not yet done: basically the register values you got
>>>> from config space via the vdpa_get_config_unlocked() call is not
>>>> considered to be valid before features_ok (per-spec). Although in
>>>> some case you may get sane value, such behavior is generally
>>>> undefined. If you desire to show just the device_features alone
>>>> without any config space field, which the device had advertised
>>>> *before feature negotiation is complete*, that'll be fine. But looks
>>>> to me this is not how patch has been implemented. Probably need some
>>>> more work?
>>>>
>>>> Regards,
>>>> -Siwei
>>>>
>>>>>> Having said, please consider to drop the Fixes tag, as appears to
>>>>>> me you're proposing a new feature rather than fixing a real issue.
>>>>> it's a new feature to report the device feature bits than only
>>>>> negotiated features, however this patch is a must, or it will block
>>>>> the device feature bits reporting. but I agree, the fix tag is not a
>>>>> must.
>>>>>> Thanks,
>>>>>> -Siwei
>>>>>>
>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>
>>>>>>>> Users may want to query the config space of a vDPA device, to
>>>>>>>> choose a
>>>>>>>> appropriate one for a certain guest. This means the users need to
>>>>>>>> read the
>>>>>>>> config space before FEATURES_OK, and the existence of config space
>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>
>>>>>>>> The spec says:
>>>>>>>> The device MUST allow reading of any device-specific
>>>>>>>> configuration field
>>>>>>>> before FEATURES_OK is set by the driver. This includes fields
>>>>>>>> which are
>>>>>>>> conditional on feature bits, as long as those feature bits are
>>>>>>>> offered by the
>>>>>>>> device.
>>>>>>>>
>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if
>>>>>>>> FEATURES_OK)
>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>
>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>> And
>>>>>>> It should be in format
>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if
>>>>>>> FEATURES_OK")
>>>>>>>
>>>>>>> Please use checkpatch.pl script before posting the patches to
>>>>>>> catch these errors.
>>>>>>> There is a bot that looks at the fixes tag and identifies the
>>>>>>> right kernel version to apply this fix.
>>>>>>>
>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>> ---
>>>>>>>>    drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>    1 file changed, 8 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>        u32 device_id;
>>>>>>>>        void *hdr;
>>>>>>>> -    u8 status;
>>>>>>>>        int err;
>>>>>>>>
>>>>>>>>        down_read(&vdev->cf_lock);
>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>> completed");
>>>>>>>> -        err = -EAGAIN;
>>>>>>>> -        goto out;
>>>>>>>> -    }
>>>>>>>> -
>>>>>>>>        hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>>>>>>>                  VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>        if (!hdr) {
>>>>>>>> --
>>>>>>>> 2.31.1
>>>>>>> _______________________________________________
>>>>>>> Virtualization mailing list
>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!Pkwym7OAjoDucUqs2fAwchxqL8-BGd6wOl-51xcgB_yCNwPJ_cs8A1y-cYmrLTB4OBNsimnZuqJPcvQIl3g$
>>>>>>

