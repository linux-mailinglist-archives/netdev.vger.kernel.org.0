Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2601069E7B5
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 19:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjBUSlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 13:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBUSla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 13:41:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD4A2CFDD;
        Tue, 21 Feb 2023 10:41:28 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmLYt028841;
        Tue, 21 Feb 2023 18:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aRaKSdT5YOBdcMF/VLFz0L/jS/JhEWljAvedK9bydJo=;
 b=BbtVlqoFbjd5pJy9qOcweEirj8OZeKm200PQuuYV4wx2i/EYIX/Zlr4l6bW8eKN122+0
 p0eLqUJZ+bgB3xSAvFNPQeio3PpXWrv2vkpJgECbvHYf++IEUwIPVJMq04VCBVmL4lhI
 30eZmfn9h0deue/mQ6aQW+NKT00KdT7o7RAnHKg55GuzUr1htSOqqpelGjTCxA0aZMOI
 auOUT7yty7PSuJ2mWCEX94zSchCzd/dJpnyPYUlDlhngmhsWkPM5O2P2JwKO2vSxhc3D
 byUx0pPzm2JlqErUN8mjIFOFNTuZdODDYUghSch94ugib3gpZm/EgnQqj0QHTaC1P/Dl oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw11rku82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 18:41:25 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LIM4BU019879;
        Tue, 21 Feb 2023 18:41:24 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw11rku7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 18:41:24 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LIZHb5011387;
        Tue, 21 Feb 2023 18:41:23 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3ntpa7h5nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 18:41:23 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LIfLCG10158792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 18:41:22 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99FA958061;
        Tue, 21 Feb 2023 18:41:21 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19D2A58043;
        Tue, 21 Feb 2023 18:41:20 +0000 (GMT)
Received: from [9.163.71.13] (unknown [9.163.71.13])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Feb 2023 18:41:19 +0000 (GMT)
Message-ID: <23f7bd14-9a5a-6fa2-ed54-fada276ec2a5@linux.ibm.com>
Date:   Tue, 21 Feb 2023 19:41:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [net-next 0/2] Deliver confirm/delete rkey message in parallel
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1675755374-107598-1-git-send-email-alibuda@linux.alibaba.com>
 <fe0d2dae-1a3e-e32f-e8b3-285a33d29422@linux.ibm.com>
 <04e65f58-3ef3-6f5a-6f95-35d5b1555c7e@linux.alibaba.com>
 <51391bb7-9334-ea24-7a93-e2f1847d7ce8@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <51391bb7-9334-ea24-7a93-e2f1847d7ce8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I5lygg7C1hM-ze8dKQvAsInqrAgNFP8O
X-Proofpoint-GUID: qM5YGueBuVXbW7ITVL9TRT4sUdtxThd1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_11,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.02.23 04:09, D. Wythe wrote:
> 
> 
> On 2/8/23 11:04 AM, D. Wythe wrote:
>>
>>
>> On 2/8/23 7:29 AM, Wenjia Zhang wrote:
>>>
>>>
>>> On 07.02.23 08:36, D. Wythe wrote:
>>>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>>>
>>>> According to the SMC protocol specification, we know that all flows 
>>>> except
>>>> confirm_rkey adn delete_rkey are exclusive, confirm/delete rkey flows
>>>> can run concurrently (local and remote).
>>>>
>>>> However, although the protocol allows, all flows are actually mutually
>>>> exclusive in implementation, deus to we are waiting for LLC message
>>>> in serial.
>>>>
>>>> On the one hand, this implementation does not conform to the protocol
>>>> specification, on the other hand, this implementation aggravates the
>>>> time for establishing or destroying a SMC-R connection, connection
>>>> have to be queued in smc_llc_wait.
>>>>
>>>> This patch will improve the performance of the short link scenario
>>>> by about 5%. In fact, we all know that the performance bottleneck
>>>> of the short link scenario is not here.
>>>>
>>>> This patch try use rtokens or rkey to correlate a confirm/delete
>>>> rkey message with its response.
>>>>
>>>> This patch contains two parts.
>>>>
>>>> At first, we have added the process
>>>> of asynchronously waiting for the response of confirm/delete rkey
>>>> messages, using rtokens or rkey to be correlate with.
>>>>
>>>> And then, we try to send confirm/delete rkey message in parallel,
>>>> allowing parallel execution of start (remote) or initialization (local)
>>>> SMC_LLC_FLOW_RKEY flows.
>>>>
>>>> D. Wythe (2):
>>>>    net/smc: allow confirm/delete rkey response deliver multiplex
>>>>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>>>>
>>>>   net/smc/smc_core.h |   1 +
>>>>   net/smc/smc_llc.c  | 263 
>>>> +++++++++++++++++++++++++++++++++++++++++------------
>>>>   net/smc/smc_llc.h  |   6 ++
>>>>   net/smc/smc_wr.c   |  10 --
>>>>   net/smc/smc_wr.h   |  10 ++
>>>>   5 files changed, 220 insertions(+), 70 deletions(-)
>>>>
>>>
>>> As we already discussed, on this changes we need to test them 
>>> carefully so that we have to be sure that the communicating with z/OS 
>>> should not be broken. We'll let you know as soon as the testing is 
>>> finished.
>>
>>
>> Hi, Wenjia
>>
>> Thanks again for your test.
>>
>> Considering that we have reached an agreement on protocol extension,
>> we can temporarily postpone this modification until we introduce the 
>> protocol extension
>> into the Linux community version. Then we can avoid the compatibility 
>> with z/OS.
>>
>>
>> Best wishes.
>> D. Wythe
>>
> 
> We can temporarily postpone this modification until we introduce the 
> protocol extension
> into the Linux community version IF we can't pass the z/OS compatible 
> test. :-)
> 
> Sorry for the problem in my description.
> 
> Thanks.
> D. Wythe
> 
Sorry that it took a bit lang to test. But it looks good to me. Please 
let me know if you still want to postpone it.

Best
Wenjia
