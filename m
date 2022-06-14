Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BAE54A736
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiFNC7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355400AbiFNC6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:58:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D3F19289
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 19:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655175239; x=1686711239;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GbG9fbAGCXKTlxJuIqx1GeFqpNZt991yZEfhCOjWYLs=;
  b=IqJG/yvvccwm+vTCfApMOUNtQ5q4HokDFjC3Oy4UWvxcw15noU+wsU+X
   imW1GAbygmNawYVMokCzqYzh6X8KefnudAZYUUWyJI5pI8HiMHJ5xEtZh
   r/w1fQpffqHvupuBsvu364plQgoZE5ZwBKg+RKulo88VLaULr7xCa4a8d
   L5sAhvgbHZ+U0ZiN/dFj2JsS5MwHsZwBF2+BKZKNHY7Q7NP9DMC1UfFtU
   kJbzlAMQK7+Ic497LuvAhtVsTNP2s6P1EVUL7mSvA98TUzW6Xo0OyxjSk
   ATT0ptfODWXWn+o4tyoV7Q3dJiExq1WffrPYBd6As2VWpf8IZIE4pcXbe
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="276016375"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="276016375"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:53:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="910723973"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.211.167]) ([10.254.211.167])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:53:57 -0700
Message-ID: <25b0b924-14ec-496d-b986-65b3b4e224d5@intel.com>
Date:   Tue, 14 Jun 2022 10:53:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH V2 4/6] vDPA: !FEATURES_OK should not block querying
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
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
 <20220613101652.195216-5-lingshan.zhu@intel.com>
 <PH0PR12MB54816C51011A667F25C4FF7ADCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54816C51011A667F25C4FF7ADCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/2022 4:31 AM, Parav Pandit wrote:
>
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Monday, June 13, 2022 6:17 AM
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
> Management interface should not mix up the device state machine checks like above.
> Hence above code removal is better choice.
> Please add fixes tag to this patch.
will do, thanks for your review

Thanks,
Zhu Lingshan
>
> Reviewed-by: Parav Pandit <parav@nvidia.com>

