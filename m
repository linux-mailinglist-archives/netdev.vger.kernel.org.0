Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7C14A47A0
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378189AbiAaM4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:56:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351557AbiAaM4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:56:08 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VBVqxd021173;
        Mon, 31 Jan 2022 12:56:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nol+M50UaxHCX8DBOifST++5X0AQ/SHcMSrUEijb9UY=;
 b=LJPeYx45TGC2ps8WhEDTpbVuZVe3G/Zz/zMmkAsvI1UhKpQnYtRPMtzcdYngHaZVrxzw
 odGmfAKSHiGw7Ak8AbH+/V0ihI42IfBzeBVl5dEUvB6p+p1XZveJujGjOqSqNnq4d8ZQ
 C/t5RDt8HSwKZOAp4HZ2mx8phGckZSnh15+AsJjsEMx950cX9CZvoadLN+E++AfH9+JN
 4hsIAeXoaprtIutwJ6ZibMRzCGehs3JpgiqQ+aRFuBVGbhu5Yr9npmP18EMx0v4F2LcS
 slAV3MTOtH7i34V6U9V7TW2E04Vq+wAxh1t2vAuQZo3WNDa6rZr/P8m4M9dttcnFYQnS rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxe3pttaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:56:06 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VBjskK006688;
        Mon, 31 Jan 2022 12:56:05 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxe3ptt9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:56:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VCqAIW018876;
        Mon, 31 Jan 2022 12:56:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw79bga6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:56:03 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VCu09Q43778392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 12:56:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9F7A11C06C;
        Mon, 31 Jan 2022 12:56:00 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A4A611C04A;
        Mon, 31 Jan 2022 12:56:00 +0000 (GMT)
Received: from [9.145.79.147] (unknown [9.145.79.147])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 12:56:00 +0000 (GMT)
Message-ID: <a1c8957b-8ca8-fa84-105f-17619b2c8371@linux.ibm.com>
Date:   Mon, 31 Jan 2022 13:56:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
 <1f13f001-e4d7-fdcd-6575-caa1be1526e1@linux.ibm.com>
 <a297c8cf-384c-2184-aabb-49ee32476d99@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <a297c8cf-384c-2184-aabb-49ee32476d99@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iREgR0c76UpqQP-uHwie3o6ZxAySfItM
X-Proofpoint-ORIG-GUID: 5F5W6sm2U5KG7_KEXNYtcp-PWPOYbM6D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_05,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 impostorscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/01/2022 04:43, Guangguan Wang wrote:
> 
> On 2022/1/25 17:42, Stefan Raspl wrote:
>>
>> That's some truly substantial improvements!
>> But we need to be careful with protocol-level changes: There are other operating systems like z/OS and AIX which have compatible implementations of SMC, too. Changes like a reduction of connections per link group or usage of reserved fields would need to be coordinated, and likely would have unwanted side-effects even when used with older Linux kernel versions.
>> Changing the protocol is "expensive" insofar as it requires time to thoroughly discuss the changes, perform compatibility tests, and so on.
>> So I would like to urge you to investigate alternative ways that do not require protocol-level changes to address this scenario, e.g. by modifying the number of completion queue elements, to see if this could yield similar results.
>>
>> Thx!
>>
> 
> Yes, there are alternative ways, as RNR caused by the missmatch of send rate and receive rate, which means sending too fast
> or receiving too slow. What I have done in this patch is to backpressure the sending side when sending too fast.
> 
> Another solution is to process and refill the receive queue as quickly as posibble, which requires no protocol-level change. 
> The fllowing modifications are needed:
> - Enqueue cdc msgs to backlog queues instead of processing in rx tasklet. llc msgs remain unchanged.
> - A mempool is needed as cdc msgs are processed asynchronously. Allocate new receive buffers from mempool when refill receive queue.
> - Schedule backlog queues to other cpus, which are calculated by 4-tuple or 5-tuple hash of the connections, to process the cdc msgs,
>   in order to reduce the usage of the cpu where rx tasklet runs on.
> 
> the pseudocode shows below:
> rx_tasklet
>     if cdc_msgs
>         enqueue to backlog;
> 	maybe smp_call_function_single_async is needed to wakeup the corresponding cpu to process backlog;
>         allocate new buffer and modify the sge in rq_wr;
>     else
>         process remains unchanged;
>     endif
> 
>     post_recv rq_wr;
> end rx_tasklet
> 
> smp_backlog_process in corresponding cpu, called by smp_call_function_single_async
>     for connections hashed to this cpu
>         for cdc_msgs in backlog
>             process cdc msgs;
>         end cdc_msgs
>     end connections
> end smp_backlog_process
> 
> I‘d like to hear your suggestions of this solution.
> Thank you.

I like this idea, this should improve the RX handling a lot!
