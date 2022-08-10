Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AD058E4F7
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 04:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiHJCvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 22:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiHJCvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 22:51:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED97561D71
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 19:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660099870; x=1691635870;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=chagxXwvTKPx22NV6JHDK0wBoSTgAbeciCOFns/4z/o=;
  b=g/deeOXH6iRIaJQzdlopwlYJ8i+IYIJhiLjh+84Z/ZG5TbAGq7zsXvWc
   K9ywUgo+n+jPqm2mBmQ7msCZIAa/w6dzYzVSw6DziV8hGuALXsFd+OWyB
   ZVwDU+6Ij6CepCfjFnYLzdmgsd5VaC2y44dRhKk0eQEbJgfwiuP5dtfa6
   FHZQblmtew192DOzisIbONeB/FSDBVDweXRJ0KUKj0IiY1dvnfhe7zBMF
   vmFEFij1TMtTEdv06U0X92zUA0w71gJZMh2MG3d87FaKwmHWjs46vsOnI
   MGmP7TE8VyDNTMl4LOWP3n6FjBpkYvPNpPGsiTtcEKi2A7/JjIZWWwd3l
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="288547467"
X-IronPort-AV: E=Sophos;i="5.93,226,1654585200"; 
   d="scan'208";a="288547467"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 19:51:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,226,1654585200"; 
   d="scan'208";a="581052014"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.172.33]) ([10.249.172.33])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 19:51:08 -0700
Message-ID: <c0eee044-35bf-b48e-d0b2-7e152fd26f18@intel.com>
Date:   Wed, 10 Aug 2022 10:51:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
 <20220809152259-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220809152259-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/2022 3:24 AM, Michael S. Tsirkin wrote:
> On Fri, Jul 22, 2022 at 07:53:06PM +0800, Zhu Lingshan wrote:
>> This commit adds a new vDPA netlink attribution
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features of vDPA devices through this new attr.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>
> I think at least some discussion and documentation
> of this attribute versus VDPA_ATTR_DEV_SUPPORTED_FEATURES
> is called for.
>
> Otherwise how do people know which one to use?
>
> We can't send everyone to go read the lkml thread.
I will add comments in both this vdpa_dev_net_config_fill() and the 
header file.

Thanks,
Zhu Lingshan
>
>> ---
>>   drivers/vdpa/vdpa.c       | 13 +++++++++----
>>   include/uapi/linux/vdpa.h |  1 +
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index ebf2f363fbe7..9b0e39b2f022 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>>   {
>>   	struct virtio_net_config config = {};
>> -	u64 features;
>> +	u64 features_device, features_driver;
>>   	u16 val_u16;
>>   
>>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>> @@ -832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>   		return -EMSGSIZE;
>>   
>> -	features = vdev->config->get_driver_features(vdev);
>> -	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>> +	features_driver = vdev->config->get_driver_features(vdev);
>> +	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> +			      VDPA_ATTR_PAD))
>> +		return -EMSGSIZE;
>> +
>> +	features_device = vdev->config->get_device_features(vdev);
>> +	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>>   			      VDPA_ATTR_PAD))
>>   		return -EMSGSIZE;
>>   
>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>>   }
>>   
>>   static int
>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
>> index 25c55cab3d7c..39f1c3d7c112 100644
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

