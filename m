Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C10663740E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiKXIft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiKXIfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:35:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F659D1C14;
        Thu, 24 Nov 2022 00:35:45 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO7KI6F014283;
        Thu, 24 Nov 2022 08:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xe2Lmn7xfYMXtTGnCdTB8Ubg/Bmgko6jgQwiTauVbiM=;
 b=E6YTwIGrEZ5yJxMVt0rSkXkMAauODuhoxIQ+g22+FjNiQ6se8nV0dVqM4NAdfX1x8UyF
 pBybGh/hd2Ze3/8vjJFb08X1DnIgJICr7SORVaIdmQD9ZeulVhhimtQISW8YLx+SEVHO
 /izQQCEvpUHb7Hud+ns2E/YnFZ4K3jNjr1qD5WdVZxU7LOv48H+2S0en8+113qg6rcpn
 BVHGe1oiBKvmcRF9WwfKCIkLbCs1SfjKP2SqCxC/SCSM6FvA+/dlYAY00wUyUZLMAiTb
 2a7sd7ZUz86k5041ldmyP42N8L0/ZZKs/+8ZrLot8kYLu+syCzTrFktxFwXwOMB20vxO DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153m90q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 08:35:40 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AO8ZeVv031231;
        Thu, 24 Nov 2022 08:35:40 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153m8ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 08:35:40 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AO8ZNTt000909;
        Thu, 24 Nov 2022 08:35:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3kxps8wpby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 08:35:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AO8ZYR354919666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 08:35:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9596711C04A;
        Thu, 24 Nov 2022 08:35:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B22111C050;
        Thu, 24 Nov 2022 08:35:34 +0000 (GMT)
Received: from [9.171.82.62] (unknown [9.171.82.62])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 08:35:34 +0000 (GMT)
Message-ID: <5930673b-3d1f-b0d1-7cc5-b4e3bbd3bcd2@linux.ibm.com>
Date:   Thu, 24 Nov 2022 09:35:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v5 00/10] optimize the parallelism of SMC-R
 connections
To:     "D.Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EvBJ7KAYXt069-6uT2yu8DiLeXPmdSGC
X-Proofpoint-GUID: di6WJ6bs7f4PgY-6Gkp7DWNLG5Ls_6_u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_05,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211240067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/11/2022 16:54, D.Wythe wrote:
> From: "D.Wythe" <alibuda@linux.alibaba.com>
> 
> This patch set attempts to optimize the parallelism of SMC-R connections,
> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> occur after thoses optimization.
> 
> According to Off-CPU graph, SMC worker's off-CPU as that:
> 
> smc_close_passive_work                  (1.09%)
>          smcr_buf_unuse                  (1.08%)
>                  smc_llc_flow_initiate   (1.02%)
> 
> smc_listen_work                         (48.17%)
>          __mutex_lock.isra.11            (47.96%)
> 
> 
> An ideal SMC-R connection process should only block on the IO events
> of the network, but it's quite clear that the SMC-R connection now is
> queued on the lock most of the time.
> 
> The goal of this patchset is to achieve our ideal situation where
> network IO events are blocked for the majority of the connection lifetime.
> 
> There are three big locks here:
> 
> 1. smc_client_lgr_pending & smc_server_lgr_pending
> 
> 2. llc_conf_mutex
> 
> 3. rmbs_lock & sndbufs_lock
> 
> And an implementation issue:
> 
> 1. confirm/delete rkey msg can't be sent concurrently while
> protocol allows indeed.
> 
> Unfortunately,The above problems together affect the parallelism of
> SMC-R connection. If any of them are not solved. our goal cannot
> be achieved.
> 
> After this patch set, we can get a quite ideal off-CPU graph as
> following:
> 
> smc_close_passive_work                                  (41.58%)
>          smcr_buf_unuse                                  (41.57%)
>                  smc_llc_do_delete_rkey                  (41.57%)
> 
> smc_listen_work                                         (39.10%)
>          smc_clc_wait_msg                                (13.18%)
>                  tcp_recvmsg_locked                      (13.18)
>          smc_listen_find_device                          (25.87%)
>                  smcr_lgr_reg_rmbs                       (25.87%)
>                          smc_llc_do_confirm_rkey         (25.87%)
> 
> We can see that most of the waiting times are waiting for network IO
> events. This also has a certain performance improvement on our
> short-lived conenction wrk/nginx benchmark test:
> 
> +--------------+------+------+-------+--------+------+--------+
> |conns/qps     |c4    | c8   |  c16  |  c32   | c64  |  c200  |
> +--------------+------+------+-------+--------+------+--------+
> |SMC-R before  |9.7k  | 10k  |  10k  |  9.9k  | 9.1k |  8.9k  |
> +--------------+------+------+-------+--------+------+--------+
> |SMC-R now     |13k   | 19k  |  18k  |  16k   | 15k  |  12k   |
> +--------------+------+------+-------+--------+------+--------+
> |TCP           |15k   | 35k  |  51k  |  80k   | 100k |  162k  |
> +--------------+------+------+-------+--------+------+--------+
> 
> The reason why the benefit is not obvious after the number of connections
> has increased dues to workqueue. If we try to change workqueue to UNBOUND,
> we can obtain at least 4-5 times performance improvement, reach up to half
> of TCP. However, this is not an elegant solution, the optimization of it
> will be much more complicated. But in any case, we will submit relevant
> optimization patches as soon as possible.
> 
> Please note that the premise here is that the lock related problem
> must be solved first, otherwise, no matter how we optimize the workqueue,
> there won't be much improvement.
> 
> Because there are a lot of related changes to the code, if you have
> any questions or suggestions, please let me know.
> 
> Thanks
> D. Wythe

Thank you for your submission.

I'm going to test the new patch. Please give us some time to do so.

Thank you
- Jan
> 
> v1 -> v2:
> 
> 1. Fix panic in SMC-D scenario
> 2. Fix lnkc related hashfn calculation exception, caused by operator
> priority
> 3. Only wake up one connection if the lnk is not active
> 4. Delete obsolete unlock logic in smc_listen_work()
> 5. PATCH format, do Reverse Christmas tree
> 6. PATCH format, change all xxx_lnk_xxx function to xxx_link_xxx
> 7. PATCH format, add correct fix tag for the patches for fixes.
> 8. PATCH format, fix some spelling error
> 9. PATCH format, rename slow to do_slow
> 
> v2 -> v3:
> 
> 1. add SMC-D support, remove the concept of link cluster since SMC-D has
> no link at all. Replace it by lgr decision maker, who provides suggestions
> to SMC-D and SMC-R on whether to create new link group.
> 
> 2. Fix the corruption problem described by PATCH 'fix application
> data exception' on SMC-D.
> 
> v3 -> v4:
> 
> 1. Fix panic caused by uninitialization map.
> 
> v4 -> v5:
> 
> 1. Make SMC-D buf creation be serial to avoid Potential error
> 2. Add a flag to synchronize the success of the first contact
> with the ready of the link group, including SMC-D and SMC-R.
> 3. Fixed possible reference count leak in smc_llc_flow_start().
> 4. reorder the patch, make bugfix PATCH be ahead.
> 
> D. Wythe (10):
>    net/smc: Fix potential panic dues to unprotected
>      smc_llc_srv_add_link()
>    net/smc: fix application data exception
>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>    net/smc: remove locks smc_client_lgr_pending and
>      smc_server_lgr_pending
>    net/smc: allow confirm/delete rkey response deliver multiplex
>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>    net/smc: use read semaphores to reduce unnecessary blocking in
>      smc_buf_create() & smcr_buf_unuse()
>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
> 
>   net/smc/af_smc.c   |  74 ++++----
>   net/smc/smc_core.c | 541 +++++++++++++++++++++++++++++++++++++++++++++++------
>   net/smc/smc_core.h |  53 +++++-
>   net/smc/smc_llc.c  | 285 ++++++++++++++++++++--------
>   net/smc/smc_llc.h  |   6 +
>   net/smc/smc_wr.c   |  10 -
>   net/smc/smc_wr.h   |  10 +
>   7 files changed, 801 insertions(+), 178 deletions(-)
> 
