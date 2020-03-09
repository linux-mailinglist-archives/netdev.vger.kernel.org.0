Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D21F17E874
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCITai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:30:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726121AbgCITai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 15:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583782236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6NramtGDoFCwy/nxpn12rnG9AAdv9t28bJf6ex/kKU=;
        b=d+Z/KsvUUBB2qMlvqWEDUnFoRVh4eNeY6Q5FveZIzrovTcxZIiaEClHhHPQH8auR/lQlUw
        5fGbY46dPEelKihvrlLJUUX/EpB6883uwTgfz1PfR5YEaVNUa6PoAnCivV/InBBUemtVF/
        2xwpU6SpJ0Yz1DyaLOHn4lEMTnbKvNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-bMR-7LV8NCKvf3r6412A6A-1; Mon, 09 Mar 2020 15:30:33 -0400
X-MC-Unique: bMR-7LV8NCKvf3r6412A6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D2288017CC;
        Mon,  9 Mar 2020 19:30:31 +0000 (UTC)
Received: from krava (ovpn-204-56.brq.redhat.com [10.40.204.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CFA335C28D;
        Mon,  9 Mar 2020 19:30:28 +0000 (UTC)
Date:   Mon, 9 Mar 2020 20:30:26 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Message-ID: <20200309193026.GE67774@krava>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava>
 <20200304204158.GD168640@krava>
 <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com>
 <20200304212931.GE168640@krava>
 <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
 <4d3b2e44-48bd-ece2-a1c7-16b7950bc472@isovalent.com>
 <37D64185-5E90-49B4-A6EA-D5E77ACF9D1F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <37D64185-5E90-49B4-A6EA-D5E77ACF9D1F@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 06:24:22PM +0000, Song Liu wrote:
>=20
>=20
> > On Mar 9, 2020, at 11:04 AM, Quentin Monnet <quentin@isovalent.com> w=
rote:
> >=20
> > 2020-03-04 21:39 UTC+0000 ~ Song Liu <songliubraving@fb.com>
> >>=20
> >>=20
> >>> On Mar 4, 2020, at 1:29 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >>>=20
> >>> On Wed, Mar 04, 2020 at 09:16:29PM +0000, Song Liu wrote:
> >>>>=20
> >>>>=20
> >>>>> On Mar 4, 2020, at 12:41 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >>>>>=20
> >>>>> On Wed, Mar 04, 2020 at 08:08:07PM +0100, Jiri Olsa wrote:
> >>>>>> On Wed, Mar 04, 2020 at 10:07:06AM -0800, Song Liu wrote:
> >>>>>>> This set introduces bpftool prog profile command, which uses ha=
rdware
> >>>>>>> counters to profile BPF programs.
> >>>>>>>=20
> >>>>>>> This command attaches fentry/fexit programs to a target program=
. These two
> >>>>>>> programs read hardware counters before and after the target pro=
gram and
> >>>>>>> calculate the difference.
> >>>>>>>=20
> >>>>>>> Changes v3 =3D> v4:
> >>>>>>> 1. Simplify err handling in profile_open_perf_events() (Quentin=
);
> >>>>>>> 2. Remove redundant p_err() (Quentin);
> >>>>>>> 3. Replace tab with space in bash-completion; (Quentin);
> >>>>>>> 4. Fix typo _bpftool_get_map_names =3D> _bpftool_get_prog_names=
 (Quentin).
> >>>>>>=20
> >>>>>> hum, I'm getting:
> >>>>>>=20
> >>>>>> 	[jolsa@dell-r440-01 bpftool]$ pwd
> >>>>>> 	/home/jolsa/linux-perf/tools/bpf/bpftool
> >>>>>> 	[jolsa@dell-r440-01 bpftool]$ make
> >>>>>> 	...
> >>>>>> 	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bp=
f'
> >>>>>> 	  LINK     _bpftool
> >>>>>> 	make: *** No rule to make target 'skeleton/profiler.bpf.c', nee=
ded by 'skeleton/profiler.bpf.o'.  Stop.
> >>>>>=20
> >>>>> ok, I had to apply your patches by hand, because 'git am' refused=
 to
> >>>>> due to fuzz.. so some of you new files did not make it to my tree=
 ;-)
> >>>>>=20
> >>>>> anyway I hit another error now:
> >>>>>=20
> >>>>> 	  CC       prog.o
> >>>>> 	In file included from prog.c:1553:
> >>>>> 	profiler.skel.h: In function =E2=80=98profiler_bpf__create_skele=
ton=E2=80=99:
> >>>>> 	profiler.skel.h:136:35: error: =E2=80=98struct profiler_bpf=E2=80=
=99 has no member named =E2=80=98rodata=E2=80=99
> >>>>> 	  136 |  s->maps[4].mmaped =3D (void **)&obj->rodata;
> >>>>> 	      |                                   ^~
> >>>>> 	prog.c: In function =E2=80=98profile_read_values=E2=80=99:
> >>>>> 	prog.c:1650:29: error: =E2=80=98struct profiler_bpf=E2=80=99 has=
 no member named =E2=80=98rodata=E2=80=99
> >>>>> 	 1650 |  __u32 m, cpu, num_cpu =3D obj->rodata->num_cpu;
> >>>>>=20
> >>>>> I'll try to figure it out.. might be error on my end
> >>>>>=20
> >>>>> do you have git repo with these changes?
> >>>>=20
> >>>> I pushed it to=20
> >>>>=20
> >>>> https://git.kernel.org/pub/scm/linux/kernel/git/song/linux.git/tre=
e/?h=3Dbpf-per-prog-stats
> >>>=20
> >>> still the same:
> >>>=20
> >>> 	[jolsa@dell-r440-01 bpftool]$ git show --oneline HEAD | head -1
> >>> 	7bbda5cca00a bpftool: fix typo in bash-completion
> >>> 	[jolsa@dell-r440-01 bpftool]$ make=20
> >>> 	make[1]: Entering directory '/home/jolsa/linux-perf/tools/lib/bpf'
> >>> 	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bpf'
> >>> 	  CC       prog.o
> >>> 	In file included from prog.c:1553:
> >>> 	profiler.skel.h: In function =E2=80=98profiler_bpf__create_skeleto=
n=E2=80=99:
> >>> 	profiler.skel.h:136:35: error: =E2=80=98struct profiler_bpf=E2=80=99=
 has no member named =E2=80=98rodata=E2=80=99
> >>> 	  136 |  s->maps[4].mmaped =3D (void **)&obj->rodata;
> >>> 	      |                                   ^~
> >>> 	prog.c: In function =E2=80=98profile_read_values=E2=80=99:
> >>> 	prog.c:1650:29: error: =E2=80=98struct profiler_bpf=E2=80=99 has n=
o member named =E2=80=98rodata=E2=80=99
> >>> 	 1650 |  __u32 m, cpu, num_cpu =3D obj->rodata->num_cpu;
> >>> 	      |                             ^~
> >>> 	prog.c: In function =E2=80=98profile_open_perf_events=E2=80=99:
> >>> 	prog.c:1810:19: error: =E2=80=98struct profiler_bpf=E2=80=99 has n=
o member named =E2=80=98rodata=E2=80=99
> >>> 	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_met=
ric);
> >>> 	      |                   ^~
> >>> 	prog.c:1810:42: error: =E2=80=98struct profiler_bpf=E2=80=99 has n=
o member named =E2=80=98rodata=E2=80=99
> >>> 	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_met=
ric);
> >>> 	      |                                          ^~
> >>> 	prog.c:1825:26: error: =E2=80=98struct profiler_bpf=E2=80=99 has n=
o member named =E2=80=98rodata=E2=80=99
> >>> 	 1825 |   for (cpu =3D 0; cpu < obj->rodata->num_cpu; cpu++) {
> >>> 	      |                          ^~
> >>> 	prog.c: In function =E2=80=98do_profile=E2=80=99:
> >>> 	prog.c:1904:13: error: =E2=80=98struct profiler_bpf=E2=80=99 has n=
o member named =E2=80=98rodata=E2=80=99
> >>> 	 1904 |  profile_obj->rodata->num_cpu =3D num_cpu;
> >>> 	      |             ^~
> >>> 	prog.c:1905:13: error: =E2=80=98struct profiler_bpf=E2=80=99 has n=
o member named =E2=80=98rodata=E2=80=99
> >>> 	 1905 |  profile_obj->rodata->num_metric =3D num_metric;
> >>> 	      |             ^~
> >>> 	make: *** [Makefile:129: prog.o] Error 1
> >>=20
> >> I guess you need a newer version of clang that supports global data =
in BPF programs.=20
> >>=20
> >> Thanks,
> >> Song
> >>=20
> >=20
> > Thinking about this requirement again... Do you think it would be wor=
th
> > adding (as a follow-up) a feature check on the availability of clang
> > with global data support to bpftool's Makefile? So that we could comp=
ile
> > out program profiling if clang is not present or does not support it.
> > Just like libbfd support is optional already.
> >=20
> > I'm asking mostly because a number of distributions now package bpfto=
ol,
> > and e.g. Ubuntu builds it from kernel source when creating its
> > linux-images and linux-tools-* packages. And I am pretty sure the bui=
ld
> > environment does not have latest clang/LLVM, but it would be great to
> > remain able to build bpftool.
>=20
> Yeah, I think it is a good idea. Some more Makefile fun. ;)

I think it's good idea, also bpftool is already using feature
detection from tools/build/features.. you can check commits like:

  fb982666e380 tools/bpftool: fix bpftool build with bintutils >=3D 2.9

for adding new feature detection

jirka

