Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA59442D55
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhKBMCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:02:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhKBMCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:02:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2AjDJ9013720;
        Tue, 2 Nov 2021 11:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=K2cJNQ+EKDSFAkBiJMmqtiJ5pH0mLiIJH97QopMAXik=;
 b=aXFb4D42euNiN/sHycQaHWfZhMaWcvdmuiuMUdgvdK6shIhjxd0M4yMVp4rhJl8mYqlv
 s5TuKAJ7H574B5dbIjoMojqktCfqE/dv7ajMpIUsBuNOzO9qg5XQCaGU3Ll3cRNvyAB0
 xnm6nyrA9jwkH3TQvt03XbRp9bzyfgoQWFKMa7PQQMR9enwhWu3vCvGagPG3ZYDPyEqE
 43+FqlD0oYvZ0k0DTKQTW0xz6D1cmYtkc/jhq/h7lZZMkG6+lFr+7k0nBwCtl9yTIDca
 5R8ehzsX58yWPSnvDp3X2fwcVFozhzKsoO8B8EoqSAWs3WDzmIVsENLCVo48t08nllBc aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c32jp369j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 11:59:09 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A2BpNQn011525;
        Tue, 2 Nov 2021 11:59:09 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c32jp368h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 11:59:08 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A2BwnSv010236;
        Tue, 2 Nov 2021 11:59:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3c0wpb1m9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 11:59:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A2Bx3hc15335728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 11:59:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7DB14C059;
        Tue,  2 Nov 2021 11:59:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51A794C046;
        Tue,  2 Nov 2021 11:59:03 +0000 (GMT)
Received: from localhost (unknown [9.43.68.191])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Nov 2021 11:59:03 +0000 (GMT)
Date:   Tue, 02 Nov 2021 17:29:02 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH] powerpc/bpf: fix write protecting JIT code
To:     ast@kernel.org, christophe.leroy@csgroup.eu,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hari Bathini <hbathini@linux.ibm.com>, jniethe5@gmail.com,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     andrii@kernel.org, bpf@vger.kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        stable@vger.kernel.org, yhs@fb.com
References: <20211025055649.114728-1-hbathini@linux.ibm.com>
        <1635142354.46h6w5c2rx.naveen@linux.ibm.com>
        <c8d7390b-c07c-75cd-e9e9-4b8f0b786cc6@iogearbox.net>
        <87zgqs8upq.fsf@mpe.ellerman.id.au>
In-Reply-To: <87zgqs8upq.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
User-Agent: astroid/v0.16-1-g4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1635854227.x13v13l6az.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3Obt2H3OnEADXCDZNsGtkT5ZTe4QcLUD
X-Proofpoint-ORIG-GUID: WwFZpJM367dIuy28z4OWZMTgWEtv8ABy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_07,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Ellerman wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 10/25/21 8:15 AM, Naveen N. Rao wrote:
>>> Hari Bathini wrote:
>>>> Running program with bpf-to-bpf function calls results in data access
>>>> exception (0x300) with the below call trace:
>>>>
>>>> =C2=A0=C2=A0=C2=A0 [c000000000113f28] bpf_int_jit_compile+0x238/0x750 =
(unreliable)
>>>> =C2=A0=C2=A0=C2=A0 [c00000000037d2f8] bpf_check+0x2008/0x2710
>>>> =C2=A0=C2=A0=C2=A0 [c000000000360050] bpf_prog_load+0xb00/0x13a0
>>>> =C2=A0=C2=A0=C2=A0 [c000000000361d94] __sys_bpf+0x6f4/0x27c0
>>>> =C2=A0=C2=A0=C2=A0 [c000000000363f0c] sys_bpf+0x2c/0x40
>>>> =C2=A0=C2=A0=C2=A0 [c000000000032434] system_call_exception+0x164/0x33=
0
>>>> =C2=A0=C2=A0=C2=A0 [c00000000000c1e8] system_call_vectored_common+0xe8=
/0x278
>>>>
>>>> as bpf_int_jit_compile() tries writing to write protected JIT code
>>>> location during the extra pass.
>>>>
>>>> Fix it by holding off write protection of JIT code until the extra
>>>> pass, where branch target addresses fixup happens.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
>>>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
>>>> ---
>>>> =C2=A0arch/powerpc/net/bpf_jit_comp.c | 2 +-
>>>> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>>>=20
>>> Thanks for the fix!
>>>=20
>>> Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>>
>> LGTM, I presume this fix will be routed via Michael.
>=20
> Thanks for reviewing, I've picked it up.
>=20
>> BPF selftests have plenty of BPF-to-BPF calls in there, too bad this was
>> caught so late. :/
>=20
> Yeah :/
>=20
> STRICT_KERNEL_RWX is not on by default in all our defconfigs, so that's
> probably why no one caught it.

Yeah, sorry - we should have caught this sooner.

>=20
> I used to run the BPF selftests but they stopped building for me a while
> back, I'll see if I can get them going again.

Ravi had started looking into getting the selftests working well before=20
he left. I will take a look at this.


Thanks,
Naveen

