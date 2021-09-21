Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C040413A7E
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 21:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhIUTGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 15:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbhIUTGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 15:06:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AA2C061574;
        Tue, 21 Sep 2021 12:04:53 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w19so393924pfn.12;
        Tue, 21 Sep 2021 12:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SNKCbu5nohcKOUFVbifwjUrtcDWnN9l/kTL1GaMnGSs=;
        b=paFMYfzawPJ0AhztgGBomodzUWidIFLkKKSthJhaQNPcwh7/tV6MA7HdSOJ7w5bMRz
         BKgWsMQs+1X6SRxRMRionmwp47vJ+nwcagF/5yFB4yOYqjGxSiRyvU9wNBD0ry1RVWll
         UhM/RNDR9UANxYS+U2JW7tn6e1Yp5js0l9dLibpSHb6wXTG/31FXtXxC4gTE7LMiSSPG
         DvBqXmgKwlWjyqwfFNngsycHW5OmsIGWtwomhJww4uu/GYR+kfk5bwCZ0rJjWcknveDR
         iaUw+4Z5NXFstqRKi/B3viee97fz2QkjmfB7O1cIjujhtiWPlMSGqdBDjRbDooRGMxkI
         HCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SNKCbu5nohcKOUFVbifwjUrtcDWnN9l/kTL1GaMnGSs=;
        b=HA4sPu2N/p667Kn+ZlEF/ffBc2ynT4ndQQjGiNDYRioQtjyvFGcXADCItvGcDNUKxQ
         UJcVShw6A7H+p3LYFlSJNRIQnyajPt/MI1YpuB+7WyYhG3WXDJzZLAiPx0WYUEr3uKLW
         Muo5hSjrPWT0VWhworUcbUOg5TvVqCsVZpdGprMcU3kS63KbH++vW7nw9F+6sV57pAL8
         goW0tmzmukMI2R6IvEwaBo/RDkzN3hfR3iiI3xq/2QX/HjTgDfMnUH8sE4RE9mek6TU3
         eVItRncxW6CkXgPz4f7F6R4wueXtutN0OZbBfCoIeJHRnxNhqxWvcNozxjw3CmjSuYAk
         6TsQ==
X-Gm-Message-State: AOAM5313f6VWW1sIHZguB53bzh733UzMIbzfNdThsf3Skf8TDbk+ClJz
        NTRDzzyxxTnrSClL5++EIs2ih7Ko8ejI0yIzCbQ=
X-Google-Smtp-Source: ABdhPJzP8GXcED7uWnz91KpAZ1nwyMbko6aPotNm7Iuj7TTd86Xz3xmJ7YjQkzwvNiS/OOnv/X/qzJpt47CFwNOnSbE=
X-Received: by 2002:a63:3483:: with SMTP id b125mr9531975pga.35.1632251092425;
 Tue, 21 Sep 2021 12:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-9-memxor@gmail.com>
 <CAADnVQKjoCLNYBwDvLjgG9cYxrZyhw1Bgvm0yzH0gUWQLNtZnw@mail.gmail.com> <20210921045022.s5mofmkgrkh6inva@apollo.localdomain>
In-Reply-To: <20210921045022.s5mofmkgrkh6inva@apollo.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Sep 2021 12:04:41 -0700
Message-ID: <CAADnVQKqk-HNSeSkHmqSL8LGuG9QgwK0qS5ef-6NTq2ihZ2y4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 08/11] libbpf: Update gen_loader to emit
 BTF_KIND_FUNC relocations
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 9:50 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, Sep 21, 2021 at 06:27:16AM IST, Alexei Starovoitov wrote:
> > On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
> > > relocations, with support for weak kfunc relocations. The next commit
> > > adds bpftool supports to set up the fd_array_sz parameter for light
> > > skeleton.
> > >
> > > A second map for keeping fds is used instead of adding fds to existing
> > > loader.map because of following reasons:
> >
> > but it complicates signing bpf progs a lot.
> >
>
> Can you explain this in short? (Just want to understand why it would be
> problem).

The signing idea (and light skeleton too) rely on two matching blocks:
signed map and signed prog that operates on this map.
They have to match and be technically part of single logical signature
that consists of two pieces.
The second map doesn't quite fit this model. Especially since it's an empty
map and it is there for temporary use during execution of the loader prog.
That fd_array_sz value would somehow need to be part of the signature.
Adding a 3rd non-generic component to a signature has consequences
to the whole signing process.
The loader prog could have created this temp map on its own
without asking bpf_load_and_run() to do it and without exposing it
into a signature.
Anyway the signed bpf progs may get solved differently with the latest John
proposal, but that's a different discussion.
The light skeleton minimalizm is its main advantage. Keeping it two
pieces: one map and one prog is its main selling point.

> > > If reserving an area for map and BTF fds, we would waste the remaining
> > > of (MAX_USED_MAPS + MAX_KFUNC_DESCS) * sizeof(int), which in most cases
> > > will be unused by the program. Also, we must place some limit on the
> > > amount of map and BTF fds a program can possibly open.
> >
> > That is just (256 + 64)*4 bytes of data. Really not much.
> > I wouldn't worry about reserving this space.
> >
>
> Ok, I'll probably go with this now, I didn't realise a separate fd would be
> prohibitive for the signing case, so I thought it would nice to lift the
> limiation on number of map_fds by packing fd_array fds in another map.
>
> > > If setting gen->fd_array to first map_fd offset, and then just finding
> > > the offset relative to this (for later BTF fds), such that they can be
> > > packed without wasting space, we run the risk of unnecessarily running
> > > out of valid offset for emit_relo stage (for kfuncs), because gen map
> > > creation and relocation stages are separated by other steps that can add
> > > lots of data (including bpf_object__populate_internal_map). It is also
> > > prone to break silently if features are added between map and BTF fd
> > > emits that possibly add more data (just ~128KB to break BTF fd, since
> > > insn->off allows for INT16_MAX (32767) * 4 bytes).
> >
> > I don't follow this logic.
> >
> > > Both of these issues are compounded by the fact that data map is shared
> > > by all programs, so it is easy to end up with invalid offset for BTF fd.
> >
> > I don't follow this either. There is only one map and one program.
> > What sharing are you talking about?
>
> What I saw was that the sequence of calls is like this:
> bpf_gen__map_create
> add_data - from first emit we add map_fd, we also store gen->fd_array
> then libbpf would call bpf_object__populate_internal_map
> which calls bpf_gen__map_update_elem, which also does add_data (can be of
> arbitrary sizes).
>
> emit_relos happens relatively at the end.
> For each program in the object, this sequence can be repeated, such that the
> add_data that we do in emit_relos, relative offset from gen->fd_array offset
> can end up becoming big enough (as all programs in object add data to same map),
> while gen->fd_array comes from first map creation.

You've meant to use fd_array as a very very sparse array
with giant gaps between valid map_fds and btf_fds. Now I see it :)
Indeed in such a case there is a risk of running out of 16-bit in bpf_insn->off.
Reserving (256 + 64)*4 in the beginning of the data map should solve it, right?
The loader prog can create a 2nd auxiliary map on the fly,
but it seems easier and simpler to just reserve this space in one and only map.
