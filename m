Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAED05B2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 04:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfJICsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 22:48:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44915 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfJICsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 22:48:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id u22so832469qkk.11;
        Tue, 08 Oct 2019 19:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cah882sh/HIPji0YKIUpKlOhv/RQZ3ZJTipgV/0IDLk=;
        b=B4bASwxD1cNyCRwjFcdZu9Uxnojjv63ULk0mcPJ7Iq11hlWaggQJmQQe7zft5+IfS6
         wzNr9zt2TJTf9KPFuAXgIRNhj+fcGO/Mv82c/3icK+GObKlC8eJec9QsrHCQddiA3jq2
         K3hLIppttMOoQ2WuuBrt0YdHeYEZD4ocGTFX8v7w4jkBAZ7H6FYgp1xCn4O3+U91rKpi
         DLFRQXwOzbisLXUg0Cil7ZgOdnnyPWuk3e4vtR5kJajTxudLlvYX+lucp7xSFnVeUls/
         5usBZWUZ10CXNU4umFxV1/jDp27HDQABgKzkoeDx7dhpLWPd9gOy4cI1QUWgJmaPByuU
         /jjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cah882sh/HIPji0YKIUpKlOhv/RQZ3ZJTipgV/0IDLk=;
        b=iVGaxSmJpy/4n8zD3W6MZ7U6SfhyxXmEyNihGq3e7wmSnmGb1T/DJx0M4EmP3wlmEB
         Ap9gRyB/9S33qiNKUe0XddLPbdHZ4cXZAYJA9NDIC1dQhdczwYylXSxiyfgqG0rbdmgm
         X4sMfI7m2q1lhXZf9GgEuwDP685fUl/+DKXbp3BktZWRd8sishKLfnRhSDZrseJY2ZEL
         0COwzPOfj1fRJ1Uvt6x3Fa2x3brBkmP3ieBOWbR7JkPrWIlI9OUTLesE+y4kZEGEgL+h
         8VZ8xC6Mqtf15iikmBQiKEa7WctEjBQsLp8gVfG0j66+CyTiTlEDBwbH4gaYrZXwZbj/
         WCWg==
X-Gm-Message-State: APjAAAV+WcR111ZGk3C6Gmqs68+Kh7oDqYmr+HLDte3ZXP95dndTv4W8
        UEluHICW6HTMDueY6ghI+J45i4tUIaGI3W9tkpZtIAOwt1Q=
X-Google-Smtp-Source: APXvYqw6GOLEr9IBbfXInZ2Jpz1k0RSsyOyl1YUyxM067CJBiJBrUrEcsw4nndiAZRvfcKxuy1uCl/0VpSYz4j3CsU4=
X-Received: by 2002:a37:b447:: with SMTP id d68mr1477741qkf.437.1570589329379;
 Tue, 08 Oct 2019 19:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191008194548.2344473-1-andriin@fb.com> <20191008194548.2344473-2-andriin@fb.com>
 <20191008215321.hrlrbgsdifnziji6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzaLHY9MHbp27VxvVZcKWvbO43F2n6frKi_8kgqCXMDKMg@mail.gmail.com> <20191009003424.ewbra36vpgla2rlj@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191009003424.ewbra36vpgla2rlj@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 19:48:38 -0700
Message-ID: <CAEf4BzYyUpJaCPiYizZQ6CKhaBY-jiM9YZ6xYVRHHTHuFcg5Cw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as scalars
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 5:34 PM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Oct 08, 2019 at 04:49:30PM -0700, Andrii Nakryiko wrote:
> > On Tue, Oct 8, 2019 at 2:53 PM Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Tue, Oct 08, 2019 at 12:45:47PM -0700, Andrii Nakryiko wrote:
> > > > Maps that are read-only both from BPF program side and user space side
> > > > have their contents constant, so verifier can track referenced values
> > > > precisely and use that knowledge for dead code elimination, branch
> > > > pruning, etc. This patch teaches BPF verifier how to do this.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  kernel/bpf/verifier.c | 58 +++++++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 56 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index ffc3e53f5300..1e4e4bd64ca5 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > > @@ -2739,6 +2739,42 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
> > > >       reg->smax_value = reg->umax_value;
> > > >  }
> > > >
> > > > +static bool bpf_map_is_rdonly(const struct bpf_map *map)
> > > > +{
> > > > +     return (map->map_flags & BPF_F_RDONLY_PROG) &&
> > > > +            ((map->map_flags & BPF_F_RDONLY) || map->frozen);
> > > > +}
> > > > +
> > > > +static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
> > > > +{
> > > > +     void *ptr;
> > > > +     u64 addr;
> > > > +     int err;
> > > > +
> > > > +     err = map->ops->map_direct_value_addr(map, &addr, off + size);
> > > Should it be "off" instead of "off + size"?
> >
> > From array_map_direct_value_addr() code, offset is used only to check
> > that access is happening within array value bounds.
> The "size" check is done separately in the check_map_access(),
> so "off" is offset alone, I think.

Yeah, makes sense. I guess the check was originally done for loading
direct address into array, with actual access (byte, word, etc) done
separately in subsequent instructions. I'll change it back to off,
though it doesn't matter in this case, because we already checked it
above (both offset and size).

>
> > It's not used to
> > calculate returned pointer.
> > But now re-reading its code again, I think this check is wrong:
> >
> > if (off >= map->value_size)
> >         break;
> >
> > It has to be (off > map->value_size). But it seems like this whole
> > interface is counter-intuitive.
> >
> > I'm wondering if Daniel can clarify the intent behind this particular behavior.
> >
> > For now the easiest fix is to pass (off + size - 1). But maybe we
> > should change the contract to be something like
> >
> > int map_direct_value_addr(const struct bpf_map *map, u64 off, int
> > size, void *ptr)
> >
> > This then can validate that entire access in the range of [off, off +
> > size) is acceptable to a map, and then return void * pointer according
> > to given off. Thoughts?
> >
> > >
> > > > +     if (err)
> > > > +             return err;
> > > > +     ptr = (void *)addr + off;
> > > > +
> > > > +     switch (size) {
> > > > +     case sizeof(u8):
> > > > +             *val = (u64)*(u8 *)ptr;
> > > > +             break;
> > > > +     case sizeof(u16):
> > > > +             *val = (u64)*(u16 *)ptr;
> > > > +             break;
> > > > +     case sizeof(u32):
> > > > +             *val = (u64)*(u32 *)ptr;
> > > > +             break;
> > > > +     case sizeof(u64):
> > > > +             *val = *(u64 *)ptr;
> > > > +             break;
> > > > +     default:
> > > > +             return -EINVAL;
> > > > +     }
> > > > +     return 0;
> > > > +}
> > > > +
> > > >  /* check whether memory at (regno + off) is accessible for t = (read | write)
> > > >   * if t==write, value_regno is a register which value is stored into memory
> > > >   * if t==read, value_regno is a register which will receive the value from memory
> > > > @@ -2776,9 +2812,27 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
> > > >               if (err)
> > > >                       return err;
> > > >               err = check_map_access(env, regno, off, size, false);
> > > > -             if (!err && t == BPF_READ && value_regno >= 0)
> > > > -                     mark_reg_unknown(env, regs, value_regno);
> > > > +             if (!err && t == BPF_READ && value_regno >= 0) {
> > > > +                     struct bpf_map *map = reg->map_ptr;
> > > > +
> > > > +                     /* if map is read-only, track its contents as scalars */
> > > > +                     if (tnum_is_const(reg->var_off) &&
> > > > +                         bpf_map_is_rdonly(map) &&
> > > > +                         map->ops->map_direct_value_addr) {
> > > > +                             int map_off = off + reg->var_off.value;
> > > > +                             u64 val = 0;
> > > >
> > > > +                             err = bpf_map_direct_read(map, map_off, size,
> > > > +                                                       &val);
> > > > +                             if (err)
> > > > +                                     return err;
> > > > +
> > > > +                             regs[value_regno].type = SCALAR_VALUE;
> > > > +                             __mark_reg_known(&regs[value_regno], val);
> > > > +                     } else {
> > > > +                             mark_reg_unknown(env, regs, value_regno);
> > > > +                     }
> > > > +             }
> > > >       } else if (reg->type == PTR_TO_CTX) {
> > > >               enum bpf_reg_type reg_type = SCALAR_VALUE;
> > > >
> > > > --
> > > > 2.17.1
> > > >
