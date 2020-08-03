Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1319B23AAEF
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgHCQxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:53:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:26881 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbgHCQxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 12:53:12 -0400
IronPort-SDR: kBrqfdMmcTY8ZKmdWNP8t0GJwKLg9byyuDFmVrzG6Nf41S+SYoRCoczsG0I6/h8NcdGWv5gnA8
 x7SEUOHwfSJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="140084418"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="140084418"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 09:53:11 -0700
IronPort-SDR: IVwbYypN0OJ8Xz1CcGuP0pmckE5bKIq84G5JcdKk0aIY8liqN8tAlCWlH/0J7Z7nr6gC/4LDgU
 1dGsyq0JlfFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="366446533"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.196.183]) ([10.212.196.183])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2020 09:53:11 -0700
Subject: Re: [net-next v2 2/5] devlink: introduce flash update overwrite mask
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-3-jacob.e.keller@intel.com>
 <20200803153830.GD2290@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <72203b31-37f5-0dd1-e7b2-f5da0d0b1398@intel.com>
Date:   Mon, 3 Aug 2020 09:53:10 -0700
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

I disagree. BITFIELD32 has both a mask and a field. This doesn't have
the notion of a mask. The bits you allow are set, the bits you don't
allow are not set. Having both a mask and a field over complicates this.
