Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680B7682153
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjAaBTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjAaBTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:19:41 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BC610ABA;
        Mon, 30 Jan 2023 17:19:40 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id me3so37309469ejb.7;
        Mon, 30 Jan 2023 17:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9KxgH+UlAu7biJLs1wk3A2M5S6YX4jkQwyD5Isem88w=;
        b=XmUCHqRZuZ24lDkvwFutaOwe2yOwrYwoeeW4KP/qE47WTB5XYo4HcgxGDRYVIpy68E
         +08o0JU3ur6+orm/eWPWQI7etNef3r2Si+jtHQsMa/YLpgIbuUn94WGq5TjyShdcSRP9
         qCh+Y8qvW9qAMdN5hSZB9j8dsFB+l5j7Cpvx3ciSkHR4Y5GGvHFwxTFkQAIz5yR8emI2
         ypThasjLzpPAY6464YRZCzG/W0iz3U36cpgktX8Z6zrLmKRs5gVsAsLKT9pgw5oaxQJn
         fXBnuVP7y+sBJuBqajAY0w3N7da0nW7vKSzKuJMKOFhJzSwJo23p+gyFTCmF9TWYAr6s
         j4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9KxgH+UlAu7biJLs1wk3A2M5S6YX4jkQwyD5Isem88w=;
        b=z5hJJ5krNZVL2TKhEeXAnBjA55fEmy//6JdHqj/BS8DLVWyEyodnJIk7xjHAN6Ig6X
         1pqhZlj8vUpg8FO2qhbr0BqJFWo18WmBEz1IjpXTDZqCRfIEBt3MITQ095SHzA7VYjO2
         0hmoN+7mrfjce8ZoaQWNPhRWR83VokW27kLVdQjoyD3+iEpXRE9gEXYotzEZzLyB1f6e
         kHgcqwZtIVm5zAQWnck81ffuPxMri85puwDTYlr3iLIfZ2yQ2hy/56oRgPd+n9KW3WAs
         L/QTXhGEjM2Os2bDfKBP1ttvq5Cz1JSjBH+Sx4ggzxll8qXW25iM7lpDMO0ZIeq/i8Bk
         tHRw==
X-Gm-Message-State: AO0yUKV6n0IKYeQfIwyJhVjuGkkncQP6QOkjH77yx+jtCu4MRR4B2HG2
        zfszgUKRhURIZxzxGhtvDAQctbwDYyJUZ62Sp7c=
X-Google-Smtp-Source: AK7set8gOqWUVGiY8Ju1ez/xLJ9DyA+b4RV4ZfurvHiJMvUOURMPpIQHlAStvLHt35Shxy8hE5ovSy5a7qBqJzUhx70=
X-Received: by 2002:a17:907:175d:b0:885:dc8a:a7c5 with SMTP id
 lf29-20020a170907175d00b00885dc8aa7c5mr2162402ejc.180.1675127978713; Mon, 30
 Jan 2023 17:19:38 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <CAEf4BzYK2JOtChh4VNTg4L9-u9kay3zzG8X6GqTkak22E37wig@mail.gmail.com>
 <CAJnrk1YEN+9dn4DKQQKAQGR4RU9HVVrVD2A3O7chet4tC6OG5A@mail.gmail.com>
 <CAEf4BzYA2sT7z+2W1XOd_nk2PC3mKST7MC2X8pRg1HfFK3yFpA@mail.gmail.com> <CAJnrk1Y61=Qc3fndvAPghgu8+iNwzU2wvtwsi2jk_NeEwdP9aw@mail.gmail.com>
In-Reply-To: <CAJnrk1Y61=Qc3fndvAPghgu8+iNwzU2wvtwsi2jk_NeEwdP9aw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Jan 2023 17:19:26 -0800
Message-ID: <CAEf4BzY7GFVWpMKszVL3t_SRAeGPRG9SgKFO_srCZdavDWFDKg@mail.gmail.com>
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

On Mon, Jan 30, 2023 at 5:13 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 5:06 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 4:56 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > On Mon, Jan 30, 2023 at 4:48 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Jan 27, 2023 at 11:18 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > >
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
> > > > >
> > > > > Any bpf_dynptr_write() automatically invalidates any prior data slices
> > > > > to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> > > > > to data in a paged buffer, so it will need to pull the buffer first into
> > > > > the head. The reason it needs to be pulled instead of writing directly to
> > > > > the paged buffers is because they may be cloned (only the head of the skb
> > > > > is by default uncloned). As such, any bpf_dynptr_write() will
> > > > > automatically have its prior data slices invalidated, even if the write
> > > > > is to data in the skb head (the verifier has no way of differentiating
> > > > > whether the write is to the head or paged buffers during program load
> > > > > time). Please note as well that any other helper calls that change the
> > > > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > > > > slices of the skb dynptr as well. The stack trace for this is
> > > > > check_helper_call() -> clear_all_pkt_pointers() ->
> > > > > __clear_all_pkt_pointers() -> mark_reg_unknown().
> > > > >
> > > > > For examples of how skb dynptrs can be used, please see the attached
> > > > > selftests.
> > > > >
> > > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > > ---
> > > > >  include/linux/bpf.h            |  82 +++++++++------
> > > > >  include/linux/filter.h         |  18 ++++
> > > > >  include/uapi/linux/bpf.h       |  37 +++++--
> > > > >  kernel/bpf/btf.c               |  18 ++++
> > > > >  kernel/bpf/helpers.c           |  95 ++++++++++++++---
> > > > >  kernel/bpf/verifier.c          | 185 ++++++++++++++++++++++++++-------
> > > > >  net/core/filter.c              |  60 ++++++++++-
> > > > >  tools/include/uapi/linux/bpf.h |  37 +++++--
> > > > >  8 files changed, 432 insertions(+), 100 deletions(-)
> > > > >
> > > >
> > > > [...]
> > > >
> > > > >  static const struct bpf_func_proto bpf_dynptr_write_proto = {
> > > > > @@ -1560,6 +1595,8 @@ static const struct bpf_func_proto bpf_dynptr_write_proto = {
> > > > >
> > > > >  BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u32, len)
> > > > >  {
> > > > > +       enum bpf_dynptr_type type;
> > > > > +       void *data;
> > > > >         int err;
> > > > >
> > > > >         if (!ptr->data)
> > > > > @@ -1569,10 +1606,36 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u3
> > > > >         if (err)
> > > > >                 return 0;
> > > > >
> > > > > -       if (bpf_dynptr_is_rdonly(ptr))
> > > > > -               return 0;
> > > > > +       type = bpf_dynptr_get_type(ptr);
> > > > > +
> > > > > +       switch (type) {
> > > > > +       case BPF_DYNPTR_TYPE_LOCAL:
> > > > > +       case BPF_DYNPTR_TYPE_RINGBUF:
> > > > > +               if (bpf_dynptr_is_rdonly(ptr))
> > > > > +                       return 0;
> > > >
> > > > will something break if we return ptr->data for read-only LOCAL/RINGBUF dynptr?
> > >
> > > There will be nothing guarding against direct writes into read-only
> > > LOCAL/RINGBUF dynptrs if we return ptr->data. For skb type dynptrs,
> > > it's guarded by the ptr->data return pointer being marked as
> > > MEM_RDONLY in the verifier if the skb is non-writable.
> > >
> >
> > Ah, so we won't add MEM_RDONLY for bpf_dynptr_data()'s returned
> > PTR_TO_MEM if we know (statically) that dynptr is read-only?
>
> I think you meant will, not won't? If so, then yes we only add
> MEM_RDONLY for the returned data slice if we can pre-determine that
> the dynptr is read-only, else bpf_dynptr_data() will return null.
>
> >
> > Ok, not a big deal, just something that we might want to improve in the future.
>
> I'm curious to hear how you think this could be improved. If we're not
> able to know statically whether the dynptr is read-only or writable,
> then there's no way to enforce it in the verifier before the bpf
> program runs. Or is there some way to do this?

I might be just confused, I thought the conclusion from previous
discussions were that we do know statically if dynptr is read-only? If
that's not the case, then yeah, we can't really do much about this.

Either way, I think this is a small thing, as in practice
LOCAL/RINGBUF dynptrs will always be read-write, right?

>
> >
> > > >
> > > > > +
> > > > > +               data = ptr->data;
> > > > > +               break;
> > > > > +       case BPF_DYNPTR_TYPE_SKB:
> > > > > +       {
> > > > > +               struct sk_buff *skb = ptr->data;
> > > > >
> > > >
> > > > [...]
