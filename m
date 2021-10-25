Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38787438F3D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 08:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhJYGSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 02:18:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48904 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229841AbhJYGSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 02:18:24 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P2g9RS029185;
        Mon, 25 Oct 2021 02:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=v5gSGXfj5/YdFpW/xxDwXzuFg5yfHNmwdjm+62+2R8o=;
 b=Whxysw9B1rYWBgzHTUWmhWUD5ewOKdE4thmSy1w0vbuSju1jUVl4trtfZidg0kTJ3UOK
 BmXKLOttTQlbEF+Ba9woPmwvd3k467tHqhKSGg/mdyV8mWRKmfF0e7Pe8uBCQOvkMi6p
 mxDNzkPpEY99zcjev40H65OTf3HBx3UDcXvduDxr4SC+VbMVJVUvIE4rj1XGS8UDmngK
 LebowtRANZVVz0F80cf+Izhl2vH6W1Jr3WJAHq4l0tECsCS/Sj/fNPMwOkc/mIj6yvMg
 Br+1qqGgN9JoQTw/CViB/SC2F+TNceQMm6JxoMyZx7jj6381EqTR+Sa71NEuUuBoBbCM 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvyuysn5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 02:15:30 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19P5xCpY017848;
        Mon, 25 Oct 2021 02:15:29 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvyuysn57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 02:15:29 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P62lbu025259;
        Mon, 25 Oct 2021 06:15:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3bva1aj7ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 06:15:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P69NlK61735378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 06:09:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA10B52051;
        Mon, 25 Oct 2021 06:15:24 +0000 (GMT)
Received: from localhost (unknown [9.43.123.71])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8FAFD5204E;
        Mon, 25 Oct 2021 06:15:24 +0000 (GMT)
Date:   Mon, 25 Oct 2021 11:45:23 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH] powerpc/bpf: fix write protecting JIT code
To:     ast@kernel.org, christophe.leroy@csgroup.eu, daniel@iogearbox.net,
        Hari Bathini <hbathini@linux.ibm.com>, jniethe5@gmail.com,
        mpe@ellerman.id.au
Cc:     andrii@kernel.org, bpf@vger.kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        stable@vger.kernel.org, yhs@fb.com
References: <20211025055649.114728-1-hbathini@linux.ibm.com>
In-Reply-To: <20211025055649.114728-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/v0.15-23-gcdc62b30
 (https://github.com/astroidmail/astroid)
Message-Id: <1635142354.46h6w5c2rx.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JiJwZNW4RvKRhX36cpqy_TIpKAwNyFfk
X-Proofpoint-ORIG-GUID: Z8DX6AV7MXC8oswD3dxL3yYJ05Nsuehg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_01,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250034
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hari Bathini wrote:
> Running program with bpf-to-bpf function calls results in data access
> exception (0x300) with the below call trace:
>=20
>     [c000000000113f28] bpf_int_jit_compile+0x238/0x750 (unreliable)
>     [c00000000037d2f8] bpf_check+0x2008/0x2710
>     [c000000000360050] bpf_prog_load+0xb00/0x13a0
>     [c000000000361d94] __sys_bpf+0x6f4/0x27c0
>     [c000000000363f0c] sys_bpf+0x2c/0x40
>     [c000000000032434] system_call_exception+0x164/0x330
>     [c00000000000c1e8] system_call_vectored_common+0xe8/0x278
>=20
> as bpf_int_jit_compile() tries writing to write protected JIT code
> location during the extra pass.
>=20
> Fix it by holding off write protection of JIT code until the extra
> pass, where branch target addresses fixup happens.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
> ---
>  arch/powerpc/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for the fix!

Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

