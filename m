Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8269A179AEB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgCDV3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:29:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgCDV3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 16:29:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583357381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJI8QQF7/OEZKkEHa78AcqUTru7oSuK0u2/Zvt+yl1s=;
        b=IK/gtMXDx/KJyWwqJJk8EhppIc3Y42ziDQJS3zrYx8vSi+rUDsH/L+QZGvUQqq7yQdxu9k
        G8NsdcD+yzEYzFU54cuVPngFV792qchInrgYaHd07BGhMpY9jtk17i5yqnid+fgk2casHB
        yptk11eoOHn5jndai/jy8wjr5gXl+cA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-sruHRiTCP7OGO-1CblhqNw-1; Wed, 04 Mar 2020 16:29:37 -0500
X-MC-Unique: sruHRiTCP7OGO-1CblhqNw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D227800D50;
        Wed,  4 Mar 2020 21:29:35 +0000 (UTC)
Received: from krava (ovpn-205-10.brq.redhat.com [10.40.205.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 754708AC36;
        Wed,  4 Mar 2020 21:29:33 +0000 (UTC)
Date:   Wed, 4 Mar 2020 22:29:31 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "quentin@isovalent.com" <quentin@isovalent.com>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Message-ID: <20200304212931.GE168640@krava>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava>
 <20200304204158.GD168640@krava>
 <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 09:16:29PM +0000, Song Liu wrote:
>=20
>=20
> > On Mar 4, 2020, at 12:41 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >=20
> > On Wed, Mar 04, 2020 at 08:08:07PM +0100, Jiri Olsa wrote:
> >> On Wed, Mar 04, 2020 at 10:07:06AM -0800, Song Liu wrote:
> >>> This set introduces bpftool prog profile command, which uses hardwa=
re
> >>> counters to profile BPF programs.
> >>>=20
> >>> This command attaches fentry/fexit programs to a target program. Th=
ese two
> >>> programs read hardware counters before and after the target program=
 and
> >>> calculate the difference.
> >>>=20
> >>> Changes v3 =3D> v4:
> >>> 1. Simplify err handling in profile_open_perf_events() (Quentin);
> >>> 2. Remove redundant p_err() (Quentin);
> >>> 3. Replace tab with space in bash-completion; (Quentin);
> >>> 4. Fix typo _bpftool_get_map_names =3D> _bpftool_get_prog_names (Qu=
entin).
> >>=20
> >> hum, I'm getting:
> >>=20
> >> 	[jolsa@dell-r440-01 bpftool]$ pwd
> >> 	/home/jolsa/linux-perf/tools/bpf/bpftool
> >> 	[jolsa@dell-r440-01 bpftool]$ make
> >> 	...
> >> 	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bpf'
> >> 	  LINK     _bpftool
> >> 	make: *** No rule to make target 'skeleton/profiler.bpf.c', needed =
by 'skeleton/profiler.bpf.o'.  Stop.
> >=20
> > ok, I had to apply your patches by hand, because 'git am' refused to
> > due to fuzz.. so some of you new files did not make it to my tree ;-)
> >=20
> > anyway I hit another error now:
> >=20
> > 	  CC       prog.o
> > 	In file included from prog.c:1553:
> > 	profiler.skel.h: In function =E2=80=98profiler_bpf__create_skeleton=E2=
=80=99:
> > 	profiler.skel.h:136:35: error: =E2=80=98struct profiler_bpf=E2=80=99=
 has no member named =E2=80=98rodata=E2=80=99
> > 	  136 |  s->maps[4].mmaped =3D (void **)&obj->rodata;
> > 	      |                                   ^~
> > 	prog.c: In function =E2=80=98profile_read_values=E2=80=99:
> > 	prog.c:1650:29: error: =E2=80=98struct profiler_bpf=E2=80=99 has no =
member named =E2=80=98rodata=E2=80=99
> > 	 1650 |  __u32 m, cpu, num_cpu =3D obj->rodata->num_cpu;
> >=20
> > I'll try to figure it out.. might be error on my end
> >=20
> > do you have git repo with these changes?
>=20
> I pushed it to=20
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/song/linux.git/tree/?h=3D=
bpf-per-prog-stats

still the same:

	[jolsa@dell-r440-01 bpftool]$ git show --oneline HEAD | head -1
	7bbda5cca00a bpftool: fix typo in bash-completion
	[jolsa@dell-r440-01 bpftool]$ make=20
	make[1]: Entering directory '/home/jolsa/linux-perf/tools/lib/bpf'
	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bpf'
	  CC       prog.o
	In file included from prog.c:1553:
	profiler.skel.h: In function =E2=80=98profiler_bpf__create_skeleton=E2=80=
=99:
	profiler.skel.h:136:35: error: =E2=80=98struct profiler_bpf=E2=80=99 has=
 no member named =E2=80=98rodata=E2=80=99
	  136 |  s->maps[4].mmaped =3D (void **)&obj->rodata;
	      |                                   ^~
	prog.c: In function =E2=80=98profile_read_values=E2=80=99:
	prog.c:1650:29: error: =E2=80=98struct profiler_bpf=E2=80=99 has no memb=
er named =E2=80=98rodata=E2=80=99
	 1650 |  __u32 m, cpu, num_cpu =3D obj->rodata->num_cpu;
	      |                             ^~
	prog.c: In function =E2=80=98profile_open_perf_events=E2=80=99:
	prog.c:1810:19: error: =E2=80=98struct profiler_bpf=E2=80=99 has no memb=
er named =E2=80=98rodata=E2=80=99
	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
	      |                   ^~
	prog.c:1810:42: error: =E2=80=98struct profiler_bpf=E2=80=99 has no memb=
er named =E2=80=98rodata=E2=80=99
	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
	      |                                          ^~
	prog.c:1825:26: error: =E2=80=98struct profiler_bpf=E2=80=99 has no memb=
er named =E2=80=98rodata=E2=80=99
	 1825 |   for (cpu =3D 0; cpu < obj->rodata->num_cpu; cpu++) {
	      |                          ^~
	prog.c: In function =E2=80=98do_profile=E2=80=99:
	prog.c:1904:13: error: =E2=80=98struct profiler_bpf=E2=80=99 has no memb=
er named =E2=80=98rodata=E2=80=99
	 1904 |  profile_obj->rodata->num_cpu =3D num_cpu;
	      |             ^~
	prog.c:1905:13: error: =E2=80=98struct profiler_bpf=E2=80=99 has no memb=
er named =E2=80=98rodata=E2=80=99
	 1905 |  profile_obj->rodata->num_metric =3D num_metric;
	      |             ^~
	make: *** [Makefile:129: prog.o] Error 1


jirka

