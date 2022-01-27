Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4782D49E52A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbiA0Owj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:52:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37658 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232186AbiA0Owj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:52:39 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20REfxpQ032326;
        Thu, 27 Jan 2022 14:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mRFU3LhMTNakaNyNk6PZuQkNJv1QO1+VwhJ3u88yBSs=;
 b=tZQpugbO3AovuHiBwZruecy7vKd/qCW8zbZxOIg9eMFrczKOd5X6n1MK8Z6lCoq9bdHo
 2KYmKlYrQJfaGwko66CZAwI37tIJuAfsMOG/rQBeRbFXnAdtvi4iOPEL7+pykAfZu9Br
 C05cifwf0kGs03OhdIfO2PjkPaA3+azHLgxc64cr4dQ4Ad2hrzVypiKPxk2NctjFMELQ
 cmCNEuV0IXjT9+j3h2ibICtqAH9JkoMW/gKTIk2FGGZFMItShG17boyKkfkBEaJkqVQL
 nNN4YW0Nn0E6R+tNBsUkYhCNAiQiH7vICpat8+cO2ay8QCSG91v2GJNG9z2vo5T06yC/ NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3duvh0sq5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:52:35 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20REhWpU005920;
        Thu, 27 Jan 2022 14:52:34 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3duvh0sq55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:52:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20REqXlt024520;
        Thu, 27 Jan 2022 14:52:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3dr9j9s73c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:52:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20REqUb940763794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 14:52:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A0DD4C05E;
        Thu, 27 Jan 2022 14:52:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C6164C052;
        Thu, 27 Jan 2022 14:52:30 +0000 (GMT)
Received: from [9.152.222.35] (unknown [9.152.222.35])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 14:52:29 +0000 (GMT)
Message-ID: <3fcfdf75-eb8c-426d-5874-3afdc49de743@linux.ibm.com>
Date:   Thu, 27 Jan 2022 15:52:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal> <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca> <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal> <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
 <YfJcDfkBZfeYA1Z/@unreal> <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
 <YfJlFe3p2ABbzoYI@unreal> <YfJq5pygXS13XRhp@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YfJq5pygXS13XRhp@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jkkOmHvkj0MAaZDp7B9Fbtk6pQ35qVmP
X-Proofpoint-GUID: 3k3ObI87iqAxYE3vcI1Rfc740r466vAU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201270088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/01/2022 10:50, Tony Lu wrote:
> On Thu, Jan 27, 2022 at 11:25:41AM +0200, Leon Romanovsky wrote:
>> On Thu, Jan 27, 2022 at 05:14:35PM +0800, Tony Lu wrote:
>>> On Thu, Jan 27, 2022 at 10:47:09AM +0200, Leon Romanovsky wrote:
>>>> On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
>>>
>>> Sorry for that if I missed something about properly using existing
>>> in-kernel API. I am not sure the proper API is to use ib_cq_pool_get()
>>> and ib_cq_pool_put()?
>>>
>>> If so, these APIs doesn't suit for current smc's usage, I have to
>>> refactor logic (tasklet and wr_id) in smc. I think it is a huge work
>>> and should do it with full discussion.
>>
>> This discussion is not going anywhere. Just to summarize, we (Jason and I)
>> are asking to use existing API, from the beginning.
> 
> Yes, I can't agree more with you about using existing API and I have
> tried them earlier. The existing APIs are easy to use if I wrote a new
> logic. I also don't want to repeat the codes.
> 
> The main obstacle is that the packet and wr processing of smc is
> tightly bound to the old API and not easy to replace with existing API.
> 
> To solve a real issue, I have to fix it based on the old API. If using
> existing API in this patch, I have to refactor smc logics which needs
> more time. Our production tree is synced with smc next. So I choose to
> fix this issue first, then refactor these logic to fit existing API once
> and for all.

While I understand your approach to fix the issue first I need to say
that such interim fixes create an significant amount of effort that has to
be spent for review and test for others. And there is the increased risk 
to introduce new bugs by just this only-for-now fix.

Given the fact that right now you are the only one who is affected by this problem
I recommend to keep your fix in your environment for now, and come back with the
final version. In the meantime I can use the saved time to review the bunch 
of other patches that we received.

Thank you!
