Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060D4113A2F
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 04:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfLEDDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 22:03:38 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6753 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728459AbfLEDDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 22:03:38 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 782588F9F0C6E6745370;
        Thu,  5 Dec 2019 11:03:36 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Dec 2019
 11:03:32 +0800
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiDnrZTlpI06IOetlOWkjTogW1BBVENI?=
 =?UTF-8?Q?]_page=5fpool:_mark_unbound_node_page_as_reusable_pages?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
 <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
 <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
 <68135c0148894aa3b26db19120fb7bac@baidu.com>
 <3e3b1e0c-e7e0-eea2-b1b5-20bf2b8fc34b@huawei.com>
 <cd63eccb89bb406ca6edea46aee60e3a@baidu.com>
 <cc336ff3-b729-539e-59f7-67c6c37663d9@huawei.com>
 <504bf0958f424a2c9add3a84543c45c6@baidu.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0c5b19c3-b639-b990-73a1-a1300d417221@huawei.com>
Date:   Thu, 5 Dec 2019 11:03:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <504bf0958f424a2c9add3a84543c45c6@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/5 10:47, Li,Rongqing wrote:
>>
>> [1] https://lore.kernel.org/patchwork/patch/1125789/
> 
> 
> What is status of this patch? I think you should fix your firmware or bios

Have not reached a conclusion yet.

> 
> Consider the below condition:
> 
> there is two numa node, and NIC sites on node 2, but NUMA_NO_NODE is used, recycle will fail due to page_to_nid(page) == numa_mem_id(), 
> and reallocated pages maybe always from node 1, then the recycle will never success.

For page pool:

1. if the pool->p.nid != NUMA_NO_NODE, the recycle is always decided by
checking page_to_nid(page) == pool->p.nid.

2. only when the pool->p.nid == NUMA_NO_NODE, the numa_mem_id() is checked
   to decide the recycle.

Yes, If pool->p.nid == NUMA_NO_NODE, and the cpu that is doing recycling
is changing each time, the recycle may never success, but it is not common,
and have its own performance penalty when changing the recycling cpu so
often.


> 
> -RongQing
> 
> 

