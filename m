Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F2656B2B3
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiGHGWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbiGHGWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:22:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5817B2C109
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 23:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657261332; x=1688797332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+xcCqaDGt4/n5biucDVcC/ko31w3ssGfdyQYtdSak9Y=;
  b=MioPcnUGz7xvfXzkHpmOXuI/2KAsva5ryXYgzI4QglXSpnVVC8WeuEzw
   fIJn3bmgAHdu1+zJ8zBJhLb02lUBkOgp3wgXk+STNEyUG6zxoxPxseP0R
   e1Ni/IkKsYP6NSbBvs+dC7xtt2c1K/Dh33yodhOYVvgZ4xhxy86F8yotR
   zCxyug0oc0B2hbJ82LXF4sxDGqs/UAItUvlvkHFb+mB+JmxqIXV5B4Utf
   gUNGMqKFY3xne8IZb3RYLPlKfAcHtsWdrNUok3cojQSXdsD3A2+eRtl0P
   MqeeYFeJQnyWg2u72PGY4mH0w+DWQzJ1lXnqP17GLqz74gUvxD3/JLyHO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="264616146"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="264616146"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:22:06 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="920885532"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.210.36]) ([10.254.210.36])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:22:04 -0700
Message-ID: <733ee258-86e3-da9c-22af-fa1275f00593@intel.com>
Date:   Fri, 8 Jul 2022 14:22:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
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
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/2022 6:12 AM, Parav Pandit wrote:
>
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 1, 2022 9:28 AM
>>
>> Users may want to query the config space of a vDPA device, to choose a
>> appropriate one for a certain guest. This means the users need to read the
>> config space before FEATURES_OK, and the existence of config space
>> contents does not depend on FEATURES_OK.
>>
>> The spec says:
>> The device MUST allow reading of any device-specific configuration field
>> before FEATURES_OK is set by the driver. This includes fields which are
>> conditional on feature bits, as long as those feature bits are offered by the
>> device.
>>
>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if FEATURES_OK)
> Fix is fine, but fixes tag needs correction described below.
>
> Above commit id is 13 letters should be 12.
> And
> It should be in format
> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if FEATURES_OK")
>
> Please use checkpatch.pl script before posting the patches to catch these errors.
> There is a bot that looks at the fixes tag and identifies the right kernel version to apply this fix.
strange, checkpatch.pl did not complain this, I will fix this tag. Thanks
>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>> 9b0e39b2f022..d76b22b2f7ae 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>> struct sk_buff *msg, u32 portid,  {
>>   	u32 device_id;
>>   	void *hdr;
>> -	u8 status;
>>   	int err;
>>
>>   	down_read(&vdev->cf_lock);
>> -	status = vdev->config->get_status(vdev);
>> -	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>> -		NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>> completed");
>> -		err = -EAGAIN;
>> -		goto out;
>> -	}
>> -
>>   	hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>   			  VDPA_CMD_DEV_CONFIG_GET);
>>   	if (!hdr) {
>> --
>> 2.31.1

