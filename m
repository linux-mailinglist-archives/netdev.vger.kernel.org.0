Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DD0CF0DD
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 04:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfJHCib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 22:38:31 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38592 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbfJHCia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 22:38:30 -0400
Received: by mail-lj1-f193.google.com with SMTP id b20so15813997ljj.5;
        Mon, 07 Oct 2019 19:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VgTBznajx1HX4zvBYEm6aNoSOsgFu/JG0aP5omKI1e4=;
        b=oGeXTShEmm2cSJ51fJfrZphg72LwXwFJ+3IaVGqV7EH6f+sjBz0H9di4yYbkgUbTyC
         UTnKYUhCNb+dMsUQ/5QUK3UvUGuNW8tg+GbrI4mi6FGIGr5MKLUptQqt4k4nKFU0yom9
         Z/8TPKtDlywwOcZPOUkBs2Sbcla56/Sf2N8UqCVjLxmklvE1R3BGfb2NgNvN07zREAB2
         m0G2p/ANunKHuY9GCLCqs24vAjIZ7bXI5/NEuF6WKdpNhk0ez2Jx/Fty1e5fQBH/gr9z
         //rGaBlnDrmlXmgYhauNlbm0gP/s0W1UZW7mo621iX0JxMRjnydHTEWZyOXNtFdjE8MC
         eROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VgTBznajx1HX4zvBYEm6aNoSOsgFu/JG0aP5omKI1e4=;
        b=rH/E3GSinHla2Z9VKZdWsOXPGm5KIdznrqJUjvi9Hh169G1rZnkWHmx36w6WddgdW6
         2Lxef5a8H5Z4hxWAxuxRrk9RiyKL/XTc6Ryu7voVN00N2C39gh9YzfUGshWq3pKFlHON
         XW6KlFFRLZRq8XIdStgaf+UjsdF9qb4RzLLauqikWhErOwHXw8e12upyWYK0B5kz1UJ/
         Qc+WyqU0kX3M0QsNKTME3gz8EuNvo5YH+I3J5k0/rEv1gHR5lFvsnRg01v6Ska4mQKd7
         fNqaM/3A1Ug/xzGigLo4h6Syo21DdcVZaWA3txPE5wLwr4+yR533KnjnR1TMqQnBj3za
         YGmw==
X-Gm-Message-State: APjAAAWWbbtGQmMGtrjMgIG4ZyuH/pLPOJBXZ/6GYvkgCTx21yI+irKZ
        m+VDPs2jnpuMsV3oooklg0dxaCg2vhXgf2YSfrk=
X-Google-Smtp-Source: APXvYqw6An+Q/HIBj8ODgIQwgciSeNV7wWH0gdJWPJeccHQAzVmwT94heE8lPQsyfd+6fxgT436rCwU1xpIONV+kz8A=
X-Received: by 2002:a2e:29dc:: with SMTP id p89mr20843740ljp.228.1570502306891;
 Mon, 07 Oct 2019 19:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191007225604.2006146-1-andriin@fb.com> <20191007185932.24d00391@cakuba.netronome.com>
 <CAADnVQ+XrFG25PaT_859Vz+9HmenKm4F1y4m8F-KauKkBCZp7Q@mail.gmail.com> <20191007192328.2d89f63e@cakuba.netronome.com>
In-Reply-To: <20191007192328.2d89f63e@cakuba.netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Oct 2019 19:38:15 -0700
Message-ID: <CAADnVQJne3UYsuuyzTMrCB5LS2d+=--mJ1uRod=JVBcozuuDzg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpftool: fix bpftool build by switching to bpf_object__open_file()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 7:23 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 7 Oct 2019 19:16:45 -0700, Alexei Starovoitov wrote:
> > On Mon, Oct 7, 2019 at 7:00 PM Jakub Kicinski wrote:
> > > On Mon, 7 Oct 2019 15:56:04 -0700, Andrii Nakryiko wrote:
> > > > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > > > index 43fdbbfe41bb..27da96a797ab 100644
> > > > --- a/tools/bpf/bpftool/prog.c
> > > > +++ b/tools/bpf/bpftool/prog.c
> > > > @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
> > > >  static int load_with_options(int argc, char **argv, bool first_prog_only)
> > > >  {
> > > >       struct bpf_object_load_attr load_attr = { 0 };
> > > > -     struct bpf_object_open_attr open_attr = {
> > > > -             .prog_type = BPF_PROG_TYPE_UNSPEC,
> > > > -     };
> > > > +     enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
> > > >       enum bpf_attach_type expected_attach_type;
> > > >       struct map_replace *map_replace = NULL;
> > > >       struct bpf_program *prog = NULL, *pos;
> > >
> > > Please maintain reverse xmas tree..
> >
> > There are exceptions. I don't think it's worth doing everywhere.
>
> Rule #0 stick to the existing code style.
>
> "Previous line of code declaring this variable in a different way was
> in this place" is a really weak argument and the only one which can be
> made here...

do you seriously think that arguing about xmas tree is a good
spend of yours and my time?!
