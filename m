Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF68867B77B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbjAYQzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbjAYQz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:55:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E232B08C
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:55:26 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PG7lKk019043;
        Wed, 25 Jan 2023 16:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CNDsuKzsqonGbb2ZBkPkaKJewbonl4k0JLtzvAu4JWY=;
 b=TSEBDf/m8Le5JNMKckWrSiEMiMScRef+puNtx524v75pYtmH1SdoWU23f7i0KzINb+qm
 mtNBp/FDujxOtCYP4RWTT1fnqFv+FEsnp/ulOCEzWBGO2R5MajatIh1gatQGRwo6i2Aa
 E86jZettPdSmtAgXspAGe2uKBlAqdbLT/VYyyS9AnK1E0fioueYgsXPAFSQeL+DcuKvM
 Vw1P4vR72GihivFQGMsViEctuA4hg5M+9LjPDsWUvnTBNXxWLrnG5lMP15XZdSPBjJ0Z
 F79jbXV2nL1+2V3o6Ga4opD1oZb01Nhuda7qAX2G/8iPU4LypyRCo173rmDfYRy2e2ef Gg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nac213eq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 16:55:23 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30PDZS49006833;
        Wed, 25 Jan 2023 16:55:22 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3n87p7gwgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 16:55:22 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30PGtLGa8848026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 16:55:21 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D4C458057;
        Wed, 25 Jan 2023 16:55:21 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D11F058062;
        Wed, 25 Jan 2023 16:55:20 +0000 (GMT)
Received: from [9.160.167.56] (unknown [9.160.167.56])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 25 Jan 2023 16:55:20 +0000 (GMT)
Message-ID: <0bf3b3e3-8927-bcdd-9600-4f9133d4d81d@linux.ibm.com>
Date:   Wed, 25 Jan 2023 10:55:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] ibmvnic: Toggle between queue types in affinity
 mapping
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com
References: <20230123221727.30423-1-nnac123@linux.ibm.com>
 <20230124183925.257621e8@kernel.org>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20230124183925.257621e8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uR6SsqYXSlyh-NL7maHw3o_Khwv_5Mw_
X-Proofpoint-ORIG-GUID: uR6SsqYXSlyh-NL7maHw3o_Khwv_5Mw_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_10,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=844 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250147
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/23 20:39, Jakub Kicinski wrote:
> On Mon, 23 Jan 2023 16:17:27 -0600 Nick Child wrote:
>> A more optimal algorithm would balance the number RX and TX IRQ's across
>> the physical cores. Therefore, to increase performance, distribute RX and
>> TX IRQs across cores by alternating between assigning IRQs for RX and TX
>> queues to CPUs.
>> With a system with 64 CPUs and 32 queues, this results in the following
>> pattern (binding is done in reverse order for readable code):
>>
>> IRQ type |  CPU number
>> -----------------------
>> TX15	 |	0-1
>> RX15	 |	2-3
>> TX14	 |	4-5
>> RX14	 |	6-7
> 
> Seems sensible but why did you invert the order? To save LoC?

Thanks for checking this out Jakub.

Correct, the effect on performance is the same and IMO the algorithm
is more readable. Less so about minimizing lines and more about
making the code understandable for the next dev.
