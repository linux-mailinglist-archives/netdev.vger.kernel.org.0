Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8B52E0E82
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 19:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgLVS7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 13:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgLVS7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 13:59:04 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AE7C0613D6;
        Tue, 22 Dec 2020 10:58:23 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id j17so12544167ybt.9;
        Tue, 22 Dec 2020 10:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QMkS+o0BrnS2omLkHBMtuZru/D6pZxW4V6aT1vOEC/Q=;
        b=mDJKAF2goGKPClo6KDzwJDAZxjqYp0N0pfs8gOYs9qX3Dj7Ecw7o++4yUPrYyZQA30
         0BnrhTPiQ9NEvzcmrAJy5Tt8UGeFkky8JVhQr8bJY1txom+a1RDpLiEgeOUQfF5c+syY
         kiTZ6PIDzmzZj1rQGstu7d1H+c0hWiPc1sS7wTwOop13MV6tIzc/ie54cvvBeaSNhYzk
         N23zQKSD+u0UcuTOKVZB1FXUgKiTIUuf3v3pBlkZrYjMgTmjXMzmXUT7K+wtA3wugDGk
         7lWB5Ise4OIKq8hsqgl99NAAhjaD8Hb3+WGC4SFLRXjZi0l88OeUKRStlG/CN1fsp4y9
         feuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QMkS+o0BrnS2omLkHBMtuZru/D6pZxW4V6aT1vOEC/Q=;
        b=oOBbvcjovvjXxXZcLesmrWNu4NbwvadEcTEIs8hSssOCRJtY1vN+oGZxwTFnil1QSn
         dEQMUg/j5TMC9T/EqouPosbVWsLFtTWprd26ub5CKw+yve/PJizhY7Iju0fxUBx48n+8
         +SurOX8EzOnVH9/oalU2yHYNfgseRbT7LF9Zdum2zRoclEVDmozwUTVqSuWklmSksRh5
         0fmY0MEwGgiNlLRIOl+s7bWINLcQX3EDA0nj9+D3xY4NJ9IQ1bwxTQXxjAQcKiouf0h9
         BPONKYcwf911nMWmbo2+Gavp40DPKFa1Z7a4/SfnoSTMl/xGPWgSPDCt4ZvSQlSEcCl8
         b+rg==
X-Gm-Message-State: AOAM530hErFPMEJN3nR89V4ruh6MLFtVbMG3+aNQ+hTGu9GcZ4pQAIL1
        gmOpj1iYjhMmPSaSC4qUqtvAb7R7SL+Fo/1q0tBEpdXG7WM3IA==
X-Google-Smtp-Source: ABdhPJybCNNeMsEsQ6Qf2JcrpopmLRX9CKQgerF2IcJyX+Bcu1oE8595m4rnFtpHdTNQzFwYYauCqYtI/48GI2wuuQU=
X-Received: by 2002:a25:4107:: with SMTP id o7mr31103591yba.459.1608663503202;
 Tue, 22 Dec 2020 10:58:23 -0800 (PST)
MIME-Version: 1.0
References: <160865400291.3593456.17026136957003358677.stgit@firesoul> <160865406506.3593456.8475116968286355613.stgit@firesoul>
In-Reply-To: <160865406506.3593456.8475116968286355613.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Dec 2020 10:58:12 -0800
Message-ID: <CAEf4Bzb5NdQbZMPKAY8xKqVXy4DAWPhszW1pF4Afo==GQEoT0g@mail.gmail.com>
Subject: Re: [PATCH bpf-next V10 7/7] bpf/selftests: tests using bpf_check_mtu BPF-helper
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 8:23 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> it can be used from both XDP and TC.
>
> V10:
>  - Remove errno non-zero test in CHECK_ATTR()
>  - Addresse comments from Andrii Nakryiko
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Looks good, few minor nits below, feel free to address if you end up
with another revision.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/prog_tests/check_mtu.c |  218 ++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/test_check_mtu.c |  199 ++++++++++++++++++
>  2 files changed, 417 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> new file mode 100644
> index 000000000000..63f01c9e08d8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> @@ -0,0 +1,218 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Jesper Dangaard Brouer */
> +
> +#include <linux/if_link.h> /* before test_progs.h, avoid bpf_util.h redefines */
> +
> +#include <test_progs.h>
> +#include "test_check_mtu.skel.h"
> +#include <network_helpers.h>

bit: test_progs and network_helpers should be included with "", not <>

> +
> +#include <stdlib.h>
> +#include <inttypes.h>
> +
> +#define IFINDEX_LO 1
> +
> +static __u32 duration; /* Hint: needed for CHECK macro */
> +
> +static int read_mtu_device_lo(void)
> +{
> +       const char *filename = "/sys/class/net/lo/mtu";
> +       char buf[11] = {};
> +       int value;
> +       int fd;
> +
> +       fd = open(filename, 0, O_RDONLY);
> +       if (fd == -1)
> +               return -1;
> +
> +       if (read(fd, buf, sizeof(buf)) == -1) {
> +               close(fd);
> +               return -2;
> +       }
> +       close(fd);

nit: imo, simpler to write:

err = read(...);
close(fd);
if (err == -1)
  return -2;

This way you don't need to close twice. But it's very minor.


> +
> +       value = strtoimax(buf, NULL, 10);
> +       if (errno == ERANGE)
> +               return -3;
> +
> +       return value;
> +}
> +

[...]

> +       CHECK(link_info.type != BPF_LINK_TYPE_XDP, "link_type",
> +             "got %u != exp %u\n", link_info.type, BPF_LINK_TYPE_XDP);
> +       CHECK(link_info.xdp.ifindex != IFINDEX_LO, "link_ifindex",
> +             "got %u != exp %u\n", link_info.xdp.ifindex, IFINDEX_LO);
> +
> +       err = bpf_link__detach(link);
> +       CHECK(err, "link_detach", "failed %d\n", err);
> +

unless you explicitly want to test this force-detach, destroying the
link (through destroying skeleton) would detach the program just fine.


> +out:
> +       test_check_mtu__destroy(skel);
> +}
> +

[...]

> +
> +SEC("xdp")
> +int xdp_exceed_mtu(struct xdp_md *ctx)
> +{
> +       void *data_end = (void *)(long)ctx->data_end;
> +       void *data = (void *)(long)ctx->data;
> +       __u32 ifindex = GLOBAL_USER_IFINDEX;
> +       __u32 data_len = data_end - data;
> +       int retval = XDP_ABORTED; /* Fail */
> +       __u32 mtu_len = 0;
> +

nit: unnecessary empty line inside variable declaration block

> +       int delta;
> +       int err;
> +
> +       /* Exceed MTU with 1 via delta adjust */
> +       delta = GLOBAL_USER_MTU - (data_len - ETH_HLEN) + 1;
> +
> +       err = bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0);
> +       if (err) {
> +               retval = XDP_PASS; /* Success in exceeding MTU check */
> +               if (err != BPF_MTU_CHK_RET_FRAG_NEEDED)
> +                       retval = XDP_DROP;
> +       }
> +
> +       global_bpf_mtu_xdp = mtu_len;
> +       return retval;
> +}
> +

[...]
