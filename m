Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABD854C238
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbiFOGyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiFOGyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:54:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C9F2A948
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 23:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655276092; x=1686812092;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LvyYbHv3BETtaOMGH2vBXm5pBblI3/XKalpIMHtESws=;
  b=NFVEq0ujqKHZQS4C6G2KQ3z2biRUseS7mmAFc8rf31cWoHCECi+u3TYI
   0DjFjgsEZaTuT3ck6Nq83yV8zf2qv83fI6Tnac0seHkWfbMwqGCE1aNES
   9dDQAMTxlW8ryCihb8PI0BKBrRlbuS4nnTFHLFvwP0gJYJP36IZ4GHqAO
   PFWsvfxK03WwwkbIrYkX18OyCngJ8mkSdNx4Y/xgqfek8yhmoW7SxI4Qh
   +DjidkYyxlanAIeO7P37C8zeFACvvgeoKHK+LYY16JcIBN7UZnfyjWc+Y
   eKXf5UUjTGZXn/pE6Se2J9iHHN4+hMT4qadZZl34AMxg2vjeUJNFLHhf4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="279901155"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="279901155"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 23:54:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="911463703"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.212.27]) ([10.254.212.27])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 23:54:49 -0700
Message-ID: <b2c9df82-ad49-faad-c855-851de5c88a4c@intel.com>
Date:   Wed, 15 Jun 2022 14:54:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH V2 3/6] vDPA: allow userspace to query features of a vDPA
 device
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
 <20220613101652.195216-4-lingshan.zhu@intel.com>
 <PH0PR12MB548173EB919A97FF82E5E62BDCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <9ed635bf-1c92-f3c6-f6c6-5715a5a5ac92@intel.com>
 <PH0PR12MB54816E481633EEB9C24D4D5CDCAA9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54816E481633EEB9C24D4D5CDCAA9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/2022 2:38 AM, Parav Pandit wrote:
>
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Monday, June 13, 2022 10:53 PM
>>
>>
>> On 6/14/2022 4:42 AM, Parav Pandit wrote:
>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Monday, June 13, 2022 6:17 AM
>>>> device
>>>>
>>>> This commit adds a new vDPA netlink attribution
>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features
>>>> of vDPA devices through this new attr.
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>    drivers/vdpa/vdpa.c       | 13 +++++++++----
>>>>    include/uapi/linux/vdpa.h |  1 +
>>>>    2 files changed, 10 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>> ebf2f363fbe7..9b0e39b2f022 100644
>>>> --- a/drivers/vdpa/vdpa.c
>>>> +++ b/drivers/vdpa/vdpa.c
>>>> @@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct
>>>> vdpa_device *vdev,  static int vdpa_dev_net_config_fill(struct
>>>> vdpa_device *vdev, struct sk_buff *msg)  {
>>>>    	struct virtio_net_config config = {};
>>>> -	u64 features;
>>>> +	u64 features_device, features_driver;
>>>>    	u16 val_u16;
>>>>
>>>>    	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config)); @@ -
>>>> 832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct
>>>> vdpa_device *vdev, struct sk_buff *ms
>>>>    	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>    		return -EMSGSIZE;
>>>>
>>>> -	features = vdev->config->get_driver_features(vdev);
>>>> -	if (nla_put_u64_64bit(msg,
>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>> +	features_driver = vdev->config->get_driver_features(vdev);
>>>> +	if (nla_put_u64_64bit(msg,
>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>> +			      VDPA_ATTR_PAD))
>>>> +		return -EMSGSIZE;
>>>> +
>>>> +	features_device = vdev->config->get_device_features(vdev);
>>>> +	if (nla_put_u64_64bit(msg,
>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
>>>> +features_device,
>>>>    			      VDPA_ATTR_PAD))
>>>>    		return -EMSGSIZE;
>>>>
>>>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>>>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>>>> +&config);
>>>>    }
>>>>
>>>>    static int
>>>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
>>>> index
>>>> 25c55cab3d7c..39f1c3d7c112 100644
>>>> --- a/include/uapi/linux/vdpa.h
>>>> +++ b/include/uapi/linux/vdpa.h
>>>> @@ -47,6 +47,7 @@ enum vdpa_attr {
>>>>    	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>>>>    	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>>>>    	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
>>> I see now what was done incorrectly with commit cd2629f6df1ca.
>>>
>>> Above was done with wrong name prefix that missed MGMTDEV_. :(
>> Please
>>> don't add VDPA_ prefix due to one mistake.
>>> Please reuse this VDPA_ATTR_DEV_SUPPORTED_FEATURES for device
>> attribute as well.
>> currently we can reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to report
>> device features for sure, however this could confuse the readers since every
>> attr should has its own unique purpose.
> VDPA_ATTR_DEV_SUPPORTED_FEATURES is supposed to be VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES
> And device specific features is supposed to be named as,
> VDPA_ATTR_DEV_SUPPORTED_FEATURES.
Yes, that's the point and what I did in my V1 series, but you see if  we 
change original VDPA_ATTR_DEV_SUPPORTED_FEATURES to 
VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES, uAPI has been changed, so iproute2 
may work improperly.
> But it was not done this way in commit cd2629f6df1ca.
> This leads to the finding good name problem now.
>
> Given that this new attribute is going to show same or subset of the features of the management device supported features, it is fine to reuse with exception with explicit comment in the UAPI header file.
Currently I don't see any bugs can be caused by reuse the attr 
VDPA_ATTR_DEV_SUPPORTED_FEATURES.
However I really prefer to do defensive coding, introduce a new attr is 
not a big burden, its a common practice using a dedicated attr for an 
unique type of data, this can help us avoid potential bugs, and less 
confusion for other contributors.

VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES is still better than a ATTR2, but maybe it is not pretty enough, any better namings are more than welcome!!!!!


