Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A2C15CD97
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgBMVuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:50:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727778AbgBMVuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581630611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rccrrusYeh/lKJYi1zR95yhXu0ox759XDiw1HfFrUwQ=;
        b=ZXRdVo2XXwyREaCdO1B+DbWJGbAr0wxLcSIU1j5IyDPuBjXoM5Ni7cDezNUkFjSP+QbRXF
        szBO3uVY7ALJpb4mK9ZLUXxbEtl1+XWUS4emOy2XKjWHJJxyX+H/gVRYDNQp9hv847MDRv
        LIgDgX0MvMv02yxE3zuyq7WyqJcCZwU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-NB2Vd6o4PI27vZZ-as6cDQ-1; Thu, 13 Feb 2020 16:50:09 -0500
X-MC-Unique: NB2Vd6o4PI27vZZ-as6cDQ-1
Received: by mail-lj1-f198.google.com with SMTP id j1so2568856lja.3
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:50:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rccrrusYeh/lKJYi1zR95yhXu0ox759XDiw1HfFrUwQ=;
        b=tPa2R5ohysGrtxOgIQETDcE66dJCR/QcOPPFmTmEAdzlnXeEo5O/1GxNWFwWhgARrc
         8waWBDXXHAhdL004SD7VPoJB77j75HjRmZ9/KgPN3PbPG/OEEEXWbpw7BlANbM5PhbNp
         gFz7jMbR8ZJ/skOCbWXeeC5rs4N+4qVE+1EAx4zaFNKPUbO81kj4pjuWCfrzLrfox6F3
         CEHADkIF41nC4JeLWLDLc1caGWJIAHEdovMbn40LeYCT8Kg1lTd9lzD6IDFXyWSnqiZL
         Q3ytTAM56/eLQZMMMjCdRYIRfpnVUKSE8s2KDxgmWGBSDBhhv3nRMzNyUD5TvBBBKb9z
         JSBQ==
X-Gm-Message-State: APjAAAUO6Q5ccxWK6UOC//rLCpmjxj+5sZbDFwrii4RpxLa04HojrUXm
        tQYn72oZcw3i1OPUdv+EyO6emWX8f2MGDhLc4KKUEJK3KCrEyIxHQz30+kcBdAapEPnDyxXlt8U
        hzr1yctXqjPgF3N0S
X-Received: by 2002:a2e:7812:: with SMTP id t18mr12947428ljc.289.1581630608080;
        Thu, 13 Feb 2020 13:50:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXjkEZfMsjk1Sf2VTCksNc2vfWRGOAZDq6df04jcnIkWuCsFmH9R7MtIPfyy8/M8ggS39bEw==
X-Received: by 2002:a2e:7812:: with SMTP id t18mr12947420ljc.289.1581630607825;
        Thu, 13 Feb 2020 13:50:07 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v9sm2370728lfe.18.2020.02.13.13.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 13:50:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4BC75180371; Thu, 13 Feb 2020 22:50:06 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        Song Liu <songliubraving@fb.com>
Subject: Re: [RFC bpf-next 3/4] bpftool: introduce "prog profile" command
In-Reply-To: <20200213210115.1455809-4-songliubraving@fb.com>
References: <20200213210115.1455809-1-songliubraving@fb.com> <20200213210115.1455809-4-songliubraving@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Feb 2020 22:50:06 +0100
Message-ID: <87o8u2dunl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu <songliubraving@fb.com> writes:

> With fentry/fexit programs, it is possible to profile BPF program with
> hardware counters. Introduce bpftool "prog profile", which measures key
> metrics of a BPF program.
>
> bpftool prog profile command creates per-cpu perf events. Then it attaches
> fentry/fexit programs to the target BPF program. The fentry program saves
> perf event value to a map. The fexit program reads the perf event again,
> and calculates the difference, which is the instructions/cycles used by
> the target program.
>
> Example input and output:
>
>   ./bpftool prog profile 20 id 810 cycles instructions
>   cycles: duration 20 run_cnt 1368 miss_cnt 665
>           counter 503377 enabled 668202 running 351857
>   instructions: duration 20 run_cnt 1368 miss_cnt 707
>           counter 398625 enabled 502330 running 272014
>
> This command measures cycles and instructions for BPF program with id
> 810 for 20 seconds. The program has triggered 1368 times. cycles was not
> measured in 665 out of these runs, because of perf event multiplexing
> (some perf commands are running in the background). In these runs, the BPF
> program consumed 503377 cycles. The perf_event enabled and running time
> are 668202 and 351857 respectively.
>
> Note that, this approach measures cycles and instructions in very small
> increments. So the fentry/fexit programs introduce noticable errors to
> the measurement results.
>
> The fentry/fexit programs are generated with BPF skeleton. Currently,
> generation of the skeleton requires some manual steps.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/bpf/bpftool/profiler.skel.h         | 820 ++++++++++++++++++++++
>  tools/bpf/bpftool/prog.c                  | 387 +++++++++-
>  tools/bpf/bpftool/skeleton/README         |   3 +
>  tools/bpf/bpftool/skeleton/profiler.bpf.c | 185 +++++
>  tools/bpf/bpftool/skeleton/profiler.h     |  47 ++
>  5 files changed, 1441 insertions(+), 1 deletion(-)
>  create mode 100644 tools/bpf/bpftool/profiler.skel.h
>  create mode 100644 tools/bpf/bpftool/skeleton/README
>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
>
> diff --git a/tools/bpf/bpftool/profiler.skel.h b/tools/bpf/bpftool/profiler.skel.h
> new file mode 100644
> index 000000000000..10e99989c03e
> --- /dev/null
> +++ b/tools/bpf/bpftool/profiler.skel.h
> @@ -0,0 +1,820 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +
> +/* THIS FILE IS AUTOGENERATED! */
> +#ifndef __PROFILER_BPF_SKEL_H__
> +#define __PROFILER_BPF_SKEL_H__
> +
> +#include <stdlib.h>
> +#include <bpf/libbpf.h>
> +
> +struct profiler_bpf {
> +	struct bpf_object_skeleton *skeleton;
> +	struct bpf_object *obj;
> +	struct {
> +		struct bpf_map *events;
> +		struct bpf_map *fentry_readings;
> +		struct bpf_map *accum_readings;
> +		struct bpf_map *counts;
> +		struct bpf_map *miss_counts;
> +		struct bpf_map *rodata;
> +	} maps;
> +	struct {
> +		struct bpf_program *fentry_XXX;
> +		struct bpf_program *fexit_XXX;
> +	} progs;
> +	struct {
> +		struct bpf_link *fentry_XXX;
> +		struct bpf_link *fexit_XXX;
> +	} links;
> +	struct profiler_bpf__rodata {
> +		__u32 num_cpu;
> +		__u32 num_metric;
> +	} *rodata;
> +};
> +
> +static void
> +profiler_bpf__destroy(struct profiler_bpf *obj)
> +{
> +	if (!obj)
> +		return;
> +	if (obj->skeleton)
> +		bpf_object__destroy_skeleton(obj->skeleton);
> +	free(obj);
> +}
> +
> +static inline int
> +profiler_bpf__create_skeleton(struct profiler_bpf *obj);
> +
> +static inline struct profiler_bpf *
> +profiler_bpf__open_opts(const struct bpf_object_open_opts *opts)
> +{
> +	struct profiler_bpf *obj;
> +
> +	obj = (typeof(obj))calloc(1, sizeof(*obj));
> +	if (!obj)
> +		return NULL;
> +	if (profiler_bpf__create_skeleton(obj))
> +		goto err;
> +	if (bpf_object__open_skeleton(obj->skeleton, opts))
> +		goto err;
> +
> +	return obj;
> +err:
> +	profiler_bpf__destroy(obj);
> +	return NULL;
> +}
> +
> +static inline struct profiler_bpf *
> +profiler_bpf__open(void)
> +{
> +	return profiler_bpf__open_opts(NULL);
> +}
> +
> +static inline int
> +profiler_bpf__load(struct profiler_bpf *obj)
> +{
> +	return bpf_object__load_skeleton(obj->skeleton);
> +}
> +
> +static inline struct profiler_bpf *
> +profiler_bpf__open_and_load(void)
> +{
> +	struct profiler_bpf *obj;
> +
> +	obj = profiler_bpf__open();
> +	if (!obj)
> +		return NULL;
> +	if (profiler_bpf__load(obj)) {
> +		profiler_bpf__destroy(obj);
> +		return NULL;
> +	}
> +	return obj;
> +}
> +
> +static inline int
> +profiler_bpf__attach(struct profiler_bpf *obj)
> +{
> +	return bpf_object__attach_skeleton(obj->skeleton);
> +}
> +
> +static inline void
> +profiler_bpf__detach(struct profiler_bpf *obj)
> +{
> +	return bpf_object__detach_skeleton(obj->skeleton);
> +}
> +
> +static inline int
> +profiler_bpf__create_skeleton(struct profiler_bpf *obj)
> +{
> +	struct bpf_object_skeleton *s;
> +
> +	s = (typeof(s))calloc(1, sizeof(*s));
> +	if (!s)
> +		return -1;
> +	obj->skeleton = s;
> +
> +	s->sz = sizeof(*s);
> +	s->name = "profiler_bpf";
> +	s->obj = &obj->obj;
> +
> +	/* maps */
> +	s->map_cnt = 6;
> +	s->map_skel_sz = sizeof(*s->maps);
> +	s->maps = (typeof(s->maps))calloc(s->map_cnt, s->map_skel_sz);
> +	if (!s->maps)
> +		goto err;
> +
> +	s->maps[0].name = "events";
> +	s->maps[0].map = &obj->maps.events;
> +
> +	s->maps[1].name = "fentry_readings";
> +	s->maps[1].map = &obj->maps.fentry_readings;
> +
> +	s->maps[2].name = "accum_readings";
> +	s->maps[2].map = &obj->maps.accum_readings;
> +
> +	s->maps[3].name = "counts";
> +	s->maps[3].map = &obj->maps.counts;
> +
> +	s->maps[4].name = "miss_counts";
> +	s->maps[4].map = &obj->maps.miss_counts;
> +
> +	s->maps[5].name = "profiler.rodata";
> +	s->maps[5].map = &obj->maps.rodata;
> +	s->maps[5].mmaped = (void **)&obj->rodata;
> +
> +	/* programs */
> +	s->prog_cnt = 2;
> +	s->prog_skel_sz = sizeof(*s->progs);
> +	s->progs = (typeof(s->progs))calloc(s->prog_cnt, s->prog_skel_sz);
> +	if (!s->progs)
> +		goto err;
> +
> +	s->progs[0].name = "fentry_XXX";
> +	s->progs[0].prog = &obj->progs.fentry_XXX;
> +	s->progs[0].link = &obj->links.fentry_XXX;
> +
> +	s->progs[1].name = "fexit_XXX";
> +	s->progs[1].prog = &obj->progs.fexit_XXX;
> +	s->progs[1].link = &obj->links.fexit_XXX;
> +
> +	s->data_sz = 18256;
> +	s->data = (void *)"\
> +\x7f\x45\x4c\x46\x02\x01\x01\0\0\0\0\0\0\0\0\0\x01\0\xf7\0\x01\0\0\0\0\0\0\0\0\

Holy binary blob, Batman! :)

What is this blob, exactly? The bytecode output of a precompiled
program?

-Toke

