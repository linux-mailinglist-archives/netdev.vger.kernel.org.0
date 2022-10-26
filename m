Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA760E1B3
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiJZNNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiJZNNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:13:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DBAFC1F7;
        Wed, 26 Oct 2022 06:13:09 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QCwTTa002523;
        Wed, 26 Oct 2022 13:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=i2E+t/Pe3kj7ipB6NqOEl4e14Vgssw/e2wZiQp6qfS4=;
 b=YB07XIJl7LQSX4pkh8IoGC5Oz0SgivyFxRl+cH690nhwyE5O3vYRXRaaIPF1qT8nnrk9
 T0XmcytE+bJab069hkY/JfFwUXfcLENJXWkz/YrPOOMwYLEG+JOBmufmR6NvuvF5Rvzf
 4tX3BGifg9t8pHGvraDei42HigFRuJMGufSzu0rVVFegZlVyjdu35I/tTCZ10blV9Pif
 TLz7O7L4MfBMTPoT5i4GK+7OMe2lkiTuWsW5SZDfCCFucIc7M13cqnTstnMdkyRxhbVD
 fYml/UeWqjjHjPoc6kzakhCAjENE1J9VKrapgh4oUNHpr2KUEcxGzva3UisGgZ7gc2vs UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf5cc8t6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:13:02 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29QCwb53003515;
        Wed, 26 Oct 2022 13:13:01 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf5cc8sxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:13:01 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29QD4xXH029864;
        Wed, 26 Oct 2022 13:12:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kc7sj7g4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:12:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29QD7ZQV40042896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 13:07:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19B6AA4054;
        Wed, 26 Oct 2022 13:12:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB034A405B;
        Wed, 26 Oct 2022 13:12:49 +0000 (GMT)
Received: from [9.171.65.88] (unknown [9.171.65.88])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 13:12:49 +0000 (GMT)
Message-ID: <35d14144-28f7-6129-d6d3-ba16dae7a646@linux.ibm.com>
Date:   Wed, 26 Oct 2022 15:12:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v3 00/10] optimize the parallelism of SMC-R
 connections
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
 <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
 <79e3bccb-55c2-3b92-b14a-7378ef02dd78@linux.ibm.com>
 <4127d84d-e3b4-ca44-2531-8aed12fdee3f@linux.alibaba.com>
 <f8ea7943-4267-8b8d-f8b4-831fea7f3963@linux.ibm.com>
 <Y1d+jDQiyn4LSKlu@TonyMac-Alibaba>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <Y1d+jDQiyn4LSKlu@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v6H8fLsvE4Zk2OZe6YU3NfSeL9ybgeHj
X-Proofpoint-ORIG-GUID: WV6TO0yESz1bHI3sM6OQMzFraQ2-li7G
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_06,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=593 lowpriorityscore=0
 bulkscore=0 spamscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/10/2022 08:13, Tony Lu wrote:
> On Mon, Oct 24, 2022 at 03:10:54PM +0200, Jan Karcher wrote:
>> Hi D. Wythe,
>>
>> I reply with the feedback on your fix to your v4 fix.
>>
>> Regarding your questions:
>> We are aware of this situation and we are currently evaluating how we want
>> to deal with SMC-D in the future because as of right now i can understand
>> your frustration regarding the SMC-D testing.
>> Please give me some time to hit up the right people and collect some
>> information to answer your question. I'll let you know as soon as i have an
>> answer.

Hi Tony (and D.),
> 
> Hi Jan,
> 
> We sent a RFC [1] to mock SMC-D device for inter-VM communication. The
> original purpose is not to test, but for now it could be useful for the
> people who are going to test without physical devices in the community.

I'm aware of the RFC and various people in IBM looked over it.

As stated in the last mail we are aware that the entanglement between 
SMC-D and ISM is causing problems for the community.
To give you a little insight:

In order to improve the code quality and usability for the broader 
community we are working on placing an API between SMC-D and the ISM 
device. If this API is complete it will be easier to use different 
"devices" for SMC-D. One could be your device driver for inter-VM 
communication (ivshmem).
Another one could be a "Dummy-Device" which just implements the required 
interface which acts as a loopback device. This would work only in a 
single Linux instance, thus would be the perfect device to test SMC-D 
logic for the broad community.
We would hope that these changes remove the hardware restrictions and 
that the community picks up the idea and implements devices and improves 
SMC (including SMC-D and SMC-R) even more in the future!

As i said - and also teased by Alexandra in a respond to your RFC - this 
API feature is currently being developed and in our internal reviews. 
This would make your idea with the inter-VM communication a lot easier 
and would provide a clean base to build upon in the future.

> 
> This driver basically works but I would improve it for testing. Before
> that, what do you think about it?

I think it is a great idea and we should definetly give it a shot! I'm 
also putting a lot in code quality and future maintainability. The API 
is a key feature there improving the usability for the community and our 
work as maintainers. So - for the sake of the future of the SMC code 
base - I'd like to wait with putting your changes upstream for the API 
and use your idea to see if fits our (and your) requirements.

> 
> And where to put this driver? In kernel with SMC code or merge into
> separate SMC test cases. I haven't made up my mind yet.

We are not sure either currently, and have to think about that for a 
bit. I think your driver could be a classic driver, since it is usable 
for a real world problem (communication between two VMs on the same 
host). If we look at the "Dummy-Device" above we see that it does not 
provide any value beside testing. Feel free to share your ideas on that 
topic.

> 
> [1] https://lore.kernel.org/netdev/20220720170048.20806-1-tonylu@linux.alibaba.com/
> 
> Cheers,
> Tony Lu

A friendly disclaimer: Even tho this API feature is pretty far in the 
development process it can always be that we decide to drop it, if it 
does not meet our quality expectations. But of course we'll keep you 
updated.

- Jan
