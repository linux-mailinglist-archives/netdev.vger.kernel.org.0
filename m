Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E886169F517
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 14:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjBVNI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 08:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjBVNI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 08:08:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D262005C;
        Wed, 22 Feb 2023 05:08:24 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MCdhuF007147;
        Wed, 22 Feb 2023 13:08:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KUCHdQ10OuAnV3jMXM0raioOvgK0W0Crzhl/sFF96wg=;
 b=dSW/tNVXmtVMHmDrIyHAgS1ECyu3IqIPZXf71W0hhJaEyKPEfRK4FzkuYkXakKxEmjWc
 Sh0dA65MKwCbfJw0oAq7Q5r48p8Oc93PzLk+x5i68S+lCCTPmtk2Q119L5JKgPHZDTNb
 qyy7cTZ7vD6IN9zXzk9y5wJffek61fFWNXmqqy4qNhh0xFy2FayW4nE5fmQ5F48c+dFC
 bBlYMk2T4sQHVYoU5UU1huU/JZah635ISjDXX9xfXKTsxOjjmpWPqertZsvPZsKiwRYt
 oKmW9eRZMIQQz7vlMh6lBaWgLp0XdhxRYtjVJD5ZaFfyHK7TqMSWavwmgCRymCK9TNO7 uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwj6cte5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 13:08:19 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MD36bH018911;
        Wed, 22 Feb 2023 13:08:18 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwj6cte2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 13:08:18 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31MAP4Xi000556;
        Wed, 22 Feb 2023 13:08:12 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3ntpa7ecnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 13:08:12 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MD8Ai666650456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 13:08:10 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E37755805D;
        Wed, 22 Feb 2023 13:08:09 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37F4858058;
        Wed, 22 Feb 2023 13:08:08 +0000 (GMT)
Received: from [9.211.152.15] (unknown [9.211.152.15])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 13:08:08 +0000 (GMT)
Message-ID: <fbfdc4d0-7b66-efcb-b84d-d675fb484527@linux.ibm.com>
Date:   Wed, 22 Feb 2023 14:08:07 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC PATCH net-next v3 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexandra Winter <WINTERA@de.ibm.com>
References: <1676477905-88043-1-git-send-email-guwen@linux.alibaba.com>
 <06f1d098-724c-80ba-7efc-b9569593f1e6@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <06f1d098-724c-80ba-7efc-b9569593f1e6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rkMJ65xkhgvGLw9eFSCEjTQkIyKr1SL0
X-Proofpoint-ORIG-GUID: j8y_LF9n0n54AQlal9dyCKFHIvAD0xoc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 5 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 clxscore=1015 adultscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220115
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.02.23 13:00, Wen Gu wrote:
> 
> 
> On 2023/2/16 00:18, Wen Gu wrote:
> 
>> Hi, all
>>
>> # Background
>>
>> The background and previous discussion can be referred from [1].
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
>> This version is implemented based on the generalized interface 
>> provided by [2].
>> And there is an open issue of this version, which will be mentioned 
>> later.
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
>> SMC-D v2
>> device and designed to provide communication between SMC sockets in 
>> the same OS
>> instance.
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
>> host (based on virtio-ism device, see [3]). What these scenarios have 
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
>> 1. ipc-benchmark (see [4])
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
>> # Open issue
>>
>> The open issue has not been resolved now is about how to detect that 
>> the source
>> and target of CLC proposal are within the same OS instance and can 
>> communicate
>> through the SMC-D loopback device. Similar issue also exists when 
>> using virtio-ism
>> devices (the background and details of virtio-ism device can be 
>> referred from [3]).
>> In previous discussions, multiple options were proposed (see [5]). 
>> Thanks again for
>> the help of the community. cc Alexandra Winter :)
>>
>> But as we discussed, these solutions have some imperfection. So this 
>> version of RFC
>> continues to use previous workaround, that is, a 64-bit random GID is 
>> generated for
>> SMC-D loopback device. If the GIDs of the devices found by two peers 
>> are the same,
>> then they are considered to be in the same OS instance and can 
>> communicate with each
>> other by the loopback device.
>>
>> This approach has very small risk. Assume the following situations:
>>
>> (1) Assume that the SMC-D loopback devices of the two OS instances 
>> happen to
>>      generate the same 64-bit GID.
>>
>>      For the convenience of description, we refer to the sockets on 
>> these two
>>      different OS instance as server A and client B.
>>
>>      A will misjudge that the two are on the same OS instance because 
>> the same GID
>>      in CLC proposal message. Then A creates its RMB and sends 64-bit 
>> token-A to B
>>      in CLC accept message.
>>
>>      B receives the CLC accept message. And according to patch #7/9, B 
>> tries to
>>      attach its sndbuf to A's RMB by token-A.
>>
>> (2) Assume that the OS instance where B is located happens to have an 
>> unattached
>>      RMB whose 64-bit token is same as token-A.
>>
>>      Then B successfully attaches its sndbuf to the wrong RMB, and 
>> creates its RMB,
>>      sends token-B to A in CLC confirm message.
>>
>>      Similarly, A receives the message and tries to attach its sndbuf 
>> to B's RMB by
>>      token-B.
>>
>> (3) Similar to (2), assume that the OS instance where A is located 
>> happens to have
>>      an unattached RMB whose 64-bit token is same as token-B.
>>
>>      Then A successfully attach its sndbuf to the wrong RMB. Both 
>> sides mistakenly
>>      believe that an SMC-D connection based on the loopback device is 
>> established
>>      between them.
>>
>> If the above 3 coincidences all happen, that is, 64-bit random number 
>> conflicts occur
>> 3 times, then an unreachable SMC-D connection will be established, 
>> which is nasty.
>> If one of above is not satisfied, it will safely fallback to TCP.
>>
>> Since the chances of these happening are very small, I wonder if this 
>> risk of 1/2^(64*3)
>> probability can be tolerated ?
> 
> Hi,
> 
> Any comments about this open issue or other parts of this RFC patch set? :)
> 
> Thanks,
> Wen Gu
> 
Hi Wen,

I don't forget it ;) I'm trying to run it by myself. Please give us more 
time for the trying and review.

Thanks
Wenjia

>> Another way to solve this open issue is using a 128-bit UUID to 
>> identify SMC-D loopback
>> device or virtio-ism device, because the probability of a 128-bit UUID 
>> collision is
>> considered negligible. But it may need to extend the CLC message to 
>> carry a longer GID,
>> which is the last option.
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
>> [1] 
>> https://lore.kernel.org/netdev/1671506505-104676-1-git-send-email-guwen@linux.alibaba.com/
>> [2] 
>> https://lore.kernel.org/netdev/20230123181752.1068-1-jaka@linux.ibm.com/
>> [3] 
>> https://lists.oasis-open.org/archives/virtio-comment/202302/msg00148.html
>> [4] https://github.com/goldsborough/ipc-bench
>> [5] 
>> https://lore.kernel.org/netdev/b9867c7d-bb2b-16fc-feda-b79579aa833d@linux.ibm.com/
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
>>   net/smc/smc_ism.h          |   4 +
>>   net/smc/smc_loopback.c     | 442 
>> +++++++++++++++++++++++++++++++++++++++++++++
>>   net/smc/smc_loopback.h     |  55 ++++++
>>   12 files changed, 725 insertions(+), 37 deletions(-)
>>   create mode 100644 net/smc/smc_loopback.c
>>   create mode 100644 net/smc/smc_loopback.h
>>
