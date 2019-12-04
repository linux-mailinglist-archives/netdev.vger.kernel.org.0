Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B231129AC
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfLDK6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 05:58:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727472AbfLDK6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 05:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575457083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gDaTecph8Rh/JPKwYat9tHBvAWnUrZz+amifETT1mc=;
        b=Y9y/UgQPscYx3WRbYw1/UznfJJ3lfd5OqToJ1Ihejd+/GPQflcNtTzvNNkcacuxhf+fnPK
        5ahNtrjlDIwsyGfpgWI7fbkTExAmAponLE0W+xzyoDGIJwrdXL/geHbYETo1ivQpN8Sp7D
        XPCgZfDclkRAtPT1OkRP5zooJEupoL0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-espOYjGlP6CgYBet6L_x-g-1; Wed, 04 Dec 2019 05:58:02 -0500
Received: by mail-lj1-f197.google.com with SMTP id k25so862292lji.4
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 02:58:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=KcON+ZnXbOaneQXDnO49ePrfIssRevwFNRCOp04UDIY=;
        b=My1g/jUUxkq0TAGNChFD7ml91kg0j7AVY/KTbNtyhrZ5zdEmvvaPwLWSsowI3AZP+W
         V4R6SAvJLa/V9Mt1XN2nzxRP56rwod8yIyNZevWjgR0qB1OtL/yCw121QIrBIVt9bzKB
         aDc7yrP4BUHU+kULnFgHPKLuNU9YMrU7+IgPG2q7gUQQZuC35r/5ECtcvaJixkRaHpUK
         lBk4oDdTWJoE4jfLrWrlQ2+E0LAunXvkGixpTZgSMd4eqjO5BPw827zEJxlxO8k03Ucn
         QtiIb2clS55nP2UASm9EjShi+KKSxN0Q6UHUxRTPO+lI+yDoz7Pa6CjSCIErQMTEzNlv
         FuKQ==
X-Gm-Message-State: APjAAAWt1GePjpI4KgztUJCVzb7f/nhUz3kCWTH3cT1C966Id1ntHSiD
        scvF0SYDiXX0tGaEIMeaiZ0Ghrt5kCEujYDnWpy+51BCukCYZGLbE1r4/q8Dyh6/mL7+3DjQk3D
        /VDK5OgN/iwAyO6+P
X-Received: by 2002:a19:3f16:: with SMTP id m22mr1657990lfa.116.1575457081272;
        Wed, 04 Dec 2019 02:58:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqyHZ8fnHzSVuQR8PFFMiyJUuqZkRB6SDCXCj2xWgrNiCr7mlTw0t1+qB55Wz0CH2MG5OdhDnQ==
X-Received: by 2002:a19:3f16:: with SMTP id m22mr1657976lfa.116.1575457081085;
        Wed, 04 Dec 2019 02:58:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c12sm2938420ljk.77.2019.12.04.02.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 02:58:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5BD7118193A; Wed,  4 Dec 2019 11:57:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
In-Reply-To: <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
References: <20191202131847.30837-1-jolsa@kernel.org> <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com> <87wobepgy0.fsf@toke.dk> <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 Dec 2019 11:57:58 +0100
Message-ID: <877e3cpdc9.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: espOYjGlP6CgYBet6L_x-g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Dec 2, 2019 at 1:15 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Ah, that is my mistake: I was getting dynamic libbpf symbols with this
>> approach, but that was because I had the version of libbpf.so in my
>> $LIBDIR that had the patch to expose the netlink APIs as versioned
>> symbols; so it was just pulling in everything from the shared library.
>>
>> So what I was going for was exactly what you described above; but it
>> seems that doesn't actually work. Too bad, and sorry for wasting your
>> time on this :/
>
> bpftool is currently tightly coupled with libbpf and very likely
> in the future the dependency will be even tighter.
> In that sense bpftool is an extension of libbpf and libbpf is an extensio=
n
> of bpftool.
> Andrii is working on set of patches to generate user space .c code
> from bpf program.
> bpftool will be generating the code that is specific for the version
> bpftool and for
> the version of libbpf. There will be compatibility layers as usual.
> But in general the situation where a bug in libbpf is so criticial
> that bpftool needs to repackaged is imo less likely than a bug in
> bpftool that will require re-packaging of libbpf.
> bpftool is quite special. It's not a typical user of libbpf.
> The other way around is more correct. libbpf is a user of the code
> that bpftool generates and both depend on each other.
> perf on the other side is what typical user space app that uses
> libbpf will look like.
> I think keeping bpftool in the kernel while packaging libbpf
> out of github was an oversight.
> I think we need to mirror bpftool into github/libbpf as well
> and make sure they stay together. The version of libbpf =3D=3D version of=
 bpftool.
> Both should come from the same package and so on.
> May be they can be two different packages but
> upgrading one should trigger upgrade of another and vice versa.
> I think one package would be easier though.
> Thoughts?

Yup, making bpftool explicitly the "libbpf command line interface" makes
sense and would help clarify the relationship between the two. As Jiri
said, we are already moving in that direction packaging-wise...

-Toke

