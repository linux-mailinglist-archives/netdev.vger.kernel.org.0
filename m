Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4C641F6D7
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353838AbhJAVZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:25:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2170 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229894AbhJAVZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 17:25:21 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191LMFir016677;
        Fri, 1 Oct 2021 17:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KdbECt7xMf59r4iFzQJ48ebBbpqTjpyEi09f219mPIs=;
 b=EhY7FP4zWTdbJ2qn1GZj15Ys8wwW+knrD+uV7TUHgnkkLb1VRKzG87gzknaVGpwEkx0W
 ozldPY5h00Y6IjWdxJZ3P3dc69A7bEftrbtdHtm1LW5vQy+7uTRokW8Ify/2kKkLNota
 O8IjijS+7hemdigl4wWYEZt/LS12+tNt+CeX5SUcddnw59ntPA5jV0dJRxLOrIfe4Su2
 t9Q+i1Qzf044YHeQrcgTldZNSHFvfpUldeLH7/36msXVbOHInepfXL/GmZ03w1ozkeSF
 kMRfso7J7Yuy27i0qVIcj5DHKpXIsWPpmXj487600TyN2H89Jg84tQ+C4uMpJVKWKNwT hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bea6dr07a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 17:23:05 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 191LN4CN018122;
        Fri, 1 Oct 2021 17:23:04 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bea6dr076-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 17:23:04 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 191LGeWE004180;
        Fri, 1 Oct 2021 21:23:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3b9udat1jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 21:23:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 191LN0wr42205468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Oct 2021 21:23:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65F8752050;
        Fri,  1 Oct 2021 21:23:00 +0000 (GMT)
Received: from localhost (unknown [9.43.54.98])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D523A5204E;
        Fri,  1 Oct 2021 21:22:59 +0000 (GMT)
Date:   Sat, 02 Oct 2021 02:52:58 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in powerpc
 JIT compiler
To:     ast@kernel.org, christophe.leroy@csgroup.eu,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hari Bathini <hbathini@linux.ibm.com>, mpe@ellerman.id.au
Cc:     andrii@kernel.org, bpf@vger.kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        yhs@fb.com
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
        <88b59272-e3f7-30ba-dda0-c4a6b42c0029@iogearbox.net>
In-Reply-To: <88b59272-e3f7-30ba-dda0-c4a6b42c0029@iogearbox.net>
User-Agent: astroid/v0.15-23-gcdc62b30
 (https://github.com/astroidmail/astroid)
Message-Id: <1633123101.e5sflytz4f.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6mN9CZGWhZIucqhRhkK3RMFvae8dKpG6
X-Proofpoint-GUID: _cY-NIW-L_OMpRIM22KMMWpUyxtjDpse
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_05,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=969
 mlxscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110010147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 9/29/21 1:18 PM, Hari Bathini wrote:
>> Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
>> compiler code with the aim to simplify adding BPF_PROBE_MEM support.
>> Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
>> branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
>> & PPC32 JIT compilers respectively. Patch #6 & #8 handle bad userspace
>> pointers for PPC64 & PPC32 cases respectively.
>=20
> Michael, are you planning to pick up the series or shall we route via bpf=
-next?

I just posted a few fixes to the powerpc BPF JIT (*). It would be nice=20
if those can be picked up for v5.15 through bpf/master or powerpc/fixes.=20=
=20
If so, this series may need to be rebased to address some conflicts.=20=20
Otherwise, I can re-post my fixes atop this.


Thanks,
Naveen

(*) https://lore.kernel.org/linuxppc-dev/cover.1633104510.git.naveen.n.rao@=
linux.vnet.ibm.com/T/#u

