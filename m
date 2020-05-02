Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6CE1C265C
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 16:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgEBO4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 10:56:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728068AbgEBO42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 10:56:28 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042EWD3l054168;
        Sat, 2 May 2020 10:56:27 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s28djq9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 10:56:27 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 042EipPD076283;
        Sat, 2 May 2020 10:56:27 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s28djq94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 10:56:27 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042Esoh2020742;
        Sat, 2 May 2020 14:56:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g58cgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 14:56:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042EuMmu8782122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 14:56:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BEBCAE045;
        Sat,  2 May 2020 14:56:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BDBBAE051;
        Sat,  2 May 2020 14:56:22 +0000 (GMT)
Received: from [9.145.175.68] (unknown [9.145.175.68])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 14:56:22 +0000 (GMT)
Subject: Re: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200422161329.56026-1-edumazet@google.com>
 <20200422161329.56026-2-edumazet@google.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <a8f1fbf8-b25f-d3aa-27fe-11b1f0fdae3f@linux.ibm.com>
Date:   Sat, 2 May 2020 16:56:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422161329.56026-2-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_07:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.04.20 18:13, Eric Dumazet wrote:
> Back in commit 3b47d30396ba ("net: gro: add a per device gro flush timer")
> we added the ability to arm one high resolution timer, that we used
> to keep not-complete packets in GRO engine a bit longer, hoping that further
> frames might be added to them.
> 
> Since then, we added the napi_complete_done() interface, and commit
> 364b6055738b ("net: busy-poll: return busypolling status to drivers")
> allowed drivers to avoid re-arming NIC interrupts if we made a promise
> that their NAPI poll() handler would be called in the near future.
> 
> This infrastructure can be leveraged, thanks to a new device parameter,
> which allows to arm the napi hrtimer, instead of re-arming the device
> hard IRQ.
> 
> We have noticed that on some servers with 32 RX queues or more, the chit-chat
> between the NIC and the host caused by IRQ delivery and re-arming could hurt
> throughput by ~20% on 100Gbit NIC.
> 
> In contrast, hrtimers are using local (percpu) resources and might have lower
> cost.
> 
> The new tunable, named napi_defer_hard_irqs, is placed in the same hierarchy
> than gro_flush_timeout (/sys/class/net/ethX/)
> 

Hi Eric,
could you please add some Documentation for this new sysfs tunable? Thanks!
Looks like gro_flush_timeout is missing the same :).

> By default, both gro_flush_timeout and napi_defer_hard_irqs are zero.
> 
> This patch does not change the prior behavior of gro_flush_timeout
> if used alone : NIC hard irqs should be rearmed as before.
> 
> One concrete usage can be :
> 
> echo 20000 >/sys/class/net/eth1/gro_flush_timeout
> echo 10 >/sys/class/net/eth1/napi_defer_hard_irqs
> 
> If at least one packet is retired, then we will reset napi counter
> to 10 (napi_defer_hard_irqs), ensuring at least 10 periodic scans
> of the queue.
> 
> On busy queues, this should avoid NIC hard IRQ, while before this patch IRQ
> avoidance was only possible if napi->poll() was exhausting its budget
> and not call napi_complete_done().
> 

I was confused here for a second, so let me just clarify how this is intended
to look like for pure TX completion IRQs:

napi->poll() calls napi_complete_done() with an accurate work_done value, but
then still returns 0 because TX completion work doesn't consume NAPI budget.

> This feature also can be used to work around some non-optimal NIC irq
> coalescing strategies.
> 
> Having the ability to insert XX usec delays between each napi->poll()
> can increase cache efficiency, since we increase batch sizes.
> 
> It also keeps serving cpus not idle too long, reducing tail latencies.
> 
> Co-developed-by: Luigi Rizzo <lrizzo@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
