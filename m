Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986B1A3FAE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfH3Vfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:35:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41238 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbfH3Vfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:35:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so3922633pls.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zumOGWEFsMXrLVxFP/CAInFT5wMODXI5T6IEqZrAc5s=;
        b=WnWqXHLSxyM/eRCAI6vlA+VSHOlAwzE7xGLmiGr9hKKdnry8JDmcHi+odZgmfaDe2Q
         CVV+XPS5h1vjpcFPA5gZAc/vwndyrpcm7NQxnLWm/u19MHw6viezA2jwmQZyAlTSZBN7
         5rBbQuCJjkkmjTJCxN/vxYnouPSGdmjCjHMgXqRvsBni8CU08FKdyn025HTUB/gCC/Z4
         lRGGG2hRMx47ioO/X5XDetNfeGpOXtcrJrN5kbs1mWK0mNDyNOtzAPfJeX2I/clP6MYo
         XWQgB/ZZrIk4D/DEzU67JzRRGuHYf17S4HZQZO5KvSpk4b1tSsbFq17p3BxdUes5RXhv
         20OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zumOGWEFsMXrLVxFP/CAInFT5wMODXI5T6IEqZrAc5s=;
        b=g7mZSzhYQ9VUl3milPElzsSC80wJEtYu0uf0msvsdxBLm2xhowsgBcfNyTOkWV4uTZ
         fpKBu7vyNdNhdRj3TobvmdxQdYmhQcUn5GACurGniJr9hMI4f+lbruKOdPHfx8BeYcXY
         Cj6hzs11btEfb5oTzd4XMlnm5DRTPe4Svd31QA39fYlYRpsjpL3kEgJ5Uj0/6CnepJIb
         19qKdukwSn3MfWfK/rIgISwEhdpF8XaJek9s6IWhD4dxfkJhVVEh8QcHir9ehCZtkDPk
         hT54Q5cKDdKDOKGPqNirhMrE1xhfZASdWgMKQDvgwb1xWQe+6/3gNuQ8+Na+Ck6IFUB7
         LxkQ==
X-Gm-Message-State: APjAAAVdqDSCoArvM1J21sixf9Lw0/2PPMSaaUL3MCRSxcCBBZ1sCcGn
        dlU4Yvi6INEoR4QkyOE0UAknwg==
X-Google-Smtp-Source: APXvYqzK4hoXUqZoTY/8q8fttCk6XC9aRXzy4CALMXJKLDh4nAY5bHW+CbC9ICloDXtjqqb1rb1RpA==
X-Received: by 2002:a17:902:7049:: with SMTP id h9mr18209897plt.232.1567200933032;
        Fri, 30 Aug 2019 14:35:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 71sm9679113pfw.157.2019.08.30.14.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 14:35:32 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:35:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190830143508.73c30631@cakuba.netronome.com>
In-Reply-To: <a3422ffd-e9f2-af77-a92d-81393a9f4fc7@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
        <20190829113932.5c058194@cakuba.netronome.com>
        <a3422ffd-e9f2-af77-a92d-81393a9f4fc7@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 07:25:54 +0000, Yonghong Song wrote:
> On 8/29/19 11:39 AM, Jakub Kicinski wrote:
> > On Wed, 28 Aug 2019 23:45:02 -0700, Yonghong Song wrote: =20
> >> Brian Vazquez has proposed BPF_MAP_DUMP command to look up more than o=
ne
> >> map entries per syscall.
> >>    https://lore.kernel.org/bpf/CABCgpaU3xxX6CMMxD+1knApivtc2jLBHysDXw-=
0E9bQEL0qC3A@mail.gmail.com/T/#t
> >>
> >> During discussion, we found more use cases can be supported in a simil=
ar
> >> map operation batching framework. For example, batched map lookup and =
delete,
> >> which can be really helpful for bcc.
> >>    https://github.com/iovisor/bcc/blob/master/tools/tcptop.py#L233-L243
> >>    https://github.com/iovisor/bcc/blob/master/tools/slabratetop.py#L12=
9-L138
> >>     =20
> >> Also, in bcc, we have API to delete all entries in a map.
> >>    https://github.com/iovisor/bcc/blob/master/src/cc/api/BPFTable.h#L2=
57-L264
> >>
> >> For map update, batched operations also useful as sometimes applicatio=
ns need
> >> to populate initial maps with more than one entry. For example, the be=
low
> >> example is from kernel/samples/bpf/xdp_redirect_cpu_user.c:
> >>    https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_redir=
ect_cpu_user.c#L543-L550
> >>
> >> This patch addresses all the above use cases. To make uapi stable, it =
also
> >> covers other potential use cases. Four bpf syscall subcommands are int=
roduced:
> >>      BPF_MAP_LOOKUP_BATCH
> >>      BPF_MAP_LOOKUP_AND_DELETE_BATCH
> >>      BPF_MAP_UPDATE_BATCH
> >>      BPF_MAP_DELETE_BATCH
> >>
> >> In userspace, application can iterate through the whole map one batch
> >> as a time, e.g., bpf_map_lookup_batch() in the below:
> >>      p_key =3D NULL;
> >>      p_next_key =3D &key;
> >>      while (true) {
> >>         err =3D bpf_map_lookup_batch(fd, p_key, &p_next_key, keys, val=
ues,
> >>                                    &batch_size, elem_flags, flags);
> >>         if (err) ...
> >>         if (p_next_key) break; // done
> >>         if (!p_key) p_key =3D p_next_key;
> >>      }
> >> Please look at individual patches for details of new syscall subcomman=
ds
> >> and examples of user codes.
> >>
> >> The testing is also done in a qemu VM environment:
> >>        measure_lookup: max_entries 1000000, batch 10, time 342ms
> >>        measure_lookup: max_entries 1000000, batch 1000, time 295ms
> >>        measure_lookup: max_entries 1000000, batch 1000000, time 270ms
> >>        measure_lookup: max_entries 1000000, no batching, time 1346ms
> >>        measure_lookup_delete: max_entries 1000000, batch 10, time 433ms
> >>        measure_lookup_delete: max_entries 1000000, batch 1000, time 36=
3ms
> >>        measure_lookup_delete: max_entries 1000000, batch 1000000, time=
 357ms
> >>        measure_lookup_delete: max_entries 1000000, not batch, time 189=
4ms
> >>        measure_delete: max_entries 1000000, batch, time 220ms
> >>        measure_delete: max_entries 1000000, not batch, time 1289ms
> >> For a 1M entry hash table, batch size of 10 can reduce cpu time
> >> by 70%. Please see patch "tools/bpf: measure map batching perf"
> >> for details of test codes. =20
> >=20
> > Hi Yonghong!
> >=20
> > great to see this, we have been looking at implementing some way to
> > speed up map walks as well.
> >=20
> > The direction we were looking in, after previous discussions [1],
> > however, was to provide a BPF program which can run the logic entirely
> > within the kernel.
> >=20
> > We have a rough PoC on the FW side (we can offload the program which
> > walks the map, which is pretty neat), but the kernel verifier side
> > hasn't really progressed. It will soon.
> >=20
> > The rough idea is that the user space provides two programs, "filter"
> > and "dumper":
> >=20
> > 	bpftool map exec id XYZ filter pinned /some/prog \
> > 				dumper pinned /some/other_prog
> >=20
> > Both programs get this context:
> >=20
> > struct map_op_ctx {
> > 	u64 key;
> > 	u64 value;
> > }
> >=20
> > We need a per-map implementation of the exec side, but roughly maps
> > would do:
> >=20
> > 	LIST_HEAD(deleted);
> >=20
> > 	for entry in map {
> > 		struct map_op_ctx {
> > 			.key	=3D entry->key,
> > 			.value	=3D entry->value,
> > 		};
> >=20
> > 		act =3D BPF_PROG_RUN(filter, &map_op_ctx);
> > 		if (act & ~ACT_BITS)
> > 			return -EINVAL;
> >=20
> > 		if (act & DELETE) {
> > 			map_unlink(entry);
> > 			list_add(entry, &deleted);
> > 		}
> > 		if (act & STOP)
> > 			break;
> > 	}
> >=20
> > 	synchronize_rcu();
> >=20
> > 	for entry in deleted {
> > 		struct map_op_ctx {
> > 			.key	=3D entry->key,
> > 			.value	=3D entry->value,
> > 		};
> > 	=09
> > 		BPF_PROG_RUN(dumper, &map_op_ctx);
> > 		map_free(entry);
> > 	}
> >=20
> > The filter program can't perform any map operations other than lookup,
> > otherwise we won't be able to guarantee that we'll walk the entire map
> > (if the filter program deletes some entries in a unfortunate order). =20
>=20
> Looks like you will provide a new program type and per-map=20
> implementation of above code. My patch set indeed avoided per-map=20
> implementation for all of lookup/delete/get-next-key...

Indeed, the simple batched ops are undeniably lower LoC.

> > If user space just wants a pure dump it can simply load a program which
> > dumps the entries into a perf ring. =20
>=20
> percpu perf ring is not really ideal for user space which simply just
> want to get some key/value pairs back. Some kind of generate non-per-cpu
> ring buffer might be better for such cases.

I don't think it had to be per-cpu, but I may be blissfully ignorant
about the perf ring details :) bpf_perf_event_output() takes flags,
which are effectively selecting the "output CPU", no?

> > I'm bringing this up because that mechanism should cover what is
> > achieved with this patch set and much more. =20
>=20
> The only case it did not cover is batched update. But that may not
> be super critical.

Right, my other concern (which admittedly is slightly pedantic) is the
potential loss of modifications. the lookup_and_delete() operation does
not guarantee that the result returned to user space is the "final"
value. We'd need to wait for a RCU grace period between lookup and dump.
The "map is definitely unused now"/RCU guarantee had came up in the
past.

> Your approach give each element an action choice through another bpf=20
> program. This indeed powerful. My use case is simpler than your use case
> below, hence the implementation.

Agreed, the simplicity is tempting.=20

> > In particular for networking workloads where old flows have to be
> > pruned from the map periodically it's far more efficient to communicate
> > to user space only the flows which timed out (the delete batching from
> > this set won't help at all). =20
>=20
> Maybe LRU map will help in this case? It is designed for such
> use cases.

LRU map would be perfect if it dumped the entry somewhere before it got
reused... Perhaps we need to attach a program to the LRU map that'd get
run when entries get reaped. That'd be cool =F0=9F=A4=94 We could trivially=
 reuse
the "dumper" prog type for this.

> > With a 2M entry map and this patch set we still won't be able to prune
> > once a second on one core.
> >=20
> > [1]
> > https://lore.kernel.org/netdev/20190813130921.10704-4-quentin.monnet@ne=
tronome.com/
