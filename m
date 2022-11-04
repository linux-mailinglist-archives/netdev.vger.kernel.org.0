Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E74619F88
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiKDSPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKDSPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:15:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC113137F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 11:15:49 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Hk498011916;
        Fri, 4 Nov 2022 18:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rhbi4DdQZskap4yRXsCNXUYPxeK5CejE22dWmCNB7S8=;
 b=eCZAdYC/BZmHxqFlNjWiMnjQCdKwFkqaH9RwZV0N7r2FfgZHK+DrFkqs7W5RgItRKHST
 8Svq0X1EUTJBdjM2xEoFLRUu6KYeqOje47lTRwbGQDUbQhze3uc5QmudHWI0LC/+xowF
 F4/GrR4ObO/4OmURLhYYFaGemrg1U6AELfRAayUuV98GxJ9GV8JjgrmO2QxZ2V+hKcC3
 NkWpoHeR/8x89rnFK/1o+ASRyQSXV+uzy7a6lmfWwpzFUNinBmltaMyCpwu0o9SAaLnz
 12FYEPCIG52UfDnx4HSnLAnlaY8gZ/h5UuwdJVkbyQZzBDDjCV6abziQad6x30Lo+zSu VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpna1ce0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 18:15:45 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A4F7gsC012855;
        Fri, 4 Nov 2022 18:15:44 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpna1cdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 18:15:44 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A4I4xRf000520;
        Fri, 4 Nov 2022 18:15:44 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3kgutav2j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 18:15:43 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A4IFgrv13304506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Nov 2022 18:15:42 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7CA95806A;
        Fri,  4 Nov 2022 18:15:41 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB1B858058;
        Fri,  4 Nov 2022 18:15:40 +0000 (GMT)
Received: from [9.160.12.76] (unknown [9.160.12.76])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  4 Nov 2022 18:15:40 +0000 (GMT)
Message-ID: <a2924a54-7e44-952d-8544-d14e44d9d8f5@linux.ibm.com>
Date:   Fri, 4 Nov 2022 13:15:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 net] ibmveth: Reduce maximum tx queues to 8
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, bjking1@linux.ibm.com,
        ricklind@us.ibm.com, dave.taht@gmail.com
References: <20221102183837.157966-1-nnac123@linux.ibm.com>
 <20221103205945.40aacd90@kernel.org>
 <4f84f10b-9a79-17f6-7e2e-f65f0d2934cb@linux.ibm.com>
 <20221104105955.2c3c74a7@kernel.org>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20221104105955.2c3c74a7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zn7g-P2RaP93UX4Mr0XYEFVjMbYhqrxT
X-Proofpoint-ORIG-GUID: dEQKHaDQ-XWQAPwqCWNCkR7KWBbKeXzg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_11,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=913 lowpriorityscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/22 12:59, Jakub Kicinski wrote:
> On Fri, 4 Nov 2022 09:06:02 -0500 Nick Child wrote:
>> On 11/3/22 22:59, Jakub Kicinski wrote:
>>> On Wed,  2 Nov 2022 13:38:37 -0500 Nick Child wrote:
>>>> Previously, the maximum number of transmit queues allowed was 16. Due to
>>>> resource concerns, limit to 8 queues instead.
>>>>
>>>> Since the driver is virtualized away from the physical NIC, the purpose
>>>> of multiple queues is purely to allow for parallel calls to the
>>>> hypervisor. Therefore, there is no noticeable effect on performance by
>>>> reducing queue count to 8.
>>>
>>> I'm not sure if that's the point Dave was making but we should be
>>> influencing the default, not the MAX. Why limit the MAX?
>>
>> The MAX is always allocated in the drivers probe function. In the
>> drivers open and ethtool-set-channels functions we set
>> real_num_tx_queues. So the number of allocated queues is always MAX
>> but the number of queues actually in use may differ and can be set by
>> the user.
>> I hope this explains. Otherwise, please let me know.
> 
> Perhaps I don't understand the worry. Is allowing 16 queues a problem
> because it limits how many instances the hypervisor can support?

No, the hypervisor is unaware of the number of netdev queues. The reason
for adding more netdev queues in the first place is to allow the higher
networking layers to make parallel calls to the drivers xmit function,
which the hypervisor can handle.

> Or is the concern coming from your recent work on BQL and having many
> queues exacerbating buffer bloat?

Yes, and Dave can jump in here if I am wrong, but, from my 
understanding, if the NIC cannot send packets at the rate that
they are queued then these queues will inevitably fill to txqueuelen.
In this case, having more queues will not mean better throughput but
will result in a large number of allocations sitting in queues 
(bufferbloat). I believe Dave's point was, if more queues does not
allow for better performance (and can risk bufferbloat) then why
have so many at all.

After going through testing and seeing no difference in performance
with 8 vs 16 queues, I would rather not have the driver be a culprit
of potential resource hogging.
