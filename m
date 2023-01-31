Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D8B6836D4
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjAaTuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjAaTub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:50:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F04166C1;
        Tue, 31 Jan 2023 11:50:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bk15so44878655ejb.9;
        Tue, 31 Jan 2023 11:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I8CmauAmc92p1rT/LQHNRgbh4sF4sm5e2ogKtoQzhUw=;
        b=hvp3wTLJShWXHNLkru1jkQ8s98MMdGHO7choYPCaOoJD9Me94FHB2Ckg5BgGNuTJyH
         KO564hY6sH3i2TC4gw2Bwo2s5vAPAY7afAqVHoB8laT2JCeeAsxhIwFnhjqk+vfIL1H8
         bwyKNhhtiXoCZeHutGic0VsH7EUI1y425IUXLKjWKARZx94cuH2L46EmuSCZPaeDwUeG
         EPxWW0y4oT+MGLMcgRF4TMe6hijQSjA+PxX9PvhM/oWTD0x5CgcTvhmOOlgGpa0+ImeA
         NQsIGzLAjurP5xNyRFzyviaHsVVIZK0vp2OJGZIeKIfDqyyOF/aVuVbstM1NMORTZNCj
         +t0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8CmauAmc92p1rT/LQHNRgbh4sF4sm5e2ogKtoQzhUw=;
        b=F2e7k1MUuZ8W8YTsvN8KyDeh2xfwClXaIIWEBtPTtsxWpU5WmcFOt/ZLArQSNglCWC
         /Css+LhGZDl2LX/rrrvjCx5zdgJuDMW8kSH1oVwgZ7R6fxwc9G1KIDks1yKNkuZcdbze
         MyB4SOr+9gdB67CCV8oLSlZCaGWJJye5PXXFaAgxwpDl8+j+Lz7qlyYYmmm3KnTaajF5
         Cb8azeZen6kR+jlPDRksWffH1csL2ppLijXg5WWKXfXMNgxfNGVwJQ/jO7F435qG23uX
         Rgd9IntNQNP3nw+Ow021hyGvgjSGdnYZVaTX8rVYajeEmrgi7eKJ6ZKqg/vdO2EWuqiW
         BT7g==
X-Gm-Message-State: AO0yUKWE8o21ncfTdcDGbmRVR7QJfk4jevdQJmUNy9S92lHeaM0MVI3f
        0PKAYNy90N615ctodxf4eCg+lNlx6MqLA702CbE=
X-Google-Smtp-Source: AK7set8dUq3w5VLaHchzRbzY274S17GS0Vl8YlpIPtzycTIdymtQty25/502G9CyX6CtXQ3VeyliypgTeke3/UJSlo8=
X-Received: by 2002:a17:907:780c:b0:88c:1d3d:6fab with SMTP id
 la12-20020a170907780c00b0088c1d3d6fabmr1193934ejc.299.1675194629532; Tue, 31
 Jan 2023 11:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <20230129233928.f3wf6dd6ep75w4vz@MacBook-Pro-6.local>
 <CAJnrk1ap0dsdEzR31x0=9hTaA=4xUU+yvgT8=Ur3tEUYur=Edw@mail.gmail.com>
 <20230131053605.g7o75yylku6nusnp@macbook-pro-6.dhcp.thefacebook.com> <CAJnrk1Z_GB_ynL5kEaVQaxYsPFjad+3dk8JWKqDfvb1VHHavwg@mail.gmail.com>
In-Reply-To: <CAJnrk1Z_GB_ynL5kEaVQaxYsPFjad+3dk8JWKqDfvb1VHHavwg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 31 Jan 2023 11:50:18 -0800
Message-ID: <CAADnVQLKriT9p_ULKnLSkAZNcheQxQERv_ijLezP2NTE_mWR0w@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
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

On Tue, Jan 31, 2023 at 9:55 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 9:36 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 04:44:12PM -0800, Joanne Koong wrote:
> > > On Sun, Jan 29, 2023 at 3:39 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Jan 27, 2023 at 11:17:01AM -0800, Joanne Koong wrote:
> > > > > Add skb dynptrs, which are dynptrs whose underlying pointer points
> > > > > to a skb. The dynptr acts on skb data. skb dynptrs have two main
> > > > > benefits. One is that they allow operations on sizes that are not
> > > > > statically known at compile-time (eg variable-sized accesses).
> > > > > Another is that parsing the packet data through dynptrs (instead of
> > > > > through direct access of skb->data and skb->data_end) can be more
> > > > > ergonomic and less brittle (eg does not need manual if checking for
> > > > > being within bounds of data_end).
> > > > >
> > > > > For bpf prog types that don't support writes on skb data, the dynptr is
> > > > > read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> > > > > will return a data slice that is read-only where any writes to it will
> > > > > be rejected by the verifier).
> > > > >
> > > > > For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> > > > > interfaces, reading and writing from/to data in the head as well as from/to
> > > > > non-linear paged buffers is supported. For data slices (through the
> > > > > bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> > > > > must first call bpf_skb_pull_data() to pull the data into the linear
> > > > > portion.
> > > >
> > > > Looks like there is an assumption in parts of this patch that
> > > > linear part of skb is always writeable. That's not the case.
> > > > See if (ops->gen_prologue || env->seen_direct_write) in convert_ctx_accesses().
> > > > For TC progs it calls bpf_unclone_prologue() which adds hidden
> > > > bpf_skb_pull_data() in the beginning of the prog to make it writeable.
> > >
> > > I think we can make this assumption? For writable progs (referenced in
> > > the may_access_direct_pkt_data() function), all of them have a
> > > gen_prologue that unclones the buffer (eg tc_cls_act, lwt_xmit, sk_skb
> > > progs) or their linear portion is okay to write into by default (eg
> > > xdp, sk_msg, cg_sockopt progs).
> >
> > but the patch was preserving seen_direct_write in some cases.
> > I'm still confused.
>
> seen_direct_write is used to determine whether to actually unclone or
> not in the program's prologue function (eg tc_cls_act_prologue() ->
> bpf_unclone_prologue() where in bpf_unclone_prologue(), if
> direct_write was not true, then it can skip doing the actual
> uncloning).
>
> I think the part of the patch you're talking about regarding
> seen_direct_write is this in check_helper_call():
>
> + if (func_id == BPF_FUNC_dynptr_data &&
> +    dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> +   bool seen_direct_write = env->seen_direct_write;
> +
> +   regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> +   if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> +     regs[BPF_REG_0].type |= MEM_RDONLY;
> +   else
> +     /*
> +     * Calling may_access_direct_pkt_data() will set
> +     * env->seen_direct_write to true if the skb is
> +     * writable. As an optimization, we can ignore
> +     * setting env->seen_direct_write.
> +     *
> +     * env->seen_direct_write is used by skb
> +     * programs to determine whether the skb's page
> +     * buffers should be cloned. Since data slice
> +     * writes would only be to the head, we can skip
> +     * this.
> +     */
> +     env->seen_direct_write = seen_direct_write;
> + }
>
> If the data slice for a skb dynptr is writable, then seen_direct_write
> gets set to true (done internally in may_access_direct_pkt_data()) so
> that the skb is actually uncloned, whereas if it's read-only, then
> env->seen_direct_write gets reset to its original value (since the
> may_access_direct_pkt_data() call will have set env->seen_direct_write
> to true)

I'm still confused.
When may_access_direct_pkt_data() returns false
it doesn't change seen_direct_write.
When it returns true it also sets seen_direct_write=true.
But the code above restores it to whatever value it had before.
How is this correct?
Are you saying that another may_access_direct_pkt_data() gets
called somewhere in the verifier that sets seen_direct_write=true?
But what's the harm in doing it twice or N times in all cases?
