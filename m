Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B40456B298
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiGHGQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHGQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:16:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C471D286C1
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 23:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657260964; x=1688796964;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4A/lMFVk6b14q7boRPa0U5OS+diwCwGhuXHyLDodAEQ=;
  b=Z65iepZL/jB/Il163nc+pPn+adLHKh1SWdMdbOTd76FyTne1j2SQisOS
   +pXaebXA0axgbJKEwaJRmFcikuANdzQf9vJ+gIWrw8ztmVeeA7Oaw8+N5
   FNLKVYPxpnz68n0z84pEZzYVBhsoxXxvVSbN2tEzx2ElXUWVQyNwNXQyL
   OQjGUahkImqGHNz7GyopYQIIL85TrImtpYgUbhbntWqcdsuiLVE/CVtyA
   3BmH8F3CI3yzfTQ+8xhpHI54K8ZULkErOJfYvywh2S1CaSkXsf7+HSGnf
   Yolv/gzXVg7G+430qio7rMrXkYc8m2QuNa8EqxxLe6j/oq9BRzcz90sax
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="267233298"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="267233298"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:16:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="920883996"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.210.36]) ([10.254.210.36])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:16:02 -0700
Message-ID: <bfd46eb1-bc82-b1c8-f492-7bcaaada8aa4@intel.com>
Date:   Fri, 8 Jul 2022 14:16:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
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
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/2022 6:02 AM, Parav Pandit wrote:
>
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 1, 2022 9:28 AM
>>
>> This commit adds a new vDPA netlink attribution
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features of vDPA devices through this new attr.
>>
>> Fixes: a64917bc2e9b vdpa: (Provide interface to read driver feature)
> Missing the "" in the line.
will fix
> I reviewed the patches again.
>
> However, this is not the fix.
> A fix cannot add a new UAPI.
I think we have discussed this, on why we can not re-name the existing 
wrong named attr, and why we can not re-use the attr.
So are you suggesting remove this fixes tag?
And why a fix can not add a new uAPI?
>
> Code is already considering negotiated driver features to return the device config space.
> Hence it is fine.
No, the spec says:
The device MUST allow reading of any device-specific configuration
field before FEATURES_OK is set by the driver.
>
> This patch intents to provide device features to user space.
> First what vdpa device are capable of, are already returned by features attribute on the management device.
> This is done in commit [1].
we have discussed this in another thread, vDPA device feature bits can 
be different from the management device feature bits.
>
> The only reason to have it is, when one management device indicates that feature is supported, but device may end up not supporting this feature if such feature is shared with other devices on same physical device.
> For example all VFs may not be symmetric after large number of them are in use. In such case features bit of management device can differ (more features) than the vdpa device of this VF.
> Hence, showing on the device is useful.
>
> As mentioned before in V2, commit [1] has wrongly named the attribute to VDPA_ATTR_DEV_SUPPORTED_FEATURES.
> It should have been, VDPA_ATTR_DEV_MGMTDEV_SUPPORTED_FEATURES.
> Because it is in UAPI, and since we don't want to break compilation of iproute2,
> It cannot be renamed anymore.
Yes, rename it will break current uAPI, so I can not rename it.
>
> Given that, we do not want to start trend of naming device attributes with additional _VDPA_ to it as done in this patch.
> Error in commit [1] was exception.
>
> Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return for device features too.
>
> Secondly, you need output example for showing device features in the commit log.
>
> 3rd, please drop the fixes tag as new capability is not a fix.
>
> [1] cd2629f6df1c ("vdpa: Support reporting max device capabilities ")
>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c       | 13 +++++++++----
>>   include/uapi/linux/vdpa.h |  1 +
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>> ebf2f363fbe7..9b0e39b2f022 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct
>> vdpa_device *vdev,  static int vdpa_dev_net_config_fill(struct vdpa_device
>> *vdev, struct sk_buff *msg)  {
>>   	struct virtio_net_config config = {};
>> -	u64 features;
>> +	u64 features_device, features_driver;
>>   	u16 val_u16;
>>
>>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config)); @@ -
>> 832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device
>> *vdev, struct sk_buff *ms
>>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>   		return -EMSGSIZE;
>>
>> -	features = vdev->config->get_driver_features(vdev);
>> -	if (nla_put_u64_64bit(msg,
>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>> +	features_driver = vdev->config->get_driver_features(vdev);
>> +	if (nla_put_u64_64bit(msg,
>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> +			      VDPA_ATTR_PAD))
>> +		return -EMSGSIZE;
>> +
>> +	features_device = vdev->config->get_device_features(vdev);
>> +	if (nla_put_u64_64bit(msg,
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
>> +features_device,
>>   			      VDPA_ATTR_PAD))
>>   		return -EMSGSIZE;
>>
>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>> +&config);
>>   }
>>
>>   static int
>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h index
>> 25c55cab3d7c..39f1c3d7c112 100644
>> --- a/include/uapi/linux/vdpa.h
>> +++ b/include/uapi/linux/vdpa.h
>> @@ -47,6 +47,7 @@ enum vdpa_attr {
>>   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>>   	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>>   	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
>> +	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
>>
>>   	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>   	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
>> --
>> 2.31.1

