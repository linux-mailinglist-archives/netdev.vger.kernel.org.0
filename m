Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EF02CEBF7
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgLDKQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:16:25 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:28290 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729553AbgLDKQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:16:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607076917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4vO+7427xJI6/sOycUD2JdSCZ4WDWtL3sIJuxtfunVw=;
        b=LYWwcfO6DJJwDZBcWVyXw0pL6/ydKJVOdL9hZVmC/fLsPlHsnuyP/c1ikZveGI2FbIXmF9
        waK1G7dIBmi8QQHmS79Oy9QAPyV46VA50CUl7tdB88+vVVZRIDnnh29TwHKKILOqYGxmkE
        Y40+9NC2hhFkodyB6nhgSQZfaXfKxjE=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-VvO30Fz2PfyrnC9fJklcZg-1; Fri, 04 Dec 2020 11:15:15 +0100
X-MC-Unique: VvO30Fz2PfyrnC9fJklcZg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALnVB+O5aPLuzbrVsqr37Ek9XmJLV/tm9vEH7H0ouBH9hg2RIlyQ0X6LUlk+7kdjwXYDH8DLpu/Jmu165jLbJbOu5ySDslWSciPriWKKOlhdyC4krKzjSFuVYJTWwoq4pQrvPYgp1h53bGcMLfkfnXgEqAOFR71qR1H/yC6gs0FKu1pHaEq8Jba+V4o6rfNHVhskYRoADS3I5+pLvGhoi6BXR2aj7ZCXJhjwMVd6aE0Q5uUKgtCpCdmdZpu61YGKFEp92I70SNcnc9ZWd65WJ0n0NSjAnG3ZvoCZ1J//7MwJBySlHGgjZ0SrFIVkjiSkR0Oun+JuspZA2QqGo0/uhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vO+7427xJI6/sOycUD2JdSCZ4WDWtL3sIJuxtfunVw=;
 b=PNhesZUFwTk5Ce6gZ3EJB+s3C8F7UlMMZ3wRYudCuya6j33ASalfdIgCSKylWl8nXTYxb5g7KergfLPINtDwmLoO8TXNUZx05NXX8erVuhg/u9LdlS5Ebd/gq3MhyXViMUlkI/rw1JhQsQ3fbcige3/ET4SENJTiYXubZQdyHekD1WWetdTnwxe383ZVEXIOjPb/YNd4uLYA6V5sDOqK75Rdbn1toPVjEPkCUeva+5gPuJ+PttkebR8Pf98+VbXKn7eO2Z87se5vID0cdpPRiTlnqNPBw1BRG22g2QwTXUQ+L2JXFjqaMFwN5/SUAyq3bCYD6Dzk5uI9TNooWSDZgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBAPR04MB7301.eurprd04.prod.outlook.com (2603:10a6:10:1a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 10:15:14 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%7]) with mapi id 15.20.3589.037; Fri, 4 Dec 2020
 10:15:14 +0000
Date:   Fri, 4 Dec 2020 18:15:04 +0800
From:   Gary Lin <glin@suse.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf, x64: bump the number of passes to 64
Message-ID: <20201204101504.GB16653@GaryWorkstation>
References: <20201203091252.27604-1-glin@suse.com>
 <8fbcb23d-d140-48fb-819d-61f49672d9bd@gmail.com>
 <20201203181431.t2l63nifzprxqc26@ast-mbp>
 <20201204034213.GA16653@GaryWorkstation>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204034213.GA16653@GaryWorkstation>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR02CA0096.eurprd02.prod.outlook.com
 (2603:10a6:208:154::37) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR02CA0096.eurprd02.prod.outlook.com (2603:10a6:208:154::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Fri, 4 Dec 2020 10:15:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26e870a7-f46c-492e-07dd-08d8983d7d68
X-MS-TrafficTypeDiagnostic: DBAPR04MB7301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73012F1033CC4BD41F02C712A9F10@DBAPR04MB7301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQnKImJNmtEzjQVfS7taMXD0lKE3kBgHsUcSA3FhMjI6T6njt3OxFEtVggHged1xu0JuGM8m1og7a5Ed1fVv4q+5Y2T2FU1FnQoD0IQ3ALcaFd6eK/KLi0XFjWvnmK9GMR+pFkWYQtv76NnlIneEOcPFb/aYlRd71W1ZZ9BNAFDfvghPdYiVBErDdl++7p2dko71hwtoDivbsavBgUyCiXiofepY+HYwRGm8ztRd9ey7ie5Q1b9NUrMKVXO/RwJc0S/cQ9cbqvT0twW/rKtHcztXlluMpV65YWghEN3xWJxi3k89Bc0wabWtEC8N44JEDsiHyu6JUwmL489814xtYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(376002)(39860400002)(8936002)(83380400001)(8676002)(2906002)(53546011)(186003)(956004)(86362001)(107886003)(6496006)(52116002)(26005)(55236004)(16526019)(4326008)(478600001)(9686003)(66556008)(6666004)(55016002)(5660300002)(66476007)(66946007)(316002)(1076003)(33716001)(54906003)(6916009)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mw6qfQ1WWpVChnHesHMgzt+pw2DBqwlJrWycfxD6p35ee2u9V1jSwa7XZ316?=
 =?us-ascii?Q?+XPjgSuyf/EwSOnHhzmhuQLOrNBAwuMqz6wqIsfJSoSqxoFal1IzarfZAjM1?=
 =?us-ascii?Q?+1ldfgmSuw4awis/2j70d1KWwSPynlGOcWR5bI2qFjnUo7eLHp/P5grulwXU?=
 =?us-ascii?Q?EAuF6/PZ5c9geacYMHDYECBvHZpgp0Qk0E0nGR+PYz78yID1eIGGxvHzJaRx?=
 =?us-ascii?Q?hwU+9AW+cQ9Zu8/uLjP8vfT9pwtB8ffBRBAU5RfaQpZOi2h1fuk0nhyw+qcK?=
 =?us-ascii?Q?hoZwy8vVc4fQMyR8TsvLSSPyVk1cbsbEHkwUEkXgtAYXmuFUpnmdXAzu31ZH?=
 =?us-ascii?Q?Ld+wY5qyHOPXr1ZQPiglC6o/JA83oyVzufLY3xRfmRAfFL2zYlaeVJnjQXzC?=
 =?us-ascii?Q?NK2eVspCHRagwT1Rhjg7a1ihXowmOu80mZseFTBPfvEw4qcmhrrpjyAg3D6R?=
 =?us-ascii?Q?8jzN8DL0VRroj+km9hqaaX3lq3RaYoy+BQinzYfcXEMsb3fQkegeI9JINI/3?=
 =?us-ascii?Q?0Jp70L6Spo2lGzp16KKN4BzoIxsG88xJWQk3N+UotThwf1o7HtX5syPGQtTq?=
 =?us-ascii?Q?vxzyQmsEzTgJbiUr3mjpdpRvaNumsQ5Ir/I6dT5km21eCUyhPBJLUKNWMor9?=
 =?us-ascii?Q?i3Rkn8v4nqFDy1V8hEOBQk1oQVmQWEQJ2YcOlDMUJToeeKu0mBuEF+nWZOng?=
 =?us-ascii?Q?VerGZk8DDVEdXnVWA+jjR5ziqKvl275MKxx/nnGO+SdwIpsN3/+/QdTo+S6N?=
 =?us-ascii?Q?TgtGwirWGjGIDxGGVbVvNd9Rw2UxKws76281QDYlzvqsTmV3ykWVRiXRCgr9?=
 =?us-ascii?Q?FIOFqOFaI6wwZNy7RJXCjJAia5bpcCzSvo6s7JiqVX8lB0i4brgbfY02nsRY?=
 =?us-ascii?Q?5fdyR4LWBRG/rQv+SdpyNjRnrQOqvNM5OOztYJfM9cdmwo6S+i4GOLWOL/d5?=
 =?us-ascii?Q?0r/hihNnaqMq/KZJ88hj/pM+bikLBASpIfn3sJYOQeQ+bGS0YN9XI21ixJ1Q?=
 =?us-ascii?Q?m93j?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e870a7-f46c-492e-07dd-08d8983d7d68
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 10:15:13.9293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBuPFwQfSTYpYhViXGCVeLjamf6DX6vuT1v3K/2FpG7YJ4VWv5L9us1ipPnMAJIM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 11:42:13AM +0800, Gary Lin wrote:
> On Thu, Dec 03, 2020 at 10:14:31AM -0800, Alexei Starovoitov wrote:
> > On Thu, Dec 03, 2020 at 12:20:38PM +0100, Eric Dumazet wrote:
> > > 
> > > 
> > > On 12/3/20 10:12 AM, Gary Lin wrote:
> > > > The x64 bpf jit expects bpf images converge within the given passes, but
> > > > it could fail to do so with some corner cases. For example:
> > > > 
> > > >       l0:     ldh [4]
> > > >       l1:     jeq #0x537d, l2, l40
> > > >       l2:     ld [0]
> > > >       l3:     jeq #0xfa163e0d, l4, l40
> > > >       l4:     ldh [12]
> > > >       l5:     ldx #0xe
> > > >       l6:     jeq #0x86dd, l41, l7
> > > >       l8:     ld [x+16]
> > > >       l9:     ja 41
> > > > 
> > > >         [... repeated ja 41 ]
> > > > 
> > > >       l40:    ja 41
> > > >       l41:    ret #0
> > > >       l42:    ld #len
> > > >       l43:    ret a
> > > > 
> > > > This bpf program contains 32 "ja 41" instructions which are effectively
> > > > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > > > bpf jit should optimize those "ja 41" instructions out when translating
> > > > the bpf instructions into x86_64 machine code. However, do_jit() can
> > > > only remove one "ja 41" for offset==0 on each pass, so it requires at
> > > > least 32 runs to eliminate those JMPs and exceeds the current limit of
> > > > passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > > > is set even though it's legit as a classic socket filter.
> > > > 
> > > > Since this kind of programs are usually handcrafted rather than
> > > > generated by LLVM, those programs tend to be small. To avoid increasing
> > > > the complexity of BPF JIT, this commit just bumps the number of passes
> > > > to 64 as suggested by Daniel to make it less likely to fail on such cases.
> > > > 
> > > 
> > > Another idea would be to stop trying to reduce size of generated
> > > code after a given number of passes have been attempted.
> > > 
> > > Because even a limit of 64 wont ensure all 'valid' programs can be JITed.
> > 
> > +1.
> > Bumping the limit is not solving anything.
> > It only allows bad actors force kernel to spend more time in JIT.
> > If we're holding locks the longer looping may cause issues.
> > I think JIT is parallel enough, but still it's a concern.
> > 
> > I wonder how assemblers deal with it?
> > They probably face the same issue.
> > 
> > Instead of going back to 32-bit jumps and suddenly increase image size
> > I think we can do nop padding instead.
> > After few loops every insn is more or less optimal.
> > I think the fix could be something like:
> >   if (is_imm8(jmp_offset)) {
> >        EMIT2(jmp_cond, jmp_offset);
> >        if (loop_cnt > 5) {
> >           EMIT N nops
> >           where N = addrs[i] - addrs[i - 1]; // not sure about this math.
> >           N can be 0 or 4 here.
> >           // or may be NOPs should be emitted before EMIT2.
> >           // need to think it through
> >        }
> >   }
> This looks promising. Once we switch to nop padding, the image is likely
> to converge soon. Maybe we can postpone the padding to the last 5 passes
> so that do_jit() could optimize the image a bit more.
> 
> > Will something like this work?
> > I think that's what you're suggesting, right?
> > 
> Besides nop padding, the optimization for 0 offset jump also has to be
> disabled since it's actually the one causing image shrinking in my case.
> 
> Gary Lin
> 

Here is my testing patch. My sample program got accepted with this
patch. Haven't done the further test though.

---
 arch/x86/net/bpf_jit_comp.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..6a39c5ba6383 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -790,7 +790,7 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
 }
 
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
-		  int oldproglen, struct jit_context *ctx)
+		  int oldproglen, struct jit_context *ctx, bool ja_padding)
 {
 	bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
 	struct bpf_insn *insn = bpf_prog->insnsi;
@@ -800,6 +800,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	bool seen_exit = false;
 	u8 temp[BPF_MAX_INSN_SIZE + BPF_INSN_SAFETY];
 	int i, cnt = 0, excnt = 0;
+	int p;
 	int proglen = 0;
 	u8 *prog = temp;
 
@@ -1410,6 +1411,11 @@ xadd:			if (is_imm8(insn->off))
 			jmp_offset = addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
 				EMIT2(jmp_cond, jmp_offset);
+				ilen = prog - temp;
+				if (ja_padding && (addrs[i] - addrs[i-1]) > ilen) {
+					for (p = 0; p < 4; p++)
+						EMIT1(0x90);
+				}
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
 			} else {
@@ -1431,12 +1437,17 @@ xadd:			if (is_imm8(insn->off))
 			else
 				jmp_offset = addrs[i + insn->off] - addrs[i];
 
-			if (!jmp_offset)
+			if (!jmp_offset && !ja_padding)
 				/* Optimize out nop jumps */
 				break;
 emit_jmp:
 			if (is_imm8(jmp_offset)) {
 				EMIT2(0xEB, jmp_offset);
+				ilen = prog - temp;
+				if (ja_padding && (addrs[i] - addrs[i-1]) > ilen) {
+					for (p = 0; p < 4; p++)
+						EMIT1(0x90);
+				}
 			} else if (is_simm32(jmp_offset)) {
 				EMIT1_off32(0xE9, jmp_offset);
 			} else {
@@ -1972,6 +1983,9 @@ struct x64_jit_data {
 	struct jit_context ctx;
 };
 
+#define MAX_PASSES 20
+#define PADDING_PASSES (MAX_PASSES - 5)
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header = NULL;
@@ -2043,7 +2057,10 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	 * pass to emit the final image.
 	 */
 	for (pass = 0; pass < 20 || image; pass++) {
-		proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
+		if (pass < PADDING_PASSES)
+			proglen = do_jit(prog, addrs, image, oldproglen, &ctx, false);
+		else
+			proglen = do_jit(prog, addrs, image, oldproglen, &ctx, true);
 		if (proglen <= 0) {
 out_image:
 			image = NULL;

