Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B434951EB
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 17:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376813AbiATQA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 11:00:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243632AbiATQA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 11:00:28 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KFmDep008880;
        Thu, 20 Jan 2022 16:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gupPrdVIdj7SwKoI26HJCs2fOy4ojWK4YXYErXoYjgs=;
 b=E9Dhs/wQiEfoJBUTUPo9UN87chjFQFrISk5M072aPUCdKheVVw6ilsvLPt/lNx4wpHwg
 ezyeo+3zF0UhffEg1dihvzM/dI8OCSCT/LtDxEMPElONwUPKtZYvAo6iNIcAkI/53AEm
 JG7DbDGv8C258/lBIQ1ROgempIhGerdIzeY/V7bu91s6Sd1vBAgFTPLRbUpKHV6ULSLH
 40RjXN6MYYHNjHLdPXZCL1sWc/vZIRG178cQb6VUZWuVM19gQrdXOHrf9Fe7VbyZ6KVx
 oTbblZ3939zfJJln6o8yW4SBS4QuP23LYH9xS9mZbCFm6LxBvYB8Ei41O/QgqEddWrww 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqapngfpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 16:00:26 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20KG0PkW015835;
        Thu, 20 Jan 2022 16:00:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqapngfkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 16:00:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KFvqmm028139;
        Thu, 20 Jan 2022 16:00:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhk380q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 16:00:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KG0JYh42336628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:00:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2A14A4066;
        Thu, 20 Jan 2022 16:00:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E210A4068;
        Thu, 20 Jan 2022 16:00:19 +0000 (GMT)
Received: from [9.171.36.133] (unknown [9.171.36.133])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jan 2022 16:00:19 +0000 (GMT)
Message-ID: <591d2e47-edd9-453a-a888-c43ba5b76a1e@linux.ibm.com>
Date:   Thu, 20 Jan 2022 17:00:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>
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
 <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
 <YelmFWn7ot0iQCYG@TonyMac-Alibaba>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <YelmFWn7ot0iQCYG@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dsBJzItTA-47pkbs7Bd9WYnuSK2Smar3
X-Proofpoint-ORIG-GUID: K6gQPcKdjNxaAW_w8gQ53t0SKhqEEu98
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_06,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/22 14:39, Tony Lu wrote:
> On Thu, Jan 13, 2022 at 09:07:51AM +0100, Karsten Graul wrote:
>> On 06/01/2022 08:05, Tony Lu wrote:
>>
>> I think of the following approach: the default maximum of active workers in a
>> work queue is defined by WQ_MAX_ACTIVE (512). when this limit is hit then we
>> have slightly lesser than 512 parallel SMC handshakes running at the moment,
>> and new workers would be enqueued without to become active.
>> In that case (max active workers reached) I would tend to fallback new connections
>> to TCP. We would end up with lesser connections using SMC, but for the user space
>> applications there would be nearly no change compared to TCP (no dropped TCP connection
>> attempts, no need to reconnect).
>> Imho, most users will never run into this problem, so I think its fine to behave like this.
> 
> This makes sense to me, thanks.
> 
>>
>> As far as I understand you, you still see a good reason in having another behavior
>> implemented in parallel (controllable by user) which enqueues all incoming connections
>> like in your patch proposal? But how to deal with the out-of-memory problems that might
>> happen with that?
> 
> There is a possible scene, when the user only wants to use SMC protocol, such
> as performance benchmark, or explicitly specify SMC protocol, they can
> afford the lower speed of incoming connection creation, but enjoy the
> higher QPS after creation.
> 
>> Lets decide that when you have a specific control that you want to implement.
>> I want to have a very good to introduce another interface into the SMC module,
>> making the code more complex and all of that. The decision for the netlink interface
>> was also done because we have the impression that this is the NEW way to go, and
>> since we had no interface before we started with the most modern way to implement it.
>>
>> TCP et al have a history with sysfs, so thats why it is still there.
>> But I might be wrong on that...
> 
> Thanks for the information that I don't know about the decision for new
> control interface. I am understanding your decision about the interface.
> We are glad to contribute the knobs to smc_netlink.c in the next patches.
> 
> There is something I want to discuss here about the persistent
> configuration, we need to store new config in system, and make sure that
> it could be loaded correctly after boot up. A possible solution is to
> extend smc-tools for new config, and work with systemd for auto-loading.
> If it works, we are glad to contribute these to smc-tools.

I'd be definitely open to look into patches for smc-tools that extend it to 
configure SMC properties, and that provide the capability to read (and apply) a 
config from a file! We can discuss what you'd imagine as an interface before you 
implement it, too.

Ciao,
Stefan
