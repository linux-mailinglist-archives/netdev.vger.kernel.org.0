Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06075952EB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiHPGr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiHPGrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:47:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369683122E;
        Mon, 15 Aug 2022 18:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660614568; x=1692150568;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zis7IsGuXYuOV3w4prl+9IMVvwGrLF2ieGGMLCuRCGc=;
  b=QXZO5t6NO5ggOMQJcQcxnZ4bWY697grVIFLWt4a7ZjNfXmOQNQZcNaK/
   InMBom2EB1pqx9GTyriUNPIMA33RdOxGjh2c99SYW779PP1KY7paGo1B1
   V0jD6ecrAJ6FzwVqzm/FTIEu14sQoLxry2/aq404UE2BXXI4kAFpra0EC
   IVnVN6ze/hxQDaRtE+RM3YshitAmNHq/NOEMNgpxpg23uSHu+AbkgQjU+
   AMZ2PShvchpnUYCfuG2CqFjdOQ1dRIeAIyYTeQlRc68k7+eLYYWBOGwRC
   KWv0L+IGR0y6mADDlt197FD0PYnoKkCBh7djOgeM57hCKFpiEuDEC98CC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="272492226"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="272492226"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 18:49:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="666894554"
Received: from zhaoxiny-mobl.ccr.corp.intel.com (HELO [10.255.29.22]) ([10.255.29.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 18:49:09 -0700
Message-ID: <cea494d0-d446-274f-f913-723822a53e6a@intel.com>
Date:   Tue, 16 Aug 2022 09:49:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-2-lingshan.zhu@intel.com>
 <15a9ba60-f6f5-f73a-8923-0d0513ea7d62@oracle.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <15a9ba60-f6f5-f73a-8923-0d0513ea7d62@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2022 2:15 AM, Si-Wei Liu wrote:
>
>
> On 8/15/2022 2:26 AM, Zhu Lingshan wrote:
>> This commit adds a new vDPA netlink attribution
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features of vDPA devices through this new attr.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c       | 17 +++++++++++++----
>>   include/uapi/linux/vdpa.h |  3 +++
>>   2 files changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index c06c02704461..efb55a06e961 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -491,6 +491,8 @@ static int vdpa_mgmtdev_fill(const struct 
>> vdpa_mgmt_dev *mdev, struct sk_buff *m
>>           err = -EMSGSIZE;
>>           goto msg_err;
>>       }
>> +
>> +    /* report features of a vDPA management device through 
>> VDPA_ATTR_DEV_SUPPORTED_FEATURES */
>>       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>>                     mdev->supported_features, VDPA_ATTR_PAD)) {
>>           err = -EMSGSIZE;
>> @@ -815,7 +817,7 @@ static int vdpa_dev_net_mq_config_fill(struct 
>> vdpa_device *vdev,
>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, 
>> struct sk_buff *msg)
>>   {
>>       struct virtio_net_config config = {};
>> -    u64 features;
>> +    u64 features_device, features_driver;
>>       u16 val_u16;
>>         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>> @@ -832,12 +834,19 @@ static int vdpa_dev_net_config_fill(struct 
>> vdpa_device *vdev, struct sk_buff *ms
>>       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>           return -EMSGSIZE;
>>   -    features = vdev->config->get_driver_features(vdev);
>> -    if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, 
>> features,
>> +    features_driver = vdev->config->get_driver_features(vdev);
>> +    if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, 
>> features_driver,
>> +                  VDPA_ATTR_PAD))
>> +        return -EMSGSIZE;
>> +
>> +    features_device = vdev->config->get_device_features(vdev);
>> +
>> +    /* report features of a vDPA device through 
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES */
>> +    if (nla_put_u64_64bit(msg, 
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>>                     VDPA_ATTR_PAD))
>>           return -EMSGSIZE;
>>   -    return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>> +    return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, 
>> &config);
>>   }
>>     static int
>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
>> index 25c55cab3d7c..d171b92ef522 100644
>> --- a/include/uapi/linux/vdpa.h
>> +++ b/include/uapi/linux/vdpa.h
>> @@ -46,7 +46,10 @@ enum vdpa_attr {
>>         VDPA_ATTR_DEV_NEGOTIATED_FEATURES,    /* u64 */
>>       VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,        /* u32 */
>> +    /* features of a vDPA management device */
>>       VDPA_ATTR_DEV_SUPPORTED_FEATURES,    /* u64 */
>> +    /* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
>> +    VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,    /* u64 */
> Append to the end, please. Otherwise it breaks userspace ABI.
OK, will fix it in V2
>
> -Siwei
>
>> VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>       VDPA_ATTR_DEV_VENDOR_ATTR_NAME,        /* string */
>

