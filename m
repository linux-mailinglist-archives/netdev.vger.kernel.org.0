Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4150960EAAD
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 23:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiJZVKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 17:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiJZVKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 17:10:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBCB9379F
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 14:10:38 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QKkXkk017467;
        Wed, 26 Oct 2022 21:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6AbRs2yZXLAlN+3iL6qz52SqfS+TK3xHOEsvfYaf8/E=;
 b=kHhO2XOYHkgfCmpnMLBGH0Tg5ARbywmEq2xb/cdxWZ9i1ACvrBYYxOJOX0zyQ1IpaJcY
 h4C4/SF49apiEsfv869z7lVfnw7veneNRpodxPMyovUOFynPRugitTIQaheai2VfseD2
 Qt8N2PcL6YkibRidOnCl6/9q27FIxjTJWMe6JtCXmUovTvFf+EkXlhVvZNCtFHeV7BUN
 f6EJEsB3n9y1Lto2U+y3ibHTTqW/e1sMV2r940ZxdUXr0XJr4sJGLMgSyHp1pQQmnkqp
 W8GW/+/AQiwmxzkBJJvrkZ6Kbzzyu5QrWVCW6bRiy1K3x5ybLytb4UsmrblW6S3dV+B8 iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kfc7srnnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 21:10:28 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29QKmFT8025847;
        Wed, 26 Oct 2022 21:10:28 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kfc7srnmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 21:10:28 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29QL5FRi001558;
        Wed, 26 Oct 2022 21:10:26 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 3kfahy0fhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 21:10:26 +0000
Received: from smtpav05.wdc07v.mail.ibm.com ([9.208.128.117])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29QLAPd69241238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 21:10:25 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF7F358068;
        Wed, 26 Oct 2022 21:10:24 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52A8858067;
        Wed, 26 Oct 2022 21:10:24 +0000 (GMT)
Received: from [9.65.249.248] (unknown [9.65.249.248])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 21:10:24 +0000 (GMT)
Message-ID: <419f7e64-c15c-86b8-3b1d-ccedf60959f5@linux.ibm.com>
Date:   Wed, 26 Oct 2022 16:10:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RFC PATCH net-next 0/1] ibmveth: Implement BQL
Content-Language: en-US
To:     Dave Taht <dave.taht@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com
References: <20221024213828.320219-1-nnac123@linux.ibm.com>
 <20221025114148.1bcf194b@kernel.org>
 <b4492820-a2d5-7f86-75e4-cb344e050a8f@linux.ibm.com>
 <20221025151031.67f06127@kernel.org>
 <CAA93jw5reJmaOvt9vw15C1fo1AN7q5jVKzUocbAoNDC-cpi=KQ@mail.gmail.com>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <CAA93jw5reJmaOvt9vw15C1fo1AN7q5jVKzUocbAoNDC-cpi=KQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cJPVI0IDhpKIdKRkw2tNC0ssm6Lpekin
X-Proofpoint-GUID: 2SSywM6o1xKPN5G1nEao5kB3CMyRAMrr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/22 19:08, Dave Taht wrote:
> On Tue, Oct 25, 2022 at 3:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue, 25 Oct 2022 15:03:03 -0500 Nick Child wrote:
>>> Th qdisc is default pfifo_fast.
>>
>> You need a more advanced qdisc to seen an effect. Try fq.
>> BQL tries to keep the NIC queue (fifo) as short as possible
>> to hold packets in the qdisc. But if the qdisc is also just
>> a fifo there's no practical difference.
>>
>> I have no practical experience with BQL on virtualized NICs
>> tho, so unsure what gains you should expect to see..
> 

I understand. I think that is why I am trying to investigate this 
further, because the whole virtualization aspect could undermine
everything that BQL is trying to accomplish. That being said, I could 
also be shining my flashlight in the wrong places. Hence the reason for
the RFC.

> fq_codel would be a better choice of underlying qdisc for a test, and
> in this environment you'd need to pound the interface flat with hundreds
> of flows, preferably in both directions.
> 

Enabling FQ_CODEL and restarting tests, I am still not seeing any 
noticeable difference in bytes sitting in the netdev_queue (but it is 
possible my tracing is incorrect). I also tried reducing the number of 
queues, disabling tso and even running 100-500 parallel iperf 
connections. I can see the throughput and latency taking a hit with more 
connections so I assume the systems are saturated.

> My questions are:
> 
> If the ring buffers never fill, why do you need to allocate so many
> buffers in the first place?

The reasoning for 16 tx queues was mostly to allow for more parallel 
calls to the devices xmit function. After hearing your points about 
resource issues, I will send a patch to reduce this number to 8 queues.

> If bql never engages, what's the bottleneck elsewhere? XMIT_MORE?
> 

I suppose the question I am trying to pose is: How do we know that bql 
is engaging?

> Now the only tool for monitoring bql I know of is bqlmon.
> 
bqlmon is to useful for tracking the bql `limit` value assigned to a 
queue (IOW `watch 
/sys/class/net/<device>/queues/tx*/byte_queue_limits/limit` ) but 
whether or not this value is being applied to an active network 
connection is what I would like to figure out.

Thanks again for feedback and helping me out with this.
Nick Child

