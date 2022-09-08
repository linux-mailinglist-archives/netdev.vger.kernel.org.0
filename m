Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5BB5B18F4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiIHJlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiIHJlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:41:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00792DABA2;
        Thu,  8 Sep 2022 02:41:10 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2889DPwm018157;
        Thu, 8 Sep 2022 09:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vFrn8IEYcuoemmb+U8aUPvmcXQTyk/sjWExgr/AGv80=;
 b=MeMti80IqEjxrCmYrt+fSsZEdbKgeqnyjLcPWTnZvc8S9kVCUBJM0gYMiW93KAexx2NN
 Ey/izat2nb+0m1/u4Ut6eBJ397GNPOotuO/BpE6pNB1XsJfdMNdF4q2MAiHsB+qkKwYi
 FbPiBbsndSiuYpeV65B7jVEIfQYJaNM5clgEL5Pbl2oJkRntrW4w6ztUVjbr6kgml44k
 kFB5Ti/Dq1Z2TvIQ6rx+9SJ3ICV1j7uC4wl/bp/fyxBrwXFLmPPl8EdCW6wDvcjCsVzm
 YBDiM1CB14BltbnAxur2pKZZiz5OeLo77Uzr8IYGVrByUw1h3maWxUfF5bd3vfBWgfgn 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfdjkgtec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 09:40:34 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2889dwA3016973;
        Thu, 8 Sep 2022 09:40:34 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfdjkgtcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 09:40:33 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2889aM7h022888;
        Thu, 8 Sep 2022 09:40:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3jbxj8mqeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 09:40:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2889eSlo24838422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Sep 2022 09:40:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1310C11C050;
        Thu,  8 Sep 2022 09:40:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75B3811C04C;
        Thu,  8 Sep 2022 09:40:27 +0000 (GMT)
Received: from [9.171.66.190] (unknown [9.171.66.190])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  8 Sep 2022 09:40:27 +0000 (GMT)
Message-ID: <375efe42-910d-69ae-e48d-cff0298dd104@linux.ibm.com>
Date:   Thu, 8 Sep 2022 11:40:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC net] tcp: Fix performance regression for request-response
 workloads
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
References: <20220907122505.26953-1-wintera@linux.ibm.com>
 <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Mv-lsnKL3B6wBeXAACNoMkZhXubUdscA
X-Proofpoint-GUID: GvcktbD9KF6_2vifa7qy07mGqh8-_705
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_06,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 mlxlogscore=971
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209080034
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 07.09.22 um 18:06 schrieb Eric Dumazet:
> On Wed, Sep 7, 2022 at 5:26 AM Alexandra Winter <wintera@linux.ibm.com> wrote:
>>
>> Since linear payload was removed even for single small messages,
>> an additional page is required and we are measuring performance impact.
>>
>> 3613b3dbd1ad ("tcp: prepare skbs for better sack shifting")
>> explicitely allowed "payload in skb->head for first skb put in the queue,
>> to not impact RPC workloads."
>> 472c2e07eef0 ("tcp: add one skb cache for tx")
>> made that obsolete and removed it.
>> When
>> d8b81175e412 ("tcp: remove sk_{tr}x_skb_cache")
>> reverted it, this piece was not reverted and not added back in.
>>
>> When running uperf with a request-response pattern with 1k payload
>> and 250 connections parallel, we measure 13% difference in throughput
>> for our PCI based network interfaces since 472c2e07eef0.
>> (our IO MMU is sensitive to the number of mapped pages)
> 
> 
> 
>>
>> Could you please consider allowing linear payload for the first
>> skb in queue again? A patch proposal is appended below.
> 
> No.
> 
> Please add a work around in your driver.
> 
> You can increase throughput by 20% by premapping a coherent piece of
> memory in which
> you can copy small skbs (skb->head included)
> 
> Something like 256 bytes per slot in the TX ring.
> 

FWIW this regression was withthe standard mellanox driver (nothing s390 specific).
