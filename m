Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743755A80DA
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiHaPEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHaPEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:04:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF360D3EE3;
        Wed, 31 Aug 2022 08:04:28 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VEkv1k010041;
        Wed, 31 Aug 2022 15:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=a/NxA4zKOXr3tHCr9wMQwFDF+L0SrZ0PEEQKTQcro3E=;
 b=SxnOOfHmZUM71b8nhv4/RoTa4sWw+WVSA6cCc/R2auko9hyOwgIqfZEMK2mXWHeT5cft
 H7knIK9fUvL0hRn5EV+3KE6RWfcS0heObfHXNPR/6Zm1Ln0lk4lj9gDebCsyK2R44E12
 kDWZbA/h644gM8X0IdULOqN9BFuwD0iCFMjsQdd+NqGqw/Gkh0ZC7i6taJcMhdvJYeHi
 HDmqH7pUqvDV0D4GgAGTH996XrNn/uBQoyU59lSt7PswI6zxmTNSLFK6MqSyGu8BIR9S
 hhsfRjPhVrhKieMQE4HRqWpz/Oq+7eEVtQZaTHAlZqiiuC/61y+frWkD/4lQiA/NBzfa UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ja99nacau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:04:18 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27VEudWa013922;
        Wed, 31 Aug 2022 15:04:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ja99nac8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:04:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27VEpjrx031300;
        Wed, 31 Aug 2022 15:04:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3j7aw8wcyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:04:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27VF4CIZ39911752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 15:04:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FDA4A4051;
        Wed, 31 Aug 2022 15:04:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7851CA4040;
        Wed, 31 Aug 2022 15:04:11 +0000 (GMT)
Received: from [9.171.6.210] (unknown [9.171.6.210])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 31 Aug 2022 15:04:11 +0000 (GMT)
Message-ID: <f8ac755b-242b-acbb-a50c-7c6fcd3be736@linux.ibm.com>
Date:   Wed, 31 Aug 2022 17:04:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net-next v2 01/10] net/smc: remove locks
 smc_client_lgr_pending and smc_server_lgr_pending
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
 <688d165fe630989665e5091a28a5b1238123fbdc.1661407821.git.alibuda@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
In-Reply-To: <688d165fe630989665e5091a28a5b1238123fbdc.1661407821.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QAr59WbhjhgpnWT4sxRMDQIgo28S-2w1
X-Proofpoint-GUID: XWQUHODHhpjaHTB-MB6IC8YIlXK2nlq-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_09,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.08.2022 11:51, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patch attempts to remove locks named smc_client_lgr_pending and
> smc_server_lgr_pending, which aim to serialize the creation of link
> group. However, once link group existed already, those locks are
> meaningless, worse still, they make incoming connections have to be
> queued one after the other.
> 
> Now, the creation of link group is no longer generated by competition,
> but allocated through following strategy.
> 
> 1. Try to find a suitable link group, if successd, current connection
> is considered as NON first contact connection. ends.
> 
> 2. Check the number of connections currently waiting for a suitable
> link group to be created, if it is not less that the number of link
> groups to be created multiplied by (SMC_RMBS_PER_LGR_MAX - 1), then
> increase the number of link groups to be created, current connection
> is considered as the first contact connection. ends.
> 
> 3. Increase the number of connections currently waiting, and wait
> for woken up.
> 
> 4. Decrease the number of connections currently waiting, goto 1.
> 
> We wake up the connection that was put to sleep in stage 3 through
> the SMC link state change event. Once the link moves out of the
> SMC_LNK_ACTIVATING state, decrease the number of link groups to
> be created, and then wake up at most (SMC_RMBS_PER_LGR_MAX - 1)
> connections.
> 
> In the iplementation, we introduce the concept of lnk cluster, which is
> a collection of links with the same characteristics (see
> smcr_lnk_cluster_cmpfn() with more details), which makes it possible to
> wake up efficiently in the scenario of N v.s 1.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

Hello D.,

thanks for the v2 and the patience.
I got to testing and as with v1 I want to share our findings with you. 
If you need more information or want us to look deeper into the findings 
please let us know.

Regarding SMC-R test-suite:
We see a refcount error during one of our stress tests. This lets us 
believe that the smc_link_cluster_put() to smc_link_cluster_hold() ratio 
is not right anymore.
The patch provided by yacan does fix this issue but we did not verify if 
it is the right way to balance the hold and put calls.

[root@t8345011 ~]# journalctl --dmesg | tail -100
Aug 31 16:17:36 t8345011.lnxne.boe smc-tests: test_smcapp_50x_ifdown started
Aug 31 16:17:46 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000100 net 1 
link removed: id 00000101, peerid 00000101, ibdev mlx5_0, ibport 1
Aug 31 16:17:46 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000100 net 1 
state changed: SINGLE, pnetid NET25
Aug 31 16:17:46 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000100 net 1 
link added: id 00000103, peerid 00000103, ibdev mlx5_0, ibport 1
Aug 31 16:17:46 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000100 net 1 
state changed: ASYMMETRIC_PEER, pnetid NET25
Aug 31 16:17:55 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000100 net 1 
link added: id 00000104, peerid 00000104, ibdev mlx5_0, ibport 1
Aug 31 16:17:55 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000100 net 1 
state changed: SYMMETRIC, pnetid NET25
Aug 31 16:17:55 t8345011.lnxne.boe kernel: ------------[ cut here 
]------------
Aug 31 16:17:55 t8345011.lnxne.boe kernel: refcount_t: underflow; 
use-after-free.
Aug 31 16:17:55 t8345011.lnxne.boe kernel: WARNING: CPU: 1 PID: 150 at 
lib/refcount.c:87 refcount_dec_not_one+0x88/0xa8
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Modules linked in: smc_diag 
tcp_diag inet_diag nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set 
nf_tables nfnetlink mlx5_ib ism smc ib_uverbs ib_core vfio_ccw mdev 
s390_trng vfio_iommu_type1 vfio sch_fq_codel configfs ip_tables x_tables 
ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes 
sha3_512_s390 sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common 
pkey zcrypt rng_core autofs4
Aug 31 16:17:55 t8345011.lnxne.boe kernel: CPU: 1 PID: 150 Comm: 
kworker/1:2 Not tainted 6.0.0-rc2-00493-g91ecd751199f #8
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Hardware name: IBM 8561 T01 
701 (z/VM 7.2.0)
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Workqueue: events 
smc_llc_add_link_work [smc]
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Krnl PSW : 0704c00180000000 
000000005b31f32c (refcount_dec_not_one+0x8c/0xa8)
Aug 31 16:17:55 t8345011.lnxne.boe kernel:            R:0 T:1 IO:1 EX:1 
Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Krnl GPRS: 00000000ffffffea 
0000000000000027 0000000000000026 000000005c3151e0
Aug 31 16:17:55 t8345011.lnxne.boe kernel:            00000000fee80000 
0000038000000001 000000008e0e9a00 000000008de79c24
Aug 31 16:17:55 t8345011.lnxne.boe kernel:            0000038000000000 
000003ff803f05ac 0000000095038360 000000008de79c00
Aug 31 16:17:55 t8345011.lnxne.boe kernel:            00000000828ca100 
0000000095038360 000000005b31f328 0000038000943b50
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Krnl Code: 000000005b31f31c: 
c02000466122        larl        %r2,000000005bbeb560
                                                       000000005b31f322: 
c0e500232e53        brasl        %r14,000000005b784fc8
                                                      #000000005b31f328: 
af000000                mc        0,0
                                                      >000000005b31f32c: 
a7280001                lhi        %r2,1
                                                       000000005b31f330: 
ebeff0a00004        lmg        %r14,%r15,160(%r15)
                                                       000000005b31f336: 
ec223fbf0055        risbg        %r2,%r2,63,191,0
                                                       000000005b31f33c: 
07fe                bcr        15,%r14
                                                       000000005b31f33e: 
47000700                bc        0,1792
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Call Trace:
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000000005b31f32c>] 
refcount_dec_not_one+0x8c/0xa8
Aug 31 16:17:55 t8345011.lnxne.boe kernel: ([<000000005b31f328>] 
refcount_dec_not_one+0x88/0xa8)
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000003ff803ef16a>] 
smcr_link_cluster_on_link_state.part.0+0x1ba/0x440 [smc]
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000003ff803f05ac>] 
smcr_link_clear+0x5c/0x1b0 [smc]
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000003ff803fadf4>] 
smc_llc_add_link_work+0x43c/0x470 [smc]
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000000005ac1f0e2>] 
process_one_work+0x1fa/0x478
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000000005ac1f88c>] 
worker_thread+0x64/0x468
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000000005ac28580>] 
kthread+0x108/0x110
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000000005abaf2dc>] 
__ret_from_fork+0x3c/0x58
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000000005b7a4d6a>] 
ret_from_fork+0xa/0x40
Aug 31 16:17:55 t8345011.lnxne.boe kernel: Last Breaking-Event-Address:
Aug 31 16:17:55 t8345011.lnxne.boe kernel:  [<000000005b785028>] 
__warn_printk+0x60/0x68
Aug 31 16:17:55 t8345011.lnxne.boe kernel: ---[ end trace 
0000000000000000 ]---
Aug 31 16:17:55 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000100 net 1 
link removed: id 00000103, peerid 00000103, ibdev mlx5_0, ibport 1
[root@t8345011 ~]#



Regarding SMC-D test-suite:
For SMC-D we also see errors during another stress test. While we expect 
connections to fall back to TCP due to the limit of parallel connections 
your patch introduces TCP fallbacks with a new reason.

[root@t8345011 ~]# journalctl --dmesg | tail -10
Aug 31 16:30:07 t8345011.lnxne.boe smc-tests: 
test_oob7_send_multi_urg_at_start started
Aug 31 16:30:16 t8345011.lnxne.boe smc-tests: 
test_oob8_ignore_some_urg_data started
Aug 31 16:30:30 t8345011.lnxne.boe smc-tests: test_smc_tool_second started
Aug 31 16:30:34 t8345011.lnxne.boe smc-tests: test_tshark started
Aug 31 16:30:34 t8345011.lnxne.boe smc-tests: test_smcapp_torture_test 
started
Aug 31 16:30:49 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000400 net 1 
link added: id 00000401, peerid 00000401, ibdev mlx5_0, ibport 1
Aug 31 16:30:49 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000400 net 1 
state changed: SINGLE, pnetid NET25
Aug 31 16:30:49 t8345011.lnxne.boe kernel: TCP: request_sock_TCP: 
Possible SYN flooding on port 51897. Sending cookies.  Check SNMP counters.
Aug 31 16:30:49 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000400 net 1 
link added: id 00000402, peerid 00000402, ibdev mlx5_1, ibport 1
Aug 31 16:30:49 t8345011.lnxne.boe kernel: smc: SMC-R lg 00000400 net 1 
state changed: SYMMETRIC, pnetid NET25

^
I am wondering why we see SMC-R dmesgs even if we communicate with 
SMC-D. Gotta verify that. Can be an error on our side.

[root@t8345011 ~]#
[root@t8345011 ~]# smcss
ACTIVE         00000 0067005 10.25.45.10:48096       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0067001 10.25.45.10:48060       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0066999 10.25.45.10:48054       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0068762 10.25.45.10:48046       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0066997 10.25.45.10:48044       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0068760 10.25.45.10:48036       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0066995 10.25.45.10:48026       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0068758 10.25.45.10:48024       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0066993 10.25.45.10:48022       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0068756 10.25.45.10:48006       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0066991 10.25.45.10:47998       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0068754 10.25.45.10:47984       10.25.45.11:51897 
     0000 SMCD
ACTIVE         00000 0067124 10.25.45.11:51897       10.25.45.10:48314 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0067121 10.25.45.11:51897       10.25.45.10:48302 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0067120 10.25.45.11:51897       10.25.45.10:48284 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0067114 10.25.45.11:51897       10.25.45.10:48282 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0067115 10.25.45.11:51897       10.25.45.10:48254 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0067111 10.25.45.11:51897       10.25.45.10:48250 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0066415 10.25.45.11:51897       10.25.45.10:48242 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0067113 10.25.45.11:51897       10.25.45.10:48230 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0066409 10.25.45.11:51897       10.25.45.10:48202 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0066413 10.25.45.11:51897       10.25.45.10:48214 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0066414 10.25.45.11:51897       10.25.45.10:48204 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0066397 10.25.45.11:51897       10.25.45.10:48120 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0066399 10.25.45.11:51897       10.25.45.10:48084 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0066396 10.25.45.11:51897       10.25.45.10:48078 
     0000 TCP 0x05000000/0x030d0000
ACTIVE         00000 0062632 10.25.45.11:51897       10.25.45.10:43120 
     0000 TCP 0x03010000
ACTIVE         00000 0062631 10.25.45.11:51897       10.25.45.10:43134 
     0000 TCP 0x03010000
ACTIVE         00000 0062626 10.25.45.11:51897       10.25.45.10:43106 
     0000 TCP 0x03010000
ACTIVE         00000 0062625 10.25.45.11:51897       10.25.45.10:43138 
     0000 TCP 0x03010000
ACTIVE         00000 0062621 10.25.45.11:51897       10.25.45.10:43160 
     0000 TCP 0x03010000
ACTIVE         00000 0061580 10.25.45.11:51897       10.25.45.10:42820 
     0000 TCP 0x03010000
ACTIVE         00000 0061558 10.25.45.11:51897       10.25.45.10:42792 
     0000 TCP 0x03010000
ACTIVE         00000 0061549 10.25.45.11:51897       10.25.45.10:42816 
     0000 TCP 0x03010000
ACTIVE         00000 0061548 10.25.45.11:51897       10.25.45.10:42764 
     0000 TCP 0x03010000
ACTIVE         00000 0061544 10.25.45.11:51897       10.25.45.10:42804 
     0000 TCP 0x03010000
ACTIVE         00000 0061543 10.25.45.11:51897       10.25.45.10:42856 
     0000 TCP 0x03010000
ACTIVE         00000 0061542 10.25.45.11:51897       10.25.45.10:42756 
     0000 TCP 0x03010000
ACTIVE         00000 0062554 10.25.45.11:51897       10.25.45.10:42852 
     0000 TCP 0x03010000
ACTIVE         00000 0062553 10.25.45.11:51897       10.25.45.10:42844 
     0000 TCP 0x03010000
ACTIVE         00000 0062549 10.25.45.11:51897       10.25.45.10:42836 
     0000 TCP 0x03010000

^
Here SMCD and 0x05000000/0x030d0000 are expected. But:
   [353] smcss confirmed connection of type SMCD
   [353] Error: Found TCP fallback due to unexpected reasons: 0x03010000
We also exeperience that the lsmod count stays above 2 even after the 
testcase finished and takes quite a while before it goes down again (we 
send a kill signal at the end of our testcase).

During test (which is fine)

[root@t8345011 ~]# lsmod | grep smc
smc_diag               16384  0
smc                   225280  2981 ism,smc_diag
ib_core               413696  3 smc,ib_uverbs,mlx5_ib

Count > 2 even after tests finish!

[root@t8345011 ~]# lsmod | grep smc
smc_diag               16384  0
smc                   225280  40 ism,smc_diag
ib_core               413696  3 smc,ib_uverbs,mlx5_ib

Let us know if you need any more information.
Thanks, Jan
