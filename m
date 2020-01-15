Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E06013CEE6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgAOV0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:26:37 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41456 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgAOV0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:26:37 -0500
Received: by mail-lf1-f68.google.com with SMTP id m30so13857115lfp.8;
        Wed, 15 Jan 2020 13:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qUcqprxzi4OpusPge9b+ctTKe/+2yNyRvpVornc3kG4=;
        b=B4M6c5R8fsObbWiRlCO3W/CnlZnVJ7BPXJtWE+mmdt7Xprg8HB71TiQp6TfvsUnpm8
         K+vS5+JScBu2VN4Y3fq6BhOaSvzX3cL6BPy7mQWMYPiqosFB+pqGTampHaiPmG4K4O0y
         XZpimzoHQiQYMmfUDWlTcLzxLrINYBA/HM3sZuF1GdYtXOYMEJuV6ST4kHVoeFP8VRY9
         PgAaaILfbaml8wEVokV34dK2Y5pTrIi9burZWoEz75aaqBbwwl/R1mYdfXAPEeSr7rj7
         PNjNygaj58irVDGKqzB7x2qBzuZXlFcaWCdRZ4dEbviUjwtbwWylLAyY+F1WwRu599S+
         k8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qUcqprxzi4OpusPge9b+ctTKe/+2yNyRvpVornc3kG4=;
        b=CZxgH+M3iG0Kvg3L5c+Vg/77HVRXj+pt4eM8Kv2IUzjfSkvcZYKP70FleaxgzWe+TV
         +gxU1urwqhe/NDwnyold7AqjCOgnIQzRHVtuynDXWcQeSEYaGemfXdh3rfF/VaRqsg7j
         kmqRx+P8QSfjGHmS4nSGSsUuDXeVLx1g9kHk4jbyqUCxA7X3bHlkNPB1u6Kn+bAGcXVx
         5VYFbCS8ApLuqbcG8Uh506GTLkOh6MnhwRASzVyaarbew9ovFKOL8097v78ff7Aacmsp
         aZaY6HDAZmsaFierDjfzifi/KbA/lpx2rEvg7GJLg9/zWGd4fli1WGgi49HMbxrcl6YS
         eh7g==
X-Gm-Message-State: APjAAAUKh+nbC3YSDpM/6kH1fZfFm8zcy7HrNjM9iPleqC/AoL/nDj03
        lTdMA7vY+vJXdUhvob5YaT9BBEgCIiYOAo4c2pk=
X-Google-Smtp-Source: APXvYqyts+55ZZ64qWwScTdWkqCl47A2LtZn7PJWlMoF35S4yiuF2vAoLxI2JN3oPRLOhS+10MbHn6GvnRknCQ/4FlU=
X-Received: by 2002:a19:4a12:: with SMTP id x18mr511139lfa.158.1579123595242;
 Wed, 15 Jan 2020 13:26:35 -0800 (PST)
MIME-Version: 1.0
References: <157909410480.47481.11202505690938004673.stgit@xdp-tutorial> <CAEf4BzZmF6TUtGkmcWAP8T5+JH=CEqAvu-q=LntsoYbuZbePgw@mail.gmail.com>
In-Reply-To: <CAEf4BzZmF6TUtGkmcWAP8T5+JH=CEqAvu-q=LntsoYbuZbePgw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jan 2020 13:26:23 -0800
Message-ID: <CAADnVQ+o0JcbrJr9YE0wHgg11DMWfpxsYcexU1SXt-SOzD1E-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 9:04 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 15, 2020 at 5:15 AM Eelco Chaudron <echaudro@redhat.com> wrote:
> >
> > Add a test that will attach a FENTRY and FEXIT program to the XDP test
> > program. It will also verify data from the XDP context on FENTRY and
> > verifies the return code on exit.
> >
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > ---
>
> Looks good, thanks! You are just missing one CHECK() for
> bpf_map_update_elem below, please add it. With that:
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> > v2 -> v3:
> >   - Incorporated review comments from Andrii and Maciej
> >
> > v1 -> v2:
> >   - Changed code to use the BPF skeleton
> >   - Replace static volatile with global variable in eBPF code
> >
> >  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   65 ++++++++++++++++++++
> >  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 ++++++++++++++
> >  2 files changed, 109 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> > new file mode 100644
> > index 000000000000..6b56bdc73ebc
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> > @@ -0,0 +1,65 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include <net/if.h>
> > +#include "test_xdp.skel.h"
> > +#include "test_xdp_bpf2bpf.skel.h"
> > +
> > +void test_xdp_bpf2bpf(void)
> > +{
> > +       __u32 duration = 0, retval, size;
> > +       char buf[128];
> > +       int err, pkt_fd, map_fd;
> > +       struct iphdr *iph = (void *)buf + sizeof(struct ethhdr);
> > +       struct iptnl_info value4 = {.family = AF_INET};
> > +       struct test_xdp *pkt_skel = NULL;
> > +       struct test_xdp_bpf2bpf *ftrace_skel = NULL;
> > +       struct vip key4 = {.protocol = 6, .family = AF_INET};
> > +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
> > +
> > +       /* Load XDP program to introspect */
> > +       pkt_skel = test_xdp__open_and_load();
> > +       if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp skeleton failed\n"))
> > +               return;
> > +
> > +       pkt_fd = bpf_program__fd(pkt_skel->progs._xdp_tx_iptunnel);
> > +
> > +       map_fd = bpf_map__fd(pkt_skel->maps.vip2tnl);
> > +       bpf_map_update_elem(map_fd, &key4, &value4, 0);
>
> CHECK()? Sorry, didn't spot first time.

There is no such check in few other places in selftests and
I don't think it's really necessary here.
If we adjust them let's fix them all.

Applied to bpf-next. Thanks.
