Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5F86379F9
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 14:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiKXNbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 08:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXNbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 08:31:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43318CEFCC;
        Thu, 24 Nov 2022 05:31:13 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOCoWs0014283;
        Thu, 24 Nov 2022 13:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UunHd9TMv3RRwhFhK6fVmR8HtoRqANs3TdFoDTxfLCQ=;
 b=ohsP/CGcODx+Dbcfa2sEw+0peE5C7Tj+LmpkqKQXCSQNk2jSXa6uhHofex/MAaeZw+Dj
 XD915loF95mM72sxGTCS0xw16tzMHPWnlTZZoixXN0f1vDqif56KZabfjJOf55PhVip4
 FDZiwgSvKPgh1KhrYEaIqe4GdC/E0z6famY24PYyE0dkzKin851HNHUBNbYUU+4D9dtw
 JRc8VxguSDF+erkkLLciulwC1hSsX9lXhmGYeYDYkkSubhTIHJpv1FZKC111JuI92nh+
 PyCvgfp6OTNN9PtfyJu2EHoPN9dM7d9lsdzZ8Gk9hVmyohvPeLZmAOVGM9TAsgJITetx UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153u4u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:31:03 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AODHeWs019659;
        Thu, 24 Nov 2022 13:31:03 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153u4st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:31:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AODLeM1032710;
        Thu, 24 Nov 2022 13:31:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdj08dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:31:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AODUvDH52822316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 13:30:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3858611C050;
        Thu, 24 Nov 2022 13:30:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C26FF11C04C;
        Thu, 24 Nov 2022 13:30:56 +0000 (GMT)
Received: from [9.171.82.62] (unknown [9.171.82.62])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 13:30:56 +0000 (GMT)
Message-ID: <11182feb-0f41-e9a4-e866-8f917c745a48@linux.ibm.com>
Date:   Thu, 24 Nov 2022 14:30:55 +0100
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
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <1f87a8c2-7a47-119a-1141-250d05678546@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sNq-KrXwnc9crP2hysaTKG146JPXY4Jz
X-Proofpoint-GUID: W-Ln_XqKP2rtKrVxTcb7rLL4WwLs1x3O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_09,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211240102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/11/2022 09:53, D. Wythe wrote:
> 
> 
> On 11/24/22 4:33 PM, Jan Karcher wrote:
>>
>>
>> On 24/11/2022 06:55, D. Wythe wrote:
>>>
>>>
>>> On 11/23/22 11:54 PM, D.Wythe wrote:
>>>> From: "D.Wythe" <alibuda@linux.alibaba.com>
>>>>
>>>> This patch set attempts to optimize the parallelism of SMC-R 
>>>> connections,
>>>> mainly to reduce unnecessary blocking on locks, and to fix 
>>>> exceptions that
>>>> occur after thoses optimization.
>>>>
>>>
>>>> D. Wythe (10):
>>>>    net/smc: Fix potential panic dues to unprotected
>>>>      smc_llc_srv_add_link()
>>>>    net/smc: fix application data exception
>>>>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>>>>    net/smc: remove locks smc_client_lgr_pending and
>>>>      smc_server_lgr_pending
>>>>    net/smc: allow confirm/delete rkey response deliver multiplex
>>>>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>>>>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>>>>    net/smc: use read semaphores to reduce unnecessary blocking in
>>>>      smc_buf_create() & smcr_buf_unuse()
>>>>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>>>>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
>>>>
>>>>   net/smc/af_smc.c   |  74 ++++----
>>>>   net/smc/smc_core.c | 541 
>>>> +++++++++++++++++++++++++++++++++++++++++++++++------
>>>>   net/smc/smc_core.h |  53 +++++-
>>>>   net/smc/smc_llc.c  | 285 ++++++++++++++++++++--------
>>>>   net/smc/smc_llc.h  |   6 +
>>>>   net/smc/smc_wr.c   |  10 -
>>>>   net/smc/smc_wr.h   |  10 +
>>>>   7 files changed, 801 insertions(+), 178 deletions(-)
>>>>
>>>
>>> Hi Jan and Wenjia,
>>>
>>> I'm wondering whether the bug fix patches need to be put together in 
>>> this series. I'm considering
>>> sending these bug fix patches separately now, which may be better, in 
>>> case that our patch
>>> might have other problems. These bug fix patches are mainly 
>>> independent, even without my other
>>> patches, they may be triggered theoretically.
>>
>> Hi D.
>>
>> Wenjia and i just talked about that. For us it would be better 
>> separating the fixes and the new logic.
>> If the fixes are independent feel free to post them to net.
> 
> 
> Got it, I will remove those bug fix patches in the next series and send 
> them separately.
> And thanks a lot for your test, no matter what the final test results 
> are, I will send a new series
> to separate them after your test finished.

Hi D.,

I have some troubles applying your patches.

     error: sha1 information is lacking or useless (net/smc/smc_core.c).
     error: could not build fake ancestor
     Patch failed at 0001 optimize the parallelism of SMC-R connections

Before merging them by hand could you please send the v6 with the fixes 
separated and verify that you are basing on the latest net / net-next tree?

That would make it easier for us to test them.

Thank you
- Jan

> 
> Thanks
> D. Wythe
> 
> 
> 
