Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A5958A657
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 09:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbiHEHGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 03:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbiHEHGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 03:06:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6241F605;
        Fri,  5 Aug 2022 00:06:06 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2756hbNo024239;
        Fri, 5 Aug 2022 07:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6ALatlPnA1QxQRbC705c9MjKoCFtKmnqmoMFwulymG4=;
 b=rkC1ixulDOzOsXeQUEdZ+BMu1bej5S6ZZBc9CZhN4TQC7e3z+qyOtCAurvg8xa8sak7g
 0IDb2jXTzxXE75wmk07BCeZc3SWHgDLKpNljUbv8fV7PInkeVw7iTviGDYV0ctiJpLDU
 CErCgQBEjmBvqAxnbAibo36c5aOhOFoSQlF5TCj8oQUlmR81tdNsaH0IKyudvoS2y76q
 qGs+g2C3DsEhQ8J7+5wc+c9GBaiBEs+Gs8IKTfQcbypoSeu993Kfj7vv2EXjMYH8akb2
 vwuU8Hn0brGlhKEuKBtsI7jPMcOxTYjNP1nzX2VNiHv7g4kMaSfZH7Tk6rXdjXEklDxw 7g== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrx6m8n5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 07:05:53 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27575pA8018275;
        Fri, 5 Aug 2022 07:05:51 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3hrf218tfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 07:05:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27575mNg28901722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Aug 2022 07:05:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D971A4054;
        Fri,  5 Aug 2022 07:05:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 233C6A405C;
        Fri,  5 Aug 2022 07:05:48 +0000 (GMT)
Received: from [9.145.46.72] (unknown [9.145.46.72])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Aug 2022 07:05:48 +0000 (GMT)
Message-ID: <7735d444-5041-ccde-accc-5a69af2f2731@linux.ibm.com>
Date:   Fri, 5 Aug 2022 09:05:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
 <20220803144015.52946-2-wintera@linux.ibm.com> <YuqR8HGEe2vWsxNz@lunn.ch>
 <dae87dee-67b0-30ce-91c0-a81eae8ec66f@linux.ibm.com>
 <YuvEu9/bzLGU2sTA@lunn.ch> <20220804132742.73f8bfda@kernel.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220804132742.73f8bfda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c8YJKOvEXvk_uJ6n4CqvuGWuBKcT1ekN
X-Proofpoint-GUID: c8YJKOvEXvk_uJ6n4CqvuGWuBKcT1ekN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_01,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.08.22 22:27, Jakub Kicinski wrote:
> On Thu, 4 Aug 2022 15:08:11 +0200 Andrew Lunn wrote:
>> On Thu, Aug 04, 2022 at 10:53:33AM +0200, Alexandra Winter wrote:
>>> Thank you Andrew for the review. I fully understand your point.
>>> I would like to propose that I put that on my ToDo list and fix
>>> that in a follow-on patch to net-next.
>>>
>>> The fields in the link_info control blocks are used today to generate
>>> other values (e.g. supported speed) which will not work with *_UNKNOWN,
>>> so the follow-on patch will be more than just 2 lines.  
>>
>> So it sounds like your code is all backwards around. If you know what
>> the hardware is, you know the supported link modes are, assuming its
>> not an SFP and the SFP module is not plugged in. Those link modes
>> should be independent of if the link is up or not. speed/duplex is
>> only valid when the link is up and negotiation has finished.
> 
> To make sure I understand - the code depends on the speed and duplex
> being set to something specific when the device is _down_? Can this be
> spelled out more clearly in the commit message?
This was a discussion about existing code. We display default speed and
duplex even when the device is down. And this patch does not change that
behaviour. Andrew rightfully pointed out that this should (eventually) be
changed.
> 
>> Since this is for net, than yes, maybe it would be best to go with a
>> minimal patch to make your backwards around code work. But for
>> net-next, you really should fix this properly. 
> 
> Then again this patch doesn't look like a regression fix (and does not
> have a fixes tag). Channeling my inner Greg I'd say - fix this right and
> then worry about backports later. 
This patch is a pre-req for [PATCH net 2/2] s390/qeth: use cached link_info for ethtool
2/2 is the regression fix.
Guidance is welcome. Should I merge them into a single commit?
Or clarify in the commit message of 1/1 that this is a preparation for 2/2?
