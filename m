Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A286C54BB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjCVTRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCVTRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:17:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859D060A9D;
        Wed, 22 Mar 2023 12:17:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ew6so14260653edb.7;
        Wed, 22 Mar 2023 12:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679512637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zq7Jl3TGbJwfMRCJgFwbgsM8JVMZ+vr7U3sGfe6jsB8=;
        b=IwEJFjUWISTejU0FVnsTrdJHJe6HwK372fdhRbbSA9UYXwB1Bgz77aw/8yVgn2DQ5A
         F6rXGGxKi86YjpcmMYtnebKufUdSIaIVUyZnxArAh6CHPOADa+yUlffw++XpSAxd4E9E
         GVFlY677GTCphhkdyh+uvKjffRznl21AJRM66o5tJprFyzO97+F2/V//Cxd6laqEM7+k
         cFEK/GUJiyE56D6rZXx5wU9FDGyfN4S2mYri3eGl+FIH/Zk7g6J+bu7IyiEQ+NhFNqpY
         TuKUzhtcY6Rbq7f2ym1cuHMu9A2WrMOyAT767LCavF7x9ryAAWlWvPJrF9pwlyAmwrHz
         0ekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679512637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zq7Jl3TGbJwfMRCJgFwbgsM8JVMZ+vr7U3sGfe6jsB8=;
        b=lGNt1a1FGB4Lg6zcK/6KZUoNv0SmzFYU6u7AC/AaMlEqXubPOoY/HkIstxEzLG58vk
         MPXlkutyja6jzeXsyvJrlHdxFKKhJuQUioAPTG/xzr7UIEcYlZ4gBxhnRjL2Ts3gFsKi
         pu+jg8f2k8hlxYhHp8dbB1hXwjjQYq7JZ1wppuJaL8P5a7I6hdHvwWE/dmb6Dbm1P4P4
         TchKtDv+ygQscONdVid1BaV7VJ1zTsXZSa9+V5fPCFHvksZJtvcDehlH2+gc5BzDsO7L
         81JDzFoZMoTzNIaQSfTwOB4EZNMxNuXMSCGeGcEjKhoeCbt95khNcaH9lVYSdsxywDck
         KaBg==
X-Gm-Message-State: AO0yUKXgQNNncqH4L9vp33jpOua8zuUFKkBeNEqDtqP4KA/YSvLQ0SLU
        gAuRq0U9WhUMIn3ai0d50PAK6f17hM9kaVeNVDk=
X-Google-Smtp-Source: AK7set9552GdKOTmZ+tiPEVlGLee/ERxdsxUe3D7HddBqrBIhldF7UjpKsvlmjxDOFDXG2JkBtFdTg1eCUR1gkUJ0ys=
X-Received: by 2002:a50:9995:0:b0:4fa:3c0b:74b with SMTP id
 m21-20020a509995000000b004fa3c0b074bmr4126749edb.3.1679512636925; Wed, 22 Mar
 2023 12:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com> <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
 <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
In-Reply-To: <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Mar 2023 12:17:05 -0700
Message-ID: <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 12:00=E2=80=AFPM Stanislav Fomichev <sdf@google.com=
> wrote:
>
> On Wed, Mar 22, 2023 at 9:07=E2=80=AFAM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> > >
> > >
> > >
> > > On 21/03/2023 19.47, Stanislav Fomichev wrote:
> > > > On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
> > > > <brouer@redhat.com> wrote:
> > > >>
> > > >> When driver developers add XDP-hints kfuncs for RX hash it is
> > > >> practical to print the return code in bpf_printk trace pipe log.
> > > >>
> > > >> Print hash value as a hex value, both AF_XDP userspace and bpf_pro=
g,
> > > >> as this makes it easier to spot poor quality hashes.
> > > >>
> > > >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > >> ---
> > > >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++=
---
> > > >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
> > > >>   2 files changed, 10 insertions(+), 4 deletions(-)
> > > >>
> > > >> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b=
/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > >> index 40c17adbf483..ce07010e4d48 100644
> > > >> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > >> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > >> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> > > >>                  meta->rx_timestamp =3D 0; /* Used by AF_XDP as no=
t avail signal */
> > > >>          }
> > > >>
> > > >> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> > > >> -               bpf_printk("populated rx_hash with %u", meta->rx_h=
ash);
> > > >> -       else
> > > >> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> > > >> +       if (ret >=3D 0) {
> > > >> +               bpf_printk("populated rx_hash with 0x%08X", meta->=
rx_hash);
> > > >> +       } else {
> > > >> +               bpf_printk("rx_hash not-avail errno:%d", ret);
> > > >>                  meta->rx_hash =3D 0; /* Used by AF_XDP as not ava=
il signal */
> > > >> +       }
> > > >>
> > > >>          return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PA=
SS);
> > > >>   }
> > > >> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools=
/testing/selftests/bpf/xdp_hw_metadata.c
> > > >> index 400bfe19abfe..f3ec07ccdc95 100644
> > > >> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > >> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > >> @@ -3,6 +3,9 @@
> > > >>   /* Reference program for verifying XDP metadata on real HW. Func=
tional test
> > > >>    * only, doesn't test the performance.
> > > >>    *
> > > >> + * BPF-prog bpf_printk info outout can be access via
> > > >> + * /sys/kernel/debug/tracing/trace_pipe
> > > >
> > > > s/outout/output/
> > > >
> > >
> > > Fixed in V3
> > >
> > > > But let's maybe drop it? If you want to make it more usable, let's
> > > > have a separate patch to enable tracing and periodically dump it to
> > > > the console instead (as previously discussed).
> > >
> > > Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardless o=
f
> > > setting in
> > > /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable
> > >
> > > We likely need a followup patch that adds a BPF config switch that ca=
n
> > > disable bpf_printk calls, because this adds overhead and thus affects
> > > the timestamps.
> >
> > No. This is by design.
> > Do not use bpf_printk* in production.
>
> But that's not for the production? xdp_hw_metadata is a small tool to
> verify that the metadata being dumped is correct (during the
> development).
> We have a proper (less verbose) selftest in
> {progs,prog_tests}/xdp_metadata.c (over veth).
> This xdp_hw_metadata was supposed to be used for running it against
> the real hardware, so having as much debugging at hand as possible
> seems helpful? (at least it was helpful to me when playing with mlx4)

The only use of bpf_printk is for debugging of bpf progs themselves.
It should not be used in any tool.
