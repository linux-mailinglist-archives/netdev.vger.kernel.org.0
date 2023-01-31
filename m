Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA04682143
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjAaBGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjAaBGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:06:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AC82FCE7;
        Mon, 30 Jan 2023 17:06:37 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id kt14so37310773ejc.3;
        Mon, 30 Jan 2023 17:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y+01Wecvb6wB30dohyUTU0q4r1Qli5tQbqJHRGrfKA=;
        b=CjvAynRp3Xg51e+hL1QgBebU5qlyGXsxoIY9xb6WrQuz3bPLgoq9w36gi4qcw+KY9H
         eaGrzkRCfmy7veNrx9N8FBQBgmX4MKs4Pj8WWdPgfjgicOaN60j/MqpX8c7VQBlT2onR
         Jfc/doYNl2IEHrFyhOUQpU3Zh9cPeOr43mFA1u8yY/hqt2MO+axPw87DJlk6U9Rp6DNn
         9xjr8SUJ6HG4L2Af5fCIYRirqCi9bp8WNOiQb6jXYjT9xdzc2Vc3mlFIVdMb53tgdVqL
         ESVj+zIW2G85ld+ldLY9HGVrAas5xuMe+TQX5tD+UxlFQFgVt1tauFImS90/KBauo/Pd
         MM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Y+01Wecvb6wB30dohyUTU0q4r1Qli5tQbqJHRGrfKA=;
        b=KgmuRQNMRN0MISC7kFaCCHlKEg4jLngeLsJeXdEv7RwW6pXms3mtNAkErCAVSstPtU
         dn+ryM0rXC4RXEs7R05SLagrfzZmm4qgDlIf7j7hk0EqBLbmcQ5acXusTdh4AzHy9w4s
         MIIQ730KV6QovmbMjSi7d6Kk5CdkNv+hZjasO0YLkcSIDjVR6/6dAAL6Xi1RPE40NF29
         07zqQtptX5Jm/5N9D1oCqYKmvZVuC1HoWq/EISQ3n6ST6gKK1pReltDDqhXuyVeiDnHG
         1WH9DI+5DOU0U5fc2f+1b+u5LF1w0t8ZBAV8UT1S4pXVzXFEqr7+RnND3cd0vYVJRxF5
         eQPQ==
X-Gm-Message-State: AO0yUKXhPzLtOxD2xtDI9EddjEPCPxJ1wqBLWoLpWOLwAvU9E9+xaXFq
        tGyK0j+GfNkK+IZk6Vm46PdSBg9djXIR0KTJ4Q0=
X-Google-Smtp-Source: AK7set93lWnzLFaK0fREQomYRY8NNahPeEXvOIoJYiSx6O2mvYbCqFgaAg2J+GQXhOBfRFIjJ+YOeErHJ0c27kl7h5Q=
X-Received: by 2002:a17:907:2cea:b0:88b:93c0:34f2 with SMTP id
 hz10-20020a1709072cea00b0088b93c034f2mr543193ejc.296.1675127195989; Mon, 30
 Jan 2023 17:06:35 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <CAEf4BzYK2JOtChh4VNTg4L9-u9kay3zzG8X6GqTkak22E37wig@mail.gmail.com>
 <CAJnrk1YEN+9dn4DKQQKAQGR4RU9HVVrVD2A3O7chet4tC6OG5A@mail.gmail.com>
In-Reply-To: <CAJnrk1YEN+9dn4DKQQKAQGR4RU9HVVrVD2A3O7chet4tC6OG5A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Jan 2023 17:06:24 -0800
Message-ID: <CAEf4BzYA2sT7z+2W1XOd_nk2PC3mKST7MC2X8pRg1HfFK3yFpA@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
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

On Mon, Jan 30, 2023 at 4:56 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 4:48 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jan 27, 2023 at 11:18 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > Add skb dynptrs, which are dynptrs whose underlying pointer points
> > > to a skb. The dynptr acts on skb data. skb dynptrs have two main
> > > benefits. One is that they allow operations on sizes that are not
> > > statically known at compile-time (eg variable-sized accesses).
> > > Another is that parsing the packet data through dynptrs (instead of
> > > through direct access of skb->data and skb->data_end) can be more
> > > ergonomic and less brittle (eg does not need manual if checking for
> > > being within bounds of data_end).
> > >
> > > For bpf prog types that don't support writes on skb data, the dynptr is
> > > read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> > > will return a data slice that is read-only where any writes to it will
> > > be rejected by the verifier).
> > >
> > > For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> > > interfaces, reading and writing from/to data in the head as well as from/to
> > > non-linear paged buffers is supported. For data slices (through the
> > > bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> > > must first call bpf_skb_pull_data() to pull the data into the linear
> > > portion.
> > >
> > > Any bpf_dynptr_write() automatically invalidates any prior data slices
> > > to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> > > to data in a paged buffer, so it will need to pull the buffer first into
> > > the head. The reason it needs to be pulled instead of writing directly to
> > > the paged buffers is because they may be cloned (only the head of the skb
> > > is by default uncloned). As such, any bpf_dynptr_write() will
> > > automatically have its prior data slices invalidated, even if the write
> > > is to data in the skb head (the verifier has no way of differentiating
> > > whether the write is to the head or paged buffers during program load
> > > time). Please note as well that any other helper calls that change the
> > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > > slices of the skb dynptr as well. The stack trace for this is
> > > check_helper_call() -> clear_all_pkt_pointers() ->
> > > __clear_all_pkt_pointers() -> mark_reg_unknown().
> > >
> > > For examples of how skb dynptrs can be used, please see the attached
> > > selftests.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  include/linux/bpf.h            |  82 +++++++++------
> > >  include/linux/filter.h         |  18 ++++
> > >  include/uapi/linux/bpf.h       |  37 +++++--
> > >  kernel/bpf/btf.c               |  18 ++++
> > >  kernel/bpf/helpers.c           |  95 ++++++++++++++---
> > >  kernel/bpf/verifier.c          | 185 ++++++++++++++++++++++++++-------
> > >  net/core/filter.c              |  60 ++++++++++-
> > >  tools/include/uapi/linux/bpf.h |  37 +++++--
> > >  8 files changed, 432 insertions(+), 100 deletions(-)
> > >
> >
> > [...]
> >
> > >  static const struct bpf_func_proto bpf_dynptr_write_proto = {
> > > @@ -1560,6 +1595,8 @@ static const struct bpf_func_proto bpf_dynptr_write_proto = {
> > >
> > >  BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u32, len)
> > >  {
> > > +       enum bpf_dynptr_type type;
> > > +       void *data;
> > >         int err;
> > >
> > >         if (!ptr->data)
> > > @@ -1569,10 +1606,36 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u3
> > >         if (err)
> > >                 return 0;
> > >
> > > -       if (bpf_dynptr_is_rdonly(ptr))
> > > -               return 0;
> > > +       type = bpf_dynptr_get_type(ptr);
> > > +
> > > +       switch (type) {
> > > +       case BPF_DYNPTR_TYPE_LOCAL:
> > > +       case BPF_DYNPTR_TYPE_RINGBUF:
> > > +               if (bpf_dynptr_is_rdonly(ptr))
> > > +                       return 0;
> >
> > will something break if we return ptr->data for read-only LOCAL/RINGBUF dynptr?
>
> There will be nothing guarding against direct writes into read-only
> LOCAL/RINGBUF dynptrs if we return ptr->data. For skb type dynptrs,
> it's guarded by the ptr->data return pointer being marked as
> MEM_RDONLY in the verifier if the skb is non-writable.
>

Ah, so we won't add MEM_RDONLY for bpf_dynptr_data()'s returned
PTR_TO_MEM if we know (statically) that dynptr is read-only?

Ok, not a big deal, just something that we might want to improve in the future.

> >
> > > +
> > > +               data = ptr->data;
> > > +               break;
> > > +       case BPF_DYNPTR_TYPE_SKB:
> > > +       {
> > > +               struct sk_buff *skb = ptr->data;
> > >
> >
> > [...]
