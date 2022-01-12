Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6834948C127
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 10:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352133AbiALJkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 04:40:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46616 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352136AbiALJjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 04:39:42 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20C8pLh8029510;
        Wed, 12 Jan 2022 09:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/9tK+VS/cnDyK47dSrtk7wEbYK8TmwqMeslMQZr03Gg=;
 b=LbmJfzedl1NZspCQM2pTJV4k1LnRDtjNcK62X+AMEq7Ohrcecak6JZivD3BYLG9jwvTj
 9p32iQsd3jBAKFuI719iCeGoQ4n4khnHiFNGqYI+DApchtQPpO/DD/hhDzGgJVHGUjY0
 Nkug2ht8Xn0xOUyw7kVzDH47igUANuVLb3YOe/Xas//nnsL05OSCzagnPoK8NgO+ca1k
 F9Xzx+bZ7AB8/In2SG/m7a14aSssuNZexvKRXEZZAEF7ObcQoph4GWYHrn2+ww9TWjn7
 XW2PGp4BteWMosCNhMOuxyxTZBUuP2+HfiNXLgXshvNtppT2dTsEC6YmcS9mSfLkw4yx XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhuugruys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 09:39:31 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20C9YF30022278;
        Wed, 12 Jan 2022 09:39:31 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhuugruya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 09:39:31 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20C9c0q6019207;
        Wed, 12 Jan 2022 09:39:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3df289qnn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 09:39:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20C9TO1d44696000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 09:29:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 273624C052;
        Wed, 12 Jan 2022 09:38:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CADCA4C040;
        Wed, 12 Jan 2022 09:38:26 +0000 (GMT)
Received: from [9.145.42.178] (unknown [9.145.42.178])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jan 2022 09:38:26 +0000 (GMT)
Message-ID: <5dd7ffd1-28e2-24cc-9442-1defec27375e@linux.ibm.com>
Date:   Wed, 12 Jan 2022 10:38:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after clcsock
 released
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
 <ac977743-9696-9723-5682-97ebbcca6828@linux.ibm.com>
 <719f264e-a70d-7bed-0873-ffbba8381841@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <719f264e-a70d-7bed-0873-ffbba8381841@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tPZaZ1IPn9yd5DD0-GpKOGqaSXfABRQh
X-Proofpoint-GUID: GoDvYq22Le5GCgMA3oR7v9STTm0mUyB_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_03,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=868 malwarescore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 17:34, Wen Gu wrote:
> Thanks for your reply.
> 
> On 2022/1/11 6:03 pm, Karsten Graul wrote:
>> On 10/01/2022 10:38, Wen Gu wrote:
>>> We encountered a crash in smc_setsockopt() and it is caused by
>>> accessing smc->clcsock after clcsock was released.
>>>
>>
>> In the switch() the function smc_switch_to_fallback() might be called which also
>> accesses smc->clcsock without further checking. This should also be protected then?
>> Also from all callers of smc_switch_to_fallback() ?
>>
>> There are more uses of smc->clcsock (e.g. smc_bind(), ...), so why does this problem
>> happen in setsockopt() for you only? I suspect it depends on the test case.
>>
> 
> Yes, it depends on the test case. The crash described here only happens one time when
> I run a stress test of nginx/wrk, accompanied with frequent RNIC up/down operations.
> 
> Considering accessing smc->clcsock after its release is an uncommon, low probability
> issue and only happens in setsockopt() in my test, I choce an simple way to fix it, using
> the existing clcsock_release_lock, and only check in smc_setsockopt() and smc_getsockopt().
> 
>> I wonder if it makes sense to check and protect smc->clcsock at all places in the code where
>> it is used... as of now we had no such races like you encountered. But I see that in theory
>> this problem could also happen in other code areas.
>>
> 
> But inspired by your questions, I think maybe we should treat the race as a general problem?
> Do you think it is necessary to find all the potential race related to the clcsock release and
> fix them in a unified approach? like define smc->clcsock as RCU pointer, hold rcu read lock
> before accessing smc->clcsock and call synchronize_rcu() before resetting smc->clcsock? just a rough idea :)
> 
> Or we should decide it later, do some more tests to see the probability of recurrence of this problem?

I like the idea to use RCU with rcu_assign_pointer() to protect that pointer!

Lets go with your initial patch (improved to address the access in smc_switch_to_fallback())
for now because it solves your current problem. 

I put that RCU thing on our list, but if either of us here starts working on that please let the
others know so we don't end up doing parallel work on this. But I doubt that we will be able to start working
on that soon.

Thanks for the good idea!

