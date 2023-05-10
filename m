Return-Path: <netdev+bounces-1410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 776EC6FDB2B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E3D01C20CE6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418746FAF;
	Wed, 10 May 2023 09:57:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303AD20B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:57:11 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE25D1BCF;
	Wed, 10 May 2023 02:57:06 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A9hCA4018848;
	Wed, 10 May 2023 09:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=idPp3eq40YwJK7JPGUQLzwoJdOzPG86DCR4GRegFkW8=;
 b=apGtPYMpt50EOuMWT0J1Xe3CR32nmgCY5qiKhKlS38ei1jmUvTi5KUEfFY0zuUN8qHX2
 JyR7bOAWae9v+TaTJfJvPXERujsP56mFdmSLrpAUczW+9yL82G/bKNChveEqxmJQyoGd
 Wr9JXVCC17Ieh1BnygWY1JqBv7Edh3cSg6+czNUcNv7Y4n2WqRWzWEvmoHZRva4Kd41K
 0q9HHZ2FT3fDAXp9GvaseCALgcgX3tmfmdXEJWqzL98JPC4yk1BuOjynz9Uj5OZ0A1fH
 nDGQQsJmiZ1/o24IFpkYSfDI8fGJZGdb9ocQCrbM94os1lXKhzuDTmy9ScW2BHSXe2M6 sA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg7uct2sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 09:57:02 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A9tFrB026159;
	Wed, 10 May 2023 09:57:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg7uct2re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 09:57:01 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A0aEcv015736;
	Wed, 10 May 2023 09:56:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896ryhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 09:56:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A9uuWx10551810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 09:56:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AB2320040;
	Wed, 10 May 2023 09:56:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 745D120043;
	Wed, 10 May 2023 09:56:55 +0000 (GMT)
Received: from [9.171.72.106] (unknown [9.171.72.106])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 May 2023 09:56:55 +0000 (GMT)
Message-ID: <347c15c2-c18d-4823-3177-abaeb394c772@linux.ibm.com>
Date: Wed, 10 May 2023 11:56:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [RFC PATCH net-next v5 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
To: Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>
References: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
 <1297b2c6-00c2-adc9-3abe-af12471e2838@linux.alibaba.com>
From: Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <1297b2c6-00c2-adc9-3abe-af12471e2838@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MVtf6PNfQEwOT0Pg_RIYVkfvvaMBB0yo
X-Proofpoint-ORIG-GUID: nPFC4hDDGo1liukC80TCVBGOzEAA_B7u
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0
 clxscore=1011 adultscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305100074
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,NUMERIC_HTTP_ADDR,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10/05/2023 04:02, Wen Gu wrote:
> Hi Wenjia & Jan:
> 
> Does this version work fine on your platform?
> 
> And any comments on this version? :)

Hi Wen Gu,

as background for the others: IBM & Alibaba are having calls regarding 
SMC since Alibaba shows a lot of interest and there is a lot to discuss 
(as you may have noticed).

As we have agreed in our calls, the information shared about SMC-D in 
specific doesn't make it easy to understand the underlying concepts 
(e.g. role of GID, EIDs, DMB tokens, etc.).
That's why one of the next calls is dedicated to explain some of the 
concepts in depth to you and see where we can improve our flow of 
information to the community in the future.
After that we can go over this RFC with a shared understanding of the 
concepts.

Thank you
- Jan


> 
> 
> Best regards,
> Wen Gu
> 
> 
> On 2023/4/23 20:17, Wen Gu wrote:
> 
>> Hi, all
>>
>> # Background
>>
>> The background and previous discussion can be referred from [1]~[3].
>>
>> We found SMC-D can be used to accelerate OS internal communication, 
>> such as
>> loopback or between two containers within the same OS instance. So 
>> this patch
>> set provides a kind of SMC-D dummy device (we call it the SMC-D 
>> loopback device)
>> to emulate an ISM device, so that SMC-D can also be used on architectures
>> other than s390. The SMC-D loopback device are designed as a system 
>> global
>> device, visible to all containers.
>>
>> # Design
>>
>> This patch set basically follows the design of the previous version.
>>
>> Patch #1/9 ~ #3/9 attempt to decouple ISM-related structures from the 
>> SMC-D
>> generalized code and extract some helpers to make SMC-D protocol 
>> compatible
>> with devices other than s390 ISM device.
>>
>> Patch #4/9 introduces a kind of loopback device, which is defined as 
>> SMC-Dv2
>> device and designed to provide communication between SMC sockets on 
>> the same
>> OS instance.
>>
>>   +-------------------------------------------+
>>   |  +--------------+       +--------------+  |
>>   |  | SMC socket A |       | SMC socket B |  |
>>   |  +--------------+       +--------------+  |
>>   |       ^                         ^         |
>>   |       |    +----------------+   |         |
>>   |       |    |   SMC stack    |   |         |
>>   |       +--->| +------------+ |<--|         |
>>   |            | |   dummy    | |             |
>>   |            | |   device   | |             |
>>   |            +-+------------+-+             |
>>   |                   OS                      |
>>   +-------------------------------------------+
>>
>> Patch #5/9 ~ #8/9 expand SMC-D protocol interface (smcd_ops) for 
>> scenarios where
>> SMC-D is used to communicate within VM (loopback here) or between VMs 
>> on the same
>> host (based on virtio-ism device, see [4]). What these scenarios have 
>> in common
>> is that the local sndbuf and peer RMB can be mapped to same physical 
>> memory region,
>> so the data copy between the local sndbuf and peer RMB can be omitted. 
>> Performance
>> improvement brought by this extension can be found in # Benchmark Test.
>>
>>   +----------+                     +----------+
>>   | socket A |                     | socket B |
>>   +----------+                     +----------+
>>         |                               ^
>>         |         +---------+           |
>>    regard as      |         | ----------|
>>    local sndbuf   |  B's    |     regard as
>>         |         |  RMB    |     local RMB
>>         |-------> |         |
>>                   +---------+
>>
>> Patch #9/9 realizes the support of loopback device for the 
>> above-mentioned expanded
>> SMC-D protocol interface.
>>
>> # Benchmark Test
>>
>>   * Test environments:
>>        - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>>        - SMC sndbuf/RMB size 1MB.
>>
>>   * Test object:
>>        - TCP lo: run on TCP loopback.
>>        - domain: run on UNIX domain.
>>        - SMC lo: run on SMC loopback device with patch #1/9 ~ #4/9.
>>        - SMC lo-nocpy: run on SMC loopback device with patch #1/9 ~ #9/9.
>>
>> 1. ipc-benchmark (see [5])
>>
>>   - ./<foo> -c 1000000 -s 100
>>
>>                      TCP-lo              domain              
>> SMC-lo          SMC-lo-nocpy
>> Message
>> rate (msg/s)         79025      115736(+46.45%)    
>> 146760(+85.71%)       149800(+89.56%)
>>
>> 2. sockperf
>>
>>   - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>>   - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp 
>> --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
>>
>>                      TCP-lo                  SMC-lo             
>> SMC-lo-nocpy
>> Bandwidth(MBps)   4822.388        4940.918(+2.56%)         
>> 8086.67(+67.69%)
>> Latency(us)          6.298          3.352(-46.78%)            
>> 3.35(-46.81%)
>>
>> 3. iperf3
>>
>>   - serv: <smc_run> taskset -c <cpu> iperf3 -s
>>   - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
>>
>>                      TCP-lo                  SMC-lo             
>> SMC-lo-nocpy
>> Bitrate(Gb/s)         40.7            40.5(-0.49%)            
>> 72.4(+77.89%)
>>
>> 4. nginx/wrk
>>
>>   - serv: <smc_run> nginx
>>   - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
>>
>>                      TCP-lo                  SMC-lo             
>> SMC-lo-nocpy
>> Requests/s       155994.57      214544.79(+37.53%)       
>> 215538.55(+38.17%)
>>
>>
>> v5->v4
>>   1. The loopback device generates SEID in the same way as the ISM 
>> devices when coexisting
>>      with ISM devices and uses a default fixed SEID in other cases.
>>   2. Ensure each DMB token of the same loopback device is unique.
>>   3. Fixe a crash caused by setting smcd_ops->signal_event interface 
>> to NULL.
>>   4. Fixe a compilation warning complained by kernel test rebot.
>>
>> v4->v3
>>   1. Rebase to the latest net-next;
>>   2. Introduce SEID helper. SMC-D loopback will return 
>> SMCD_DEFAULT_V2_SEID. And if it
>>      coexist with ISM device, the SEID of ISM device will overwrite 
>> SMCD_DEFAULT_V2_SEID
>>      as smc_ism_v2_system_eid.
>>   3. Won't remove dmb_node from hashtable until no sndbuf attaching to 
>> it.
>>
>>   Something postponed in this version
>>   1. Hierarchy perference of SMC-D devices when loopback and ISM 
>> devices coexist, which
>>      will be determinated after comparing the performance of loopback 
>> and ISM.
>>
>> v3->v2
>>   1. Adapt new generalized interface provided by [2];
>>   2. Select loopback device through SMC-D v2 protocol;
>>   3. Split the loopback-related implementation and generic 
>> implementation into different
>>      patches more reasonably.
>>
>> v1->v2
>>   1. Fix some build WARNINGs complained by kernel test rebot
>>      Reported-by: kernel test robot <lkp@intel.com>
>>   2. Add iperf3 test data.
>>
>>
>> [1] 
>> https://lore.kernel.org/netdev/1671506505-104676-1-git-send-email-guwen@linux.alibaba.com/
>> [2] 
>> https://lore.kernel.org/netdev/1676477905-88043-1-git-send-email-guwen@linux.alibaba.com/
>> [3] 
>> https://lore.kernel.org/netdev/1679887699-54797-1-git-send-email-guwen@linux.alibaba.com/
>> [4] 
>> https://lore.kernel.org/all/20230209033056.96657-1-xuanzhuo@linux.alibaba.com/
>> [5] https://github.com/goldsborough/ipc-bench
>>
>>
>>
>> Wen Gu (9):
>>    net/smc: Decouple ism_dev from SMC-D device dump
>>    net/smc: Decouple ism_dev from SMC-D DMB registration
>>    net/smc: Extract v2 check helper from SMC-D device registration
>>    net/smc: Introduce SMC-D loopback device
>>    net/smc: Introduce an interface for getting DMB attribute
>>    net/smc: Introudce interfaces for DMB attach and detach
>>    net/smc: Avoid data copy from sndbuf to peer RMB in SMC-D
>>    net/smc: Modify cursor update logic when using mappable DMB
>>    net/smc: Add interface implementation of loopback device
>>
>>   drivers/s390/net/ism_drv.c |   5 +-
>>   include/net/smc.h          |  18 +-
>>   net/smc/Makefile           |   2 +-
>>   net/smc/af_smc.c           |  26 ++-
>>   net/smc/smc_cdc.c          |  59 ++++--
>>   net/smc/smc_cdc.h          |   1 +
>>   net/smc/smc_core.c         |  70 ++++++-
>>   net/smc/smc_core.h         |   1 +
>>   net/smc/smc_ism.c          |  79 ++++++--
>>   net/smc/smc_ism.h          |   6 +
>>   net/smc/smc_loopback.c     | 491 
>> +++++++++++++++++++++++++++++++++++++++++++++
>>   net/smc/smc_loopback.h     |  56 ++++++
>>   12 files changed, 777 insertions(+), 37 deletions(-)
>>   create mode 100644 net/smc/smc_loopback.c
>>   create mode 100644 net/smc/smc_loopback.h
>>

