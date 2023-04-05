Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6956D847D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDERFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbjDERE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:04:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25651BEA;
        Wed,  5 Apr 2023 10:04:32 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335Gqcco007121;
        Wed, 5 Apr 2023 17:04:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=UHols9TvcwFtbqfmvLLYKf0HhSObbueAyTBH3RLGIaY=;
 b=SduXG2rjuBLQKR1lG4guMUHiwDulTv5HuVmjN91dV9iQRKVbwLxKEjpBWnlvLHY21oyd
 Xk8uJlzbL1Fh1iXO8cm1CIxBawNfyTP3DhHcatjRnG1SQjOhp0TZHOD7lO8PBxolAysp
 8I57jM9gpyaZQI4d7e1fmbW1Yi0C/ta55W1Kqh0R6DqP+EspwHa1DxWC+95FeWfycrrH
 K6l1Mau96dPFEFN6BTerxNfmxS8KewlmvfTap+Tw1ngOawWOrpZq3ZUpaVUqcKXMZDnE
 efcM4OAKQKYfgfVrl01t3bkB0Dw/KT846GiWr+xa0acqH/11STi+WwTf43PJ6SPNQx7b hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps992q493-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 17:04:21 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 335GuRT1005782;
        Wed, 5 Apr 2023 17:04:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps992q488-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 17:04:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3355SQCf015821;
        Wed, 5 Apr 2023 17:04:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc873g91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 17:04:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 335H4FGU25952970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 17:04:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67CCA20043;
        Wed,  5 Apr 2023 17:04:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B68020040;
        Wed,  5 Apr 2023 17:04:15 +0000 (GMT)
Received: from [9.155.211.163] (unknown [9.155.211.163])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 17:04:14 +0000 (GMT)
Message-ID: <6156aaad710bc7350cbae6cb821289c8a37f44bb.camel@linux.ibm.com>
Subject: Re: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, wintera@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 05 Apr 2023 19:04:14 +0200
In-Reply-To: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UWg6vurLIFPmrBI9EkwPV3aZCUC5JeH5
X-Proofpoint-ORIG-GUID: bb9eFV1iLPpWrSjYhjR32gFJoVOI-6z8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_11,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304050154
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NUMERIC_HTTP_ADDR,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-27 at 11:28 +0800, Wen Gu wrote:
> Hi, all
>=20
> # Background
>=20
> The background and previous discussion can be referred from [1],[6].
>=20
> We found SMC-D can be used to accelerate OS internal communication, such =
as
> loopback or between two containers within the same OS instance. So this p=
atch
> set provides a kind of SMC-D dummy device (we call it the SMC-D loopback =
device)
> to emulate an ISM device, so that SMC-D can also be used on architectures
> other than s390. The SMC-D loopback device are designed as a system global
> device, visible to all containers.
>=20
> This version is implemented based on the generalized interface provided b=
y [2].
> And there is an open issue, which will be mentioned later.
>=20
> # Design
>=20
> This patch set basically follows the design of the previous version.
>=20
> Patch #1/9 ~ #3/9 attempt to decouple ISM-related structures from the SMC=
-D
> generalized code and extract some helpers to make SMC-D protocol compatib=
le
> with devices other than s390 ISM device.
>=20
> Patch #4/9 introduces a kind of loopback device, which is defined as SMC-=
D v2
> device and designed to provide communication between SMC sockets in the s=
ame OS
> instance.
>=20
>  +-------------------------------------------+
>  |  +--------------+       +--------------+  |
>  |  | SMC socket A |       | SMC socket B |  |
>  |  +--------------+       +--------------+  |
>  |       ^                         ^         |
>  |       |    +----------------+   |         |
>  |       |    |   SMC stack    |   |         |
>  |       +--->| +------------+ |<--|         |
>  |            | |   dummy    | |             |
>  |            | |   device   | |             |
>  |            +-+------------+-+             |
>  |                   OS                      |
>  +-------------------------------------------+
>=20
> Patch #5/9 ~ #8/9 expand SMC-D protocol interface (smcd_ops) for scenario=
s where
> SMC-D is used to communicate within VM (loopback here) or between VMs on =
the same
> host (based on virtio-ism device, see [3]). What these scenarios have in =
common
> is that the local sndbuf and peer RMB can be mapped to same physical memo=
ry region,
> so the data copy between the local sndbuf and peer RMB can be omitted. Pe=
rformance
> improvement brought by this extension can be found in # Benchmark Test.
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
>=20
> Patch #9/9 realizes the support of loopback device for the above-mentione=
d expanded
> SMC-D protocol interface.
>=20
> # Benchmark Test
>=20
>  * Test environments:
>       - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>       - SMC sndbuf/RMB size 1MB.
>=20
>  * Test object:
>       - TCP lo: run on TCP loopback.
>       - domain: run on UNIX domain.
>       - SMC lo: run on SMC loopback device with patch #1/9 ~ #4/9.
>       - SMC lo-nocpy: run on SMC loopback device with patch #1/9 ~ #9/9.
>=20
> 1. ipc-benchmark (see [4])
>=20
>  - ./<foo> -c 1000000 -s 100
>=20
>                     TCP-lo              domain              SMC-lo       =
   SMC-lo-nocpy
> Message
> rate (msg/s)         79025      115736(+46.45%)    146760(+85.71%)       =
149800(+89.56%)
>=20
> 2. sockperf
>=20
>  - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>  - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size=
=3D{ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
>=20
>                     TCP-lo                  SMC-lo             SMC-lo-noc=
py
> Bandwidth(MBps)   4822.388        4940.918(+2.56%)         8086.67(+67.69=
%)
> Latency(us)          6.298          3.352(-46.78%)            3.35(-46.81=
%)
>=20
> 3. iperf3
>=20
>  - serv: <smc_run> taskset -c <cpu> iperf3 -s
>  - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
>=20
>                     TCP-lo                  SMC-lo             SMC-lo-noc=
py
> Bitrate(Gb/s)         40.7            40.5(-0.49%)            72.4(+77.89=
%)
>=20
> 4. nginx/wrk
>=20
>  - serv: <smc_run> nginx
>  - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
>=20
>                     TCP-lo                  SMC-lo             SMC-lo-noc=
py
> Requests/s       155994.57      214544.79(+37.53%)       215538.55(+38.17=
%)
>=20
>=20
> # Open issue
>=20
> The open issue is about how to detect that the source and target of CLC p=
roposal
> are within the same OS instance and can communicate through the SMC-D loo=
pback device.
> Similar issue also exists when using virtio-ism devices (the background a=
nd details
> of virtio-ism device can be referred from [3]). In previous discussions, =
multiple
> options were proposed (see [5]). Thanks again for the help of the communi=
ty. :)
>=20
> But as we discussed, these solutions have some imperfection. So this vers=
ion of RFC
> continues to use previous workaround, that is, a 64-bit random GID is gen=
erated for
> SMC-D loopback device. If the GIDs of the devices found by two peers are =
the same,
> then they are considered to be in the same OS instance and can communicat=
e with each
> other by the loopback device.
>=20
> This approach needs that the loopback device GID is globally unique. But =
theoretically
> there is a possibility of a collision. Assume the following situations:
>=20
> (1) Assume that the SMC-D loopback devices of the two different OS instan=
ces happen
>     to generate the same 64-bit GID.
>=20
>     For the convenience of description, we refer to the sockets on these =
two
>     different OS instance as server A and client B.
>=20
>     A will misjudge that the two are on the same OS instance because the =
same GID
>     in CLC proposal message. Then A creates its RMB and sends 64-bit toke=
n-A to B
>     in CLC accept message.
>=20
>     B receives the CLC accept message. And according to patch #7/9, B tri=
es to
>     attach its sndbuf to A's RMB by token-A.
>=20
> (2) And assume that the OS instance where B is located happens to have an=
 unattached
>     RMB whose 64-bit token is same as token-A.
>=20
>     Then B successfully attaches its sndbuf to the wrong RMB, and creates=
 its RMB,
>     sends token-B to A in CLC confirm message.
>=20
>     Similarly, A receives the message and tries to attach its sndbuf to B=
's RMB by
>     token-B.
>=20
> (3) Similar to (2), assume that the OS instance where A is located happen=
s to have
>     an unattached RMB whose 64-bit token is same as token-B.
>=20
>     Then A successfully attach its sndbuf to the wrong RMB. Both sides mi=
stakenly
>     believe that an SMC-D connection based on the loopback device is esta=
blished
>     between them.
>=20
> If the above 3 coincidences all happen, that is, 64-bit random number con=
flicts occur
> 3 times, then an unreachable SMC-D connection will be established, which =
is nasty.
> But if one of above is not satisfied, it will safely fallback to TCP.
>=20
> Since the chances of these happening are very small, I wonder if this ris=
k of 1/2^(64*3)
> probability is acceptable? Can we just use 64-bits random generated numbe=
r as GID in
> loopback device?

Let me just spell out some details here to make sure we're all on the
same page.

You're assuming that GIDs are generated randomly at cryptographic
quality. In the code I can see that you use get_random_bytes() which as
its comment explains supplies the same quality randomness as
/dev/urandom so on modern kernels that should provide cryptographic
quality randomness and be fine. Might be something to keep in mind for
backports though.

The fixed CHID of 0xFFFF makes sure this system identity confusion can
only occur between SMC-D loopback (and possibly virtio-ism?) never with
ISM based SMC-D or SMC-R as these never use this CHID value. Correct?

Now for the collision scenario above. As I understand it the
probability of the case where fallback does *not* occur is equivalent
to a 128 bit hash collision. Basically the random 64 bit GID_A
concatenated with the 64 bit DMB Token_A needs to just happen to match
the concatenation of the random 64 bit GID_B with DMB Token_B. With
that interpretation we can consult Wikipedia[0] for a nice table of how
many random GID+DMB Token choices are needed for a certain collision
probability. For 128 bits at least 8.2=C3=9710^11 tries would be needed just
to reach a 10^-15 collision probability. Considering the collision does
not only need to exist between two systems but these also need to try
to communicate with each other and happen to use the colliding DMBs for
things to get into the broken fallback case I think from a theoretical
point of view this sounds like neglible risk to me.

That said I'm more worried about the fallback to TCP being broken due
to a code bug once the GIDs do match which is already extremely
unlikely and thus not naturally tested in the wild. Do we have a plan
how to keep testing that fallback scenario somehow. Maybe with a
selftest or something?=C2=A0

If we can solve the testing part then I'm personally in favor of this
approach of going with cryptograhically random GID and DMB token. It's
simple and doesn't depend on external factors and doesn't need a
protocol extension except for possibly reserving CHID 0xFFFF.

One more question though, what about the SEID why does that have to be
fixed and at least partially match what ISM devices use? I think I'm
missing some SMC protocol/design detail here. I'm guessing this would
require a protocol change?

Thanks,
Niklas

[0] https://en.wikipedia.org/wiki/Birthday_attack


