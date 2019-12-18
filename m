Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC81243E1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfLRKC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:02:57 -0500
Received: from fd.dlink.ru ([178.170.168.18]:36378 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfLRKC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 05:02:57 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 7A0251B20468; Wed, 18 Dec 2019 13:02:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 7A0251B20468
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1576663374; bh=gDGQswSJmOCrBpGvaSKjgS8f9nsrlgdTnRggmnaY5a4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=XPMAyoi4OAfBqI7lHEMD5nGmnvsojNVwYLElsQkuWfLCfCputZJXlVR8+uT8t9gAN
         soy8fWB9YbxgrYUOKWCH9hXK74Z4yk69X3NOip7fgYgjkuOkP6qC/a6NJmM3PWiQVC
         AZxaAKQQ3fpM3fKMPtzwTposZHLCJyfvyOMeN91c=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 395251B20091;
        Wed, 18 Dec 2019 13:02:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 395251B20091
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id CFEC01B20367;
        Wed, 18 Dec 2019 13:02:41 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 18 Dec 2019 13:02:41 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 18 Dec 2019 13:02:41 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     Paul Burton <paulburton@kernel.org>,
        =?UTF-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf 2/2] bpf, mips: limit to 33 tail calls
In-Reply-To: <20191218095825.GA15840@Omicron>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
 <b8eb2caac1c25453c539248e56ca22f74b5316af.1575916815.git.paul.chaignon@gmail.com>
 <20191210232316.aastpgbirqp4yaoi@lantea.localdomain>
 <8cf09e73329b3205a64eae4886b02fea@dlink.ru> <20191218095825.GA15840@Omicron>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <4090532015bc8b26e89ba90f9f881d7f@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Chaignon wrote 18.12.2019 12:58:
> On Wed, Dec 18, 2019 at 12:32:53PM +0300, Alexander Lobakin wrote:
>> Paul Burton wrote 11.12.2019 02:23:
>> > Hi Paul,
>> >
>> > On Mon, Dec 09, 2019 at 07:52:52PM +0100, Paul Chaignon wrote:
>> > > All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail
>> > > calls
>> > > limit at runtime.  In addition, a test was recently added, in
>> > > tailcalls2,
>> > > to check this limit.
>> > >
>> > > This patch updates the tail call limit in MIPS' JIT compiler to allow
>> > > 33 tail calls.
>> 
>> Hi Paul,
>> 
>> You've restored MIPS cBPF in mips-fixes tree, doesn't it require any
>> changes to limit tail calls to 33? This series includes only eBPF as
>> there was no MIPS cBPF at the moment of writing.
> 
> cBPF doesn't support tail calls or even the call instruction for
> helpers.

Aww, didn't know that. Thanks!

> Paul C.
> 
>> 
>> > > Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
>> > > Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
>> > > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
>> >
>> > I'd be happy to take this through mips-fixes, but equally happy for it
>> > to go through the BPF/net trees in which case:
>> >
>> >   Acked-by: Paul Burton <paulburton@kernel.org>
>> >
>> > Thanks,
>> >     Paul
>> >
>> > > ---
>> > >  arch/mips/net/ebpf_jit.c | 9 +++++----
>> > >  1 file changed, 5 insertions(+), 4 deletions(-)
>> > >
>> > > diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
>> > > index 46b76751f3a5..3ec69d9cbe88 100644
>> > > --- a/arch/mips/net/ebpf_jit.c
>> > > +++ b/arch/mips/net/ebpf_jit.c
>> > > @@ -604,6 +604,7 @@ static void emit_const_to_reg(struct jit_ctx
>> > > *ctx, int dst, u64 value)
>> > >  static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
>> > >  {
>> > >  	int off, b_off;
>> > > +	int tcc_reg;
>> > >
>> > >  	ctx->flags |= EBPF_SEEN_TC;
>> > >  	/*
>> > > @@ -616,14 +617,14 @@ static int emit_bpf_tail_call(struct jit_ctx
>> > > *ctx, int this_idx)
>> > >  	b_off = b_imm(this_idx + 1, ctx);
>> > >  	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
>> > >  	/*
>> > > -	 * if (--TCC < 0)
>> > > +	 * if (TCC-- < 0)
>> > >  	 *     goto out;
>> > >  	 */
>> > >  	/* Delay slot */
>> > > -	emit_instr(ctx, daddiu, MIPS_R_T5,
>> > > -		   (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4, -1);
>> > > +	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
>> > > +	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
>> > >  	b_off = b_imm(this_idx + 1, ctx);
>> > > -	emit_instr(ctx, bltz, MIPS_R_T5, b_off);
>> > > +	emit_instr(ctx, bltz, tcc_reg, b_off);
>> > >  	/*
>> > >  	 * prog = array->ptrs[index];
>> > >  	 * if (prog == NULL)
>> > > --
>> > > 2.17.1
>> > >
>> 
>> Regards,
>> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
