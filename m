Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DC0586396
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiHAEo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238845AbiHAEoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86EE913E29
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659329091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1bpBKSZDOVNREkqxskTmG4NhhxP3g1FX8PanNLMS2g0=;
        b=hOTpKNcNZrxeFWZ1WEjEkBjfVkdUY5OOfwA7A29PM//ezSOpIhSb8H/HBKuQwSP7g+Il5X
        renZMO8lBPG15Jd1ul6w04SLjdkFKSJi/GPhFlsDRPCOM/d5O2sOjqkdjhOD/ckyiWv8Dy
        LZynDYTRZ15eKNbjiq2/ew/DmvvWfes=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-BA5wi61zPESppJA3ie77Og-1; Mon, 01 Aug 2022 00:44:49 -0400
X-MC-Unique: BA5wi61zPESppJA3ie77Og-1
Received: by mail-pj1-f72.google.com with SMTP id h1-20020a17090a298100b001f4e5d3a522so2024034pjd.5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1bpBKSZDOVNREkqxskTmG4NhhxP3g1FX8PanNLMS2g0=;
        b=BMLkoEQrkdJUaiA+11bzevSmFCCyVwrPEIWlsTn6BtlkC3MJ73v3XX93StuPwXjnLT
         Bk+RPw1H0gSvCRcX3aXAVJHm9m/8qqhrUt03celJHHRIv9M8/jbKuhJ1k2fmUP7rVMLr
         iKn6R5i4qHLN5nZqyJEWtaG1beopylSTlDn4SdhukqYPeUhlRDI+1eWnMQ72pxplaVWc
         HjBiDCJC8jVQQLbZkSTmkjmHzlXYpU7DgB0XvwU+Uno7AZKryy94Z0gn2lVX0OwynqEN
         SWs2vpiRdd/Outqwk7V9XArTywV/0892pK1EE+PUAAvz1EcNM8Po5z4egmUiLIUnJGtk
         ITYg==
X-Gm-Message-State: AJIora/CugYn9vcLNDDpnzaQlUaehbr+UKxo34N56jyjN86D5Pyd3rBr
        ZpvAJvYlwF+xjmq7KutjTdT+Gt/9mJm3hfj/1i6jyi7baGfWLIVyS1lEe+uf8Uvo81i7M21UkHM
        dVoP734rriHcNPMif
X-Received: by 2002:a05:6a00:21c2:b0:52b:ff44:666a with SMTP id t2-20020a056a0021c200b0052bff44666amr14397210pfj.83.1659329088091;
        Sun, 31 Jul 2022 21:44:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s0Dr+mWU3m4L8Y5H8r7n7HHXFLAGW8DTkPEnGT9cMTo3fj5mgvHDdj3ovf+7eT2RNh8Av13w==
X-Received: by 2002:a05:6a00:21c2:b0:52b:ff44:666a with SMTP id t2-20020a056a0021c200b0052bff44666amr14397193pfj.83.1659329087739;
        Sun, 31 Jul 2022 21:44:47 -0700 (PDT)
Received: from [10.72.13.139] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b0016edb59f670sm2813156plb.6.2022.07.31.21.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 21:44:47 -0700 (PDT)
Message-ID: <f1c56fd6-7fa1-c2b8-83f4-4f0d68de86f4@redhat.com>
Date:   Mon, 1 Aug 2022 12:44:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <454bdf1b-daa1-aa67-2b8c-bc15351c1851@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/30 04:55, Si-Wei Liu 写道:
>
>
> On 7/28/2022 7:04 PM, Zhu, Lingshan wrote:
>>
>>
>> On 7/29/2022 5:48 AM, Si-Wei Liu wrote:
>>>
>>>
>>> On 7/27/2022 7:43 PM, Zhu, Lingshan wrote:
>>>>
>>>>
>>>> On 7/28/2022 8:56 AM, Si-Wei Liu wrote:
>>>>>
>>>>>
>>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>>
>>>>>>
>>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>>> Sorry to chime in late in the game. For some reason I couldn't 
>>>>>>> get to most emails for this discussion (I only subscribed to the 
>>>>>>> virtualization list), while I was taking off amongst the past 
>>>>>>> few weeks.
>>>>>>>
>>>>>>> It looks to me this patch is incomplete. Noted down the way in 
>>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>>          features = vdev->config->get_driver_features(vdev);
>>>>>>>          if (nla_put_u64_64bit(msg, 
>>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>>                                VDPA_ATTR_PAD))
>>>>>>>                  return -EMSGSIZE;
>>>>>>>
>>>>>>> Making call to .get_driver_features() doesn't make sense when 
>>>>>>> feature negotiation isn't complete. Neither should present 
>>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>>
>>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill() 
>>>>>>> probably should not show before negotiation is done - it depends 
>>>>>>> on driver features negotiated.
>>>>>> I have another patch in this series introduces device_features 
>>>>>> and will report device_features to the userspace even features 
>>>>>> negotiation not done. Because the spec says we should allow 
>>>>>> driver access the config space before FEATURES_OK.
>>>>> The config space can be accessed by guest before features_ok 
>>>>> doesn't necessarily mean the value is valid. You may want to 
>>>>> double check with Michael for what he quoted earlier:
>>>> that's why I proposed to fix these issues, e.g., if no _F_MAC, vDPA 
>>>> kernel should not return a mac to the userspace, there is not a 
>>>> default value for mac.
>>> Then please show us the code, as I can only comment based on your 
>>> latest (v4) patch and it was not there.. To be honest, I don't 
>>> understand the motivation and the use cases you have, is it for 
>>> debugging/monitoring or there's really a use case for live 
>>> migration? For the former, you can do a direct dump on all config 
>>> space fields regardless of endianess and feature negotiation without 
>>> having to worry about validity (meaningful to present to admin 
>>> user). To me these are conflict asks that is impossible to mix in 
>>> exact one command.
>> This bug just has been revealed two days, and you will see the patch 
>> soon.
>>
>> There are something to clarify:
>> 1) we need to read the device features, or how can you pick a proper 
>> LM destination


So it's probably not very efficient to use this, the manager layer 
should have the knowledge about the compatibility before doing migration 
other than try-and-fail.

And it's the task of the management to gather the nodes whose devices 
could be live migrated to each other as something like "cluster" which 
we've already used in the case of cpuflags.

1) during node bootstrap, the capability of each node and devices was 
reported to management layer
2) management layer decide the cluster and make sure the migration can 
only done among the nodes insides the cluster
3) before migration, the vDPA needs to be provisioned on the destination


>> 2) vdpa dev config show can show both device features and driver 
>> features, there just need a patch for iproute2
>> 3) To process information like MQ, we don't just dump the config 
>> space, MST has explained before
> So, it's for live migration... Then why not export those config 
> parameters specified for vdpa creation (as well as device feature 
> bits) to the output of "vdpa dev show" command? That's where device 
> side config lives and is static across vdpa's life cycle. "vdpa dev 
> config show" is mostly for dynamic driver side config, and the 
> validity is subject to feature negotiation. I suppose this should suit 
> your need of LM, e.g.


I think so.


>
> $ vdpa dev add name vdpa1 mgmtdev pci/0000:41:04.2 max_vqp 7 mtu 2000
> $ vdpa dev show vdpa1
> vdpa1: type network mgmtdev pci/0000:41:04.2 vendor_id 5555 max_vqs 15 
> max_vq_size 256
>   max_vqp 7 mtu 2000
>   dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ 
> MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED


Note that the mgmt should know this destination have those 
capability/features before the provisioning.


>
> For it to work, you'd want to pass "struct vdpa_dev_set_config" to 
> _vdpa_register_device() during registration, and get it saved there in 
> "struct vdpa_device". Then in vdpa_dev_fill() show each field 
> conditionally subject to "struct vdpa_dev_set_config.mask".
>
> Thanks,
> -Siwei


Thanks


>>
>> Thanks
>> Zhu Lingshan
>>>
>>>>>> Nope:
>>>>>>
>>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>>
>>>>>> ...
>>>>>>
>>>>>> For optional configuration space fields, the driver MUST check 
>>>>>> that the corresponding feature is offered
>>>>>> before accessing that part of the configuration space.
>>>>>
>>>>> and how many driver bugs taking wrong assumption of the validity 
>>>>> of config space field without features_ok. I am not sure what use 
>>>>> case you want to expose config resister values for before 
>>>>> features_ok, if it's mostly for live migration I guess it's 
>>>>> probably heading a wrong direction.
>>>>>
>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Last but not the least, this "vdpa dev config" command was not 
>>>>>>> designed to display the real config space register values in the 
>>>>>>> first place. Quoting the vdpa-dev(8) man page:
>>>>>>>
>>>>>>>> vdpa dev config show - Show configuration of specific device or 
>>>>>>>> all devices.
>>>>>>>> DEV - specifies the vdpa device to show its configuration. If 
>>>>>>>> this argument is omitted all devices configuration is listed.
>>>>>>> It doesn't say anything about configuration space or register 
>>>>>>> values in config space. As long as it can convey the config 
>>>>>>> attribute when instantiating vDPA device instance, and more 
>>>>>>> importantly, the config can be easily imported from or exported 
>>>>>>> to userspace tools when trying to reconstruct vdpa instance 
>>>>>>> intact on destination host for live migration, IMHO in my 
>>>>>>> personal interpretation it doesn't matter what the config space 
>>>>>>> may present. It may be worth while adding a new debug command to 
>>>>>>> expose the real register value, but that's another story.
>>>>>> I am not sure getting your points. vDPA now reports device 
>>>>>> feature bits(device_features) and negotiated feature 
>>>>>> bits(driver_features), and yes, the drivers features can be a 
>>>>>> subset of the device features; and the vDPA device features can 
>>>>>> be a subset of the management device features.
>>>>> What I said is after unblocking the conditional check, you'd have 
>>>>> to handle the case for each of the vdpa attribute when feature 
>>>>> negotiation is not yet done: basically the register values you got 
>>>>> from config space via the vdpa_get_config_unlocked() call is not 
>>>>> considered to be valid before features_ok (per-spec). Although in 
>>>>> some case you may get sane value, such behavior is generally 
>>>>> undefined. If you desire to show just the device_features alone 
>>>>> without any config space field, which the device had advertised 
>>>>> *before feature negotiation is complete*, that'll be fine. But 
>>>>> looks to me this is not how patch has been implemented. Probably 
>>>>> need some more work?
>>>> They are driver_features(negotiated) and the device_features(which 
>>>> comes with the device), and the config space fields that depend on 
>>>> them. In this series, we report both to the userspace.
>>> I fail to understand what you want to present from your description. 
>>> May be worth showing some example outputs that at least include the 
>>> following cases: 1) when device offers features but not yet 
>>> acknowledge by guest 2) when guest acknowledged features and device 
>>> is yet to accept 3) after guest feature negotiation is completed 
>>> (agreed upon between guest and device).
>> Only two feature sets: 1) what the device has. (2) what is negotiated
>>>
>>> Thanks,
>>> -Siwei
>>>>>
>>>>> Regards,
>>>>> -Siwei
>>>>>
>>>>>>>
>>>>>>> Having said, please consider to drop the Fixes tag, as appears 
>>>>>>> to me you're proposing a new feature rather than fixing a real 
>>>>>>> issue.
>>>>>> it's a new feature to report the device feature bits than only 
>>>>>> negotiated features, however this patch is a must, or it will 
>>>>>> block the device feature bits reporting. but I agree, the fix tag 
>>>>>> is not a must.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> -Siwei
>>>>>>>
>>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>>
>>>>>>>>> Users may want to query the config space of a vDPA device, to 
>>>>>>>>> choose a
>>>>>>>>> appropriate one for a certain guest. This means the users need 
>>>>>>>>> to read the
>>>>>>>>> config space before FEATURES_OK, and the existence of config 
>>>>>>>>> space
>>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>>
>>>>>>>>> The spec says:
>>>>>>>>> The device MUST allow reading of any device-specific 
>>>>>>>>> configuration field
>>>>>>>>> before FEATURES_OK is set by the driver. This includes fields 
>>>>>>>>> which are
>>>>>>>>> conditional on feature bits, as long as those feature bits are 
>>>>>>>>> offered by the
>>>>>>>>> device.
>>>>>>>>>
>>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if 
>>>>>>>>> FEATURES_OK)
>>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>>
>>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>>> And
>>>>>>>> It should be in format
>>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if 
>>>>>>>> FEATURES_OK")
>>>>>>>>
>>>>>>>> Please use checkpatch.pl script before posting the patches to 
>>>>>>>> catch these errors.
>>>>>>>> There is a bot that looks at the fixes tag and identifies the 
>>>>>>>> right kernel version to apply this fix.
>>>>>>>>
>>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>> ---
>>>>>>>>>   drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>>   1 file changed, 8 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device 
>>>>>>>>> *vdev,
>>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>>       u32 device_id;
>>>>>>>>>       void *hdr;
>>>>>>>>> -    u8 status;
>>>>>>>>>       int err;
>>>>>>>>>
>>>>>>>>>       down_read(&vdev->cf_lock);
>>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>>> completed");
>>>>>>>>> -        err = -EAGAIN;
>>>>>>>>> -        goto out;
>>>>>>>>> -    }
>>>>>>>>> -
>>>>>>>>>       hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>>>>>>>>                 VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>>       if (!hdr) {
>>>>>>>>> -- 
>>>>>>>>> 2.31.1
>>>>>>>> _______________________________________________
>>>>>>>> Virtualization mailing list
>>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>

