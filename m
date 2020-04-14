Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF51F1A8B14
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504998AbgDNTi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504960AbgDNTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:38:26 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E76C061A10;
        Tue, 14 Apr 2020 12:38:25 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i19so8371712qtp.13;
        Tue, 14 Apr 2020 12:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S8Sruc3Mb8WtMEXL39Vf+5pyS5l53hxUElAAf0KjhFs=;
        b=cjAXviUWk8tTEtFWCG//p3nWhyXBUMR2Lfn7u/D0H1PpsC/r9TMupxX+K8ZXXOoyMI
         /qcQmJupyBOlMtEjj20jVuzInR84e+gXyEeHYhke/liFopXWkKKuxKZZVheUa63xDwBP
         p7N4AGNepD2IHBoq8sLzGoKqRADvEyyiahRhd2R/7HzQBsc+rgJ8Jdfai79v3UqGelkj
         yk94rLizD8DRktMoxO+ocMMHpALDqLIPKyhd8WPNpuQEBTdbJQr8dXuoTGLz7Tqo7URf
         f9R39K+TmecKy8QcB9JEnyhIr9xXgo7tqaqd1jmnMMGYgn1KaYIfVnLRIdU/bhfNSSWR
         v4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S8Sruc3Mb8WtMEXL39Vf+5pyS5l53hxUElAAf0KjhFs=;
        b=O1ix0Fa5+nf93xcAKcFJgwjQEco/r7ZpuisYCrwepHXvDkMDaL5+x+HplM16LT6pOE
         tsMf0Wto7vL88883bKAnqYk6YjiMQIPUotWbh0K8x50wo5oZSUeUsj92pueyKCfv9F1H
         o4EkTWHvWlT+W/gBMZh0ZzqWvw3RCrMs2Vt3SK6f+ik41Y6AcE9PR0tnQtMPanw2oq8L
         pSRDB+OvdhASVgEa1+OCzofb6jogbC9tADXDbIBQSDILkL33ADln+HIv5Nvly/utE+t/
         Y/wHE/5GmMnxB4Gl/+EwkSnhoY+bj+TLqqrt+OJSN9W1oxYJN5EYs1DiaFraKmhStpuo
         AedA==
X-Gm-Message-State: AGi0Pubtx2u3kF8cBbWafRXui++3OK6uj1uEqV73CZgyhgrMsVkg7z4y
        DHwf9Mw9i70D7m1RZdMl5buVZxcMh8HlI2n1L29Wpjg4
X-Google-Smtp-Source: APiQypIRm9IdbZt1nt7wsI3UOpvfQ1Bhvbptzy7Zb+eRZ9boFqJzudRUIjc6LaWofbsHrStP+vXxE9uMdrmXvjMHuf0=
X-Received: by 2002:ac8:1744:: with SMTP id u4mr11044718qtk.141.1586893104295;
 Tue, 14 Apr 2020 12:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200414045613.2104756-1-andriin@fb.com> <20200414175608.GB54710@rdna-mbp>
 <CAEf4BzbM4-PvOgro-SjHx6h2ndYndSNkbQTA6xq74W=PuPTpjA@mail.gmail.com> <20200414184326.GA59623@rdna-mbp>
In-Reply-To: <20200414184326.GA59623@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Apr 2020 12:38:13 -0700
Message-ID: <CAEf4BzYA6UvME-MLQVrYFPEuqzPtfB8aHbgps+VYqM7_nBn7jA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 11:44 AM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> [Tue, 2020-04-14 11:25 -0700]=
:
> > On Tue, Apr 14, 2020 at 10:56 AM Andrey Ignatov <rdna@fb.com> wrote:
> > >
> > > Andrii Nakryiko <andriin@fb.com> [Mon, 2020-04-13 21:56 -0700]:
>
> ...
>
> > > > v1->v2:
> > > > - fixed prog_type/expected_attach_type combo (Andrey);
> > > > - added comment explaining what we are doing in probe_exp_attach_ty=
pe (Andrey).
> > >
> > > Thanks for changes.
> > >
> > > I built the patch (removing the double .sec Song mentioned since it
> > > breaks compilation) and tested it: it fixes the problem with NET_XMIT=
_CN
> >
> > Wait, what? How does it break compilation? I compiled and tested
> > before submitting and just cleaned and built again, no compilation
> > errors or even warnings. Can you share compilation error you got,
> > please?
>
> Sure:
>
>         11:37:28 1 rdna@dev082.prn2:~/bpf-next$>/home/rdna/bin/clang --ve=
rsion
>         clang version 9.0.20190721
>         Target: x86_64-unknown-linux-gnu
>         Thread model: posix
>         InstalledDir: /home/rdna/bin
>         11:37:32 0 rdna@dev082.prn2:~/bpf-next$>env GCC=3D~/bin/gcc CLANG=
=3D~/bin/clang CC=3D~/bin/clang LLC=3D~/bin/llc LLVM_STRIP=3D~/bin/llvm-str=
ip  make V=3D1 -C tools/bpf/bpftool/

[...]

>
>         fatal error: too many errors emitted, stopping now [-ferror-limit=
=3D]
>         20 errors generated.
>            ld -r -o staticobjs/libbpf-in.o  staticobjs/libbpf.o staticobj=
s/bpf.o staticobjs/nlattr.o staticobjs/btf.o staticobjs/libbpf_errno.o stat=
icobjs/str_error.o staticobjs/netlink.o staticobjs/bpf_prog_linfo.o statico=
bjs/libbpf_probes.o staticobjs/xsk.o staticobjs/hashmap.o staticobjs/btf_du=
mp.o
>         ld: cannot find staticobjs/libbpf.o: No such file or directory
>         make[2]: *** [staticobjs/libbpf-in.o] Error 1
>         make[1]: *** [staticobjs/libbpf-in.o] Error 2
>         make[1]: Leaving directory `/home/rdna/bpf-next/tools/lib/bpf'
>         make: *** [/home/rdna/bpf-next/tools/lib/bpf/libbpf.a] Error 2
>         make: Leaving directory `/home/rdna/bpf-next/tools/bpf/bpftool'
>         11:37:43 2 rdna@dev082.prn2:~/bpf-next$>

Weird, I can't repro it locally neither with GCC, nor with clang-9 or
latest clang...

>
> > > I guess we can deal with selftest separately in the original thread.
> >
> > Sure, if this is going to be applied to bpf as a fix, I'd rather
> > follow-up with selftests separately.
>
> Sounds good.
>
> > > Also a question about bpf vs bpf-next: since this fixes real problem
> > > with loading cgroup skb programs, should it go to bpf tree instead?
> >
> > It will be up to maintainers, it's not so clear whether it's a new
> > feature or a bug fix.. I don't mind either way.
>
> Sounds good. Thanks.
>
> --
> Andrey Ignatov
