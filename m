Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBD681C76
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjA3VME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjA3VLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:11:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D476B4954A;
        Mon, 30 Jan 2023 13:11:07 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UKxTWk009590;
        Mon, 30 Jan 2023 21:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HcjlVfrOv1ufsjNoGLMxRHYLBsqf1L3B/faZdAmMXaY=;
 b=UJzE5ZCwp0JGry9CEfeyRJjaAQh9swPy3C4Ek/qGqyXK2Pg9nsZA1BRkz7XPgud1xFXp
 iOc0yH4CCIfGblMTN3wfjFJ5iM5AadbKKQwJnQK8AoqjaD5wEilnzLCncNONdE/xGmXv
 6Zxba80/q2Jzdm8AQfp49PL8ubAHwe8+vvwxjPoAJqwo7gBsqzYmo24Mr/9J0pJP1FOC
 Gp5rjFBMQnND+ayRVLTQ0FlK01L39LSlap3jZkKeKKLgInxQ808kA06QBRpKVXPVhhjl
 q1C0P1u2x1YiTC3yodOQaaVW+aZJFTV9Q9cplkPH+/gPgWbF3NkgQcm+WhE4dNo8GEMS tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nemrg157y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 21:10:52 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30UL0Rvx016077;
        Mon, 30 Jan 2023 21:10:51 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nemrg157j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 21:10:51 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30UJWLG0012312;
        Mon, 30 Jan 2023 21:10:51 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3ncvvdcp3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 21:10:51 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30ULAnDR66847042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 21:10:49 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D6FE58066;
        Mon, 30 Jan 2023 21:10:49 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FB8958051;
        Mon, 30 Jan 2023 21:10:47 +0000 (GMT)
Received: from [9.163.16.35] (unknown [9.163.16.35])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 30 Jan 2023 21:10:47 +0000 (GMT)
Message-ID: <bb50c952-6075-d838-0bc3-4848c12ad920@linux.ibm.com>
Date:   Mon, 30 Jan 2023 22:10:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v6 1/7] net/smc: remove locks
 smc_client_lgr_pending and smc_server_lgr_pending
To:     "D. Wythe" <alibuda@linux.alibaba.com>, jaka@linux.ibm.com,
        kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669453422-38152-1-git-send-email-alibuda@linux.alibaba.com>
 <1669453422-38152-2-git-send-email-alibuda@linux.alibaba.com>
 <2ad147d3-b127-b192-c2a5-29fa704cf3a1@linux.alibaba.com>
 <c45960d9-c358-e47b-0a33-1de8c3a8f94c@linux.ibm.com>
 <a0de12ab-dd9a-acfe-4324-78815d6ebc35@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <a0de12ab-dd9a-acfe-4324-78815d6ebc35@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n1XjYMCVW_uU6JsafQeuCXCPeHojcDBw
X-Proofpoint-ORIG-GUID: 0v031njaaQJCNngYou4n-33jtcJZ3274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_17,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 adultscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301300197
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.01.23 11:51, D. Wythe wrote:
> 
> 
> On 1/30/23 4:37 PM, Wenjia Zhang wrote:
>>
>>
>> On 29.01.23 16:11, D. Wythe wrote:
>>>
>>>
>>> On 11/26/22 5:03 PM, D.Wythe wrote:
>>>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>>>
>>>> This patch attempts to remove locks named smc_client_lgr_pending and
>>>> smc_server_lgr_pending, which aim to serialize the creation of link
>>>> group. However, once link group existed already, those locks are
>>>> meaningless, worse still, they make incoming connections have to be
>>>> queued one after the other.
>>>>
>>>> Now, the creation of link group is no longer generated by competition,
>>>> but allocated through following strategy.
>>>>
>>>
>>>
>>> Hi, all
>>>
>>> I have noticed that there may be some difficulties in the advancement 
>>> of this series of patches.
>>> I guess the main problem is to try remove the global lock in this 
>>> patch, the risks of removing locks
>>> do harm to SMC-D, at the same time, this patch of removing locks is 
>>> also a little too complex.
>>>
>>> So, I am considering that we can temporarily delay the advancement of 
>>> this patch. We can works on
>>> other patches first. Other patches are either simple enough or have 
>>> no obvious impact on SMC-D.
>>>
>>> What do you think?
>>>
>>> Best wishes.
>>> D. Wythe
>>>
>>>
>> Hi D. Wythe,
>>
>> that sounds good. Thank you for your consideration about SMC-D!
> 
> Hi Wenjia,
> 
> Thanks for your reply.
> 
>> Removing locks is indeed a big issue, those patches make us difficult 
>> to accept without thoroughly testing in every corner.
>>
>> Best
>> Wenjia
> 
> What do you mean by those patches? My plan is to delete the first patch 
> in this series,
> that is, 'remove locks smc_client_lgr_pending and 
> smc_server_lgr_pending', while other patches
> should be retained.
> 
> They has almost nothing impact on SMC-D or simple enough to be tested. 
> If you agree with this,
> I can then issue the next version as soon as possible to remove the 
> first patch, and I think
> we can quickly promote those patches.
> 
> Thanks.
> Wenjia
> 
Except for the removing locks of smc_client_lgr_pending and 
smc_server_lgr_pending, I'm still not that sure if running 
SMC_LLC_FLOW_RKEY concurrently could make the communication between our 
Linux and z/OS broken, that we can not test currently, though I really 
like this idea.
Sure, you can send the next version, I'll find a way to verify it.



> 
> 
> 
