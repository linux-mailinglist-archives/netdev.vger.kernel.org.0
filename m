Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36751026B
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352728AbiDZQCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbiDZQCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:02:39 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9B162F02;
        Tue, 26 Apr 2022 08:59:31 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 125so20511869iov.10;
        Tue, 26 Apr 2022 08:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gfpSc0z/6I7jJsQOTt2qZJawlUricbXQold41CY5zB4=;
        b=eHKp597PQK44V/1bqAaHTyqhrcnNqvHLy9QR3FDa6fnKNU5D5cJK1IAbSN3vEG04Rs
         zIDB75886gHtg01vThi35+aHgSHXdk6DCecIqJdmSUqZz5Qn0fk05VtTZs97FHzculrE
         NzSpd7ROO6ES9cPGEnXVq7bcPAkL6Gg7yKLYseEAyKxSlqvkhnrDWpJxdpvAAALbr2TH
         GGPn29uLp0W6Hr4B61/bxe6/jDJzHK0EYwr5ZIPmD/49IXkRH6mJBmcQ2V7VU+PHyAid
         tndw+JcIM2oLK0VDLqswTebQk+qumLWjDZmQDsdei0bXsoBYT9DNx/2wkqenYKIXlq/a
         skIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gfpSc0z/6I7jJsQOTt2qZJawlUricbXQold41CY5zB4=;
        b=SBR98WOi+AVW8AdZBsWSz6K5Ex4lPsbl8e7kFCq4j5IJ2idx3dSZI6/7Sahcz5qAiN
         YtvhVfTniGLCMfn6x/hFmrVBR6wLH87Vx9arCXJSTfqnfuT9x8hW8kQHBiv5T/1+rIed
         +O0tr71Ws7H9NXgMN8R8ETVTWLiIhLTOudWzdoYeu6hI90rCKX2cYxa3zNMV6k7yKt5E
         +qtclAx6lIoGtn5g3SKHluHYkWAjDptVmRCLnZj72saapziuuPMcNrsz+z0JLVdTExxu
         FNBkNau86TQ1q5gryadqwNJQSJLd5SRrfu/IIk7Nl1GfEAS84MLHvgqIQ7PTt3qGN7A9
         T3uQ==
X-Gm-Message-State: AOAM5301u+9giNWMoth6KY/j8CTw8d2wrnFf/S/YHA7mKX7EsnpY4LnM
        SuJXWkAczceQneg0XIQJv9khZHqB2/C2i/BnfIw=
X-Google-Smtp-Source: ABdhPJyUFkILh6J2ny6XYpvSmVcSKPUffwbFxZvct8ShDKFycnqIL5g3+cTLXrVEK+y0vEDeMItP4DrtmXCDXiwKsq0=
X-Received: by 2002:a92:c8ca:0:b0:2cb:fb69:b0e8 with SMTP id
 c10-20020a92c8ca000000b002cbfb69b0e8mr9248186ilq.238.1650988770611; Tue, 26
 Apr 2022 08:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-3-laoar.shao@gmail.com>
 <29b077a7-1e99-9436-bd5a-4277651e09db@iogearbox.net>
In-Reply-To: <29b077a7-1e99-9436-bd5a-4277651e09db@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Apr 2022 23:58:54 +0800
Message-ID: <CALOAHbAb6VH_fHAE3_tCMK0pBJCdM9PPg9pfHoye+2jq+N7DYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] libbpf: Add helpers for pinning bpf prog
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

On Mon, Apr 25, 2022 at 9:57 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/23/22 4:00 PM, Yafang Shao wrote:
> > Currently there're helpers for allowing to open/load/attach BPF object
> > through BPF object skeleton. Let's also add helpers for pinning through
> > BPF object skeleton. It could simplify BPF userspace code which wants to
> > pin the progs into bpffs.
>
> Please elaborate some more on your use case/rationale for the commit message,
> do you have orchestration code that will rely on these specifically?
>

We have a bpf manager on our production environment to maintain the
bpf programs, some of which need to be pinned in bpffs, for example
tracing bpf programs, perf_event programs and other bpf hooks added by
ourselves for performance tuning.  These bpf programs don't need a
user agent, while they really work like a kernel module, that is why
we pin them. For these kinds of bpf programs, the bpf manager can help
to simplify the development and deployment.  Take the improvement on
development for example,  the user doesn't need to write userspace
code while he focuses on the kernel side only, and then bpf manager
will do all the other things. Below is a simple example,
   Step1, gen the skeleton for the user provided bpf object file,
              $ bpftool gen skeleton  test.bpf.o > simple.skel.h
   Step2, Compile the bpf object file into a runnable binary
              #include "simple.skel.h"

              #define SIMPLE_BPF_PIN(name, path)  \
              ({                                                              \
                  struct name##_bpf *obj;                      \
                  int err = 0;                                            \
                                                                              \
                  obj = name##_bpf__open();                \
                   if (!obj) {                                              \
                       err = -errno;                                    \
                       goto cleanup;                                 \
                    }                                                         \
                                                                              \
                    err = name##_bpf__load(obj);           \
                    if (err)                                                 \
                        goto cleanup;                                 \
                                                                               \
                     err = name##_bpf__attach(obj);       \
                     if (err)                                                \
                         goto cleanup;                                \
                                                                               \
                     err = name##_bpf__pin_prog(obj, path);      \
                     if (err)                                                \
                         goto cleanup;                                \
                                                                              \
                      goto end;                                         \
                                                                              \
                  cleanup:                                              \
                      name##_bpf__destroy(obj);            \
                  end:                                                     \
                      err;                                                  \
                   })

                   SIMPLE_BPF_PIN(test, "/sys/fs/bpf");

               As the userspace code of FD-based bpf objects are all
the same,  so we can abstract them as above.  The pathset means to add
the non-exist "name##_bpf__pin_prog(obj, path)" for it.

> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >   tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++++
> >   tools/lib/bpf/libbpf.h   |  4 +++
> >   tools/lib/bpf/libbpf.map |  2 ++
> >   3 files changed, 65 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 13fcf91e9e0e..e7ed6c53c525 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -12726,6 +12726,65 @@ void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
> >       }
> >   }
> >
> > +int bpf_object__pin_skeleton_prog(struct bpf_object_skeleton *s,
> > +                               const char *path)
>
> These pin the link, not the prog itself, so the func name is a bit misleading? Also,
> what if is this needs to be more customized in future? It doesn't seem very generic.
>

Ah, it should be bpf_object__pin_skeleton_link().
I'm not sure if it can be extended to work for a non-auto-detachable
bpf program, but I know it is hard for pinning tc-bpf programs, which
is also running on our production environment, in this way.

> > +{
> > +     struct bpf_link *link;
> > +     int err;
> > +     int i;
> > +
> > +     if (!s->prog_cnt)
> > +             return libbpf_err(-EINVAL);
> > +
> > +     if (!path)
> > +             path = DEFAULT_BPFFS;
> > +
> > +     for (i = 0; i < s->prog_cnt; i++) {
> > +             char buf[PATH_MAX];
> > +             int len;
> > +
> > +             len = snprintf(buf, PATH_MAX, "%s/%s", path, s->progs[i].name);
> > +             if (len < 0) {
> > +                     err = -EINVAL;
> > +                     goto err_unpin_prog;
> > +             } else if (len >= PATH_MAX) {
> > +                     err = -ENAMETOOLONG;
> > +                     goto err_unpin_prog;
> > +             }
> > +
> > +             link = *s->progs[i].link;
> > +             if (!link) {
> > +                     err = -EINVAL;
> > +                     goto err_unpin_prog;
> > +             }
> > +
> > +             err = bpf_link__pin(link, buf);
> > +             if (err)
> > +                     goto err_unpin_prog;
> > +     }
> > +
> > +     return 0;
> > +
> > +err_unpin_prog:
> > +     bpf_object__unpin_skeleton_prog(s);
> > +
> > +     return libbpf_err(err);
> > +}
> > +
> > +void bpf_object__unpin_skeleton_prog(struct bpf_object_skeleton *s)
> > +{
> > +     struct bpf_link *link;
> > +     int i;
> > +
> > +     for (i = 0; i < s->prog_cnt; i++) {
> > +             link = *s->progs[i].link;
> > +             if (!link || !link->pin_path)
> > +                     continue;
> > +
> > +             bpf_link__unpin(link);
> > +     }
> > +}
> > +
> >   void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
> >   {
> >       if (!s)
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 3784867811a4..af44b0968cca 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -1427,6 +1427,10 @@ bpf_object__open_skeleton(struct bpf_object_skeleton *s,
> >   LIBBPF_API int bpf_object__load_skeleton(struct bpf_object_skeleton *s);
> >   LIBBPF_API int bpf_object__attach_skeleton(struct bpf_object_skeleton *s);
> >   LIBBPF_API void bpf_object__detach_skeleton(struct bpf_object_skeleton *s);
> > +LIBBPF_API int
> > +bpf_object__pin_skeleton_prog(struct bpf_object_skeleton *s, const char *path);
> > +LIBBPF_API void
> > +bpf_object__unpin_skeleton_prog(struct bpf_object_skeleton *s);
> >   LIBBPF_API void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s);
>
> Please also add API documentation.
>

Sure.

> >   struct bpf_var_skeleton {
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 82f6d62176dd..4e3e37b84b3a 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -55,6 +55,8 @@ LIBBPF_0.0.1 {
> >               bpf_object__unload;
> >               bpf_object__unpin_maps;
> >               bpf_object__unpin_programs;
> > +             bpf_object__pin_skeleton_prog;
> > +             bpf_object__unpin_skeleton_prog;
>
> This would have to go under LIBBPF_0.8.0 if so.
>

Thanks, I will change it.

> >               bpf_perf_event_read_simple;
> >               bpf_prog_attach;
> >               bpf_prog_detach;
> >
>

-- 
Regards
Yafang
