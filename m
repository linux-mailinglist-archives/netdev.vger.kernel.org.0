Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32262D921A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 04:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438395AbgLNDwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 22:52:42 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:45052 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgLNDwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 22:52:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607917891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFPiOG0r6wqYnKDkY9MwQ8mObdm4RH2qFLAwbVO4t8o=;
        b=lxQjtP+gGZpPjdx+IhAJWyQxvVb21SjPCU0paQjwe/giNzHmNJuQScz6ov+RU1oKyWyrIG
        OZF6VneuEv7XVzC+U/1viojkEJBlrGSBNbGYM1t+lim6TotlLNHHVFnZZzy25bBUQzdgv/
        WYhOQdzqWMJA0AibcHtFstDQlRqia6M=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2111.outbound.protection.outlook.com [104.47.18.111])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-04XxOc-zON64_SPZZJDuzQ-1; Mon, 14 Dec 2020 04:51:29 +0100
X-MC-Unique: 04XxOc-zON64_SPZZJDuzQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swwmw7Ao/gkTZFweZYndWPO8P01Sc0wwC13bf80CV09OoNKXdnZXaKJFybGkWjIfW57rNp9jzI/G4dRr6c9snbB2PnS5HEk2BCMly2fzSYlcEAz1/tZap22/bb1Oj8Otq+Y2kqE2awgmNE99c8qtk9dRGTz/faYrCebr4yw4ktR67pdEObG+6CoYJDsQOl90mFBZV8EZCKFlYU2S+MjuOP5j4Q2GI2H/0RCeQtLPgXdukdezLu+992UM2W7wprrzIugqzM6NbVo59AU9JcYcg/qDhW/xghT99xKEKpO1JU8umAQB/WTtIgmXW1cNCwiIJ+oRPw2n6Rwd33HjrArE6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFPiOG0r6wqYnKDkY9MwQ8mObdm4RH2qFLAwbVO4t8o=;
 b=U3Akax4Ek1hsS0Lk6UTkJkTobUKDB62jun4PTIRt2dUQyj2AIvFxahf9uS4k0vlTPMZu3AYy3B3hZf0CKb8aS/ko+teJssW4T0iKZ3AwXpMZhE5HXQbbmmsNWi0RB/d+5uYu9Kpet6Rvky14/vLV2O92TFogzuXM+ECQrauwCBb/Sg6qij2Bo9OVhGmQ+vU4pqwvDuwtVg37fKII5oKOFe9exkWJIrtNT3AsDxQJGmVA8XDdgjsapTXsxj25eUghzZiZHbJc7EneXfWHzbe+mPkJvf3eF8rfPh/o7eDAfpTK3MNkI+a88YDO4eP3Lyd3oTKgOXynAsatrH0EZ8g1Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB6PR0402MB2918.eurprd04.prod.outlook.com (2603:10a6:4:9a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 03:51:27 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 03:51:27 +0000
Date:   Mon, 14 Dec 2020 11:51:16 +0800
From:   Gary Lin <glin@suse.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
Message-ID: <X9bhNAnOrpAzg2mg@GaryWorkstation>
References: <20201211081903.17857-1-glin@suse.com>
 <CAEf4BzbJRf-+_GE4r2+mk0FjT96Qszx3ru9wEfieP_zr6p6dOw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbJRf-+_GE4r2+mk0FjT96Qszx3ru9wEfieP_zr6p6dOw@mail.gmail.com>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM8P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::23) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 03:51:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 999ffa6d-449d-48d4-c2e3-08d89fe3889e
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2918:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2918A37D866A7B8164E71268A9C70@DB6PR0402MB2918.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L60y+mbbRw4PrHcSE2eAI07MVDDYkeFc5pjtVZaV4TZG66JnOmMIMMSzmwUVx6+1GjC0rHOWwv3+vY8VuB+9Ic2WS8VJ1WVWYDp9QxVFRiXJyUixv2bSqyQ8bQdkAVeIU/Lgc49Ke0PMgmuPqCEM0jOTOhSwkHxJaH/VNyttVCC0NyGEqtVa2jqsJA6vsfV+JcNk3N4PDhIWuLlQyEbYythbA0KzvD3ecTWDhCXugxE+PZ9EQVxVW+Kmh+37zzMSNd7ok/lWFCpSL7K8sHIziCevDHdqKBVzzvo3SFE0Phtimad8hmvZjNSCyDdOQ9CuzpdyIY1VE9bExg3noxRPPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39850400004)(376002)(136003)(2906002)(6666004)(33716001)(55236004)(66946007)(54906003)(66476007)(83380400001)(53546011)(66556008)(5660300002)(8676002)(6496006)(52116002)(107886003)(4326008)(26005)(956004)(86362001)(478600001)(16526019)(55016002)(6916009)(9686003)(186003)(8936002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U8murBXTvbvo5m7omrGLvr2tN6d9sEbTWZp6LsWYG64xbdYc6gDNeTj6TLtg?=
 =?us-ascii?Q?a3OavXFZ9+G5TS4YOXsr7S1LmFaMoSsy6aZgPsb/OpPxF8YwhhXC8xPziakN?=
 =?us-ascii?Q?9xhPQHKBlJpiNz9b76R6Tch4GnmgZxb1WPDSKt0z74WzqJgubjl1he9PMJj4?=
 =?us-ascii?Q?y3h4qPSaf0hYfymndI5Dlya1gpFqnYWW0rC/0iJOSJ64CcGijbeSJm9WGn4R?=
 =?us-ascii?Q?+tjNymD+gM9WSmVq3jJh1n8VeScuvwAqtuuZpOHuzdAl6MC6IcP2jffi//7F?=
 =?us-ascii?Q?1+a6GF/PucrqmxMmCpzox9UNR2dvvUgPuWxiGSBiB4f1Y65+5ZiyLV9t4Bkq?=
 =?us-ascii?Q?T4OnfhwUOiFdaiADQubx2CIOBw1YmFatIguf6uzpheKJYBw/c1vusejszQRZ?=
 =?us-ascii?Q?ocXP9VrPUQbAlkfAFfU+5vveJ/Jn6UXajtYjTis6e7fzOv4tkPyma4r6UpaC?=
 =?us-ascii?Q?cCXJFxGtya/R90rxuY1Ga52iuIQd9xQz8KQtPWiYr0SWr0vMkZwJ5voEpFKP?=
 =?us-ascii?Q?NYmGvkCsjRrq0d0vtWdML0kzW7krDWiVOBUOnJHD4siYbMyV5LNJDh4yHRSN?=
 =?us-ascii?Q?fP+RqOSXQUKJIjE7rHWBuUkqpljHJo64GE9gZKCOkLrPTxtHtCZ6QnOcwsgZ?=
 =?us-ascii?Q?4gllHiJAXBGvN7SGstxsWEabad1bVNOjApgCGTC/BqVqFrSWEpHKKcLIm2DS?=
 =?us-ascii?Q?7zPlv5COvFOvTUqdKmyXldh5kfinRkJ3NHzStofx8r9WLdVg4ZAKnyyhN8WZ?=
 =?us-ascii?Q?GkMSdPQ+CNUxZZbvbbijHJKZnDB0XSPabwnipUFEuT0Byp2xwsxjp9P0svqk?=
 =?us-ascii?Q?KFHpLe5jEnlgqCisu9bzzK84kz4yj5DizxhlG69yS9HcIzJJS4jMATYkdhyQ?=
 =?us-ascii?Q?qiaEwqXs56v7aj3YMGQaUMhJmYbjP5JAyROByzjpPmcTUULBEHUzI7L02Iyn?=
 =?us-ascii?Q?1i65xzuf6Tq6ri+BTwajTvriGTE36Rzm9OZiCORe+l3SByWNgc6PKmmd/ydu?=
 =?us-ascii?Q?o3Cr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 03:51:27.0484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 999ffa6d-449d-48d4-c2e3-08d89fe3889e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3G/5EIk8OFn423JK0IL6ZoyUxCdRaO7bJFLRa/qJldHF0m4H2+ok/IQxDBxyfa0h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2918
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 12:58:17PM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 11, 2020 at 8:51 AM Gary Lin <glin@suse.com> wrote:
> >
> > The x64 bpf jit expects bpf images converge within the given passes, but
> > it could fail to do so with some corner cases. For example:
> >
> >       l0:     ldh [4]
> >       l1:     jeq #0x537d, l2, l40
> >       l2:     ld [0]
> >       l3:     jeq #0xfa163e0d, l4, l40
> >       l4:     ldh [12]
> >       l5:     ldx #0xe
> >       l6:     jeq #0x86dd, l41, l7
> >       l8:     ld [x+16]
> >       l9:     ja 41
> >
> >         [... repeated ja 41 ]
> >
> >       l40:    ja 41
> >       l41:    ret #0
> >       l42:    ld #len
> >       l43:    ret a
> >
> > This bpf program contains 32 "ja 41" instructions which are effectively
> > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > bpf jit should optimize those "ja 41" instructions out when translating
> > the bpf instructions into x86_64 machine code. However, do_jit() can
> > only remove one "ja 41" for offset==0 on each pass, so it requires at
> > least 32 runs to eliminate those JMPs and exceeds the current limit of
> > passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > is set even though it's legit as a classic socket filter.
> >
> > To make the image more likely converge within 20 passes, this commit
> > pads some instructions with NOPs in the last 5 passes:
> >
> > 1. conditional jumps
> >   A possible size variance comes from the adoption of imm8 JMP. If the
> >   offset is imm8, we calculate the size difference of this BPF instruction
> >   between the previous pass and the current pass and fill the gap with NOPs.
> >   To avoid the recalculation of jump offset, those NOPs are inserted before
> >   the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
> >   calculating the NOP number.
> >
> > 2. BPF_JA
> >   There are two conditions for BPF_JA.
> >   a.) nop jumps
> >     If this instruction is not optimized out in the previous pass,
> >     instead of removing it, we insert the equivalent size of NOPs.
> >   b.) label jumps
> >     Similar to condition jumps, we prepend NOPs right before the JMP
> >     code.
> >
> > To make the code concise, emit_nops() is modified to use the signed len and
> > return the number of inserted NOPs.
> >
> > To support bpf-to-bpf, a new flag, padded, is introduced to 'struct bpf_prog'
> > so that bpf_int_jit_compile() could know if the program is padded or not.
> >
> > Signed-off-by: Gary Lin <glin@suse.com>
> > ---
> >  arch/x86/net/bpf_jit_comp.c | 68 ++++++++++++++++++++++++-------------
> >  include/linux/filter.h      |  1 +
> >  2 files changed, 45 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 796506dcfc42..30b81c8539b3 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -789,8 +789,31 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
> >         }
> >  }
> >
> > +static int emit_nops(u8 **pprog, int len)
> > +{
> > +       u8 *prog = *pprog;
> > +       int i, noplen, cnt = 0;
> > +
> > +       while (len > 0) {
> > +               noplen = len;
> > +
> > +               if (noplen > ASM_NOP_MAX)
> > +                       noplen = ASM_NOP_MAX;
> > +
> > +               for (i = 0; i < noplen; i++)
> > +                       EMIT1(ideal_nops[noplen][i]);
> > +               len -= noplen;
> > +       }
> > +
> > +       *pprog = prog;
> > +
> > +       return cnt;
> 
> Isn't cnt always zero? I guess it was supposed to be `cnt = len` at
> the beginning?
> 
[Skip this one since Daniel answered in another mail.]

> But then it begs the question how this patch was actually tested given
> emit_nops() is returning wrong answers? Changes like this should
> definitely come with tests.
> 
Before submitting this patch, I lowered PADDING_PASSES to 2 and ran
tools/testing/selftests/bpf/test_progs. We surely need some official
test cases for this patch. Will do it in v2.

> > +}
> > +
> > +#define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
> > +
> >  static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> > -                 int oldproglen, struct jit_context *ctx)
> > +                 int oldproglen, struct jit_context *ctx, bool jmp_padding)
> >  {
> >         bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
> >         struct bpf_insn *insn = bpf_prog->insnsi;
> > @@ -1409,6 +1432,8 @@ xadd:                     if (is_imm8(insn->off))
> >                         }
> >                         jmp_offset = addrs[i + insn->off] - addrs[i];
> >                         if (is_imm8(jmp_offset)) {
> > +                               if (jmp_padding)
> > +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
> >                                 EMIT2(jmp_cond, jmp_offset);
> >                         } else if (is_simm32(jmp_offset)) {
> >                                 EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
> > @@ -1431,11 +1456,19 @@ xadd:                   if (is_imm8(insn->off))
> >                         else
> >                                 jmp_offset = addrs[i + insn->off] - addrs[i];
> >
> > -                       if (!jmp_offset)
> > -                               /* Optimize out nop jumps */
> > +                       if (!jmp_offset) {
> > +                               /*
> > +                                * If jmp_padding is enabled, the extra nops will
> > +                                * be inserted. Otherwise, optimize out nop jumps.
> > +                                */
> > +                               if (jmp_padding)
> > +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF);
> >                                 break;
> > +                       }
> >  emit_jmp:
> >                         if (is_imm8(jmp_offset)) {
> > +                               if (jmp_padding)
> > +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
> >                                 EMIT2(0xEB, jmp_offset);
> >                         } else if (is_simm32(jmp_offset)) {
> >                                 EMIT1_off32(0xE9, jmp_offset);
> > @@ -1578,26 +1611,6 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
> >         return 0;
> >  }
> >
> > -static void emit_nops(u8 **pprog, unsigned int len)
> > -{
> > -       unsigned int i, noplen;
> > -       u8 *prog = *pprog;
> > -       int cnt = 0;
> > -
> > -       while (len > 0) {
> > -               noplen = len;
> > -
> > -               if (noplen > ASM_NOP_MAX)
> > -                       noplen = ASM_NOP_MAX;
> > -
> > -               for (i = 0; i < noplen; i++)
> > -                       EMIT1(ideal_nops[noplen][i]);
> > -               len -= noplen;
> > -       }
> > -
> > -       *pprog = prog;
> > -}
> > -
> >  static void emit_align(u8 **pprog, u32 align)
> >  {
> >         u8 *target, *prog = *pprog;
> > @@ -1972,6 +1985,9 @@ struct x64_jit_data {
> >         struct jit_context ctx;
> >  };
> >
> > +#define MAX_PASSES 20
> > +#define PADDING_PASSES (MAX_PASSES - 5)
> > +
> >  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >  {
> >         struct bpf_binary_header *header = NULL;
> > @@ -1981,6 +1997,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >         struct jit_context ctx = {};
> >         bool tmp_blinded = false;
> >         bool extra_pass = false;
> > +       bool padding = prog->padded;
> 
> can this ever be true on assignment? I.e., can the program be jitted twice?
> 
Yes, bpf-to-bpf runs bpf_int_jit_compile twice and it expects to run
only one pass in the second time.

> >         u8 *image = NULL;
> >         int *addrs;
> >         int pass;
> > @@ -2043,7 +2060,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >          * pass to emit the final image.
> >          */
> >         for (pass = 0; pass < 20 || image; pass++) {
> > -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> > +               if (!padding && pass >= PADDING_PASSES)
> > +                       padding = true;
> 
> Just, unconditionally:
> 
> padding = pass >= PADDING_PASSES;
> 
But this would turn 'padding' from 'true' to 'false' when invoking
bpf_int_jit_compile() the second time for bpf-to-bpf, so we still need
to do it conditionally.

Gary Lin

> > +               proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
> >                 if (proglen <= 0) {
> >  out_image:
> >                         image = NULL;
> > @@ -2101,6 +2120,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >                 prog->bpf_func = (void *)image;
> >                 prog->jited = 1;
> >                 prog->jited_len = proglen;
> > +               prog->padded = padding;
> >         } else {
> >                 prog = orig_prog;
> >         }
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 1b62397bd124..cb7ce2b3737a 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -531,6 +531,7 @@ struct bpf_prog {
> >                                 dst_needed:1,   /* Do we need dst entry? */
> >                                 blinded:1,      /* Was blinded */
> >                                 is_func:1,      /* program is a bpf function */
> > +                               padded:1,       /* jitted image was padded */
> >                                 kprobe_override:1, /* Do we override a kprobe? */
> >                                 has_callchain_buf:1, /* callchain buffer allocated? */
> >                                 enforce_expected_attach_type:1, /* Enforce expected_attach_type checking at attach time */
> > --
> > 2.29.2
> >
> 

