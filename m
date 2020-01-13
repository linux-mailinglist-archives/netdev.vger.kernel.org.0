Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3C9138952
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 02:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbgAMBj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 20:39:57 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9160 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727222AbgAMBj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 20:39:56 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 302B3726976CD8B241FC;
        Mon, 13 Jan 2020 09:39:55 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 Jan 2020
 09:39:51 +0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Alex Vesker <valex@mellanox.com>, Jakub Kicinski <kubakici@wp.pl>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200112124521.467fa06a@cakuba>
 <DB6PR0501MB224859D8DC219E81D4CFB17CC33A0@DB6PR0501MB2248.eurprd05.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <421f78c2-7713-b931-779e-dfe675fe5f53@huawei.com>
Date:   Mon, 13 Jan 2020 09:39:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <DB6PR0501MB224859D8DC219E81D4CFB17CC33A0@DB6PR0501MB2248.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/1/13 5:18, Alex Vesker wrote:
> On 1/12/2020 10:45 PM, Jakub Kicinski wrote:
>> On Sat, 11 Jan 2020 09:51:00 +0800, Yunsheng Lin wrote:
>>>> regions can essentially be used to dump arbitrary addressable content. I
>>>> think all of the above are great examples.
>>>>
>>>> I have a series of patches to update and convert the devlink
>>>> documentation, and I do provide some further detail in the new
>>>> devlink-region.rst file.
>>>>
>>>> Perhaps you could review that and provide suggestions on what would make
>>>> sense to add there?  
>>> For the case of region for mlx4, I am not sure it worths the effort to
>>> document it, because Jiri has mention that there was plan to convert mlx4 to
>>> use "devlink health" api for the above case.
>>>
>>> Also, there is dpipe, health and region api:
>>> For health and region, they seems similar to me, and the non-essential
>>> difference is:
>>> 1. health can be used used to dump content of tlv style, and can be triggered
>>>    by driver automatically or by user manually.
>>>
>>> 2. region can be used to dump binary content and can be triggered by driver
>>>    automatically only.
>>>
>>> It would be good to merged the above to the same api(perhaps merge the binary
>>> content dumping of region api to health api), then we can resue the same dump
>>> ops for both driver and user triggering case.
>> I think there is a fundamental difference between health API and
>> regions in the fact that health reporters allow for returning
>> structured data from different sources which are associated with 
>> an event/error condition. That includes information read from the
>> hardware or driver/software state. Region API (as Jake said) is good
>> for dumping arbitrary addressable content, e.g. registers. I don't see
>> much use for merging the two right now, FWIW...

The point is that we are beginning to use health API for event/error
condition, right? Do we use health API or regions API to dump a arbitrary
addressable content when there is an event/error detected?

Also we may need to dump both a arbitrary addressable content and the
structured data when there is an event/error detected, the health API or
regions API can not do both, right?

It still seems it is a little confusing when deciding to use health or
regions API.

>>
> Totally agree with Jakub, I think health and region are different and
> each has its
> usages as mentioned above. Using words such as recovery and health for
> exposing
> registers doesn't sound correct. There are future usages I can think of
> for region if we
> will add the trigger support as well as the live region read.

health API already has "trigger support" now if region API is merged to
health API.

I am not sure I understand "live region" here, what is the usecase of live
region?

> 
> 
> 

