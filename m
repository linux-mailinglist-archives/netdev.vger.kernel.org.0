Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9545A437071
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 05:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhJVDSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 23:18:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32420 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230349AbhJVDSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 23:18:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M0asSl029183;
        Thu, 21 Oct 2021 23:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=qJel+OJ1TgF+3oWM8lV5h1vas/rk6pTaMgnFgGIUFR4=;
 b=R+KOB/pfggZRd9sIXGaoVtp5dBSsOoRKwyUiQZJzOufdfaUnboPXtmTgrcHSTG0UyCTg
 iyRa7dj1hYIlnrtQnBseCNT95HAkOUu+6qg7oOG1OTz+UMmn9yLMLyTQ2rXhLNcWOVSA
 QarsqQ/4h2HWo+4DWGUMNzklEZJ17DccjlLWFH5lhd6TT9JpbOl1LgdcY9cyoC03IIu+
 5Nb3o/GA9YV4R2Vs1vfZM6l25/QWolP8LvMgltZHK4d6sI3xevLOcgoXr/YekZQAmdAW
 Grk2aLaTQzS0NaHWTOHVO7Fc96LEAO1jn1vTnWSfGptdP4Fo5TdVL7EtC1XPGGxBJJbC GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bua9hdsq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 23:16:17 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19M2xXSG016682;
        Thu, 21 Oct 2021 23:16:16 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bua9hdspy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 23:16:16 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19M3Fcfr012691;
        Fri, 22 Oct 2021 03:16:15 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 3bqpcdqdca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 03:16:15 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19M3GEGe52494764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 03:16:14 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E34E6136066;
        Fri, 22 Oct 2021 03:16:13 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE89213605E;
        Fri, 22 Oct 2021 03:16:09 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.160.35.45])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with SMTP;
        Fri, 22 Oct 2021 03:16:09 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id BC8BC2E14F8; Thu, 21 Oct 2021 20:16:04 -0700 (PDT)
Date:   Thu, 21 Oct 2021 20:16:04 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linyunsheng@huawei.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <YXIs9GRNtNbl8MkZ@us.ibm.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
 <YW3t8AGxW6p261hw@us.ibm.com>
 <20211018155503.74aeaba9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ULofOzCVYu6DkbJO2XQdqSIF5FoQTNO
X-Proofpoint-ORIG-GUID: 4uqj_FC4xZRzesp2uxo2Iz16G__tBfTW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_01,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dany Madden [drt@linux.ibm.com] wrote:
> 
> We hit two napi related crashes while attempting mtu size change.
> 
> 1st crash:
> [430425.020051] ------------[ cut here ]------------
> [430425.020053] kernel BUG at ../net/core/dev.c:6938!
> [430425.020057] Oops: Exception in kernel mode, sig: 5 [#1]
> [430425.020068] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> [430425.020075] Modules linked in: binfmt_misc rpadlpar_io rpaphp xt_tcpudp
> iptable_filter ip_tables x_tables pseries_rng ibmvnic rng_core ibmveth
> vmx_crypto gf128mul fuse btrfs blake2b_generic xor zstd_compress
> lzo_compress raid6_pq dm_service_time crc32c_vpmsum dm_mirror dm_region_hash
> dm_log dm_multipath scsi_dh_rdac scsi_dh_alua autofs4
> [430425.020123] CPU: 0 PID: 34337 Comm: kworker/0:3 Kdump: loaded Tainted: G
> W     5.15.0-rc2-suka-00486-gce916130f5f6 #3
> [430425.020133] Workqueue: events_long __ibmvnic_reset [ibmvnic]
> [430425.020145] NIP: c000000000cb03f4 LR: c0080000014a4ce8 CTR:
> c000000000cb03b0
> [430425.020151] REGS: c00000002e5d37e0 TRAP: 0700  Tainted: G    W
> (5.15.0-rc2-suka-00486-gce916130f5f6)
> [430425.020159] MSR: 800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE> CR:
> 28248428 XER: 20000001
> [430425.020176] CFAR: c0080000014ad9cc IRQMASK: 0
>         GPR00: c0080000014a4ce8 c00000002e5d3a80 c000000001b12100
> c0000001274f3190
>         GPR04: 00000000ffff36dc fffffffffffffff6 0000000000000019
> 0000000000000010
>         GPR08: c00000002ec48900 0000000000000001 c0000001274f31a0
> c0080000014ad9b8
>         GPR12: c000000000cb03b0 c000000001d00000 0000000080000000
> 00000000000003fe
>         GPR16: 00000000000006e3 0000000000000000 0000000000000008
> c00000002ec48af8
>         GPR20: c00000002ec48db0 0000000000000000 0000000000000004
> 0000000000000000
>         GPR24: c00000002ec48000 0000000000000004 c00000002ec49070
> 0000000000000006
>         GPR28: c00000002ec48900 c00000002ec48900 0000000000000002
> c00000002ec48000
> [430425.020248] NIP [c000000000cb03f4] napi_enable+0x44/0xc0
> [430425.020257] LR [c0080000014a4ce8] __ibmvnic_open+0xf0/0x440 [ibmvnic]
> [430425.020265] Call Trace:
> [430425.020269] [c00000002e5d3a80] [c00000002ec48900] 0xc00000002ec48900
> (unreliable)
> [430425.020277] [c00000002e5d3ab0] [c0080000014a4f40]
> __ibmvnic_open+0x348/0x440 [ibmvnic]
> [430425.020286] [c00000002e5d3b40] [c0080000014ace58]
> __ibmvnic_reset+0xb10/0xe40 [ibmvnic]
> [430425.020296] [c00000002e5d3c60] [c0000000001673a4]
> process_one_work+0x2d4/0x5d0
> [430425.020305] [c00000002e5d3d00] [c000000000167718]
> worker_thread+0x78/0x6c0
> [430425.020314] [c00000002e5d3da0] [c000000000173388] kthread+0x188/0x190
> [430425.020322] [c00000002e5d3e10] [c00000000000cee4]
> ret_from_kernel_thread+0x5c/0x64
> [430425.020331] Instruction dump:
> [430425.020335] 38a0fff6 39430010 e92d0c80 f9210028 39200000 60000000
> 60000000 e9030010
> [430425.020348] f9010020 e9210020 7d2948f8 792907e0 <0b090000> e9230038
> 7d072838 89290889
> [430425.020364] ---[ end trace 3abb5ec5589518ca ]---
> [430425.068100]
> [430425.068108] Sending IPI to other CPUs
> [430425.068206] IPI complete
> [430425.090333] kexec: Starting switchover sequence.

Jakub,

We hit this napi_enable() BUG_ON() crash three times this week. In two
of those times it appears that

	napi->state = netdev_priv(netdev)

i.e it contains ibmvnic_adapter* in our case.

	# Crash was on eth3

	crash> net |grep eth3
	c00000002e948000  eth3   10.1.194.173

	crash> net_device |grep SIZE
	SIZE: 2304

	crash> px 2304
	$1 = 0x900

	crash> ibmvnic_adapter c00000002e948900 |grep napi
	  napi = 0xc00000003b7dc000,
	  num_active_rx_napi = 8,
	  napi_enabled = false,

	crash> napi_struct 0xc00000003b7dc000 |grep state
	  state = 13835058056063650048,
	    state = 0 '\000',

	crash> px 13835058056063650048
	$2 = 0xc00000002e948900		#eth3 ibmvnic_adapter above

In the third case napi->state was 16 (i.e NAPI_STATE_SCHED was clear and
hence the bug in napi_enable()).

Let us know if any other fields are of interest. Do we have any clues on
when this started?

Sukadev
