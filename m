Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3F312AF33
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 23:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLZWZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 17:25:21 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43546 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZWZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 17:25:21 -0500
Received: by mail-qt1-f196.google.com with SMTP id d18so20566625qtj.10;
        Thu, 26 Dec 2019 14:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xa5v85pBrZMDO9hZDJPjYJTLCZ9KZmSPA87n8YgrhU4=;
        b=uV1DBR4U5wvxE6kLChdDj5vrP67BloZAi0zjTXcvVB6Xw8Sb1ShmIXez9gCIpGL4iq
         h1ZWlOsxVO0xKizg5nKLCT9bIvsI/F+MAufQ7EgasNFEL4pG4vt3XVHR9VKraM8XplEy
         uBIwpa4XhYmxvIU/ebzbiFJAC5lny5BpSIWlHt2Gf0uX8KpqTJrT2ba3BdGNS3Nlg3r0
         9EzF405iuKb3ORdxuMJ3zKrNBwOQLbmchIvbRmy4+VXVG6WAHv54PHdVPUA4maUcdFSu
         bOPqlU9BjQqFJVlKT/tIxvt3MprmRuJ+oBDQDXEDWPXXOckyHfXjbsBiXCD7b5OMFhw4
         Y3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xa5v85pBrZMDO9hZDJPjYJTLCZ9KZmSPA87n8YgrhU4=;
        b=sulNbcAO90fUZPhlsn7aGVMSGHAEeu+anC7o4UkzVtYbiIWE1QJlv2mcwT+tws5eAu
         wfi4So4Fkeplq/rTeW3UmTw7riSt7cr4FKEvCg5vwhD7C008rt/iWCdkB42fF6WRQ1CU
         adygtDKLyLw1TITVCRrxQ4x5V1uGA77u4F9CcpG293HmVq3Hs3LGPfYnTPqlVYaeS7Cw
         pjgtb5tQ2wO0O+k3wSRRtUfP2ZmMBT8kLWlR+eobvrfl8TpExowtykELwNpK2MyFvRnk
         VRLSXH/Ax3YaFpwNtKK42zE8l819+f9J5xQjs+oA3JRlBxtTDPVr4V+usXkI0hz7ilTk
         qVOQ==
X-Gm-Message-State: APjAAAWHQPXNpXOaSXIQMVEo4oLJ6WgYEpCzJqbO0p+ILmFOXYqCizMo
        fp6OGGm2l7gog3x7MbJFxbQLeb49Z4FTFYnpE1s=
X-Google-Smtp-Source: APXvYqwzhF7ihTtTblckmmv2DZNEy+sg1ltttDa5GpYdumulcOJk/TvmDWpQf3at7qlERP37tUx1MTNc3BOEpyo1tMQ=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr34455908qtq.93.1577399119767;
 Thu, 26 Dec 2019 14:25:19 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
 <20191224013140.ibn33unj77mtbkne@kafai-mbp> <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
 <20191224165003.oi4kvxad6mlsg5kw@kafai-mbp> <CAEf4BzYA=xS7pHPqGxK4LsRHpxN=Y4dLcbG8WNMqGhKpauh7gQ@mail.gmail.com>
 <20191226202512.abhyhdtetv46z5sd@kafai-mbp> <CAEf4BzagEe4sbUfz6=Y6MHCsAAUAVe1GKi_XJUNu8xpHdd_mAQ@mail.gmail.com>
 <20191226222007.5m4kra2lqa5igpfm@kafai-mbp>
In-Reply-To: <20191226222007.5m4kra2lqa5igpfm@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Dec 2019 14:25:08 -0800
Message-ID: <CAEf4BzaXwQ-DHzt31_oz+xZDwjV-ZG77HR+Xr6CYicv_ceRUKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 2:20 PM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Dec 26, 2019 at 12:48:09PM -0800, Andrii Nakryiko wrote:
> > On Thu, Dec 26, 2019 at 12:25 PM Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Thu, Dec 26, 2019 at 11:02:26AM -0800, Andrii Nakryiko wrote:
> > > > On Tue, Dec 24, 2019 at 8:50 AM Martin Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Mon, Dec 23, 2019 at 11:01:55PM -0800, Andrii Nakryiko wrote:
> > > > > > On Mon, Dec 23, 2019 at 5:31 PM Martin Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote:
> > > > > > > > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > > >
> > > > > > > > > This patch adds a bpf_dctcp example.  It currently does not do
> > > > > > > > > no-ECN fallback but the same could be done through the cgrp2-bpf.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > > ---
> > > > > > > > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++++++
> > > > > > > > >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 +++++++++++++++++
> > > > > > > > >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++++
> > > > > > > > >  3 files changed, 656 insertions(+)
> > > > > > > > >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > > > > > > > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > > > > > > > >
> > > > > > > > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > > > > new file mode 100644
> > > > > > > > > index 000000000000..7ba8c1b4157a
> > > > > > > > > --- /dev/null
> > > > > > > > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > > > > @@ -0,0 +1,228 @@
> > > > > > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > > > > > +#ifndef __BPF_TCP_HELPERS_H
> > > > > > > > > +#define __BPF_TCP_HELPERS_H
> > > > > > > > > +
> > > > > > > > > +#include <stdbool.h>
> > > > > > > > > +#include <linux/types.h>
> > > > > > > > > +#include <bpf_helpers.h>
> > > > > > > > > +#include <bpf_core_read.h>
> > > > > > > > > +#include "bpf_trace_helpers.h"
> > > > > > > > > +
> > > > > > > > > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > >
> > > > > > > > Should we try to put those BPF programs into some section that would
> > > > > > > > indicate they are used with struct opts? libbpf doesn't use or enforce
> > > > > > > > that (even though it could to derive and enforce that they are
> > > > > > > > STRUCT_OPS programs). So something like
> > > > > > > > SEC("struct_ops/<ideally-operation-name-here>"). I think having this
> > > > > > > > convention is very useful for consistency and to do a quick ELF dump
> > > > > > > > and see what is where. WDYT?
> > > > > > > I did not use it here because I don't want any misperception that it is
> > > > > > > a required convention by libbpf.
> > > > > > >
> > > > > > > Sure, I can prefix it here and comment that it is just a
> > > > > > > convention but not a libbpf's requirement.
> > > > > >
> > > > > > Well, we can actually make it a requirement of sorts. Currently your
> > > > > > code expects that BPF program's type is UNSPEC and then it sets it to
> > > > > > STRUCT_OPS. Alternatively we can say that any BPF program in
> > > > > > SEC("struct_ops/<whatever>") will be automatically assigned
> > > > > > STRUCT_OPTS BPF program type (which is done generically in
> > > > > > bpf_object__open()), and then as .struct_ops section is parsed, all
> > > > > > those programs will be "assembled" by the code you added into a
> > > > > > struct_ops map.
> > > > > Setting BPF_PROG_TYPE_STRUCT_OPS can be done automatically at open
> > > > > phase (during collect_reloc time).  I will make this change.
> > > > >
> > > >
> > > > Can you please extend exiting logic in __bpf_object__open() to do
> > > > this? See how libbpf_prog_type_by_name() is used for that.
> > > Does it have to call libbpf_prog_type_by_name() if everything
> > > has already been decided by the earlier
> > > bpf_object__collect_struct_ops_map_reloc()?
> >
> > We can certainly change the logic to omit guessing program type if
> > it's already set to something else than UNSPEC.
> >
> > But all I'm asking is that instead of using #fname"_sec" section name,
> > is to use "struct_ops/"#fname, because it's consistent with all other
> > program types. If you do that, then you don't have to do anything
> > extra (well, add single entry to section_defs, of course), it will
> > just work as is.
> Re: adding "struct_ops/" to section_defs,
> Sure. as long as SEC(".struct_ops") can use prog that
> libbpf_prog_type_by_name() concluded it is either -ESRCH or
> STRUCT_OPS.
>
> It is not the only change though.  Other changes are still
> needed in collect_reloc (e.g. check prog type mismatch).
> They won't be much though.

sounds good, thanks!
