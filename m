Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2082B130D
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgKMAJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKMAJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:09:52 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04928C0613D1;
        Thu, 12 Nov 2020 16:09:45 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b63so2458631pfg.12;
        Thu, 12 Nov 2020 16:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YEOak1Q65fB6+iOVs3xmnbDLXO/CwBmy09sjyTkwWFc=;
        b=Q+2kl2pVYezPYnWZXed+fidnWzaOmJR75KD2EOF7ytOfd2TUf1OSXP8oAl8/uBaI7e
         UeG69Gbtx9Lx97VP2HXzG+HeVOCTT7reY95xRbR87+/iY3jBH+urqqyHoEKqGolkIeVv
         B2LFyOEu3vOQw0wXLA53ASbPllByJ1hmV+KoQ94kmcjzDxi9x6iak+QRK4UHOjlt9FlK
         n/Na/up2cL+8npN+ePWdMYyrxG5tM96x/lukSBqxjOmiBldWiU70znL3j7ZsctlK2kxF
         GQ2RqZxuxacNWot1lwHTC9WzlWxyq9Egg0w2zKziHiTEqrBmY5RN08m0PHU+svLcNlsq
         bg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YEOak1Q65fB6+iOVs3xmnbDLXO/CwBmy09sjyTkwWFc=;
        b=mQKHSvg58PNQ/R+jCe441a0Zr43wTztSq408akOjbn4viSuFhytGFU+iJxPOZtH20s
         4WXXskeT0jvkMVP/9Kq61eN6cFTJJtxJKfe91sqUpJV/SqRn8QjgFFJeOPrGjHHCyTQ5
         0DLponPplVYtP8TiXaUSaBX6BtXFt/hFLKhsIkLaBtZEJ/bCJfczUMbO/TE+sa/QZrgj
         gYu1RNQZQpABkP+xTksTCUkfzwVSyRA7GlOMTxl2DFcmEq9y3NPq69+rrep6VPY0dC1U
         D+gmDNRETm7Kz+RPCcPEXa3y+7tqcldTmoJvH0dGiRyWzhC1fRzADjjEq1fD9+OOHrss
         4V+A==
X-Gm-Message-State: AOAM530SawON6/GFzSDthxd8KpenwQAsgqADhNyz49KqpinWy2QiT78r
        /bGlNtqA2GBgqWQMQM8hojU=
X-Google-Smtp-Source: ABdhPJw77sxkxN9tBas35Txm1csTktcPi+S6uVTE0/wn+Atjf9Us3hGy7OJhf8CwpgyUEG26Svjrlg==
X-Received: by 2002:aa7:808a:0:b029:160:167d:d332 with SMTP id v10-20020aa7808a0000b0290160167dd332mr1842331pff.1.1605226184529;
        Thu, 12 Nov 2020 16:09:44 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:a370])
        by smtp.gmail.com with ESMTPSA id 199sm7493078pgg.18.2020.11.12.16.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 16:09:43 -0800 (PST)
Date:   Thu, 12 Nov 2020 16:09:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Support for pointers beyond pkt_end.
Message-ID: <20201113000941.azxyv523bl45z6s5@ast-mbp>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-2-alexei.starovoitov@gmail.com>
 <5fad89fb649af_2a612088e@john-XPS-13-9370.notmuch>
 <4f80439b-3251-f82b-be63-b398d5f73ac2@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f80439b-3251-f82b-be63-b398d5f73ac2@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 12:56:52AM +0100, Daniel Borkmann wrote:
> On 11/12/20 8:16 PM, John Fastabend wrote:
> > Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > > 
> > > This patch adds the verifier support to recognize inlined branch conditions.
> > > The LLVM knows that the branch evaluates to the same value, but the verifier
> > > couldn't track it. Hence causing valid programs to be rejected.
> > > The potential LLVM workaround: https://reviews.llvm.org/D87428
> > > can have undesired side effects, since LLVM doesn't know that
> > > skb->data/data_end are being compared. LLVM has to introduce extra boolean
> > > variable and use inline_asm trick to force easier for the verifier assembly.
> > > 
> > > Instead teach the verifier to recognize that
> > > r1 = skb->data;
> > > r1 += 10;
> > > r2 = skb->data_end;
> > > if (r1 > r2) {
> > >    here r1 points beyond packet_end and
> > >    subsequent
> > >    if (r1 > r2) // always evaluates to "true".
> > > }
> > > 
> > > Tested-by: Jiri Olsa <jolsa@redhat.com>
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >   include/linux/bpf_verifier.h |   2 +-
> > >   kernel/bpf/verifier.c        | 129 +++++++++++++++++++++++++++++------
> > >   2 files changed, 108 insertions(+), 23 deletions(-)
> > > 
> > 
> > Thanks, we can remove another set of inline asm logic.
> > 
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > >   	if (pred >= 0) {
> > > @@ -7517,7 +7601,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
> > >   		 */
> > >   		if (!__is_pointer_value(false, dst_reg))
> > >   			err = mark_chain_precision(env, insn->dst_reg);
> > > -		if (BPF_SRC(insn->code) == BPF_X && !err)
> > > +		if (BPF_SRC(insn->code) == BPF_X && !err &&
> > > +		    !__is_pointer_value(false, src_reg))
> > 
> > This could have been more specific with !type_is_pkt_pointer() correct? I
> > think its fine as is though.
> > 
> > >   			err = mark_chain_precision(env, insn->src_reg);
> > >   		if (err)
> > >   			return err;
> 
> Given the reg->range could now be negative, I wonder whether for the regsafe()
> pruning logic we should now better add a >=0 sanity check in there before we
> attempt to test on rold->range > rcur->range?

I thought about it and specifically picked negative range value to keep
regsafe() check as-is.
The check is this:
                if (rold->range > rcur->range)
                        return false;
rold is the one that was safe in the past.
If rold was positive and the current is negative we fail here
which is ok. State pruning is conservative.

If rold was negative it means the previous state was safe even though that pointer
was pointing beyond packet end. So it's ok for rcur->range to be anything.
Whether rcur is positive or negative doesn't matter. Everything is still ok.
If rold->range == -1 and rcur->range == -2 we fail here.
It's minor annoyance. State pruning is tiny bit more conservative than necessary.

So I think no extra checks in regsafe() are neeeded.
Does it make sense?
