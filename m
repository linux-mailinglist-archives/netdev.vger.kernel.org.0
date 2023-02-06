Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515D168BAF7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBFLG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjBFLG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:06:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D766A1ABD7;
        Mon,  6 Feb 2023 03:06:55 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316Arjp4031883;
        Mon, 6 Feb 2023 11:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8hyQRgU95rvFaDSwKrnPII4W8DXMYZWoQL2UVCCZhkk=;
 b=M8Dk+1EfxGLQC3ZiMNxQ3GxAXcOBzbDvpn1hQbnlWU77G9wdHMbV5ykYR9nGX7EB5Na1
 Qs8XTshLAaAT9yODZUEMsE3Vg9qZZ3YLzbxS4sOEFaCL5x6YGhzmZ7LXVP+3V2+stmzT
 0ZfXFelnD7KzOj4dwXBHQfkGgCTg694HQZ+wqjJZWfOgLxmyVSpcVjaV+V2C20yqKF7K
 8pUXO3ckWZtbOAQoGzveD+suN/j7MJ8uxgoa3bw6G4Q9CAGnXhberE06KqP7NBZto5eX
 +bnIsdRhryDiRStJP9mv4ETGtk20ttKT6fMOOjZt2IdnuasmrGR64kwC4Hk3kb5J2Iqr jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk06w0af6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 11:06:50 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316AswBq004197;
        Mon, 6 Feb 2023 11:06:50 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk06w0aer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 11:06:50 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316833vo020150;
        Mon, 6 Feb 2023 11:06:49 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3nhf072bnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 11:06:49 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316B6m316029952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 11:06:48 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 123F158079;
        Mon,  6 Feb 2023 11:06:48 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2444A5805C;
        Mon,  6 Feb 2023 11:06:46 +0000 (GMT)
Received: from [9.163.48.193] (unknown [9.163.48.193])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 11:06:45 +0000 (GMT)
Message-ID: <273e8c67-fbb0-edd8-600f-512c1a6812f3@linux.ibm.com>
Date:   Mon, 6 Feb 2023 12:06:45 +0100
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
X-Proofpoint-GUID: Ze6rGbl2fvvwt-avf8T9OYFz1NDmdjPJ
X-Proofpoint-ORIG-GUID: V0TDIY2PEPEJTzTg89nBFfuM-zwilosh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_05,2023-02-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060095
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
This answer seems too late ;-)

I did some test as thoroughly as I can, it looks good to me.

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>

