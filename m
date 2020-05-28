Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1241E5811
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgE1HBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgE1HBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:01:52 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25137C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:01:52 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 205so2194205qkg.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JHDw5aL1eTxUzfhSKo+/aoW/O8V/V561gmVbQAV8BH4=;
        b=nHHPCfX2oQ8O0et+jwcL/8lrmCSquLi4cC8QFrwyQTl2cyT2iK13WXdDNY694UBxGG
         MTdhf5DTJiDHPx3IVLQDjYRMJniLXzOpcsryVlb/QhmXKzZgXBQhQA4Ekg/H4o/4rHdT
         h7npUdTGRCrbP/twx7N6vBiUfvXo6i04IZpSyjEUiU3+OTTqbVnte6x45Bzks6Oq2nwB
         HUIlcDpS6M37uHojYA5+MgOs+o9qWvH+NWm8Itm149c4aHMfrwQh3NQN+v1EZxfNsTVU
         VkCf+3lCFiJo5FtcOdpb6FK9uYzBxsgPrC41zFhnvSel7ZIGG8z4Jsu6IcgyGNwA+TVK
         xRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JHDw5aL1eTxUzfhSKo+/aoW/O8V/V561gmVbQAV8BH4=;
        b=rwlmGkdd1Y7EZyDgYPKDwMlG0sEAC92u+IbKuM8LsXfttG08TDmUbTVoDS0tkSjlN2
         5VGomY8b7d362y2xFtA24jahoTjTLyQbb2dNZt/tl1cM8aQxTiTmYv/DgQ/aylZqzb37
         U5eBJyI11+E7RUHr8BSvVrl6drqMqZuxr/FsD4mbpC1bpB5L+3DpXhQIwt6vNyqXFbiT
         l09ZuoDx0+pGtBJL4v2DrgkxhlTCpur5h79CXLTFwp0GApNmP70CYXL6ddwk4bJjRrBk
         VPK+IsMZT/u/c8uRJ/3K3m2zACzj3Xdx+pHsrlwf1dykbr1C83ucgfENvWNbka3GVIIs
         69zA==
X-Gm-Message-State: AOAM530LKscO6Xm9+hSOAVlodAAEfrVdARFx9pb4zTueYFZr7TisB0Yc
        mnEYNt4tjKUDzTorPLtireU2qPiXLuCghtXdTV8=
X-Google-Smtp-Source: ABdhPJzUSB+2DpAfEwT5iSQomg67bKLfFhPtKAWKmr7jhC/ZVlpo1LUm3sUfwv5blWucNP23ptOpaSXKYhrRg2I1j3o=
X-Received: by 2002:a05:620a:247:: with SMTP id q7mr1493119qkn.36.1590649311337;
 Thu, 28 May 2020 00:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200528001423.58575-1-dsahern@kernel.org> <20200528001423.58575-3-dsahern@kernel.org>
In-Reply-To: <20200528001423.58575-3-dsahern@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 00:01:40 -0700
Message-ID: <CAEf4BzYZSPdGH+RXp+kHfWnGGLRuiP=ho9oMsSf7RsYWyeNk0g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/5] bpf: Add support to attach bpf program to
 a devmap entry
To:     David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 5:17 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Add BPF_XDP_DEVMAP attach type for use with programs associated with a
> DEVMAP entry.
>
> Allow DEVMAPs to associate a program with a device entry by adding
> a bpf_prog_fd to 'struct devmap_val'. Values read show the program
> id, so the fd and id are a union.
>
> The program associated with the fd must have type XDP with expected
> attach type BPF_XDP_DEVMAP. When a program is associated with a device
> index, the program is run on an XDP_REDIRECT and before the buffer is
> added to the per-cpu queue. At this point rxq data is still valid; the
> next patch adds tx device information allowing the prorgam to see both
> ingress and egress device indices.
>
> XDP generic is skb based and XDP programs do not work with skb's. Block
> the use case by walking maps used by a program that is to be attached
> via xdpgeneric and fail if any of them are DEVMAP / DEVMAP_HASH with
>  > 4-byte values.
>
> Block attach of BPF_XDP_DEVMAP programs to devices.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---

Please cc bpf@vger.kernel.org in the future for patches related to BPF
in general.

>  include/linux/bpf.h            |  5 +++
>  include/uapi/linux/bpf.h       |  5 +++
>  kernel/bpf/devmap.c            | 79 +++++++++++++++++++++++++++++++++-
>  net/core/dev.c                 | 18 ++++++++
>  tools/include/uapi/linux/bpf.h |  5 +++
>  5 files changed, 110 insertions(+), 2 deletions(-)
>

[...]

>
> +static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
> +                                        struct xdp_buff *xdp,
> +                                        struct bpf_prog *xdp_prog)
> +{
> +       u32 act;
> +
> +       act = bpf_prog_run_xdp(xdp_prog, xdp);
> +       switch (act) {
> +       case XDP_DROP:
> +               fallthrough;

nit: I don't think fallthrough is necessary for cases like:

case XDP_DROP:
case XDP_PASS:
    /* do something */

> +       case XDP_PASS:
> +               break;
> +       default:
> +               bpf_warn_invalid_xdp_action(act);
> +               fallthrough;
> +       case XDP_ABORTED:
> +               trace_xdp_exception(dev, xdp_prog, act);
> +               act = XDP_DROP;
> +               break;
> +       }
> +
> +       if (act == XDP_DROP) {
> +               xdp_return_buff(xdp);
> +               xdp = NULL;

hm.. if you move XDP_DROP case to after XDP_ABORTED and do fallthrough
from XDP_ABORTED, you won't even need to override act and it will just
handle all the cases, no?

switch (act) {
case XDP_PASS:
    return xdp;
default:
    bpf_warn_invalid_xdp_action(act);
    fallthrough;
case XDP_ABORTED:
    trace_xdp_exception(dev, xdp_prog, act);
    fallthrough;
case XDP_DROP:
    xdp_return_buff(xdp);
    return NULL;
}

Wouldn't this be simpler?


> +       }
> +
> +       return xdp;
> +}
> +

[...]
