Return-Path: <netdev+bounces-6563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD16716EEA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C939E281384
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0071A200B4;
	Tue, 30 May 2023 20:37:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E180E7E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:37:03 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4525319B;
	Tue, 30 May 2023 13:36:33 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UJQmRe017820;
	Tue, 30 May 2023 20:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=X7HRVosRgmJs5+RFEXM6XSFA8cNWjEsb1oakecBUyJE=;
 b=oxIcMiPcE5bSc4zXf6h3IroIipLvp3dCDjHBuv96sI7QbySt912o6oj9RtQ52M0S/Lfm
 ZN6Tw3e/ldJWkta8PQHGLPMNuCqcTLediIigC0JMCz5tgd+wCZiufXXCWlHjw0SkWzBb
 vI9Ygaou0tABCsqAPTD5MtmHsLhf//cLIP6+1ScdfScsjjz+BkYqF2uNdIVXJCmjM1oE
 0lHQ+QegL21JT97klPanz5wy9JX0q/wQIz5fxjMKuIIwf+KLO+EVV1PhjN4npqBfqSYm
 VDwvq0+n+Zao5jimV2Z0IddbH5elcgsZxcdAPAAbqaJjmQNpFiYNvLtHPEyFxys70YGr lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwmx25qnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 20:34:35 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UKSaM4004765;
	Tue, 30 May 2023 20:34:35 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwmx25qn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 20:34:35 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
	by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34UHoGjq016721;
	Tue, 30 May 2023 20:34:34 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
	by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3qu9g61jb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 20:34:34 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UKYWq025166464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 20:34:33 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD21758052;
	Tue, 30 May 2023 20:34:32 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B59C358050;
	Tue, 30 May 2023 20:34:30 +0000 (GMT)
Received: from [9.61.92.222] (unknown [9.61.92.222])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 May 2023 20:34:30 +0000 (GMT)
Message-ID: <f309d525-7e12-ee81-8d59-ad07f94f9e9d@linux.ibm.com>
Date: Tue, 30 May 2023 22:34:29 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH net 2/2] net/smc: Don't use RMBs not mapped to new link in
 SMCRv2 ADD LINK
To: Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1685101741-74826-1-git-send-email-guwen@linux.alibaba.com>
 <1685101741-74826-3-git-send-email-guwen@linux.alibaba.com>
 <f134294c-2919-6069-d362-87a84c846690@linux.ibm.com>
 <34e6b564-a658-4461-ebec-f53dd80a9125@linux.alibaba.com>
From: Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <34e6b564-a658-4461-ebec-f53dd80a9125@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6Gnmr9EKebcZZGXDVLBeslmA6qIBq4SM
X-Proofpoint-ORIG-GUID: c8ux_XYcnOC3Y0ECBTlF8oOPxa_mbxRh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_16,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 27.05.23 17:20, Wen Gu wrote:
> 
> 
> On 2023/5/27 18:22, Wenjia Zhang wrote:
>>
>> I'm wondering if this crash is introduced by the first fix patch you 
>> wrote.
>>
>> Thanks,
>> Wenjia
> 
> Hi Wenjia,
> 
> No, the crash can be reproduced without my two patches by the following 
> steps:
> 
> 1. Each side activates only one RNIC firstly and set the default 
> sndbuf/RMB sizes to more
>     than 16KB, such as 64KB, through sysctl net.smc.{wmem | rmem}.
>     (The reason why initial sndbufs/RMBs size needs to be larger than 
> 16KB will be explained later)
> 
> 2. Use SMCRv2 in any test, just to create a link group that has some 
> alloced RMBs.
> 
>     Example of step #1 #2:
> 
>     [server]
>     smcr ueid add 1234
>     sysctl net.smc.rmem=65536
>     sysctl net.smc.wmem=65536
>     smc_run sockperf sr --tcp
> 
>     [client]
>     smcr ueid add 1234
>     sysctl net.smc.rmem=65536
>     sysctl net.smc.wmem=65536
>     smc_run sockperf pp --tcp -i <server ip> -t <time>
> 
> 
> 3. Change the default sndbuf/RMB sizes, make sure they are larger than 
> initial size above,
>     such as 256KB.
> 
> 4. Then rerun the test, and there will be some bigger RMBs alloced. And 
> when the test is
>     running, activate the second alternate RNIC of each side. It will 
> trigger to add a new
>     link and do what I described in the second patch's commit log, that 
> only map the in-use
>     256KB RMBs to new link but try to access the unused 64KB RMBs' 
> invalid mr[new_link->lnk_idx].
> 
>     Example of step #3 #4:
> 
>     [server]
>     sysctl net.smc.rmem=262144
>     sysctl net.smc.wmem=262144
>     smc_run sockperf sr --tcp
> 
>     [client]
>     sysctl net.smc.rmem=262144
>     sysctl net.smc.wmem=262144
>     smc_run sockperf pp --tcp -i <server ip> -t <time>
> 
>     When the sockperf is running:
> 
>     [server/client]
>     ip link set dev <2nd RNIC> up    # activate the second alternate 
> RNIC, then crash occurs.
> 
> 
> At the beginning, I only found the crash in the second patch. But when I 
> try to fix it,
> I found the issue descibed in the first patch.
> 
> In first patch, if I understand correctly, smc_llc_get_first_rmb() is 
> aimed to get the first
> RMB in lgr->rmb[*]. If so, It should start from lgr->rmbs[0] instead of 
> lgr->rmbs[1], right?
> 
> Then back to the reason needs to be explained in step #1. Because of the 
> issue mentioned
> above in smc_llc_get_first_rmb(), if we set the initial sndbuf/RMB sizes 
> to 16KB, these 16KB
> RMBs (in lgr->rmbs[0]) alloced in step #2 will happen not to be accessed 
> in step #4, so the
> potential crash is hided.
> 
> So, the crash is not introduced by the first fix. Instead, it is the 
> first issue that may hide
> the second issue(crash) in special cases.
> 
> I am a little curious why you think the first fix patch caused the 
> second crash? Is
> something wrong in the first fix patch?
> 
> Thanks for your review!
> 
> Regards,
> Wen Gu

Hi Wen,

Sorry for the late answer because of the public holiday here!

I really like the test scenario, thank you for the elaboration and the 
fixes!
They look good to me.

Why I asked that was that the first patch looked very reasonable, but I 
was wondering why I didn't meet any problem with that before ;-) and if 
it would trigger some problem during processing the SMCRv1 ADD Link 
Continuation Messages. After checking the code again, I don't think 
there would be any problem with the patch, because in the case of 
processing the SMCRv1 ADD Link Continuation Messages, it's about the 
same RMB.

Hi @Paolo, I would appreciate it if you could give us more time to 
review and test the patches. Because we have to make sure that they can 
work on our platform (s390) without problem, not only on x86.

Thanks
Wenjia




