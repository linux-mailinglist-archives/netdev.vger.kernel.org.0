Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57A05895B5
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 03:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbiHDBlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 21:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbiHDBlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 21:41:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406A5D0DD
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 18:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659577310; x=1691113310;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PUF/maUW1yI2WcnWVURVsP00+61ncH/7rYUltLCFML8=;
  b=W0e3DgEZVUPZCdvAdm38fbTIJrpwgHmo5GUTboQxXr/IosyrIWkJ5+cK
   2FZSJn2IU2FzNFK6gKpKdTJdN2+PWR3io7NTnqc/KStfo0tay4fDFatsI
   x4FyyN9g/yQMMWAJBPHGkqv8vlXeIrkrGRshhEOyU6/85OEbHEaSsQ8tu
   Skkngh0M9MmcOCOVsh+l+kJ16rMqrwdjCGFVVM9lAKqsilQVmmnimWQ04
   K2TV3S8D6XYEbGf2fMuPrXZPO5z5EnaeGno0X+TAyVJlvZXBOisK3KQXG
   avFoDiHVbKFDLeUw86CKzz1c8gszAG4fzeKmQiyObn6cxZ20AIUzgdjpW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="353814523"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="353814523"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 18:41:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="631378809"
Received: from jzhou17-mobl.ccr.corp.intel.com (HELO [10.249.169.141]) ([10.249.169.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 18:41:46 -0700
Message-ID: <bdb3015d-4836-5e1e-8cad-89f0b8f63ef9@intel.com>
Date:   Thu, 4 Aug 2022 09:41:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>
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
 <00e2e07e-1a2e-7af8-a060-cc9034e0d33f@intel.com>
 <b58dba25-3258-d600-ea06-879094639852@oracle.com>
 <c143e2da-208e-b046-9b8f-1780f75ed3e6@intel.com>
 <454bdf1b-daa1-aa67-2b8c-bc15351c1851@oracle.com>
 <f1c56fd6-7fa1-c2b8-83f4-4f0d68de86f4@redhat.com>
 <ec302cd4-3791-d648-aa00-28b1e97d75e7@oracle.com>
 <c77aa133-54ad-1578-aae3-031432cc9b36@oracle.com>
 <CACGkMEuUVicQX87PDCO87pckAg5EMQ9OGura2J35DaR0T=COfw@mail.gmail.com>
 <a2b2fe74-4633-2911-b953-25fcb8e81665@oracle.com>
 <213dec42-bd3d-2b5c-9003-276bc2a9f649@intel.com>
 <73b17906-fb89-5d92-ca31-ca21652b8335@oracle.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <73b17906-fb89-5d92-ca31-ca21652b8335@oracle.com>
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



On 8/4/2022 7:09 AM, Si-Wei Liu wrote:
>
>
> On 8/2/2022 7:30 PM, Zhu, Lingshan wrote:
>>
>>
>> On 8/3/2022 9:26 AM, Si-Wei Liu wrote:
>>>
>>>
>>> On 8/1/2022 11:33 PM, Jason Wang wrote:
>>>> On Tue, Aug 2, 2022 at 6:58 AM Si-Wei Liu <si-wei.liu@oracle.com> 
>>>> wrote:
>>>>>
>>>>>
>>>>> On 8/1/2022 3:53 PM, Si-Wei Liu wrote:
>>>>>>
>>>>>> On 7/31/2022 9:44 PM, Jason Wang wrote:
>>>>>>> 在 2022/7/30 04:55, Si-Wei Liu 写道:
>>>>>>>>
>>>>>>>> On 7/28/2022 7:04 PM, Zhu, Lingshan wrote:
>>>>>>>>>
>>>>>>>>> On 7/29/2022 5:48 AM, Si-Wei Liu wrote:
>>>>>>>>>>
>>>>>>>>>> On 7/27/2022 7:43 PM, Zhu, Lingshan wrote:
>>>>>>>>>>>
>>>>>>>>>>> On 7/28/2022 8:56 AM, Si-Wei Liu wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>>>>>>>>>> Sorry to chime in late in the game. For some reason I 
>>>>>>>>>>>>>> couldn't
>>>>>>>>>>>>>> get to most emails for this discussion (I only subscribed to
>>>>>>>>>>>>>> the virtualization list), while I was taking off amongst the
>>>>>>>>>>>>>> past few weeks.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> It looks to me this patch is incomplete. Noted down the 
>>>>>>>>>>>>>> way in
>>>>>>>>>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>>>>>>>>>           features = 
>>>>>>>>>>>>>> vdev->config->get_driver_features(vdev);
>>>>>>>>>>>>>>           if (nla_put_u64_64bit(msg,
>>>>>>>>>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>>>>>>>>> VDPA_ATTR_PAD))
>>>>>>>>>>>>>>                   return -EMSGSIZE;
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Making call to .get_driver_features() doesn't make sense 
>>>>>>>>>>>>>> when
>>>>>>>>>>>>>> feature negotiation isn't complete. Neither should present
>>>>>>>>>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill()
>>>>>>>>>>>>>> probably should not show before negotiation is done - it
>>>>>>>>>>>>>> depends on driver features negotiated.
>>>>>>>>>>>>> I have another patch in this series introduces 
>>>>>>>>>>>>> device_features
>>>>>>>>>>>>> and will report device_features to the userspace even 
>>>>>>>>>>>>> features
>>>>>>>>>>>>> negotiation not done. Because the spec says we should allow
>>>>>>>>>>>>> driver access the config space before FEATURES_OK.
>>>>>>>>>>>> The config space can be accessed by guest before features_ok
>>>>>>>>>>>> doesn't necessarily mean the value is valid. You may want to
>>>>>>>>>>>> double check with Michael for what he quoted earlier:
>>>>>>>>>>> that's why I proposed to fix these issues, e.g., if no _F_MAC,
>>>>>>>>>>> vDPA kernel should not return a mac to the userspace, there is
>>>>>>>>>>> not a default value for mac.
>>>>>>>>>> Then please show us the code, as I can only comment based on 
>>>>>>>>>> your
>>>>>>>>>> latest (v4) patch and it was not there.. To be honest, I don't
>>>>>>>>>> understand the motivation and the use cases you have, is it for
>>>>>>>>>> debugging/monitoring or there's really a use case for live
>>>>>>>>>> migration? For the former, you can do a direct dump on all 
>>>>>>>>>> config
>>>>>>>>>> space fields regardless of endianess and feature negotiation
>>>>>>>>>> without having to worry about validity (meaningful to present to
>>>>>>>>>> admin user). To me these are conflict asks that is impossible to
>>>>>>>>>> mix in exact one command.
>>>>>>>>> This bug just has been revealed two days, and you will see the
>>>>>>>>> patch soon.
>>>>>>>>>
>>>>>>>>> There are something to clarify:
>>>>>>>>> 1) we need to read the device features, or how can you pick a
>>>>>>>>> proper LM destination
>>>>>>>
>>>>>>> So it's probably not very efficient to use this, the manager layer
>>>>>>> should have the knowledge about the compatibility before doing
>>>>>>> migration other than try-and-fail.
>>>>>>>
>>>>>>> And it's the task of the management to gather the nodes whose 
>>>>>>> devices
>>>>>>> could be live migrated to each other as something like "cluster"
>>>>>>> which we've already used in the case of cpuflags.
>>>>>>>
>>>>>>> 1) during node bootstrap, the capability of each node and 
>>>>>>> devices was
>>>>>>> reported to management layer
>>>>>>> 2) management layer decide the cluster and make sure the migration
>>>>>>> can only done among the nodes insides the cluster
>>>>>>> 3) before migration, the vDPA needs to be provisioned on the 
>>>>>>> destination
>>>>>>>
>>>>>>>
>>>>>>>>> 2) vdpa dev config show can show both device features and driver
>>>>>>>>> features, there just need a patch for iproute2
>>>>>>>>> 3) To process information like MQ, we don't just dump the config
>>>>>>>>> space, MST has explained before
>>>>>>>> So, it's for live migration... Then why not export those config
>>>>>>>> parameters specified for vdpa creation (as well as device feature
>>>>>>>> bits) to the output of "vdpa dev show" command? That's where 
>>>>>>>> device
>>>>>>>> side config lives and is static across vdpa's life cycle. "vdpa 
>>>>>>>> dev
>>>>>>>> config show" is mostly for dynamic driver side config, and the
>>>>>>>> validity is subject to feature negotiation. I suppose this should
>>>>>>>> suit your need of LM, e.g.
>>>>>>>
>>>>>>> I think so.
>>>>>>>
>>>>>>>
>>>>>>>> $ vdpa dev add name vdpa1 mgmtdev pci/0000:41:04.2 max_vqp 7 
>>>>>>>> mtu 2000
>>>>>>>> $ vdpa dev show vdpa1
>>>>>>>> vdpa1: type network mgmtdev pci/0000:41:04.2 vendor_id 5555 
>>>>>>>> max_vqs
>>>>>>>> 15 max_vq_size 256
>>>>>>>>    max_vqp 7 mtu 2000
>>>>>>>>    dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS
>>>>>>>> CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>>>>>>>
>>>>>>> Note that the mgmt should know this destination have those
>>>>>>> capability/features before the provisioning.
>>>>>> Yes, mgmt software should have to check the above from source.
>>>>> On destination mgmt software can run below to check vdpa mgmtdev's
>>>>> capability/features:
>>>>>
>>>>> $ vdpa mgmtdev show pci/0000:41:04.3
>>>>> pci/0000:41:04.3:
>>>>>     supported_classes net
>>>>>     max_supported_vqs 257
>>>>>     dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS 
>>>>> CTRL_VQ
>>>>> MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>>>> Right and this is probably better to be done at node bootstrapping for
>>>> the management to know about the cluster.
>>> Exactly. That's what mgmt software is supposed to do typically.
>> I think this could apply to both mgmt devices and vDPA devices:
>> 1)mgmt device, see whether the mgmt device is capable to create a 
>> vDPA device with a certain feature bits, this is for LM
>> 2)vDPA device, report the device features, it is for normal operation
> Can you elaborate the use case "for normal operations"? Then it has 
> nothing to do with LM for sure, correct?
like when you just want to check the features to pick a proper device
>
> Noted for the LM case, just as Jason indicated, it's not even 
> *required* for the mgmt software to gather the device features through 
> "vdpa dev show" on source host *alive* right before live migration is 
> started. Depending on the way how it is implemented, the mgmt software 
> can well collect device capability on boot strap time, or may well 
> save the vdpa device capability/config in persistent store ahead of 
> time, say before any VM is to be launched. Then with all such info 
> collected for each cluster node, mgmt software is able to get its own 
> way to infer and sort out the live migration compatibility between 
> nodes. I'm not sure which case you would need to check the device 
> features, but in case you need it, it'd be better live in "vdpa dev 
> show" than "vdpa dev config show".
it is not only for LM
>
> Thanks,
> -Siwei
>
>>
>> Thanks,
>> Zhu Lingshan
>>>
>>> Thanks,
>>> -Siwei
>>>
>>>>
>>>> Thanks
>>>>
>>>>>>>
>>>>>>>> For it to work, you'd want to pass "struct vdpa_dev_set_config" to
>>>>>>>> _vdpa_register_device() during registration, and get it saved 
>>>>>>>> there
>>>>>>>> in "struct vdpa_device". Then in vdpa_dev_fill() show each field
>>>>>>>> conditionally subject to "struct vdpa_dev_set_config.mask".
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> -Siwei
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>> Zhu Lingshan
>>>>>>>>>>>>> Nope:
>>>>>>>>>>>>>
>>>>>>>>>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>>>>>>>>>
>>>>>>>>>>>>> ...
>>>>>>>>>>>>>
>>>>>>>>>>>>> For optional configuration space fields, the driver MUST 
>>>>>>>>>>>>> check
>>>>>>>>>>>>> that the corresponding feature is offered
>>>>>>>>>>>>> before accessing that part of the configuration space.
>>>>>>>>>>>> and how many driver bugs taking wrong assumption of the 
>>>>>>>>>>>> validity
>>>>>>>>>>>> of config space field without features_ok. I am not sure what
>>>>>>>>>>>> use case you want to expose config resister values for before
>>>>>>>>>>>> features_ok, if it's mostly for live migration I guess it's
>>>>>>>>>>>> probably heading a wrong direction.
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Last but not the least, this "vdpa dev config" command 
>>>>>>>>>>>>>> was not
>>>>>>>>>>>>>> designed to display the real config space register values in
>>>>>>>>>>>>>> the first place. Quoting the vdpa-dev(8) man page:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> vdpa dev config show - Show configuration of specific 
>>>>>>>>>>>>>>> device
>>>>>>>>>>>>>>> or all devices.
>>>>>>>>>>>>>>> DEV - specifies the vdpa device to show its 
>>>>>>>>>>>>>>> configuration. If
>>>>>>>>>>>>>>> this argument is omitted all devices configuration is 
>>>>>>>>>>>>>>> listed.
>>>>>>>>>>>>>> It doesn't say anything about configuration space or 
>>>>>>>>>>>>>> register
>>>>>>>>>>>>>> values in config space. As long as it can convey the config
>>>>>>>>>>>>>> attribute when instantiating vDPA device instance, and more
>>>>>>>>>>>>>> importantly, the config can be easily imported from or
>>>>>>>>>>>>>> exported to userspace tools when trying to reconstruct vdpa
>>>>>>>>>>>>>> instance intact on destination host for live migration, IMHO
>>>>>>>>>>>>>> in my personal interpretation it doesn't matter what the
>>>>>>>>>>>>>> config space may present. It may be worth while adding a new
>>>>>>>>>>>>>> debug command to expose the real register value, but that's
>>>>>>>>>>>>>> another story.
>>>>>>>>>>>>> I am not sure getting your points. vDPA now reports device
>>>>>>>>>>>>> feature bits(device_features) and negotiated feature
>>>>>>>>>>>>> bits(driver_features), and yes, the drivers features can be a
>>>>>>>>>>>>> subset of the device features; and the vDPA device 
>>>>>>>>>>>>> features can
>>>>>>>>>>>>> be a subset of the management device features.
>>>>>>>>>>>> What I said is after unblocking the conditional check, you'd
>>>>>>>>>>>> have to handle the case for each of the vdpa attribute when
>>>>>>>>>>>> feature negotiation is not yet done: basically the register
>>>>>>>>>>>> values you got from config space via the
>>>>>>>>>>>> vdpa_get_config_unlocked() call is not considered to be valid
>>>>>>>>>>>> before features_ok (per-spec). Although in some case you 
>>>>>>>>>>>> may get
>>>>>>>>>>>> sane value, such behavior is generally undefined. If you 
>>>>>>>>>>>> desire
>>>>>>>>>>>> to show just the device_features alone without any config 
>>>>>>>>>>>> space
>>>>>>>>>>>> field, which the device had advertised *before feature
>>>>>>>>>>>> negotiation is complete*, that'll be fine. But looks to me 
>>>>>>>>>>>> this
>>>>>>>>>>>> is not how patch has been implemented. Probably need some more
>>>>>>>>>>>> work?
>>>>>>>>>>> They are driver_features(negotiated) and the
>>>>>>>>>>> device_features(which comes with the device), and the config
>>>>>>>>>>> space fields that depend on them. In this series, we report 
>>>>>>>>>>> both
>>>>>>>>>>> to the userspace.
>>>>>>>>>> I fail to understand what you want to present from your
>>>>>>>>>> description. May be worth showing some example outputs that at
>>>>>>>>>> least include the following cases: 1) when device offers 
>>>>>>>>>> features
>>>>>>>>>> but not yet acknowledge by guest 2) when guest acknowledged
>>>>>>>>>> features and device is yet to accept 3) after guest feature
>>>>>>>>>> negotiation is completed (agreed upon between guest and device).
>>>>>>>>> Only two feature sets: 1) what the device has. (2) what is 
>>>>>>>>> negotiated
>>>>>>>>>> Thanks,
>>>>>>>>>> -Siwei
>>>>>>>>>>>> Regards,
>>>>>>>>>>>> -Siwei
>>>>>>>>>>>>
>>>>>>>>>>>>>> Having said, please consider to drop the Fixes tag, as 
>>>>>>>>>>>>>> appears
>>>>>>>>>>>>>> to me you're proposing a new feature rather than fixing a 
>>>>>>>>>>>>>> real
>>>>>>>>>>>>>> issue.
>>>>>>>>>>>>> it's a new feature to report the device feature bits than 
>>>>>>>>>>>>> only
>>>>>>>>>>>>> negotiated features, however this patch is a must, or it will
>>>>>>>>>>>>> block the device feature bits reporting. but I agree, the fix
>>>>>>>>>>>>> tag is not a must.
>>>>>>>>>>>>>> Thanks,
>>>>>>>>>>>>>> -Siwei
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>>>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Users may want to query the config space of a vDPA device,
>>>>>>>>>>>>>>>> to choose a
>>>>>>>>>>>>>>>> appropriate one for a certain guest. This means the users
>>>>>>>>>>>>>>>> need to read the
>>>>>>>>>>>>>>>> config space before FEATURES_OK, and the existence of 
>>>>>>>>>>>>>>>> config
>>>>>>>>>>>>>>>> space
>>>>>>>>>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The spec says:
>>>>>>>>>>>>>>>> The device MUST allow reading of any device-specific
>>>>>>>>>>>>>>>> configuration field
>>>>>>>>>>>>>>>> before FEATURES_OK is set by the driver. This includes
>>>>>>>>>>>>>>>> fields which are
>>>>>>>>>>>>>>>> conditional on feature bits, as long as those feature bits
>>>>>>>>>>>>>>>> are offered by the
>>>>>>>>>>>>>>>> device.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only
>>>>>>>>>>>>>>>> if FEATURES_OK)
>>>>>>>>>>>>>>> Fix is fine, but fixes tag needs correction described 
>>>>>>>>>>>>>>> below.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>>>>>>>>>> And
>>>>>>>>>>>>>>> It should be in format
>>>>>>>>>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration 
>>>>>>>>>>>>>>> only if
>>>>>>>>>>>>>>> FEATURES_OK")
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Please use checkpatch.pl script before posting the 
>>>>>>>>>>>>>>> patches to
>>>>>>>>>>>>>>> catch these errors.
>>>>>>>>>>>>>>> There is a bot that looks at the fixes tag and 
>>>>>>>>>>>>>>> identifies the
>>>>>>>>>>>>>>> right kernel version to apply this fix.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>    drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>>>>>>>>>    1 file changed, 8 deletions(-)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c 
>>>>>>>>>>>>>>>> index
>>>>>>>>>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>>>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>>>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>>>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct 
>>>>>>>>>>>>>>>> vdpa_device
>>>>>>>>>>>>>>>> *vdev,
>>>>>>>>>>>>>>>> struct sk_buff *msg, u32 portid, {
>>>>>>>>>>>>>>>>        u32 device_id;
>>>>>>>>>>>>>>>>        void *hdr;
>>>>>>>>>>>>>>>> -    u8 status;
>>>>>>>>>>>>>>>>        int err;
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> down_read(&vdev->cf_lock);
>>>>>>>>>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>>>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>>>>>>>>>> - NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>>>>>>>>>> completed");
>>>>>>>>>>>>>>>> -        err = -EAGAIN;
>>>>>>>>>>>>>>>> -        goto out;
>>>>>>>>>>>>>>>> -    }
>>>>>>>>>>>>>>>> -
>>>>>>>>>>>>>>>>        hdr = genlmsg_put(msg, portid, seq, 
>>>>>>>>>>>>>>>> &vdpa_nl_family,
>>>>>>>>>>>>>>>> flags,
>>>>>>>>>>>>>>>> VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>>>>>>>>>        if (!hdr) {
>>>>>>>>>>>>>>>> -- 
>>>>>>>>>>>>>>>> 2.31.1
>>>>>>>>>>>>>>> _______________________________________________
>>>>>>>>>>>>>>> Virtualization mailing list
>>>>>>>>>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>>>>>>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!NzOv5Ew_Z2CP-zHyD7RsUoStLZ54KpB21QyuZ8L63YVPLEGDEwvcOSDlIGxQPHY-DMkOa9sKKZdBSaNknMU$ 
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>
>>
>

