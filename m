Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C075110F144
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfLBUC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 15:02:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47555 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728001AbfLBUC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 15:02:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575316974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EahjHtPxa0IRKLg7rJztVt75g0Mh1O3hEHuZpwDPvYg=;
        b=NiZYzFLiPqlnSu/NNoKVFW7jVAInZWxyKHGFD0/3kN8PiuF19A4xRbt8ATbkYfQrLPAjAM
        vlA/DPflBfzIX8zlShRgi/oNTTbHc/snom4rN4/9SI5rYZmmKRjnrVqtvu9/UuyPAR6ww0
        iV14fjIxdYucGmx+ukyoMxPICGIDuBo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-39vGrJ5NP5uyOA_Wex8FWg-1; Mon, 02 Dec 2019 15:02:53 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E4FF800D41;
        Mon,  2 Dec 2019 20:02:51 +0000 (UTC)
Received: from krava (ovpn-204-100.brq.redhat.com [10.40.204.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A37FB5DA2C;
        Mon,  2 Dec 2019 20:02:42 +0000 (UTC)
Date:   Mon, 2 Dec 2019 21:02:41 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
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
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191202200241.GB22100@krava>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
 <87zhgappl7.fsf@toke.dk>
 <CAEf4BzYoJUttk=o+p=NHK8K_aS3z2LdLiqzRni7PwyDaOxu68A@mail.gmail.com>
 <20191202192122.GA22100@krava>
 <CAEf4BzbqSKZyTyn5wTr3rt=-9W3bFZeupSiNr5YiTPp_Z8rOQw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbqSKZyTyn5wTr3rt=-9W3bFZeupSiNr5YiTPp_Z8rOQw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 39vGrJ5NP5uyOA_Wex8FWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 11:54:27AM -0800, Andrii Nakryiko wrote:
> On Mon, Dec 2, 2019 at 11:21 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, Dec 02, 2019 at 10:42:53AM -0800, Andrii Nakryiko wrote:
> > > On Mon, Dec 2, 2019 at 10:09 AM Toke H=F8iland-J=F8rgensen <toke@redh=
at.com> wrote:
> > > >
> > > > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> > > >
> > > > > On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrot=
e:
> > > > >>
> > > > >> hi,
> > > > >> adding support to link bpftool with libbpf dynamically,
> > > > >> and config change for perf.
> > > > >>
> > > > >> It's now possible to use:
> > > > >>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
> > > > >
> > > > > I wonder what's the motivation behind these changes, though? Why =
is
> > > > > linking bpftool dynamically with libbpf is necessary and importan=
t?
> > > > > They are both developed tightly within kernel repo, so I fail to =
see
> > > > > what are the huge advantages one can get from linking them
> > > > > dynamically.
> > > >
> > > > Well, all the regular reasons for using dynamic linking (memory usa=
ge,
> > > > binary size, etc).
> > >
> > > bpftool is 327KB with statically linked libbpf. Hardly a huge problem
> > > for either binary size or memory usage. CPU instruction cache usage i=
s
> > > also hardly a concern for bpftool specifically.
> > >
> > > > But in particular, the ability to update the libbpf
> > > > package if there's a serious bug, and have that be picked up by all
> > > > utilities making use of it.
> > >
> > > I agree, and that works only for utilities linking with libbpf
> > > dynamically. For tools that build statically, you'd have to update
> > > tools anyways. And if you can update libbpf, you can as well update
> > > bpftool at the same time, so I don't think linking bpftool statically
> > > with libbpf causes any new problems.
> >
> > it makes difference for us if we need to respin just one library
> > instead of several applications (bpftool and perf at the moment),
> > because of the bug in the library
> >
> > with the Toke's approach we compile some bits of libbpf statically into
> > bpftool, but there's still the official API in the dynamic libbpf that
> > we care about and that could carry on the fix without bpftool respin
>=20
> See my replies on v4 of your patchset. I have doubts this actually
> works as we hope it works.
>=20
> I also don't see how that is going to work in general. Imagine
> something like this:
>=20
> static int some_state =3D 123;
>=20
> LIBBPF_API void set_state(int x) { some_state =3D x; }
>=20
> int get_state() { return some_state; }
>=20
> If bpftool does:
>=20
> set_state(42);
> printf("%d\n", get_state());
>=20
>=20
> How is this supposed to work with set_state() coming from libbpf.so,
> while get_state() being statically linked? Who "owns" memory of `int
> some_state` -- bpftool or libbpf.so? Can they magically share it? Or
> rather maybe some_state will be actually two different variables in
> two different memory regions? And set_state() would be setting one of
> them, while get_state() would be reading another one?
>=20
> It would be good to test this out. Do you mind checking?

I think you're right.. sry, I should have checked on this more,
there are no relocations for libbpf.so, so it's all statically
linked and the libbpf is just in 'needed' libs record.. ugh :-\

jirka

