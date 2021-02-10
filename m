Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9663316555
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhBJLhb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Feb 2021 06:37:31 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:27875 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhBJLgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:36:08 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-115-a5OTD5OFOq-Owgh4ZRfTyA-1; Wed, 10 Feb 2021 11:34:27 +0000
X-MC-Unique: a5OTD5OFOq-Owgh4ZRfTyA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 10 Feb 2021 11:34:25 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 10 Feb 2021 11:34:25 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Nathan Chancellor' <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Daniel Kiss <daniel.kiss@arm.com>
Subject: RE: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Thread-Topic: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Thread-Index: AQHW/0GRCH7UzKiswkSGiUsyv9cB9qpRQTWg
Date:   Wed, 10 Feb 2021 11:34:25 +0000
Message-ID: <67555404a0d449508def1d5be4d1f569@AcuMS.aculab.com>
References: <20210209052311.GA125918@ubuntu-m3-large-x86>
 <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <YCKwxNDkS9rdr43W@krava> <YCLdJPPC+6QjUsR4@krava>
 <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
 <20210210000257.GA1683281@ubuntu-m3-large-x86>
In-Reply-To: <20210210000257.GA1683281@ubuntu-m3-large-x86>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > vfs_truncate disasm:
> > >
> > >         ffff80001031f430 <vfs_truncate>:
> > >         ffff80001031f430: 5f 24 03 d5   hint    #34
> > >         ffff80001031f434: 1f 20 03 d5   nop
> > >         ffff80001031f438: 1f 20 03 d5   nop
> > >         ffff80001031f43c: 3f 23 03 d5   hint    #25
> > >
> > > thats why we don't match it in pahole.. I checked few other functions
> > > and some have the same problem and some match the function boundary
> > >
> > > those that match don't have that first hint instrucion, like:
> > >
> > >         ffff800010321e40 <do_faccessat>:
> > >         ffff800010321e40: 1f 20 03 d5   nop
> > >         ffff800010321e44: 1f 20 03 d5   nop
> > >         ffff800010321e48: 3f 23 03 d5   hint    #25
> > >
> > > any hints about hint instructions? ;-)
> >
> > aarch64 makes *some* newer instructions reuse the "hint" ie "nop"
> > encoding space to make software backwards compatible on older hardware
> > that doesn't support such instructions.  Is this BTI, perhaps? (The
> > function is perhaps the destination of an indirect call?)
> 
> It seems like it. The issue is not reproducible when
> CONFIG_ARM64_BTI_KERNEL is not set.

Is the compiler/linker doing something 'crazy'?

If a function address is taken then the BTI instruction is placed
before the function body and the symbol moved.
But non-indirect calls still jump to the original start of the function.
(In this case the first nop.)

This saves the execution time of the BTI instruction for non-indirect
calls.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

