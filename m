Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDCC31139EE
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfLECa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:30:26 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7637 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728459AbfLECa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 21:30:26 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6B81D5A1B138BBE0D1DA;
        Thu,  5 Dec 2019 10:30:23 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Dec 2019
 10:30:22 +0800
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiDnrZTlpI06IFtQQVRDSF0gcGFnZV9w?=
 =?UTF-8?Q?ool:_mark_unbound_node_page_as_reusable_pages?=
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cc336ff3-b729-539e-59f7-67c6c37663d9@huawei.com>
Date:   Thu, 5 Dec 2019 10:30:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <cd63eccb89bb406ca6edea46aee60e3a@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> -----邮件原件-----
>> 发件人: Yunsheng Lin [mailto:linyunsheng@huawei.com]
>> 发送时间: 2019年12月5日 10:06
>> 收件人: Li,Rongqing <lirongqing@baidu.com>; netdev@vger.kernel.org;
>> saeedm@mellanox.com
>> 主题: Re: 答复: 答复: [PATCH] page_pool: mark unbound node page as
>> reusable pages
>>
>> On 2019/12/5 9:55, Li,Rongqing wrote:
>>>
>>>
>>>> -----邮件原件-----
>>>> 发件人: Yunsheng Lin [mailto:linyunsheng@huawei.com]
>>>> 发送时间: 2019年12月5日 9:44
>>>> 收件人: Li,Rongqing <lirongqing@baidu.com>; netdev@vger.kernel.org;
>>>> saeedm@mellanox.com
>>>> 主题: Re: 答复: [PATCH] page_pool: mark unbound node page as reusable
>>>> pages
>>>>
>>>> On 2019/12/5 9:08, Li,Rongqing wrote:
>>>>>
>>>>>
>>>>>> -----邮件原件-----
>>>>>> 发件人: Yunsheng Lin [mailto:linyunsheng@huawei.com]
>>>>>> 发送时间: 2019年12月5日 8:55
>>>>>> 收件人: Li,Rongqing <lirongqing@baidu.com>; netdev@vger.kernel.org;
>>>>>> saeedm@mellanox.com
>>>>>> 主题: Re: [PATCH] page_pool: mark unbound node page as reusable
>> pages
>>>>>>
>>>>>> On 2019/12/4 18:14, Li RongQing wrote:
>>>>>>> some drivers uses page pool, but not require to allocate page from
>>>>>>> bound node, so pool.p.nid is NUMA_NO_NODE, and this fixed patch
>>>>>>> will block this kind of driver to recycle
>>>>>>>
>>>>>>> Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable
>>>>>>> pages")
>>>>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>>>>>> Cc: Saeed Mahameed <saeedm@mellanox.com>
>>>>>>> ---
>>>>>>>  net/core/page_pool.c | 4 +++-
>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c index
>>>>>>> a6aefe989043..4054db683178 100644
>>>>>>> --- a/net/core/page_pool.c
>>>>>>> +++ b/net/core/page_pool.c
>>>>>>> @@ -317,7 +317,9 @@ static bool __page_pool_recycle_direct(struct
>>>>>>> page
>>>>>> *page,
>>>>>>>   */
>>>>>>>  static bool pool_page_reusable(struct page_pool *pool, struct
>>>>>>> page
>>>>>>> *page)  {
>>>>>>> -	return !page_is_pfmemalloc(page) && page_to_nid(page) ==
>>>> pool->p.nid;
>>>>>>> +	return !page_is_pfmemalloc(page) &&
>>>>>>> +		(page_to_nid(page) == pool->p.nid ||
>>>>>>> +		 pool->p.nid == NUMA_NO_NODE);
>>>>>>
>>>>>> If I understand it correctly, you are allowing recycling when
>>>>>> pool->p.nid is NUMA_NO_NODE, which does not seems match the
>> commit
>>>>>> log: "this fixed patch will block this kind of driver to recycle".
>>>>>>
>>>>>> Maybe you mean "commit d5394610b1ba" by this fixed patch?
>>>>>
>>>>> yes
>>>>>
>>>>>>
>>>>>> Also, maybe it is better to allow recycling if the below condition is
>> matched:
>>>>>>
>>>>>> 	pool->p.nid == NUMA_NO_NODE && page_to_nid(page) ==
>>>>>> numa_mem_id()
>>>>>
>>>>> If driver uses NUMA_NO_NODE, it does not care numa node, and maybe
>>>>> its platform Only has a node, so not need to compare like
>>>>> "page_to_nid(page) ==
>>>> numa_mem_id()"
>>>>
>>>> Normally, driver does not care if the node of a device is
>>>> NUMA_NO_NODE or not, it just uses the node that returns from
>> dev_to_node().
>>>>
>>>> Even for multi node system, the node of a device may be NUMA_NO_NODE
>>>> when BIOS/FW has not specified it through ACPI/DT, see [1].
>>>>
>>>>
>>>> [1] https://lore.kernel.org/patchwork/patch/1141952/
>>>>
>>>
>>> at this condition, page can be allocated from any node from driver
>>> boot, why need to check "page_to_nid(page) == numa_mem_id()" at recycle?
>>
>> For performance, the performance is better when the rx page is on the same
>> node as the rx process is running.
>>
>> We want the node of rx page is close to the node of device/cpu to achive better
>> performance, since the node of device is unknown, maybe we choose the node
>> of memory that is close to the cpu that is running to handle the rx cleaning.
>>
> 
> if the driver takes care about numa node, it should not assign NUMA_NO_NODE, it should
> assign a detail numa node at starting step. Not depend on recycle to decide the numa
> node

How and where we should handle the NUMA_NO_NODE has been discussed before,
see [1].
but the driver has not been considered the place to handle it.

For driver that has not using page pool, the numa_mem_id() checking
is how they decide to recycle or not, see [2] [3].

I think it is better to be consistent with the page pool too.


[1] https://lore.kernel.org/patchwork/patch/1125789/
[2] https://elixir.bootlin.com/linux/v5.4.2/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L2437
[3] https://elixir.bootlin.com/linux/v5.4.2/source/drivers/net/ethernet/intel/i40e/i40e_txrx.c#L1858
> 
> -RongQing
> 
> 
>>>
>>> -Li
>>>
>>>>>
>>>>>
>>>>> -RongQing
>>>>>
>>>>>
>>>>>>
>>>>>>>  }
>>>>>>>
>>>>>>>  void __page_pool_put_page(struct page_pool *pool, struct page
>>>>>>> *page,
>>>>>>>
>>>>>
>>>
> 

