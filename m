Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952A568A07A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbjBCRhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjBCRhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:37:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29D6AA25F;
        Fri,  3 Feb 2023 09:36:51 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313HHnqY003249;
        Fri, 3 Feb 2023 17:36:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TSxDEBmRifL/9qGJzi+cnHy93kLLSmu3sNQPp6mziH0=;
 b=bMUAuLOG+bjQ3KLQEeTtZTE/6d2zK6K3yJaAwD6yRsoXATzPqrjtkOYRFVzMvhS7ePdR
 u5ZFCyMaMWsFc/DMBxW10vBmcQFdzJsHV+ZpAGMPXeYIHEkqjhvcGDLYMBrLd8PRY3/3
 Sr1IWw8wgtD8khDhdXUu15YfvRI8BFIZ3HiI5/Vnly3Aq6NqtKajcVRsk0skL9cCiFSF
 IT6tXICVSPLNxXy1gbyemjhJx00BHnubVzA3YqReF09ZAUoo/NQjagrnPtbRFMP4rr4o
 EEfJX8HmtHt0NYwbBj1WwiPDDxiWz9qACUVWk551nYr3ZN3ZWV+KcE7fSirittMSdD2N 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh6hp8fsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:36:39 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313HKLW6013677;
        Fri, 3 Feb 2023 17:36:39 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh6hp8frs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:36:39 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 313Fcv7I026861;
        Fri, 3 Feb 2023 17:36:38 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3ncvtnhwmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:36:38 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313HaaC86357644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 17:36:37 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A064C58062;
        Fri,  3 Feb 2023 17:36:36 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B0D758059;
        Fri,  3 Feb 2023 17:36:35 +0000 (GMT)
Received: from [9.163.93.135] (unknown [9.163.93.135])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 17:36:35 +0000 (GMT)
Message-ID: <47a5d56c-ec68-5966-031f-5dfa85fd4e06@linux.ibm.com>
Date:   Fri, 3 Feb 2023 18:36:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next v7 0/4] net/smc: optimize the parallelism of SMC-R
 connections
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1675326402-109943-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1675326402-109943-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4-P1rsR1f7lNuCX0jzl9E4wyyBRykRIH
X-Proofpoint-GUID: XMD3veZ87V-bqX3kCY0Q2YjbQGDGiunB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_16,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302030152
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.02.23 09:26, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
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
> v5 -> v6:
> 
> 1. Separate the bugfix patches to make it independent.
> 2. Merge patch 'fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending'
> with patch 'remove locks smc_client_lgr_pending and smc_server_lgr_pending'
> 3. Format code styles, including alignment and reverse christmas tree
> style.
> 4. Fix a possible memory leak in smc_llc_rmt_delete_rkey()
> and smc_llc_rmt_conf_rkey().
> 
> v6 -> v7:
> 
> 1. Discard patch attempting to remove global locks
> 2. Discard patch attempting make confirm/delete rkey process concurrently
> 
> D. Wythe (4):
>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>    net/smc: use read semaphores to reduce unnecessary blocking in
>      smc_buf_create() & smcr_buf_unuse()
>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
> 
>   net/smc/af_smc.c   | 25 ++++++++++++++----
>   net/smc/smc_core.c | 75 +++++++++++++++++++++++++++---------------------------
>   net/smc/smc_core.h |  6 ++---
>   net/smc/smc_llc.c  | 34 ++++++++++++-------------
>   4 files changed, 78 insertions(+), 62 deletions(-)
> 
Thank you for the patches!
First a good news, I did some tests by running SMC_LLC_FLOW_RKEY 
concurrently on one peer while on another peer not, it looks good. So I 
don't think that the communication with z/OS would be broken through 
these patches.
But I still need some time to test them thoghouly, I'll let you know ASAP.
