Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2149734128F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhCSB6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhCSB6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:58:49 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF0C06174A;
        Thu, 18 Mar 2021 18:58:49 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id y133so4586561ybe.12;
        Thu, 18 Mar 2021 18:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYgK/vE3JJnvEhD/WTQMpX5ovo4FS4jNngr/T0RXNGU=;
        b=as2UpPyIJxONydn5hgHkUQiFvL3f8JKarVQs3/7+Eky5c6nDTghxt68PVe2Hd/xjtA
         aZzDJN81Phy3TAy/6kULziMvtZJ+nDOVnIzsqGQeyESebT1qpUuwK7kV1FQyRgjjOWYX
         6fsNR8NuKOy6RWHvEGcLjFVbmqYZgsGwPnj2OYEoKUCH7U+0FXa14F7tJpHUfoZAt++Q
         GfPJM5Un6obzHyItbHp4rL68qn//YAArM48eMO8IHbZCEV2h35uzvfoEvDQl80V4IFDB
         Je7NTPDdjN3P2htn12Fi/7eHgDQpK/8yu2ibr3GZZoG3LWbQIWHhvCECMWEmf0cedeI5
         vhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYgK/vE3JJnvEhD/WTQMpX5ovo4FS4jNngr/T0RXNGU=;
        b=PvJJrN4uFuezHnqfce2CU1D9E3S7/hejjrBAXV94RUkISdgxJUNjYR10mbvWCgfGo2
         8HRpAz8R4kzW4G5+n5ltQ2G/K4d3ppVSlyfBa661mtsjCdGVKSE5iiPhFP7jrJu0LHbA
         TmGY6KZ3T0b25d+dLLbKtazLZ6RrbpXq1hqRvg1IrV7XyhaNtXzC6DA9LqvgjS79ebMZ
         mnWbtJyphyC/L2muLrYBI+CUAQFB15/0VL6LsCR1SpEtpFdPnI1BoeDON8e3K+9Uufjq
         ef04/NqpL9LoTk6ay4OKOy0b0Vn1KLtdlzqIoSQ2DVOd01m732yv0D+zJ9gfD4w3hH4i
         5B3g==
X-Gm-Message-State: AOAM533ZO09Lk/422eo9CYBqwvnRlvLrBWRvpliafGpVtwRe5t+GialA
        VxZ0bCEjXwG2R2A1Xhlrjecy7WwJHBHypsmVaaU=
X-Google-Smtp-Source: ABdhPJy1CoWZf74TqU9bwdXAnkFg8FiYzwEXIVr3PxjAdB0dpjN624/cbUcfainoKg0vwKn1HCB2wLGf72gx5yaJY+w=
X-Received: by 2002:a25:db07:: with SMTP id g7mr3139273ybf.304.1616119128832;
 Thu, 18 Mar 2021 18:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210318063626.216024-1-Jianlin.Lv@arm.com> <939f6d78-b6f8-b9fc-35b7-e8560a8b020c@iogearbox.net>
In-Reply-To: <939f6d78-b6f8-b9fc-35b7-e8560a8b020c@iogearbox.net>
From:   Jianlin Lv <iecedge@gmail.com>
Date:   Fri, 19 Mar 2021 09:58:37 +0800
Message-ID: <CAFA-uR93P=Y6vxeq3426gp4F5apC2smqUJP7vJBjU4R+9ddguw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: Simplify expression for identify bpf mem type
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf@vger.kernel.org,
        kuba@kernel.org, simon.horman@netronome.com, davem@davemloft.net,
        ast@kernel.org, alexei.starovoitov@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 11:58 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/18/21 7:36 AM, Jianlin Lv wrote:
> > Added BPF_LD_ST_SIZE_MASK macro as mask of size modifier that help to
> > reduce the evaluation of expressions in if statements,
> > and remove BPF_SIZE_MASK in netronome driver.
> >
> > Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> > ---
> > v2: Move the bpf_LD_ST_SIZE_MASK macro definition to include/linux/bpf.h
> > ---
> >   drivers/net/ethernet/netronome/nfp/bpf/main.h |  8 +++-----
> >   include/linux/bpf.h                           |  1 +
> >   kernel/bpf/verifier.c                         | 12 ++++--------
> >   3 files changed, 8 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
> > index d0e17eebddd9..e90981e69763 100644
> > --- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
> > +++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
> > @@ -346,8 +346,6 @@ struct nfp_insn_meta {
> >       struct list_head l;
> >   };
> >
> > -#define BPF_SIZE_MASK        0x18
> > -
> >   static inline u8 mbpf_class(const struct nfp_insn_meta *meta)
> >   {
> >       return BPF_CLASS(meta->insn.code);
> > @@ -375,7 +373,7 @@ static inline bool is_mbpf_alu(const struct nfp_insn_meta *meta)
> >
> >   static inline bool is_mbpf_load(const struct nfp_insn_meta *meta)
> >   {
> > -     return (meta->insn.code & ~BPF_SIZE_MASK) == (BPF_LDX | BPF_MEM);
> > +     return (meta->insn.code & ~BPF_LD_ST_SIZE_MASK) == (BPF_LDX | BPF_MEM);
> >   }
> >
> >   static inline bool is_mbpf_jmp32(const struct nfp_insn_meta *meta)
> > @@ -395,7 +393,7 @@ static inline bool is_mbpf_jmp(const struct nfp_insn_meta *meta)
> >
> >   static inline bool is_mbpf_store(const struct nfp_insn_meta *meta)
> >   {
> > -     return (meta->insn.code & ~BPF_SIZE_MASK) == (BPF_STX | BPF_MEM);
> > +     return (meta->insn.code & ~BPF_LD_ST_SIZE_MASK) == (BPF_STX | BPF_MEM);
> >   }
> >
> >   static inline bool is_mbpf_load_pkt(const struct nfp_insn_meta *meta)
> > @@ -430,7 +428,7 @@ static inline bool is_mbpf_classic_store_pkt(const struct nfp_insn_meta *meta)
> >
> >   static inline bool is_mbpf_atomic(const struct nfp_insn_meta *meta)
> >   {
> > -     return (meta->insn.code & ~BPF_SIZE_MASK) == (BPF_STX | BPF_ATOMIC);
> > +     return (meta->insn.code & ~BPF_LD_ST_SIZE_MASK) == (BPF_STX | BPF_ATOMIC);
> >   }
> >
> >   static inline bool is_mbpf_mul(const struct nfp_insn_meta *meta)
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index a25730eaa148..e85924719c65 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -995,6 +995,7 @@ struct bpf_array {
> >                                BPF_F_RDONLY_PROG |    \
> >                                BPF_F_WRONLY |         \
> >                                BPF_F_WRONLY_PROG)
> > +#define BPF_LD_ST_SIZE_MASK  0x18    /* mask of size modifier */
> >
> >   #define BPF_MAP_CAN_READ    BIT(0)
> >   #define BPF_MAP_CAN_WRITE   BIT(1)
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index f9096b049cd6..29fdfdb8abfa 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -11384,15 +11384,11 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
> >       for (i = 0; i < insn_cnt; i++, insn++) {
> >               bpf_convert_ctx_access_t convert_ctx_access;
> >
> > -             if (insn->code == (BPF_LDX | BPF_MEM | BPF_B) ||
> > -                 insn->code == (BPF_LDX | BPF_MEM | BPF_H) ||
> > -                 insn->code == (BPF_LDX | BPF_MEM | BPF_W) ||
> > -                 insn->code == (BPF_LDX | BPF_MEM | BPF_DW))
> > +             /* opcode: BPF_MEM | <size> | BPF_LDX */
> > +             if ((insn->code & ~BPF_LD_ST_SIZE_MASK) == (BPF_LDX | BPF_MEM))
> >                       type = BPF_READ;
> > -             else if (insn->code == (BPF_STX | BPF_MEM | BPF_B) ||
> > -                      insn->code == (BPF_STX | BPF_MEM | BPF_H) ||
> > -                      insn->code == (BPF_STX | BPF_MEM | BPF_W) ||
> > -                      insn->code == (BPF_STX | BPF_MEM | BPF_DW))
> > +             /* opcode: BPF_MEM | <size> | BPF_STX */
> > +             else if ((insn->code & ~BPF_LD_ST_SIZE_MASK) == (BPF_STX | BPF_MEM))
> >                       type = BPF_WRITE;
> >               else
> >                       continue;
> >
>
> To me this cleanup makes the code harder to read, in particular on verfier side,
> I don't think it's worth it, especially given it's not in (highly) performance
> critical code.
>
> Thanks,
> Daniel

I have some different opinions. I think the addition of the mask just helps
developers understand that the currently processed instruction covers all
possible values of size;

In addition, from my experience in reading the verfier.c file,
to fully understand this part of the code, it needs to understand the
meaning of each instruction.
It is really hard to say that this is an easy task, at least for me.
Haha ^_^

Regards,
Jianlin
