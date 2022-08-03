Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729D2589330
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbiHCU2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbiHCU2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:28:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C825A889;
        Wed,  3 Aug 2022 13:28:06 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273KDTAf021429;
        Wed, 3 Aug 2022 20:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1r388OS7h5QWZttrhBOslSZ4/JfU+Z5hnc+EMHQuoGc=;
 b=r8A9PY+EtzFzY5lQ+XRVDVNNqHi1kTSkTxyvRnwgKUMiLJ1+n+3uoxe0xaBg/ZbYNuLw
 h+pqQmrvAdwq5Nk0fgRB3NzZQtOIg3LhGllr2g5FzXD1SoCCLdv3XdYvtCWKZ0r8ZeHQ
 QvOStLNFz34x9zCAYYMEDhcWjt9FVToJBWzvD/lqiqRMj4Cm41YnVhS9p82G5bEtRuah
 KC1Pc7AnA/Gkuu4K24ebQ2likXfPEFDYvtrrZQKI81/3aMC4A4mbyEV7cvIoiJZ+maOK
 dbgX9RnjjaLllZzdECOydRh2MAXoZH6JNd1FxrletIOTjx450QBB8jVBqioVfqx8XlE2 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqyv50bat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 20:28:01 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 273KEeMR030236;
        Wed, 3 Aug 2022 20:28:00 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqyv50ba6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 20:28:00 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273KKrtf015766;
        Wed, 3 Aug 2022 20:27:59 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 3hmv99tafa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 20:27:59 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273KRxk38127008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 20:27:59 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09D4E28058;
        Wed,  3 Aug 2022 20:27:59 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 150AF2805A;
        Wed,  3 Aug 2022 20:27:56 +0000 (GMT)
Received: from [9.211.67.200] (unknown [9.211.67.200])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 20:27:55 +0000 (GMT)
Message-ID: <0ccf9cc6-4916-7815-9ce2-990dc7884849@linux.ibm.com>
Date:   Wed, 3 Aug 2022 16:27:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next 1/1] net/smc: SMC for inter-VM communication
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        zmlcc@linux.alibaba.com, hans@linux.alibaba.com,
        zhiyuan2048@linux.alibaba.com, herongguang@linux.alibaba.com
References: <20220720170048.20806-1-tonylu@linux.alibaba.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220720170048.20806-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qvq5Sa-bJOO_zHt1Ak_yxPtbbVTyP90L
X-Proofpoint-ORIG-GUID: Ernd5TVkwLhhtewTGXtgzMcu09F_eU6U
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_06,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,WEIRD_QUOTING autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/22 1:00 PM, Tony Lu wrote:
> Hi all,
> 
> # Background
> 
> We (Alibaba Cloud) have already used SMC in cloud environment to
> transparently accelerate TCP applications with ERDMA [1]. Nowadays,
> there is a common scenario that deploy containers (which runtime is
> based on lightweight virtual machine) on ECS (Elastic Compute Service),
> and the containers may want to be scheduled on the same host in order to
> get higher performance of network, such as AI, big data or other
> scenarios that are sensitive with bandwidth and latency. Currently, the
> performance of inter-VM is poor and CPU resource is wasted (see
> #Benchmark virtio). This scenario has been discussed many times, but a
> solution for a common scenario for applications is missing [2] [3] [4].
> 
> # Design
> 
> In inter-VM scenario, we use ivshmem (Inter-VM shared memory device)
> which is modeled by QEMU [5]. With it, multiple VMs can access one
> shared memory. This shared memory device is statically created by host
> and shared to desired guests. The device exposes as a PCI BAR, and can
> interrupt its peers (ivshmem-doorbell).
> 
> In order to use ivshmem in SMC, we write a draft device driver as a
> bridge between SMC and ivshmem PCI device. To make it easier, this
> driver acts like a SMC-D device in order to fit in SMC without modifying
> the code, which is named ivpci (see patch #1).
> 
>    ┌───────────────────────────────────────┐
>    │  ┌───────────────┐ ┌───────────────┐  │
>    │  │      VM1      │ │      VM2      │  │
>    │  │┌─────────────┐│ │┌─────────────┐│  │
>    │  ││ Application ││ ││ Application ││  │
>    │  │├─────────────┤│ │├─────────────┤│  │
>    │  ││     SMC     ││ ││     SMC     ││  │
>    │  │├─────────────┤│ │├─────────────┤│  │
>    │  ││    ivpci    ││ ││    ivpci    ││  │
>    │  └└─────────────┘┘ └└─────────────┘┘  │
>    │        x  *               x  *        │
>    │        x  ****************x* *        │
>    │        x  xxxxxxxxxxxxxxxxx* *        │
>    │        x  x                * *        │
>    │  ┌───────────────┐ ┌───────────────┐  │
>    │  │shared memories│ │ivshmem-server │  │
>    │  └───────────────┘ └───────────────┘  │
>    │                HOST A                 │
>    └───────────────────────────────────────┘
>     *********** Control flow (interrupt)
>     xxxxxxxxxxx Data flow (memory access)
> 
> Inside ivpci driver, it implements almost all the operations of SMC-D
> device. It can be divided into two parts:
> 
> - control flow, most of it is same with SMC-D, use ivshmem trigger
>    interruptions in ivpci and process CDC flow.
> 
> - data flow, the shared memory of each connection is one large region
>    and divided into two part for local and remote RMB. Every writer
>    syscall copies data to sndbuf and calls ISM's move_data() to move data
>    to remote RMB in ivshmem and interrupt remote. And reader then
>    receives interruption and check CDC message, consume data if cursor is
>    updated.
> 
> # Benchmark
> 
> Current POC of ivpci is unstable and only works for single SMC
> connection. Here is the brief data:
> 
> Items         Latency (pingpong)    Throughput (64KB)
> TCP (virtio)   19.3 us                3794.185 MBps
> TCP (SR-IOV)   13.2 us                3948.792 MBps
> SMC (ivshmem)   6.3 us               11900.269 MBps
> 
> Test environments:
> 
> - CPU Intel Xeon Platinum 8 core, mem 32 GiB
> - NIC Mellanox CX4 with 2 VFs in two different guests
> - using virsh to setup virtio-net + vhost
> - using sockperf and single connection
> - SMC + ivshmem throughput uses one-copy (userspace -> kernel copy)
>    with intrusive modification of SMC (see patch #1), latency (pingpong)
>    use two-copy (user -> kernel and move_data() copy, patch version).
> 
> With the comparison, SMC with ivshmem gets 3-4x bandwidth and a half
> latency.
> 
> TCP + virtio is the most usage solution for guest, it gains lower
> performance. Moreover, it consumes extra thread with full CPU core
> occupied in host to transfer data, wastes more CPU resource. If the host
> is very busy, the performance will be worse.
> 

Hi Tony,

Quite interesting!  FWIW for s390x we are also looking at passthrough of 
host ISM devices to enable SMC-D in QEMU guests:
https://lore.kernel.org/kvm/20220606203325.110625-1-mjrosato@linux.ibm.com/
https://lore.kernel.org/kvm/20220606203614.110928-1-mjrosato@linux.ibm.com/

But seems to me an 'emulated ISM' of sorts could still be interesting 
even on s390x e.g. for scenarios where host device passthrough is not 
possible/desired.

Out of curiosity I tried this ivpci module on s390x but the device won't 
probe -- This is possibly an issue with the s390x PCI emulation layer in 
QEMU, I'll have to look into that.

> # Discussion
> 
> This RFC and solution is still in early stage, so we want to come it up
> as soon as possible and fully discuss with IBM and community. We have
> some topics putting on the table:
> 
> 1. SMC officially supports this scenario.
> 
> SMC + ivshmem shows huge improvement when communicating inter VMs. SMC-D
> and mocking ISM device might not be the official solution, maybe another
> extension for SMC besides SMC-R and SMC-D. So we are wondering if SMC
> would accept this idea to fix this scenario? Are there any other
> possibilities?

I am curious about ivshmem and its current state though -- e.g. looking 
around I see mention of v2 which you also referenced but don't see any 
activity on it for a few years?  And as far as v1 ivshmem -- server "not 
for production use", etc.

Thanks,
Matt

> 
> 2. Implementation of SMC for inter-VM.
> 
> SMC is used in container and cloud environment, maybe we can propose a
> new device and new protocol if possible in these new scenarios to solve
> this problem.
> 
> 3. Standardize this new protocol and device.
> 
> SMC-R has an open RFC 7609, so can this new device or protocol like
> SMC-D can be standardized. There is a possible option that proposing a
> new device model in QEMU + virtio ecosystem and SMC supports this
> standard virtio device, like [6].
> 
> If there are any problems, please point them out.
> 
> Hope to hear from you, thank you.
> 
> [1] https://lwn.net/Articles/879373/
> [2] https://projectacrn.github.io/latest/tutorials/enable_ivshmem.html
> [3] https://dl.acm.org/doi/10.1145/2847562
> [4] https://hal.archives-ouvertes.fr/hal-00368622/document
> [5] https://github.com/qemu/qemu/blob/master/docs/specs/ivshmem-spec.txt
> [6] https://github.com/siemens/jailhouse/blob/master/Documentation/ivshmem-v2-specification.md
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
