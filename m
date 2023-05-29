Return-Path: <netdev+bounces-6038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1598E7147D2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BEA6280D94
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494436AA9;
	Mon, 29 May 2023 10:19:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F23E7C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 10:19:00 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B46C9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 03:18:53 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QVBHs15nPzLpyC;
	Mon, 29 May 2023 18:15:53 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 29 May 2023 18:18:50 +0800
Message-ID: <889f39b7-92dc-1c37-e164-b16610de9999@huawei.com>
Date: Mon, 29 May 2023 18:18:50 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
To: Peilin Ye <yepeilin.cs@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>
CC: <netdev@vger.kernel.org>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
	<wanghai38@huawei.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
 <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/29 16:59, Peilin Ye wrote:
> On Mon, May 29, 2023 at 09:10:23AM +0800, shaozhengchao wrote:
>> On 2023/5/29 3:05, Jamal Hadi Salim wrote:
>>> On Sat, May 27, 2023 at 5:30 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>>> When use the following command to test:
>>>> 1)ip link add bond0 type bond
>>>> 2)ip link set bond0 up
>>>> 3)tc qdisc add dev bond0 root handle ffff: mq
>>>> 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
>>>
>>> This is fixed by Peilin in this ongoing discussion:
>>> https://lore.kernel.org/netdev/cover.1684887977.git.peilin.ye@bytedance.com/
>>>
>>        Thank you for your reply. I have notice Peilin's patches before,
>> and test after the patch is incorporated in local host. But it still
>> triggers the problem.
>>        Peilin's patches can be filtered out when the query result of
>> qdisc_lookup is of the ingress type. Here is 4/6 patch in his patches.
>> +if (q->flags & TCQ_F_INGRESS) {
>> +     NL_SET_ERR_MSG(extack,
>> +                    "Cannot regraft ingress or clsact Qdiscs");
>> +     return -EINVAL;
>> +}
>>        However, the query result of my test case in qdisc_lookup is mq.
>> Therefore, the patch cannot solve my problem.
> 
> Ack, they are different: patch [4/6] prevents ingress (clsact) Qdiscs
> from being regrafted (to elsewhere), and Zhengchao's patch prevents other
> Qdiscs from being regrafted to ffff:fff1.
> 
> Thanks,
> Peilin Ye
> 
Hi Peilin:
	Thank you for your ack.

Zhengchao Shao

