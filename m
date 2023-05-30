Return-Path: <netdev+bounces-6221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E3F715403
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B4781C20B27
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD52ED1;
	Tue, 30 May 2023 02:46:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F57FB
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:46:37 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A4F188
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:45:56 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QVc9m2wn6zLqH6;
	Tue, 30 May 2023 10:42:04 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 10:45:02 +0800
Message-ID: <8c3eb711-6428-699e-9ef1-6bbdeb36ffb0@huawei.com>
Date: Tue, 30 May 2023 10:45:02 +0800
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
	<wanghai38@huawei.com>, <peilin.ye@bytedance.com>, <cong.wang@bytedance.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
 <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
 <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
 <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Peilin:
	Thank you for your reply.
On 2023/5/30 8:17, Peilin Ye wrote:
> On Mon, May 29, 2023 at 09:53:28AM -0400, Jamal Hadi Salim wrote:
>> On Mon, May 29, 2023 at 4:59 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>>> On Mon, May 29, 2023 at 09:10:23AM +0800, shaozhengchao wrote:
>>>> On 2023/5/29 3:05, Jamal Hadi Salim wrote:
>>>>> On Sat, May 27, 2023 at 5:30 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>>>>> When use the following command to test:
>>>>>> 1)ip link add bond0 type bond
>>>>>> 2)ip link set bond0 up
>>>>>> 3)tc qdisc add dev bond0 root handle ffff: mq
>>>>>> 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
>>>>>
>>>>> This is fixed by Peilin in this ongoing discussion:
>>>>> https://lore.kernel.org/netdev/cover.1684887977.git.peilin.ye@bytedance.com/
>>>>>
>>>>        Thank you for your reply. I have notice Peilin's patches before,
>>>> and test after the patch is incorporated in local host. But it still
>>>> triggers the problem.
>>>>        Peilin's patches can be filtered out when the query result of
>>>> qdisc_lookup is of the ingress type. Here is 4/6 patch in his patches.
>>>> +if (q->flags & TCQ_F_INGRESS) {
>>>> +     NL_SET_ERR_MSG(extack,
>>>> +                    "Cannot regraft ingress or clsact Qdiscs");
>>>> +     return -EINVAL;
>>>> +}
>>>>        However, the query result of my test case in qdisc_lookup is mq.
>>>> Therefore, the patch cannot solve my problem.
>>>
>>> Ack, they are different: patch [4/6] prevents ingress (clsact) Qdiscs
>>> from being regrafted (to elsewhere), and Zhengchao's patch prevents other
>>> Qdiscs from being regrafted to ffff:fff1.
>>
>> Ok, at first glance it was not obvious.
>> Do we catch all combinations? for egress (0xffffffff) allowed minor is
>> 0xfff3 (clsact::) and 0xffff. For ingress (0xfffffff1) allowed minor
>> is 0xfff1 and 0xfff2(clsact).
> 
> ffff:fff1 is special in tc_modify_qdisc(); if minor isn't fff1,
> tc_modify_qdisc() thinks user wants to graft a Qdisc under existing ingress
> or clsact Qdisc:
> 
> 	if (clid != TC_H_INGRESS) {	/* ffff:fff1 */
> 		p = qdisc_lookup(dev, TC_H_MAJ(clid));
> 		if (!p) {
> 			NL_SET_ERR_MSG(extack, "Failed to find specified qdisc");
> 			return -ENOENT;
> 		}
> 		q = qdisc_leaf(p, clid);
> 	} else if (dev_ingress_queue_create(dev)) {
> 		q = dev_ingress_queue(dev)->qdisc_sleeping;
> 	}
> 
> This will go to the "parent != NULL" path in qdisc_graft(), and
> sch_{ingress,clsact} doesn't implement cl_ops->graft(), so -EOPNOTSUPP will
> be returned.
> 
Yes, I agree.
> In short, yes, I think ffff:fff1 is the only case should be fixed.
> 
> By the way I just noticed that currently it is possible to create a e.g.
> HTB class with a class ID of ffff:fff1...
> 
>    $ tc qdisc add dev eth0 root handle ffff: htb default fff1
>    $ tc class add dev eth0 \
>              parent ffff: classid ffff:fff1 htb rate 100%
> 
> Regrafting a Qdisc to such classes won't work as intended at all.  It's a
> separate issue though.
> 
This seems to be another problem.

Zhengchao Shao
> Thanks,
> Peilin Ye
> 

