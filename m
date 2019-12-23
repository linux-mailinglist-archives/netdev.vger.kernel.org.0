Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CCB1291B0
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 06:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfLWFzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 00:55:00 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43382 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfLWFzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 00:55:00 -0500
Received: by mail-qt1-f196.google.com with SMTP id d18so11840670qtj.10;
        Sun, 22 Dec 2019 21:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vph61GXxgq9yRNojZ2R+RFipBj5KccaiwjndF8mVX3A=;
        b=MTHsW6ndC+oNo3Y60zjCvmsV9KuBN3uLi8gitEvPiudJAk4AFpVZCwGzi8zIW3YTCf
         1ugWbHHXZNTxN39dyshH4wT+ToGKRQqrj95wQ3UKuL+UMMfH06nMfrH7wivRUqFMVhze
         KQ5BaM6P9MuWJi9szZOxXyfTVT33g0N26jCRcZg4cycFw+Orig9bGo9GUiRLdST19pyx
         WSHNDAYdEX6AMZGGSZN1E3NizcCq/C/l43sknj0UM05btT5x+CFpfWLoVHRhznwS1Wm8
         f4csQdaBQdEkEZQekaisetCSxH8SOUOqAYnligo1PwHNnp8nvRFxJCYfF22ax2gaCQrM
         6/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vph61GXxgq9yRNojZ2R+RFipBj5KccaiwjndF8mVX3A=;
        b=DNCc0d293e1RLB0ewl4P5ZPXughdIvxZBb/i8SzWSE1oQZimZX5mUKK89OoMmukDPX
         CP/pf5AgfYifMZrq/YFwV+vH6S2hnY43C9wAEH5MM/WLe654nTe0D3E6PV5qc9iyI6td
         UcDHklYJl1X0+f1dLBrzo7+VteqeJmWbASv5MUeHF952eiGI1RoCMIg0LoCqKyWnrQwF
         7Kisfifn+1YqlSZgy4gq4FdKy4Wp85V8JAs4yYwKUho9vxXcX1JsxxHbEVLcc66b+McP
         gYyB+KRMZ+QyQCu4rO35nkQV4kzwcPoetpjNbUZXqxC/zFKZLQZW8IB6JhasyqKgMmUt
         sItw==
X-Gm-Message-State: APjAAAXLe9ukkn9DxbVzTsxJp/n7J3Ln3SqaMyJUL/6iZw8a9EJivuTG
        Iaezks0ht2fb4kHdjb5UJyZpPAN7w2mjAiEGhMwho++e
X-Google-Smtp-Source: APXvYqxszHeWVggwRJJ6lgaW5XepNjxxR8LQuou/oNFLCqCQSkVHydpU7nlDsqI9E5NyZDgcKKQrBfTDojZo2OK+++k=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr21635681qtj.117.1577080498692;
 Sun, 22 Dec 2019 21:54:58 -0800 (PST)
MIME-Version: 1.0
References: <20191221162158.rw6xqqktubozg6fg@ast-mbp.dhcp.thefacebook.com>
 <20191223030530.725937-1-namhyung@kernel.org> <CAEf4BzaGfsF352kWu1zZe+yXSRm4c9LQ0U57VnRq2EdtjeQutw@mail.gmail.com>
In-Reply-To: <CAEf4BzaGfsF352kWu1zZe+yXSRm4c9LQ0U57VnRq2EdtjeQutw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 22 Dec 2019 21:54:47 -0800
Message-ID: <CAEf4BzbyBgDN5svEcfpyjoViixhn2iGBs1j+jyvNhfjPp_1E=w@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Fix build on read-only filesystems
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 9:45 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Dec 22, 2019 at 7:05 PM Namhyung Kim <namhyung@kernel.org> wrote:
> >
> > I got the following error when I tried to build perf on a read-only
> > filesystem with O=dir option.
> >
> >   $ cd /some/where/ro/linux/tools/perf
> >   $ make O=$HOME/build/perf
> >   ...
> >     CC       /home/namhyung/build/perf/lib.o
> >   /bin/sh: bpf_helper_defs.h: Read-only file system
> >   make[3]: *** [Makefile:184: bpf_helper_defs.h] Error 1
> >   make[2]: *** [Makefile.perf:778: /home/namhyung/build/perf/libbpf.a] Error 2
> >   make[2]: *** Waiting for unfinished jobs....
> >     LD       /home/namhyung/build/perf/libperf-in.o
> >     AR       /home/namhyung/build/perf/libperf.a
> >     PERF_VERSION = 5.4.0
> >   make[1]: *** [Makefile.perf:225: sub-make] Error 2
> >   make: *** [Makefile:70: all] Error 2
> >
> > It was becaused bpf_helper_defs.h was generated in current directory.
> > Move it to OUTPUT directory.
> >
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
>
> Looks good, thanks!

just one minor thing: bpf_helper_defs.h has to be added to .gitignore
under selftests/bpf now

>
> Tested-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  tools/lib/bpf/Makefile               | 15 ++++++++-------
> >  tools/testing/selftests/bpf/Makefile |  6 +++---
> >  2 files changed, 11 insertions(+), 10 deletions(-)
> >
>
> [...]
