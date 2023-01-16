Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C766BC5E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjAPLCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjAPLCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:02:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C191C311;
        Mon, 16 Jan 2023 03:01:27 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GAZknB022818;
        Mon, 16 Jan 2023 11:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3QMDyJ88SGzHaVcUolDf3jWoJy0kBaDQI8PuPw7c7Ys=;
 b=mv98FpUH8DkesMqSHYfibDItyDdIkhmPimeSnInHeGh8dbb+mxsXMt55J4PxV61MwZoR
 bCVbCnOHfxtWag96aNNWH9DiF2A/oeWi5IfoOL215t/oo+6HypnrvkW5C4vF5IIPHxGi
 C8+IR58FuXQUpaeXnuuPtW6+AGslsPqBQXIW0JorYLrMqpMBjp6o7nQU9HHU5DU9H4Ix
 LrYx3MUWkhkQGqS6qO7tjK7HkJsJragPBNfeJsIqy3IB/fAY//y80qgNaTbvnpUH0+nw
 +gLfw4WK/EIjF0p2RK7w2D9PLX1jMPykJJ7iXEmPC1AfkT4WpOudDyHjr4OvJetD9PmD rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n4g07wfs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 11:01:19 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GAxR7c005861;
        Mon, 16 Jan 2023 11:01:19 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n4g07wfrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 11:01:18 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30G9SsWi013744;
        Mon, 16 Jan 2023 11:01:18 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3n3m16prr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 11:01:18 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GB1GUZ35521182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 11:01:16 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 788E3580A7;
        Mon, 16 Jan 2023 11:01:16 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1546E580AB;
        Mon, 16 Jan 2023 11:01:14 +0000 (GMT)
Received: from [9.211.83.196] (unknown [9.211.83.196])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 11:01:13 +0000 (GMT)
Message-ID: <bc4e55b9-ac35-3c71-104e-862fec958403@linux.ibm.com>
Date:   Mon, 16 Jan 2023 12:01:13 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH net-next v2 0/5] net/smc:Introduce SMC-D based
 loopback acceleration
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
 <42f2972f1dfe45a2741482f36fbbda5b5a56d8f1.camel@linux.ibm.com>
 <4a9b0ff0-8f03-1bfd-d09c-6deb3a9bb39e@linux.alibaba.com>
 <4c7b0f4d-d57d-0aab-4ddd-6a4f15661e8d@linux.ibm.com>
 <b25f56de-7913-2a56-950f-dfe0defd6936@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <b25f56de-7913-2a56-950f-dfe0defd6936@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VIj83aTJZkmHpr21woKmrIbdRU7M-NuE
X-Proofpoint-GUID: j2eVEU2tEvDM7I_S2d0LTsNkTkyz2_ph
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_08,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301160078
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,NUMERIC_HTTP_ADDR,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.01.23 13:12, Wen Gu wrote:
> 
> 
> On 2023/1/5 00:09, Alexandra Winter wrote:
>>
>>
>> On 21.12.22 14:14, Wen Gu wrote:
>>>
>>>
>>> On 2022/12/20 22:02, Niklas Schnelle wrote:
>>>
>>>> On Tue, 2022-12-20 at 11:21 +0800, Wen Gu wrote:
>>>>> Hi, all
>>>>>
>>>>> # Background
>>>>>
>>>>> As previously mentioned in [1], we (Alibaba Cloud) are trying to 
>>>>> use SMC
>>>>> to accelerate TCP applications in cloud environment, improving 
>>>>> inter-host
>>>>> or inter-VM communication.
>>>>>
>>>>> In addition of these, we also found the value of SMC-D in scenario 
>>>>> of local
>>>>> inter-process communication, such as accelerate communication 
>>>>> between containers
>>>>> within the same host. So this RFC tries to provide a SMC-D loopback 
>>>>> solution
>>>>> in such scenario, to bring a significant improvement in latency and 
>>>>> throughput
>>>>> compared to TCP loopback.
>>>>>
>>>>> # Design
>>>>>
>>>>> This patch set provides a kind of SMC-D loopback solution.
>>>>>
>>>>> Patch #1/5 and #2/5 provide an SMC-D based dummy device, preparing 
>>>>> for the
>>>>> inter-process communication acceleration. Except for loopback 
>>>>> acceleration,
>>>>> the dummy device can also meet the requirements mentioned in [2], 
>>>>> which is
>>>>> providing a way to test SMC-D logic for broad community without ISM 
>>>>> device.
>>>>>
>>>>>    +------------------------------------------+
>>>>>    |  +-----------+           +-----------+   |
>>>>>    |  | process A |           | process B |   |
>>>>>    |  +-----------+           +-----------+   |
>>>>>    |       ^                        ^         |
>>>>>    |       |    +---------------+   |         |
>>>>>    |       |    |   SMC stack   |   |         |
>>>>>    |       +--->| +-----------+ |<--|         |
>>>>>    |            | |   dummy   | |             |
>>>>>    |            | |   device  | |             |
>>>>>    |            +-+-----------+-+             |
>>>>>    |                   VM                     |
>>>>>    +------------------------------------------+
>>>>>
>>>>> Patch #3/5, #4/5, #5/5 provides a way to avoid data copy from 
>>>>> sndbuf to RMB
>>>>> and improve SMC-D loopback performance. Through extending smcd_ops 
>>>>> with two
>>>>> new semantic: attach_dmb and detach_dmb, sender's sndbuf shares the 
>>>>> same
>>>>> physical memory region with receiver's RMB. The data copied from 
>>>>> userspace
>>>>> to sender's sndbuf directly reaches the receiver's RMB without 
>>>>> unnecessary
>>>>> memory copy in the same kernel.
>>>>>
>>>>>    +----------+                     +----------+
>>>>>    | socket A |                     | socket B |
>>>>>    +----------+                     +----------+
>>>>>          |                               ^
>>>>>          |         +---------+           |
>>>>>     regard as      |         | ----------|
>>>>>     local sndbuf   |  B's    |     regard as
>>>>>          |         |  RMB    |     local RMB
>>>>>          |-------> |         |
>>>>>                    +---------+
>>>>
>>>> Hi Wen Gu,
>>>>
>>>> I maintain the s390 specific PCI support in Linux and would like to
>>>> provide a bit of background on this. You're surely wondering why we
>>>> even have a copy in there for our ISM virtual PCI device. To understand
>>>> why this copy operation exists and why we need to keep it working, one
>>>> needs a bit of s390 aka mainframe background.
>>>>
>>>> On s390 all (currently supported) native machines have a mandatory
>>>> machine level hypervisor. All OSs whether z/OS or Linux run either on
>>>> this machine level hypervisor as so called Logical Partitions (LPARs)
>>>> or as second/third/… level guests on e.g. a KVM or z/VM hypervisor that
>>>> in turn runs in an LPAR. Now, in terms of memory this machine level
>>>> hypervisor sometimes called PR/SM unlike KVM, z/VM, or VMWare is a
>>>> partitioning hypervisor without paging. This is one of the main reasons
>>>> for the very-near-native performance of the machine hypervisor as the
>>>> memory of its guests acts just like native RAM on other systems. It is
>>>> never paged out and always accessible to IOMMU translated DMA from
>>>> devices without the need for pinning pages and besides a trivial
>>>> offset/limit adjustment an LPAR's MMU does the same amount of work as
>>>> an MMU on a bare metal x86_64/ARM64 box.
>>>>
>>>> It also means however that when SMC-D is used to communicate between
>>>> LPARs via an ISM device there is  no way of mapping the DMBs to the
>>>> same physical memory as there exists no MMU-like layer spanning
>>>> partitions that could do such a mapping. Meanwhile for machine level
>>>> firmware including the ISM virtual PCI device it is still possible to
>>>> _copy_ memory between different memory partitions. So yeah while I do
>>>> see the appeal of skipping the memcpy() for loopback or even between
>>>> guests of a paging hypervisor such as KVM, which can map the DMBs on
>>>> the same physical memory, we must keep in mind this original use case
>>>> requiring a copy operation.
>>>>
>>>> Thanks,
>>>> Niklas
>>>>
>>>
>>> Hi Niklas,
>>>
>>> Thank you so much for the complete and detailed explanation! This 
>>> provides
>>> me a brand new perspective of s390 device that we hadn't dabbled in 
>>> before.
>>> Now I understand why shared memory is unavailable between different 
>>> LPARs.
>>>
>>> Our original intention of proposing loopback device and the incoming 
>>> device
>>> (virtio-ism) for inter-VM is to use SMC-D to accelerate communication 
>>> in the
>>> case with no existing s390 ISM devices. In our conception, s390 ISM 
>>> device,
>>> loopback device and virtio-ism device are parallel and are abstracted 
>>> by smcd_ops.
>>>
>>>   +------------------------+
>>>   |          SMC-D         |
>>>   +------------------------+
>>>   -------- smcd_ops ---------
>>>   +------+ +------+ +------+
>>>   | s390 | | loop | |virtio|
>>>   | ISM  | | back | | -ism |
>>>   | dev  | | dev  | | dev  |
>>>   +------+ +------+ +------+
>>>
>>> We also believe that keeping the existing design and behavior of s390 
>>> ISM
>>> device is unshaken. What we want to get support for is some smcd_ops 
>>> extension
>>> for devices with optional beneficial capability, such as nocopy here 
>>> (Let's call
>>> it this for now), which is really helpful for us in inter-process and 
>>> inter-VM
>>> scenario.
>>>
>>> And coincided with IBM's intention to add APIs between SMC-D and 
>>> devices to
>>> support various devices for SMC-D, as mentioned in [2], we send out 
>>> this RFC and
>>> the incoming virio-ism RFC, to provide some examples.
>>>
>>>>>
>>>>> # Benchmark Test
>>>>>
>>>>>    * Test environments:
>>>>>         - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>>>>>         - SMC sndbuf/RMB size 1MB.
>>>>>
>>>>>    * Test object:
>>>>>         - TCP: run on TCP loopback.
>>>>>         - domain: run on UNIX domain.
>>>>>         - SMC lo: run on SMC loopback device with patch #1/5 ~ #2/5.
>>>>>         - SMC lo-nocpy: run on SMC loopback device with patch #1/5 
>>>>> ~ #5/5.
>>>>>
>>>>> 1. ipc-benchmark (see [3])
>>>>>
>>>>>    - ./<foo> -c 1000000 -s 100
>>>>>
>>>>>                          TCP              domain              
>>>>> SMC-lo             SMC-lo-nocpy
>>>>> Message
>>>>> rate (msg/s)         75140      129548(+72.41)    
>>>>> 152266(+102.64%)         151914(+102.17%)
>>>>
>>>> Interesting that it does beat UNIX domain sockets. Also, see my below
>>>> comment for nginx/wrk as this seems very similar.
>>>>
>>>>>
>>>>> 2. sockperf
>>>>>
>>>>>    - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>>>>>    - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp 
>>>>> --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
>>>>>
>>>>>                          TCP                  SMC-lo             
>>>>> SMC-lo-nocpy
>>>>> Bandwidth(MBps)   4943.359        4936.096(-0.15%)        
>>>>> 8239.624(+66.68%)
>>>>> Latency(us)          6.372          3.359(-47.28%)            
>>>>> 3.25(-49.00%)
>>>>>
>>>>> 3. iperf3
>>>>>
>>>>>    - serv: <smc_run> taskset -c <cpu> iperf3 -s
>>>>>    - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
>>>>>
>>>>>                          TCP                  SMC-lo             
>>>>> SMC-lo-nocpy
>>>>> Bitrate(Gb/s)         40.5            41.4(+2.22%)            
>>>>> 76.4(+88.64%)
>>>>>
>>>>> 4. nginx/wrk
>>>>>
>>>>>    - serv: <smc_run> nginx
>>>>>    - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
>>>>>
>>>>>                          TCP                  SMC-lo             
>>>>> SMC-lo-nocpy
>>>>> Requests/s       154643.22      220894.03(+42.84%)        
>>>>> 226754.3(+46.63%)
>>>>
>>>>
>>>> This result is very interesting indeed. So with the much more realistic
>>>> nginx/wrk workload it seems to copy hurts much less than the
>>>> iperf3/sockperf would suggest while SMC-D itself seems to help more.
>>>> I'd hope that this translates to actual applications as well. Maybe
>>>> this makes SMC-D based loopback interesting even while keeping the
>>>> copy, at least until we can come up with a sane way to work a no-copy
>>>> variant into SMC-D?
>>>>
>>>
>>> I agree, nginx/wrk workload is much more realistic for many 
>>> applications.
>>>
>>> But we also encounter many other cases similar to sockperf on the 
>>> cloud, which
>>> requires high throughput, such as AI training and big data.
>>>
>>> So avoidance of copying between DMBs can help these cases a lot :)
>>>
>>>>>
>>>>>
>>>>> # Discussion
>>>>>
>>>>> 1. API between SMC-D and ISM device
>>>>>
>>>>> As Jan mentioned in [2], IBM are working on placing an API between 
>>>>> SMC-D
>>>>> and the ISM device for easier use of different "devices" for SMC-D.
>>>>>
>>>>> So, considering that the introduction of attach_dmb or detach_dmb can
>>>>> effectively avoid data copying from sndbuf to RMB and brings obvious
>>>>> throughput advantages in inter-VM or inter-process scenarios, can the
>>>>> attach/detach semantics be taken into consideration when designing the
>>>>> API to make it a standard ISM device behavior?
>>>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>
>>>> Due to the reasons explained above this behavior can't be emulated by
>>>> ISM devices at least not when crossing partitions. Not sure if we can
>>>> still incorporate it in the API and allow for both copying and
>>>> remapping SMC-D like devices, it definitely needs careful consideration
>>>> and I think also a better understanding of the benefit for real world
>>>> workloads.
>>>>
>>>
>>> Here I am not rigorous.
>>>
>>> Nocopy shouldn't be a standard ISM device behavior indeed. Actually 
>>> we hope it be a
>>> standard optional _SMC-D_ device behavior and defined by smcd_ops.
>>>
>>> For devices don't support these options, like ISM device on s390 
>>> architecture,
>>> .attach_dmb/.detach_dmb and other reasonable extensions (which will 
>>> be proposed to
>>> discuss in incoming virtio-ism RFC) can be set to NULL or return 
>>> invalid. And for
>>> devices do support, they may be used for improving performance in 
>>> some cases.
>>>
>>> In addition, can I know more latest news about the API design? :) , 
>>> like its scale, will
>>> it be a almost refactor of existing interface or incremental 
>>> patching? and its object,
>>> will it be tailored for exact ISM behavior or to reserve some options 
>>> for other devices,
>>> like nocopy here? From my understanding of [2], it might be the latter?
>>>
>>>>>
>>>>> Maybe our RFC of SMC-D based inter-process acceleration (this one) and
>>>>> inter-VM acceleration (will coming soon, which is the update of [1])
>>>>> can provide some examples for new API design. And we are very glad to
>>>>> discuss this on the mail list.
>>>>>
>>>>> 2. Way to select different ISM-like devices
>>>>>
>>>>> With the proposal of SMC-D loopback 'device' (this RFC) and incoming
>>>>> device used for inter-VM acceleration as update of [1], SMC-D has more
>>>>> options to choose from. So we need to consider that how to indicate
>>>>> supported devices, how to determine which one to use, and their 
>>>>> priority...
>>>>
>>>> Agree on this part, though it is for the SMC maintainers to decide, I
>>>> think we would definitely want to be able to use any upcoming inter-VM
>>>> devices on s390 possibly also in conjunction with ISM devices for
>>>> communication across partitions.
>>>>
>>>
>>> Yes, this part needs to be discussed with SMC maintainers. And thank 
>>> you, we are very glad
>>> if our devices can be applied on s390 through the efforts.
>>>
>>>
>>> Best Regards,
>>> Wen Gu
>>>
>>>>>
>>>>> IMHO, this may require an update of CLC message and negotiation 
>>>>> mechanism.
>>>>> Again, we are very glad to discuss this with you on the mailing list.
>>
>> As described in
>> SMC protocol (including SMC-D): 
>> https://www.ibm.com/support/pages/system/files/inline-files/IBM%20Shared%20Memory%20Communications%20Version%202_2.pdf
>> the CLC messages provide a list of up to 8 ISM devices to chose from.
>> So I would hope that we can use the existing protocol.
>>
>> The challenge will be to define GID (Global Interface ID) and CHID (a 
>> fabric ID) in
>> a meaningful way for the new devices.
>> There is always smcd_ops->query_remote_gid()  as a safety net. But the 
>> idea is that
>> a CHID mismatch is a fast way to tell that these 2 interfaces do match.
>>
>>
> 

FYI, we just sent the rest part of the API to the net-next 
https://lore.kernel.org/netdev/20230116092712.10176-1-jaka@linux.ibm.com/T/#t,
which should answer some questions in your patch series.


> Hi Winter and all,
> 
> Thanks for your reply and suggestions! And sorry for my late reply 
> because it took me
> some time to understand SMC-Dv2 protocol and implementation.
> 
> I agree with your opinion. The existing SMC-Dv2 protocol whose CLC 
> messages include
> ism_dev[] list can solve the devices negotiation problem. And I am very 
> willing to use
> the existing protocol, because we all know that the protocol update is a 
> long and complex
> process.
> 
> If I understand correctly, SMC-D loopback(dummy) device can coordinate 
> with existing
> SMC-Dv2 protocol as follows. If there is any mistake, please point out.
> 
> 
> # Initialization
> 
> - Initialize the loopback device with unique GID [Q-1].
> 
> - Register the loopback device as SMC-Dv2-capable device with a 
> system_eid whose 24th
>     or 28th byte is non-zero [Q-2], so that this system's 
> smc_ism_v2_capable will be set
>     to TRUE and SMC-Dv2 is available.
> 
The decision point is the VLAN_ID, if it is x1FFF, the device will 
support V2. i.e. If you can have subnet with VLAN_ID x1FFF, then the 
SEID is necessary, so that the series or types is non-zero. (*1)
> 
> # Proposal
> 
> - Find the loopback device from the smcd_dev_list in 
> smc_find_ism_v2_device_clnt();
> 
> - Record the SEID, GID and CHID[Q-3] of loopback device in the v2 
> extension part of CLC
>     proposal message.
> 
> 
> # Accept
> 
> - Check the GID/CHID list and SEID in CLC proposal message, and find 
> local matched ISM
>     device from smcd_dev_list in smc_find_ism_v2_device_serv(). If both 
> sides of the
>     communication are in the same VM and share the same loopback device, 
> the SEID, GID and
>     CHID will match and loopback device will be chosen [Q-4].
> 
> - Record the loopback device's GID/CHID and matched SEID into CLC accept 
> message.
> 
> 
> # Confirm
> 
> - Confirm the server-selected device (loopback device) accordingto CLC 
> accept messages.
> 
> - Record the loopback device's GID/CHID and server-selected SEID in CLC 
> confirm message.
> 
> 
> Follow the above process, I supplement a patch based on this RFC in the 
> email attachment.
> With the attachment patch, SMC-D loopback will switch to use SMC-Dv2 
> protocol.
> 
> 
> 
> And in the above process, there are something I want to consult and 
> discuss, which is marked
> with '[Q-*]' in the above description.
> 
> # [Q-1]:
> 
> The GID of loopback device is randomly generated in this RFC patch set, 
> but I will find a way
> to unique the GID in formal patches. Any suggestions are welcome.
> 
I think the randowmly generated GID is fine in your case, which is 
equivalent to the IP address.
> 
> # [Q-2]:
> 
> In Linux implementation, the system_eid of the first registered smcd 
> device will determinate
> system's smc_ism_v2_capable (see smcd_register_dev()).
> 
> And I wonder that
> 
> 1) How to define the system_eid? It can be inferred from the code that 
> the 24th and 28th byte
>      are special for SMC-Dv2. So in attachment patch, I define the 
> loopback device SEID as
> 
>      static struct smc_lo_systemeid LO_SYSTEM_EID = {
>              .seid_string = "SMC-SYSZ-LOSEID000000000",
>              .serial_number = "1000",
>              .type = "1000",
>      };
> 
>      Is there anything else I need to pay attention to?
> 
If you just want to use V2, such defination looks good.
e.g. you can use some unique information from "lshw"
> 
> 2) Seems only the first added smcd device determinate the system 
> smc_ism_v2_capable? If two
>      different smcd devices respectively with v1-indicated and 
> v2-indicated system_eid, will
>      the order in which they are registered affects the result of 
> smc_ism_v2_capable ?
> 
see (*1)
> 
> # [Q-3]:
> 
> In attachment patch, I define a special CHID (0xFFFF) for loopback 
> device, as a kind of
> 'unassociated ISM CHID' that not associated with any IP (OSA or 
> HiperSockets) interfaces.
> 
> What's your opinion about this?
> 
It looks good to me
> 
> # [Q-4]:
> 
> In current Linux implementation, server will select the first 
> successfully initialized device
> from the candidates as the final selected one in 
> smc_find_ism_v2_device_serv().
> 
> for (i = 0; i < matches; i++) {
>      ini->smcd_version = SMC_V2;
>      ini->is_smcd = true;
>      ini->ism_selected = i;
>      rc = smc_listen_ism_init(new_smc, ini);
>      if (rc) {
>          smc_find_ism_store_rc(rc, ini);
>          /* try next active ISM device */
>          continue;
>      }
>      return; /* matching and usable V2 ISM device found */
> }
> 
> IMHO, maybe candidate devices should have different priorities? For 
> example, the loopback device
> may be preferred to use if loopback is available.
> 
IMO, I'd prefer such a order: ISM -> loopback -> RoCE
Because ISM for SMC-D is our standard user case, not loopback.
> 
> Best Regards,
> Wen Gu
> 
>>>>>
>>>>> [1] 
>>>>> https://lore.kernel.org/netdev/20220720170048.20806-1-tonylu@linux.alibaba.com/
>>>>> [2] 
>>>>> https://lore.kernel.org/netdev/35d14144-28f7-6129-d6d3-ba16dae7a646@linux.ibm.com/
>>>>> [3] https://github.com/goldsborough/ipc-bench
>>>>>
>>>>> v1->v2
>>>>>    1. Fix some build WARNINGs complained by kernel test rebot
>>>>>       Reported-by: kernel test robot <lkp@intel.com>
>>>>>    2. Add iperf3 test data.
>>>>>
>>>>> Wen Gu (5):
>>>>>     net/smc: introduce SMC-D loopback device
>>>>>     net/smc: choose loopback device in SMC-D communication
>>>>>     net/smc: add dmb attach and detach interface
>>>>>     net/smc: avoid data copy from sndbuf to peer RMB in SMC-D loopback
>>>>>     net/smc: logic of cursors update in SMC-D loopback connections
>>>>>
>>>>>    include/net/smc.h      |   3 +
>>>>>    net/smc/Makefile       |   2 +-
>>>>>    net/smc/af_smc.c       |  88 +++++++++++-
>>>>>    net/smc/smc_cdc.c      |  59 ++++++--
>>>>>    net/smc/smc_cdc.h      |   1 +
>>>>>    net/smc/smc_clc.c      |   4 +-
>>>>>    net/smc/smc_core.c     |  62 +++++++++
>>>>>    net/smc/smc_core.h     |   2 +
>>>>>    net/smc/smc_ism.c      |  39 +++++-
>>>>>    net/smc/smc_ism.h      |   2 +
>>>>>    net/smc/smc_loopback.c | 358 
>>>>> +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>    net/smc/smc_loopback.h |  63 +++++++++
>>>>>    12 files changed, 662 insertions(+), 21 deletions(-)
>>>>>    create mode 100644 net/smc/smc_loopback.c
>>>>>    create mode 100644 net/smc/smc_loopback.h
>>>>>
