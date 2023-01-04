Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BDD65D7FF
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbjADQKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239851AbjADQJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:09:38 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2038F4084D;
        Wed,  4 Jan 2023 08:09:17 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304FTvR1011327;
        Wed, 4 Jan 2023 16:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yHePGXtwgey/XDqUsj11QCOZvwLZFJ6GwPS6xRCI9g0=;
 b=lANjQd0Oi9nwa4fkTMRQfpvSpvlvVyooLjaDmIrnZKobEigmpIqGICw+/4g2h9yogG21
 MT7s6wIaKlTh1GXthJxys6e0tuUqTsg575yxFu3Zsb1z9pOUr/TFEfldU8DyWlozfFUW
 jGwuNlYS/YS8dfIadMifNXz1jgu2GgYNQwS3kD8YKJlfDwKDDFzJFEI+61rwcbJOrAzq
 64+MMDfdxIYiV1HgSGx0vrEKpultlkHMO3i/nqeSe20al9N/iSpmHFGqYJaoIfjShxQo
 Z6adOklIM2/86Efqn4dgNWXxoG/Un1El3Jd2gMcDwuietsXapWtZdMHe/6Jny6GMgQig 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwc5cgydb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 16:09:10 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 304FdaM1004977;
        Wed, 4 Jan 2023 16:09:10 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwc5cgyc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 16:09:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3041eE9g001601;
        Wed, 4 Jan 2023 16:09:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6c26u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 16:09:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 304G94Ll47120836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 16:09:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91A7020040;
        Wed,  4 Jan 2023 16:09:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE6292004B;
        Wed,  4 Jan 2023 16:09:03 +0000 (GMT)
Received: from [9.171.28.83] (unknown [9.171.28.83])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  4 Jan 2023 16:09:03 +0000 (GMT)
Message-ID: <4c7b0f4d-d57d-0aab-4ddd-6a4f15661e8d@linux.ibm.com>
Date:   Wed, 4 Jan 2023 17:09:03 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH net-next v2 0/5] net/smc:Introduce SMC-D based
 loopback acceleration
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
 <42f2972f1dfe45a2741482f36fbbda5b5a56d8f1.camel@linux.ibm.com>
 <4a9b0ff0-8f03-1bfd-d09c-6deb3a9bb39e@linux.alibaba.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <4a9b0ff0-8f03-1bfd-d09c-6deb3a9bb39e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zYbRG_gYCez2-Y89NI8sKg-oaU0SmjCm
X-Proofpoint-ORIG-GUID: SZHGBUzsnXA-LlfNCpRljKJDziMzbT9R
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 clxscore=1015 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301040133
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,NUMERIC_HTTP_ADDR,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.12.22 14:14, Wen Gu wrote:
> 
> 
> On 2022/12/20 22:02, Niklas Schnelle wrote:
> 
>> On Tue, 2022-12-20 at 11:21 +0800, Wen Gu wrote:
>>> Hi, all
>>>
>>> # Background
>>>
>>> As previously mentioned in [1], we (Alibaba Cloud) are trying to use SMC
>>> to accelerate TCP applications in cloud environment, improving inter-host
>>> or inter-VM communication.
>>>
>>> In addition of these, we also found the value of SMC-D in scenario of local
>>> inter-process communication, such as accelerate communication between containers
>>> within the same host. So this RFC tries to provide a SMC-D loopback solution
>>> in such scenario, to bring a significant improvement in latency and throughput
>>> compared to TCP loopback.
>>>
>>> # Design
>>>
>>> This patch set provides a kind of SMC-D loopback solution.
>>>
>>> Patch #1/5 and #2/5 provide an SMC-D based dummy device, preparing for the
>>> inter-process communication acceleration. Except for loopback acceleration,
>>> the dummy device can also meet the requirements mentioned in [2], which is
>>> providing a way to test SMC-D logic for broad community without ISM device.
>>>
>>>   +------------------------------------------+
>>>   |  +-----------+           +-----------+   |
>>>   |  | process A |           | process B |   |
>>>   |  +-----------+           +-----------+   |
>>>   |       ^                        ^         |
>>>   |       |    +---------------+   |         |
>>>   |       |    |   SMC stack   |   |         |
>>>   |       +--->| +-----------+ |<--|         |
>>>   |            | |   dummy   | |             |
>>>   |            | |   device  | |             |
>>>   |            +-+-----------+-+             |
>>>   |                   VM                     |
>>>   +------------------------------------------+
>>>
>>> Patch #3/5, #4/5, #5/5 provides a way to avoid data copy from sndbuf to RMB
>>> and improve SMC-D loopback performance. Through extending smcd_ops with two
>>> new semantic: attach_dmb and detach_dmb, sender's sndbuf shares the same
>>> physical memory region with receiver's RMB. The data copied from userspace
>>> to sender's sndbuf directly reaches the receiver's RMB without unnecessary
>>> memory copy in the same kernel.
>>>
>>>   +----------+                     +----------+
>>>   | socket A |                     | socket B |
>>>   +----------+                     +----------+
>>>         |                               ^
>>>         |         +---------+           |
>>>    regard as      |         | ----------|
>>>    local sndbuf   |  B's    |     regard as
>>>         |         |  RMB    |     local RMB
>>>         |-------> |         |
>>>                   +---------+
>>
>> Hi Wen Gu,
>>
>> I maintain the s390 specific PCI support in Linux and would like to
>> provide a bit of background on this. You're surely wondering why we
>> even have a copy in there for our ISM virtual PCI device. To understand
>> why this copy operation exists and why we need to keep it working, one
>> needs a bit of s390 aka mainframe background.
>>
>> On s390 all (currently supported) native machines have a mandatory
>> machine level hypervisor. All OSs whether z/OS or Linux run either on
>> this machine level hypervisor as so called Logical Partitions (LPARs)
>> or as second/third/… level guests on e.g. a KVM or z/VM hypervisor that
>> in turn runs in an LPAR. Now, in terms of memory this machine level
>> hypervisor sometimes called PR/SM unlike KVM, z/VM, or VMWare is a
>> partitioning hypervisor without paging. This is one of the main reasons
>> for the very-near-native performance of the machine hypervisor as the
>> memory of its guests acts just like native RAM on other systems. It is
>> never paged out and always accessible to IOMMU translated DMA from
>> devices without the need for pinning pages and besides a trivial
>> offset/limit adjustment an LPAR's MMU does the same amount of work as
>> an MMU on a bare metal x86_64/ARM64 box.
>>
>> It also means however that when SMC-D is used to communicate between
>> LPARs via an ISM device there is  no way of mapping the DMBs to the
>> same physical memory as there exists no MMU-like layer spanning
>> partitions that could do such a mapping. Meanwhile for machine level
>> firmware including the ISM virtual PCI device it is still possible to
>> _copy_ memory between different memory partitions. So yeah while I do
>> see the appeal of skipping the memcpy() for loopback or even between
>> guests of a paging hypervisor such as KVM, which can map the DMBs on
>> the same physical memory, we must keep in mind this original use case
>> requiring a copy operation.
>>
>> Thanks,
>> Niklas
>>
> 
> Hi Niklas,
> 
> Thank you so much for the complete and detailed explanation! This provides
> me a brand new perspective of s390 device that we hadn't dabbled in before.
> Now I understand why shared memory is unavailable between different LPARs.
> 
> Our original intention of proposing loopback device and the incoming device
> (virtio-ism) for inter-VM is to use SMC-D to accelerate communication in the
> case with no existing s390 ISM devices. In our conception, s390 ISM device,
> loopback device and virtio-ism device are parallel and are abstracted by smcd_ops.
> 
>  +------------------------+
>  |          SMC-D         |
>  +------------------------+
>  -------- smcd_ops ---------
>  +------+ +------+ +------+
>  | s390 | | loop | |virtio|
>  | ISM  | | back | | -ism |
>  | dev  | | dev  | | dev  |
>  +------+ +------+ +------+
> 
> We also believe that keeping the existing design and behavior of s390 ISM
> device is unshaken. What we want to get support for is some smcd_ops extension
> for devices with optional beneficial capability, such as nocopy here (Let's call
> it this for now), which is really helpful for us in inter-process and inter-VM
> scenario.
> 
> And coincided with IBM's intention to add APIs between SMC-D and devices to
> support various devices for SMC-D, as mentioned in [2], we send out this RFC and
> the incoming virio-ism RFC, to provide some examples.
> 
>>>
>>> # Benchmark Test
>>>
>>>   * Test environments:
>>>        - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>>>        - SMC sndbuf/RMB size 1MB.
>>>
>>>   * Test object:
>>>        - TCP: run on TCP loopback.
>>>        - domain: run on UNIX domain.
>>>        - SMC lo: run on SMC loopback device with patch #1/5 ~ #2/5.
>>>        - SMC lo-nocpy: run on SMC loopback device with patch #1/5 ~ #5/5.
>>>
>>> 1. ipc-benchmark (see [3])
>>>
>>>   - ./<foo> -c 1000000 -s 100
>>>
>>>                         TCP              domain              SMC-lo             SMC-lo-nocpy
>>> Message
>>> rate (msg/s)         75140      129548(+72.41)    152266(+102.64%)         151914(+102.17%)
>>
>> Interesting that it does beat UNIX domain sockets. Also, see my below
>> comment for nginx/wrk as this seems very similar.
>>
>>>
>>> 2. sockperf
>>>
>>>   - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>>>   - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
>>>
>>>                         TCP                  SMC-lo             SMC-lo-nocpy
>>> Bandwidth(MBps)   4943.359        4936.096(-0.15%)        8239.624(+66.68%)
>>> Latency(us)          6.372          3.359(-47.28%)            3.25(-49.00%)
>>>
>>> 3. iperf3
>>>
>>>   - serv: <smc_run> taskset -c <cpu> iperf3 -s
>>>   - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
>>>
>>>                         TCP                  SMC-lo             SMC-lo-nocpy
>>> Bitrate(Gb/s)         40.5            41.4(+2.22%)            76.4(+88.64%)
>>>
>>> 4. nginx/wrk
>>>
>>>   - serv: <smc_run> nginx
>>>   - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
>>>
>>>                         TCP                  SMC-lo             SMC-lo-nocpy
>>> Requests/s       154643.22      220894.03(+42.84%)        226754.3(+46.63%)
>>
>>
>> This result is very interesting indeed. So with the much more realistic
>> nginx/wrk workload it seems to copy hurts much less than the
>> iperf3/sockperf would suggest while SMC-D itself seems to help more.
>> I'd hope that this translates to actual applications as well. Maybe
>> this makes SMC-D based loopback interesting even while keeping the
>> copy, at least until we can come up with a sane way to work a no-copy
>> variant into SMC-D?
>>
> 
> I agree, nginx/wrk workload is much more realistic for many applications.
> 
> But we also encounter many other cases similar to sockperf on the cloud, which
> requires high throughput, such as AI training and big data.
> 
> So avoidance of copying between DMBs can help these cases a lot :)
> 
>>>
>>>
>>> # Discussion
>>>
>>> 1. API between SMC-D and ISM device
>>>
>>> As Jan mentioned in [2], IBM are working on placing an API between SMC-D
>>> and the ISM device for easier use of different "devices" for SMC-D.
>>>
>>> So, considering that the introduction of attach_dmb or detach_dmb can
>>> effectively avoid data copying from sndbuf to RMB and brings obvious
>>> throughput advantages in inter-VM or inter-process scenarios, can the
>>> attach/detach semantics be taken into consideration when designing the
>>> API to make it a standard ISM device behavior?
>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> Due to the reasons explained above this behavior can't be emulated by
>> ISM devices at least not when crossing partitions. Not sure if we can
>> still incorporate it in the API and allow for both copying and
>> remapping SMC-D like devices, it definitely needs careful consideration
>> and I think also a better understanding of the benefit for real world
>> workloads.
>>
> 
> Here I am not rigorous.
> 
> Nocopy shouldn't be a standard ISM device behavior indeed. Actually we hope it be a
> standard optional _SMC-D_ device behavior and defined by smcd_ops.
> 
> For devices don't support these options, like ISM device on s390 architecture,
> .attach_dmb/.detach_dmb and other reasonable extensions (which will be proposed to
> discuss in incoming virtio-ism RFC) can be set to NULL or return invalid. And for
> devices do support, they may be used for improving performance in some cases.
> 
> In addition, can I know more latest news about the API design? :) , like its scale, will
> it be a almost refactor of existing interface or incremental patching? and its object,
> will it be tailored for exact ISM behavior or to reserve some options for other devices,
> like nocopy here? From my understanding of [2], it might be the latter?
> 
>>>
>>> Maybe our RFC of SMC-D based inter-process acceleration (this one) and
>>> inter-VM acceleration (will coming soon, which is the update of [1])
>>> can provide some examples for new API design. And we are very glad to
>>> discuss this on the mail list.
>>>
>>> 2. Way to select different ISM-like devices
>>>
>>> With the proposal of SMC-D loopback 'device' (this RFC) and incoming
>>> device used for inter-VM acceleration as update of [1], SMC-D has more
>>> options to choose from. So we need to consider that how to indicate
>>> supported devices, how to determine which one to use, and their priority...
>>
>> Agree on this part, though it is for the SMC maintainers to decide, I
>> think we would definitely want to be able to use any upcoming inter-VM
>> devices on s390 possibly also in conjunction with ISM devices for
>> communication across partitions.
>>
> 
> Yes, this part needs to be discussed with SMC maintainers. And thank you, we are very glad
> if our devices can be applied on s390 through the efforts.
> 
> 
> Best Regards,
> Wen Gu
> 
>>>
>>> IMHO, this may require an update of CLC message and negotiation mechanism.
>>> Again, we are very glad to discuss this with you on the mailing list.

As described in 
SMC protocol (including SMC-D): https://www.ibm.com/support/pages/system/files/inline-files/IBM%20Shared%20Memory%20Communications%20Version%202_2.pdf
the CLC messages provide a list of up to 8 ISM devices to chose from.
So I would hope that we can use the existing protocol.

The challenge will be to define GID (Global Interface ID) and CHID (a fabric ID) in
a meaningful way for the new devices.
There is always smcd_ops->query_remote_gid()  as a safety net. But the idea is that
a CHID mismatch is a fast way to tell that these 2 interfaces do match. 


>>>
>>> [1] https://lore.kernel.org/netdev/20220720170048.20806-1-tonylu@linux.alibaba.com/
>>> [2] https://lore.kernel.org/netdev/35d14144-28f7-6129-d6d3-ba16dae7a646@linux.ibm.com/
>>> [3] https://github.com/goldsborough/ipc-bench
>>>
>>> v1->v2
>>>   1. Fix some build WARNINGs complained by kernel test rebot
>>>      Reported-by: kernel test robot <lkp@intel.com>
>>>   2. Add iperf3 test data.
>>>
>>> Wen Gu (5):
>>>    net/smc: introduce SMC-D loopback device
>>>    net/smc: choose loopback device in SMC-D communication
>>>    net/smc: add dmb attach and detach interface
>>>    net/smc: avoid data copy from sndbuf to peer RMB in SMC-D loopback
>>>    net/smc: logic of cursors update in SMC-D loopback connections
>>>
>>>   include/net/smc.h      |   3 +
>>>   net/smc/Makefile       |   2 +-
>>>   net/smc/af_smc.c       |  88 +++++++++++-
>>>   net/smc/smc_cdc.c      |  59 ++++++--
>>>   net/smc/smc_cdc.h      |   1 +
>>>   net/smc/smc_clc.c      |   4 +-
>>>   net/smc/smc_core.c     |  62 +++++++++
>>>   net/smc/smc_core.h     |   2 +
>>>   net/smc/smc_ism.c      |  39 +++++-
>>>   net/smc/smc_ism.h      |   2 +
>>>   net/smc/smc_loopback.c | 358 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>   net/smc/smc_loopback.h |  63 +++++++++
>>>   12 files changed, 662 insertions(+), 21 deletions(-)
>>>   create mode 100644 net/smc/smc_loopback.c
>>>   create mode 100644 net/smc/smc_loopback.h
>>>
