Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B9960D51B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiJYUDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiJYUDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:03:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CAB11A951
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 13:03:10 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJ7tvE016447;
        Tue, 25 Oct 2022 20:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=49k34qJiuaFieowvnSbtdiEltnwLT4qoNgNjirMhf0g=;
 b=Se4asnGpJ3dfe/BV28YkslXKRzgok1eGzhUFcaxEnrzRsxNBpFzWIbOJoACsWRreV1Uo
 A3L4OAJAUTbq87O+AQ6fxovWMsemTNa/S1OZr4ncsAWE7p7dB6hqyjUvtUhyqWBLTi69
 FF8sXV1yk2dtlu+QOOcymzfbVQLALkAa5VCuckF63r1ePf/OEzcZP9Pvn8kzWvxH4KUD
 JBGkvZ3gMwZ+g5wXP6/aaiN34mUkHITLKKV1LZ3shS51XW3EH1pczZXyrwewnI1RTMbo
 oFpVOqrYqnkqveuodfqA9N+xXcjpm5qot+kVe+Wgbs0P0iNvTwOn+zKWUB6+idKcAEap CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee36ay35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 20:03:06 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PJDwWP003950;
        Tue, 25 Oct 2022 20:03:06 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee36ay2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 20:03:06 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PJo42H009311;
        Tue, 25 Oct 2022 20:03:05 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3kc85abb15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 20:03:05 +0000
Received: from smtpav06.dal12v.mail.ibm.com ([9.208.128.130])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PK327C54395250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:03:02 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 364A25805E;
        Tue, 25 Oct 2022 20:03:04 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8F8358059;
        Tue, 25 Oct 2022 20:03:03 +0000 (GMT)
Received: from [9.160.105.88] (unknown [9.160.105.88])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 20:03:03 +0000 (GMT)
Message-ID: <b4492820-a2d5-7f86-75e4-cb344e050a8f@linux.ibm.com>
Date:   Tue, 25 Oct 2022 15:03:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RFC PATCH net-next 0/1] ibmveth: Implement BQL
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, dave.taht@gmail.com
References: <20221024213828.320219-1-nnac123@linux.ibm.com>
 <20221025114148.1bcf194b@kernel.org>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20221025114148.1bcf194b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AIpGg8nWZtJThFscZ5r-fj40ms0Tf6-0
X-Proofpoint-GUID: IEx-t7lKrPThONKloOe8XZI2jAYpwd9b
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_12,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250113
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/22 13:41, Jakub Kicinski wrote:
> On Mon, 24 Oct 2022 16:38:27 -0500 Nick Child wrote:

>>  Does anyone know of a mechanism to measure the length
>> of a netdev_queue?
>>
>> I tried creating a BPF script[1] to track the bytes in a netdev_queue
>> but again am not seeing any difference with and without BQL. I do not
>> believe anything is wrong with BQL (it is more likely that my tracing
>> is bad) but I would like to have some evidence of BQL having a
>> positive effect on the device. Any recommendations or advice would be
>> greatly appreciated.
> 
> What qdisc are you using and what "netperf tests" are you running?

Th qdisc is default pfifo_fast.

I have tried the netperf tests described in the patchset which 
introduced BQL[1]. More specifically, 100 low priority netperf 
TCP_STREAMs with 1 high priority TCP_RR. The author of the patchset also 
listed data for number of queued bytes but did not explain how he 
managed to get those measurements.
Additionally, I have tried using flent[2] (a wrapper for netperf) to run 
performance measurements when the system is under considerable load. In 
particular I tried the flent rrul_prio (Realtime Response Under Load - 
Test Prio Queue) and rtt_fair (RTT Fair Realtime Response Under Load) tests.

Again, a positive effect on performance is not as much as a concern for 
me as knowing that BQL is doing is enforcing queue size limits.

Thanks for your help,
Nick

[1] https://lwn.net/Articles/469652/
[2] https://flent.org/
