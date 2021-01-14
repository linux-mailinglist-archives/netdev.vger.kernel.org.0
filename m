Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F952F5E26
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbhANJzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:55:55 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:38180 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727955AbhANJzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610618079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyzYIw7NfUmuq6pxj+o4aU3g1oORfJ4VWb8hDDDtUg4=;
        b=HzXFhgN4jQmWNnc8gfIktHTYEQ2a6dJK5FEm/IJi+G9qiSCZpXuKbd4UotkNDgpVdT1L+9
        YZy7Upte5EEIcbp1vZ/Vw5pvejThLLwHlUnG3dxK1Y8Vd4YxZxKA1k8isid+IFRXiJlVB4
        /JAimTVaw0B7srUvmmsOPCwXVYplyXI=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2058.outbound.protection.outlook.com [104.47.9.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-1iPPBbxuMqCSaH6Z9oNzjg-1; Thu, 14 Jan 2021 10:54:35 +0100
X-MC-Unique: 1iPPBbxuMqCSaH6Z9oNzjg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBjRVYzbOuUSEb7QuLeknbzw7tEwf5pIo5Vv5KfR36jwRgh0edK/oVy3kXxLtOe8E2jn3fkUQukNT5O0u+jWCYX8HcwOxfuV+R/orhxrxWJt0ilT2eVm5xApjrQLQWommCbz9L0Ys7DBZnjmWErkwAAz8N711mm1XeL9hkBhXXLbdE4nXboGu9wAXXHyR7IOKf4fVfq0Uv4bUYpfgFJLR5UQjkzphecseXGNxyLIGIJnUHl/u/OJSHSbGUO0lTXcJ6c9p5QXNFLANnwhvkfEGfQScYKqovcTyU8u1Fg2gHig6aIZ3St51O62yb+v/XsNB3f0+o7hbHUadc3Jx81Wtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TkexveZkO32PHmHYPbwsNz9YtroAOHbKCTQzOqvGgc=;
 b=F18kVqlqzZcfODB54OHZASOjXSJdePYkwxSgT9W2om3rrlrrqsQR7hCY3Xovd2CjcSKFta2eIr99YqW8NTJtFqNt/FufCAOVHU7EqWgPMo2Rl5oJSlbmUw4hZtZQgKyWdb51QKM/VgYryU6I8vGq52gKt0orYTZVX1VZkKG7mUqsktpvQVdP+4tM0iJTMfPMQDif8YOAr3WxBjRAk3pUkCaTLCFLyZ+ScGx/juP+9GR4UMpcQwPRgQ8mPKTolQIbT2KGl1L2KqLg0eMNnMbqLAU5+qXuiGf05KM11iU3cUuKg1/OXEOVz21wiGydL40ie+HfRwbxJ4u/uh8Y3mhNbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBBPR04MB6153.eurprd04.prod.outlook.com (2603:10a6:10:d2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Thu, 14 Jan
 2021 09:54:33 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 09:54:33 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v3 1/3] bpf,x64: pad NOPs to make images converge more easily
Date:   Thu, 14 Jan 2021 17:54:09 +0800
Message-ID: <20210114095411.20903-2-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114095411.20903-1-glin@suse.com>
References: <20210114095411.20903-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.145.171]
X-ClientProxiedBy: AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::28) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.145.171) by AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 09:54:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab824e8a-66d9-4a33-51f3-08d8b87264d1
X-MS-TrafficTypeDiagnostic: DBBPR04MB6153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB61536C5B6D7F5A95521BD796A9A80@DBBPR04MB6153.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANGDXzuJLyLAUaeZ2G1uabH/c2J15VSI6KUfNiAVXBrUVBOjTmDhOCboxofDzmcxkLa2ZZmDEy3zY97GidXwEIOGpG2w0t+D3J68AR30BgkHu6K5smM6mj3EMG2LkNBVnTudnLnKm3CbmMuG5SrOr/axSV7T8d2f7nMwq9ukE1YSkDlh9Sp6rapr+tAk+oxM3GV3baOPsOU3tYBaHFUiqrp6HM7cgwkngzXVQEWAsWbBQl0t4fGGaS+eWzRAjFC1/pfRS+U1pE0yXlP9+F63j8YrPi13JsenJkRWnsx0+xT5bjov0jCcXmpFxjQRMYhT2+13cx/vVuCjJj6sADSE7Ztq2IPrSndb+qtdVRW5I2ktNnEVL4eWNmalOLFcA33zTiXJgRWyboHY/yVqi1wTgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(39860400002)(366004)(316002)(83380400001)(1076003)(6486002)(2906002)(478600001)(52116002)(8676002)(5660300002)(186003)(110136005)(4326008)(107886003)(36756003)(6666004)(8936002)(16526019)(6506007)(66946007)(6512007)(956004)(26005)(2616005)(66476007)(54906003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7EA44FT2djXAPCcbCL4DuBWVbClHPMGe1tTf2Hm7pIQO1BREemVqTCPX/RE3?=
 =?us-ascii?Q?CvDc98I2/IsPmargA7XHbBQbxzg/UjuGWpi3WRkXmgvcdk16AVILMs5IbjTC?=
 =?us-ascii?Q?Oz3un4Pi0RY2UpxtSeynpo0oqkQery1VF0fSeMs+CTciv67c0VubdgjT6IBK?=
 =?us-ascii?Q?LupEljL6LeBItJsu6gZWDFyBNV2VWnGkOqjT09DhcglbUHL+0aBIUZA22J3Q?=
 =?us-ascii?Q?4CFOCm9ydIsLsYPma1NxJxQcgacz6uM/XCQDETGFxtu/pvVEsI0q0dJx/GdG?=
 =?us-ascii?Q?6MvXHtK6EJF3YMwvVeXHW94aP4snmV+7Tfe9f7mH2otCpxlOfgvqs10ynXvh?=
 =?us-ascii?Q?Z5DOuEtfojkSwXSP7T5uwK8M67I2ZuIehXo/F/lj1PpTUU7crmntqnqUlmYp?=
 =?us-ascii?Q?uf6WYa4TjiyvDaDNLe6AlSQQOk74jkxusfpLLRijJUUkUzG1L+F00uxhGsIh?=
 =?us-ascii?Q?5RSWMZjBbaSp22kO1uJoP7nH3sR3VRxD/sD2vzKrCoWlewYB5yFPPt5PONTp?=
 =?us-ascii?Q?v/VtccuvYbjbe8cJCR3bDQSqsiGDtwdgg9wyYspqBqkidLTugvmOFrRE1mXS?=
 =?us-ascii?Q?M2HS4oYOnOOUMlfLD/G/K9xuZbKgQZmSNiCxNLFjlwxJacJ7+Jhkdydj9PdZ?=
 =?us-ascii?Q?uTqF0iLOWSvZs4aaesmBAPL2IErx8OUo+eef2OzeihIo/xVJdbfCHlNnm0zJ?=
 =?us-ascii?Q?4GoiBxwHq8bumjGJJmEA+jeOIqGhaJrSw1mZ7muECBtvxtE8eqwj8pPUMBuR?=
 =?us-ascii?Q?2klWLm48W33gluHzbTfT8G2eBT7vRYgb8rJ04mRfxvb+EIlBTrFvQiX1Prd1?=
 =?us-ascii?Q?kbuFL9ZlEeYkm2lxtWBGGHnWn5ijMuBo0ykZMYmGeHf0UovRqRZ04z4+N/9P?=
 =?us-ascii?Q?+Owv1K/M8LM0PVhV9gPU7/u5C1kcnDdjz1sISBaPu8GxPZ8yuXhOekfYXxSC?=
 =?us-ascii?Q?5C6UbwWuu1+RaiodgKNjHgIgGkZV6iW1durUFmxB88TjvMiGFOkb4zqkelml?=
 =?us-ascii?Q?WXwa?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 09:54:32.9747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: ab824e8a-66d9-4a33-51f3-08d8b87264d1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfsE9/KmUSw+Y7HkHL3FAOXQN9yb46gfcSWyZdpoMS01MalaTVai+dEy/IS1EY8F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The x64 bpf jit expects bpf images converge within the given passes, but
it could fail to do so with some corner cases. For example:

      l0:     ja 40
      l1:     ja 40

        [... repeated ja 40 ]

      l39:    ja 40
      l40:    ret #0

This bpf program contains 40 "ja 40" instructions which are effectively
NOPs and designed to be replaced with valid code dynamically. Ideally,
bpf jit should optimize those "ja 40" instructions out when translating
the bpf instructions into x64 machine code. However, do_jit() can only
remove one "ja 40" for offset=3D=3D0 on each pass, so it requires at least
40 runs to eliminate those JMPs and exceeds the current limit of
passes(20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
is set even though it's legit as a classic socket filter.

To make bpf images more likely converge within 20 passes, this commit
pads some instructions with NOPs in the last 5 passes:

1. conditional jumps
  A possible size variance comes from the adoption of imm8 JMP. If the
  offset is imm8, we calculate the size difference of this BPF instruction
  between the previous and the current pass and fill the gap with NOPs.
  To avoid the recalculation of jump offset, those NOPs are inserted before
  the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
  calculating the NOP number.

2. BPF_JA
  There are two conditions for BPF_JA.
  a.) nop jumps
    If this instruction is not optimized out in the previous pass,
    instead of removing it, we insert the equivalent size of NOPs.
  b.) label jumps
    Similar to condition jumps, we prepend NOPs right before the JMP
    code.

To make the code concise, emit_nops() is modified to use the signed len and
return the number of inserted NOPs.

For bpf-to-bpf, we always enable padding for the extra pass since there
is only one extra run and the jump padding doesn't affected the images
that converge without padding.

After applying this patch, the corner case was loaded with the following
jit code:

    flen=3D45 proglen=3D77 pass=3D17 image=3Dffffffffc03367d4 from=3Djump p=
id=3D10097
    JIT code: 00000000: 0f 1f 44 00 00 55 48 89 e5 53 41 55 31 c0 45 31
    JIT code: 00000010: ed 48 89 fb eb 30 eb 2e eb 2c eb 2a eb 28 eb 26
    JIT code: 00000020: eb 24 eb 22 eb 20 eb 1e eb 1c eb 1a eb 18 eb 16
    JIT code: 00000030: eb 14 eb 12 eb 10 eb 0e eb 0c eb 0a eb 08 eb 06
    JIT code: 00000040: eb 04 eb 02 66 90 31 c0 41 5d 5b c9 c3

     0: 0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
     5: 55                      push   rbp
     6: 48 89 e5                mov    rbp,rsp
     9: 53                      push   rbx
     a: 41 55                   push   r13
     c: 31 c0                   xor    eax,eax
     e: 45 31 ed                xor    r13d,r13d
    11: 48 89 fb                mov    rbx,rdi
    14: eb 30                   jmp    0x46
    16: eb 2e                   jmp    0x46
        ...
    3e: eb 06                   jmp    0x46
    40: eb 04                   jmp    0x46
    42: eb 02                   jmp    0x46
    44: 66 90                   xchg   ax,ax
    46: 31 c0                   xor    eax,eax
    48: 41 5d                   pop    r13
    4a: 5b                      pop    rbx
    4b: c9                      leave
    4c: c3                      ret

At the 16th pass, 15 jumps were already optimized out, and one jump was
replaced with NOPs at 44 and the image converged at the 17th pass.

v3:
  - Copy the instructions of prologue separately or the size calculation
    of the first BPF instruction would include the prologue.
  - Replace WARN_ONCE() with pr_err() and EFAULT
  - Use MAX_PASSES in the for loop condition check
  - Remove the "padded" flag from x64_jit_data. For the extra pass of
    subprogs, padding is always enabled since it won't hurt the images
    that converge without padding.

v2:
  - Simplify the sample code in the description and provide the jit code
  - Check the expected padding bytes with WARN_ONCE
  - Move the 'padded' flag to 'struct x64_jit_data'

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 103 ++++++++++++++++++++++++++----------
 1 file changed, 75 insertions(+), 28 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..bb36f4117e9b 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -789,8 +789,31 @@ static void detect_reg_usage(struct bpf_insn *insn, in=
t insn_cnt,
 	}
 }
=20
+static int emit_nops(u8 **pprog, int len)
+{
+	u8 *prog =3D *pprog;
+	int i, noplen, cnt =3D 0;
+
+	while (len > 0) {
+		noplen =3D len;
+
+		if (noplen > ASM_NOP_MAX)
+			noplen =3D ASM_NOP_MAX;
+
+		for (i =3D 0; i < noplen; i++)
+			EMIT1(ideal_nops[noplen][i]);
+		len -=3D noplen;
+	}
+
+	*pprog =3D prog;
+
+	return cnt;
+}
+
+#define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
-		  int oldproglen, struct jit_context *ctx)
+		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
 {
 	bool tail_call_reachable =3D bpf_prog->aux->tail_call_reachable;
 	struct bpf_insn *insn =3D bpf_prog->insnsi;
@@ -800,7 +823,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs=
, u8 *image,
 	bool seen_exit =3D false;
 	u8 temp[BPF_MAX_INSN_SIZE + BPF_INSN_SAFETY];
 	int i, cnt =3D 0, excnt =3D 0;
-	int proglen =3D 0;
+	int ilen, proglen =3D 0;
 	u8 *prog =3D temp;
=20
 	detect_reg_usage(insn, insn_cnt, callee_regs_used,
@@ -813,7 +836,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addr=
s, u8 *image,
 		      bpf_prog_was_classic(bpf_prog), tail_call_reachable,
 		      bpf_prog->aux->func_idx !=3D 0);
 	push_callee_regs(&prog, callee_regs_used);
-	addrs[0] =3D prog - temp;
+
+	ilen =3D prog - temp;
+	if (image)
+		memcpy(image + proglen, temp, ilen);
+	proglen +=3D ilen;
+	addrs[0] =3D proglen;
+	prog =3D temp;
=20
 	for (i =3D 1; i <=3D insn_cnt; i++, insn++) {
 		const s32 imm32 =3D insn->imm;
@@ -822,8 +851,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs=
, u8 *image,
 		u8 b2 =3D 0, b3 =3D 0;
 		s64 jmp_offset;
 		u8 jmp_cond;
-		int ilen;
 		u8 *func;
+		int nops;
=20
 		switch (insn->code) {
 			/* ALU */
@@ -1409,6 +1438,15 @@ xadd:			if (is_imm8(insn->off))
 			}
 			jmp_offset =3D addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					nops =3D INSN_SZ_DIFF - 2;
+					if (nops !=3D 0 && nops !=3D 4) {
+						pr_err("unexpected cond_jmp padding: %d bytes\n",
+						       nops);
+						return -EFAULT;
+					}
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
@@ -1431,11 +1469,33 @@ xadd:			if (is_imm8(insn->off))
 			else
 				jmp_offset =3D addrs[i + insn->off] - addrs[i];
=20
-			if (!jmp_offset)
-				/* Optimize out nop jumps */
+			if (!jmp_offset) {
+				/*
+				 * If jmp_padding is enabled, the extra nops will
+				 * be inserted. Otherwise, optimize out nop jumps.
+				 */
+				if (jmp_padding) {
+					nops =3D INSN_SZ_DIFF;
+					if (nops !=3D 0 && nops !=3D 2 && nops !=3D 5) {
+						pr_err("unexpected nop jump padding: %d bytes\n",
+						       nops);
+						return -EFAULT;
+					}
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				break;
+			}
 emit_jmp:
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					nops =3D INSN_SZ_DIFF - 2;
+					if (nops !=3D 0 && nops !=3D 3) {
+						pr_err("unexpected jump padding: %d bytes\n",
+						       nops);
+						return -EFAULT;
+					}
+					cnt +=3D emit_nops(&prog, INSN_SZ_DIFF - 2);
+				}
 				EMIT2(0xEB, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT1_off32(0xE9, jmp_offset);
@@ -1578,26 +1638,6 @@ static int invoke_bpf_prog(const struct btf_func_mod=
el *m, u8 **pprog,
 	return 0;
 }
=20
-static void emit_nops(u8 **pprog, unsigned int len)
-{
-	unsigned int i, noplen;
-	u8 *prog =3D *pprog;
-	int cnt =3D 0;
-
-	while (len > 0) {
-		noplen =3D len;
-
-		if (noplen > ASM_NOP_MAX)
-			noplen =3D ASM_NOP_MAX;
-
-		for (i =3D 0; i < noplen; i++)
-			EMIT1(ideal_nops[noplen][i]);
-		len -=3D noplen;
-	}
-
-	*pprog =3D prog;
-}
-
 static void emit_align(u8 **pprog, u32 align)
 {
 	u8 *target, *prog =3D *pprog;
@@ -1972,6 +2012,9 @@ struct x64_jit_data {
 	struct jit_context ctx;
 };
=20
+#define MAX_PASSES 20
+#define PADDING_PASSES (MAX_PASSES - 5)
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -1981,6 +2024,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	struct jit_context ctx =3D {};
 	bool tmp_blinded =3D false;
 	bool extra_pass =3D false;
+	bool padding =3D false;
 	u8 *image =3D NULL;
 	int *addrs;
 	int pass;
@@ -2017,6 +2061,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 		image =3D jit_data->image;
 		header =3D jit_data->header;
 		extra_pass =3D true;
+		padding =3D true;
 		goto skip_init_addrs;
 	}
 	addrs =3D kmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
@@ -2042,8 +2087,10 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog=
 *prog)
 	 * may converge on the last pass. In such case do one more
 	 * pass to emit the final image.
 	 */
-	for (pass =3D 0; pass < 20 || image; pass++) {
-		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
+	for (pass =3D 0; pass < MAX_PASSES || image; pass++) {
+		if (!padding && pass >=3D PADDING_PASSES)
+			padding =3D true;
+		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx, padding);
 		if (proglen <=3D 0) {
 out_image:
 			image =3D NULL;
--=20
2.29.2

