Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E8C484F58
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiAEI3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:29:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbiAEI3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:29:52 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2058Epek017432;
        Wed, 5 Jan 2022 08:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : cc : from : subject : to : content-type :
 content-transfer-encoding; s=pp1;
 bh=IzBMxitNbdLyU3nShevN0ViQ22zjFL6d5QbxSUBtHzA=;
 b=ij7comEvQUrKhIYAITrBpgDaljSNib4SyVTON1sFaKQb8CdL7HQOHZPeqNWoNrDi1Zrc
 KUmWCMCkIkaBl8To8cgYDp+IRgjf8L50oRteZFTyKWAsOc7A6cotftILmVlVxOba/Snn
 Ql3HG46dwkJlE6bBdr/1IqiEbzjUjom6P3pf0ZBP4zv3VDoHsaKV0BS9/0Rj7/k4Nn/G
 wYqazaETwkqTfMKkmt1yJy3ew7oOSCYxrD3Mq5avMjj01e9smHaOh694Q7wBImwe3nch
 K4OGllqTpJYiWDefihOm8OFeYTi46fYG22PhB3+OP+p/VYuIYNi40lOyHLM3lZ1LbStq uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dckxsvux6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 08:29:38 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2058ObJW025268;
        Wed, 5 Jan 2022 08:29:37 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dckxsvuwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 08:29:37 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2058SfLT027917;
        Wed, 5 Jan 2022 08:29:36 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3daekb2bqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 08:29:36 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2058TZ3r34406710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jan 2022 08:29:35 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A94C136066;
        Wed,  5 Jan 2022 08:29:35 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DB01136060;
        Wed,  5 Jan 2022 08:29:32 +0000 (GMT)
Received: from [9.43.99.48] (unknown [9.43.99.48])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jan 2022 08:29:31 +0000 (GMT)
Message-ID: <63380c22-a163-2664-62be-2cf401065e73@linux.vnet.ibm.com>
Date:   Wed, 5 Jan 2022 13:56:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
Cc:     alexandr.lobakin@intel.com,
        "kuba@kernel.org >> Jakub Kicinski" <kuba@kernel.org>,
        dumazet@google.com, brian King <brking@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>
From:   Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: [5.16.0-rc5][ppc][net] kernel oops when hotplug remove of vNIC
 interface
To:     linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3lSDvtLjC7hXrJ5K58EV8ilW6-bjGaAw
X-Proofpoint-ORIG-GUID: zg1rzLiCKba6e1FbQN6PtOb5jekeE4Ir
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_02,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 mlxscore=0 bulkscore=0 clxscore=1011 suspectscore=0 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greeting's

Mainline kernel 5.16.0-rc5 panics when DLPAR ADD of vNIC device on my 
Powerpc LPAR

Perform below dlpar commands in a loop from linux OS

drmgr -r -c slot -s U9080.HEX.134C488-V1-C3 -w 5 -d 1
drmgr -a -c slot -s U9080.HEX.134C488-V1-C3 -w 5 -d 1

after 7th iteration, the kernel panics with below messages

console messages:
[102056] ibmvnic 30000003 env3: Sending CRQ: 801e000864000000 
0060000000000000
<intr> ibmvnic 30000003 env3: Handling CRQ: 809e000800000000 
0000000000000000
[102056] ibmvnic 30000003 env3: Disabling tx_scrq[0] irq
[102056] ibmvnic 30000003 env3: Disabling tx_scrq[1] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[0] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[1] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[2] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[3] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[4] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[5] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[6] irq
[102056] ibmvnic 30000003 env3: Disabling rx_scrq[7] irq
[102056] ibmvnic 30000003 env3: Replenished 8 pools
Kernel attempted to read user page (10) - exploit attempt? (uid: 0)
BUG: Kernel NULL pointer dereference on read at 0x00000010
Faulting instruction address: 0xc000000000a3c840
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: bridge stp llc ib_core rpadlpar_io rpaphp nfnetlink 
tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag 
bonding rfkill ibmvnic sunrpc pseries_rng xts vmx_crypto gf128mul 
sch_fq_codel binfmt_misc ip_tables ext4 mbcache jbd2 dm_service_time 
sd_mod t10_pi sg ibmvfc scsi_transport_fc ibmveth dm_multipath dm_mirror 
dm_region_hash dm_log dm_mod fuse
CPU: 9 PID: 102056 Comm: kworker/9:2 Kdump: loaded Not tainted 
5.16.0-rc5-autotest-g6441998e2e37 #1
Workqueue: events_long __ibmvnic_reset [ibmvnic]
NIP:  c000000000a3c840 LR: c0080000029b5378 CTR: c000000000a3c820
REGS: c0000000548e37e0 TRAP: 0300   Not tainted 
(5.16.0-rc5-autotest-g6441998e2e37)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28248484  XER: 00000004
CFAR: c0080000029bdd24 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
GPR00: c0080000029b55d0 c0000000548e3a80 c0000000028f0200 0000000000000000
GPR04: c000000c7d1a7e00 fffffffffffffff6 0000000000000027 c000000c7d1a7e08
GPR08: 0000000000000023 0000000000000000 0000000000000010 c0080000029bdd10
GPR12: c000000000a3c820 c000000c7fca6680 0000000000000000 c000000133016bf8
GPR16: 00000000000003fe 0000000000001000 0000000000000002 0000000000000008
GPR20: c000000133016eb0 0000000000000000 0000000000000000 0000000000000003
GPR24: c000000133016000 c000000133017168 0000000020000000 c000000133016a00
GPR28: 0000000000000006 c000000133016a00 0000000000000001 c000000133016000
NIP [c000000000a3c840] napi_enable+0x20/0xc0
LR [c0080000029b5378] __ibmvnic_open+0xf0/0x430 [ibmvnic]
Call Trace:
[c0000000548e3a80] [0000000000000006] 0x6 (unreliable)
[c0000000548e3ab0] [c0080000029b55d0] __ibmvnic_open+0x348/0x430 [ibmvnic]
[c0000000548e3b40] [c0080000029bcc28] __ibmvnic_reset+0x500/0xdf0 [ibmvnic]
[c0000000548e3c60] [c000000000176228] process_one_work+0x288/0x570
[c0000000548e3d00] [c000000000176588] worker_thread+0x78/0x660
[c0000000548e3da0] [c0000000001822f0] kthread+0x1c0/0x1d0
[c0000000548e3e10] [c00000000000cf64] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
7d2948f8 792307e0 4e800020 60000000 3c4c01eb 384239e0 f821ffd1 39430010
38a0fff6 e92d1100 f9210028 39200000 <e9030010> f9010020 60420000 e9210020
---[ end trace 5f8033b08fd27706 ]---
radix-mmu: Page sizes from device-tree:

the fault instruction points to

[root@ltcden11-lp1 boot]# gdb -batch 
vmlinuz-5.16.0-rc5-autotest-g6441998e2e37 -ex 'list *(0xc000000000a3c840)'
0xc000000000a3c840 is in napi_enable (net/core/dev.c:6966).
6961    void napi_enable(struct napi_struct *n)
6962    {
6963        unsigned long val, new;
6964
6965        do {
6966            val = READ_ONCE(n->state);
6967            BUG_ON(!test_bit(NAPI_STATE_SCHED, &val));
6968
6969            new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
6970            if (n->dev->threaded && n->thread)

-- 
Regard's

Abdul Haleem
IBM Linux Technology Center

