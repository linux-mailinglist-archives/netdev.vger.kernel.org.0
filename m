Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225503B918A
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhGAMUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:20:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10234 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbhGAMUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:20:48 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GFxtb1kbJz1BTk1;
        Thu,  1 Jul 2021 20:12:55 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 20:18:16 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 1 Jul
 2021 20:18:15 +0800
Subject: Re: [PATCH net-next v2 0/6] ethtool: add standard FEC statistics
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <michael.chan@broadcom.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <f.fainelli@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <ariela@nvidia.com>
References: <20210415225318.2726095-1-kuba@kernel.org>
 <b5bb362e-a430-2cc8-291e-b407e306fd49@huawei.com>
 <20210518103056.4e8a8a6f@kicinski-fedora-PC1C0HJN>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <fc15329d-6f09-edd9-923d-403db6e74b2a@huawei.com>
Date:   Thu, 1 Jul 2021 20:18:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210518103056.4e8a8a6f@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/19 1:30, Jakub Kicinski wrote:
> On Tue, 18 May 2021 14:48:13 +0800 huangguangbin (A) wrote:
>> On 2021/4/16 6:53, Jakub Kicinski wrote:
>>> This set adds uAPI for reporting standard FEC statistics, and
>>> implements it in a handful of drivers.
>>>
>>> The statistics are taken from the IEEE standard, with one
>>> extra seemingly popular but not standard statistics added.
>>>
>>> The implementation is similar to that of the pause frame
>>> statistics, user requests the stats by setting a bit
>>> (ETHTOOL_FLAG_STATS) in the common ethtool header of
>>> ETHTOOL_MSG_FEC_GET.
>>>
>>> Since standard defines the statistics per lane what's
>>> reported is both total and per-lane counters:
>>>
>>>    # ethtool -I --show-fec eth0
>>>    FEC parameters for eth0:
>>>    Configured FEC encodings: None
>>>    Active FEC encoding: None
>>>    Statistics:
>>>     corrected_blocks: 256
>>>       Lane 0: 255
>>>       Lane 1: 1
>>>     uncorrectable_blocks: 145
>>>       Lane 0: 128
>>>       Lane 1: 17
>>
>> Hi, I have a doubt that why active FEC encoding is None here?
>> Should it actually be BaseR or RS if FEC statistics are reported?
> 
> Hi! Good point. The values in the example are collected from a netdevsim
> based mock up which I used for testing the interface, not real hardware.
> In reality seeing None and corrected/uncorrectable blocks is not valid.
> That said please keep in mind that the statistics should not be reset
> when settings are changed, so OFF + stats may happen.
> .
> 
Hi, Jakub, I have another question of per-lane counters.
If speed is changed, do the lane number of FEC statistics need to follow the change?
For examples, change speed from 200Gbps to 50Gbps, the actual used lane number is
changed from 4 to 2, in this case, how many lanes are needed to display FEC statistic?
Still 4 lanes or 2 lanes?

Thanks,
Guangbin
.
