Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC5D2FB8D7
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405978AbhASNtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:49:06 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:28714 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390572AbhASKa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:30:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611052140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nhWA5JxYXlHyY8G9GP9kKMoeAua8zPUto7O7q9ccu4c=;
        b=W9VvWW3N27N6136os0ea6KeR0ZXs0fPXubbi9vmI6A+OwZaXtz+3OIOaA0kJ+A/Rd/em3W
        9tlKoMJ07SmD6sPHdImeDJ9+PoJUtHtz+HEfc+4NY3IKdnC/0q6O4Thcz7aXb0LVK9EUL9
        YH2/5M8yYjI2ecSmDu1/ndL6WYBxsOQ=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2051.outbound.protection.outlook.com [104.47.6.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-dvSWzTAQP3eGMi-8I9tbQg-1; Tue, 19 Jan 2021 11:25:35 +0100
X-MC-Unique: dvSWzTAQP3eGMi-8I9tbQg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOdEGCkJKTJjsm9lJCdZXa0S86/Te0U9PGm+TvaMDmUxoTKWsbXj0gZABLJpnU+PXaheeX3xW5bx6O7GT/+0HfkYuYToWcpPWVzIxIUUmjBc8ViLpn655V8uLHjIT7t3MwGKYDe+FKDNFiWEVwnwlABsMydK9a4aLYYuF7utzxbVWsJKpeTn1fQ0HxQq1KNUTwubhn8PZrhPRYWJNtQnajq9Gv4rY+xV0d65GzDGhTaB+6lXmlWPHVdV3jAT3Kf2GiSo6/NEzdcx4Rx/WvkdwmXhI5OBTuFZ2eaYYvz9vd7WCUMawrCvHFNIkiqNUH9NXJ7J35y6nnp9jrAAnW2lUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ustf11rjWTfbLqoyEYFfYL0TMSoEMf15WGLRvDebExs=;
 b=oN4K26ZqDTKmnLuftCsbynFJHgRtzDIqG1fLYPxo4LlkZqZDUtJwInmbA30G04EaF0nAR72XaObNnxvAaVrA44DsKPyr7SmOTvOGMU4LT9RPbaBHGeD0dQTackkdY++kaCiAI+Nc8IYDMIoLYG13WJk9FrpnAfilysmXPQh8SV9f5wK4BjOcd0PEK1+kTCdWZubzGxEoezxTkGIMdWKvV+DRTSf+jv/Yon0Vf5FvoRgcCNwrPM8RJffQmHPErMGzxRoNdJmW3N02EpHmftsX1A0QiwsR2XTglDrwoV8kUHymtJnSsXjeDqgsUELVRJjSx4vlhcwSuiiXJPeb+VhA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBBPR04MB7964.eurprd04.prod.outlook.com (2603:10a6:10:1e9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 10:25:33 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 10:25:33 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v4 3/3] selftests/bpf: Add verifier tests for x64 jit jump padding
Date:   Tue, 19 Jan 2021 18:25:01 +0800
Message-ID: <20210119102501.511-4-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119102501.511-1-glin@suse.com>
References: <20210119102501.511-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.113.126]
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.113.126) by FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Tue, 19 Jan 2021 10:25:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ccc1452-ac5a-4829-c2c0-08d8bc648d99
X-MS-TrafficTypeDiagnostic: DBBPR04MB7964:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7964019FF1AB65FBCC001DC4A9A30@DBBPR04MB7964.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7ENsDMOtGTuh1nKdAAG3fpM6jT5dy0yHc71pLv8sUXWRSyghYjeg8T/5mhHLgDSHJ6hqB4BUeADq/4poUGywl+R1OruQJoVaNha3IDLWH7iusKQLyU/uk5SwcLgT3epUjdtxcrSjVT66Dyb2pcfYFVhOCdX7HmPGle5p9iZvIrIu4k8zbF3VKG53ZJGZJxQWhn1YcnNUkwih0lYwS7FWqnNKhks4MDxYCglkO3/RLf/NF6/n/w2kSSLdQ/uylunKV8KplvMs1/VCGTkT0REXM1AMgYRwMiAQY/N5Nj1s92odYbxjGEYzF6dSRzM+9IMmIJU9qarkVTvL8XEP96Ugq8aEyZc4Rf/opUakdAb0+WOk8pCqIx0bCVEjaOlleo+b34a+ydWxVaS8A+QDrYT6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(6666004)(2906002)(36756003)(6486002)(316002)(110136005)(52116002)(8676002)(186003)(1076003)(2616005)(16526019)(86362001)(956004)(5660300002)(66476007)(6512007)(4326008)(26005)(6506007)(66556008)(107886003)(8936002)(66946007)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gS8xm+IzptgIrz9A9XtfShwt+1U8aJL0tviLS24OI5Rz40HZSDBljmlJr3G2?=
 =?us-ascii?Q?70GnBK01h0mqk+bL9rQIfVpow26LJnLHWbEln8jxoyEFIVAQVbjoaHTPejpD?=
 =?us-ascii?Q?GY2GFjMKrNT8kM5wRv4HL0AoBpERRqBryikQwY0lUQCr8OoaKtv5pOxqpKtu?=
 =?us-ascii?Q?fpIgW2B8dlmFXlmw19vVBJslsDhbiPOTDPkQZqxmED2CAt2axUf2qKdPC4mE?=
 =?us-ascii?Q?G0D7RZPt9RV9+dpZgo8q3HpeMp9btO8nXzgLVqRceTIxnAOYm8rs+X6q+iNz?=
 =?us-ascii?Q?96Pzu16+3MAngwpNnc2u7J7p3Sh3BhhrzZbPtOHr5RvO2PgjnWN/8eSPux0X?=
 =?us-ascii?Q?x1DwCXlimb5MR1lOKM1qCBWAsUnhsplZ/zou0J9xl/Uz/52vNV7YspY9Ld4d?=
 =?us-ascii?Q?pX+3W0AXBhZ5F5t9TDp9jyYvVKPyPjXbFbhi+4pFNjb8CxV4Ia4/Q7De5dba?=
 =?us-ascii?Q?yprYLxrqEMglAGSFC+MPXQxrSnkNvW7JsnVf0D7hzxq2QIwJvcV7hPttvyYw?=
 =?us-ascii?Q?UzoBJ2Dmi4GejdlwbFvpCMKe5w8BZxgFOJMIWBHFwwCLGXzh9iv8hDNwNJ8b?=
 =?us-ascii?Q?vX5iFBmjKF6ucMP+5NOIo5Y5exuc0JCMpgWRt3MkkprZX0gATu0QQdlJzSMV?=
 =?us-ascii?Q?PaIQy7aog6xxBzG4jJIuemfW1qNp8hPYb/0uubwCRwRqZloVybJffva9S5DC?=
 =?us-ascii?Q?PO6umOkpFYjwj31iDgJF37BzalG9Zi7UWeZKzwdWTW+BzNHasexQSqc3KBIw?=
 =?us-ascii?Q?r/m7AO42ssRk2Ge7h2eXmEoWoPTwcaHR/FXTcJUk+/5yZpNsODCG1rkzG52d?=
 =?us-ascii?Q?eiRINvj7knfvGcKIaZjHtPxTCNeYNQocWk90m0TeOrEoLAexA2kEDUanX8Qm?=
 =?us-ascii?Q?vFfgXvJmMHcV1ZEqyIkX6GaT5p4yf00kyp1fnoOZ6UBKCYrK2gFmwDwhUofc?=
 =?us-ascii?Q?rF3I0qca5P7UKNw/2+Wib/WyXAIsZCcQ6VzICUo5ikY9eWvgfjUqUQRIZV6R?=
 =?us-ascii?Q?1lMI?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ccc1452-ac5a-4829-c2c0-08d8bc648d99
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 10:25:33.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9w3ha7H/JVvfy1xM+fBcWJPoBzVvLJDYrt89yhOORdtKU4IIcfdnASRkT/e941x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7964
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 3 tests added into verifier's jit tests to trigger x64
jit jump padding.

The first test can be represented as the following assembly code:

      1: bpf_call bpf_get_prandom_u32
      2: if r0 =3D=3D 1 goto pc+128
      3: if r0 =3D=3D 2 goto pc+128
         ...
    129: if r0 =3D=3D 128 goto pc+128
    130: goto pc+128
    131: goto pc+127
         ...
    256: goto pc+2
    257: goto pc+1
    258: r0 =3D 1
    259: ret

We first store a random number to r0 and add the corresponding
conditional jumps (2~129) to make verifier believe that those jump
instructions from 130 to 257 are reachable. When the program is sent to
x64 jit, it starts to optimize out the NOP jumps backwards from 257.
Since there are 128 such jumps, the program easily reaches 15 passes and
triggers jump padding.

Here is the x64 jit code of the first test:

      0:    0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
      5:    66 90                   xchg   ax,ax
      7:    55                      push   rbp
      8:    48 89 e5                mov    rbp,rsp
      b:    e8 4c 90 75 e3          call   0xffffffffe375905c
     10:    48 83 f8 01             cmp    rax,0x1
     14:    0f 84 fe 04 00 00       je     0x518
     1a:    48 83 f8 02             cmp    rax,0x2
     1e:    0f 84 f9 04 00 00       je     0x51d
      ...
     f6:    48 83 f8 18             cmp    rax,0x18
     fa:    0f 84 8b 04 00 00       je     0x58b
    100:    48 83 f8 19             cmp    rax,0x19
    104:    0f 84 86 04 00 00       je     0x590
    10a:    48 83 f8 1a             cmp    rax,0x1a
    10e:    0f 84 81 04 00 00       je     0x595
      ...
    500:    0f 84 83 01 00 00       je     0x689
    506:    48 81 f8 80 00 00 00    cmp    rax,0x80
    50d:    0f 84 76 01 00 00       je     0x689
    513:    e9 71 01 00 00          jmp    0x689
    518:    e9 6c 01 00 00          jmp    0x689
      ...
    5fe:    e9 86 00 00 00          jmp    0x689
    603:    e9 81 00 00 00          jmp    0x689
    608:    0f 1f 00                nop    DWORD PTR [rax]
    60b:    eb 7c                   jmp    0x689
    60d:    eb 7a                   jmp    0x689
      ...
    683:    eb 04                   jmp    0x689
    685:    eb 02                   jmp    0x689
    687:    66 90                   xchg   ax,ax
    689:    b8 01 00 00 00          mov    eax,0x1
    68e:    c9                      leave
    68f:    c3                      ret

As expected, a 3 bytes NOPs is inserted at 608 due to the transition
from imm32 jmp to imm8 jmp. A 2 bytes NOPs is also inserted at 687 to
replace a NOP jump.

The second test case is tricky. Here is the assembly code:

       1: bpf_call bpf_get_prandom_u32
       2: if r0 =3D=3D 1 goto pc+2048
       3: if r0 =3D=3D 2 goto pc+2048
       ...
    2049: if r0 =3D=3D 2048 goto pc+2048
    2050: goto pc+2048
    2051: goto pc+16
    2052: goto pc+15
       ...
    2064: goto pc+3
    2065: goto pc+2
    2066: goto pc+1
       ...
       [repeat "goto pc+16".."goto pc+1" 127 times]
       ...
    4099: r0 =3D 2
    4100: ret

There are 4 major parts of the program.
1) 1~2049: Those are instructions to make 2050~4098 reachable. Some of
           them also could generate the padding for jmp_cond.
2) 2050: This is the target instruction for the imm32 nop jmp padding.
3) 2051~4098: The repeated "goto 1~16" instructions are designed to be
              consumed by the nop jmp optimization. In the end, those
              instrucitons become 128 continuous 0 offset jmp and are
              optimized out in 1 pass, and this make insn 2050 an imm32
              nop jmp in the next pass, so that we can trigger the
              5 bytes padding.
4) 4099~4100: Those are the instructions to end the program.

The x64 jit code is like this:

       0:       0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
       5:       66 90                   xchg   ax,ax
       7:       55                      push   rbp
       8:       48 89 e5                mov    rbp,rsp
       b:       e8 bc 7b d5 d3          call   0xffffffffd3d57bcc
      10:       48 83 f8 01             cmp    rax,0x1
      14:       0f 84 7e 66 00 00       je     0x6698
      1a:       48 83 f8 02             cmp    rax,0x2
      1e:       0f 84 74 66 00 00       je     0x6698
      24:       48 83 f8 03             cmp    rax,0x3
      28:       0f 84 6a 66 00 00       je     0x6698
      2e:       48 83 f8 04             cmp    rax,0x4
      32:       0f 84 60 66 00 00       je     0x6698
      38:       48 83 f8 05             cmp    rax,0x5
      3c:       0f 84 56 66 00 00       je     0x6698
      42:       48 83 f8 06             cmp    rax,0x6
      46:       0f 84 4c 66 00 00       je     0x6698
      ...
    666c:       48 81 f8 fe 07 00 00    cmp    rax,0x7fe
    6673:       0f 1f 40 00             nop    DWORD PTR [rax+0x0]
    6677:       74 1f                   je     0x6698
    6679:       48 81 f8 ff 07 00 00    cmp    rax,0x7ff
    6680:       0f 1f 40 00             nop    DWORD PTR [rax+0x0]
    6684:       74 12                   je     0x6698
    6686:       48 81 f8 00 08 00 00    cmp    rax,0x800
    668d:       0f 1f 40 00             nop    DWORD PTR [rax+0x0]
    6691:       74 05                   je     0x6698
    6693:       0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
    6698:       b8 02 00 00 00          mov    eax,0x2
    669d:       c9                      leave
    669e:       c3                      ret

Since insn 2051~4098 are optimized out right before the padding pass,
there are several conditional jumps from the first part are replaced with
imm8 jmp_cond, and this triggers the 4 bytes padding, for example at
6673, 6680, and 668d. On the other hand, Insn 2050 is replaced with the
5 bytes nops at 6693.

The third test is to invoke the first and second tests as subprogs to test
bpf2bpf. Per the system log, there was one more jit happened with only
one pass and the same jit code was produced.

v4:
  - Add the second test case which triggers jmp_cond padding and imm32 nop
    jmp padding.
  - Add the new test case as another subprog

Signed-off-by: Gary Lin <glin@suse.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 72 +++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/jit.c  | 24 +++++++
 2 files changed, 96 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/se=
lftests/bpf/test_verifier.c
index 777a81404fdb..e0e65ff30a2d 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -296,6 +296,78 @@ static void bpf_fill_scale(struct bpf_test *self)
 	}
 }
=20
+static int bpf_fill_torturous_jumps_insn_1(struct bpf_insn *insn)
+{
+	unsigned int len =3D 259, hlen =3D 128;
+	int i;
+
+	insn[0] =3D BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32);
+	for (i =3D 1; i <=3D hlen; i++) {
+		insn[i]        =3D BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, i, hlen);
+		insn[i + hlen] =3D BPF_JMP_A(hlen - i);
+	}
+	insn[len - 2] =3D BPF_MOV64_IMM(BPF_REG_0, 1);
+	insn[len - 1] =3D BPF_EXIT_INSN();
+
+	return len;
+}
+
+static int bpf_fill_torturous_jumps_insn_2(struct bpf_insn *insn)
+{
+	unsigned int len =3D 4100, jmp_off =3D 2048;
+	int i, j;
+
+	insn[0] =3D BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32);
+	for (i =3D 1; i <=3D jmp_off; i++) {
+		insn[i] =3D BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, i, jmp_off);
+	}
+	insn[i++] =3D BPF_JMP_A(jmp_off);
+	for (; i <=3D jmp_off * 2 + 1; i+=3D16) {
+		for (j =3D 0; j < 16; j++) {
+			insn[i + j] =3D BPF_JMP_A(16 - j - 1);
+		}
+	}
+
+	insn[len - 2] =3D BPF_MOV64_IMM(BPF_REG_0, 2);
+	insn[len - 1] =3D BPF_EXIT_INSN();
+
+	return len;
+}
+
+static void bpf_fill_torturous_jumps(struct bpf_test *self)
+{
+	struct bpf_insn *insn =3D self->fill_insns;
+	int i =3D 0;
+
+	switch (self->retval) {
+	case 1:
+		self->prog_len =3D bpf_fill_torturous_jumps_insn_1(insn);
+		return;
+	case 2:
+		self->prog_len =3D bpf_fill_torturous_jumps_insn_2(insn);
+		return;
+	case 3:
+		/* main */
+		insn[i++] =3D BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 4);
+		insn[i++] =3D BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 262);
+		insn[i++] =3D BPF_ST_MEM(BPF_B, BPF_REG_10, -32, 0);
+		insn[i++] =3D BPF_MOV64_IMM(BPF_REG_0, 3);
+		insn[i++] =3D BPF_EXIT_INSN();
+
+		/* subprog 1 */
+		i +=3D bpf_fill_torturous_jumps_insn_1(insn + i);
+
+		/* subprog 2 */
+		i +=3D bpf_fill_torturous_jumps_insn_2(insn + i);
+
+		self->prog_len =3D i;
+		return;
+	default:
+		self->prog_len =3D 0;
+		break;
+	}
+}
+
 /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
 #define BPF_SK_LOOKUP(func)						\
 	/* struct bpf_sock_tuple tuple =3D {} */				\
diff --git a/tools/testing/selftests/bpf/verifier/jit.c b/tools/testing/sel=
ftests/bpf/verifier/jit.c
index c33adf344fae..df215e004566 100644
--- a/tools/testing/selftests/bpf/verifier/jit.c
+++ b/tools/testing/selftests/bpf/verifier/jit.c
@@ -105,3 +105,27 @@
 	.result =3D ACCEPT,
 	.retval =3D 2,
 },
+{
+	"jit: torturous jumps, imm8 nop jmp and pure jump padding",
+	.insns =3D { },
+	.fill_helper =3D bpf_fill_torturous_jumps,
+	.prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
+	.result =3D ACCEPT,
+	.retval =3D 1,
+},
+{
+	"jit: torturous jumps, imm32 nop jmp and jmp_cond padding",
+	.insns =3D { },
+	.fill_helper =3D bpf_fill_torturous_jumps,
+	.prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
+	.result =3D ACCEPT,
+	.retval =3D 2,
+},
+{
+	"jit: torturous jumps in subprog",
+	.insns =3D { },
+	.fill_helper =3D bpf_fill_torturous_jumps,
+	.prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
+	.result =3D ACCEPT,
+	.retval =3D 3,
+},
--=20
2.29.2

