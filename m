Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9F13B356
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgANUEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:04:05 -0500
Received: from mga04.intel.com ([192.55.52.120]:36043 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgANUEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 15:04:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 12:04:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,320,1574150400"; 
   d="scan'208";a="256440394"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jan 2020 12:04:04 -0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200113165858.GG2131@nanopsycho>
 <1771df1d-8f2e-8622-5edf-2cce47571faf@intel.com>
 <a8bdbb3f-35d3-efc0-0a9c-ca5546397032@huawei.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <98206413-81d3-211c-c9c4-916770f5e859@intel.com>
Date:   Tue, 14 Jan 2020 12:04:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <a8bdbb3f-35d3-efc0-0a9c-ca5546397032@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/2020 12:33 AM, Yunsheng Lin wrote:
> On 2020/1/14 2:22, Jacob Keller wrote:
>>
>>
>> On 1/13/2020 8:58 AM, Jiri Pirko wrote:
>>> Why? That is the purpose of the dpipe, but make the hw
>>> pipeline visible and show you the content of individual nodes.
>>>
>>
>> I agree. dpipe seems to be focused specifically on dumping nodes of the
>> tables that represent the hardware's pipeline. I think it's unrelated to
>> this discussion about regions vs health API.
> 
> Sorry for bringing up a not really unrelated question in the thread,
> 

No problem here :) I've been investigating devlink for our products, and
am working towards implementations for several features. Further
discussion is definitely welcome!

> For the hns3 hw mac table, it seems the hns3 hw is pretty simple, it mainly
> contain the port bitmaps of a mac address, then the hw can forward the packet
> based on the dst mac' port bitamp.
> 

Right.

> It seems a litte hard to match to the dpipe API the last time I tried to
> use dpipe API to dump that.

dpipe is primarily targeted towards dumping complex hardware pipelines.

> 
> So maybe it would be good to have the support of table dumping (both structured
> and binary table) for health API natively, so that we use it to dump some hw
> table for both driver and user triggering cases.
> 

Maybe dpipe needs additional mechanism for presenting tables?

> I am not sure if other driver has the above requirement, and if the requirement
> makes any sense?
> 

I think there's value in the ability to express this kind of contents.
Regions could work.

In regards to using devlink-health, I do believe the health API should
remain focused as the area you use for dumping data gathered
specifically in relation to an event such as an error condition.

Regions make sense when you want to allow access to a section of
addressable contents on demand.

A binary table could be dumped via a region, but I'm not 100% sure it
would make sense for structured tables.

Thanks,
Jake
