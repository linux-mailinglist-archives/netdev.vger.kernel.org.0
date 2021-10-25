Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEBD438F0B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 07:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJYGAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 02:00:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229678AbhJYGAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 02:00:08 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P2BWXZ002897;
        Mon, 25 Oct 2021 01:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Yrql1A3zEoiaAiMlCrkjNOeG6UgXSyYESM54IDW+hFk=;
 b=suEt4ooclPP0tyttxqJDvy7wswcpj/GS1zfRzCU5gpsNhg4vWmSQgmFVskHtXlXoWx9P
 /5e4KTQW+EVaTpMymRP4WhZUKlqHfhJ15XSgm7mgvGQ1UELQ/NY8taRkRpxiIyDmJ9c8
 RwmGEbopdQow5dO6ll6hHCnlzbizVvIDpxw3LuSqolqyKoy3Ek2gqfdrKdBEs+MqZiS5
 xcH+bRUEGIgM1+8gfoL+3Zrwvrf+XHF0SRSDlHcQyV4/qzvFRw07IhdLqPb59iZcOLsg
 dkY6l5yT4PFG5DZmlQsV1wcjtdeh0E8uqoxFEZqHXyJhZjhB7Xu0bbf6hQq3akMekrl7 Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bvy9q1fh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 01:57:07 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19P4rcuv025532;
        Mon, 25 Oct 2021 01:57:07 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bvy9q1fgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 01:57:07 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P5slqA010679;
        Mon, 25 Oct 2021 05:57:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3bva1ahxt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 05:57:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P5v17W53477784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 05:57:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC1D252051;
        Mon, 25 Oct 2021 05:57:01 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.32.58])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A39E25204E;
        Mon, 25 Oct 2021 05:56:57 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, jniethe5@gmail.com,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH] powerpc/bpf: fix write protecting JIT code
Date:   Mon, 25 Oct 2021 11:26:49 +0530
Message-Id: <20211025055649.114728-1-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HgdCVfj6g5biGbYpPc1Iq424TT_6zGG3
X-Proofpoint-GUID: w8HwfKcXREudIYwCbb2537m7_fCPXTjl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_01,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250032
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running program with bpf-to-bpf function calls results in data access
exception (0x300) with the below call trace:

    [c000000000113f28] bpf_int_jit_compile+0x238/0x750 (unreliable)
    [c00000000037d2f8] bpf_check+0x2008/0x2710
    [c000000000360050] bpf_prog_load+0xb00/0x13a0
    [c000000000361d94] __sys_bpf+0x6f4/0x27c0
    [c000000000363f0c] sys_bpf+0x2c/0x40
    [c000000000032434] system_call_exception+0x164/0x330
    [c00000000000c1e8] system_call_vectored_common+0xe8/0x278

as bpf_int_jit_compile() tries writing to write protected JIT code
location during the extra pass.

Fix it by holding off write protection of JIT code until the extra
pass, where branch target addresses fixup happens.

Cc: stable@vger.kernel.org
Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index fcbf7a917c56..90ce75f0f1e2 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -241,8 +241,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	fp->jited_len = alloclen;
 
 	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
-	bpf_jit_binary_lock_ro(bpf_hdr);
 	if (!fp->is_func || extra_pass) {
+		bpf_jit_binary_lock_ro(bpf_hdr);
 		bpf_prog_fill_jited_linfo(fp, addrs);
 out_addrs:
 		kfree(addrs);
-- 
2.31.1

