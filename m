Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1823C1C26C8
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgEBQKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 12:10:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728222AbgEBQKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 12:10:39 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042G1vt5076239;
        Sat, 2 May 2020 12:10:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s28dm1gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:10:36 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 042GA2gi091060;
        Sat, 2 May 2020 12:10:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s28dm1fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:10:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042G53qp009348;
        Sat, 2 May 2020 16:10:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5h1nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 16:10:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042G9Mie31916326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 16:09:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A99AAAE045;
        Sat,  2 May 2020 16:10:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72AF4AE055;
        Sat,  2 May 2020 16:10:31 +0000 (GMT)
Received: from [9.145.175.68] (unknown [9.145.175.68])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 16:10:31 +0000 (GMT)
Subject: Re: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200422161329.56026-1-edumazet@google.com>
 <20200422161329.56026-2-edumazet@google.com>
 <a8f1fbf8-b25f-d3aa-27fe-11b1f0fdae3f@linux.ibm.com>
 <CANn89iKid-JWYs6esRYo25NqVdLkLvn6uwiB7wLz_PXuREQQKA@mail.gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <08fd7715-62c3-23b9-ecac-4d0caff71d3e@linux.ibm.com>
Date:   Sat, 2 May 2020 18:10:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKid-JWYs6esRYo25NqVdLkLvn6uwiB7wLz_PXuREQQKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_09:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.05.20 17:40, Eric Dumazet wrote:
> On Sat, May 2, 2020 at 7:56 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>>
>> On 22.04.20 18:13, Eric Dumazet wrote:
>>> Back in commit 3b47d30396ba ("net: gro: add a per device gro flush timer")
>>> we added the ability to arm one high resolution timer, that we used
>>> to keep not-complete packets in GRO engine a bit longer, hoping that further
>>> frames might be added to them.
>>>
>>> Since then, we added the napi_complete_done() interface, and commit
>>> 364b6055738b ("net: busy-poll: return busypolling status to drivers")
>>> allowed drivers to avoid re-arming NIC interrupts if we made a promise
>>> that their NAPI poll() handler would be called in the near future.
>>>
>>> This infrastructure can be leveraged, thanks to a new device parameter,
>>> which allows to arm the napi hrtimer, instead of re-arming the device
>>> hard IRQ.
>>>
>>> We have noticed that on some servers with 32 RX queues or more, the chit-chat
>>> between the NIC and the host caused by IRQ delivery and re-arming could hurt
>>> throughput by ~20% on 100Gbit NIC.
>>>
>>> In contrast, hrtimers are using local (percpu) resources and might have lower
>>> cost.
>>>
>>> The new tunable, named napi_defer_hard_irqs, is placed in the same hierarchy
>>> than gro_flush_timeout (/sys/class/net/ethX/)
>>>
>>
>> Hi Eric,
>> could you please add some Documentation for this new sysfs tunable? Thanks!
>> Looks like gro_flush_timeout is missing the same :).
> 
> 
> Yes. I was planning adding this in
> Documentation/networking/scaling.rst, once our fires are extinguished.
> 
>>
>>
>>> By default, both gro_flush_timeout and napi_defer_hard_irqs are zero.
>>>
>>> This patch does not change the prior behavior of gro_flush_timeout
>>> if used alone : NIC hard irqs should be rearmed as before.
>>>
>>> One concrete usage can be :
>>>
>>> echo 20000 >/sys/class/net/eth1/gro_flush_timeout
>>> echo 10 >/sys/class/net/eth1/napi_defer_hard_irqs
>>>
>>> If at least one packet is retired, then we will reset napi counter
>>> to 10 (napi_defer_hard_irqs), ensuring at least 10 periodic scans
>>> of the queue.
>>>
>>> On busy queues, this should avoid NIC hard IRQ, while before this patch IRQ
>>> avoidance was only possible if napi->poll() was exhausting its budget
>>> and not call napi_complete_done().
>>>
>>
>> I was confused here for a second, so let me just clarify how this is intended
>> to look like for pure TX completion IRQs:
>>
>> napi->poll() calls napi_complete_done() with an accurate work_done value, but
>> then still returns 0 because TX completion work doesn't consume NAPI budget.
> 
> 
> If the napi budget was consumed, the driver does _not_ call
> napi_complete() or napi_complete_done() anyway.
> 

I was thinking of "TX completions are cheap and don't consume _any_ NAPI budget, ever"
as the current consensus, but looking at the mlx4 code that evidently isn't true
for all drivers.

> If the budget is consumed, then napi_complete_done(napi, X>0) allows
> napi_complete_done()
> to return 0 if napi_defer_hard_irqs is not 0
> 
> This means that the NIC hard irq will stay disabled for at least one more round.
>
