Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEA14A7DEB
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 03:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiBCCaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 21:30:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:57391 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231596AbiBCCaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 21:30:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643855415; x=1675391415;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=51LPAxLCA6IR8bE9yHgy3Ms4HDZ0kcQcyLzR64OTizY=;
  b=mBm7hpg6KsMQytXEGVDJzrSxnM0qA2nkybF/cVobUQDTnWMrEDxDZleV
   hAxo56p9oDfrC2OCKn2ZRs25G/eHn+6IJEvzLHJGYI6FEoWSLOE0+W1OG
   b2m+sos0xYNnb0qnNXF8B1BCNtouIWj2W+c1dggyFcRhSCXC+GCms2uv4
   kHpacxp9k2MIYQTo1TVgh0hwzobD6VkQWefl9iuA/SUN58279s7fjCDd9
   DgULi6RbviNJinK5zAORaGybqwIi7F606gJ+IBl1GvHG49YnT+uf8CVK+
   0OzVia8EVdBbKRhR5gHtPh2dCiaLfIwtrkK3gLg3wi7oUUdW3CzvRc92R
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="334421964"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="334421964"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 18:30:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="497986598"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.159.249]) ([10.212.159.249])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 18:30:12 -0800
Message-ID: <59eabeba-414d-c8fe-2d3c-2cf9b33b3a83@linux.intel.com>
Date:   Wed, 2 Feb 2022 18:30:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 07/13] net: wwan: t7xx: Data path HW layer
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-8-ricardo.martinez@linux.intel.com>
 <8593f871-6737-7f85-5035-b1b2d5d312e@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <8593f871-6737-7f85-5035-b1b2d5d312e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/1/2022 1:08 AM, Ilpo Järvinen wrote:
> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
>
...
>> +static int t7xx_dpmaif_config_dlq_hw(struct dpmaif_ctrl *dpmaif_ctrl)
>> +{
>> +	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
>> +	struct dpmaif_dl_hwq *dl_hw;
> Only defined in 08. I might have not noticed all missing defs
> so please compile test yourself to find the rest if any.
>
> In general, it would be useful to use, e.g., a shell for loop to compile
> test every change incrementally in the patchset before sending them out.

Compilation is tested in every incremental patch.

This file provides lower level functions used only by code in 08, hence

it is added to the Makefile at 08.

For the next iteration, I'll decouple 07 and 08, but I think it makes 
sense to

keep the Makefile changes at 08 when the functionality is actually added

to the driver.

> Another thing is that the values inside struct dpmaif_dl_hwq are
> just set from constants and never changed anywhere. Why not use
> the constants directly?
>
Agree. Using the constants directly will also help to decouple 07 and 08.

...

>
