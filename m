Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DC36838A7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjAaV3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjAaV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:29:47 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EF02B2A2;
        Tue, 31 Jan 2023 13:29:46 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id b1so19839700ybn.11;
        Tue, 31 Jan 2023 13:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rfmL6XbGFaZZiwExIz/Vml+AX2Dv+8MgOe49YHesH6A=;
        b=BqOzWUPWRSBGyKlUZADAoA6Ez3rkSxfiFhlL5SiAtXlB1bGdhLVrTrCuaf1Fyt9yIH
         0XYpXPsq+2njSfi9Uwrtggf+zjAwgElZYBlT0MyO3IXidnBzgQNmLDIeC2VfwgMy7K9o
         KSq3ifc/VBDx0nlP9a8UuTkbtY36885Q9AfrVBbK4XXnSpFWaVbGwLtuwfaqM6JO9+7M
         7aOHcX4vsKx/4QasagkqaxLutzcssNvaPnTFLB45nMO9NxJ4FU5FjxjVmlo3Az+0Sjx6
         e9lOUFQ9+DYfnCpG7hVhz/dl47luY2evlpmkvlIA0xX9Cw7XaaVYVepof6xlO8vZRR1W
         67ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rfmL6XbGFaZZiwExIz/Vml+AX2Dv+8MgOe49YHesH6A=;
        b=TkLShtfxJ+zV3ui1Nk3ugh2g/yZBMnEFlMavzK6UvwORG8wqFJ8aT1KYuucTSpwEDe
         P5gmYyrNXM0vKcZZ6djHMsQ1ElsQeFjqzak+lhUfqQgLpJP2KrO0pXHq/hBv4DdbJLnz
         VJyLGgoWd3evKu/ekpa6Axd1+fCczWo9i8ySMzL9xu0dH9oP7VG+wm1JX11McHT0Gl4b
         Qu/ZM7rQtVe/t9kWDMxz1h3F4hCGLtM+vcuiiFVGlWjbOy5jl9b4kEmqrIhUwIGb4wyX
         h0SqnWeRnkB3uOpiB0o0UW51YRtX1mX6QmRGbkseaHbpkVl6t79VC6VpaW5W20L15cyf
         5skg==
X-Gm-Message-State: AO0yUKVlQMP8fR721VoUz3YeYq/LvkQVqiCfn6gtfHGsixYfxaDBoqT9
        XRxgcXEMjvfAMVZB/KD1hGx5+PLeTJ7YHkymER4=
X-Google-Smtp-Source: AK7set+cX+YpomhQ4Czh6Py0P036zLqq4Y5aOkdWPiRhUjjJoiz4ahSEog6ZMdbN/NNORaiNk3K8MIiSvCoU19PplvY=
X-Received: by 2002:a25:bd4:0:b0:80b:707c:58ab with SMTP id
 203-20020a250bd4000000b0080b707c58abmr68618ybl.255.1675200585327; Tue, 31 Jan
 2023 13:29:45 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <20230129233928.f3wf6dd6ep75w4vz@MacBook-Pro-6.local>
 <CAJnrk1ap0dsdEzR31x0=9hTaA=4xUU+yvgT8=Ur3tEUYur=Edw@mail.gmail.com>
 <20230131053605.g7o75yylku6nusnp@macbook-pro-6.dhcp.thefacebook.com>
 <CAJnrk1Z_GB_ynL5kEaVQaxYsPFjad+3dk8JWKqDfvb1VHHavwg@mail.gmail.com> <CAADnVQLKriT9p_ULKnLSkAZNcheQxQERv_ijLezP2NTE_mWR0w@mail.gmail.com>
In-Reply-To: <CAADnVQLKriT9p_ULKnLSkAZNcheQxQERv_ijLezP2NTE_mWR0w@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 31 Jan 2023 13:29:34 -0800
Message-ID: <CAJnrk1bL9hAiAraNq4j=sXt-HTDoOdcGCYieqcegf7VdM0rauw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:50 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 31, 2023 at 9:55 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 9:36 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Jan 30, 2023 at 04:44:12PM -0800, Joanne Koong wrote:
> > > > On Sun, Jan 29, 2023 at 3:39 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Jan 27, 2023 at 11:17:01AM -0800, Joanne Koong wrote:
> > > > > > Add skb dynptrs, which are dynptrs whose underlying pointer points
> > > > > > to a skb. The dynptr acts on skb data. skb dynptrs have two main
> > > > > > benefits. One is that they allow operations on sizes that are not
> > > > > > statically known at compile-time (eg variable-sized accesses).
> > > > > > Another is that parsing the packet data through dynptrs (instead of
> > > > > > through direct access of skb->data and skb->data_end) can be more
> > > > > > ergonomic and less brittle (eg does not need manual if checking for
> > > > > > being within bounds of data_end).
> > > > > >
> > > > > > For bpf prog types that don't support writes on skb data, the dynptr is
> > > > > > read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> > > > > > will return a data slice that is read-only where any writes to it will
> > > > > > be rejected by the verifier).
> > > > > >
> > > > > > For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> > > > > > interfaces, reading and writing from/to data in the head as well as from/to
> > > > > > non-linear paged buffers is supported. For data slices (through the
> > > > > > bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> > > > > > must first call bpf_skb_pull_data() to pull the data into the linear
> > > > > > portion.
> > > > >
> > > > > Looks like there is an assumption in parts of this patch that
> > > > > linear part of skb is always writeable. That's not the case.
> > > > > See if (ops->gen_prologue || env->seen_direct_write) in convert_ctx_accesses().
> > > > > For TC progs it calls bpf_unclone_prologue() which adds hidden
> > > > > bpf_skb_pull_data() in the beginning of the prog to make it writeable.
> > > >
> > > > I think we can make this assumption? For writable progs (referenced in
> > > > the may_access_direct_pkt_data() function), all of them have a
> > > > gen_prologue that unclones the buffer (eg tc_cls_act, lwt_xmit, sk_skb
> > > > progs) or their linear portion is okay to write into by default (eg
> > > > xdp, sk_msg, cg_sockopt progs).
> > >
> > > but the patch was preserving seen_direct_write in some cases.
> > > I'm still confused.
> >
> > seen_direct_write is used to determine whether to actually unclone or
> > not in the program's prologue function (eg tc_cls_act_prologue() ->
> > bpf_unclone_prologue() where in bpf_unclone_prologue(), if
> > direct_write was not true, then it can skip doing the actual
> > uncloning).
> >
> > I think the part of the patch you're talking about regarding
> > seen_direct_write is this in check_helper_call():
> >
> > + if (func_id == BPF_FUNC_dynptr_data &&
> > +    dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > +   bool seen_direct_write = env->seen_direct_write;
> > +
> > +   regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > +   if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > +     regs[BPF_REG_0].type |= MEM_RDONLY;
> > +   else
> > +     /*
> > +     * Calling may_access_direct_pkt_data() will set
> > +     * env->seen_direct_write to true if the skb is
> > +     * writable. As an optimization, we can ignore
> > +     * setting env->seen_direct_write.
> > +     *
> > +     * env->seen_direct_write is used by skb
> > +     * programs to determine whether the skb's page
> > +     * buffers should be cloned. Since data slice
> > +     * writes would only be to the head, we can skip
> > +     * this.
> > +     */
> > +     env->seen_direct_write = seen_direct_write;
> > + }
> >
> > If the data slice for a skb dynptr is writable, then seen_direct_write
> > gets set to true (done internally in may_access_direct_pkt_data()) so
> > that the skb is actually uncloned, whereas if it's read-only, then
> > env->seen_direct_write gets reset to its original value (since the
> > may_access_direct_pkt_data() call will have set env->seen_direct_write
> > to true)
>
> I'm still confused.
> When may_access_direct_pkt_data() returns false
> it doesn't change seen_direct_write.
> When it returns true it also sets seen_direct_write=true.
> But the code above restores it to whatever value it had before.
> How is this correct?
> Are you saying that another may_access_direct_pkt_data() gets
> called somewhere in the verifier that sets seen_direct_write=true?
> But what's the harm in doing it twice or N times in all cases?

I'm confused now too. I added this in v7, judging from the comment
block, I think I added this because I thought uncloning an skb only
needs to happen if the skb's page buffers get written to (aka only if
the skb needs to be pulled), not if it's linear portion gets written
to. This is incorrect - writing to the linear part also needs to
unclone the skb. I will fix this section when I resubmit
