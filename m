Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B7656D2EB
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 04:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGKCS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 22:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKCS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 22:18:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C744595A5
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 19:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657505937; x=1689041937;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q46wZQglv9QTkr9wAQrqh/TnfC7Lo/AEBp46K7fnid0=;
  b=FdD78NI4ddX/08HJn6xu58dkApzm2qO7ogCXzZviUkS6q9lseRZUff4X
   IbtXdPvWl8E+l/+h+D+LHkKKPaXjZfgjQTDoBFT6OaQfHtLsrl+U0U4lb
   968k1oDdxKQTNNTzJSBxl9msfI7WJZPTLqezynUD/aqYL+ZjERgC+sz//
   2uHyJ7SQdqLjb5Sjy9tZKybBySMlrsS3N+D1udxdhFQKGv1fCXc9sF5xw
   FEjh7+95ybEVjySzmeA5QxbFR0fmgt+6hw7aOmDmLJz+vaSb+H67FYK9b
   crD/13qQybhyjXtwpKhMWAu+XsHiB5czFXPV/MSEUm8/NIblDfwnqil6v
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="285303917"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="285303917"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 19:18:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="544839632"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.215.78]) ([10.254.215.78])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 19:18:55 -0700
Message-ID: <cbbb0341-5383-0e64-1ab8-52289869a233@intel.com>
Date:   Mon, 11 Jul 2022 10:18:53 +0800
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
 <bfd46eb1-bc82-b1c8-f492-7bcaaada8aa4@intel.com>
 <PH0PR12MB54816D143AAB834616FAEF67DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54816D143AAB834616FAEF67DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/2022 12:13 AM, Parav Pandit wrote:
>
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 8, 2022 2:16 AM
>>
>> On 7/2/2022 6:02 AM, Parav Pandit wrote:
>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>
>>>> This commit adds a new vDPA netlink attribution
>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features
>>>> of vDPA devices through this new attr.
>>>>
>>>> Fixes: a64917bc2e9b vdpa: (Provide interface to read driver feature)
>>> Missing the "" in the line.
>> will fix
>>> I reviewed the patches again.
>>>
>>> However, this is not the fix.
>>> A fix cannot add a new UAPI.
>> I think we have discussed this, on why we can not re-name the existing
>> wrong named attr, and why we can not re-use the attr.
>> So are you suggesting remove this fixes tag?
>> And why a fix can not add a new uAPI?
> Because a new attribute cannot fix any existing attribute.
>
> What is done in the patch is show current attributes of the vdpa device (which sometimes contains a different value than the mgmt. device).
> So it is a new functionality that cannot have fixes tag.
OK, I get the points now.
>
>>> Code is already considering negotiated driver features to return the device
>> config space.
>>> Hence it is fine.
>> No, the spec says:
>> The device MUST allow reading of any device-specific configuration field
>> before FEATURES_OK is set by the driver.
>>> This patch intents to provide device features to user space.
>>> First what vdpa device are capable of, are already returned by features
>> attribute on the management device.
>>> This is done in commit [1].
>> we have discussed this in another thread, vDPA device feature bits can be
>> different from the management device feature bits.
> Yes.
>>> The only reason to have it is, when one management device indicates that
>> feature is supported, but device may end up not supporting this feature if
>> such feature is shared with other devices on same physical device.
>>> For example all VFs may not be symmetric after large number of them are
>> in use. In such case features bit of management device can differ (more
>> features) than the vdpa device of this VF.
>>> Hence, showing on the device is useful.
>>>
>>> As mentioned before in V2, commit [1] has wrongly named the attribute to
>> VDPA_ATTR_DEV_SUPPORTED_FEATURES.
>>> It should have been,
>> VDPA_ATTR_DEV_MGMTDEV_SUPPORTED_FEATURES.
>>> Because it is in UAPI, and since we don't want to break compilation of
>>> iproute2, It cannot be renamed anymore.
>> Yes, rename it will break current uAPI, so I can not rename it.
> I know, which is why this patch needs to do following listed changes described in previous email.
>
>>> Given that, we do not want to start trend of naming device attributes with
>> additional _VDPA_ to it as done in this patch.
>>> Error in commit [1] was exception.
>>>
>>> Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return
>> for device features too.
>>> Secondly, you need output example for showing device features in the
>> commit log.
>>> 3rd, please drop the fixes tag as new capability is not a fix.
>>>

