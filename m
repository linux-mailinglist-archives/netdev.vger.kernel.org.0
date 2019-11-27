Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3648810C05B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 23:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfK0WsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 17:48:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727007AbfK0WsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 17:48:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574894888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=toeJ9GPoxlKgpugAoVw1OE/YjcHKR6enYDrV2N8KHUA=;
        b=VyoIRAvtMScFJ+saCfBkgGyEbt5bEDWkoPa7d1ekbNoYbvUq3QTwh6M1lzhnAF1NXp7THQ
        0oRGlLvFYrAJeNrYPlYAeqFkwlZ7iTvtcJ0Ls4LW+eaNrf1ddQvLzyG43zqpYma2JnP2jd
        Kb3cGGgLdrlrVaHFgKarybjv2gcN/gc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-wC0uPfiPPn2r5VVSlOmDTw-1; Wed, 27 Nov 2019 17:48:06 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B9762F2A;
        Wed, 27 Nov 2019 22:48:03 +0000 (UTC)
Received: from krava (ovpn-204-45.brq.redhat.com [10.40.204.45])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8A0A1608B9;
        Wed, 27 Nov 2019 22:47:54 +0000 (UTC)
Date:   Wed, 27 Nov 2019 23:47:53 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191127224753.GA1209@krava>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
 <CAEf4BzaDxnF0Ppfo5r5ma3ht033bWjQ78oiBzB=F40_Np=AKhw@mail.gmail.com>
 <14accea8-a35f-5be3-607c-f5e1e7dff310@iogearbox.net>
MIME-Version: 1.0
In-Reply-To: <14accea8-a35f-5be3-607c-f5e1e7dff310@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: wC0uPfiPPn2r5VVSlOmDTw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 10:22:31PM +0100, Daniel Borkmann wrote:
> On 11/27/19 9:24 PM, Andrii Nakryiko wrote:
> > On Wed, Nov 27, 2019 at 8:38 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > On Wed, Nov 27, 2019 at 1:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >=20
> > > > hi,
> > > > adding support to link bpftool with libbpf dynamically,
> > > > and config change for perf.
> > > >=20
> > > > It's now possible to use:
> > > >    $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
> > > >=20
> > > > which will detect libbpf devel package with needed version,
> > > > and if found, link it with bpftool.
> > > >=20
> > > > It's possible to use arbitrary installed libbpf:
> > > >    $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/tm=
p/libbpf/
> > > >=20
> > > > I based this change on top of Arnaldo's perf/core, because
> > > > it contains libbpf feature detection code as dependency.
> > > > It's now also synced with latest bpf-next, so Toke's change
> > > > applies correctly.
> > >=20
> > > I don't like it.
> > > Especially Toke's patch to expose netlink as public and stable libbpf=
 api.
> > > bpftools needs to stay tightly coupled with libbpf (and statically
> > > linked for that reason).
> > > Otherwise libbpf will grow a ton of public api that would have to be =
stable
> > > and will quickly become a burden.
>=20
> +1, and would also be out of scope from a BPF library point of view.

ok, static it is.. ;-) thanks for the feedback,

jirka


>=20
> > I second that. I'm currently working on adding few more APIs that I'd
> > like to keep unstable for a while, until we have enough real-world
> > usage (and feedback) accumulated, before we stabilize them. With
> > LIBBPF_API and a promise of stable API, we are going to over-stress
> > and over-design APIs, potentially making them either too generic and
> > bloated, or too limited (and thus become deprecated almost at
> > inception time). I'd like to take that pressure off for a super-new
> > and in flux APIs and not hamper the progress.
> >=20
> > I'm thinking of splitting off those non-stable, sort-of-internal APIs
> > into separate libbpf-experimental.h (or whatever name makes sense),
> > and let those be used only by tools like bpftool, which are only ever
> > statically link against libbpf and are ok with occasional changes to
> > those APIs (which we'll obviously fix in bpftool as well). Pahole
> > seems like another candidate that fits this bill and we might expose
> > some stuff early on to it, if it provides tangible benefits (e.g., BTF
> > dedup speeds ups, etc).
> >=20
> > Then as APIs mature, we might decide to move them into libbpf.h with
> > LIBBPF_API slapped onto them. Any objections?
>=20
> I don't think adding yet another libbpf_experimental.h makes sense, it fe=
els
> too much of an invitation to add all sort of random stuff in there. We al=
ready
> do have libbpf.h and libbpf_internal.h, so everything that does not relat=
e to
> the /stable and public/ API should be moved from libbpf.h into libbpf_int=
ernal.h
> such as the netlink helpers, as one example, and bpftool can use these si=
nce
> in-tree changes also cover the latter just fine. So overall, same page, j=
ust
> reuse/improve libbpf_internal.h instead of a new libbpf_experimental.h.
>=20
> Thanks,
> Daniel
>=20

