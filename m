Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC4559800
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiFXKiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 06:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFXKiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 06:38:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93D47C530;
        Fri, 24 Jun 2022 03:38:49 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25O8j04c029582;
        Fri, 24 Jun 2022 10:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=GmQ/Ok3MALIzsxkrn+jtIODmpczo8l5jpYyEIpA1p2Q=;
 b=PLUkv/RANIu9jhpx/D3mE1U6sHR5uqkrJLyQureLki5hdUHsbiJqA9+9yYeXyetS7Yll
 PLEzv7S9zNtQOrQuIDIbpGn2KyHRUzGPjblAcIHomLpW8k6vgzm+onLR2vQKJ3Bqs+9t
 HSkvog+xuAhfOWizlcAgUKI1XHh4ALDORsL42mgf5mKhgrTupGykfW4U9KW3ZAs5KsKE
 hE7YgMf+HEE8tdB647MgrEouSRm47UDqkuyn6/5N+kX4S9Ni0PjIFkCJk8ERSuv+3Vg3
 65kUmtar7D24I2eborvheK+Hmm7BZ1jI4QaBnlZT40P+1/POgu7riY4cQSwQoo5IOLY4 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw9hyka5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 10:38:05 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25OAVmm1003164;
        Fri, 24 Jun 2022 10:38:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw9hyka4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 10:38:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OAaWGx009801;
        Fri, 24 Jun 2022 10:38:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gvuj7s7a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 10:38:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OAc6VN31588708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 10:38:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 282664C046;
        Fri, 24 Jun 2022 10:38:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82DE44C044;
        Fri, 24 Jun 2022 10:37:59 +0000 (GMT)
Received: from localhost (unknown [9.43.19.217])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 10:37:59 +0000 (GMT)
Date:   Fri, 24 Jun 2022 16:07:58 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v2 0/5] Atomics support for eBPF on powerpc
To:     bpf@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jordan Niethe <jniethe5@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Russell Currey <ruscur@russell.cc>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20220610155552.25892-1-hbathini@linux.ibm.com>
In-Reply-To: <20220610155552.25892-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1656066254.ebcla8exs0.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RE9FtiVUmc3qtD5v52sO1YemoU8KsuwS
X-Proofpoint-ORIG-GUID: Fe2VZ9a_OwBLHfgStWkAeLerODyLOCZf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_06,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206240040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hari,

Hari Bathini wrote:
> This patchset adds atomic operations to the eBPF instruction set on
> powerpc. The instructions that are added here can be summarised with
> this list of kernel operations for ppc64:
>=20
> * atomic[64]_[fetch_]add
> * atomic[64]_[fetch_]and
> * atomic[64]_[fetch_]or
> * atomic[64]_[fetch_]xor
> * atomic[64]_xchg
> * atomic[64]_cmpxchg
>=20
> and this list of kernel operations for ppc32:
>=20
> * atomic_[fetch_]add
> * atomic_[fetch_]and
> * atomic_[fetch_]or
> * atomic_[fetch_]xor
> * atomic_xchg
> * atomic_cmpxchg

Thanks for your work on this. For this series:
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

>=20
> The following are left out of scope for this effort:
>=20
> * 64 bit operations on ppc32.
> * Explicit memory barriers, 16 and 8 bit operations on both ppc32
>   & ppc64.

The latter is a limitation of the eBPF instruction set itself today,=20
rather than a powerpc-specific limitation.

>=20
> The first patch adds support for bitwsie atomic operations on ppc64.
> The next patch adds fetch variant support for these instructions. The
> third patch adds support for xchg and cmpxchg atomic operations on
> ppc64. Patch #4 adds support for 32-bit atomic bitwise operations on
> ppc32. patch #5 adds support for xchg and cmpxchg atomic operations
> on ppc32.
>=20
> Validated these changes successfully with atomics test cases in
> test_bpf testsuite and  test_verifier & test_progs selftests.
> With test_bpf testsuite:
>=20
>   all 147 atomics related test cases (both 32-bit & 64-bit) JIT'ed
>   successfully on ppc64:
>=20
>     test_bpf: Summary: 1026 PASSED, 0 FAILED, [1014/1014 JIT'ed]
>=20
>   all 76 atomics related test cases (32-bit) JIT'ed successfully
>   on ppc32:
>=20
>     test_bpf: Summary: 1027 PASSED, 0 FAILED, [915/1015 JIT'ed]

Indeed. In my tests, before this series, with CONFIG_BPF_JIT_ALWAYS_ON=3Dy:
test_bpf: Summary: 894 PASSED, 132 FAILED, [882/882 JIT'ed]
test_progs --name=3Datomic: Summary: 0/0 PASSED, 0 SKIPPED, 2 FAILED
test_verifier 0 100: Summary: 46 PASSED, 151 SKIPPED, 0 FAILED

With your patches:
test_bpf: Summary: 1026 PASSED, 0 FAILED, [1014/1014 JIT'ed]
test_progs --name=3Datomic: Summary: 2/7 PASSED, 0 SKIPPED, 0 FAILED
test_verifier 0 100: Summary: 101 PASSED, 96 SKIPPED, 0 FAILED

It is nice to see all the test_bpf tests pass again on ppc64le!

Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com> (ppc64le)


- Naveen

