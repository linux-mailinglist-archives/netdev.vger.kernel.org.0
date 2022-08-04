Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2BC589D00
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbiHDNo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 09:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiHDNo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:44:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7697A29CBA;
        Thu,  4 Aug 2022 06:44:55 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274DhVl5002361;
        Thu, 4 Aug 2022 13:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+TBm99yV08FbCekbpZqluqUFSQ4a4LJwB/P+oD1RPHw=;
 b=Sv4PaZt/vPZKVk484h43IewSnNcgLjZKvfKhczt/FLc/kt9c0KNRR3281uFpducrr4sl
 dt5aPxtvooC7H9UxdcAsulIXwYW3SXY4sYaSY01mtP3xV7miA6RY2rWHmyPZVw4Kg6LR
 RerHdARx2Q2FzKKqHDqcVp35a1ASo92D0seBuzcEutW9gs5zv4dr1KYuCzRGuMjDgwza
 7g8ge3N6UWZtD4yZ98MJ3hxoTnwW+SY8gAY3pbwuT06Ps4Fw9UND4wLFjYNsFLieqqrb
 jfuadr/IyUCN+EU5DWqyU9IAcoBjZnb5qu+lmHx8JxCR7cf5tcBkHhDgTfpXIxHErFOS LA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrf89g10s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 13:44:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 274DakBb003904;
        Thu, 4 Aug 2022 13:44:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3hmv98vmnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 13:44:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 274DihWG30212436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Aug 2022 13:44:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 664154C046;
        Thu,  4 Aug 2022 13:44:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ABF64C040;
        Thu,  4 Aug 2022 13:44:43 +0000 (GMT)
Received: from [9.152.224.235] (unknown [9.152.224.235])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Aug 2022 13:44:43 +0000 (GMT)
Message-ID: <9d3d619e-e3ad-28d2-b319-d647b1c39b69@linux.ibm.com>
Date:   Thu, 4 Aug 2022 15:44:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
 <20220803144015.52946-2-wintera@linux.ibm.com> <YuqR8HGEe2vWsxNz@lunn.ch>
 <dae87dee-67b0-30ce-91c0-a81eae8ec66f@linux.ibm.com>
 <YuvEu9/bzLGU2sTA@lunn.ch>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <YuvEu9/bzLGU2sTA@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aN-dlBElek0KGqHdN3cniF85oUNoBh54
X-Proofpoint-ORIG-GUID: aN-dlBElek0KGqHdN3cniF85oUNoBh54
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208040061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.08.22 15:08, Andrew Lunn wrote:
> On Thu, Aug 04, 2022 at 10:53:33AM +0200, Alexandra Winter wrote:
>>
>>
>> On 03.08.22 17:19, Andrew Lunn wrote:
>>> On Wed, Aug 03, 2022 at 04:40:14PM +0200, Alexandra Winter wrote:
>>>> Speed, duplex, port type and link mode can change, after the physical link
>>>> goes down (STOPLAN) or the card goes offline
>>>
>>> If the link is down, speed, and duplex are meaningless. They should be
>>> set to DUPLEX_UNKNOWN, SPEED_UNKNOWN. There is no PORT_UNKNOWN, but
>>> generally, it does not change on link up, so you could set this
>>> depending on the hardware type.
>>>
>>> 	Andrew
>>
>> Thank you Andrew for the review. I fully understand your point.
>> I would like to propose that I put that on my ToDo list and fix
>> that in a follow-on patch to net-next.
>>
>> The fields in the link_info control blocks are used today to generate
>> other values (e.g. supported speed) which will not work with *_UNKNOWN,
>> so the follow-on patch will be more than just 2 lines.
> 
> So it sounds like your code is all backwards around. If you know what
> the hardware is, you know the supported link modes are, assuming its
> not an SFP and the SFP module is not plugged in. Those link modes
> should be independent of if the link is up or not. speed/duplex is
> only valid when the link is up and negotiation has finished.
> 
> Since this is for net, than yes, maybe it would be best to go with a
> minimal patch to make your backwards around code work. But for
> net-next, you really should fix this properly. 
> 
> 	  Andrew

Thank you Andrew. I agree with your analysis.
