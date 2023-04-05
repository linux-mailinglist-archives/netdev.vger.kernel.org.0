Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE76D7FF8
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbjDEOs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbjDEOs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:48:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AACC1;
        Wed,  5 Apr 2023 07:48:26 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335EL8I0023781;
        Wed, 5 Apr 2023 14:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=HfpEUMEUnBT3SNvaAnp0L3iox3w367o+wY3OuFKEtlc=;
 b=GPeeP7/LoN8GhG7hD8BwVIwShwKmgmrdTaVMGo2R3mLJeIIroXsao9iw12aFPtOwc+fF
 TX3X51sKw3xyVM5QwiFZ0AckA/NqZm8iY3aTu/vEHy+U93u4EBTFhUJO//vGMGzAWKk1
 /RwNsoDZAxM+PPm9TpTrz+/lKoxeMX0cY9gCjRoud4wpMR7w5HkGVSJ5q03/TlJdDdtg
 mQ5QZ5UcxYM7WmQX5cpO8UqrAC7lREFDqxnTGEhs7VX434At3XXNjKXSfXeX7SCDGMaL
 CQ6JWrnbEQBygXL3/8aWK8Zhyc607vuF94mB14sLNmjZY8sK1SW5yKlkecstuIguy4a1 Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps75jf31e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 14:48:21 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 335DURMI031035;
        Wed, 5 Apr 2023 14:48:20 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps75jf30q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 14:48:20 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 335AQ3IS016808;
        Wed, 5 Apr 2023 14:48:19 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3ppc87xrym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 14:48:19 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 335EmHHp32571944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 14:48:17 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 104B858064;
        Wed,  5 Apr 2023 14:48:17 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E4E858056;
        Wed,  5 Apr 2023 14:48:15 +0000 (GMT)
Received: from [9.211.92.70] (unknown [9.211.92.70])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 14:48:15 +0000 (GMT)
Message-ID: <709cbd7d-7bc6-d039-a814-cbc8d50b861b@linux.ibm.com>
Date:   Wed, 5 Apr 2023 16:48:14 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, wintera@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eRM_zaCzAJMDnqopRIk65PX0rtgJDO-2
X-Proofpoint-ORIG-GUID: KcOUfiS-DI88fbpbPNUNPudnoYl3NExI
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_09,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050132
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.03.23 05:28, Wen Gu wrote:
> Hi, all
> 
> # Background
> 
> The background and previous discussion can be referred from [1],[6].
> 
> We found SMC-D can be used to accelerate OS internal communication, such as
> loopback or between two containers within the same OS instance. So this patch
> set provides a kind of SMC-D dummy device (we call it the SMC-D loopback device)
> to emulate an ISM device, so that SMC-D can also be used on architectures
> other than s390. The SMC-D loopback device are designed as a system global
> device, visible to all containers.
> 
> This version is implemented based on the generalized interface provided by [2].
> And there is an open issue, which will be mentioned later.
> 
> # Design
> 
> This patch set basically follows the design of the previous version.
> 
> Patch #1/9 ~ #3/9 attempt to decouple ISM-related structures from the SMC-D
> generalized code and extract some helpers to make SMC-D protocol compatible
> with devices other than s390 ISM device.
> 
> Patch #4/9 introduces a kind of loopback device, which is defined as SMC-D v2
> device and designed to provide communication between SMC sockets in the same OS
> instance.
> 
>   +-------------------------------------------+
>   |  +--------------+       +--------------+  |
>   |  | SMC socket A |       | SMC socket B |  |
>   |  +--------------+       +--------------+  |
>   |       ^                         ^         |
>   |       |    +----------------+   |         |
>   |       |    |   SMC stack    |   |         |
>   |       +--->| +------------+ |<--|         |
>   |            | |   dummy    | |             |
>   |            | |   device   | |             |
>   |            +-+------------+-+             |
>   |                   OS                      |
>   +-------------------------------------------+
> 
> Patch #5/9 ~ #8/9 expand SMC-D protocol interface (smcd_ops) for scenarios where
> SMC-D is used to communicate within VM (loopback here) or between VMs on the same
> host (based on virtio-ism device, see [3]). What these scenarios have in common
> is that the local sndbuf and peer RMB can be mapped to same physical memory region,
> so the data copy between the local sndbuf and peer RMB can be omitted. Performance
> improvement brought by this extension can be found in # Benchmark Test.
> 
>   +----------+                     +----------+
>   | socket A |                     | socket B |
>   +----------+                     +----------+
>         |                               ^
>         |         +---------+           |
>    regard as      |         | ----------|
>    local sndbuf   |  B's    |     regard as
>         |         |  RMB    |     local RMB
>         |-------> |         |
>                   +---------+
> 
> Patch #9/9 realizes the support of loopback device for the above-mentioned expanded
> SMC-D protocol interface.
> 
> # Benchmark Test
> 
>   * Test environments:
>        - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>        - SMC sndbuf/RMB size 1MB.
> 
>   * Test object:
>        - TCP lo: run on TCP loopback.
>        - domain: run on UNIX domain.
>        - SMC lo: run on SMC loopback device with patch #1/9 ~ #4/9.
>        - SMC lo-nocpy: run on SMC loopback device with patch #1/9 ~ #9/9.
> 
> 1. ipc-benchmark (see [4])
> 
>   - ./<foo> -c 1000000 -s 100
> 
>                      TCP-lo              domain              SMC-lo          SMC-lo-nocpy
> Message
> rate (msg/s)         79025      115736(+46.45%)    146760(+85.71%)       149800(+89.56%)
> 
> 2. sockperf
> 
>   - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>   - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
> 
>                      TCP-lo                  SMC-lo             SMC-lo-nocpy
> Bandwidth(MBps)   4822.388        4940.918(+2.56%)         8086.67(+67.69%)
> Latency(us)          6.298          3.352(-46.78%)            3.35(-46.81%)
> 
> 3. iperf3
> 
>   - serv: <smc_run> taskset -c <cpu> iperf3 -s
>   - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
> 
>                      TCP-lo                  SMC-lo             SMC-lo-nocpy
> Bitrate(Gb/s)         40.7            40.5(-0.49%)            72.4(+77.89%)
> 
> 4. nginx/wrk
> 
>   - serv: <smc_run> nginx
>   - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
> 
>                      TCP-lo                  SMC-lo             SMC-lo-nocpy
> Requests/s       155994.57      214544.79(+37.53%)       215538.55(+38.17%)
> 
> 
> # Open issue
> 
> The open issue is about how to detect that the source and target of CLC proposal
> are within the same OS instance and can communicate through the SMC-D loopback device.
> Similar issue also exists when using virtio-ism devices (the background and details
> of virtio-ism device can be referred from [3]). In previous discussions, multiple
> options were proposed (see [5]). Thanks again for the help of the community. :)
> 
> But as we discussed, these solutions have some imperfection. So this version of RFC
> continues to use previous workaround, that is, a 64-bit random GID is generated for
> SMC-D loopback device. If the GIDs of the devices found by two peers are the same,
> then they are considered to be in the same OS instance and can communicate with each
> other by the loopback device.
> 
> This approach needs that the loopback device GID is globally unique. But theoretically
> there is a possibility of a collision. Assume the following situations:
> 
> (1) Assume that the SMC-D loopback devices of the two different OS instances happen
>      to generate the same 64-bit GID.
> 
>      For the convenience of description, we refer to the sockets on these two
>      different OS instance as server A and client B.
> 
>      A will misjudge that the two are on the same OS instance because the same GID
>      in CLC proposal message. Then A creates its RMB and sends 64-bit token-A to B
>      in CLC accept message.
> 
>      B receives the CLC accept message. And according to patch #7/9, B tries to
>      attach its sndbuf to A's RMB by token-A.
> 
> (2) And assume that the OS instance where B is located happens to have an unattached
>      RMB whose 64-bit token is same as token-A.
> 
>      Then B successfully attaches its sndbuf to the wrong RMB, and creates its RMB,
>      sends token-B to A in CLC confirm message.
> 
>      Similarly, A receives the message and tries to attach its sndbuf to B's RMB by
>      token-B.
> 
> (3) Similar to (2), assume that the OS instance where A is located happens to have
>      an unattached RMB whose 64-bit token is same as token-B.
> 
>      Then A successfully attach its sndbuf to the wrong RMB. Both sides mistakenly
>      believe that an SMC-D connection based on the loopback device is established
>      between them.
> 
> If the above 3 coincidences all happen, that is, 64-bit random number conflicts occur
> 3 times, then an unreachable SMC-D connection will be established, which is nasty.
> But if one of above is not satisfied, it will safely fallback to TCP.
> 
> Since the chances of these happening are very small, I wonder if this risk of 1/2^(64*3)
> probability is acceptable? Can we just use 64-bits random generated number as GID in
> loopback device?
> 
> Some other ways that may be able to make loopback GID unique are
>   1) Using a 128-bit UUID to identify SMC-D loopback device or virtio-ism device, because
>      the probability of a 128-bit UUID collision is considered negligible. But it needs
>      to extend the CLC message to carry a longer GID.
>   2) Using MAC address of netdev in the OS as part of SMC-D loopback device GID, provided
>      that the MAC addresses are unique. But the MAC address could theoretically also be
>      incorrectly set to be the same.
> 
> Hope to hear opinions from the community. Any ideas are welcome.
> 
> Thanks!
> Wen Gu

Hi Wen,

Thank you for the new version. The discussion on the open issue is still 
on-going in our organisation internally. I appreciate your patience!

One thing I need to mention during testing the loopback device on our 
platform is that we get crash, because smc_ism-signal_shutdown() is 
called by smc_1gr_free_work(), which is called indirectly by 
smc_conn_free(). Please make sure that it would go to the path of the 
loopback device cleanly. Any question and consideration is welcome!

Thanks,
Wenjia
> 
> v4->v3
>   1. Rebase to the latest net-next;
>   2. Introduce SEID helper. SMC-D loopback will return SMCD_DEFAULT_V2_SEID. And if it
>      coexist with ISM device, the SEID of ISM device will overwrite SMCD_DEFAULT_V2_SEID
>      as smc_ism_v2_system_eid.
>   3. Won't remove dmb_node from hashtable until no sndbuf attaching to it.
> 
>   Something postponed in this version
>   1. Hierarchy perference of SMC-D devices when loopback and ISM devices coexist, which
>      will be determinated after comparing the performance of loopback and ISM.
> 
> v3->v2
>   1. Adapt new generalized interface provided by [2];
>   2. Select loopback device through SMC-D v2 protocol;
>   3. Split the loopback-related implementation and generic implementation into different
>      patches more reasonably.
> 
> v1->v2
>   1. Fix some build WARNINGs complained by kernel test rebot
>      Reported-by: kernel test robot <lkp@intel.com>
>   2. Add iperf3 test data.
> 
> [1] https://lore.kernel.org/netdev/1671506505-104676-1-git-send-email-guwen@linux.alibaba.com/
> [2] https://lore.kernel.org/netdev/20230123181752.1068-1-jaka@linux.ibm.com/
> [3] https://lists.oasis-open.org/archives/virtio-comment/202302/msg00148.html
> [4] https://github.com/goldsborough/ipc-bench
> [5] https://lore.kernel.org/netdev/b9867c7d-bb2b-16fc-feda-b79579aa833d@linux.ibm.com/
> [6] https://lore.kernel.org/netdev/1676477905-88043-1-git-send-email-guwen@linux.alibaba.com/
> 
> 
> Wen Gu (9):
>    net/smc: Decouple ism_dev from SMC-D device dump
>    net/smc: Decouple ism_dev from SMC-D DMB registration
>    net/smc: Extract v2 check helper from SMC-D device registration
>    net/smc: Introduce SMC-D loopback device
>    net/smc: Introduce an interface for getting DMB attribute
>    net/smc: Introudce interfaces for DMB attach and detach
>    net/smc: Avoid data copy from sndbuf to peer RMB in SMC-D
>    net/smc: Modify cursor update logic when using mappable DMB
>    net/smc: Add interface implementation of loopback device
> 
>   drivers/s390/net/ism_drv.c |   5 +-
>   include/net/smc.h          |  18 +-
>   net/smc/Makefile           |   2 +-
>   net/smc/af_smc.c           |  26 ++-
>   net/smc/smc_cdc.c          |  59 ++++--
>   net/smc/smc_cdc.h          |   1 +
>   net/smc/smc_core.c         |  70 ++++++-
>   net/smc/smc_core.h         |   1 +
>   net/smc/smc_ism.c          |  99 ++++++++--
>   net/smc/smc_ism.h          |   5 +
>   net/smc/smc_loopback.c     | 445 +++++++++++++++++++++++++++++++++++++++++++++
>   net/smc/smc_loopback.h     |  56 ++++++
>   12 files changed, 750 insertions(+), 37 deletions(-)
>   create mode 100644 net/smc/smc_loopback.c
>   create mode 100644 net/smc/smc_loopback.h
> 
