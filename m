Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426374F0E55
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 06:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356822AbiDDEv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 00:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiDDEv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 00:51:27 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA3A338AF;
        Sun,  3 Apr 2022 21:49:31 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z6so9979418iot.0;
        Sun, 03 Apr 2022 21:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AS9WYNNj/VPlVB9CqYHFizFP+FlxyScQsu/X3g94fx8=;
        b=COCLRGrCaPTV7fgGSwsSCQZ8uIIGnGLXsdiB6i/qqY1Dr86d6m7Yth7/hvuEEl+dnh
         j1KFruosNj6ufSgFRIDgp0I0q/h5VYTa0J3c/cSCG6gHN4pmElDELIkToq0tVdAjhW1V
         w1ToS7ctBaqfW3i6Ra67SFeunVH+kdO8eUgxLyQB2xZxF2Iup5AvAKehZ/4wqeh1W7mn
         vfyLZC0i72SVKA/1s5pNix91mndpDog5RfCD7PoH5ittZ9j5ZEXTlbRh4FY+Ym56o+91
         dNkY0pSKTTB0S22u1WE0CD1SsWpeBF3MwJXzbjscBMoZuuax90kqdJD+YWdHm9lz6XCJ
         gmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AS9WYNNj/VPlVB9CqYHFizFP+FlxyScQsu/X3g94fx8=;
        b=1cVIwfwr/wVPTuuJ6V+cmWg3rKD9I+cjdbAU2Uq98CRD0loRmHkS9naX0c8z8mC1iS
         1MYIS9hAWJGA0E9MyC2SBx6SyK82YzR7j212WKHgLOYGJIYKqB+ZKjYC+wJsYxXIXo2K
         Fd5TjAABRnMqYRZtV3gOxJdW5DSt9spnNZauqpxeGwM8Qlie8yiJLla9IEo2kgIZZ2GU
         J1gztODJQ7IqSVw1WbEu9BcwmSzSWWYGWJcAlsa/tD5UPVJP4jDnSGCx5QzNQ7AiSA4K
         iDmm3D9NDv8S4yeNuEqcWkOptEzmQCuBkN80f2RGbAGq5XY/sExp2JjFu49LmX9FHJsS
         cV5w==
X-Gm-Message-State: AOAM531Wxm8kzAeA5hYDqr9J4uuBTlXoGZhwQ6Q/NsHvK7C5NlkbTerx
        L56ZcqHkIwUTkURgEB/sbaerlXXjyABanU0FPSQ=
X-Google-Smtp-Source: ABdhPJyH2pUV5y0OfmO8i3vVtu2qJmSoJOYGnDsq4oNOUzWWHiflssI75XzxRrMbAB4JTkyZ/ID03q5zKTkADFkiMZ0=
X-Received: by 2002:a6b:7d44:0:b0:64c:ab1b:a8a6 with SMTP id
 d4-20020a6b7d44000000b0064cab1ba8a6mr4537242ioq.63.1649047770587; Sun, 03 Apr
 2022 21:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
 <1648654000-21758-4-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzbB3yeKdxqGewFs=BA+bXBNfhDf2Xh4XzBjrsSp_0khPQ@mail.gmail.com> <CAEf4BzZ5iLi=Xuw=+Ez30LWqPQuuVK8hGaVwfyHL5A+XDkFWgw@mail.gmail.com>
In-Reply-To: <CAEf4BzZ5iLi=Xuw=+Ez30LWqPQuuVK8hGaVwfyHL5A+XDkFWgw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 21:49:19 -0700
Message-ID: <CAEf4BzYs+7B3CRrOA87A4-6DYxbVhaOj+iY+yx2ckt+=02y3kA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/5] libbpf: add auto-attach for uprobes based
 on section name
To:     Alan Maguire <alan.maguire@oracle.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 3, 2022 at 9:46 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Apr 3, 2022 at 6:14 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > Now that u[ret]probes can use name-based specification, it makes
> > > sense to add support for auto-attach based on SEC() definition.
> > > The format proposed is
> > >
> > >         SEC("u[ret]probe/binary:[raw_offset|[function_name[+offset]]")
> > >
> > > For example, to trace malloc() in libc:
> > >
> > >         SEC("uprobe/libc.so.6:malloc")
> > >
> > > ...or to trace function foo2 in /usr/bin/foo:
> > >
> > >         SEC("uprobe//usr/bin/foo:foo2")
> > >
> > > Auto-attach is done for all tasks (pid -1).  prog can be an absolute
> > > path or simply a program/library name; in the latter case, we use
> > > PATH/LD_LIBRARY_PATH to resolve the full path, falling back to
> > > standard locations (/usr/bin:/usr/sbin or /usr/lib64:/usr/lib) if
> > > the file is not found via environment-variable specified locations.
> > >
> > > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 72 insertions(+), 2 deletions(-)
> > >
> >
> > [...]
> >
> > > +static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
> > > +{
> > > +       DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> > > +       char *func, *probe_name, *func_end;
> > > +       char *func_name, binary_path[512];
> > > +       unsigned long long raw_offset;
> > > +       size_t offset = 0;
> > > +       int n;
> > > +
> > > +       *link = NULL;
> > > +
> > > +       opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe/");
> > > +       if (opts.retprobe)
> > > +               probe_name = prog->sec_name + sizeof("uretprobe/") - 1;
> > > +       else
> > > +               probe_name = prog->sec_name + sizeof("uprobe/") - 1;
> >
> > I think this will mishandle SEC("uretprobe"), let's fix this in a
> > follow up (and see a note about uretprobe selftests)
>
> So I actually fixed it up a little bit to avoid test failure on s390x
> arch. But now it's a different problem, complaining about not being
> able to resolve libc.so.6. CC'ing Ilya, but I was wondering if it's
> better to use more generic "libc.so" instead of "libc.so.6"? Have you
> tried that?

See [0] for one such failure log.

  [0] https://github.com/kernel-patches/bpf/runs/5810017263?check_suite_focus=true

>
> We should also probably refactor attach_probe.c selftest to be a
> collection of subtest, so that we can blacklist only some subtests.
> For now I have to blacklist it entirely on s390x.
>
> >
> > > +
> > > +       /* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
> > > +       if (strlen(probe_name) == 0) {
> > > +               pr_debug("section '%s' is old-style u[ret]probe/function, cannot auto-attach\n",
> > > +                        prog->sec_name);
> >
> > this seems excessive to log this, it's expected situation. The message
> > itself is also misleading, SEC("uretprobe") isn't old-style, it's
> > valid and supported case. SEC("uretprobe/something") is an error now,
> > so that's a different thing (let's improve handling in the follow up).
> >
> > > +               return 0;
> > > +       }
> > > +       snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
> > > +       /* ':' should be prior to function+offset */
> > > +       func_name = strrchr(binary_path, ':');
> > > +       if (!func_name) {
> > > +               pr_warn("section '%s' missing ':function[+offset]' specification\n",
> > > +                       prog->sec_name);
> > > +               return -EINVAL;
> > > +       }
> > > +       func_name[0] = '\0';
> > > +       func_name++;
> > > +       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
> > > +       if (n < 1) {
> > > +               pr_warn("uprobe name '%s' is invalid\n", func_name);
> > > +               return -EINVAL;
> > > +       }
> >
> > I have this feeling that you could have simplified this a bunch with
> > just one sscanf. Something along the lines of
> > "%m[^/]/%m[^:]:%m[a-zA-Z0-9_.]+%li". If one argument matched (supposed
> > to be uprobe or uretprobe), then it is a no-auto-attach case, just
> > exit. If two matched -- invalid definition (old-style definition you
> > were reporting erroneously above in pr_debug). If 3 matched -- binary
> > + func (or abs offset), if 4 matched - binary + func + offset. That
> > should cover everything, right?
> >
> > Please try to do this in a follow up.
> >
> > > +       if (opts.retprobe && offset != 0) {
> > > +               free(func);
> > > +               pr_warn("uretprobes do not support offset specification\n");
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       /* Is func a raw address? */
> > > +       errno = 0;
> > > +       raw_offset = strtoull(func, &func_end, 0);
> > > +       if (!errno && !*func_end) {
> > > +               free(func);
> > > +               func = NULL;
> > > +               offset = (size_t)raw_offset;
> > > +       }
> > > +       opts.func_name = func;
> > > +
> > > +       *link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
> > > +       free(func);
> > > +       return 0;
> >
> > this should have been return libbpf_get_error(*link), fixed it
> >
> >
> > > +}
> > > +
> > >  struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
> > >                                             bool retprobe, pid_t pid,
> > >                                             const char *binary_path,
> > > --
> > > 1.8.3.1
> > >
