Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C271626D1F2
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQDzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:55:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbgIQDzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 23:55:18 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 40B1A3DAAB07664918D2;
        Thu, 17 Sep 2020 11:55:17 +0800 (CST)
Received: from [10.174.178.63] (10.174.178.63) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 11:55:11 +0800
Subject: Re: [PATCH] hinic: fix potential resource leak
To:     "luobin (L)" <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huawei.libin@huawei.com>, <guohanjun@huawei.com>
References: <20200917030307.47195-1-liwei391@huawei.com>
 <dadc79e3-a923-7a4a-2d6f-3f33d614591e@huawei.com>
From:   "liwei (GF)" <liwei391@huawei.com>
Message-ID: <30debf33-49b9-3ac1-cf2a-4ee2c0f1f13d@huawei.com>
Date:   Thu, 17 Sep 2020 11:55:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <dadc79e3-a923-7a4a-2d6f-3f33d614591e@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.63]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi luobin,

On 2020/9/17 11:44, luobin (L) wrote:
> On 2020/9/17 11:03, Wei Li wrote:
>> +	err = irq_set_affinity_hint(rq->irq, &rq->affinity_mask);
>> +	if (err)
>> +		goto err_irq;
>> +
>> +	return 0;
>> +
>> +err_irq:
>> +	rx_del_napi(rxq);
>> +	return err;
> If irq_set_affinity_hint fails, irq should be freed as well.
> 
Yes, indeed.
I will fix that in the next spin.

Thanks,
Wei
