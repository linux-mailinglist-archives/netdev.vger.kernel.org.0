Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FC75BF852
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiIUHx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiIUHxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:53:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AE486712;
        Wed, 21 Sep 2022 00:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663746813; x=1695282813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nRL2/lRbiSr1qmkqOITf2ajJb1l0W8gM8a7M1/m71vs=;
  b=eyppgj5S21yzdp5UoIs79ibDrgnXckXDy1bNCJnuiKSNNKQQ86NQt2mL
   ywQx4FUODjwOVOaMGmb6zP73u/+hLPxhBDGgIYA9giitcYZS5oyTeAnwr
   PdvVylgSGvpHB76Da2wXLH+So0F5KZ0vZG2I6HlygbR1Wsgq4roePUS6p
   e6YUHicNlk3f0W5NdrT9+fZccFENZFHnkezpFAi3vJlw+RxAmooh38e6l
   MQOk28CQpRNkG/xgEc9jeGebta/OFKma3+qFo1pgJV4FUu3VM9kg0OiY0
   bCPxU9PZnDelRYrr0m1zgi87SqUByFxzp22Na5UUqGuoGaQry1NG+Le/t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="298651209"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="298651209"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 00:53:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="596867586"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.29.68]) ([10.255.29.68])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 00:53:30 -0700
Message-ID: <92b2ede9-8d3a-a574-d4d5-d52504c553f6@intel.com>
Date:   Wed, 21 Sep 2022 15:53:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH 2/4] vDPA: only report driver features if FEATURES_OK is
 set
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-3-lingshan.zhu@intel.com>
 <CACGkMEsYARr3toEBTxVcwFi86JxK0D-w4OpNtvVdhCEbAnc8ZA@mail.gmail.com>
 <6fd1f8b3-23b1-84cc-2376-ee04f1fa8438@intel.com>
 <CACGkMEuusM3EMmWW6+q8V1fZscfjM2R9n7jGefUnSY59UnZDYQ@mail.gmail.com>
 <ed56a694-a024-23be-d4cb-7ab51c959b61@intel.com>
 <CACGkMEuXA6Uj7OHqUDux=Yz+XFtouKWGOVV4fk5B5XCZW5F22w@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEuXA6Uj7OHqUDux=Yz+XFtouKWGOVV4fk5B5XCZW5F22w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/2022 3:43 PM, Jason Wang wrote:
> On Wed, Sep 21, 2022 at 1:39 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 9/21/2022 10:14 AM, Jason Wang wrote:
>>> On Tue, Sep 20, 2022 at 1:46 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>>>
>>>> On 9/20/2022 10:16 AM, Jason Wang wrote:
>>>>> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>>>> vdpa_dev_net_config_fill() should only report driver features
>>>>>> to userspace after features negotiation is done.
>>>>>>
>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> ---
>>>>>>     drivers/vdpa/vdpa.c | 13 +++++++++----
>>>>>>     1 file changed, 9 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>>>> index 798a02c7aa94..29d7e8858e6f 100644
>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>> @@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>>>            struct virtio_net_config config = {};
>>>>>>            u64 features_device, features_driver;
>>>>>>            u16 val_u16;
>>>>>> +       u8 status;
>>>>>>
>>>>>>            vdev->config->get_config(vdev, 0, &config, sizeof(config));
>>>>>>
>>>>>> @@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>>>            if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>>                    return -EMSGSIZE;
>>>>>>
>>>>>> -       features_driver = vdev->config->get_driver_features(vdev);
>>>>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>>>> -                             VDPA_ATTR_PAD))
>>>>>> -               return -EMSGSIZE;
>>>>>> +       /* only read driver features after the feature negotiation is done */
>>>>>> +       status = vdev->config->get_status(vdev);
>>>>>> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
>>>>> Any reason this is not checked in its caller as what it used to do before?
>>>> will check the existence of vdev->config->get_status before calling it in V2
>>> Just to clarify, I meant to check FEAUTRES_OK in the caller -
>>> vdpa_dev_config_fill() otherwise each type needs to repeat this in
>>> their specific codes.
>> if we check FEATURES_OK in the caller vdpa_dev_config_fill(), then
>> !FEATURES_OK will block reporting all attributions, for example
>> the device features and virtio device config space fields in this series
>> and device status.
>> Currently only driver features needs to check FEATURES_OK.
>> Or did I missed anything?
> I don't see much difference, we just move the following part to the
> caller, it is not the config but the VDPA_ATTR_DEV_NEGOTIATED_FEATURES
> is blocked.
OK, I get you. V2 will check FEATURES_OK and report driver features in 
vdpa_dev_config_fill()

Thanks
Zhu Lingshan
>
> Thanks
>
>> Thanks
>>> Thanks
>>>
>>>> Thanks,
>>>> Zhu Lingshan
>>>>> Thanks
>>>>>
>>>>>> +               features_driver = vdev->config->get_driver_features(vdev);
>>>>>> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>>>> +                                     VDPA_ATTR_PAD))
>>>>>> +                       return -EMSGSIZE;
>>>>>> +       }
>>>>>>
>>>>>>            features_device = vdev->config->get_device_features(vdev);
>>>>>>
>>>>>> --
>>>>>> 2.31.1
>>>>>>

