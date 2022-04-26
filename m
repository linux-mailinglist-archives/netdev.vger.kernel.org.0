Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851E2510273
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352747AbiDZQEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352787AbiDZQEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:04:06 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AB9B852;
        Tue, 26 Apr 2022 09:00:58 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z26so2295936iot.8;
        Tue, 26 Apr 2022 09:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rSkUkaURL4HEXp6eDUwobhgJ9shXFSHoWRujy366OcY=;
        b=JVbCO8w9HFioTVzLCPlSZy/gqbi9L3wP3tTDXOrg7838Zdep5mtX0C/jgK1hqHZmFo
         A0STunzyXvB3TrHSSdlntTc/J22RyC3/724LE9+PD8F/aUG2IR32rrzLr9N6MXwaLTyc
         v8XUuss7zqypyM5gTYy4zNpKva27TLyIfgL/16EJMWkG52zU4QN6oM3fj1J0UcmoddDo
         kdCBtWF2uTzWZNfsimNlZcsAQ5BLWEdU8Gtl2/NcWRT/M3FmRP6rQQeacOR2wIXhufG9
         D4trmMdV5Ehq+yyPn5aAltPN0w+CCC3MkaZ5utA5uWB0szT3hFTIsClEckcLuQpUaNMg
         wD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rSkUkaURL4HEXp6eDUwobhgJ9shXFSHoWRujy366OcY=;
        b=5rDQtYsgT20z0Yk4ZwfLHzTtvKIXb3rJLDxpc0tkE5SkMznsHA0xBAC9jAUEUYDwmr
         8xvVnrCcdSq+hd7jdqm+GWAO2UcVLD2q+R3EeFCfarXonSAMZGLwHGlL4Fd0mo+Sst1r
         J3DMFV6IMm03R1yec4bepobOQFEV6ULCpggVzYwI93vup6tODPmMbxsIPEnj00qeUFlE
         1hmEK2+wYWjy+veO4GWuKhPpKJh/ZGvekzGHik1NCrhpFdf6mLLKuXzA6bLvhOjV29Lf
         h2wQNnzNProqvyxIIVvYHO0K/+Wv6YRH5lePTgiyMylSu9gQYjqGd1Jl7Vp8EY/ST+/s
         YvCA==
X-Gm-Message-State: AOAM532Q7Rcsliu0L/yzqRhmD73eA8GlUMfs2igBxJ77yhfo4tTgMMjZ
        CctHOM6EG37z817YMNFBNyWbkuJJI6thS4Ehb40=
X-Google-Smtp-Source: ABdhPJxXbFqylLkPxB2ftBSse2QxiXC1QnILgPxBoznPtS2cd3fqktegN13uzbjMy49GM5DrZHjeL5mKZ/11JKVbAIo=
X-Received: by 2002:a05:6638:2104:b0:326:1e94:efa6 with SMTP id
 n4-20020a056638210400b003261e94efa6mr10674733jaj.234.1650988858067; Tue, 26
 Apr 2022 09:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-5-laoar.shao@gmail.com>
 <33e5314f-8546-3945-c73b-25ee13d1b368@iogearbox.net>
In-Reply-To: <33e5314f-8546-3945-c73b-25ee13d1b368@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 27 Apr 2022 00:00:21 +0800
Message-ID: <CALOAHbCikXvNEz3f8dqe8_FcNSkvhUGpJtzyvKCgnRBdXPb7Ag@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] bpftool: Generate helpers for pinning prog
 through bpf object skeleton
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Mon, Apr 25, 2022 at 10:03 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/23/22 4:00 PM, Yafang Shao wrote:
> > After this change, with command 'bpftool gen skeleton XXX.bpf.o', the
> > helpers for pinning BPF prog will be generated in BPF object skeleton. It
> > could simplify userspace code which wants to pin bpf progs in bpffs.
> >
> > The new helpers are named with __{pin, unpin}_prog, because it only pins
> > bpf progs. If the user also wants to pin bpf maps in bpffs, he can use
> > LIBBPF_PIN_BY_NAME.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >   tools/bpf/bpftool/gen.c | 16 ++++++++++++++++
> >   1 file changed, 16 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 8f76d8d9996c..1d06ebde723b 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -1087,6 +1087,8 @@ static int do_skeleton(int argc, char **argv)
> >                       static inline int load(struct %1$s *skel);          \n\
> >                       static inline int attach(struct %1$s *skel);        \n\
> >                       static inline void detach(struct %1$s *skel);       \n\
> > +                     static inline int pin_prog(struct %1$s *skel, const char *path);\n\
> > +                     static inline void unpin_prog(struct %1$s *skel);   \n\
> >                       static inline void destroy(struct %1$s *skel);      \n\
> >                       static inline const void *elf_bytes(size_t *sz);    \n\
> >               #endif /* __cplusplus */                                    \n\
> > @@ -1172,6 +1174,18 @@ static int do_skeleton(int argc, char **argv)
> >               %1$s__detach(struct %1$s *obj)                              \n\
> >               {                                                           \n\
> >                       bpf_object__detach_skeleton(obj->skeleton);         \n\
> > +             }                                                           \n\
> > +                                                                         \n\
> > +             static inline int                                           \n\
> > +             %1$s__pin_prog(struct %1$s *obj, const char *path)          \n\
> > +             {                                                           \n\
> > +                     return bpf_object__pin_skeleton_prog(obj->skeleton, path);\n\
> > +             }                                                           \n\
> > +                                                                         \n\
> > +             static inline void                                          \n\
> > +             %1$s__unpin_prog(struct %1$s *obj)                          \n\
> > +             {                                                           \n\
> > +                     bpf_object__unpin_skeleton_prog(obj->skeleton);     \n\
> >               }                                                           \n\
>
> (This should also have BPF selftest code as in-tree user.)
>

Will do it, thanks.

[snip]

-- 
Regards
Yafang
