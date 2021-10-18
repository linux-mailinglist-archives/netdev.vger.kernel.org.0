Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5C432A62
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhJRXjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:39:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229524AbhJRXjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 19:39:12 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IKxXDT024816;
        Mon, 18 Oct 2021 19:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=kzA5HNO4PQchdRsCTqWXPdBQZud78SiuQPgIGFZN+8w=;
 b=j4CVLpExg4B01OtNgB9GcTVNtRmV4f9SNC6YGEa6BfgKaYEUr7B8qosprLptH3PNUKU6
 C+i8KbJce9J2VdjgR37BZUEwc/fPl8w65/o6nTix+rlZL/D49fIn7ck7XVqOak9TXo0b
 l0wBgfrmLmVnGMch5LInIgWAw2ODO5fj0PEIaJ8A2VFuY7vEqhqwgidKDDCo10YW5h/6
 ApQm2tS8yOCo6jDyvfX4uXZiCyElnoYIZ4AebcYhQVoKNzgCIO+A+TXnCGu6b/KgWDDk
 fLb80QKwN/YYlamYdnnR0pI4FFIPAmH546Mo8ngD5xMsj+Obb10KelfANqEIAs6uyzwh Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bsfwhu72k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 19:36:39 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19INadoY005599;
        Mon, 18 Oct 2021 19:36:39 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bsfwhu729-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 19:36:39 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19INHNho029487;
        Mon, 18 Oct 2021 23:36:38 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3bqpcbbnsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 23:36:38 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19INabmm31654384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 23:36:37 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42681AC065;
        Mon, 18 Oct 2021 23:36:37 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AFD5AC062;
        Mon, 18 Oct 2021 23:36:36 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 18 Oct 2021 23:36:36 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 18 Oct 2021 16:36:36 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linyunsheng@huawei.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?Q?B?= =?UTF-8?Q?j=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
In-Reply-To: <20211018155503.74aeaba9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
 <YW3t8AGxW6p261hw@us.ibm.com>
 <20211018155503.74aeaba9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FadrIKvtbLR1014lqpr_0rXUY0la0Zlh
X-Proofpoint-GUID: dmZyUY8FbYEGlKNBzJrSySgtnxoxS4V8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-18 15:55, Jakub Kicinski wrote:
> On Mon, 18 Oct 2021 14:58:08 -0700 Sukadev Bhattiprolu wrote:
>> >                       CPU0       |                   CPU1       | napi.state
>> > ===============================================================================
>> > napi_disable()                   |                              | SCHED | NPSVC
>> > napi_enable()                    |                              |
>> > {                                |                              |
>> >     smp_mb__before_atomic();     |                              |
>> >     clear_bit(SCHED, &n->state); |                              | NPSVC
>> >                                  | napi_schedule_prep()         | SCHED | NPSVC
>> >                                  | napi_poll()                  |
>> >                                  |   napi_complete_done()       |
>> >                                  |   {                          |
>> >                                  |      if (n->state & (NPSVC | | (1)
>> >                                  |               _BUSY_POLL)))  |
>> >                                  |           return false;      |
>> >                                  |     ................         |
>> >                                  |   }                          | SCHED | NPSVC
>> >                                  |                              |
>> >     clear_bit(NPSVC, &n->state); |                              | SCHED
>> > }                                |                              |
>> 
>> So its possible that after cpu0 cleared SCHED, cpu1 could have set it
>> back and we are going to use cmpxchg() to detect and retry right? If 
>> so,
> 
> This is a state diagram before the change. There's no cmpxchg() here.
> 
>> > napi_schedule_prep()             |                              | SCHED | MISSED (2)
>> >
>> > (1) Here return direct. Because of NAPI_STATE_NPSVC exists.
>> > (2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list
>> >
>> > Since NAPI_STATE_SCHED already exists and napi is not in the
>> > sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
>> > exist.
>> >
>> > 1. This will cause this queue to no longer receive packets.
>> > 2. If you encounter napi_disable under the protection of rtnl_lock, it
>> >    will cause the entire rtnl_lock to be locked, affecting the overall
>> >    system.
>> >
>> > This patch uses cmpxchg to implement napi_enable(), which ensures that
>> > there will be no race due to the separation of clear two bits.
>> >
>> > Fixes: 2d8bff12699abc ("netpoll: Close race condition between poll_one_napi and napi_disable")
>> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>> > ---
>> >  net/core/dev.c | 16 ++++++++++------
>> >  1 file changed, 10 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/net/core/dev.c b/net/core/dev.c
>> > index 74fd402d26dd..7ee9fecd3aff 100644
>> > --- a/net/core/dev.c
>> > +++ b/net/core/dev.c
>> > @@ -6923,12 +6923,16 @@ EXPORT_SYMBOL(napi_disable);
>> >   */
>> >  void napi_enable(struct napi_struct *n)
>> >  {
>> > -	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
>> > -	smp_mb__before_atomic();
>> > -	clear_bit(NAPI_STATE_SCHED, &n->state);
>> > -	clear_bit(NAPI_STATE_NPSVC, &n->state);
>> > -	if (n->dev->threaded && n->thread)
>> > -		set_bit(NAPI_STATE_THREADED, &n->state);
>> > +	unsigned long val, new;
>> > +
>> > +	do {
>> > +		val = READ_ONCE(n->state);
>> > +		BUG_ON(!test_bit(NAPI_STATE_SCHED, &val));
>> 
>> is this BUG_ON valid/needed? We could have lost the cmpxchg() and
>> the other thread could have set NAPI_STATE_SCHED?
> 
> The BUG_ON() is here to make sure that when napi_enable() is called the
> napi instance was dormant, i.e. disabled. We have "STATE_SCHED" bit set
> on disabled NAPIs because that bit means ownership. Whoever disabled
> the NAPI owns it.
> 
> That BUG_ON() could have been taken outside of the loop, there's no
> point re-checking on every try.
> 
> Are you seeing NAPI-related failures? We had at least 3 reports in the
> last two weeks of strange failures which look like NAPI state getting
> corrupted on net-next...

We hit two napi related crashes while attempting mtu size change.

1st crash:
[430425.020051] ------------[ cut here ]------------
[430425.020053] kernel BUG at ../net/core/dev.c:6938!
[430425.020057] Oops: Exception in kernel mode, sig: 5 [#1]
[430425.020068] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
[430425.020075] Modules linked in: binfmt_misc rpadlpar_io rpaphp 
xt_tcpudp iptable_filter ip_tables x_tables pseries_rng ibmvnic rng_core 
ibmveth vmx_crypto gf128mul fuse btrfs blake2b_generic xor zstd_compress 
lzo_compress raid6_pq dm_service_time crc32c_vpmsum dm_mirror 
dm_region_hash dm_log dm_multipath scsi_dh_rdac scsi_dh_alua autofs4
[430425.020123] CPU: 0 PID: 34337 Comm: kworker/0:3 Kdump: loaded 
Tainted: G    W     5.15.0-rc2-suka-00486-gce916130f5f6 #3
[430425.020133] Workqueue: events_long __ibmvnic_reset [ibmvnic]
[430425.020145] NIP: c000000000cb03f4 LR: c0080000014a4ce8 CTR: 
c000000000cb03b0
[430425.020151] REGS: c00000002e5d37e0 TRAP: 0700  Tainted: G    W     
(5.15.0-rc2-suka-00486-gce916130f5f6)
[430425.020159] MSR: 800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE> 
CR: 28248428 XER: 20000001
[430425.020176] CFAR: c0080000014ad9cc IRQMASK: 0
         GPR00: c0080000014a4ce8 c00000002e5d3a80 c000000001b12100 
c0000001274f3190
         GPR04: 00000000ffff36dc fffffffffffffff6 0000000000000019 
0000000000000010
         GPR08: c00000002ec48900 0000000000000001 c0000001274f31a0 
c0080000014ad9b8
         GPR12: c000000000cb03b0 c000000001d00000 0000000080000000 
00000000000003fe
         GPR16: 00000000000006e3 0000000000000000 0000000000000008 
c00000002ec48af8
         GPR20: c00000002ec48db0 0000000000000000 0000000000000004 
0000000000000000
         GPR24: c00000002ec48000 0000000000000004 c00000002ec49070 
0000000000000006
         GPR28: c00000002ec48900 c00000002ec48900 0000000000000002 
c00000002ec48000
[430425.020248] NIP [c000000000cb03f4] napi_enable+0x44/0xc0
[430425.020257] LR [c0080000014a4ce8] __ibmvnic_open+0xf0/0x440 
[ibmvnic]
[430425.020265] Call Trace:
[430425.020269] [c00000002e5d3a80] [c00000002ec48900] 0xc00000002ec48900 
(unreliable)
[430425.020277] [c00000002e5d3ab0] [c0080000014a4f40] 
__ibmvnic_open+0x348/0x440 [ibmvnic]
[430425.020286] [c00000002e5d3b40] [c0080000014ace58] 
__ibmvnic_reset+0xb10/0xe40 [ibmvnic]
[430425.020296] [c00000002e5d3c60] [c0000000001673a4] 
process_one_work+0x2d4/0x5d0
[430425.020305] [c00000002e5d3d00] [c000000000167718] 
worker_thread+0x78/0x6c0
[430425.020314] [c00000002e5d3da0] [c000000000173388] 
kthread+0x188/0x190
[430425.020322] [c00000002e5d3e10] [c00000000000cee4] 
ret_from_kernel_thread+0x5c/0x64
[430425.020331] Instruction dump:
[430425.020335] 38a0fff6 39430010 e92d0c80 f9210028 39200000 60000000 
60000000 e9030010
[430425.020348] f9010020 e9210020 7d2948f8 792907e0 <0b090000> e9230038 
7d072838 89290889
[430425.020364] ---[ end trace 3abb5ec5589518ca ]---
[430425.068100]
[430425.068108] Sending IPI to other CPUs
[430425.068206] IPI complete
[430425.090333] kexec: Starting switchover sequence.

2nd crash:
[ 1526.539335] NAPI poll function 0x96b6b00f7adfd returned 0, exceeding 
its budget of -49738736.
[ 1526.539349] BUG: Kernel NULL pointer dereference on read at 
0x00000000
[ 1526.539354] Faulting instruction address: 0xc000000000cc4054
[ 1526.539358] Oops: Kernel access of bad area, sig: 11 [#1]
[ 1526.539376] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
[ 1526.539390] Modules linked in: rpadlpar_io rpaphp xt_tcpudp 
iptable_filter ip_tables x_tables pseries_rng ibmvnic rng_core ibmveth 
vmx_crypto gf128mul fuse btrfs blake2b_generic xor zstd_compress 
lzo_compress raid6_pq dm_service_time crc32c_vpmsum dm_mirror 
dm_region_hash dm_log dm_multipath scsi_dh_rdac scsi_dh_alua autofs4
[ 1526.539469] CPU: 0 PID: 11 Comm: ksoftirqd/0 Kdump: loaded Not 
tainted 5.15.0-rc2-suka-00489-gd86e74e0e2e9 #4
[ 1526.539484] NIP: c000000000cc4054 LR: c000000000cc4494 CTR: 
c00000000089b9f0
[ 1526.539495] REGS: c00000000652b790 TRAP: 0380  Not tainted 
(5.15.0-rc2-suka-00489-gd86e74e0e2e9)
[ 1526.539506] MSR: 800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE> 
CR: 28004224 XER: 20000001
[ 1526.539538] CFAR: c000000000cc4490 IRQMASK: 0
         GPR00: c000000000cc4494 c00000000652ba30 c000000001b12100 
c0000003fd090d08
         GPR04: 00000000fffeffff c00000000652b800 0000000000000027 
c0000003fd007e08
         GPR08: 0000000000000023 0000000000000000 0000000000000027 
0000000000000001
         GPR12: 0000000028004224 c000000001d00000 c0000000064ceb00 
0000000000000001
         GPR16: 0000000000000000 c000000001b33a00 000000010001df1f 
0000000000000003
         GPR20: c0000003fd090c00 0000000000000026 ffffffffffffffff 
0000000000000000
         GPR24: c000000001b33a00 c00000000652bba8 000000010001df20 
c00000000652ba58
         GPR28: c00000000652bb97 fffffffffd090c10 c0000003fd090d08 
0000000000000000
[ 1526.539661] NIP [c000000000cc4054] 
netif_receive_skb_list_internal+0x54/0x340
[ 1526.539675] LR [c000000000cc4494] gro_normal_list.part.149+0x34/0x60
[ 1526.539687] Call Trace:
[ 1526.539696] [c00000000652ba30] [c0000000001ca308] 
vprintk_emit+0xe8/0x2b0 (unreliable)
[ 1526.539713] [c00000000652bab0] [c000000000cc4494] 
gro_normal_list.part.149+0x34/0x60
[ 1526.539727] [c00000000652bae0] [c000000000cc6340] 
__napi_poll+0x250/0x330
[ 1526.539741] [c00000000652bb70] [c000000000cc697c] 
net_rx_action+0x31c/0x370
[ 1526.539754] [c00000000652bc20] [c000000000f3c8fc] 
__do_softirq+0x16c/0x420
[ 1526.539768] [c00000000652bd20] [c000000000147654] 
run_ksoftirqd+0x64/0x90
[ 1526.539783] [c00000000652bd40] [c00000000017955c] 
smpboot_thread_fn+0x21c/0x260
[ 1526.539796] [c00000000652bda0] [c000000000173388] kthread+0x188/0x190
[ 1526.539812] [c00000000652be10] [c00000000000cee4] 
ret_from_kernel_thread+0x5c/0x64
[ 1526.539827] Instruction dump:
[ 1526.539835] fbe1fff8 7c7e1b78 f8010010 f821ff81 ebe30000 3b610028 
e92d0c80 f9210048
[ 1526.539858] 39200000 fb610028 fb610030 7fa3f840 <eb9f0000> 419e004c 
7ffdfb78 60000000
[ 1526.539884] ---[ end trace e9681bc32653835d ]---
[ 1526.559758]
[ 1526.559766] Sending IPI to other CPUs
[ 1526.559858] IPI complete
[ 1526.581983] kexec: Starting switchover sequence.
