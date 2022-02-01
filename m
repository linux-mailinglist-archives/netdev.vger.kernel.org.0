Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE63A4A619C
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 17:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbiBAQu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 11:50:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235246AbiBAQu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 11:50:57 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211F3Mje030314;
        Tue, 1 Feb 2022 16:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zNVSTvZfXc4LemYI2NRyspRmWquswIG5l/qv0JJD7AE=;
 b=oFiAfD5MTxdl5GsII2xacyx0NWYjwAYZgvDw1M4edIlE4f7aOSblD/CXYoW41b+hlCvL
 BOwBlNbqfZ7GhcZoLfXP0Lac4+mooTjRc8OCpdfkcvz1n86VInyTWcLR/pUqnsiLrSw7
 aTwx8mzwrXSJgyAPNVJKobnplA0YkBpgdv+/6NuInVQkT6/aN2A6yatx2FdHXXzDfcaA
 VM+X1p/ZmKd1/tMtNIlDj/nMnuqL+tDSXH5opD8HuSWTPfXKq0QGiC76ou8e9Hv+oZXm
 kZYrLZSST9eDwifFfbAurLRYgYjywX4+2GvNisReNETQKb+xlb7n2ys5n36qZf9DRnAp +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dy1v9rxkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 16:50:55 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 211GYGgS013114;
        Tue, 1 Feb 2022 16:50:54 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dy1v9rxjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 16:50:54 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211GmjCk000410;
        Tue, 1 Feb 2022 16:50:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw79phcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 16:50:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211Gon4W33161680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Feb 2022 16:50:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C775B42042;
        Tue,  1 Feb 2022 16:50:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 529104204B;
        Tue,  1 Feb 2022 16:50:49 +0000 (GMT)
Received: from [9.145.64.14] (unknown [9.145.64.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Feb 2022 16:50:49 +0000 (GMT)
Message-ID: <6739dd5f-aaa9-dce9-4b06-08060fe267da@linux.ibm.com>
Date:   Tue, 1 Feb 2022 17:50:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca> <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal> <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
 <YfJcDfkBZfeYA1Z/@unreal> <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
 <YfJlFe3p2ABbzoYI@unreal> <YfJq5pygXS13XRhp@TonyMac-Alibaba>
 <3fcfdf75-eb8c-426d-5874-3afdc49de743@linux.ibm.com>
 <YfOTa5uIPUw+gOfM@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YfOTa5uIPUw+gOfM@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n4aMzg8gaQzsKH-ttZNYz5iCEKQj9fgw
X-Proofpoint-GUID: JO0ryo-iLdRdLpYbDYbNDWgBRPLyfZ20
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_08,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2022 07:55, Tony Lu wrote:
> On Thu, Jan 27, 2022 at 03:52:36PM +0100, Karsten Graul wrote:
>> On 27/01/2022 10:50, Tony Lu wrote:
>>> On Thu, Jan 27, 2022 at 11:25:41AM +0200, Leon Romanovsky wrote:
>>>> On Thu, Jan 27, 2022 at 05:14:35PM +0800, Tony Lu wrote:
>>>>> On Thu, Jan 27, 2022 at 10:47:09AM +0200, Leon Romanovsky wrote:
>>>>>> On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
>>>>>
>>>>> Sorry for that if I missed something about properly using existing
>>>>> in-kernel API. I am not sure the proper API is to use ib_cq_pool_get()
>>>>> and ib_cq_pool_put()?
>>>>>
>>>>> If so, these APIs doesn't suit for current smc's usage, I have to
>>>>> refactor logic (tasklet and wr_id) in smc. I think it is a huge work
>>>>> and should do it with full discussion.
>>>>
>>>> This discussion is not going anywhere. Just to summarize, we (Jason and I)
>>>> are asking to use existing API, from the beginning.
>>>
>>> Yes, I can't agree more with you about using existing API and I have
>>> tried them earlier. The existing APIs are easy to use if I wrote a new
>>> logic. I also don't want to repeat the codes.
>>>
>>> The main obstacle is that the packet and wr processing of smc is
>>> tightly bound to the old API and not easy to replace with existing API.
>>>
>>> To solve a real issue, I have to fix it based on the old API. If using
>>> existing API in this patch, I have to refactor smc logics which needs
>>> more time. Our production tree is synced with smc next. So I choose to
>>> fix this issue first, then refactor these logic to fit existing API once
>>> and for all.
>>
>> While I understand your approach to fix the issue first I need to say
>> that such interim fixes create an significant amount of effort that has to
>> be spent for review and test for others. And there is the increased risk 
>> to introduce new bugs by just this only-for-now fix.
> 
> Let's back to this patch itself. This approach spreads CQs to different
> vectors, it tries to solve this issue under current design and not to
> introduce more changes to make it easier to review and test. It severely
> limits the performance of SMC when replacing TCP. This patch tries to
> reduce the gap between SMC and TCP.
> 
> To use newer API, it should have a lots of work to do with wr process
> logic, for example remove tasklet handler, refactor wr_id logic. I have
> no idea if we should do this? If it's okay and got your permission, I
> will do this in the next patch.

Hi Tony,

I think there was quite a discussion now about this patch series and the conclusion from 
the RDMA list and from my side was that if this code is changed it should be done using
the new API. The current version re-implements code that is already available there.

I agree that using the new API is the way to go, and I am in for any early discussions
about the changes that are needed.

>> Given the fact that right now you are the only one who is affected by this problem
>> I recommend to keep your fix in your environment for now, and come back with the
>> final version. In the meantime I can use the saved time to review the bunch 
>> of other patches that we received.
> 
> I really appreciate the time you spent reviewing our patch. Recently,
> our team has submitted a lot of patches and got your detailed
> suggestions, including panic (linkgroup, CDC), performance and so on.
> We are using SMC in our public cloud environment. Therefore, we maintain
> a internal tree and try to contribute these changes to upstream, and we
> will continue to invest to improve the stability, performance and
> compatibility, and focus on SMC for a long time.
> 
> We are willing to commit time and resource to help out in reviewing and
> testing the patch in mail list and -next, as reviewer or tester.
> 
> We have built up CI/CD and nightly test for SMC. And we intend to send
> test reports for each patch in the mail list, help to review, find out
> panic and performance regression.
> 
> Not sure if this proposal will help save your time to review other
> patches? Glad to hear your advice.

Thanks for all the time and work you spend to bring SMC into a cloud environment!
We really appreciate this a lot.

Karsten
