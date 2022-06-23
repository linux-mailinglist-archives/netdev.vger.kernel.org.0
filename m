Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5432F5579AA
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiFWMBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiFWMBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:01:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2434C4DF7F;
        Thu, 23 Jun 2022 04:59:56 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NAAIh0009543;
        Thu, 23 Jun 2022 11:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1gS4KqEglfRa2rs5isdJZVuSaMHH0gdUvV5HnNnTsW0=;
 b=SD/tdpMpyT1daJEDwiIpWDRYxaANxCefbVKQQsywS+urdxrEUw2xx5cL5bjvx4f6GMtA
 7bsizi8lRQvHwcNGmFSxxaDLiO8B5BZ+US7JIiflrgFC8qVQKrmWVmlpGTskXETRXD12
 msLOPfu2gD3+Ic6vML824XjrZwks3ANAfP3RXMPuLQibsVz7GNwPx8Z71HTu3UGjT9DK
 EsuJn3I6P/RWIES8gbn9nmGd7Upd2fveCT4m8ZmPniAYYbuDbC7LVwiaKdf/j+r8p9Kg
 hzrJFwVZr8649XX9ntMt/u6XeyFfuhU5zVp2IJn90Sv0VZqossxmDeVmVquCXquapFzy QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvm1m6w0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 11:59:43 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25NBl8Ne012646;
        Thu, 23 Jun 2022 11:59:42 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvm1m6w0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 11:59:42 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25NBow4T020689;
        Thu, 23 Jun 2022 11:59:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3gv3j695xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 11:59:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25NBxb3214221574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 11:59:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB04A4203F;
        Thu, 23 Jun 2022 11:59:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7661E42041;
        Thu, 23 Jun 2022 11:59:37 +0000 (GMT)
Received: from [9.152.224.219] (unknown [9.152.224.219])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jun 2022 11:59:37 +0000 (GMT)
Message-ID: <002050da-64a3-4648-6e8f-b3ae8ed3eece@linux.ibm.com>
Date:   Thu, 23 Jun 2022 13:59:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
 <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
 <61fbee55-245f-b912-95df-d9557849d08f@linux.alibaba.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <61fbee55-245f-b912-95df-d9557849d08f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qa_w1FBYzPPkVKAUpEcTDPLn9INaWrnA
X-Proofpoint-GUID: gJ0uhpLdNZOJ2bK1bS5CHApB9QFQfG1w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_05,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.06.22 15:49, D. Wythe wrote:
> 
> 
> On 2022/6/1 下午2:33, D. Wythe wrote:
>>
>> 在 2022/5/25 下午9:42, Alexandra Winter 写道:
>>
>>> We need to carefully evaluate them and make sure everything is compatible
>>> with the existing implementations of SMC-D and SMC-R v1 and v2. In the
>>> typical s390 environment ROCE LAG is propably not good enough, as the card
>>> is still a single point of failure. So your ideas need to be compatible
>>> with link redundancy. We also need to consider that the extension of the
>>> protocol does not block other desirable extensions.
>>>
>>> Your prototype is very helpful for the understanding. Before submitting any
>>> code patches to net-next, we should agree on the details of the protocol
>>> extension. Maybe you could formulate your proposal in plain text, so we can
>>> discuss it here?
>>>
>>> We also need to inform you that several public holidays are upcoming in the
>>> next weeks and several of our team will be out for summer vacation, so please
>>> allow for longer response times.
>>>
>>> Kind regards
>>> Alexandra Winter
>>>
>>
>> Hi alls,
>>
>> In order to achieve signle-link compatibility, we must
>> complete at least once negotiation. We wish to provide
>> higher scalability while meeting this feature. There are
>> few ways to reach this.
>>
>> 1. Use the available reserved bits. According to
>> the SMC v2 protocol, there are at least 28 reserved octets
>> in PROPOSAL MESSAGE and at least 10 reserved octets in
>> ACCEPT MESSAGE are available. We can define an area in which
>> as a feature area, works like bitmap. Considering the subsequent scalability, we MAY use at least 2 reserved ctets, which can support negotiation of at least 16 features.
>>
>> 2. Unify all the areas named extension in current
>> SMC v2 protocol spec without reinterpreting any existing field
>> and field offset changes, including 'PROPOSAL V1 IP Subnet Extension',
>> 'PROPOSAL V2 Extension', 'PROPOSAL SMC-DV2 EXTENSION' .etc. And provides
>> the ability to grow dynamically as needs expand. This scheme will use
>> at least 10 reserved octets in the PROPOSAL MESSAGE and at least 4 reserved octets in ACCEPT MESSAGE and CONFIRM MESSAGE. Fortunately, we only need to use reserved fields, and the current reserved fields are sufficient. And then we can easily add a new extension named SIGNLE LINK. Limited by space, the details will be elaborated after the scheme is finalized.
>>
[...]
>>
>>
>> Look forward to your advice and comments.
>>
>> Thanks.
> 
> Hi all,
> 
> On the basis of previous，If we can put the application data over the PROPOSAL message,
> we can achieve SMC 0-RTT. Its process should be similar to the following:
> 
[...]

Thank you D. Wythe for the detailed proposal, I have forwarded it to the protocol owner
and we are currently reviewing it. 
We may contact you and Tony Lu directly to discuss the details, if that is ok for you.

Kind regards
Alexandra Winter





