Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59EE638424
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 07:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiKYGzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 01:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKYGzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 01:55:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D612B60F;
        Thu, 24 Nov 2022 22:55:04 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP6UMQc038350;
        Fri, 25 Nov 2022 06:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ciVnNQJMq+vfSxaPWLiqzNSxx0S9DYjGEhmBi6qK9ak=;
 b=hgNUwVHNdroQchgg9upUB+Y3wYdztFMxyhR6LMBhVBBTJUydchWI5j5Xaqu8jhnx4yvz
 34tBAw4n7mUOonZziKDumtiNUyLEPRS0RFMNn+gLTgRmg70J/LrIMjhGHtQLFUer07pn
 FjPtiCegvrzcW/mL954fPh20nqTbjNZ/JdmFrMUujze+kv6w7D1NmpS269ng9Q2U/qrS
 2Pbaw3n6B0JXn20f9p0irr4WaJpKFEcjbR0afTIpjQu0F1yCYVPGB6nD0PmFuMAuGJH6
 M1QP2i9CuNaGWZRfMVePko+gRujgpRV1JxOroaWyMevTBy/aFCRahWDqefzQZ1jzBvsO eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2rg40enb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:55:00 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AP6Vo1G000613;
        Fri, 25 Nov 2022 06:55:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2rg40emk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:54:59 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AP6pZcG017489;
        Fri, 25 Nov 2022 06:54:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps96mk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:54:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AP6ssw89634324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 06:54:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CAE911C050;
        Fri, 25 Nov 2022 06:54:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5D1511C04A;
        Fri, 25 Nov 2022 06:54:53 +0000 (GMT)
Received: from [9.179.19.184] (unknown [9.179.19.184])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 06:54:53 +0000 (GMT)
Message-ID: <22f468cb-106b-1797-0496-e9108773ab9d@linux.ibm.com>
Date:   Fri, 25 Nov 2022 07:54:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v5 00/10] optimize the parallelism of SMC-R
 connections
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
 <c98a8f04-c696-c9e0-4d7e-bc31109a0e04@linux.alibaba.com>
 <352b1e15-3c6d-a398-3fe6-0f438e0e8406@linux.ibm.com>
 <1f87a8c2-7a47-119a-1141-250d05678546@linux.alibaba.com>
 <11182feb-0f41-e9a4-e866-8f917c745a48@linux.ibm.com>
 <4f6d8e70-b3f2-93cd-ae83-77ee733cf716@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <4f6d8e70-b3f2-93cd-ae83-77ee733cf716@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8TmCdQp2zsjSlnUaXOg5idLt25Yl-2bH
X-Proofpoint-GUID: w9gRtFxy7PZ6DxS1Mk79HZHO1f7E2-eQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211250052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/11/2022 20:53, D. Wythe wrote:
> 
> 
> On 11/24/22 9:30 PM, Jan Karcher wrote:
>>
>>
>> On 24/11/2022 09:53, D. Wythe wrote:
>>>
>>>
>>> On 11/24/22 4:33 PM, Jan Karcher wrote:
>>>>
>>>>
>>>> On 24/11/2022 06:55, D. Wythe wrote:
>>>>>
>>>>>
>>>>> On 11/23/22 11:54 PM, D.Wythe wrote:
>>>>>> From: "D.Wythe" <alibuda@linux.alibaba.com>
>>>>>>
>>>>>> This patch set attempts to optimize the parallelism of SMC-R 
>>>>>> connections,
>>>>>> mainly to reduce unnecessary blocking on locks, and to fix 
>>>>>> exceptions that
>>>>>> occur after thoses optimization.
>>>>>>
>>>>>
>>>>>> D. Wythe (10):
>>>>>>    net/smc: Fix potential panic dues to unprotected
>>>>>>      smc_llc_srv_add_link()
>>>>>>    net/smc: fix application data exception
>>>>>>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without 
>>>>>> smc_server_lgr_pending
>>>>>>    net/smc: remove locks smc_client_lgr_pending and
>>>>>>      smc_server_lgr_pending
>>>>>>    net/smc: allow confirm/delete rkey response deliver multiplex
>>>>>>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>>>>>>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>>>>>>    net/smc: use read semaphores to reduce unnecessary blocking in
>>>>>>      smc_buf_create() & smcr_buf_unuse()
>>>>>>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>>>>>>    net/smc: replace mutex rmbs_lock and sndbufs_lock with 
>>>>>> rw_semaphore
>>>>>>
>>>>>>   net/smc/af_smc.c   |  74 ++++----
>>>>>>   net/smc/smc_core.c | 541 
>>>>>> +++++++++++++++++++++++++++++++++++++++++++++++------
>>>>>>   net/smc/smc_core.h |  53 +++++-
>>>>>>   net/smc/smc_llc.c  | 285 ++++++++++++++++++++--------
>>>>>>   net/smc/smc_llc.h  |   6 +
>>>>>>   net/smc/smc_wr.c   |  10 -
>>>>>>   net/smc/smc_wr.h   |  10 +
>>>>>>   7 files changed, 801 insertions(+), 178 deletions(-)
>>>>>>
>>>>>
>>>>> Hi Jan and Wenjia,
>>>>>
>>>>> I'm wondering whether the bug fix patches need to be put together 
>>>>> in this series. I'm considering
>>>>> sending these bug fix patches separately now, which may be better, 
>>>>> in case that our patch
>>>>> might have other problems. These bug fix patches are mainly 
>>>>> independent, even without my other
>>>>> patches, they may be triggered theoretically.
>>>>
>>>> Hi D.
>>>>
>>>> Wenjia and i just talked about that. For us it would be better 
>>>> separating the fixes and the new logic.
>>>> If the fixes are independent feel free to post them to net.
>>>
>>>
>>> Got it, I will remove those bug fix patches in the next series and 
>>> send them separately.
>>> And thanks a lot for your test, no matter what the final test results 
>>> are, I will send a new series
>>> to separate them after your test finished.
>>
>> Hi D.,
>>
>> I have some troubles applying your patches.
>>
>>      error: sha1 information is lacking or useless (net/smc/smc_core.c).
>>      error: could not build fake ancestor
>>      Patch failed at 0001 optimize the parallelism of SMC-R connections
>>
>> Before merging them by hand could you please send the v6 with the 
>> fixes separated and verify that you are basing on the latest net / 
>> net-next tree?
>>
>> That would make it easier for us to test them.
>>
>> Thank you
>> - Jan
>>
> 
> Hi Jan,
> 
> It's quite weird, it seems that my patch did based on the latest 
> net-next tree.
> And I try apply it the latest net tree, it's seems work to me too. Maybe 
> there
> is something wrong with the mirror I use. Can you show me the conflict 
> described
> in the .rej file？

Hi D.,

sorry for the delayed reply:
I just re-tried it with path instead of git am and i think i messed it 
up yesterday.
Mea culpa. With patch your changes *can* be applied to the latest net-next.
I'm very sorry for the inconvenience. Could you still please send the 
v6. That way i can verify the fixes separate and we can - if the tests 
succeed - already apply them.

Sorry and thank you
- Jan

> 
> Thanks.
> D. Wythe
> 
> 
> 
> 
> 
> 
> 
