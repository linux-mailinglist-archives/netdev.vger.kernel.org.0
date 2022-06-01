Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BE353A43E
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349263AbiFALgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiFALgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:36:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24601326E6;
        Wed,  1 Jun 2022 04:36:03 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251A7Coe002163;
        Wed, 1 Jun 2022 11:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TEcSc53xq12JwZ22Jm+ODdKDD5AwMEfeVMyVhWez9hw=;
 b=ttSGw5fqRKA903UW753yjObMfeEdHTev/mVne0IVC9oE3f2LT4Z9hwfdzOKvnSWaxZ28
 Vto8GuvFQCP11bcSxQoR7ENsV7hZlGJZQ6p++pPH4dees+ShnTOM59AiYGMXxznprN3c
 UdieSl5volqMqRKKV0BYWo3gT63F8v1ADxExO2Yg4SfGgAmFMpoIBuh+bkLm9B0VlnrL
 9tCelFJP1eI4+be0l//XFnPoEbAmwZ5hoF0zFXE/qBG4JB5twWM45Av6ikKvfSIhcHNb
 6+KJ4Hvp9y7UEoIR2kPmNmaL+3OzQyBBMeb6JPzXKw5sa/90Vqg1v1Ln+Tevte7fDHkw 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge4uq374g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 11:35:58 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251AwcgX017146;
        Wed, 1 Jun 2022 11:35:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge4uq373j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 11:35:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251BJioS008613;
        Wed, 1 Jun 2022 11:35:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3gbc97v6nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 11:35:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251BZr0425952586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 11:35:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9963C4C04E;
        Wed,  1 Jun 2022 11:35:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 555914C044;
        Wed,  1 Jun 2022 11:35:53 +0000 (GMT)
Received: from [9.152.224.55] (unknown [9.152.224.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jun 2022 11:35:53 +0000 (GMT)
Message-ID: <7fb28436-1fca-ba4c-7745-ca88d83c657b@linux.ibm.com>
Date:   Wed, 1 Jun 2022 13:35:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
 <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
 <YpcwaNLUtPyzPBgc@TonyMac-Alibaba>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <YpcwaNLUtPyzPBgc@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rmR-56A_Yc69QUhYc_L6F9UW8RmytESf
X-Proofpoint-GUID: 7mMhP4ywYKudnr9aA5spIx1AfmBjT44B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_03,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010052
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01.06.22 11:24, Tony Lu wrote:
> On Wed, Jun 01, 2022 at 02:33:09PM +0800, D. Wythe wrote:
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
>> as a feature area, works like bitmap. Considering the subsequent
>> scalability, we MAY use at least 2 reserved ctets, which can support
>> negotiation of at least 16 features.
>>
>> 2. Unify all the areas named extension in current
>> SMC v2 protocol spec without reinterpreting any existing field
>> and field offset changes, including 'PROPOSAL V1 IP Subnet Extension',
>> 'PROPOSAL V2 Extension', 'PROPOSAL SMC-DV2 EXTENSION' .etc. And provides
>> the ability to grow dynamically as needs expand. This scheme will use
>> at least 10 reserved octets in the PROPOSAL MESSAGE and at least 4 reserved
>> octets in ACCEPT MESSAGE and CONFIRM MESSAGE. Fortunately, we only need to
>> use reserved fields, and the current reserved fields are sufficient. And
>> then we can easily add a new extension named SIGNLE LINK. Limited by space,
>> the details will be elaborated after the scheme is finalized.
> 
> After reading this and latest version of protocol, I agree with that the
> idea to provide a more flexible extension facilities. And, it's a good
> chance for us to set here talking about the protocol extension.
> 
> There are some potential scenarios that need flexible extensions in my
> mind:
> - other protocols support, such as iWARP / IB or new version protocol,
> - dozens of feature flags in the future, like this proposal. With the
>   growth of new feature, it could overflow bitmap.
> 
> Actually, this extension facilities are very similar to TCP options.
> 
> So what about your opinions about the solution of this? If there are
> some existed approaches for the future extensions, maybe this can get
> involved in it. Or we can start a discuss about this as this mail
> mentioned.
> 
> Also, I am wondering if there is plan to update the RFC7609, add the
> latest v2 support?
> 
> Thanks,
> Tony Lu

We have asked the SMC protocol owners about their opinion about using the
reserved fields for new options in particular, and about where and how to
discuss this in general. (including where to document the versions).
Please allow some time for us to come back to you.

Kind regards
Alexandra
