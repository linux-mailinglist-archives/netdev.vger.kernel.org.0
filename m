Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE25664A1
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 10:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGEH7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGEH73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:59:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281D5C54
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657007969; x=1688543969;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wgZbjkl7iEwhh1nH1cDv9zk6egu4mDdo1DzPARfkOCY=;
  b=G6G1F65CpNQSP7PuyqTIsiBKYn4Q8wfFb8pC9lKUv0e0AV26WDaHvvN7
   JtZ87GsqORe+6zPWkQjPXa9qLfbrl43K2k0XLbW4pOBnfZ/l5nYBxJGTP
   1vonF5lShq4PEwRkkeDdgw6Omnr736oWlItLKjfwSql67MMgU+snobgyf
   MGyB8Fb9yQMSgXcZBxDEfk0JPnt3py1nAQ7kbpQni+YcCdMUnwk36RfDx
   SaGLI16lE0v7Sv2XsdagXl9nOYGMVYkHgTo6st0wdY3/YDk/vY3pDMR0J
   w8Poj0EhhltTizHJvQDOME85K3b0D9NfRw0AETGqF+zwyn0sZxeMPidX9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="308823728"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="308823728"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 00:59:27 -0700
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="649997707"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.238.130.254]) ([10.238.130.254])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 00:59:25 -0700
Message-ID: <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
Date:   Tue, 5 Jul 2022 15:59:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
 <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/4/2022 8:53 PM, Parav Pandit wrote:
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Monday, July 4, 2022 12:47 AM
>>
>>
>> 在 2022/7/2 06:02, Parav Pandit 写道:
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
>>> I reviewed the patches again.
>>>
>>> However, this is not the fix.
>>> A fix cannot add a new UAPI.
>>>
>>> Code is already considering negotiated driver features to return the device
>> config space.
>>> Hence it is fine.
>>>
>>> This patch intents to provide device features to user space.
>>> First what vdpa device are capable of, are already returned by features
>> attribute on the management device.
>>> This is done in commit [1].
>>>
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
>>>
>>> Given that, we do not want to start trend of naming device attributes with
>> additional _VDPA_ to it as done in this patch.
>>> Error in commit [1] was exception.
>>>
>>> Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return
>> for device features too.
>>
>>
>> This will probably break or confuse the existing userspace?
>>
> It shouldn't break, because its new attribute on the device.
> All attributes are per command, so old one will not be confused either.
A netlink attr should has its own and unique purpose, that's why we 
don't need locks for the attrs, only one consumer and only one producer.
I am afraid re-using (for both management device and the vDPA device) 
the attr VDPA_ATTR_DEV_SUPPORTED_FEATURES would lead to new race condition.
E.g., There are possibilities of querying FEATURES of a management 
device and a vDPA device simultaneously, or can there be a syncing issue 
in a tick?

IMHO, I don't see any advantages of re-using this attr.

Thanks,
Zhu Lingshan

