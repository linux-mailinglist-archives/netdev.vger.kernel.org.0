Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE395BF5F3
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 07:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiIUFih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 01:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIUFif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 01:38:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F4A79612;
        Tue, 20 Sep 2022 22:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663738714; x=1695274714;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CsUIMOSfr+QS1OkYOwCSXOVoK/rP5JPExwLkeyrR1rg=;
  b=KDqFBlOvZIyRdjGJAbku1Ih8M9w3cFBrtoh24OkIXT0IkLV1Iw6JP84j
   Vh8+jPBjfRARjw1H+87Asw+NRSX531kMStqDGD3zOjZopRdRUMJUC1FG4
   5lGzfu+Jm7abzFofcPA0OU4bLNLYRBDa2bgJkCXPtdsURNv+tdV7rBUGA
   6eU5i4hiU7LKesMxDj6LaF+j4pzx6yb0dEvd139kjeNOsrNROyIfVpHu4
   vRwwpc14LShWU5KigXoTUoqq3kcMfKkCMzxATjNrBSRe+Jix+og03zK1o
   tp+LvhsUJetgVkbEN/0eRDfSye0jEMBtv10zk0TfsOU2S10DL8M+a1TtW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="361661522"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="361661522"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 22:38:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="681622019"
Received: from lihaitao-mobl.ccr.corp.intel.com (HELO [10.255.29.68]) ([10.255.29.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 22:38:32 -0700
Message-ID: <ed56a694-a024-23be-d4cb-7ab51c959b61@intel.com>
Date:   Wed, 21 Sep 2022 13:38:31 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEuusM3EMmWW6+q8V1fZscfjM2R9n7jGefUnSY59UnZDYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/2022 10:14 AM, Jason Wang wrote:
> On Tue, Sep 20, 2022 at 1:46 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 9/20/2022 10:16 AM, Jason Wang wrote:
>>> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>> vdpa_dev_net_config_fill() should only report driver features
>>>> to userspace after features negotiation is done.
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>    drivers/vdpa/vdpa.c | 13 +++++++++----
>>>>    1 file changed, 9 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>> index 798a02c7aa94..29d7e8858e6f 100644
>>>> --- a/drivers/vdpa/vdpa.c
>>>> +++ b/drivers/vdpa/vdpa.c
>>>> @@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>           struct virtio_net_config config = {};
>>>>           u64 features_device, features_driver;
>>>>           u16 val_u16;
>>>> +       u8 status;
>>>>
>>>>           vdev->config->get_config(vdev, 0, &config, sizeof(config));
>>>>
>>>> @@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>           if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>                   return -EMSGSIZE;
>>>>
>>>> -       features_driver = vdev->config->get_driver_features(vdev);
>>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>> -                             VDPA_ATTR_PAD))
>>>> -               return -EMSGSIZE;
>>>> +       /* only read driver features after the feature negotiation is done */
>>>> +       status = vdev->config->get_status(vdev);
>>>> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
>>> Any reason this is not checked in its caller as what it used to do before?
>> will check the existence of vdev->config->get_status before calling it in V2
> Just to clarify, I meant to check FEAUTRES_OK in the caller -
> vdpa_dev_config_fill() otherwise each type needs to repeat this in
> their specific codes.
if we check FEATURES_OK in the caller vdpa_dev_config_fill(), then
!FEATURES_OK will block reporting all attributions, for example
the device features and virtio device config space fields in this series 
and device status.
Currently only driver features needs to check FEATURES_OK.
Or did I missed anything?

Thanks
>
> Thanks
>
>> Thanks,
>> Zhu Lingshan
>>> Thanks
>>>
>>>> +               features_driver = vdev->config->get_driver_features(vdev);
>>>> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>> +                                     VDPA_ATTR_PAD))
>>>> +                       return -EMSGSIZE;
>>>> +       }
>>>>
>>>>           features_device = vdev->config->get_device_features(vdev);
>>>>
>>>> --
>>>> 2.31.1
>>>>

