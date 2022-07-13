Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49EB572F7B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiGMHq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiGMHq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:46:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5424AE5DC1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657698386; x=1689234386;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ubFntTtAAMt96fiHItlMx6IW3IWwjnOg2cqFeliNvMk=;
  b=as+QH/z60w+T4wGZaiA/bGGPHTyhkveH9TF2+Pt7v94Ji/uplJmsgohU
   cjy6CLhcAUv8O1nwMj1UYuKVz9wJCYFIJPupWMxASA30BfdklZnQpldjS
   GYW8g3E2HHZJRCyLZiTuvwo7jEMdxMGnLAWQ7idD5RYBZTUnzVHMDhib2
   Qytusv0/5x/6yLEIB0EMEw63LUdxBpFE0lmfzyPc9xw7IfgWzLYV3A0mF
   YMh9ShhxQFBvJKa2F0rEWdgYJEF3SklTmnUnX6EvqvENh9ns3if5lx97M
   HMkhBtnX1zuoCqxhJQtdQoYE4zBZ6F4L0NRLyg07STX8ITvdyrvfG+hqT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="265551140"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="265551140"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:46:25 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="628205526"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.208.157]) ([10.254.208.157])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:46:23 -0700
Message-ID: <fd667dd2-0e06-b0a3-2b85-d5e4bbca5a31@intel.com>
Date:   Wed, 13 Jul 2022 15:46:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220713012048-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220713012048-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2022 1:23 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 01, 2022 at 10:12:49PM +0000, Parav Pandit wrote:
>>
>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>> Sent: Friday, July 1, 2022 9:28 AM
>>>
>>> Users may want to query the config space of a vDPA device, to choose a
>>> appropriate one for a certain guest. This means the users need to read the
>>> config space before FEATURES_OK, and the existence of config space
>>> contents does not depend on FEATURES_OK.
>>>
>>> The spec says:
>>> The device MUST allow reading of any device-specific configuration field
>>> before FEATURES_OK is set by the driver. This includes fields which are
> c> > conditional on feature bits, as long as those feature bits are offered by the
>>> device.
yes
>>>
>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if FEATURES_OK)
>> Fix is fine, but fixes tag needs correction described below.
>>
>> Above commit id is 13 letters should be 12.
>> And
>> It should be in format
>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if FEATURES_OK")
> Yea you normally use
>
> --format='Fixes: %h (\"%s\")'
Thanks, but I will drop this fix tag, since Parav suggest I drop the fix 
tag of the 3/6 patch which reporting device
feature bits to the upserspace(this fix is composed of several patches).
>
>
>> Please use checkpatch.pl script before posting the patches to catch these errors.
>> There is a bot that looks at the fixes tag and identifies the right kernel version to apply this fix.
>
> I don't think checkpatch complains about this if for no other reason
> that sometimes the 6 byte hash is not enough.
>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/vdpa.c | 8 --------
>>>   1 file changed, 8 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>> --- a/drivers/vdpa/vdpa.c
>>> +++ b/drivers/vdpa/vdpa.c
>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>>> struct sk_buff *msg, u32 portid,  {
>>>   	u32 device_id;
>>>   	void *hdr;
>>> -	u8 status;
>>>   	int err;
>>>
>>>   	down_read(&vdev->cf_lock);
>>> -	status = vdev->config->get_status(vdev);
>>> -	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>> -		NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>> completed");
>>> -		err = -EAGAIN;
>>> -		goto out;
>>> -	}
>>> -
>>>   	hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>>   			  VDPA_CMD_DEV_CONFIG_GET);
>>>   	if (!hdr) {
>>> --
>>> 2.31.1

