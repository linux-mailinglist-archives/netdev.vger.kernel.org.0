Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13663F589D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhHXHBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:01:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18028 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbhHXHBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:01:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gv0KG4yZQzbhFL;
        Tue, 24 Aug 2021 14:57:06 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 15:00:55 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 24 Aug
 2021 15:00:55 +0800
Subject: Re: [PATCH net-next v2 2/2] page_pool: optimize the cpu sync
 operation when DMA mapping
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>
References: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
 <1629442611-61547-3-git-send-email-linyunsheng@huawei.com>
 <YR94YYRv2qpQtdSZ@Iliass-MBP>
 <16468e57-49d8-0a23-0058-c920af99d74a@huawei.com>
 <YSOXwdLgeY1ti8ZO@enceladus>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <710fcc40-64d0-cafc-5dde-8762cc0ae457@huawei.com>
Date:   Tue, 24 Aug 2021 15:00:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YSOXwdLgeY1ti8ZO@enceladus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme715-chm.china.huawei.com (10.1.199.111) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/23 20:42, Ilias Apalodimas wrote:
> On Mon, Aug 23, 2021 at 11:56:48AM +0800, Yunsheng Lin wrote:
>> On 2021/8/20 17:39, Ilias Apalodimas wrote:
>>> On Fri, Aug 20, 2021 at 02:56:51PM +0800, Yunsheng Lin wrote:

[..]
>>
>> https://elixir.bootlin.com/linux/latest/source/kernel/dma/direct.h#L104
>>
>> The one thing I am not sure about is that the pool->p.offset
>> and pool->p.max_len are used to decide the sync range before this
>> patch, while the sync range is the same as the map range when doing
>> the sync in dma_map_page_attrs().
> 
> I am not sure I am following here. We always sync the entire range as well
> in the current code as the mapping function is called with max_len.
> 
>>
>> I assumed the above is not a issue? only sync more than we need?
>> and it won't hurt the performance?
> 
> We can sync more than we need, but if it's a non-coherent architecture,
> there's a performance penalty. 

Since I do not have any performance data to prove if there is a
performance penalty for non-coherent architecture, I will drop it:)

> 
> Regards
> /Ilias
>>
