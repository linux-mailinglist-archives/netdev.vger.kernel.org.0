Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F88A13BB40
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 09:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAOIga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 03:36:30 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60552 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbgAOIga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 03:36:30 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 13F50F361F6FC9A2740A;
        Wed, 15 Jan 2020 16:36:27 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 Jan 2020
 16:36:23 +0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <valex@mellanox.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200113165858.GG2131@nanopsycho>
 <1771df1d-8f2e-8622-5edf-2cce47571faf@intel.com>
 <a8bdbb3f-35d3-efc0-0a9c-ca5546397032@huawei.com>
 <98206413-81d3-211c-c9c4-916770f5e859@intel.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d0cd20cd-a268-48e6-1b16-1fc0419d7166@huawei.com>
Date:   Wed, 15 Jan 2020 16:36:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <98206413-81d3-211c-c9c4-916770f5e859@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/1/15 4:04, Jacob Keller wrote:
> On 1/14/2020 12:33 AM, Yunsheng Lin wrote:
>> On 2020/1/14 2:22, Jacob Keller wrote:
>>>
>>>
>>> On 1/13/2020 8:58 AM, Jiri Pirko wrote:
>>>> Why? That is the purpose of the dpipe, but make the hw
>>>> pipeline visible and show you the content of individual nodes.
>>>>
>>>
>>> I agree. dpipe seems to be focused specifically on dumping nodes of the
>>> tables that represent the hardware's pipeline. I think it's unrelated to
>>> this discussion about regions vs health API.
>>
>> Sorry for bringing up a not really unrelated question in the thread,
>>
> 
> No problem here :) I've been investigating devlink for our products, and
> am working towards implementations for several features. Further
> discussion is definitely welcome!
> 
>> For the hns3 hw mac table, it seems the hns3 hw is pretty simple, it mainly
>> contain the port bitmaps of a mac address, then the hw can forward the packet
>> based on the dst mac' port bitamp.
>>
> 
> Right.
> 
>> It seems a litte hard to match to the dpipe API the last time I tried to
>> use dpipe API to dump that.
> 
> dpipe is primarily targeted towards dumping complex hardware pipelines.
> 
>>
>> So maybe it would be good to have the support of table dumping (both structured
>> and binary table) for health API natively, so that we use it to dump some hw
>> table for both driver and user triggering cases.
>>
> 
> Maybe dpipe needs additional mechanism for presenting tables?
> 
>> I am not sure if other driver has the above requirement, and if the requirement
>> makes any sense?
>>
> 
> I think there's value in the ability to express this kind of contents.
> Regions could work.
> 
> In regards to using devlink-health, I do believe the health API should
> remain focused as the area you use for dumping data gathered
> specifically in relation to an event such as an error condition.

what if there are requirements to dump the same data for both error/event
triggering and user cmd triggering case? If we implement a dump ops of
region API for user cmd triggering case, and then implement a similar
dump ops of health API for error/event case, does this not seems unnecessary
duplication of effort?

For user cmd triggering case, it is used to inspect the device' health state
mostly, so maybe it makes sense to use health API to dump that too.

> 
> Regions make sense when you want to allow access to a section of
> addressable contents on demand.
> 
> A binary table could be dumped via a region, but I'm not 100% sure it
> would make sense for structured tables.
> 
> Thanks,
> Jake
> 
> .
> 

