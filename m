Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EAB5B2F62
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiIIG76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiIIG74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:59:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88C131EF3;
        Thu,  8 Sep 2022 23:59:53 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2896fV5O021022;
        Fri, 9 Sep 2022 06:59:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=VdJGDocCkEAvlr/kbz4be9zCJIRrD+okGYvBOiKzKHs=;
 b=QyteU72vOXv3+XOBzc0c9AkFn8JWeR0QZpotlu33Sezw7Y6bRGHvvE3mFHAkeArRe3v6
 wxtDuGF7sZOhSKzkw5UdANQ42j2cBxOElpaidI23JnFQOkPidMy8Sud8fn7D5pnOAB41
 6wGZm2vsED5NwYICyFrstItDD6r+HbudYRVRUVmJeMYY5Ccy5EczB/WYKJumLl+mfYf+
 BFNG2Y+dG9SeWWVqO+PN1dzbEIZBF95EI0swWj9dXG4j5SW3vlk1Nh4k7iNE9EWB/jn0
 yUzQkzIsUCmy7lwD9oT+5SMogqEmvAx/QdGcz3+NG840eUTVj9XsgA40YL93VzoBDBNZ TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg0ekgep6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 06:59:48 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2896gHIg025382;
        Fri, 9 Sep 2022 06:59:48 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg0ekgen2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 06:59:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2896oQLa005336;
        Fri, 9 Sep 2022 06:59:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3jbxj8wknh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 06:59:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 289706Go44499404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Sep 2022 07:00:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 285F652050;
        Fri,  9 Sep 2022 06:59:42 +0000 (GMT)
Received: from [9.171.44.45] (unknown [9.171.44.45])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B671F5204F;
        Fri,  9 Sep 2022 06:59:41 +0000 (GMT)
Message-ID: <5a8a8032-e351-ec7e-a05f-693a4aa8bc6d@linux.ibm.com>
Date:   Fri, 9 Sep 2022 08:59:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next v2 00/10] optimize the parallelism of SMC-R
 connections
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
In-Reply-To: <cover.1661407821.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3y8Br9aSy_F4GYv8aMyIkIOuJfl2m9fE
X-Proofpoint-ORIG-GUID: sV4NRSKIaX59OOSzfbKUt3iBqVrRvhQD
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_02,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 mlxlogscore=999
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209090021
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
> This patch set attempts to optimize the parallelism of SMC-R connections,
> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> occur after thoses optimization.
> 
> According to Off-CPU graph, SMC worker's off-CPU as that:
> 
> smc_close_passive_work			(1.09%)
> 	smcr_buf_unuse			(1.08%)
> 		smc_llc_flow_initiate	(1.02%)
> 	
> smc_listen_work 			(48.17%)
> 	__mutex_lock.isra.11 		(47.96%)
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
> smc_close_passive_work					(41.58%)
> 	smcr_buf_unuse					(41.57%)
> 		smc_llc_do_delete_rkey			(41.57%)
> 
> smc_listen_work						(39.10%)
> 	smc_clc_wait_msg				(13.18%)
> 		tcp_recvmsg_locked			(13.18)
> 	smc_listen_find_device				(25.87%)
> 		smcr_lgr_reg_rmbs			(25.87%)
> 			smc_llc_do_confirm_rkey		(25.87%)
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
> |TCP	       |15k   | 35k  |  51k  |  80k   | 100k |  162k  |
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
> priority.
> 3. Remove -EBUSY processing of rhashtable_insert_fast, see more details
> in comments around smcr_link_get_or_create_cluster().
> 4. Only wake up one connection if the link has not been active.
> 5. Delete obsolete unlock logic in smc_listen_work().
> 6. PATCH format, do Reverse Christmas tree.
> 7. PATCH format, change all xxx_lnk_xxx function to xxx_link_xxx.
> 8. PATCH format, add correct fix tag for the patches for fixes.
> 9. PATCH format, fix some spelling error.
> 10.PATCH format, rename slow to do_slow in smcr_lgr_reg_rmbs().
> 
> 
> D. Wythe (10):
>    net/smc: remove locks smc_client_lgr_pending and
>      smc_server_lgr_pending
>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>    net/smc: allow confirm/delete rkey response deliver multiplex
>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>    net/smc: use read semaphores to reduce unnecessary blocking in
>      smc_buf_create() & smcr_buf_unuse()
>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
>    net/smc: Fix potential panic dues to unprotected
>      smc_llc_srv_add_link()
>    net/smc: fix application data exception
> 
>   net/smc/af_smc.c   |  42 +++--
>   net/smc/smc_core.c | 443 +++++++++++++++++++++++++++++++++++++++++++++++------
>   net/smc/smc_core.h |  78 +++++++++-
>   net/smc/smc_llc.c  | 286 +++++++++++++++++++++++++---------
>   net/smc/smc_llc.h  |   6 +
>   net/smc/smc_wr.c   |  10 --
>   net/smc/smc_wr.h   |  10 ++
>   7 files changed, 725 insertions(+), 150 deletions(-)
> 

D.,

I'm sorry.
I replied to the patch 01/10 with the test results and not the cover 
letter. I have a filter on my inbox separating everything for "net/smc:" 
and the keywords are missing on this cover letter.
Mea culpa.

https://lore.kernel.org/netdev/1767b6e4-0053-728b-9722-add68da13781@linux.ibm.com/

- Jan
