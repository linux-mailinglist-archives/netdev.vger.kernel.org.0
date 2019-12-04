Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A5D11365C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfLDUXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:23:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42032 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727911AbfLDUW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575490978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6501AeuCH09kqXayTpJahOroJlNswm8cYGVnammuGQ=;
        b=cmEl7UJPtZNkOCFgzByuvji/lxGXZTLTxng4mY4MiVrRJBR2Fe2yjIhGXDEr7u3gmW6NaC
        8PzCCpwJzMGwFcFj8sxEKsWoahfPGhsc+9C1zd5OxyvHrlX4RzVDHw5TQEAtKKAIqCZdFC
        wT7YRqj4PZBpBamwxI4X0PKw7c1LYXo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-XvNzvK0oMHuCpD8D8gzlcg-1; Wed, 04 Dec 2019 15:22:57 -0500
Received: by mail-lf1-f72.google.com with SMTP id z3so100320lfq.22
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 12:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bWGBRGftecl1TELE+NPWJSQpPs1ATjeROtIx8QlzOM4=;
        b=ieRpq+fxEnlIijo5sidda1xMaGU7PmTAIGlvZf+EQbDtyXKDU5qaCZ2fJ4vs/oL7kF
         vCH3rnwFZmGSMOJzZEZMxzTIKcSF6A2t+Vxo6W+AGsz3NHZFS+60ILemEwvN5RDluSPk
         g6X8kHj/8Dt5r/1XCqQuO0WK9yahk4Bmyurzb5+9hXGlCSrSTZ3la2pIlB95HGuEverB
         TiV4G6KMM4nYhb6aynsvyIKgHqXV7dz2r5kCGf+1Fj0OVQM6285FtzhU4/JnR5641/1M
         /edJLYIu1JvRcGAbOwFH6N/SQFJVEx9X0dga54XI3o7H79dE/dd4jjFfn+FuMFL7s9Vl
         ks5g==
X-Gm-Message-State: APjAAAUpZo33pkXDq8YvYTQOe0o5ZI0AvLJDtyjdvZSuXZMhvQM8bv8s
        ug/1DuiYo8GzVFK33pzzpW5aaqkvXGyg6GSziFQ59avfBXgR8YoQBFgTAnbqO7ptWUvy/scKwtE
        GbOVNushPCn6xK3h4
X-Received: by 2002:ac2:4553:: with SMTP id j19mr3393439lfm.142.1575490975543;
        Wed, 04 Dec 2019 12:22:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqy2XgLJTxeJZ2xtK1286GgeuYjhYemj4/KIs3cLvmOYe+qrHgZQ6tFFdNaXHi7b1nLifRHVpA==
X-Received: by 2002:ac2:4553:: with SMTP id j19mr3393421lfm.142.1575490975321;
        Wed, 04 Dec 2019 12:22:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o19sm4417121lji.54.2019.12.04.12.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 12:22:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C9CAC18193A; Wed,  4 Dec 2019 21:22:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
In-Reply-To: <20191204182727.GA29780@localhost.localdomain>
References: <20191202131847.30837-1-jolsa@kernel.org> <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com> <87wobepgy0.fsf@toke.dk> <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com> <877e3cpdc9.fsf@toke.dk> <CAADnVQJeC9FQDXhv34KTiFSRq-=x4cBaspj-bTXdQ1=7prphcA@mail.gmail.com> <20191204182727.GA29780@localhost.localdomain>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 Dec 2019 21:22:53 +0100
Message-ID: <874kyfon6q.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: XvNzvK0oMHuCpD8D8gzlcg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On Wed, Dec 04, 2019 at 09:39:59AM -0800, Alexei Starovoitov wrote:
>> On Wed, Dec 4, 2019 at 2:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> > > On Mon, Dec 2, 2019 at 1:15 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
>> > >>
>> > >> Ah, that is my mistake: I was getting dynamic libbpf symbols with t=
his
>> > >> approach, but that was because I had the version of libbpf.so in my
>> > >> $LIBDIR that had the patch to expose the netlink APIs as versioned
>> > >> symbols; so it was just pulling in everything from the shared libra=
ry.
>> > >>
>> > >> So what I was going for was exactly what you described above; but i=
t
>> > >> seems that doesn't actually work. Too bad, and sorry for wasting yo=
ur
>> > >> time on this :/
>> > >
>> > > bpftool is currently tightly coupled with libbpf and very likely
>> > > in the future the dependency will be even tighter.
>> > > In that sense bpftool is an extension of libbpf and libbpf is an ext=
ension
>> > > of bpftool.
>> > > Andrii is working on set of patches to generate user space .c code
>> > > from bpf program.
>> > > bpftool will be generating the code that is specific for the version
>> > > bpftool and for
>> > > the version of libbpf. There will be compatibility layers as usual.
>> > > But in general the situation where a bug in libbpf is so criticial
>> > > that bpftool needs to repackaged is imo less likely than a bug in
>> > > bpftool that will require re-packaging of libbpf.
>> > > bpftool is quite special. It's not a typical user of libbpf.
>> > > The other way around is more correct. libbpf is a user of the code
>> > > that bpftool generates and both depend on each other.
>> > > perf on the other side is what typical user space app that uses
>> > > libbpf will look like.
>> > > I think keeping bpftool in the kernel while packaging libbpf
>> > > out of github was an oversight.
>> > > I think we need to mirror bpftool into github/libbpf as well
>> > > and make sure they stay together. The version of libbpf =3D=3D versi=
on of bpftool.
>> > > Both should come from the same package and so on.
>> > > May be they can be two different packages but
>> > > upgrading one should trigger upgrade of another and vice versa.
>> > > I think one package would be easier though.
>> > > Thoughts?
>> >
>> > Yup, making bpftool explicitly the "libbpf command line interface" mak=
es
>> > sense and would help clarify the relationship between the two. As Jiri
>> > said, we are already moving in that direction packaging-wise...
>>=20
>> Awesome. Let's figure out the logistics.
>> Should we do:
>> git mv tools/bpf/bpftool/ tools/lib/bpf/
>> and appropriate adjustment to Makefiles ?
>> or keep it where it is and only add to
>> https://github.com/libbpf/libbpf/blob/master/scripts/sync-kernel.sh ?
>
> I'd be in preference of the latter aka keeping where it is.

I don't have any strong preference either way. It would make sense to
move it to make clear the interdependency (and that bpftool is really
the "libbpf cli interface"); but it could also just be kept separate and
just document this in the existing bpftool dir.

The github repository may need some surgery, though. So maybe let the
changes in the kernel tree depend on what's easiest for that? IDK?

-Toke

