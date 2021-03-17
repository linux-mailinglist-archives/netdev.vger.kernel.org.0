Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DD33FAE2
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCQWSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhCQWSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:18:37 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3909C06174A;
        Wed, 17 Mar 2021 15:18:36 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id h82so477186ybc.13;
        Wed, 17 Mar 2021 15:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VGJUHdigdozISfP0Ka6FvwuOT2FQe2qS4H2lJU3h+oo=;
        b=rynR7XRyiiCi3rCx3tMvVZJpcdVNPXUWn/++pAm4zdmLD0B4CLm7weL081DFRUxQpT
         ocFiV97ZCcX2Tmr2NDKrMGTOosJWdYzl9ipztw8KcFTSOu8FO4Hlye6SQlsi5sxqNHgk
         9svR8jnAzXlW1tzUTiBCXwnZB747e1w2WonNpYiS4X5miQw7tyUh0kI0ZacBlYKBshDS
         Sz/jDbjh2wNXv1XZv9tvVZGIs8WYXcDqzbqmfl6TbeaDiLWYXDFePO6YaDkCjoNvuyxA
         dens0Y/dxFmi+mTNDVn8k5NvZFvoGcwiWmBPitIQFGIGH6vOS9ye07BM9ZpkXzVTDNxQ
         UY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VGJUHdigdozISfP0Ka6FvwuOT2FQe2qS4H2lJU3h+oo=;
        b=UPoCgpGMCpMIgKdR+GXorlz6PzmYobHptyKdSJKkZvhC0VptkTNngJY/QKLzkzhAGI
         FU2imDvnrlQ8b9F2WPltDoFIAWaBI6NrjRelhc/6ANEY8+JiBIfL66grZ4KRx2ZiPz8i
         OFiYGHyzZXwmZ85QMrNlCnMdOQdQDEw2kqZxcLdS7ADPX2mCqEJz6DPdU4tr7hMt0SkC
         fK2deLLmbhAdid0n7VbIctUMUiwVrN6+U389U+cJdbEDgnGEtqlZuz4QUKKMqxzaZ7IY
         0XXb45SitcYy5bGQlHGmHE8JzSCPotILS3Da2efGXqHFWFuTE5/Kd+Rz/AeZEXzS+bBl
         k9+w==
X-Gm-Message-State: AOAM5301acG75yVTkQ1jWVKJacUwLPhg0EYmsFjUgmOvTkboSwZPxg47
        Ev0iBi0ncmdeUkLv6m4Yz+RVzuR/XBT7W7MEL9N5rCpwLPc=
X-Google-Smtp-Source: ABdhPJy7hDq/YkItLIucVVEi96SezMQp1d7RicHqagh1aw/DUuNkytuazB/Al32B9Ag60tP8IwruWUMQZrQbTUMhcAE=
X-Received: by 2002:a25:cc13:: with SMTP id l19mr7635863ybf.260.1616019018047;
 Wed, 17 Mar 2021 15:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-1-andrii@kernel.org> <20210313193537.1548766-8-andrii@kernel.org>
 <20210317052540.3f6epwcm6o5zwsdi@ast-mbp>
In-Reply-To: <20210317052540.3f6epwcm6o5zwsdi@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Mar 2021 15:10:06 -0700
Message-ID: <CAEf4BzbLtWcgex0+zEfy=6n2783N3nWCX2RkE3Nh1peUHaFXkw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 07/11] libbpf: add BPF static linker BTF and
 BTF.ext support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 10:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Mar 13, 2021 at 11:35:33AM -0800, Andrii Nakryiko wrote:
> > +             for (j = 0; j < n; j++, src_var++) {
> > +                     void *sec_vars = dst_sec->sec_vars;
> > +
> > +                     sec_vars = libbpf_reallocarray(sec_vars,
> > +                                                    dst_sec->sec_var_cnt + 1,
> > +                                                    sizeof(*dst_sec->sec_vars));
> > +                     if (!sec_vars)
> > +                             return -ENOMEM;
> > +
> > +                     dst_sec->sec_vars = sec_vars;
> > +                     dst_sec->sec_var_cnt++;
> > +
> > +                     dst_var = &dst_sec->sec_vars[dst_sec->sec_var_cnt - 1];
> > +                     dst_var->type = obj->btf_type_map[src_var->type];
> > +                     dst_var->size = src_var->size;
> > +                     dst_var->offset = src_sec->dst_off + src_var->offset;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void *add_btf_ext_rec(struct btf_ext_sec_data *ext_data, const void *src_rec)
> > +{
> > +     size_t new_sz = (ext_data->rec_cnt + 1) * ext_data->rec_sz;
> > +     void *tmp;
> > +
> > +     tmp = realloc(ext_data->recs, new_sz);
> > +     if (!tmp)
> > +             return NULL;
> > +
> > +     ext_data->recs = tmp;
> > +     ext_data->rec_cnt++;
> > +
> > +     tmp += new_sz - ext_data->rec_sz;
> > +     memcpy(tmp, src_rec, ext_data->rec_sz);
>
> while reading this and previous patch the cnt vs sz difference was
> constantly throwing me off. Not a big deal, of course.
> Did you consider using _cnt everywhere and use finalize method
> to convert everything to size?
> Like in this function libbpf_reallocarray() instead of realloc() would
> probably be easier to read and more consistent, since btf_ext_sec_data
> is measuring things in _cnt.

will switch this and add_sym() to reallocarray, given both are dealing
with real fixed-size records (not just bytes)

> In the previous patch the section is in _sz which I guess is necessary
> because sections can contain differently sized objects?

yes, it could be records of different sizes (e.g., relocations,
symbols), or just unstructured data (e.g., .data, string table, etc).

>
> btw, strset abstraction is really nice. It made the patches much easier
> to read.

Thanks. Yeah, it simplified existing BTF/btf_dedup logic quite a bit
as well, it was a good suggestion!
