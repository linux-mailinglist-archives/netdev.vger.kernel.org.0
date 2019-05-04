Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B158A1380F
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 09:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEDHKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 03:10:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbfEDHKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 03:10:34 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1D182BF89939EA7605A3;
        Sat,  4 May 2019 15:10:33 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 15:10:23 +0800
Subject: Re: [PATCH v2] ipnetns: use-after-free problem in
 get_netnsid_from_name func
To:     Phil Sutter <phil@nwl.cc>
CC:     <stephen@networkplumber.org>, <liuhangbin@gmail.com>,
        <kuznet@ms2.inr.ac.ru>, <nicolas.dichtel@6wind.com>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>, <kouhuiying@huawei.com>,
        <netdev@vger.kernel.org>
References: <f6c76a60-d5c4-700f-2fbf-912fc1545a31@huawei.com>
 <815afacc-4cd2-61b4-2181-aabce6582309@huawei.com>
 <20190429092808.GZ31599@orbyte.nwl.cc>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <c7a16354-f28d-7c8a-e5f6-41395da53da8@huawei.com>
Date:   Sat, 4 May 2019 15:08:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190429092808.GZ31599@orbyte.nwl.cc>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi,
> 
> On Mon, Apr 29, 2019 at 03:38:39PM +0800, Zhiqiang Liu wrote:
>> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>
>> Follow the following steps:
>> # ip netns add net1
>> # export MALLOC_MMAP_THRESHOLD_=0
>> # ip netns list
>> then Segmentation fault (core dumped) will occur.
>>
>> In get_netnsid_from_name func, answer is freed before rta_getattr_u32(tb[NETNSA_NSID]),
>> where tb[] refers to answer`s content. If we set MALLOC_MMAP_THRESHOLD_=0, mmap will
>> be adoped to malloc memory, which will be freed immediately after calling free func.
>> So reading tb[NETNSA_NSID] will access the released memory after free(answer).
>>
>> Here, we will call get_netnsid_from_name(tb[NETNSA_NSID]) before free(answer).
>>
>> Fixes: 86bf43c7c2f ("lib/libnetlink: update rtnl_talk to support malloc buff at run time")
>> Reported-by: Huiying Kou <kouhuiying@huawei.com>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> 
> Acked-by: Phil Sutter <phil@nwl.cc>
> 
> Please always Cc: netdev@vger.kernel.org for iproute2 patches.
> 
> Thanks, Phil

Thank you for reminding me. I will Cc: netdev@vger.kernel.org in the v3 patch.

> 
> .
> 

