Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5D60769A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJUL5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiJUL53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:57:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6989C2625FE;
        Fri, 21 Oct 2022 04:57:28 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LBpn7f009452;
        Fri, 21 Oct 2022 11:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JUWdKP7UQxM9UygK5tjN54X0/wf803Ofxb7csYiY9sU=;
 b=dqcS1wUzoe5ynlPuGgpr2C5wpr8BGBwiT38HmxXSjoEvapC1pMp8E6BOfMmGbpRLpydV
 uaU4dacOlHXi8uox1M9jPueaioDRFbHSEzorlNYayPpGbP/FU1GBWFZOdURURi0iOrkl
 AcOn4kla6Mm2HD51nD/8NqVa2/ne7avuPUU+7OeW3L2ueO+rANFALfbmWZLYtxXFQxfJ
 3waIvAgeqoAhhAesH6OnPvlbWl3dlkwWvcT3Ko/c8ePav5r8AY2JUEk0EUfy/pSdn0I6
 IxS/OeVlepxJ2W/+ga26WXIbNJxvd25V6670ISqSbNdA6DEjfHqfHTaHWMCC9utdCZ3k /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbtx483dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 11:57:24 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29LBrHtd018038;
        Fri, 21 Oct 2022 11:57:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbtx483ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 11:57:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29LBpiER024981;
        Fri, 21 Oct 2022 11:57:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg9ae84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 11:57:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29LBvJR4459352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 11:57:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83A2D11C04C;
        Fri, 21 Oct 2022 11:57:19 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C7F211C04A;
        Fri, 21 Oct 2022 11:57:19 +0000 (GMT)
Received: from [9.171.54.56] (unknown [9.171.54.56])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 11:57:19 +0000 (GMT)
Message-ID: <79e3bccb-55c2-3b92-b14a-7378ef02dd78@linux.ibm.com>
Date:   Fri, 21 Oct 2022 13:57:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v3 00/10] optimize the parallelism of SMC-R
 connections
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
 <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ORNH1YVa6BC3GhamkWuDDHmdhGp4NK0f
X-Proofpoint-GUID: 7ZnzHKw6eGu30sOuJVtzn4Z_Itp6TfZ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 bulkscore=0 clxscore=1015 mlxlogscore=697 spamscore=0 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/10/2022 09:00, D. Wythe wrote:
> 
> Hi Jan,
> 
> Sorry for the long delay, The main purpose of v3 is to put optimizes 
> also works on SMC-D, dues to the environment,
> I can only tests it in SMC-R, so please help us to verify the stability 
> and functional in SMC-D,
> Thanks a lot.
> 
> If you have any problems, please let us know.
> 
> Besides, PATCH bug fixes need to be reordered. After the code review 
> passes and the SMC-D test goes stable, I will adjust it
> in next serial.
> 
> 

Hi D. Wythe,

thank you again for your submission. I ran the first tests and here are 
my findings:

For SMC-R we are facing problems during unloading of the smc module:

vvvvvvvvvv

[root@testsys10 ~]# dmesg -C
[root@testsys10 ~]# dmesg
[root@testsys10 ~]# rmmod ism
[root@testsys10 ~]# rmmod smc_diag
[root@testsys10 ~]# dmesg
[   51.671365] smc: removing smcd device 1522:00:00.0
[root@testsys10 ~]# rmmod smc
[root@testsys10 ~]# dmesg
[   51.671365] smc: removing smcd device 1522:00:00.0
[   65.378445] NET: Unregistered PF_SMC protocol family
[   65.378463] ------------[ cut here ]------------
[   65.378465] WARNING: CPU: 0 PID: 1155 at kernel/workqueue.c:3066 
__flush_work.isra.0+0x28a/0x298
[   65.378476] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_nat mlx5_ib nf_conntrack ib_uverbs nf_defrag_ipv6 
nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_core smc(-) ib_core 
vfio_ccw s390_trng mdev vfio_iommu_type1 vfio sch_fq_codel configfs 
ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes 
sha3_512_s390 sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common 
pkey zcrypt rng_core autofs4 [last unloaded: smc_diag]
[   65.378509] CPU: 0 PID: 1155 Comm: rmmod Not tainted 
6.1.0-rc1-00035-g9980a965416f #4
[   65.378514] Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)
[   65.378517] Krnl PSW : 0704c00180000000 00000000f9d5f17e 
(__flush_work.isra.0+0x28e/0x298)
[   65.378523]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 RI:0 EA:3
[   65.380675] Krnl GPRS: 8000000000000001 0000000000000000 
000003ff7fd40270 0000000000000000
[   65.380683]            0000038000c73d70 000e002100000000 
0000000000000000 0000000000000001
[   65.380686]            0000038000c73d70 0000000000000000 
000003ff7fd40270 000003ff7fd40270
[   65.380688]            000000009b8d2100 000003ffe38f98f8 
0000038000c73cd0 0000038000c73c30
[   65.380697] Krnl Code: 00000000f9d5f172: a7780000            lhi 
%r7,0
                           00000000f9d5f176: a7f4ff7b            brc 
15,00000000f9d5f06c
                          #00000000f9d5f17a: af000000            mc      0,0
                          >00000000f9d5f17e: a7780000            lhi 
%r7,0
                           00000000f9d5f182: a7f4ff75            brc 
15,00000000f9d5f06c
                           00000000f9d5f186: 0707                bcr 
0,%r7
                           00000000f9d5f188: c004005daa34        brcl 
0,00000000fa9145f0
                           00000000f9d5f18e: ebaff0680024        stmg 
%r10,%r15,104(%r15)
[   65.380773] Call Trace:
[   65.380774]  [<00000000f9d5f17e>] __flush_work.isra.0+0x28e/0x298
[   65.380779]  [<00000000f9d61228>] __cancel_work_timer+0x130/0x1c0
[   65.380782]  [<00000000fa46b1b4>] rhashtable_free_and_destroy+0x2c/0x170
[   65.380787]  [<000003ff7fd3a08e>] smc_exit+0x3e/0x1b8 [smc]
[   65.380804]  [<00000000f9de946a>] __do_sys_delete_module+0x1a2/0x298
[   65.380809]  [<00000000fa8f85ac>] __do_syscall+0x1d4/0x200
[   65.380814]  [<00000000fa907722>] system_call+0x82/0xb0
[   65.380817] Last Breaking-Event-Address:
[   65.380818]  [<00000000f9d5ef24>] __flush_work.isra.0+0x34/0x298
[   65.380820] ---[ end trace 0000000000000000 ]---
[   65.380828] smc: removing ib device mlx5_0
[   65.380833] smc: removing ib device mlx5_1

^^^^^^^^^^

For SMC-D it seems like your decisionmaker is causing some troubles 
(crash). I did not have the time yet to look into it, i still dump you 
the console log - maybe you're seeing the problem faster then me:


vvvvvvvvvv

[  135.528259] smc-tests: test_cs_security started
[  136.397056] illegal operation: 0001 ilc:1 [#1] SMP
[  136.397064] Modules linked in: tcp_diag inet_diag ism mlx5_ib 
ib_uverbs mlx5_core smc_diag smc ib_core vmur nft_fib_inet nft_fib_
ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defra
g_ipv6 nf_defrag_ipv4 ip_set nf_tab
[  136.397093] CPU: 0 PID: 9 Comm: kworker/0:1 Not tainted 
6.1.0-rc1-00035-g1c11cab281ca #4
[  136.397098] Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)
[  136.397100] Workqueue: smc_hs_wq smc_listen_work [smc]
[  136.397123] Krnl PSW : 0704e00180000000 0000000000000002 (0x2)
[  136.397128]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 
PM:0 RI:0 EA:3
[  136.397133] Krnl GPRS: 0000000000000001 0000000000000000 
00000000a5670600 0000000000000000

[  136.398410]            0000000000000000 000003ff7feee620 
00000000000000c8 0000000000000000
[  136.398417]            000003ff7feed2b8 00000000a5670600 
000003ff7feed168 000003ff7fed1628
[  136.398420]            0000000080334200 0000000000000001 
000003ff7fed3ab0 0000037fffb5fa30
[  136.398425] Krnl Code:#0000000000000000: 0000                illegal
[  136.398425]           >0000000000000002: 0000                illegal
[  136.398425]            0000000000000004: 0000                illegal
[  136.398425]            0000000000000006: 0000                illegal
[  136.398425]            0000000000000008: 0000                illegal
[  136.398425]            000000000000000a: 0000                illegal
[  136.398425]            000000000000000c: 0000                illegal
[  136.398425]            000000000000000e: 0000                illegal
[  136.398465] Call Trace:
[  136.398469]  [<0000000000000002>] 0x2
[  136.398472] ([<00000001790fdbde>] release_sock+0x6e/0xd8)
[  136.398482]  [<000003ff7fed746a>] smc_conn_create+0xc2/0x9d8 [smc]
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP 
stop from CPU 01.
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP 
stop from CPU 00.

[  136.408436]  [<000003ff7fec8206>] 
smc_find_ism_v2_device_serv+0x186/0x288 [smc]
[  136.408444]  [<000003ff7fec8336>] smc_listen_find_device+0x2e/0x370 [smc]
[  136.408452]  [<000003ff7fecaa8a>] smc_listen_work+0x2ca/0x580 [smc]
[  136.408459]  [<00000001788481e8>] process_one_work+0x200/0x458
[  136.408466]  [<000000017884896e>] worker_thread+0x66/0x480
[  136.408470]  [<0000000178851888>] kthread+0x108/0x110
[  136.408474]  [<00000001787d72cc>] __ret_from_fork+0x3c/0x58
[  136.408478]  [<00000001793ef75a>] ret_from_fork+0xa/0x40
[  136.408484] Last Breaking-Event-Address:
[  136.408486]  [<000003ff7fed3aae>] 
smc_get_or_create_lgr_decision_maker.constprop.0+0xe6/0x398 [smc]
[  136.408495] Kernel panic - not syncing: Fatal exception in interrupt

^^^^^^^^^^

- Jan

