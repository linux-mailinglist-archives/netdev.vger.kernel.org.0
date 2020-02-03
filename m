Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C3F150D3F
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 17:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgBCQnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 11:43:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:29592 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbgBCQdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 08:33:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278793825"
Received: from unknown (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 08:33:23 -0800
Subject: Re: [PATCH 03/15] devlink: add operation to take an immediate
 snapshot
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-4-jacob.e.keller@intel.com>
 <20200203115001.GE2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <300903ab-7b94-08bd-1d88-100af3409f4b@intel.com>
Date:   Mon, 3 Feb 2020 08:33:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203115001.GE2260@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2020 3:50 AM, Jiri Pirko wrote:
> Thu, Jan 30, 2020 at 11:58:58PM CET, jacob.e.keller@intel.com wrote:
>> Add a new devlink command, DEVLINK_CMD_REGION_TAKE_SNAPSHOT. This
> 
> Hmm, the shapshot is now removed by user calling:
> 
> $ devlink region del DEV/REGION snapshot SNAPSHOT_ID
> That is using DEVLINK_CMD_REGION_DEL netlink command calling
> devlink_nl_cmd_region_del()
> 
> I think the creation should be symmetric. Something like:
> $ devlink region add DEV/REGION snapshot SNAPSHOT_ID
> SNAPSHOT_ID is either exact number or "any" if user does not care.
> The benefit of using user-passed ID value is that you can use this
> easily in scripts.
> 
> The existing unused netlink command DEVLINK_CMD_REGION_NEW would be used
> for this.
> 

Sure, this makes some sense. It will likely require refactoring the
snapshot id creation to handle the fact that users can choose a snapshot
id themselves.

This approach sounds like a more sound design, making the commands
symmetric and enabling easier usage from scripts.

Thanks,
Jake

> 
>>
>>     # Dump a snapshot:
>>     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
> 
> [...]
> 
