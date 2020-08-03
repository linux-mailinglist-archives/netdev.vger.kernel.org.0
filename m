Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E9E23B0AF
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgHCXIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:08:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:11086 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbgHCXIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 19:08:06 -0400
IronPort-SDR: bIOsGwLp3dqDA2loM4TJ07Rpbtxgrb3ywh/QKCGtbyjkhRuXjpj26iZpIQ+PUMbZpmAIPagyQu
 CBtVK17NQ8lg==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="132278260"
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="132278260"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 16:08:06 -0700
IronPort-SDR: gPmsWgYV79j2KSD8trVB60kwVKXhS3yO0ShgkuAaCMqLzQsFiK9Y7WFCYrL5MBs1ONxxAYVUBj
 UGmo91qwl49Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="366621219"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.196.183]) ([10.212.196.183])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2020 16:08:06 -0700
Subject: Re: [net-next v2 2/5] devlink: introduce flash update overwrite mask
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-3-jacob.e.keller@intel.com>
 <20200803153830.GD2290@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <095af367-60f3-0b0b-5191-08756962f8a2@intel.com>
Date:   Mon, 3 Aug 2020 16:08:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200803153830.GD2290@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 8:38 AM, Jiri Pirko wrote:
> Sat, Aug 01, 2020 at 02:21:56AM CEST, jacob.e.keller@intel.com wrote:
> 
> [...]
> 
>> +	nla_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
>> +	if (nla_mask) {
>> +		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
>> +			NL_SET_ERR_MSG_ATTR(info->extack, nla_mask,
>> +					    "overwrite is not supported");
>> +			return -EOPNOTSUPP;
>> +		}
>> +		params.overwrite_mask = nla_get_u32(nla_mask);
> 
> It's a bitfield, should be NL_ATTR_TYPE_BITFIELD32.
> 

v3 will use a bitfield, despite I don't believe it needs this. The
overwrite mask provided to the driver will be the bitwise AND of the
selector and the value (i.e. userspace will have to set the bit in both
the selector and value to get it enabled).

Thanks,
Jake
