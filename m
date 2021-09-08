Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE1B403795
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhIHKLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:11:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231723AbhIHKLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 06:11:30 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188A3gjf189491;
        Wed, 8 Sep 2021 06:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ShxB63Z3LnMx3bd5r38U4yiRpSv5ohG9U6xv2rNbM9A=;
 b=YHMgzM+QoPpHQwf3jYtBqZf8rIJqN/N359//GwA8Xky7z2b1K5TY1Q9Qzy2lLD2OwrKt
 5m0rlL+t4fJfAkAqR0gHPcMOg8n3hI5RbTLdzU/TO+r/pK28BbEjCGVA3Rx3qEiDQr9N
 quAoNeW+ZUKJsvxmfQ20f8YncI3EKaF3cv9Br6a/88ipTpl52iLamFmW5iMA9CSfuj54
 /ECipNt6WelLzajO59jGNwzU+hkG0QUH9t7IeWF9G88UKLB8YlwTgSweri4WZWMN4d2z
 ZNKbbje0Gvm3hfzPU1jpBtCBzbYI46xPh3hyXK+7zUe7F+Tj12iGNxMt+M7dyI7EJy8e bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axp74pwpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 06:10:08 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 188A4HNo000631;
        Wed, 8 Sep 2021 06:10:07 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axp74pwp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 06:10:07 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 188A3D3U010005;
        Wed, 8 Sep 2021 10:10:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3axcnnf3ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 10:10:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 188AA2EB51839362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Sep 2021 10:10:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DDD9A4066;
        Wed,  8 Sep 2021 10:10:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 887CCA405C;
        Wed,  8 Sep 2021 10:10:01 +0000 (GMT)
Received: from sig-9-145-45-184.uk.ibm.com (unknown [9.145.45.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Sep 2021 10:10:01 +0000 (GMT)
Message-ID: <fe04c10b5991a5fb0656fe272c137a73ec7d2472.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next v2 13/13] bpf/tests: Add tail call limit test
 with external function call
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 08 Sep 2021 12:10:01 +0200
In-Reply-To: <20210907222339.4130924-14-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
         <20210907222339.4130924-14-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cvhyETxFx_QhgMqUdtLe4OMUvrm6Qseb
X-Proofpoint-ORIG-GUID: VJL6zs6GoFzitB7Awr6rpL-eTOH5DRHB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_03:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-08 at 00:23 +0200, Johan Almbladh wrote:
> This patch adds a tail call limit test where the program also emits
> a BPF_CALL to an external function prior to the tail call. Mainly
> testing that JITed programs preserve its internal register state, for
> example tail call count, across such external calls.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  lib/test_bpf.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 48 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 7475abfd2186..6e45b4da9841 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -12259,6 +12259,20 @@ static struct tail_call_test tail_call_tests[]
> = {
>                 },
>                 .result = MAX_TAIL_CALL_CNT + 1,
>         },
> +       {
> +               "Tail call count preserved across function calls",
> +               .insns = {
> +                       BPF_ALU64_IMM(BPF_ADD, R1, 1),
> +                       BPF_STX_MEM(BPF_DW, R10, R1, -8),
> +                       BPF_CALL_REL(0),
> +                       BPF_LDX_MEM(BPF_DW, R1, R10, -8),
> +                       BPF_ALU32_REG(BPF_MOV, R0, R1),
> +                       TAIL_CALL(0),
> +                       BPF_EXIT_INSN(),
> +               },
> +               .stack_depth = 8,
> +               .result = MAX_TAIL_CALL_CNT + 1,
> +       },
>         {
>                 "Tail call error path, NULL target",
>                 .insns = {

There seems to be a problem with BPF_CALL_REL(0) on s390, since it
assumes that test_bpf_func and __bpf_call_base are within +-2G of
each other, which is not (yet) the case.

I can't think of a good fix, so how about something like this?

--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -12257,6 +12257,7 @@ static struct tail_call_test tail_call_tests[]
= {
                },
                .result = MAX_TAIL_CALL_CNT + 1,
        },
+#ifndef __s390__
        {
                "Tail call count preserved across function calls",
                .insns = {
@@ -12271,6 +12272,7 @@ static struct tail_call_test tail_call_tests[]
= {
                .stack_depth = 8,
                .result = MAX_TAIL_CALL_CNT + 1,
        },
+#endif
        {
                "Tail call error path, NULL target",
                .insns = {

[...]

