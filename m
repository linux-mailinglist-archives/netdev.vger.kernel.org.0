Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61368214D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjAaBNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAaBNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:13:32 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B182D46;
        Mon, 30 Jan 2023 17:13:31 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-4c24993965eso183777197b3.12;
        Mon, 30 Jan 2023 17:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dhf4y1fJLEC86HcvqL9Le+F6IAiYYM0N2qL8VT2b4Ic=;
        b=BXWbpb/DQEulNYbvdjW82Gr7lLZYzbcRTbuaO8+OmomTm5MwvKj2/I/Jk1HxVcUhh0
         MFvbCC1et7lAqE99hwQQywfZqk6kksSPprx6LO4y+La3QCfB7Ses/xGWP26PWtIGFYDu
         uWaoEApBWJta2GhPH8kAhjD9DErbk2rKe/L50pTddU/DB3fy8WtOGQ8MNhfw/yzEGlaZ
         fSIZvD/BxFFQ5LeGxWD1a0eFR39psK8Yd4bjf7BhHDbckRXvKfznfMJXN9GbLobiiJLl
         DU3KAQR5hbMBwpmDcJO1Zz6m5p0anV8oJPOlkqKXEGQqAzp+AUzIZE8iilupUtBXMHGL
         POuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dhf4y1fJLEC86HcvqL9Le+F6IAiYYM0N2qL8VT2b4Ic=;
        b=2KZOWw8cyjtWbx2bfFAbENG7K9/J3bbOKi+BTngPSS6uhNQ6WJJU9mV59NKWJnYZd4
         NP5fiUufIAggLWWAeLWBaK2f1268v0a/Y3IZLbJPZqMjWs9zVs4RXFaveb3ZaV5YHQd/
         vWFiEtSQb2Hb9/nW0VofyAZ3cRJKy7PSyfzSHgDRz2nsqHLI+9qu6V5nNIO2U8ViVpUR
         crw9aD++jM2m9CFhdivVdQABk0y7JVJS0bBLCnp5r1YAbl6IsuW9fX6dImD+AOAC08dR
         i9UheDC5gR8hTPnUFXfgRZ7cgTx1Kb15KLIgPxd+pi0HPCRY3xvkfHJmksLC+I5hh43/
         UHVA==
X-Gm-Message-State: AO0yUKVBeo5td+DZiPvv9niScON7xwzBwxHv4+bIhX+bvFHZy4JzBCOe
        Zn2im+2FSMABapLLZsnuSMRiFD+TvgFIz4dTM4Y=
X-Google-Smtp-Source: AK7set+x2AOlM6LFmLXNFkZ1ypgWXRSclHParwoP+FPRGFwJGxdKFvX1KYFZE6yhs/1T1ASyJCUJoo0MjWh6gyJZJRY=
X-Received: by 2002:a81:6883:0:b0:506:3b16:8373 with SMTP id
 d125-20020a816883000000b005063b168373mr2868487ywc.24.1675127610929; Mon, 30
 Jan 2023 17:13:30 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <CAEf4BzYK2JOtChh4VNTg4L9-u9kay3zzG8X6GqTkak22E37wig@mail.gmail.com>
 <CAJnrk1YEN+9dn4DKQQKAQGR4RU9HVVrVD2A3O7chet4tC6OG5A@mail.gmail.com> <CAEf4BzYA2sT7z+2W1XOd_nk2PC3mKST7MC2X8pRg1HfFK3yFpA@mail.gmail.com>
In-Reply-To: <CAEf4BzYA2sT7z+2W1XOd_nk2PC3mKST7MC2X8pRg1HfFK3yFpA@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 30 Jan 2023 17:13:19 -0800
Message-ID: <CAJnrk1Y61=Qc3fndvAPghgu8+iNwzU2wvtwsi2jk_NeEwdP9aw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        memxor@gmail.com, kernel-team@fb.com
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

On Mon, Jan 30, 2023 at 5:06 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 4:56 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 4:48 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Jan 27, 2023 at 11:18 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> > > >
> > > > Add skb dynptrs, which are dynptrs whose underlying pointer points
> > > > to a skb. The dynptr acts on skb data. skb dynptrs have two main
> > > > benefits. One is that they allow operations on sizes that are not
> > > > statically known at compile-time (eg variable-sized accesses).
> > > > Another is that parsing the packet data through dynptrs (instead of
> > > > through direct access of skb->data and skb->data_end) can be more
> > > > ergonomic and less brittle (eg does not need manual if checking for
> > > > being within bounds of data_end).
> > > >
> > > > For bpf prog types that don't support writes on skb data, the dynptr is
> > > > read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> > > > will return a data slice that is read-only where any writes to it will
> > > > be rejected by the verifier).
> > > >
> > > > For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> > > > interfaces, reading and writing from/to data in the head as well as from/to
> > > > non-linear paged buffers is supported. For data slices (through the
> > > > bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> > > > must first call bpf_skb_pull_data() to pull the data into the linear
> > > > portion.
> > > >
> > > > Any bpf_dynptr_write() automatically invalidates any prior data slices
> > > > to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> > > > to data in a paged buffer, so it will need to pull the buffer first into
> > > > the head. The reason it needs to be pulled instead of writing directly to
> > > > the paged buffers is because they may be cloned (only the head of the skb
> > > > is by default uncloned). As such, any bpf_dynptr_write() will
> > > > automatically have its prior data slices invalidated, even if the write
> > > > is to data in the skb head (the verifier has no way of differentiating
> > > > whether the write is to the head or paged buffers during program load
> > > > time). Please note as well that any other helper calls that change the
> > > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > > > slices of the skb dynptr as well. The stack trace for this is
> > > > check_helper_call() -> clear_all_pkt_pointers() ->
> > > > __clear_all_pkt_pointers() -> mark_reg_unknown().
> > > >
> > > > For examples of how skb dynptrs can be used, please see the attached
> > > > selftests.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > > >  include/linux/bpf.h            |  82 +++++++++------
> > > >  include/linux/filter.h         |  18 ++++
> > > >  include/uapi/linux/bpf.h       |  37 +++++--
> > > >  kernel/bpf/btf.c               |  18 ++++
> > > >  kernel/bpf/helpers.c           |  95 ++++++++++++++---
> > > >  kernel/bpf/verifier.c          | 185 ++++++++++++++++++++++++++-------
> > > >  net/core/filter.c              |  60 ++++++++++-
> > > >  tools/include/uapi/linux/bpf.h |  37 +++++--
> > > >  8 files changed, 432 insertions(+), 100 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > >  static const struct bpf_func_proto bpf_dynptr_write_proto = {
> > > > @@ -1560,6 +1595,8 @@ static const struct bpf_func_proto bpf_dynptr_write_proto = {
> > > >
> > > >  BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u32, len)
> > > >  {
> > > > +       enum bpf_dynptr_type type;
> > > > +       void *data;
> > > >         int err;
> > > >
> > > >         if (!ptr->data)
> > > > @@ -1569,10 +1606,36 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u3
> > > >         if (err)
> > > >                 return 0;
> > > >
> > > > -       if (bpf_dynptr_is_rdonly(ptr))
> > > > -               return 0;
> > > > +       type = bpf_dynptr_get_type(ptr);
> > > > +
> > > > +       switch (type) {
> > > > +       case BPF_DYNPTR_TYPE_LOCAL:
> > > > +       case BPF_DYNPTR_TYPE_RINGBUF:
> > > > +               if (bpf_dynptr_is_rdonly(ptr))
> > > > +                       return 0;
> > >
> > > will something break if we return ptr->data for read-only LOCAL/RINGBUF dynptr?
> >
> > There will be nothing guarding against direct writes into read-only
> > LOCAL/RINGBUF dynptrs if we return ptr->data. For skb type dynptrs,
> > it's guarded by the ptr->data return pointer being marked as
> > MEM_RDONLY in the verifier if the skb is non-writable.
> >
>
> Ah, so we won't add MEM_RDONLY for bpf_dynptr_data()'s returned
> PTR_TO_MEM if we know (statically) that dynptr is read-only?

I think you meant will, not won't? If so, then yes we only add
MEM_RDONLY for the returned data slice if we can pre-determine that
the dynptr is read-only, else bpf_dynptr_data() will return null.

>
> Ok, not a big deal, just something that we might want to improve in the future.

I'm curious to hear how you think this could be improved. If we're not
able to know statically whether the dynptr is read-only or writable,
then there's no way to enforce it in the verifier before the bpf
program runs. Or is there some way to do this?

>
> > >
> > > > +
> > > > +               data = ptr->data;
> > > > +               break;
> > > > +       case BPF_DYNPTR_TYPE_SKB:
> > > > +       {
> > > > +               struct sk_buff *skb = ptr->data;
> > > >
> > >
> > > [...]
