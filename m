Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F43657EF05
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 13:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbiGWLXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 07:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiGWLXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 07:23:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C6A3FA23
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 04:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658575422; x=1690111422;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NlZVYDNj0DSnWQTwr/ZHVNBf+NuPAPbumf0LfV1CHoE=;
  b=AqvWfOByqgEitCgnWayLGw1EW24/5RVcryGoWcNoGATF+rP10CI6utV4
   as0Aw2OTiqAhD+OQv3ay5itGvVv5+RD/LMQSkVgus6Gq/B1bvAkruYG3q
   n9ig7AQF4hyIfxx38b9Gz9lW7R/2zqXGe7sOGd8sJ1UN1aKH988YCcv7T
   5dgDcxv3NmQ6eOW6Yv4z/KMSa5X085CTqA6wp/wvYQDxvQDMlPJ+2nnMj
   EGkJxtt/6WQhfV7kyz4nBhutvG+J0R4cRJ4n/kP2ytOM5ir+pWZ4bOQjb
   SHAlW6sYlegX6M1rF5KNGiRs4EMWpRXbvMFH1lEtwBSW8dtgww5MkdrRa
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="313199330"
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="313199330"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 04:23:41 -0700
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="657529796"
Received: from qianyuwa-mobl2.ccr.corp.intel.com (HELO [10.249.169.178]) ([10.249.169.178])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 04:23:39 -0700
Message-ID: <6dc2229c-f2f3-017f-16fa-4611e53c774e@intel.com>
Date:   Sat, 23 Jul 2022 19:23:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
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
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
 <PH0PR12MB548193156AFCA04F58B01A3CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB548193156AFCA04F58B01A3CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/2022 9:12 PM, Parav Pandit wrote:
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 22, 2022 7:53 AM
>>
>> This commit adds a new vDPA netlink attribution
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features of vDPA devices through this new attr.
>>
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
> I have answered in previous emails.
> I disagree with the change.
> Please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES.
I believe we have already discussed this before in the V3 thread.
I have told you that reusing this attr will lead to a new race condition.

Pleas refer to the previous thread, and you did not answer my questions 
in that thread.

Thanks,
Zhu Lingshan
>
> MST,
> I nack this patch.
> As mentioned in the previous versions, also it is missing the example output in the commit log.
> Please include example output.
>
>>   	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>   	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
>> --
>> 2.31.1

