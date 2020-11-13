Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C512B176B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgKMIjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:39:25 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:60803 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgKMIjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 03:39:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605256761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WWpbBqfKuGd2K6RnF+MTDL+1VI1DGMZ+u0+6hNJ8SHQ=;
        b=mmiyxN9Fs9lYk+aAuNyt5Ub/eyyCcR9DTr9Z+kTNPro+HbPPbWEalGyfww5zryUBRJS6u2
        KW9zrQGywixz3DV8BwkK24iQyI8r6gnGwsTk0XbdoI+ABNe/v4/SRVt+79zd9gECuhfTSM
        cwS96lYOEyFSORCgNygygDQDEC9vHek=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-7_jcavCrO8-reddAroZBlg-1; Fri, 13 Nov 2020 09:39:19 +0100
X-MC-Unique: 7_jcavCrO8-reddAroZBlg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEGtUM7++NxLXsMKy9/AQv+N6uXcvDBc+dXCcIPyzGHF3MphXVgHSkq1HigczS1ckrNeWnsmg7BGJ131BvoafhJy7DC7biHb3/X6LRLbSWKMdJ0TBaIG8pTMsR6uoSXQEI92diZ7VvVSpn4TABu5jsrL7sifAN+Q6OVNtZfy30AcqCKvQxIZhqOLPn/EOQVbQfrhZOrRYlW8A9OZdA31oQ6SDc6O8iBcJgqZn0ja4vLXj48ZBV7lDTiA+Ti2geGJSn5z+fHmXNeSQJQCC/tEhi+Kjfm4TALkrQSVMTUQWBMkJlZcVGQdzG4xXJytsldPDX/3sKZwayAKXJRbbA+Pjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYaLrSBfx3edWy40um+qZanpNsDwYLxdh2LtlemenTU=;
 b=S7vPDs2JPlxm7/ZPpIOByp4XEiEL9EYgYMnLylpwqR2RlWsqT73kcOG8SMQSFH+nkh8F7EFdvUpbtExl8hDn37aH7YIxp502/O/j945KsKB/t2c3Efjn9jb5NSN5gOiDlYNpfOPpqY4KXR1H4HEJ/HmBaLR0YGx9Z8GNqfl49HHKAEy0rHj0JCXrE1hIm+5KQ4dBXybSFEBfkmHweH67vBeTKgINkc0qh7dlCzNmss0zQ8twsNugTlLNAfmDt751tV/7663WJV6plFi4+TnO5TRtS/KvDfLN7RxFIfP2oSR3JkK1Q1G6J8dn62PYoaeYXKmhTRDnlQqNtxWQKJG75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB7PR04MB5068.eurprd04.prod.outlook.com (2603:10a6:10:14::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 13 Nov
 2020 08:39:18 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::c84:f086:9b2e:2bf1]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::c84:f086:9b2e:2bf1%7]) with mapi id 15.20.3455.040; Fri, 13 Nov 2020
 08:39:18 +0000
From:   Gary Lin <glin@suse.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, andreas.taschner@suse.com
Subject: [PATCH RFC] bpf, x64: allow not-converged images when BPF_JIT_ALWAYS_ON is set
Date:   Fri, 13 Nov 2020 16:38:52 +0800
Message-ID: <20201113083852.22294-1-glin@suse.com>
X-Mailer: git-send-email 2.28.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM9P192CA0010.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::15) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation.suse.cz (60.251.47.115) by AM9P192CA0010.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend Transport; Fri, 13 Nov 2020 08:39:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53190378-9884-436c-ee8f-08d887af9bfb
X-MS-TrafficTypeDiagnostic: DB7PR04MB5068:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5068FFAD42A20A3949FA30D2A9E60@DB7PR04MB5068.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhELy+ejeyGfpQ+4Cy5Umy3ctEgfJNCiUv8G9DdwdEYFf+e3+Dsh3GTjXW3v57CeI0YchnBbXuezmhNALawn67ZbYfDULCbulFIlp+80WdgXyQsXh3dOP4oA78fgaz+5o/17wgcPgtvJArhfYoNcT1EW2LZk5gF+ZWudwMvEh8dswA9wFQa/Ree0pckUWEXRhIlgz/HMqPzK3edqHLT/UXEqtN7YPo/H0Hot0n5eMsSFKPaigiVfIXa7Y4VBEwycKpDzwIYmo+PPmRdEY4pcsc+OGYAkjIfMQ8pk9lb9G6fMouMp6blBbM0O2VHPaxBKIjXVZ8mBvUdFrEvUxshZfqabn08ah0zmOy4gXGjLknFG1yIa63dBFaiPu1MP8xjC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(396003)(366004)(8676002)(956004)(2616005)(8936002)(2906002)(1076003)(52116002)(6512007)(36756003)(83380400001)(86362001)(16526019)(66946007)(54906003)(6666004)(316002)(478600001)(109986005)(107886003)(26005)(4326008)(5660300002)(55236004)(6486002)(66476007)(66556008)(6506007)(186003)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Bn9ADcw1SyfcML1nFItgfReBgLB6y/FLSWktitiQv3hyUfxsVBinKLAvIS5Dj+QB/V1O5hWhX+MSFsnDlZMkrvg4t9AIvwvXqVdqu5TVLBv+pRamjoUjq1RM6ei5ETgsIjRLv/crNOAq96Ra8nozdi01f8UXkWI/Acuwes4IcKe+8uSakCJnbeV20qqlLWDgKSNH+O2ybnXYnqfCfPAsY1sZXtKxKNTkqOW3oGbZmmVKwQLpR11nWBKZeUbAhbHghthXSi/7H+SzjtIIbFg4hoJIoZTIqJBcMvIvKq9liofyrsKSiFMLJl3dbQliGHMrNcyNdCy6ZA3pr8QdjO3y7NkOUUb0r7LMBiQNszja8ASl5uGBXo06ouJ5e/RfmCwiHZTNI5U5PqV6zixrf1uxEiYPYiqC3Z4iYh0X+fd8PmUSLf1/3vK7A0kFsLAJSIknGtKz5wxMSLmUmhnk9tp6yzDE0o5nZxkUR0tCIDBDiFG40ZcYWqnrlc3XvKkVNtXyhCOQplpi9BjswlverpQbvTE/QUxOCaeUbb3xRGcqtpFhDY1i/hMtb8ShWWlyQSLGjCb1s1hFnLEHOkKnYu0n+Rg5B7qguDIepMoHQp/aTuzBR7ilNEhQaUUb+SwkJ+EfURJrFOlb/WoO9icqkTkTZw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53190378-9884-436c-ee8f-08d887af9bfb
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 08:39:18.2009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rd6vgqVidWr5yXBts8k6IZ/nNOCn7Om9QolY9249KBpLw3S+yOfO1Wy3WVmbMx0q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5068
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The x64 bpf jit expects the bpf images converge within the given passes.
However there is a corner case:

  l0:     ldh [4]
  l1:     jeq #0x537d, l2, l40
  l2:     ld [0]
  l3:     jeq #0xfa163e0d, l4, l40
  l4:     ldh [12]
  l5:     ldx #0xe
  l6:     jeq #0x86dd, l41, l7
  l7:     jeq #0x800, l8, l41
  l8:     ld [x+16]
  l9:     ja 41

    [... repeated ja 41 ]

  l40:    ja 41
  l41:    ret #0
  l42:    ld #len
  l43:    ret a

The bpf program contains 32 "ja 41" and do_jit() only removes one "ja 41"
right before "l41:  ret #0" for offset=3D=3D0 in each pass, so
bpf_int_jit_compile() needs to run do_jit() at least 32 times to
eliminate those JMP instructions. Since the current max number of passes
is 20, the bpf program couldn't converge within 20 passes and got rejected
when BPF_JIT_ALWAYS_ON is set even though it's legit as a classic socket
filter.

A not-converged image may be not optimal but at least the bpf
instructions are translated into x64 machine code. Maybe we could just
issue a warning instead so that the program is still loaded and the user
is also notified.

On the other hand, if the size convergence is mandatory, then it
deserves a document to collect the corner cases so that the user could
know the limitations and how to work around them.

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..90814c2daaae 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1972,6 +1972,8 @@ struct x64_jit_data {
 	struct jit_context ctx;
 };
=20
+#define MAX_JIT_PASSES 20
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -2042,7 +2044,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	 * may converge on the last pass. In such case do one more
 	 * pass to emit the final image.
 	 */
-	for (pass =3D 0; pass < 20 || image; pass++) {
+	for (pass =3D 0; pass < MAX_JIT_PASSES || image; pass++) {
 		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
 		if (proglen <=3D 0) {
 out_image:
@@ -2054,13 +2056,22 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_pro=
g *prog)
 		}
 		if (image) {
 			if (proglen !=3D oldproglen) {
+#ifdef CONFIG_BPF_JIT_ALWAYS_ON
+				pr_warn("bpf_jit: proglen=3D%d !=3D oldproglen=3D%d pass=3D%d\n",
+					proglen, oldproglen, pass);
+#else
 				pr_err("bpf_jit: proglen=3D%d !=3D oldproglen=3D%d\n",
 				       proglen, oldproglen);
 				goto out_image;
+#endif
 			}
 			break;
 		}
+#ifdef CONFIG_BPF_JIT_ALWAYS_ON
+		if (proglen =3D=3D oldproglen || pass >=3D (MAX_JIT_PASSES - 1)) {
+#else
 		if (proglen =3D=3D oldproglen) {
+#endif
 			/*
 			 * The number of entries in extable is the number of BPF_LDX
 			 * insns that access kernel memory via "pointer to BTF type".
--=20
2.28.0

