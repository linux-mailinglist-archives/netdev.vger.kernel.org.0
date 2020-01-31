Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A8514F1F8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgAaSJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:09:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:31494 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbgAaSJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:09:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:09:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377414811"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 10:09:54 -0800
Subject: Re: [PATCH 02/15] devlink: add functions to take snapshot while
 locked
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-3-jacob.e.keller@intel.com>
 <20200131100706.5c98981e@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8cb6ab98-9d20-4965-f230-0a4ad229be97@intel.com>
Date:   Fri, 31 Jan 2020 10:09:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100706.5c98981e@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:07 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:58:57 -0800, Jacob Keller wrote:
>> +static int
>> +devlink_region_snapshot_create_locked(struct devlink_region *region,
>> +				      u8 *data, u32 snapshot_id,
>> +				      devlink_snapshot_data_dest_t *destructor)
> 
> -1 on the _locked suffix. Please follow the time-honored tradition of
> using double underscore for internal helpers which make assumption
> about calling context.
> 

Sure.

>> +{
>> +	struct devlink_snapshot *snapshot;
> 
> lockdep_assert_held() is much better than just a kdoc comment.
> 

Ok.

>> +	/* check if region can hold one more snapshot */
>> +	if (region->cur_snapshots == region->max_snapshots)
>> +		return -ENOMEM;
