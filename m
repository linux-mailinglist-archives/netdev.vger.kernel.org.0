Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F63413D84
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbhIUW0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhIUW0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:26:53 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B05C061574;
        Tue, 21 Sep 2021 15:25:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so716631pjb.5;
        Tue, 21 Sep 2021 15:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R2pBYLVZdaDfJdvQiMPLehKNZJs56Qr+SFqFCgP7PAQ=;
        b=bQckWLN0paN57+zXaH0F4OaKL+tGlyJahPV6TJyK6nM7ojwLsNKukDOgr6/rPMaxU/
         nSdmkk9+R0Mgy4E8EjdfYnDkFmQCOUU+513V0tmRQQpumCaJXk8xC+fkoAcKQt+kIYfI
         l2FW1t+x/Yt3zieZV5xT8qYkqY1FIKu2s9u+629BSFF+cJOytEpmgckkDbwzMxeEnDSl
         yE2LYdbECudN1vGU3Lnobf3q9/bNdYofCkrkMhR3DPTomJhnnLjMPS85JArRd/UzbT8W
         wHu362KdG/ynQcdX6YCIKLapMsI6F7Iqfof0rkyZ23TcgfUk9jSaRZUmEMZm9pi9CJLt
         k/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R2pBYLVZdaDfJdvQiMPLehKNZJs56Qr+SFqFCgP7PAQ=;
        b=F8xo2zNkKFurtoEp4mTDWThS12Kf0gnyBVUleUDBoeK0Dz8fLKmP+KEhWR8gKz9BkK
         NdxIobNlrSrHs5t34TqVTx7fB3MA+j3QSWOUIIsc8xOKjg9BZ9KBkC2ey58op/BMlYU2
         ZDFbxYosLfN8hyvLE2hwxacJv4FeZtPZL25xGVvvES7id2z7xvIzjoYThYkl8w+FUjcp
         cFGcdgdD/bu22y0LBd8u2PJ5/vCFKKkdmh8hNP12pxMZILevTbcNhy8gCHfinUfidYmt
         uVsscK/XCKjxBL2yM3b7Gf4dOw/IhChKR/xlEYBTUSmE/GVp3Dk/n2cfF1sDPEXpIZ7m
         blZw==
X-Gm-Message-State: AOAM532SMRtY3BE2BkB7q/PmTZji7KGTi02TV+UOg6Et07+lUTX/5ik7
        inYGDmrUT4Yf0ThayLugVnEKg46vo7VfIQ==
X-Google-Smtp-Source: ABdhPJxcOigJ7CLbIxqsBtG31lmNUDRM3c9duEYDRkdICbVkEY5baXyvo4MKaYWe+oSNGqhsCeym/w==
X-Received: by 2002:a17:90a:16:: with SMTP id 22mr7846927pja.25.1632263124102;
        Tue, 21 Sep 2021 15:25:24 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id k15sm138154pfh.213.2021.09.21.15.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 15:25:23 -0700 (PDT)
Date:   Wed, 22 Sep 2021 03:55:21 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 08/11] libbpf: Update gen_loader to emit
 BTF_KIND_FUNC relocations
Message-ID: <20210921222521.2jnc5jkehthgjv4e@apollo.localdomain>
References: <20210920141526.3940002-1-memxor@gmail.com>
 <20210920141526.3940002-9-memxor@gmail.com>
 <CAADnVQKjoCLNYBwDvLjgG9cYxrZyhw1Bgvm0yzH0gUWQLNtZnw@mail.gmail.com>
 <20210921045022.s5mofmkgrkh6inva@apollo.localdomain>
 <CAADnVQKqk-HNSeSkHmqSL8LGuG9QgwK0qS5ef-6NTq2ihZ2y4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKqk-HNSeSkHmqSL8LGuG9QgwK0qS5ef-6NTq2ihZ2y4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 12:34:41AM IST, Alexei Starovoitov wrote:
> On Mon, Sep 20, 2021 at 9:50 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Tue, Sep 21, 2021 at 06:27:16AM IST, Alexei Starovoitov wrote:
> > > On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
> > > > relocations, with support for weak kfunc relocations. The next commit
> > > > adds bpftool supports to set up the fd_array_sz parameter for light
> > > > skeleton.
> > > >
> > > > A second map for keeping fds is used instead of adding fds to existing
> > > > loader.map because of following reasons:
> > >
> > > but it complicates signing bpf progs a lot.
> > >
> >
> > Can you explain this in short? (Just want to understand why it would be
> > problem).
>
> The signing idea (and light skeleton too) rely on two matching blocks:
> signed map and signed prog that operates on this map.
> They have to match and be technically part of single logical signature
> that consists of two pieces.
> The second map doesn't quite fit this model. Especially since it's an empty
> map and it is there for temporary use during execution of the loader prog.
> That fd_array_sz value would somehow need to be part of the signature.
> Adding a 3rd non-generic component to a signature has consequences
> to the whole signing process.
> The loader prog could have created this temp map on its own
> without asking bpf_load_and_run() to do it and without exposing it
> into a signature.
> Anyway the signed bpf progs may get solved differently with the latest John
> proposal, but that's a different discussion.
> The light skeleton minimalizm is its main advantage. Keeping it two
> pieces: one map and one prog is its main selling point.
>
> > > > If reserving an area for map and BTF fds, we would waste the remaining
> > > > of (MAX_USED_MAPS + MAX_KFUNC_DESCS) * sizeof(int), which in most cases
> > > > will be unused by the program. Also, we must place some limit on the
> > > > amount of map and BTF fds a program can possibly open.
> > >
> > > That is just (256 + 64)*4 bytes of data. Really not much.
> > > I wouldn't worry about reserving this space.
> > >
> >
> > Ok, I'll probably go with this now, I didn't realise a separate fd would be
> > prohibitive for the signing case, so I thought it would nice to lift the
> > limiation on number of map_fds by packing fd_array fds in another map.
> >
> > > > If setting gen->fd_array to first map_fd offset, and then just finding
> > > > the offset relative to this (for later BTF fds), such that they can be
> > > > packed without wasting space, we run the risk of unnecessarily running
> > > > out of valid offset for emit_relo stage (for kfuncs), because gen map
> > > > creation and relocation stages are separated by other steps that can add
> > > > lots of data (including bpf_object__populate_internal_map). It is also
> > > > prone to break silently if features are added between map and BTF fd
> > > > emits that possibly add more data (just ~128KB to break BTF fd, since
> > > > insn->off allows for INT16_MAX (32767) * 4 bytes).
> > >
> > > I don't follow this logic.
> > >
> > > > Both of these issues are compounded by the fact that data map is shared
> > > > by all programs, so it is easy to end up with invalid offset for BTF fd.
> > >
> > > I don't follow this either. There is only one map and one program.
> > > What sharing are you talking about?
> >
> > What I saw was that the sequence of calls is like this:
> > bpf_gen__map_create
> > add_data - from first emit we add map_fd, we also store gen->fd_array
> > then libbpf would call bpf_object__populate_internal_map
> > which calls bpf_gen__map_update_elem, which also does add_data (can be of
> > arbitrary sizes).
> >
> > emit_relos happens relatively at the end.
> > For each program in the object, this sequence can be repeated, such that the
> > add_data that we do in emit_relos, relative offset from gen->fd_array offset
> > can end up becoming big enough (as all programs in object add data to same map),
> > while gen->fd_array comes from first map creation.
>
> You've meant to use fd_array as a very very sparse array
> with giant gaps between valid map_fds and btf_fds. Now I see it :)
> Indeed in such a case there is a risk of running out of 16-bit in bpf_insn->off.
> Reserving (256 + 64)*4 in the beginning of the data map should solve it, right?
> The loader prog can create a 2nd auxiliary map on the fly,
> but it seems easier and simpler to just reserve this space in one and only map.

Thanks for the explanation! It makes sense. I will fix this in the next spin.

--
Kartikeya
