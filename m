Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D616F2FE431
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbhAUHkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 02:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbhAUHkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:40:16 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F22C061575;
        Wed, 20 Jan 2021 23:39:36 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id x78so1140512ybe.11;
        Wed, 20 Jan 2021 23:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8/Qs+LIYozRQBaZzt7plrZI8EEeLdzE+oyXQd9hZHQA=;
        b=vGcE306V5zNAqKhlLk64OTHHpdU/koNggfFasdYXILHtg7/C/1Tbjpmr2jMOEg0Nzy
         Yu37YSMkfcNr645mv/TNpJt0hM3Hpw8hz/CussyzRk2tD58cjSc/ypZDEtW6SmlTZnSw
         T3TTCp9oSkV2G/58hgWeQHYu58RwZms2aIbrxqB93yP7AEsEyRcNegBI24OAU71sI9Dy
         Xz/d7rKQKjb8VBAPYdFFJdE/u0KEulKf5sb3Q+uFV3ZCoUQqt3P5GqDNd2m1h052YLDA
         QXZy8pQNWiCBiO3kSPnHt+svMDfmV8Q/YzwNHxnFnaEm40Xl1Mly6REjCZMSYm26Jt9K
         Hd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8/Qs+LIYozRQBaZzt7plrZI8EEeLdzE+oyXQd9hZHQA=;
        b=l91gXYN3sqfxxFdBszO+oVBFwwtPKB1Mm7uJSxBxoje/HI1kXRycYJaMLGZ/jEm+n3
         MNDkDRcNPVwAF7SGX1YaCdaUDrtiA2GR6cuGcptW/dKBBreqy21vEfjy8egJbVnnHj78
         hkYsNIj/V98HwtqJWBGuLO0pTMYZnDJ7i8hM+DpvLopH1IS+Xeyu218jh6EbqQrWNAZP
         +o3XyYnfnErHW9xt00sXJGpyOv2VKcJ7I16MWs/oVT8SGO5Kycavq7gq3KLj1a2geK3E
         qopBozyr4CgN0ufUMkN9g+TQfWnBFeyArq3bKayNYYKdwUYC5ITvqRk/x/MRGNMYGTSE
         /A2Q==
X-Gm-Message-State: AOAM530cH9D+/zkok/S75pUunhuHasLbDV3mR/kcOoUX9MvsPkESAi8s
        /B7kssvQvQ7M6GCmkkc0CRF1ONDE4WuVjAOoozrm6fJuv6M=
X-Google-Smtp-Source: ABdhPJzw6UlLjC/wQFMrQ4yJ8ofwrZkM/W9C4rvFWoi7V44Wji1Mj2zUyGqVNOfq86AIRCRAYxumqXX0StoWGdYXbiI=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr18707086ybg.27.1611214775780;
 Wed, 20 Jan 2021 23:39:35 -0800 (PST)
MIME-Version: 1.0
References: <20210119155013.154808-1-bjorn.topel@gmail.com> <20210119155013.154808-8-bjorn.topel@gmail.com>
In-Reply-To: <20210119155013.154808-8-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Jan 2021 23:39:25 -0800
Message-ID: <CAEf4BzYaV+zA8tEX2xVyA7EeDw1_aQMUQHq8_RHNe=ZfnQWTQw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/8] selftest/bpf: add XDP socket tests for
 bpf_redirect_{xsk, map}()
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
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
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 7:55 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Add support for externally loaded XDP programs to
> xdpxceiver/test_xsk.sh, so that bpf_redirect_xsk() and
> bpf_redirect_map() can be exercised.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  .../selftests/bpf/progs/xdpxceiver_ext1.c     | 15 ++++
>  .../selftests/bpf/progs/xdpxceiver_ext2.c     |  9 +++
>  tools/testing/selftests/bpf/test_xsk.sh       | 48 ++++++++++++
>  tools/testing/selftests/bpf/xdpxceiver.c      | 77 ++++++++++++++++++-
>  tools/testing/selftests/bpf/xdpxceiver.h      |  2 +
>  5 files changed, 147 insertions(+), 4 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c
>
> diff --git a/tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c b/tools/=
testing/selftests/bpf/progs/xdpxceiver_ext1.c
> new file mode 100644
> index 000000000000..18894040cca6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c
> @@ -0,0 +1,15 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_XSKMAP);
> +       __uint(max_entries, 32);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
> +} xsks_map SEC(".maps");
> +
> +SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)

hmm.. that's unconventional... please keep SEC() on separate line

> +{
> +       return bpf_redirect_map(&xsks_map, ctx->rx_queue_index, XDP_DROP)=
;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c b/tools/=
testing/selftests/bpf/progs/xdpxceiver_ext2.c
> new file mode 100644
> index 000000000000..bd239b958c01
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)

same here

> +{
> +       return bpf_redirect_xsk(ctx, XDP_DROP);
> +}
> +

[...]
