Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A0E412E0F
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 06:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhIUEvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 00:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhIUEvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 00:51:53 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D47C061574;
        Mon, 20 Sep 2021 21:50:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n2so9939455plk.12;
        Mon, 20 Sep 2021 21:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=etxA1hoL5DTr6HAw4eT7rfvsl2MGgbF0cSTJHhjIVMA=;
        b=LJ7mSdt97nvDt1qcCrP5rxkoacMWysWHT2ppN3Yy1TdkGf4lrTzpwVOPJhMoSsMgUy
         +Kal0h4MSIhQ56/Bmw0f5nKmVL7tLS8wNWF8/8ICJAvLrep1twaWuVaCvS6Xw2vblSQx
         qva/ji7X8w0iqYKiH0Qh2iydsdMh2cnMAj796AScDRSc7IWhW3Rl/I1AmapRhDJUwjv2
         LgoI52F7EkZk4cZDWNhRv7X6BOenQVklBS4UL+RKx2Fj96ls629ABKFHGq0j9OGb860x
         SHUvDDmPYKhwNWeLLI9Lg1Woke+z40om9ZrCBQ5+FVM9dJkuw6BWxoq1sthDUPMLahL8
         7IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=etxA1hoL5DTr6HAw4eT7rfvsl2MGgbF0cSTJHhjIVMA=;
        b=4hkRrbhkV4ArvhFCrcJHZm5wyOY0gXsQVeLHrIn0LV/+M5VTAKs2nVaevVr61LO+qY
         UltnrBG5PQI+UBTZF8lEZxN6UAEWVM+XWRKGZcu9ObRHZM3VK9D8X4FTDnylwOgiRakU
         QI1xvuWGT61Qq6YxqMaJRFAdQujeBUZ1TVW+yakPokP25caNKvq7c5vezkjRl4C91Mv1
         QC/26rTeuk5bTZpinFdw0CosXXxov5zXc7hiN/HmsLIQzXyVHuwFE9xB/b2LmYYA8FBs
         MRsz97KJZvPkMxc0pmC/q55QlX1rWT1+oETL45A2eIAqSWfpYK782D6XP9Tw1VeuogLF
         cTqA==
X-Gm-Message-State: AOAM5332xrUmw7DCgAPZYppN6e4RfMQxiOi+1jkFQjAwyicapFuCYbcV
        ZaNQKV2tQLiK11Wm6Qxx984=
X-Google-Smtp-Source: ABdhPJx+QMENOr8z/X9OBRj8C79SVC7ESs/dQHQ/eHspEm8SE0ul9Lo0a6Cvb1qAyUBmGYw6oYqhbA==
X-Received: by 2002:a17:90b:1987:: with SMTP id mv7mr3020557pjb.91.1632199825287;
        Mon, 20 Sep 2021 21:50:25 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id u4sm4482086pfn.190.2021.09.20.21.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 21:50:25 -0700 (PDT)
Date:   Tue, 21 Sep 2021 10:20:22 +0530
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
Message-ID: <20210921045022.s5mofmkgrkh6inva@apollo.localdomain>
References: <20210920141526.3940002-1-memxor@gmail.com>
 <20210920141526.3940002-9-memxor@gmail.com>
 <CAADnVQKjoCLNYBwDvLjgG9cYxrZyhw1Bgvm0yzH0gUWQLNtZnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKjoCLNYBwDvLjgG9cYxrZyhw1Bgvm0yzH0gUWQLNtZnw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 06:27:16AM IST, Alexei Starovoitov wrote:
> On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
> > relocations, with support for weak kfunc relocations. The next commit
> > adds bpftool supports to set up the fd_array_sz parameter for light
> > skeleton.
> >
> > A second map for keeping fds is used instead of adding fds to existing
> > loader.map because of following reasons:
>
> but it complicates signing bpf progs a lot.
>

Can you explain this in short? (Just want to understand why it would be
problem).

> > If reserving an area for map and BTF fds, we would waste the remaining
> > of (MAX_USED_MAPS + MAX_KFUNC_DESCS) * sizeof(int), which in most cases
> > will be unused by the program. Also, we must place some limit on the
> > amount of map and BTF fds a program can possibly open.
>
> That is just (256 + 64)*4 bytes of data. Really not much.
> I wouldn't worry about reserving this space.
>

Ok, I'll probably go with this now, I didn't realise a separate fd would be
prohibitive for the signing case, so I thought it would nice to lift the
limiation on number of map_fds by packing fd_array fds in another map.

> > If setting gen->fd_array to first map_fd offset, and then just finding
> > the offset relative to this (for later BTF fds), such that they can be
> > packed without wasting space, we run the risk of unnecessarily running
> > out of valid offset for emit_relo stage (for kfuncs), because gen map
> > creation and relocation stages are separated by other steps that can add
> > lots of data (including bpf_object__populate_internal_map). It is also
> > prone to break silently if features are added between map and BTF fd
> > emits that possibly add more data (just ~128KB to break BTF fd, since
> > insn->off allows for INT16_MAX (32767) * 4 bytes).
>
> I don't follow this logic.
>
> > Both of these issues are compounded by the fact that data map is shared
> > by all programs, so it is easy to end up with invalid offset for BTF fd.
>
> I don't follow this either. There is only one map and one program.
> What sharing are you talking about?

What I saw was that the sequence of calls is like this:
bpf_gen__map_create
add_data - from first emit we add map_fd, we also store gen->fd_array
then libbpf would call bpf_object__populate_internal_map
which calls bpf_gen__map_update_elem, which also does add_data (can be of
arbitrary sizes).

emit_relos happens relatively at the end.
For each program in the object, this sequence can be repeated, such that the
add_data that we do in emit_relos, relative offset from gen->fd_array offset
can end up becoming big enough (as all programs in object add data to same map),
while gen->fd_array comes from first map creation.

However reserving an area works ok (like with the stack).
Thanks.

--
Kartikeya
