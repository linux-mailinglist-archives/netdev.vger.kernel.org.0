Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A4B6F0395
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 11:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243269AbjD0Joa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 05:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243285AbjD0Jo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 05:44:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEB94699;
        Thu, 27 Apr 2023 02:44:24 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R9b2ik022872;
        Thu, 27 Apr 2023 09:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NsdeLVPvnuTdBPZv3WD2Vnht6opWJ6idi7ZjkBpR5pc=;
 b=gcDzmsTyhsMsJDiXanvDKgoVy9G0lgLNG7KINI8NT7oxXPSVZr8Oft4A/Hp9Xf3QHgSN
 GBcroRKehrnvcqdlaMSw82ngxc0dlbCsHkd0XRvTOaXubB5xuPCZZlfffcB5zJK+aIkp
 s9BzamajLkQHo61gh8r8fRjXO0rw95miaoIIpMSYbp13m72KLGnb1yf16bYL6BOMsnCj
 bVh+1uUTIpEpbjEWmLzZl8LtT64tjLxUzWCAJswLzztJ3R/v4NZiJsKsDinD+8Yehy0b
 L9yH/hWTsXj2VqmfgBJg42usbuemFLJBnz86Dfh7ySq8WLST3uPnZ8Pc6UvTRfsw8bb1 mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp5c60b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 09:44:19 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33R9bs3q029470;
        Thu, 27 Apr 2023 09:44:19 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp5c5xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 09:44:19 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33R36j8n004299;
        Thu, 27 Apr 2023 09:44:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug2uyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 09:44:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33R9iC0V2032128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 09:44:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14D3B2004E;
        Thu, 27 Apr 2023 09:44:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33CEA20043;
        Thu, 27 Apr 2023 09:44:11 +0000 (GMT)
Received: from [9.179.20.145] (unknown [9.179.20.145])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Apr 2023 09:44:11 +0000 (GMT)
Message-ID: <a2f09b8a-add5-6bc4-64d2-6ac67e334fe0@linux.ibm.com>
Date:   Thu, 27 Apr 2023 11:44:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [RFC net] net/mlx5: Fix performance regression for
 request-response workloads
Content-Language: en-US
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20220907122505.26953-1-wintera@linux.ibm.com>
 <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
 <375efe42-910d-69ae-e48d-cff0298dd104@linux.ibm.com>
 <CANn89iKjxMMDEcOCKiqWiMybiYVd7ZqspnEkT0-puqxrknLtRA@mail.gmail.com>
 <886c690b-cc35-39a0-8397-834e70fb329b@linux.ibm.com>
 <20220930233708.kfxhgn2ytmraqhg7@sfedora>
 <d58b5b49-aea6-c980-fc4d-6eab596ddc9d@linux.ibm.com>
In-Reply-To: <d58b5b49-aea6-c980-fc4d-6eab596ddc9d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UN6T5kneicLLAwWwZr0DF8NLmh2Z-nvh
X-Proofpoint-ORIG-GUID: hIZ1xaRUbVAtVg14Pq3BZwpwA3bWrR-3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270082
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29.12.22 09:27, Alexandra Winter wrote:
> 
> 
> On 01.10.22 01:37, Saeed Mahameed wrote:
>> On 26 Sep 12:06, Alexandra Winter wrote:
>>
>> [ ... ]
>>>
>>> Saeed,
>>> As discussed at LPC, could you please consider adding a workaround to the
>>> Mellanox driver, to use non-SG SKBs for small messages? As mentioned above
>>> we are seeing 13% throughput degradation, if 2 pages need to be mapped
>>> instead of 1.
>>>
>>> While Eric's ideas sound very promising, just using non-SG in these cases
>>> should be enough to mitigate the performance regression we see.
>>
>> Hi Alexandra, sorry for the late response.
>>
>> Yeas linearizing small messages makes sense, but will require some careful
>> perf testing.
>>
>> We will do our best to include this in the next kernel release cycle.
>> I will take it with the mlx5e team next week, everybody is on vacation this
>> time of year :).
>>
>> Thanks,
>> Saeed.
> 
> Hello Saeed,
> may I ask whether you had a chance to include such a patch in the 6.2 kernel?
> Or is this still on your ToDo list?
> I haven't seen anything like this on the mailing list, but I may have overlooked it.
> All the best for 2023
> Alexandra


Hello Saeed,
any news about linearizing small messages? Is there any way we could be of help?

Kind regards
Alexandra
