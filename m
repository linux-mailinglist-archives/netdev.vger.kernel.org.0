Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F78733E2FA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhCQApp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:45:45 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3365 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhCQApW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:45:22 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4F0WbL65njz5d03;
        Wed, 17 Mar 2021 08:42:54 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 17 Mar 2021 08:45:17 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 17 Mar
 2021 08:45:17 +0800
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
 <20210315.164151.1093629330365238718.davem@redhat.com>
 <1fea8225-69b0-5a73-0e9d-f5bfdecdc840@huawei.com>
 <20210316.144533.1015318495899101097.davem@davemloft.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <441a41d4-b547-6c30-f9a8-f76604293215@huawei.com>
Date:   Wed, 17 Mar 2021 08:45:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210316.144533.1015318495899101097.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/17 5:45, David Miller wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Tue, 16 Mar 2021 10:40:56 +0800
> 
>> On 2021/3/16 7:41, David Miller wrote:
>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> At least for the fast path, taking two locks for lockless qdisc hurts
>> performance when handling requeued skb, especially if the lockless
>> qdisc supports TCQ_F_CAN_BYPASS.
> 
> The bad txq and gro skb cases are not "fast path", sorry

You are right, it is more of exceptional data path, but it is still
ok to clean that up without obvious risk, right?
For I am going to replace qdisc->seqlock with qdisc_lock(q) for lockless
qdisc too and remove qdisc->seqlock, which makes more sense.


> 
> .
> 

