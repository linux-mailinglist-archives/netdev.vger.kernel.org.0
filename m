Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6372DDF3B
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 08:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732619AbgLRHuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 02:50:52 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:32127 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgLRHuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 02:50:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608277782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvaFd6Z+80ZtUFursgBKsjyF4xxA0kZkZVxgCS0kX7M=;
        b=TPnBtCyxhwx9EgKoMuFCua0G0HlDg4ONXtrtsSCkCKJ9vMmafPk+QRJ/wU5nxjzg+CKaox
        QyFj+f7aPodhK4cc4BCGWIomyOkiammq2LrW4CsPrBgsaouLfRA7ICn3m1Yw9cnDOsMVzN
        ApHZNuSW/yOdY4teOPw0/iDliOPcaYk=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2058.outbound.protection.outlook.com [104.47.8.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-ApLUk3yUNryKEhi7sgyOxw-2; Fri, 18 Dec 2020 08:49:40 +0100
X-MC-Unique: ApLUk3yUNryKEhi7sgyOxw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPyAH8F6X4IiCAFH3llnh4zwGmjzLl/1Ho0buoWyVkQoWXzKhhiBdR000w6FWBLaOoQ7EgRUebjiKsZWIuF+IRKNACwYGK5IinQqZP603UriCTPHnNbWYsOM9nBBb5ZTbDLTXZlayeAzQWE3RF1FulkdZJ0ghhSGhOpHk7wV/SaWk5/rftyvg5Fq9bpHEdlsID9KN8bWwunfp2019n1CrEIVSo/MzC6yBqQ9XIlzPMjvwph+6NdKQ5kwyqXTPKBWsPmwYUh0cQClhoDaQOsrHo5aQWfUQQe+Nu6HdU8dcFIRc3ajOsLb1pXrcLqVezpsq17AgJ+uJv4hdQuZGUdDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yETduEdU0SRv4WXZ967bogU3r/b/oqU+4NpCx+Y/oPg=;
 b=E2Npt5jk08065NTtzOyz+bCRynxrbwAcrECb3MTpkJ6QYTMxQI27NBusQtWO6kCiDGvBKXtg5/IPqy8OTMeXABKU386XGiKSFAXVaVWXcGMMF9Sh94j6th2KyOqYP+CHU/+YwZyAiIaVPbhig4c6458EqvzfBr8VR1MctAV7f0UG8EdVonrWr/5cD5NpjZzKf1vOeGiKN8BKEDb5pm1riVW9t2/wUPtFgtr3H5lfZ4WbudHQwsZ9xhiQp7MNALV1Kq1MdZEdatzql6cJnEFBN3KF0F6cr7nX872XrfDt/UrIK+fEUMBysoJGmxA0qqcKXxmp0Am4IcOnV4VHK/U8CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB5755.eurprd04.prod.outlook.com (2603:10a6:10:ac::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Fri, 18 Dec
 2020 07:49:34 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 07:49:34 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v2 1/3] bpf,x64: pad NOPs to make images converge more easily
Date:   Fri, 18 Dec 2020 15:49:13 +0800
Message-ID: <20201218074915.22242-2-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201218074915.22242-1-glin@suse.com>
References: <20201218074915.22242-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.227.5.136]
X-ClientProxiedBy: AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::17) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (36.227.5.136) by AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 07:49:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a14c82e6-f067-4587-35eb-08d8a329764c
X-MS-TrafficTypeDiagnostic: DB8PR04MB5755:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB57558236A1CD2211B06AC62AA9C30@DB8PR04MB5755.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vU4oifLnwkDefRnsjHr62sRmEM7cNe5UEvcQckPwDzS1C5ZLIIlpCzY63cb/j42PRFL4g1nzTMRPiNacLHcO/1tzopRvss2lWNHkJb9e1pKavdinW0qk57LjdpHv2Xp44h7eHtAG3p/gW/Xi1x8VpkU7UNFOtaY2TqqKTrQi82MWUToj1zsKhxYAxNxzRJcXe4L2pIVxbUUR67PR75kiX8/MHg5kak258OYWOKs0S73rrXOh3qeUT/d0B7yfuCrFpT6DhIuSkA0piwdd7Ze5sjqlSC+vaPVTwvMjjiGZxmCIp+Zp21gfNMBcCt/7ABSv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(6506007)(83380400001)(956004)(54906003)(66556008)(66946007)(52116002)(186003)(2906002)(66476007)(2616005)(26005)(8936002)(107886003)(86362001)(1076003)(16526019)(6486002)(4326008)(8676002)(6512007)(5660300002)(6666004)(478600001)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?P41RAyq/9pp3wQT5xR/AhgAsf8GMeTknsWMih4KgbhXthCscAjJiSdc22U/n?=
 =?us-ascii?Q?l3PHfzHSTwQL4WfNK0YWkYp2PLeW+fqwoKIAujHDwzTAZW0M5cPkrmdnvu4I?=
 =?us-ascii?Q?tHWEt1BLvH+hC6hYdWTMPGRc9EvbJHMdqwiolIJKGmjWkaxIPAsM3nJUBhzk?=
 =?us-ascii?Q?/i7Jdtfkl/Ww6RPk10BWCMiapmJA99gd0+kClIZXMKJhH/YoP3NNrcOrxBm9?=
 =?us-ascii?Q?O5W6ZZsHoHbBD9G/c2h/vJrksIlYuZTsS3zDCShUg8saxqk9mUkGcxSbgAUe?=
 =?us-ascii?Q?bH2Q8ghZGUjvZWLgQfDnxnUNWsNg4yZ3++j94lW9r3TI2S24BPEVSbKknhuk?=
 =?us-ascii?Q?inNMwNR+eMQedkrCsq6FHcJ1K480RjjHO8YFYDzN9IYevsQbKvLGdwPjJh4y?=
 =?us-ascii?Q?ogmZfr7oFMp4zG2mYXPogLosGk1r5H2DVkiOEgpjy9RMBcIBavIEy+9Zjt1w?=
 =?us-ascii?Q?xayi2F2njCHH7U1RPr2f0WM7pNHISJH5kxjGg31tT1Sm9M9yePwiZnv7XnKZ?=
 =?us-ascii?Q?fp6D7c3i8MVHXEfXwFajH43VnxEnzT0LjuSTexrIrJqvYzThTM8xhN0EUyp7?=
 =?us-ascii?Q?Nh/p3lJuK+bPianf3gbA63qi16LWfp6ekEoFBPd+byAuxBsC7bTu1j9h24vk?=
 =?us-ascii?Q?nK1nkviZFQCm87SkLNQjbvbPA2B1mHb3LVUfpeFpiRKXWr+nGhpoXb33YKa9?=
 =?us-ascii?Q?SozQNCiWdmTxwAANxmsWkFeq44ibT30cC7WsBPFRQbudB54rAV2VBYpkM2Nu?=
 =?us-ascii?Q?EGkMqBw2Hm0J9FuBWS8NHYfa22Uk28BYQ9V1MiFhU3Gh6f3ww2xH3fWnupql?=
 =?us-ascii?Q?tfXApX5yorR/8WgF4Rq8Uhc3A8UdwEkJ5dT/Zi447hpuYuJDGt8k3Z4u8hu0?=
 =?us-ascii?Q?ymfD6cnp39nbEbwyR9j6f6eQWUzLHGpzrSa4bUnKdPJjpdNf0wHRdhLr+NQp?=
 =?us-ascii?Q?FREJiLvI0JD0X+11yozw4nKXGmh5YRJxqptiig8b/rI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 07:49:34.5798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: a14c82e6-f067-4587-35eb-08d8a329764c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtzSN9wPbx3nH8vQqDUs2Nx01MFGMtDJ17LQ9RpqpuByor47tSPpB1jFHRDy3bt/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5755
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

For bpf-to-bpf, the 'padded' flag is introduced to 'struct x64_jit_data' so
that bpf_int_jit_compile() could know whether the program is padded in the
previous run or not.

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

v2:
  - Simplify the sample code in the description and provide the jit code
  - Check the expected padding bytes with WARN_ONCE
  - Move the 'padded' flag to 'struct x64_jit_data'

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 86 ++++++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 24 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..9ecc1fd72b67 100644
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
@@ -824,6 +847,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs=
, u8 *image,
 		u8 jmp_cond;
 		int ilen;
 		u8 *func;
+		int nops;
=20
 		switch (insn->code) {
 			/* ALU */
@@ -1409,6 +1433,13 @@ xadd:			if (is_imm8(insn->off))
 			}
 			jmp_offset =3D addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					nops =3D INSN_SZ_DIFF - 2;
+					WARN_ONCE((nops !=3D 0 && nops !=3D 4),
+						  "unexpected cond_jmp padding: %d bytes\n",
+						  nops);
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
@@ -1431,11 +1462,29 @@ xadd:			if (is_imm8(insn->off))
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
+					WARN_ONCE((nops !=3D 0 && nops !=3D 2 && nops !=3D 5),
+						  "unexpected nop jump padding: %d bytes\n",
+						  nops);
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				break;
+			}
 emit_jmp:
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					nops =3D INSN_SZ_DIFF - 2;
+					WARN_ONCE((nops !=3D 0 && nops !=3D 3),
+						  "unexpected jump padding: %d bytes\n",
+						  nops);
+					cnt +=3D emit_nops(&prog, INSN_SZ_DIFF - 2);
+				}
 				EMIT2(0xEB, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT1_off32(0xE9, jmp_offset);
@@ -1578,26 +1627,6 @@ static int invoke_bpf_prog(const struct btf_func_mod=
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
@@ -1970,8 +1999,12 @@ struct x64_jit_data {
 	u8 *image;
 	int proglen;
 	struct jit_context ctx;
+	bool padded;
 };
=20
+#define MAX_PASSES 20
+#define PADDING_PASSES (MAX_PASSES - 5)
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -1981,6 +2014,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	struct jit_context ctx =3D {};
 	bool tmp_blinded =3D false;
 	bool extra_pass =3D false;
+	bool padding =3D false;
 	u8 *image =3D NULL;
 	int *addrs;
 	int pass;
@@ -2010,6 +2044,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 		}
 		prog->aux->jit_data =3D jit_data;
 	}
+	padding =3D jit_data->padded;
 	addrs =3D jit_data->addrs;
 	if (addrs) {
 		ctx =3D jit_data->ctx;
@@ -2043,7 +2078,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	 * pass to emit the final image.
 	 */
 	for (pass =3D 0; pass < 20 || image; pass++) {
-		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
+		if (!padding && pass >=3D PADDING_PASSES)
+			padding =3D true;
+		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx, padding);
 		if (proglen <=3D 0) {
 out_image:
 			image =3D NULL;
@@ -2097,6 +2134,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 			jit_data->proglen =3D proglen;
 			jit_data->image =3D image;
 			jit_data->header =3D header;
+			jit_data->padded =3D padding;
 		}
 		prog->bpf_func =3D (void *)image;
 		prog->jited =3D 1;
--=20
2.29.2

