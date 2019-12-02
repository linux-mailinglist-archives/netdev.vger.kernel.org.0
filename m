Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493EA10EFF2
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 20:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfLBTVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 14:21:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54277 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727935AbfLBTVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 14:21:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575314501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eaAylSD5PcvTCe/IhcrnehIoQyyCa6W45unVR5JJMi4=;
        b=h8jJ4WEm6oTwpFMWGkEwp3gTMTa0ds3LQn2zUfBvBasjG+GeXJbluStTRSZkOuEzKszc8+
        DjV1oRM+lwEKlnAvvL0cM60DJUSjXqZfLH5FiFRQAA7xjcQX+JP+pDuinRNuWK8q2NgUqq
        iPPKt1yiGaqc/5yd5jd9vW9wmTXmTYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-l2RZnPazP7SVpiORIoTWMw-1; Mon, 02 Dec 2019 14:21:39 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDB2E1883521;
        Mon,  2 Dec 2019 19:21:36 +0000 (UTC)
Received: from krava (ovpn-204-100.brq.redhat.com [10.40.204.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EFE95C28C;
        Mon,  2 Dec 2019 19:21:24 +0000 (UTC)
Date:   Mon, 2 Dec 2019 20:21:22 +0100
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
Message-ID: <20191202192122.GA22100@krava>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
 <87zhgappl7.fsf@toke.dk>
 <CAEf4BzYoJUttk=o+p=NHK8K_aS3z2LdLiqzRni7PwyDaOxu68A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYoJUttk=o+p=NHK8K_aS3z2LdLiqzRni7PwyDaOxu68A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: l2RZnPazP7SVpiORIoTWMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 10:42:53AM -0800, Andrii Nakryiko wrote:
> On Mon, Dec 2, 2019 at 10:09 AM Toke H=F8iland-J=F8rgensen <toke@redhat.c=
om> wrote:
> >
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >
> > > On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >>
> > >> hi,
> > >> adding support to link bpftool with libbpf dynamically,
> > >> and config change for perf.
> > >>
> > >> It's now possible to use:
> > >>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
> > >
> > > I wonder what's the motivation behind these changes, though? Why is
> > > linking bpftool dynamically with libbpf is necessary and important?
> > > They are both developed tightly within kernel repo, so I fail to see
> > > what are the huge advantages one can get from linking them
> > > dynamically.
> >
> > Well, all the regular reasons for using dynamic linking (memory usage,
> > binary size, etc).
>=20
> bpftool is 327KB with statically linked libbpf. Hardly a huge problem
> for either binary size or memory usage. CPU instruction cache usage is
> also hardly a concern for bpftool specifically.
>=20
> > But in particular, the ability to update the libbpf
> > package if there's a serious bug, and have that be picked up by all
> > utilities making use of it.
>=20
> I agree, and that works only for utilities linking with libbpf
> dynamically. For tools that build statically, you'd have to update
> tools anyways. And if you can update libbpf, you can as well update
> bpftool at the same time, so I don't think linking bpftool statically
> with libbpf causes any new problems.

it makes difference for us if we need to respin just one library
instead of several applications (bpftool and perf at the moment),
because of the bug in the library

with the Toke's approach we compile some bits of libbpf statically into
bpftool, but there's still the official API in the dynamic libbpf that
we care about and that could carry on the fix without bpftool respin

> > No reason why bpftool should be special in that respect.
>=20
> But I think bpftool is special and we actually want it to be special
> and tightly coupled to libbpf with sometimes very intimate knowledge
> of libbpf and access to "hidden" APIs. That allows us to experiment
> with new stuff that requires use of bpftool (e.g., code generation for
> BPF programs), without having to expose and seal public APIs. And I
> don't think it's a problem from the point of code maintenance, because
> both live in the same repository and are updated "atomically" when new
> features are added or changed.

I thought we solved this by Toke's approach, so there' no need
to expose any new/experimental API .. also you guys will probably
continue using static linking I guess

jirka

>=20
> Beyond superficial binary size worries, I don't see any good reason
> why we should add more complexity and variables to libbpf and bpftool
> build processes just to have a "nice to have" option of linking
> bpftool dynamically with libbpf.

