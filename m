Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D7D6A1FB6
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBXQeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjBXQeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:34:16 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5946B12F2C
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:34:14 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OFnPHC019356;
        Fri, 24 Feb 2023 16:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kNK3/HdrOFFXX6A+W0mtl1+DLraJaBRCs5YVvS686co=;
 b=VzCayvhSqzu8oM1qOTMizUYnh5O8AbVddQ6+wQKasJPKieu03DexMzQMO/ifID+RJJ9H
 jXX568aGUXTEddGydKcfe4qenz6qOaTcb7M6V4pqILnZYwC7zE712AH58iCKGjsKrAz1
 g57C70FmX9pqfm6AHDhhiaYEXICTeQWHHXIJYJurXu6L9jtQeaHNHIS8PEnmIS1ZVsAO
 itSVo8Noeep5YJ1CQK2QizFzc+RPFZYtNlC66aq7r5pvV84KjobkVlzrtBKQUeiVDmI0
 okuSc8WXBQ4qIHBR2AFgwZ1OZun1jvyJDjIN/Y0hiUvsdASCnbak63mtxUqEHzIO+slM kQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxuttg553-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 16:34:12 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31OG2gdI019841;
        Fri, 24 Feb 2023 16:34:12 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3ntpa7wkvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 16:34:11 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31OGYAuw6095438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 16:34:10 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 543205805C;
        Fri, 24 Feb 2023 16:34:10 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51BF25805B;
        Fri, 24 Feb 2023 16:34:09 +0000 (GMT)
Received: from [9.65.245.183] (unknown [9.65.245.183])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Feb 2023 16:34:09 +0000 (GMT)
Message-ID: <faf30f4c-42ac-5326-0c4d-7f1515ecd943@linux.ibm.com>
Date:   Fri, 24 Feb 2023 10:34:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] ibmvnic: Assign XPS map to correct queue index
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com
References: <20230223153944.44969-1-nnac123@linux.ibm.com>
 <CALs4sv3FC9ig1aJ2=Uwk-enXhb5_fwz1DU3Z_zpe76osS6_nBA@mail.gmail.com>
Content-Language: en-US
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <CALs4sv3FC9ig1aJ2=Uwk-enXhb5_fwz1DU3Z_zpe76osS6_nBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RqqD6d7cikyFjtlj6onQWV1bSTAkxY1S
X-Proofpoint-ORIG-GUID: RqqD6d7cikyFjtlj6onQWV1bSTAkxY1S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_11,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=909 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/23 02:49, Pavan Chebbi wrote:
> On Thu, Feb 23, 2023 at 9:10 PM Nick Child <nnac123@linux.ibm.com> wrote:
>> ---
>>
>> I am a little surprised that __netif_set_xps_queue() did not complain that some
>> index values were greater than the number of tx queues. Though maybe the function
>> assumes that the developers are wise enough :)
> 
> Are you sure an index greater than total tx queues was sent?
> A quick look at ibmvnic_set_affinity() suggests that the condition if
> (... || (i_txqs == num_txqs)) prevents overrunning available tx
> queues.
> 
I believe so. The issue is we were sending "i" to 
__netif_set_xps_queue() , not i_txqs.

Take an example where num_txqs == 2 and num_rxqs == 2:
total_num_q's == 4, so i will loop until until 4.
When we get to i == 2, it will attempt to map XPS values for
the second TX queue (index 1) but we would be giving the value of
i (which is 2). The index of 2 is greater than the number of available 
tx queues. Somehow __netif_set_xps_queue() is still returning a 
successful error code.
>>
>> Should __netif_set_xps_queue() have a check that index < dev->num_tx_queues?

