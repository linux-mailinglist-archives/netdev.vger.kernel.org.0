Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7506521EC
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiLTODI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiLTODG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:03:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2221B1D5;
        Tue, 20 Dec 2022 06:03:04 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKDh63O023449;
        Tue, 20 Dec 2022 14:02:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=vaDxKEGOVpVgTGiAEy836fYK1TYkGgeFeCFA7Xh+VVY=;
 b=HMB0/CTIZAMGGgzkSe5QWxuTlYNn5AWrV9WEpKQIrL4BOxfnA7bYMYI5K9OPMEpIIBQc
 mqwckqocwouCLBjFoXZmv9/Umzmz+WJeh/sg+12pBlCai7e6f+uovF/J9CCnu0IC/j1+
 xwOYq4xxgpWuUwIoLZbJttMrDui0NhhJ/TFnCrJUVP+pM/CpjXobTEle5D1NHM+KtAjn
 8GHpICpYyuar6U2bmpgwURd2Sobund6HH7i2YumI29Jck/XfD4Tj/jq5JxBtMu8titqq
 7wE30PF8qR8lEbF9wpWOE4NzpyP+3jBSadydj8N+6dkDCrgxjvUoMsU86M5lmaNPbm39 vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mke680hcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:02:54 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKDhpHB026160;
        Tue, 20 Dec 2022 14:02:52 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mke680har-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:02:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6bpAZ014051;
        Tue, 20 Dec 2022 14:02:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw43jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:02:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKE2kdP43188700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 14:02:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6B0F2004B;
        Tue, 20 Dec 2022 14:02:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9820020049;
        Tue, 20 Dec 2022 14:02:45 +0000 (GMT)
Received: from [9.155.211.163] (unknown [9.155.211.163])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 14:02:45 +0000 (GMT)
Message-ID: <42f2972f1dfe45a2741482f36fbbda5b5a56d8f1.camel@linux.ibm.com>
Subject: Re: [RFC PATCH net-next v2 0/5] net/smc:Introduce SMC-D based
 loopback acceleration
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 20 Dec 2022 15:02:45 +0100
In-Reply-To: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U9MNAlybRHAVNx77IXyZ4IPemeQAHIhJ
X-Proofpoint-ORIG-GUID: sjXRStDilPxPaUxQiEs6_wXiAxqixX8x
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 priorityscore=1501 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200111
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NUMERIC_HTTP_ADDR,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 11:21 +0800, Wen Gu wrote:
> Hi, all
>=20
> # Background
>=20
> As previously mentioned in [1], we (Alibaba Cloud) are trying to use SMC
> to accelerate TCP applications in cloud environment, improving inter-host
> or inter-VM communication.
>=20
> In addition of these, we also found the value of SMC-D in scenario of loc=
al
> inter-process communication, such as accelerate communication between con=
tainers
> within the same host. So this RFC tries to provide a SMC-D loopback solut=
ion
> in such scenario, to bring a significant improvement in latency and throu=
ghput
> compared to TCP loopback.
>=20
> # Design
>=20
> This patch set provides a kind of SMC-D loopback solution.
>=20
> Patch #1/5 and #2/5 provide an SMC-D based dummy device, preparing for the
> inter-process communication acceleration. Except for loopback acceleratio=
n,
> the dummy device can also meet the requirements mentioned in [2], which is
> providing a way to test SMC-D logic for broad community without ISM devic=
e.
>=20
>  +------------------------------------------+
>  |  +-----------+           +-----------+   |
>  |  | process A |           | process B |   |
>  |  +-----------+           +-----------+   |
>  |       ^                        ^         |
>  |       |    +---------------+   |         |
>  |       |    |   SMC stack   |   |         |
>  |       +--->| +-----------+ |<--|         |
>  |            | |   dummy   | |             |
>  |            | |   device  | |             |
>  |            +-+-----------+-+             |
>  |                   VM                     |
>  +------------------------------------------+
>=20
> Patch #3/5, #4/5, #5/5 provides a way to avoid data copy from sndbuf to R=
MB
> and improve SMC-D loopback performance. Through extending smcd_ops with t=
wo
> new semantic: attach_dmb and detach_dmb, sender's sndbuf shares the same
> physical memory region with receiver's RMB. The data copied from userspace
> to sender's sndbuf directly reaches the receiver's RMB without unnecessary
> memory copy in the same kernel.
>=20
>  +----------+                     +----------+
>  | socket A |                     | socket B |
>  +----------+                     +----------+
>        |                               ^
>        |         +---------+           |
>   regard as      |         | ----------|
>   local sndbuf   |  B's    |     regard as
>        |         |  RMB    |     local RMB
>        |-------> |         |
>                  +---------+

Hi Wen Gu,

I maintain the s390 specific PCI support in Linux and would like to
provide a bit of background on this. You're surely wondering why we
even have a copy in there for our ISM virtual PCI device. To understand
why this copy operation exists and why we need to keep it working, one
needs a bit of s390 aka mainframe background.

On s390 all (currently supported) native machines have a mandatory
machine level hypervisor. All OSs whether z/OS or Linux run either on
this machine level hypervisor as so called Logical Partitions (LPARs)
or as second/third/=E2=80=A6 level guests on e.g. a KVM or z/VM hypervisor =
that
in turn runs in an LPAR. Now, in terms of memory this machine level
hypervisor sometimes called PR/SM unlike KVM, z/VM, or VMWare is a
partitioning hypervisor without paging. This is one of the main reasons
for the very-near-native performance of the machine hypervisor as the
memory of its guests acts just like native RAM on other systems. It is
never paged out and always accessible to IOMMU translated DMA from
devices without the need for pinning pages and besides a trivial
offset/limit adjustment an LPAR's MMU does the same amount of work as
an MMU on a bare metal x86_64/ARM64 box.

It also means however that when SMC-D is used to communicate between
LPARs via an ISM device there is  no way of mapping the DMBs to the
same physical memory as there exists no MMU-like layer spanning
partitions that could do such a mapping. Meanwhile for machine level
firmware including the ISM virtual PCI device it is still possible to
_copy_ memory between different memory partitions. So yeah while I do
see the appeal of skipping the memcpy() for loopback or even between
guests of a paging hypervisor such as KVM, which can map the DMBs on
the same physical memory, we must keep in mind this original use case
requiring a copy operation.

Thanks,
Niklas

>=20
> # Benchmark Test
>=20
>  * Test environments:
>       - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>       - SMC sndbuf/RMB size 1MB.
>=20
>  * Test object:
>       - TCP: run on TCP loopback.
>       - domain: run on UNIX domain.
>       - SMC lo: run on SMC loopback device with patch #1/5 ~ #2/5.
>       - SMC lo-nocpy: run on SMC loopback device with patch #1/5 ~ #5/5.
>=20
> 1. ipc-benchmark (see [3])
>=20
>  - ./<foo> -c 1000000 -s 100
>=20
>                        TCP              domain              SMC-lo       =
      SMC-lo-nocpy
> Message
> rate (msg/s)         75140      129548(+72.41)    152266(+102.64%)       =
  151914(+102.17%)

Interesting that it does beat UNIX domain sockets. Also, see my below
comment for nginx/wrk as this seems very similar.

>=20
> 2. sockperf
>=20
>  - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>  - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size=
=3D{ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
>=20
>                        TCP                  SMC-lo             SMC-lo-noc=
py
> Bandwidth(MBps)   4943.359        4936.096(-0.15%)        8239.624(+66.68=
%)
> Latency(us)          6.372          3.359(-47.28%)            3.25(-49.00=
%)
>=20
> 3. iperf3
>=20
>  - serv: <smc_run> taskset -c <cpu> iperf3 -s
>  - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
>=20
>                        TCP                  SMC-lo             SMC-lo-noc=
py
> Bitrate(Gb/s)         40.5            41.4(+2.22%)            76.4(+88.64=
%)
>=20
> 4. nginx/wrk
>=20
>  - serv: <smc_run> nginx
>  - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
>=20
>                        TCP                  SMC-lo             SMC-lo-noc=
py
> Requests/s       154643.22      220894.03(+42.84%)        226754.3(+46.63=
%)


This result is very interesting indeed. So with the much more realistic
nginx/wrk workload it seems to copy hurts much less than the
iperf3/sockperf would suggest while SMC-D itself seems to help more.
I'd hope that this translates to actual applications as well. Maybe
this makes SMC-D based loopback interesting even while keeping the
copy, at least until we can come up with a sane way to work a no-copy
variant into SMC-D?

>=20
>=20
> # Discussion
>=20
> 1. API between SMC-D and ISM device
>=20
> As Jan mentioned in [2], IBM are working on placing an API between SMC-D
> and the ISM device for easier use of different "devices" for SMC-D.
>=20
> So, considering that the introduction of attach_dmb or detach_dmb can
> effectively avoid data copying from sndbuf to RMB and brings obvious
> throughput advantages in inter-VM or inter-process scenarios, can the
> attach/detach semantics be taken into consideration when designing the
> API to make it a standard ISM device behavior?

Due to the reasons explained above this behavior can't be emulated by
ISM devices at least not when crossing partitions. Not sure if we can
still incorporate it in the API and allow for both copying and
remapping SMC-D like devices, it definitely needs careful consideration
and I think also a better understanding of the benefit for real world
workloads.

>=20
> Maybe our RFC of SMC-D based inter-process acceleration (this one) and
> inter-VM acceleration (will coming soon, which is the update of [1])
> can provide some examples for new API design. And we are very glad to
> discuss this on the mail list.
>=20
> 2. Way to select different ISM-like devices
>=20
> With the proposal of SMC-D loopback 'device' (this RFC) and incoming
> device used for inter-VM acceleration as update of [1], SMC-D has more
> options to choose from. So we need to consider that how to indicate
> supported devices, how to determine which one to use, and their priority.=
..

Agree on this part, though it is for the SMC maintainers to decide, I
think we would definitely want to be able to use any upcoming inter-VM
devices on s390 possibly also in conjunction with ISM devices for
communication across partitions.

>=20
> IMHO, this may require an update of CLC message and negotiation mechanism.
> Again, we are very glad to discuss this with you on the mailing list.
>=20
> [1] https://lore.kernel.org/netdev/20220720170048.20806-1-tonylu@linux.al=
ibaba.com/
> [2] https://lore.kernel.org/netdev/35d14144-28f7-6129-d6d3-ba16dae7a646@l=
inux.ibm.com/
> [3] https://github.com/goldsborough/ipc-bench
>=20
> v1->v2
>  1. Fix some build WARNINGs complained by kernel test rebot
>     Reported-by: kernel test robot <lkp@intel.com>
>  2. Add iperf3 test data.
>=20
> Wen Gu (5):
>   net/smc: introduce SMC-D loopback device
>   net/smc: choose loopback device in SMC-D communication
>   net/smc: add dmb attach and detach interface
>   net/smc: avoid data copy from sndbuf to peer RMB in SMC-D loopback
>   net/smc: logic of cursors update in SMC-D loopback connections
>=20
>  include/net/smc.h      |   3 +
>  net/smc/Makefile       |   2 +-
>  net/smc/af_smc.c       |  88 +++++++++++-
>  net/smc/smc_cdc.c      |  59 ++++++--
>  net/smc/smc_cdc.h      |   1 +
>  net/smc/smc_clc.c      |   4 +-
>  net/smc/smc_core.c     |  62 +++++++++
>  net/smc/smc_core.h     |   2 +
>  net/smc/smc_ism.c      |  39 +++++-
>  net/smc/smc_ism.h      |   2 +
>  net/smc/smc_loopback.c | 358 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  net/smc/smc_loopback.h |  63 +++++++++
>  12 files changed, 662 insertions(+), 21 deletions(-)
>  create mode 100644 net/smc/smc_loopback.c
>  create mode 100644 net/smc/smc_loopback.h
>=20

