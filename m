Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D39C6C5476
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjCVTCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjCVTCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:02:05 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAB85D268
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:00:48 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so24503183pjv.5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679511640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPw82u/EjYlcJdkmo1criCAcJTkt8OjlZmqtDmpev+Y=;
        b=LXpsDxg24mECGDgep6nvpz2DEltVZE0ISwM+WcIPJ1q5Rt+7eJiqvPkEvWORKM+hWO
         H7M+g/sPLdKmHcczC65vIQgiqlJaFcO9Ns5RD+YVhU2NC3D2MjGrbaHhA24Skc/MlPbo
         s18xo6tkWmD5vHFzUHp9rlB42XKRsUKJb4W1RruD3v9UeUOw2PcMamLlp0AKaY446uO0
         mJ3xqDD2aiE5AvpQU8DznF15fBXA+LKX2wthnnFbSkOJOlcb11MWEMxfLN1bf/4EO3D/
         G6EZoNpGMk9jbBlP3DXZ8ifsZQeTgHOdUTwXO9GArz1LJBxJOMNq0S2eflA/nby03cY/
         tRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679511640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPw82u/EjYlcJdkmo1criCAcJTkt8OjlZmqtDmpev+Y=;
        b=5+t6iE5w0aU5nULWpnxKAiBlHkdbUI58VTd0q7Mv4XnLqA6sAOmtPXq5GABcIhjoEZ
         kj3dlDlJ4RU68zXiRXljpHDuDsZMjcnTrG/kmEwnLowpRnmwiHSBfhzwzGx8rLFOceZF
         Jz9Z8txcxrkLI7/tW2AkhHCDMMeS63snjhaL4DRyCsJkjZZGm/0kIiwpv2V+6i/fE+dA
         wxualQa6SjSp66wEZyPdAm6XR7q9gWsLdLp0quQfmEa3CV4a4Dbfca1OoE8IOmIkF4m7
         t/Eafjt47eTpafvfmUguKnNDZenSF3wN2k4zESfmbprwZSfkind/hxj2AAVQAZDXGZrA
         pEYw==
X-Gm-Message-State: AO0yUKX8NjbISC4u13ZC6UzKqrLZpuRRUUtopH2j1lY4xMHtXJVA6SiN
        sn/0r17h/+yN/0WNxQOXa6OBogxns77UXnumNB5Xuw==
X-Google-Smtp-Source: AK7set+hMDqiJnRnl+PIVoRNKWPVSBo6QIL0bDWogooZje/Gc+I/wzyla2g7mCUY9FBrk2Dbxr75BPu01CHVYNjlXZs=
X-Received: by 2002:a17:90a:f28d:b0:23d:424d:400f with SMTP id
 fs13-20020a17090af28d00b0023d424d400fmr1429526pjb.9.1679511639636; Wed, 22
 Mar 2023 12:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com> <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
In-Reply-To: <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 22 Mar 2023 12:00:28 -0700
Message-ID: <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 9:07=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
> >
> >
> >
> > On 21/03/2023 19.47, Stanislav Fomichev wrote:
> > > On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
> > > <brouer@redhat.com> wrote:
> > >>
> > >> When driver developers add XDP-hints kfuncs for RX hash it is
> > >> practical to print the return code in bpf_printk trace pipe log.
> > >>
> > >> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
> > >> as this makes it easier to spot poor quality hashes.
> > >>
> > >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > >> ---
> > >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++--=
-
> > >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
> > >>   2 files changed, 10 insertions(+), 4 deletions(-)
> > >>
> > >> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/t=
ools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > >> index 40c17adbf483..ce07010e4d48 100644
> > >> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > >> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > >> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> > >>                  meta->rx_timestamp =3D 0; /* Used by AF_XDP as not =
avail signal */
> > >>          }
> > >>
> > >> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> > >> -               bpf_printk("populated rx_hash with %u", meta->rx_has=
h);
> > >> -       else
> > >> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> > >> +       if (ret >=3D 0) {
> > >> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx=
_hash);
> > >> +       } else {
> > >> +               bpf_printk("rx_hash not-avail errno:%d", ret);
> > >>                  meta->rx_hash =3D 0; /* Used by AF_XDP as not avail=
 signal */
> > >> +       }
> > >>
> > >>          return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS=
);
> > >>   }
> > >> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/t=
esting/selftests/bpf/xdp_hw_metadata.c
> > >> index 400bfe19abfe..f3ec07ccdc95 100644
> > >> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > >> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > >> @@ -3,6 +3,9 @@
> > >>   /* Reference program for verifying XDP metadata on real HW. Functi=
onal test
> > >>    * only, doesn't test the performance.
> > >>    *
> > >> + * BPF-prog bpf_printk info outout can be access via
> > >> + * /sys/kernel/debug/tracing/trace_pipe
> > >
> > > s/outout/output/
> > >
> >
> > Fixed in V3
> >
> > > But let's maybe drop it? If you want to make it more usable, let's
> > > have a separate patch to enable tracing and periodically dump it to
> > > the console instead (as previously discussed).
> >
> > Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardless of
> > setting in
> > /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable
> >
> > We likely need a followup patch that adds a BPF config switch that can
> > disable bpf_printk calls, because this adds overhead and thus affects
> > the timestamps.
>
> No. This is by design.
> Do not use bpf_printk* in production.

But that's not for the production? xdp_hw_metadata is a small tool to
verify that the metadata being dumped is correct (during the
development).
We have a proper (less verbose) selftest in
{progs,prog_tests}/xdp_metadata.c (over veth).
This xdp_hw_metadata was supposed to be used for running it against
the real hardware, so having as much debugging at hand as possible
seems helpful? (at least it was helpful to me when playing with mlx4)
