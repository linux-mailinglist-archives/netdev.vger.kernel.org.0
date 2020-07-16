Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6A221A7A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgGPDDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgGPDDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:03:07 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECADC061755;
        Wed, 15 Jul 2020 20:03:07 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id o3so3806088ilo.12;
        Wed, 15 Jul 2020 20:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t+Wlsj1C9vRBcKrQbvPaRIrUEHfK7a1ao3aLrAXTh/w=;
        b=s20nivLlSY95WcxuyJxRdfKwLKTl3k6wFTw6Uyx+GAPhASxCKSxkFi79eP207h30kt
         f984HzvnURD8itmAG0AoCFGR/NQciB6sXve2O4eUnj27GpzMvXQH1qcCCDkxtQ9+6XHb
         lIHwC8iAhf8owfKJ5o/DgGrx43dqYEDB21CjOcN+M/GOpNL9A0HQqXfqqhcyyYwSBONU
         On22jPOcfmOx6h4yhrOKr8KHOzrik1/5OysRquTGlqgz7RJXBfPny15eERpjkKUxIzAM
         NSwTZPHW7UmQHFbnfkzsJVaGE60RblAGujZPGbTnJtQrxSMNeZDnyhuuWKvOiROp6Uju
         9L3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t+Wlsj1C9vRBcKrQbvPaRIrUEHfK7a1ao3aLrAXTh/w=;
        b=MxoDI9zXRLd21aU+mbvP0WsmIqOMAbpoj2NrMpshpeLcSM9icasR3dOnjIVhKYVsb7
         nDUsey+O48TfhMsYvnczkZgf7LAU6xmb7giBkgBUK3GVMHKwNpTf6eTRByJR8rP1jN7V
         u9xOukrNrlrsRX9OR2LW3+KP8G5Jm1VrggD1JC2QOnRZ4xpxnpnnYFijH8ivCgUJboPz
         Su4pvQThDAU3wxukLCjsQbYThp5xaxiJ37NqUys3bdBrl/I3DKPTLyItljIh/xewMOwq
         wi+p9/vJzYQ1zcHubMeyIYD1U2qrj5PB2Y2tDXGaDuKqWNzblW3RHaWLIujQ+82DlIx8
         CJYA==
X-Gm-Message-State: AOAM530USrxWlEN0BsugfO+I765hDb4NEIHQ2E8J64UHq8mEG9plNAFt
        n2ctBu/UKeimHy4T7M1U5PEXnXJArlXp56LWQ7s=
X-Google-Smtp-Source: ABdhPJyf7yVwHxVF9WfRgDUm24zkGcJOdZ7B98X8cDav/AVzEfZPS4Dd2dULBymJw2SpBCoUyzCg2BxUFbhh9PSfNKA=
X-Received: by 2002:a92:2802:: with SMTP id l2mr2545080ilf.169.1594868586798;
 Wed, 15 Jul 2020 20:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200715051214.28099-1-Tony.Ambardar@gmail.com> <58fadc96-2083-a043-9ef3-da72ad792324@isovalent.com>
In-Reply-To: <58fadc96-2083-a043-9ef3-da72ad792324@isovalent.com>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Wed, 15 Jul 2020 20:02:55 -0700
Message-ID: <CAPGftE86utvC+J+yoXCNU56ibJ03HwV60p0opTkxY7qN5Gtk+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: use only nftw for file tree parsing
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 at 10:35, Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-07-14 22:12 UTC-0700 ~ Tony Ambardar <tony.ambardar@gmail.com>
> > The bpftool sources include code to walk file trees, but use multiple
> > frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 a=
nd
> > is widely available, fts is not conformant and less common, especially =
on
> > non-glibc systems. The inconsistent framework usage hampers maintenance
> > and portability of bpftool, in particular for embedded systems.
> >
> > Standardize usage by rewriting one fts-based function to use nftw. This
> > change allows building bpftool against musl for OpenWrt.
> >
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
>
> Thanks!
>

Thanks for your feedback and testing, Quentin, I really appreciate it.

> I tested your set, and bpftool does not compile on my setup. The
> definitions from <ftw.h> are not picked up by gcc, common.c should have
> a "#define _GNU_SOURCE" above its list of includes for this to work
> (like perf.c has).
>

OK, I see what happened. I omitted a required "#define _XOPEN_SOURCE
..." (like in cgroup.c).  Strictly speaking, "_GNU_SOURCE" is only
needed for a nftw() GNU extension not used in common.c or cgroup.c
(but used perf.c). It turns out there are still problems with missing
definitions for getpagesize() and getline(), which are most easily
pulled in with "_GNU_SOURCE". Will update as you suggest.

> I also get a warning on this line:
>
>
> > +static int do_build_table_cb(const char *fpath, const struct stat *sb,
> > +                         int typeflag, struct FTW *ftwbuf)
> >  {
>
> Because passing fptath to open_obj_pinned() below discards the "const"
> qualifier:
>
> > +     fd =3D open_obj_pinned(fpath, true);
>
> Fixed by having simply "char *fpath" as the first argument for
> do_build_table_cb().

Hmm, that only shifts the warning, since the cb function signature for
nftw still specifies "const char":

> common.c: In function =E2=80=98build_pinned_obj_table=E2=80=99:
> common.c:438:18: warning: passing argument 2 of =E2=80=98nftw=E2=80=99 fr=
om incompatible pointer type [-Wincompatible-pointer-types]
>    if (nftw(path, do_build_table_cb, nopenfd, flags) =3D=3D -1)
>                   ^~~~~~~~~~~~~~~~~
> In file included from common.c:9:0:
> /usr/include/ftw.h:158:12: note: expected =E2=80=98__nftw_func_t {aka int=
 (*)(const char *, const struct stat *, int,  struct FTW *)}=E2=80=99 but a=
rgument is of type =E2=80=98int (*)(char *, const struct stat *, int,  stru=
ct FTW *)=E2=80=99
>  extern int nftw (const char *__dir, __nftw_func_t __func, int __descript=
ors,
>             ^~~~

Wouldn't it be better/safer in general to constify the passed char to
'open_obj_pinned' and 'open_obj_pinned_any'?  However, doing so
revealed a problem in open_obj_pinned(), where dirname() is called
directly on the passed string. This could be dangerous since some
dirname() implementations may modify the string. Let's copy the string
instead (same approach in tools/lib/bpf/libbpf.c).

> With those two modifications, bpftool compiles fine and listing objects
> with the "-f" option works as expected.
>
> Regards,
> Quentin

Let me make these changes and see what you think.

Best regards,
Tony
