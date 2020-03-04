Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D7E179A4B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbgCDUmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:42:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32577 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727528AbgCDUmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583354528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lO6YwEWJ1+PdcNBCFPWiw7ne9ikW1eavQmFGsQqPZJY=;
        b=IXqAt5dGPX7TDPMOObADHxeJ40qKJKSl/+8ow5dZtLfhzetwULJMv5/2VFKmGlKEoFNQ0o
        fVdOGyqlRr1f54njaju+fpSUMdrIxPwnqd8zsOnUghB9v13tGXEYHZugpuAItCGIbk8pDz
        EJyKiaxdT99Q4j++yS72QRtFUwsKi9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-e8bJvTE6MN6QZy0CbgRoZw-1; Wed, 04 Mar 2020 15:42:05 -0500
X-MC-Unique: e8bJvTE6MN6QZy0CbgRoZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B04D10CE781;
        Wed,  4 Mar 2020 20:42:03 +0000 (UTC)
Received: from krava (ovpn-205-10.brq.redhat.com [10.40.205.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC1F010013A1;
        Wed,  4 Mar 2020 20:42:00 +0000 (UTC)
Date:   Wed, 4 Mar 2020 21:41:58 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, quentin@isovalent.com,
        kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Message-ID: <20200304204158.GD168640@krava>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200304190807.GA168640@krava>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 08:08:07PM +0100, Jiri Olsa wrote:
> On Wed, Mar 04, 2020 at 10:07:06AM -0800, Song Liu wrote:
> > This set introduces bpftool prog profile command, which uses hardware
> > counters to profile BPF programs.
> >=20
> > This command attaches fentry/fexit programs to a target program. Thes=
e two
> > programs read hardware counters before and after the target program a=
nd
> > calculate the difference.
> >=20
> > Changes v3 =3D> v4:
> > 1. Simplify err handling in profile_open_perf_events() (Quentin);
> > 2. Remove redundant p_err() (Quentin);
> > 3. Replace tab with space in bash-completion; (Quentin);
> > 4. Fix typo _bpftool_get_map_names =3D> _bpftool_get_prog_names (Quen=
tin).
>=20
> hum, I'm getting:
>=20
> 	[jolsa@dell-r440-01 bpftool]$ pwd
> 	/home/jolsa/linux-perf/tools/bpf/bpftool
> 	[jolsa@dell-r440-01 bpftool]$ make
> 	...
> 	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bpf'
> 	  LINK     _bpftool
> 	make: *** No rule to make target 'skeleton/profiler.bpf.c', needed by =
'skeleton/profiler.bpf.o'.  Stop.

ok, I had to apply your patches by hand, because 'git am' refused to
due to fuzz.. so some of you new files did not make it to my tree ;-)

anyway I hit another error now:

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

I'll try to figure it out.. might be error on my end

do you have git repo with these changes?

thanks,
jirka

