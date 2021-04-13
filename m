Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32CB35D5F6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbhDMDfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:35:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3940 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbhDMDfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:35:03 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FKB4V2n9bz5r56;
        Tue, 13 Apr 2021 11:32:26 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 13 Apr 2021 11:34:28 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 13 Apr
 2021 11:34:28 +0800
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Hillf Danton <hdanton@sina.com>
CC:     Juergen Gross <jgross@suse.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Kosina <JKosina@suse.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210409090909.1767-1-hdanton@sina.com>
 <20210412032111.1887-1-hdanton@sina.com>
 <20210412072856.2046-1-hdanton@sina.com>
 <20210413022129.2203-1-hdanton@sina.com>
 <20210413032620.2259-1-hdanton@sina.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e67fd8f2-e247-ed2f-7de1-f58b1878226b@huawei.com>
Date:   Tue, 13 Apr 2021 11:34:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210413032620.2259-1-hdanton@sina.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/13 11:26, Hillf Danton wrote:
> On Tue, 13 Apr 2021 10:56:42 Yunsheng Lin wrote:
>> On 2021/4/13 10:21, Hillf Danton wrote:
>>> On Mon, 12 Apr 2021 20:00:43  Yunsheng Lin wrote:
>>>>
>>>> Yes, the below patch seems to fix the data race described in
>>>> the commit log.
>>>> Then what is the difference between my patch and your patch below:)
>>>
>>> Hehe, this is one of the tough questions over a bounch of weeks.
>>>
>>> If a seqcount can detect the race between skb enqueue and dequeue then we
>>> cant see any excuse for not rolling back to the point without NOLOCK.
>>
>> I am not sure I understood what you meant above.
>>
>> As my understanding, the below patch is essentially the same as
>> your previous patch, the only difference I see is it uses qdisc->pad
>> instead of __QDISC_STATE_NEED_RESCHEDULE.
>>
>> So instead of proposing another patch, it would be better if you
>> comment on my patch, and make improvement upon that.
>>
> Happy to do that after you show how it helps revert NOLOCK.

Actually I am not going to revert NOLOCK, but add optimization
to it if the patch fixes the packet stuck problem.

Is there any reason why you want to revert it?

> 
> .
> 

