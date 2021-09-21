Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33D4412AD2
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhIUB6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238530AbhIUB5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:57:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAF5C08EA79;
        Mon, 20 Sep 2021 17:57:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so1288465pjv.1;
        Mon, 20 Sep 2021 17:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9T7fESSoh8+qjTExbEsMsHHmHa36v14/SiTrX3dtRw=;
        b=mXASDEFNIGC0eSTUEscsDYNYA9zANDrE+S0bOJRaggwZ1NhfSQwmw9uPHLVAKJHv+J
         2I7arLLj4XOU0/EDQiLFIVJStjjnh8p/LcjdceKLqN6ciBi0pzZ7P9fJHySVpX0u20mh
         T3AUNjtHM3GoDk3/GUphVR3LgVTOd17rTKCXuCsPjwqfmoan5p/1r/KU4bj2lQb1oUFb
         z1r6iB5/+L9WlGhPKZd0qtzifEqVtyp3n/rfRpteJOOYBAP3b8EKe7eoT6lGA0v+X+h+
         I08wQTCXQHHbiK77DeXEXt2l7CKQ1F2ocgFLCz18jpOgRxLkGcIokoaF3t4vH6vwYyAE
         Xoog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9T7fESSoh8+qjTExbEsMsHHmHa36v14/SiTrX3dtRw=;
        b=FnR4hGVfKRUw25IWK1PZrPlMdUs+3onDvJUAMceOj9ah9iz57jMWW+tt6wKywtn/av
         AQSXFU9LATmNHcDx7VwI1OjiLiEa1ApYrmeJGW2TT3WC3zMzPhRDnvjrIBzMUU5UX6AS
         OgwYjGwOrjbXgpZzalt5mXLXlXKWwZlbQEwww2aDMWI/N1gr3g3pwwmSDg+vuT8eJS4O
         I7fZ17asxyGWMHIhavfHSaMwGdz2ID8iCOykcayTriatHpVJ+t3qZwwdO9aEVX6tSJgg
         wmuiqfKEmNfwINtV97Sr+wa/SOq6QOLH3iEjWjJo/L5iJiF27ZGVA+GYKj2ANT3Tvi2H
         vw0Q==
X-Gm-Message-State: AOAM5339LsT0OmWQniku8IaFTUay2IQrolM+6OrmggSSOFshRpulXegN
        kK6l9vjy+H4iOI7OskZiNsrWqyr2CQBeS4sl2sY=
X-Google-Smtp-Source: ABdhPJw4P8dRm8NXYPBPr2wdBJLrwhcA0M6gNgU5Ej1o01V80YKOSbEzSHpNcdKsGz4mZz4FrzsEVTX3IErnCjdR0Dw=
X-Received: by 2002:a17:902:7246:b0:138:a6ed:66cc with SMTP id
 c6-20020a170902724600b00138a6ed66ccmr25566330pll.22.1632185847754; Mon, 20
 Sep 2021 17:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-9-memxor@gmail.com>
In-Reply-To: <20210920141526.3940002-9-memxor@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 20 Sep 2021 17:57:16 -0700
Message-ID: <CAADnVQKjoCLNYBwDvLjgG9cYxrZyhw1Bgvm0yzH0gUWQLNtZnw@mail.gmail.com>
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

On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
> relocations, with support for weak kfunc relocations. The next commit
> adds bpftool supports to set up the fd_array_sz parameter for light
> skeleton.
>
> A second map for keeping fds is used instead of adding fds to existing
> loader.map because of following reasons:

but it complicates signing bpf progs a lot.

> If reserving an area for map and BTF fds, we would waste the remaining
> of (MAX_USED_MAPS + MAX_KFUNC_DESCS) * sizeof(int), which in most cases
> will be unused by the program. Also, we must place some limit on the
> amount of map and BTF fds a program can possibly open.

That is just (256 + 64)*4 bytes of data. Really not much.
I wouldn't worry about reserving this space.

> If setting gen->fd_array to first map_fd offset, and then just finding
> the offset relative to this (for later BTF fds), such that they can be
> packed without wasting space, we run the risk of unnecessarily running
> out of valid offset for emit_relo stage (for kfuncs), because gen map
> creation and relocation stages are separated by other steps that can add
> lots of data (including bpf_object__populate_internal_map). It is also
> prone to break silently if features are added between map and BTF fd
> emits that possibly add more data (just ~128KB to break BTF fd, since
> insn->off allows for INT16_MAX (32767) * 4 bytes).

I don't follow this logic.

> Both of these issues are compounded by the fact that data map is shared
> by all programs, so it is easy to end up with invalid offset for BTF fd.

I don't follow this either. There is only one map and one program.
What sharing are you talking about?
