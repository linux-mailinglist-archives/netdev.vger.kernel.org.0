Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247BE605863
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiJTHYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiJTHYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:24:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826F2317C2;
        Thu, 20 Oct 2022 00:24:43 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K6bqaI011765;
        Thu, 20 Oct 2022 07:24:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qAonZ3btuT45t59SGJ8U5rXkCFpJMdwLzYQrnXcW5pk=;
 b=nyywbQJVMI1lXmcavkkejz4mvK3ROpKDAsd8lKQuPYXM8V5pMVXeRStZE/4ZdsKDI7gN
 ZHL64VpGZEdWx/VHaDrLHx5ra0iOWxN7q/vw0rWzsNV/7Lqvu/7D79ZqlkYk5D06GN+l
 UypvPOpwfWkChl2LCTNYrL68NkC6BVh89slSgbaV402jOsn4M2xm5HcI/aVFEW1bue9e
 rP+37Lep/9AWC+PniW1Bue7iimJe0AZzwD4EONHtAWKjd3hAmndPvYhO9JO9W0mqHe+9
 zxAd8wIGE45dOfgqhCmNYzw8w7YCAfhyTvP3Ewh9LXinU8hi/st3e/cA7dG3XD+poGYT OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb0yh1mh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 07:24:37 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K6cPJ4014760;
        Thu, 20 Oct 2022 07:24:37 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb0yh1mgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 07:24:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K7LPrK030643;
        Thu, 20 Oct 2022 07:24:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98fg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 07:24:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K7OXv034668814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 07:24:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64663AE045;
        Thu, 20 Oct 2022 07:24:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB669AE055;
        Thu, 20 Oct 2022 07:24:32 +0000 (GMT)
Received: from [9.171.15.191] (unknown [9.171.15.191])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 07:24:32 +0000 (GMT)
Message-ID: <492ada12-4e46-bb45-bc4b-1962e4530764@linux.ibm.com>
Date:   Thu, 20 Oct 2022 09:24:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH net-next v3 00/10] optimize the parallelism of SMC-R
 connections
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
 <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -QXIULwT6xitUyZdUZBZWBG3oyAIqtTH
X-Proofpoint-ORIG-GUID: s_UB_NbW76xitksnTUQPCK0FZUoySiq5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1011
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.10.2022 09:00, D. Wythe wrote:
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

Hi D. Wythe,

no problem and thank you. I'm going to test your changes and let you 
know as soon as I'm done.

- Jan

> 
> 
> On 10/20/22 2:43 PM, D.Wythe wrote:
>> From: "D.Wythe" <alibuda@linux.alibaba.com>
>>
>> This patch set attempts to optimize the parallelism of SMC-R connections,
>> mainly to reduce unnecessary blocking on locks, and to fix exceptions 
>> that
>> occur after thoses optimization.
>>
>> According to Off-CPU graph, SMC worker's off-CPU as that:
>>
>> smc_close_passive_work                  (1.09%)
>>          smcr_buf_unuse                  (1.08%)
>>                  smc_llc_flow_initiate   (1.02%)
>>
>> smc_listen_work                         (48.17%)
>>          __mutex_lock.isra.11            (47.96%)
>>
>>
>> An ideal SMC-R connection process should only block on the IO events
>> of the network, but it's quite clear that the SMC-R connection now is
>> queued on the lock most of the time.
>>
>> The goal of this patchset is to achieve our ideal situation where
>> network IO events are blocked for the majority of the connection 
>> lifetime.
>>
>> There are three big locks here:
>>
>> 1. smc_client_lgr_pending & smc_server_lgr_pending
>>
>> 2. llc_conf_mutex
>>
>> 3. rmbs_lock & sndbufs_lock
>>
>> And an implementation issue:
>>
>> 1. confirm/delete rkey msg can't be sent concurrently while
>> protocol allows indeed.
>>
>> Unfortunately,The above problems together affect the parallelism of
>> SMC-R connection. If any of them are not solved. our goal cannot
>> be achieved.
>>
>> After this patch set, we can get a quite ideal off-CPU graph as
>> following:
>>
>> smc_close_passive_work                                  (41.58%)
>>          smcr_buf_unuse                                  (41.57%)
>>                  smc_llc_do_delete_rkey                  (41.57%)
>>
>> smc_listen_work                                         (39.10%)
>>          smc_clc_wait_msg                                (13.18%)
>>                  tcp_recvmsg_locked                      (13.18)
>>          smc_listen_find_device                          (25.87%)
>>                  smcr_lgr_reg_rmbs                       (25.87%)
>>                          smc_llc_do_confirm_rkey         (25.87%)
>>
>> We can see that most of the waiting times are waiting for network IO
>> events. This also has a certain performance improvement on our
>> short-lived conenction wrk/nginx benchmark test:
>>
>> +--------------+------+------+-------+--------+------+--------+
>> |conns/qps     |c4    | c8   |  c16  |  c32   | c64  |  c200  |
>> +--------------+------+------+-------+--------+------+--------+
>> |SMC-R before  |9.7k  | 10k  |  10k  |  9.9k  | 9.1k |  8.9k  |
>> +--------------+------+------+-------+--------+------+--------+
>> |SMC-R now     |13k   | 19k  |  18k  |  16k   | 15k  |  12k   |
>> +--------------+------+------+-------+--------+------+--------+
>> |TCP           |15k   | 35k  |  51k  |  80k   | 100k |  162k  |
>> +--------------+------+------+-------+--------+------+--------+
>>
>> The reason why the benefit is not obvious after the number of connections
>> has increased dues to workqueue. If we try to change workqueue to 
>> UNBOUND,
>> we can obtain at least 4-5 times performance improvement, reach up to 
>> half
>> of TCP. However, this is not an elegant solution, the optimization of it
>> will be much more complicated. But in any case, we will submit relevant
>> optimization patches as soon as possible.
>>
>> Please note that the premise here is that the lock related problem
>> must be solved first, otherwise, no matter how we optimize the workqueue,
>> there won't be much improvement.
>>
>> Because there are a lot of related changes to the code, if you have
>> any questions or suggestions, please let me know.
>>
>> Thanks
>> D. Wythe
>>
>> v1 -> v2:
>>
>> 1. Fix panic in SMC-D scenario
>> 2. Fix lnkc related hashfn calculation exception, caused by operator
>> priority
>> 3. Only wake up one connection if the lnk is not active
>> 4. Delete obsolete unlock logic in smc_listen_work()
>> 5. PATCH format, do Reverse Christmas tree
>> 6. PATCH format, change all xxx_lnk_xxx function to xxx_link_xxx
>> 7. PATCH format, add correct fix tag for the patches for fixes.
>> 8. PATCH format, fix some spelling error
>> 9. PATCH format, rename slow to do_slow
>>
>> v2 -> v3:
>>
>> 1. add SMC-D support, remove the concept of link cluster since SMC-D has
>> no link at all. Replace it by lgr decision maker, who provides 
>> suggestions
>> to SMC-D and SMC-R on whether to create new link group.
>>
>> 2. Fix the corruption problem described by PATCH 'fix application
>> data exception' on SMC-D.
>>
>> D. Wythe (10):
>>    net/smc: remove locks smc_client_lgr_pending and
>>      smc_server_lgr_pending
>>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>>    net/smc: allow confirm/delete rkey response deliver multiplex
>>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>>    net/smc: use read semaphores to reduce unnecessary blocking in
>>      smc_buf_create() & smcr_buf_unuse()
>>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
>>    net/smc: Fix potential panic dues to unprotected
>>      smc_llc_srv_add_link()
>>    net/smc: fix application data exception
>>
>>   net/smc/af_smc.c   |  70 ++++----
>>   net/smc/smc_core.c | 478 
>> +++++++++++++++++++++++++++++++++++++++++++++++------
>>   net/smc/smc_core.h |  36 +++-
>>   net/smc/smc_llc.c  | 277 ++++++++++++++++++++++---------
>>   net/smc/smc_llc.h  |   6 +
>>   net/smc/smc_wr.c   |  10 --
>>   net/smc/smc_wr.h   |  10 ++
>>   7 files changed, 712 insertions(+), 175 deletions(-)
>>
