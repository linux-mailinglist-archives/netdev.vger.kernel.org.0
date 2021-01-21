Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1502FEA25
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbhAUMcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbhAUMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 07:32:13 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B46C061757;
        Thu, 21 Jan 2021 04:31:32 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q7so1541853wre.13;
        Thu, 21 Jan 2021 04:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kxt+8VTbL5P82Zla3+Br2VOk1X53L1SllJ3pQxNFV4I=;
        b=HHCSo01bXnQgMpwqL52ROhQATVFNzK8PrPjBZ3XmdcTJkUEsPw44HPITYcVTxxJj+9
         wGLrjT713a8yQayfOYMtZYJQ3fXiJZML7Hs7fD5Gp8kmw9xadkYsmpXoj48Y95oawmev
         okXtIQyatfInPXPVLT00tsZp8AfadaS0G38n/cb7+NHFDkszX4L1W5LD7i7P4jS0FYIX
         g4jPoe970r4n3X+CrFvDcNSvyXpsOhSVvEYlnyylfVnE+2+2CCZQ9JGjaQdAXqRjCxA5
         E7o1YqEElVRcZVcvsFXEz18M5A30YTOfoip2XZNq6b6GdGJPl8tWMY7tygO7ZVTKEV+t
         9jeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kxt+8VTbL5P82Zla3+Br2VOk1X53L1SllJ3pQxNFV4I=;
        b=Yyowda1E13QWjVIVEv5MX4793/av7B1IADzc1l4//nDJac6A6ziwM47j4LOvC4tQhL
         7p0qi14N6Jbu2OwB+HzNei6gh2dPbbSSv0eUMBn3ZcFKw3MY/ht/cKV3WuLrFGQ03/UC
         +G+nAd1Wfizt18ZD5dpG0glpl5Vkg8UoDxcr9No7lr73rVrMwDvM/vJzYYPMmxeeAR46
         fBKDhNbPX6OlDoAK7patAcSJyJcMG6xiMGjMh5iKu1bu21wP4O3hwd4/Ns7Pqy2zzawK
         Fk4QEL+uW4ohaBjeZPA7hKGcqGL3WTFwhlnp9U1Zyydi9SWBbP+6dJ1Tmz7KbiJVjFfY
         GULg==
X-Gm-Message-State: AOAM530Fpiw6XuISS8d+F/Rn1FX+PNAmwBoc/dI6dz6UILkNIcZkZBW5
        xEXjYXnxEb532yVCic9zp3ZZXB0raOrlThfTtPv+qwOtRqw=
X-Google-Smtp-Source: ABdhPJyd/4byrhV0CV690dVapDuTFQXpp9uzj0cm8+leX8+CKUFCTrAtGs5lAGH/Ra34ViNbkic8xXGBbsSRSEOczIo=
X-Received: by 2002:adf:bc92:: with SMTP id g18mr13707364wrh.160.1611232291639;
 Thu, 21 Jan 2021 04:31:31 -0800 (PST)
MIME-Version: 1.0
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-8-bjorn.topel@gmail.com> <CAEf4BzYaV+zA8tEX2xVyA7EeDw1_aQMUQHq8_RHNe=ZfnQWTQw@mail.gmail.com>
In-Reply-To: <CAEf4BzYaV+zA8tEX2xVyA7EeDw1_aQMUQHq8_RHNe=ZfnQWTQw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 21 Jan 2021 13:31:19 +0100
Message-ID: <CAJ+HfNh0VY2=t80g4HmgWqwZ4Fe09+aD1Vk=p11LJeyayxQxTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/8] selftest/bpf: add XDP socket tests for
 bpf_redirect_{xsk, map}()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 at 08:39, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>
> On Tue, Jan 19, 2021 at 7:55 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Add support for externally loaded XDP programs to
> > xdpxceiver/test_xsk.sh, so that bpf_redirect_xsk() and
> > bpf_redirect_map() can be exercised.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  .../selftests/bpf/progs/xdpxceiver_ext1.c     | 15 ++++
> >  .../selftests/bpf/progs/xdpxceiver_ext2.c     |  9 +++
> >  tools/testing/selftests/bpf/test_xsk.sh       | 48 ++++++++++++
> >  tools/testing/selftests/bpf/xdpxceiver.c      | 77 ++++++++++++++++++-
> >  tools/testing/selftests/bpf/xdpxceiver.h      |  2 +
> >  5 files changed, 147 insertions(+), 4 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c
> >
> > diff --git a/tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c b/tool=
s/testing/selftests/bpf/progs/xdpxceiver_ext1.c
> > new file mode 100644
> > index 000000000000..18894040cca6
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c
> > @@ -0,0 +1,15 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_XSKMAP);
> > +       __uint(max_entries, 32);
> > +       __uint(key_size, sizeof(int));
> > +       __uint(value_size, sizeof(int));
> > +} xsks_map SEC(".maps");
> > +
> > +SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>
> hmm.. that's unconventional... please keep SEC() on separate line
>
> > +{
> > +       return bpf_redirect_map(&xsks_map, ctx->rx_queue_index, XDP_DRO=
P);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c b/tool=
s/testing/selftests/bpf/progs/xdpxceiver_ext2.c
> > new file mode 100644
> > index 000000000000..bd239b958c01
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c
> > @@ -0,0 +1,9 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>
> same here
>

Thanks Andrii! I'll make sure to have the SECs on separate lines going forw=
ard!

Bj=C3=B6rn
