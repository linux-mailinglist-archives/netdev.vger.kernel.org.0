Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C059B48D365
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiAMIIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:08:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48802 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbiAMIH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:07:59 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20D7pSrA027405;
        Thu, 13 Jan 2022 08:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xjPJgtbxCzwnEeTfwpTIz1VU2ynEJWJfr8miUH+Sq4E=;
 b=fKni5zZUP695DIWnwzhAYFCgAoPbTVRPwsNsLh9dt39DThifRm4hom44caAe4DS54l6E
 FJ16H4P/azonldAHTlvpay8qe6FpXcxAKpKg3oWbCzRNWe2JqWa2iuIIWbT7k0c/ozjX
 CFC7EwCVZsRYh8Bg2CLS3+Msb+nsMtn8xv0yAMf/HheRS+y2uETUBCGJzxka7iuoF5PC
 xxFwNFRS+7yiHDnEZNZOkEv9aAY3XAx4nBYtzChDamfc6F6UQz9lSe1XXz20is/Ra+Hq
 C7MSbV608wK+95YvOJJtqOrVUTFdWd2u8IrlCqxRXO0NFFZawXGSz8W4ce/8CTcVtZDW jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djg2eg9xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 08:07:54 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20D80MMA005766;
        Thu, 13 Jan 2022 08:07:54 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djg2eg9x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 08:07:54 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20D7vLGP032514;
        Thu, 13 Jan 2022 08:07:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3df289r4d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 08:07:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20D7wjrj34275640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 07:58:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 298FA52067;
        Thu, 13 Jan 2022 08:07:50 +0000 (GMT)
Received: from [9.145.9.227] (unknown [9.145.9.227])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B79D85205A;
        Thu, 13 Jan 2022 08:07:49 +0000 (GMT)
Message-ID: <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
Date:   Thu, 13 Jan 2022 09:07:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, dust.li@linux.alibaba.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
 <20220105150612.GA75522@e02h04389.eu6sqa>
 <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
 <YdaUuOq+SkhYTWU8@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YdaUuOq+SkhYTWU8@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8HnaXHeVeHiC926I7exh9DMSSvNS1bZa
X-Proofpoint-ORIG-GUID: dC5KELK1flj9ewxiJUUVobOiHL3kECki
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_02,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2022 08:05, Tony Lu wrote:
> On Wed, Jan 05, 2022 at 08:13:23PM +0100, Karsten Graul wrote:
>> On 05/01/2022 16:06, D. Wythe wrote:
>>> LGTM. Fallback makes the restrictions on SMC dangling
>>> connections more meaningful to me, compared to dropping them.
>>>
>>> Overall, i see there are two scenario.
>>>
>>> 1. Drop the overflow connections limited by userspace application
>>> accept.
>>>
>>> 2. Fallback the overflow connections limited by the heavy process of
>>> current SMC handshake. ( We can also control its behavior through
>>> sysctl.)
>>>
>>
>> I vote for (2) which makes the behavior from user space applications point of view more like TCP.
> Fallback when smc reaches itself limit is a good idea. I'm curious
> whether the fallback reason is suitable, it more like a non-negative
> issue. Currently, smc fallback for negative issues, such as resource not
> available or internal error. This issue doesn't like a non-negative
> reason.

SMC falls back when the SMC processing cannot be completed, e.g. due to 
resource constraints like memory. For me the time/duration constraint is
also a good reason to fall back to TCP.

> 
> And I have no idea about to mix the normal and fallback connections at
> same time, meanwhile there is no error happened or hard limit reaches,
> is a easy to maintain for users? Maybe let users misunderstanding, a
> parameter from userspace control this limit, and the behaviour (drop or
> fallback).

I think of the following approach: the default maximum of active workers in a
work queue is defined by WQ_MAX_ACTIVE (512). when this limit is hit then we
have slightly lesser than 512 parallel SMC handshakes running at the moment,
and new workers would be enqueued without to become active.
In that case (max active workers reached) I would tend to fallback new connections
to TCP. We would end up with lesser connections using SMC, but for the user space
applications there would be nearly no change compared to TCP (no dropped TCP connection
attempts, no need to reconnect).
Imho, most users will never run into this problem, so I think its fine to behave like this.

As far as I understand you, you still see a good reason in having another behavior 
implemented in parallel (controllable by user) which enqueues all incoming connections
like in your patch proposal? But how to deal with the out-of-memory problems that might 
happen with that?

>  
>> One comment to sysctl: our current approach is to add new switches to the existing 
>> netlink interface which can be used with the smc-tools package (or own implementations of course). 
>> Is this prereq problematic in your environment? 
>> We tried to avoid more sysctls and the netlink interface keeps use more flexible.
> 
> I agree with you about using netlink is more flexible. There are
> something different in our environment to use netlink to control the
> behaves of smc.
> 
> Compared with netlink, sysctl is:
> - easy to use on clusters. Applications who want to use smc, don't need
>   to deploy additional tools or developing another netlink logic,
>   especially for thousands of machines or containers. With smc forward,
>   we should make sure the package or logic is compatible with current
>   kernel, but sysctl's API compatible is easy to discover.
> 
> - config template and default maintain. We are using /etc/sysctl.conf to
>   make sure the systeml configures update to date, such as pre-tuned smc
>   config parameters. So that we can change this default values on boot,
>   and generate lots of machines base on this machine template. Userspace
>   netlink tools doesn't suit for it, for example ip related config, we
>   need additional NetworkManager or netctl to do this.
> 
> - TCP-like sysctl entries. TCP provides lots of sysctl to configure
>   itself, somethings it is hard to use and understand. However, it is
>   accepted by most of users and system. Maybe we could use sysctl for
>   the item that frequently and easy to change, netlink for the complex
>   item.
> 
> We are gold to contribute to smc-tools. Use netlink and sysctl both
> time, I think, is a more suitable choice.

Lets decide that when you have a specific control that you want to implement. 
I want to have a very good to introduce another interface into the SMC module,
making the code more complex and all of that. The decision for the netlink interface 
was also done because we have the impression that this is the NEW way to go, and
since we had no interface before we started with the most modern way to implement it.

TCP et al have a history with sysfs, so thats why it is still there. 
But I might be wrong on that...
