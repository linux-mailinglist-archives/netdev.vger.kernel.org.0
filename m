Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E170C51029A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346132AbiDZQNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244812AbiDZQNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:13:07 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1505581;
        Tue, 26 Apr 2022 09:09:59 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r12so20609043iod.6;
        Tue, 26 Apr 2022 09:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=erYFw2u97tYKdbMKzqyt7/Xqd3qvZzbPh4jS2jb8UDE=;
        b=PhZvqktTmQr6aQbxoGlQo0TVdZt4+o6F+UzjuT8taO9vHUS7j6qotGpRt8qvxDTSrp
         q/hJndWVpA4mtlu7mnkXF8FpFO2ACQYQM21VOyvFyqqxaVssOw1ni+3nmzypL08ALJed
         FI3y2NkVx6le6puYitoPqdTW01TIVcJyEIOHa2F8sRqOsNzlkBKG3B5tt2Z+9tsHhqAr
         AuF458ZztRNqyJEZXYto8cW4ZVtC9RpDyrWQ0JlgCOwd7WT9KkWNK5TXyIto/iCHao1o
         IUpPunUfw/Lzzmk5DExoeuc/gE8zpRlrt1vMRzelwto9HzfNFIHrQ5ThZn81WXnXp1K0
         3pbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=erYFw2u97tYKdbMKzqyt7/Xqd3qvZzbPh4jS2jb8UDE=;
        b=QOUyxPMVTClV334yAFN85592Vz2/TqAf9b1wduwE+WELihPdaRuK9sAQy1HtbAQltd
         adnZCs8wou6gTJursiqYw0jLcl6ldqSPihyI9d04ImCNdDeFimHyDsB6Tv7F9ezpOQNU
         XXCFOe5IK3VcQJfC55cnovGKmAow14PGh1ft+Hs1kGk37mpOHrIL7eNZtnppfUv4xd9S
         Wlk5nkrzpMWZ22XXSaF8KsSiNEBB/y5dtGZfEq/mlka9CGRpshLdtpz8qUbJJ52TnsiY
         vIBypBK5ZU+J+NitBjoL3hCB+jZDfzggmCqDOjFeRntF8NrlTaHCZfQ/uKwrle1IM1y5
         OEpA==
X-Gm-Message-State: AOAM530zbAZGBzXotwAYV7RWGs/UwJni5GvycxrCjsdNt1q13N/0TopD
        sOgdM2g8mJpxaKa0AbNMXFkJKXRWGipOiJGpUwg=
X-Google-Smtp-Source: ABdhPJxN1vH3Y34DEJRqM9xhBuY+Iqd27t4QJbnKrirvnQg2TQ+uIrT6YQTsG+0s+UaB1jjQkzRMZqa9NCtLrZXM1y8=
X-Received: by 2002:a05:6602:1592:b0:654:b130:2fa5 with SMTP id
 e18-20020a056602159200b00654b1302fa5mr9978759iow.33.1650989398540; Tue, 26
 Apr 2022 09:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <CAEf4BzbhODOBrE=unLOUpo40uUYz72BJX-+uJobiwhF9VFSizQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbhODOBrE=unLOUpo40uUYz72BJX-+uJobiwhF9VFSizQ@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 27 Apr 2022 00:09:22 +0800
Message-ID: <CALOAHbAdQLpO2we5xS9ADFOQBt1SFo1mHBrp=nmVjrVVZ=2owQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] bpf: Generate helpers for pinning through
 bpf object skeleton
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Tue, Apr 26, 2022 at 2:45 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Apr 23, 2022 at 7:01 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > Currently there're helpers for allowing to open/load/attach BPF object
> > through BPF object skeleton. Let's also add helpers for pinning through
> > BPF object skeleton. It could simplify BPF userspace code which wants to
> > pin the progs into bpffs.
> >
> > After this change, with command 'bpftool gen skeleton XXX.bpf.o', the
> > helpers for pinning BPF prog will be generated in BPF object skeleton.
> >
> > The new helpers are named with __{pin, unpin}_prog, because it only pins
> > bpf progs. If the user also wants to pin bpf maps, he can use
> > LIBBPF_PIN_BY_NAME.
>
> API says it's pinning programs, but really it's trying to pin links.

Actually it should be bpf_object__pin_skeleton_link().

> But those links might not even be created for non-auto-attachable
> programs, and for others users might or might not set
> <skel>.links.<prog_name> links.
>
> There are lots of questions about this new functionality... But the
> main one is why do we need it? What does it bring that's hard to do
> otherwise?
>

See also my replyment to Daniel[1].
For the FD-based bpf objects, the userspace code is similar, so we can
abstract the userspace code into a common code, and then the developer
doesn't need to write the userspace code any more (if he doesn't have
some special userspace logical.).


[1]. https://lore.kernel.org/bpf/CAEf4BzbhODOBrE=unLOUpo40uUYz72BJX-+uJobiwhF9VFSizQ@mail.gmail.com/T/#m32dfc6343f2b4fba980c62686b245cb6e0133c2f


> >
> > Yafang Shao (4):
> >   libbpf: Define DEFAULT_BPFFS
> >   libbpf: Add helpers for pinning bpf prog through bpf object skeleton
> >   bpftool: Fix incorrect return in generated detach helper
> >   bpftool: Generate helpers for pinning prog through bpf object skeleton
> >
> >  tools/bpf/bpftool/gen.c     | 18 ++++++++++-
> >  tools/lib/bpf/bpf_helpers.h |  2 +-
> >  tools/lib/bpf/libbpf.c      | 61 ++++++++++++++++++++++++++++++++++++-
> >  tools/lib/bpf/libbpf.h      | 10 ++++--
> >  tools/lib/bpf/libbpf.map    |  2 ++
> >  5 files changed, 88 insertions(+), 5 deletions(-)
> >
> > --
> > 2.17.1
> >



-- 
Regards
Yafang
