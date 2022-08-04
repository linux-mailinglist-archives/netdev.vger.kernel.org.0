Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E965899ED
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiHDJ1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiHDJ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:27:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050696715B;
        Thu,  4 Aug 2022 02:27:48 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2749DTPH006190;
        Thu, 4 Aug 2022 09:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=eWjNRNkVG05GCfIsUzSfYLwRV4Tn0hAqepKwu/d5fp0=;
 b=JkSk4mCGRco6d5F+sNMQYfi6DuKe1rIz0PP07GQ4739xEnkqRPV0b+s0LCWsFiRquJ2y
 oPAvge9/8VQA8OGkVWzTTmqZbCduaAp/O1H6a+Tef3Nb+PA+lcZY60LvGxSStqkb5mT1
 67MIk6ZaXhdDBIoIhQPzE+IRj8IETl1Ne5grpnQfGbXytUtKYfwvtbGUSWLM4chnHfak
 cRAOHzNlCmPjeGfnEjPG3B0NHZ0D1nw0eL67lw1qRkfcG8OsxotQkWqnBcxn1YrsG1uk
 wQPFmVA4GWXFcs9dv5dJkMC/bGQaJ3Q0tNZ3M8LAC5zwtoPWY39OT5klV4qG/QPLGCgR YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrb9m0cau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 09:27:42 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2749DkSd006567;
        Thu, 4 Aug 2022 09:27:41 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrb9m0c9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 09:27:41 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2749M5f0004937;
        Thu, 4 Aug 2022 09:27:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3hmuwht4yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 09:27:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2749RaVu26345922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Aug 2022 09:27:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 602424C040;
        Thu,  4 Aug 2022 09:27:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1C974C044;
        Thu,  4 Aug 2022 09:27:35 +0000 (GMT)
Received: from [9.152.224.235] (unknown [9.152.224.235])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Aug 2022 09:27:35 +0000 (GMT)
Message-ID: <85ee3db7-a755-d527-026e-d59c72a60010@linux.ibm.com>
Date:   Thu, 4 Aug 2022 11:27:35 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [RFC net-next 1/1] net/smc: SMC for inter-VM communication
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, zmlcc@linux.alibaba.com,
        hans@linux.alibaba.com, zhiyuan2048@linux.alibaba.com,
        herongguang@linux.alibaba.com
References: <20220720170048.20806-1-tonylu@linux.alibaba.com>
 <0ccf9cc6-4916-7815-9ce2-990dc7884849@linux.ibm.com>
 <20220803164119.5955b442@hermes.local>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220803164119.5955b442@hermes.local>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QZSvypFkIWoOCbnmXeKBYezwlIgouEjn
X-Proofpoint-ORIG-GUID: 2MeOYDQLsQqx7FG1hH6Nms9u7oySqAcM
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,WEIRD_QUOTING autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.08.22 01:41, Stephen Hemminger wrote:
> On Wed, 3 Aug 2022 16:27:54 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 7/20/22 1:00 PM, Tony Lu wrote:
>>> Hi all,
>>>
>>> # Background
>>>
>>> We (Alibaba Cloud) have already used SMC in cloud environment to
>>> transparently accelerate TCP applications with ERDMA [1]. Nowadays,
>>> there is a common scenario that deploy containers (which runtime is
>>> based on lightweight virtual machine) on ECS (Elastic Compute Service),
>>> and the containers may want to be scheduled on the same host in order to
>>> get higher performance of network, such as AI, big data or other
>>> scenarios that are sensitive with bandwidth and latency. Currently, the
>>> performance of inter-VM is poor and CPU resource is wasted (see
>>> #Benchmark virtio). This scenario has been discussed many times, but a
>>> solution for a common scenario for applications is missing [2] [3] [4].
>>>
>>> # Design
>>>
>>> In inter-VM scenario, we use ivshmem (Inter-VM shared memory device)
>>> which is modeled by QEMU [5]. With it, multiple VMs can access one
>>> shared memory. This shared memory device is statically created by host
>>> and shared to desired guests. The device exposes as a PCI BAR, and can
>>> interrupt its peers (ivshmem-doorbell).
>>>
>>> In order to use ivshmem in SMC, we write a draft device driver as a
>>> bridge between SMC and ivshmem PCI device. To make it easier, this
>>> driver acts like a SMC-D device in order to fit in SMC without modifying
>>> the code, which is named ivpci (see patch #1).
>>>
>>>    ┌───────────────────────────────────────┐
>>>    │  ┌───────────────┐ ┌───────────────┐  │
>>>    │  │      VM1      │ │      VM2      │  │
>>>    │  │┌─────────────┐│ │┌─────────────┐│  │
>>>    │  ││ Application ││ ││ Application ││  │
>>>    │  │├─────────────┤│ │├─────────────┤│  │
>>>    │  ││     SMC     ││ ││     SMC     ││  │
>>>    │  │├─────────────┤│ │├─────────────┤│  │
>>>    │  ││    ivpci    ││ ││    ivpci    ││  │
>>>    │  └└─────────────┘┘ └└─────────────┘┘  │
>>>    │        x  *               x  *        │
>>>    │        x  ****************x* *        │
>>>    │        x  xxxxxxxxxxxxxxxxx* *        │
>>>    │        x  x                * *        │
>>>    │  ┌───────────────┐ ┌───────────────┐  │
>>>    │  │shared memories│ │ivshmem-server │  │
>>>    │  └───────────────┘ └───────────────┘  │
>>>    │                HOST A                 │
>>>    └───────────────────────────────────────┘
>>>     *********** Control flow (interrupt)
>>>     xxxxxxxxxxx Data flow (memory access)
>>>
>>> Inside ivpci driver, it implements almost all the operations of SMC-D
>>> device. It can be divided into two parts:
>>>
>>> - control flow, most of it is same with SMC-D, use ivshmem trigger
>>>    interruptions in ivpci and process CDC flow.
>>>
>>> - data flow, the shared memory of each connection is one large region
>>>    and divided into two part for local and remote RMB. Every writer
>>>    syscall copies data to sndbuf and calls ISM's move_data() to move data
>>>    to remote RMB in ivshmem and interrupt remote. And reader then
>>>    receives interruption and check CDC message, consume data if cursor is
>>>    updated.
>>>
>>> # Benchmark
>>>
>>> Current POC of ivpci is unstable and only works for single SMC
>>> connection. Here is the brief data:
>>>
>>> Items         Latency (pingpong)    Throughput (64KB)
>>> TCP (virtio)   19.3 us                3794.185 MBps
>>> TCP (SR-IOV)   13.2 us                3948.792 MBps
>>> SMC (ivshmem)   6.3 us               11900.269 MBps
>>>
>>> Test environments:
>>>
>>> - CPU Intel Xeon Platinum 8 core, mem 32 GiB
>>> - NIC Mellanox CX4 with 2 VFs in two different guests
>>> - using virsh to setup virtio-net + vhost
>>> - using sockperf and single connection
>>> - SMC + ivshmem throughput uses one-copy (userspace -> kernel copy)
>>>    with intrusive modification of SMC (see patch #1), latency (pingpong)
>>>    use two-copy (user -> kernel and move_data() copy, patch version).
>>>
>>> With the comparison, SMC with ivshmem gets 3-4x bandwidth and a half
>>> latency.
>>>
>>> TCP + virtio is the most usage solution for guest, it gains lower
>>> performance. Moreover, it consumes extra thread with full CPU core
>>> occupied in host to transfer data, wastes more CPU resource. If the host
>>> is very busy, the performance will be worse.
>>>   
>>
>> Hi Tony,
>>
>> Quite interesting!  FWIW for s390x we are also looking at passthrough of 
>> host ISM devices to enable SMC-D in QEMU guests:
>> https://lore.kernel.org/kvm/20220606203325.110625-1-mjrosato@linux.ibm.com/
>> https://lore.kernel.org/kvm/20220606203614.110928-1-mjrosato@linux.ibm.com/
>>
>> But seems to me an 'emulated ISM' of sorts could still be interesting 
>> even on s390x e.g. for scenarios where host device passthrough is not 
>> possible/desired.
>>
>> Out of curiosity I tried this ivpci module on s390x but the device won't 
>> probe -- This is possibly an issue with the s390x PCI emulation layer in 
>> QEMU, I'll have to look into that.
>>
>>> # Discussion
>>>
>>> This RFC and solution is still in early stage, so we want to come it up
>>> as soon as possible and fully discuss with IBM and community. We have
>>> some topics putting on the table:
>>>
>>> 1. SMC officially supports this scenario.
>>>
>>> SMC + ivshmem shows huge improvement when communicating inter VMs. SMC-D
>>> and mocking ISM device might not be the official solution, maybe another
>>> extension for SMC besides SMC-R and SMC-D. So we are wondering if SMC
>>> would accept this idea to fix this scenario? Are there any other
>>> possibilities?  
>>
>> I am curious about ivshmem and its current state though -- e.g. looking 
>> around I see mention of v2 which you also referenced but don't see any 
>> activity on it for a few years?  And as far as v1 ivshmem -- server "not 
>> for production use", etc.
>>
>> Thanks,
>> Matt
>>
>>>
>>> 2. Implementation of SMC for inter-VM.
>>>
>>> SMC is used in container and cloud environment, maybe we can propose a
>>> new device and new protocol if possible in these new scenarios to solve
>>> this problem.
>>>
>>> 3. Standardize this new protocol and device.
>>>
>>> SMC-R has an open RFC 7609, so can this new device or protocol like
>>> SMC-D can be standardized. There is a possible option that proposing a
>>> new device model in QEMU + virtio ecosystem and SMC supports this
>>> standard virtio device, like [6].
>>>
>>> If there are any problems, please point them out.
>>>
>>> Hope to hear from you, thank you.
>>>
>>> [1] https://lwn.net/Articles/879373/
>>> [2] https://projectacrn.github.io/latest/tutorials/enable_ivshmem.html
>>> [3] https://dl.acm.org/doi/10.1145/2847562
>>> [4] https://hal.archives-ouvertes.fr/hal-00368622/document
>>> [5] https://github.com/qemu/qemu/blob/master/docs/specs/ivshmem-spec.txt
>>> [6] https://github.com/siemens/jailhouse/blob/master/Documentation/ivshmem-v2-specification.md
>>>
>>> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>  
> 
> 
> Also looks a lot like existing VSOCK which has transports for Virtio, HyperV and VMWare already.

To have it documented in this thread:
As Wenjia Zhang <wenjia@linux.ibm.com> mentioned in
https://lore.kernel.org/netdev/Yt9Xfv0bN0AGMdGP@TonyMac-Alibaba/t/#mcfaa50f7142f923d2b570dc19b70c73ceddc1270
we are working on some patches to cleanup the interface between the ism device driver and the SMC-D protocol
layer. They may simplify a project like the one described in this RFC. Stay tuned.
