Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4997658A88
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 09:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiL2I2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 03:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiL2I2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 03:28:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057D013CFD;
        Thu, 29 Dec 2022 00:28:04 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BT7oqFU016562;
        Thu, 29 Dec 2022 08:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wjJ5A55QHwsfPZQp8Vf+s/5C+qsAdXyaDEykbbEtsfc=;
 b=AbD7zVtCwL3lWUNR+DuBDGdTG+4Bf4psOe1A4DPdTSyoa1W9kgfVQFQwyPeLv17YAiY1
 5A3wR/3sm/3NAXRYs1+QtwXCZ6FUOVSQElZb4sR0Du/N1tntN7U2jGuwxXLmg6tjEijL
 AvEgsy5Rt07NfpXgveztfS482Q4K90vp1VCRB6bs1k6nKuYQg2xuRiG6PrhuNgh8GPDg
 PFOtjReB+Tjgi74RwclWgdQVtHDcBteCM9dz5UhtP1JfQOrm5kGdw6L4d5jz2BV3gGjs
 0b35lxmb1Q8Ae5eLNorGWPyZ84hUMH/H7EqfCGtxM43EFFIxQ9xgOfIp/r6fqmbWTQ0Q xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ms6v48mke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Dec 2022 08:27:59 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BT89CDo022649;
        Thu, 29 Dec 2022 08:27:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ms6v48mju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Dec 2022 08:27:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BT2lCJx003970;
        Thu, 29 Dec 2022 08:27:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mnrpfpjhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Dec 2022 08:27:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BT8Rq9I21692804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 08:27:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58D7720043;
        Thu, 29 Dec 2022 08:27:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC40C20040;
        Thu, 29 Dec 2022 08:27:51 +0000 (GMT)
Received: from [9.171.17.172] (unknown [9.171.17.172])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 29 Dec 2022 08:27:51 +0000 (GMT)
Message-ID: <d58b5b49-aea6-c980-fc4d-6eab596ddc9d@linux.ibm.com>
Date:   Thu, 29 Dec 2022 09:27:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC net] net/mlx5: Fix performance regression for
 request-response workloads
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220907122505.26953-1-wintera@linux.ibm.com>
 <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
 <375efe42-910d-69ae-e48d-cff0298dd104@linux.ibm.com>
 <CANn89iKjxMMDEcOCKiqWiMybiYVd7ZqspnEkT0-puqxrknLtRA@mail.gmail.com>
 <886c690b-cc35-39a0-8397-834e70fb329b@linux.ibm.com>
 <20220930233708.kfxhgn2ytmraqhg7@sfedora>
Content-Language: en-US
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220930233708.kfxhgn2ytmraqhg7@sfedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ioc97oN9n8t1Sv7nqaaFtNH9SAv34mnI
X-Proofpoint-ORIG-GUID: phwJUaREPl4tnk_K8bC2LEqNy6gSd5YK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_04,2022-12-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=985
 spamscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290066
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01.10.22 01:37, Saeed Mahameed wrote:
> On 26 Sep 12:06, Alexandra Winter wrote:
>>
> 
> [ ... ]
> 
>> [...]
>>
>> Saeed,
>> As discussed at LPC, could you please consider adding a workaround to the
>> Mellanox driver, to use non-SG SKBs for small messages? As mentioned above
>> we are seeing 13% throughput degradation, if 2 pages need to be mapped
>> instead of 1.
>>
>> While Eric's ideas sound very promising, just using non-SG in these cases
>> should be enough to mitigate the performance regression we see.
> 
> Hi Alexandra, sorry for the late response.
> 
> Yeas linearizing small messages makes sense, but will require some careful
> perf testing.
> 
> We will do our best to include this in the next kernel release cycle.
> I will take it with the mlx5e team next week, everybody is on vacation this
> time of year :).
> 
> Thanks,
> Saeed.

Hello Saeed,
may I ask whether you had a chance to include such a patch in the 6.2 kernel?
Or is this still on your ToDo list?
I haven't seen anything like this on the mailing list, but I may have overlooked it.
All the best for 2023
Alexandra
