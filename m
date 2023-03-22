Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3672F6C5500
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCVTdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCVTdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:33:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F146A4E5F5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:33:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso24457738pjb.3
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679513614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+yqqsftMo/G3nMdP87H9eSSXuM3ivJL8CNlu7fY/OI=;
        b=NEt3kWU3db2Pks8j9Xq0f/3Gg2nN6/zbzH1eHceZJasP2v37IlFJ1KevfQqfvU0vrh
         ic3qhbvC4j5ilbP31NUyhYoXwE0K2giaeEz54BIEdo68mGRSm5IkUrh0Ch9qvokAUER4
         4dW2MQVaLSzjK4ED++GjEJjfAiyzEjeFQJ9El8dLJ6/PZRH3fmNwimWwcTgtrmQ/tcZB
         F114eR4A40rp8znRHpAQOfrsHDSRegZvtoW25HPZ82D1T1/EzevfXj0B5eFmGchuGyLW
         eSdElYMeAVgkjpYb0RIAF/5ssBeok6KndQoyoEm+LbeFK0VovW9czaOo7j3ZBuEgeoOR
         Iopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679513614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+yqqsftMo/G3nMdP87H9eSSXuM3ivJL8CNlu7fY/OI=;
        b=4COau5y1vgMwNyR59h0wvTUNYyJbzqie+q4FgnFzDNj6x/Ym/JLgq69PQc2TDM5K/K
         +thmotFkNHOCXfLzoZsRv8EgsxrRXXhXzq/QkwiRAdqAKqfQGW4ab68j538LWDHp/5vp
         Eak9lpCCyH5Cm8LiHo9Z2sZJh57WFwtZFP5rhtqLoNG+WQI/19y/jIH4wam3QRa7nRhr
         1QwQHJfkP02yHZ2hUWwnTmXz+Jm5XUiQ5W3xbPL1stp+KSRkSdZvveYrXCEQT8Jsi+/T
         EQQLiLn23qXbMCfgGHUC1LwEaP90FQztuVvJiWba6yb2QCud0cJnNTMe+citSU4qcG4S
         WloQ==
X-Gm-Message-State: AO0yUKVB3zBaw1sZxqLSYnK7hx61LDVV37psw97kZizZvIYt55WB7ixc
        EgdNLIDp8M5Of56SiBoAXW2Mi+rErFG3ojalc1q8n1iQBXbY/mQkWkMCgg==
X-Google-Smtp-Source: AK7set/ypIrUA5qMrYjv6h+zUCLqRU+8WvxjgbyIxdvmItI2pMSceBZC/hQmlHEP6AeqH1Mo+V8r0ywLc7A8XdUOoYM=
X-Received: by 2002:a17:902:708b:b0:1a0:6001:2e0e with SMTP id
 z11-20020a170902708b00b001a060012e0emr1445303plk.8.1679513614220; Wed, 22 Mar
 2023 12:33:34 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com> <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
 <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
 <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com>
 <CAKH8qBvzVASpUu3M=6ohDqJgJjoR33jQ-J44ESD9SdkvFoGAZg@mail.gmail.com> <CAADnVQLC7ma7SWPOcjXhsZ2N0OyVtBr7TzCoT-_Dn+zQ2DEyWg@mail.gmail.com>
In-Reply-To: <CAADnVQLC7ma7SWPOcjXhsZ2N0OyVtBr7TzCoT-_Dn+zQ2DEyWg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 22 Mar 2023 12:33:22 -0700
Message-ID: <CAKH8qBuqxxVM9fSB43cAvvTnaHkA-JNRy=gufCqYf5GNbRA-8g@mail.gmail.com>
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

On Wed, Mar 22, 2023 at 12:30=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 22, 2023 at 12:23=E2=80=AFPM Stanislav Fomichev <sdf@google.c=
om> wrote:
> >
> > On Wed, Mar 22, 2023 at 12:17=E2=80=AFPM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Mar 22, 2023 at 12:00=E2=80=AFPM Stanislav Fomichev <sdf@goog=
le.com> wrote:
> > > >
> > > > On Wed, Mar 22, 2023 at 9:07=E2=80=AFAM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
> > > > > <jbrouer@redhat.com> wrote:
> > > > > >
> > > > > >
> > > > > >
> > > > > > On 21/03/2023 19.47, Stanislav Fomichev wrote:
> > > > > > > On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Broue=
r
> > > > > > > <brouer@redhat.com> wrote:
> > > > > > >>
> > > > > > >> When driver developers add XDP-hints kfuncs for RX hash it i=
s
> > > > > > >> practical to print the return code in bpf_printk trace pipe =
log.
> > > > > > >>
> > > > > > >> Print hash value as a hex value, both AF_XDP userspace and b=
pf_prog,
> > > > > > >> as this makes it easier to spot poor quality hashes.
> > > > > > >>
> > > > > > >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > > > > >> ---
> > > > > > >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 =
++++++---
> > > > > > >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 =
++++-
> > > > > > >>   2 files changed, 10 insertions(+), 4 deletions(-)
> > > > > > >>
> > > > > > >> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metada=
ta.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > > > >> index 40c17adbf483..ce07010e4d48 100644
> > > > > > >> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > > > >> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > > > >> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> > > > > > >>                  meta->rx_timestamp =3D 0; /* Used by AF_XDP=
 as not avail signal */
> > > > > > >>          }
> > > > > > >>
> > > > > > >> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> > > > > > >> -               bpf_printk("populated rx_hash with %u", meta=
->rx_hash);
> > > > > > >> -       else
> > > > > > >> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash=
);
> > > > > > >> +       if (ret >=3D 0) {
> > > > > > >> +               bpf_printk("populated rx_hash with 0x%08X", =
meta->rx_hash);
> > > > > > >> +       } else {
> > > > > > >> +               bpf_printk("rx_hash not-avail errno:%d", ret=
);
> > > > > > >>                  meta->rx_hash =3D 0; /* Used by AF_XDP as n=
ot avail signal */
> > > > > > >> +       }
> > > > > > >>
> > > > > > >>          return bpf_redirect_map(&xsk, ctx->rx_queue_index, =
XDP_PASS);
> > > > > > >>   }
> > > > > > >> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b=
/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > > > >> index 400bfe19abfe..f3ec07ccdc95 100644
> > > > > > >> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > > > >> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > > > >> @@ -3,6 +3,9 @@
> > > > > > >>   /* Reference program for verifying XDP metadata on real HW=
. Functional test
> > > > > > >>    * only, doesn't test the performance.
> > > > > > >>    *
> > > > > > >> + * BPF-prog bpf_printk info outout can be access via
> > > > > > >> + * /sys/kernel/debug/tracing/trace_pipe
> > > > > > >
> > > > > > > s/outout/output/
> > > > > > >
> > > > > >
> > > > > > Fixed in V3
> > > > > >
> > > > > > > But let's maybe drop it? If you want to make it more usable, =
let's
> > > > > > > have a separate patch to enable tracing and periodically dump=
 it to
> > > > > > > the console instead (as previously discussed).
> > > > > >
> > > > > > Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regard=
less of
> > > > > > setting in
> > > > > > /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/ena=
ble
> > > > > >
> > > > > > We likely need a followup patch that adds a BPF config switch t=
hat can
> > > > > > disable bpf_printk calls, because this adds overhead and thus a=
ffects
> > > > > > the timestamps.
> > > > >
> > > > > No. This is by design.
> > > > > Do not use bpf_printk* in production.
> > > >
> > > > But that's not for the production? xdp_hw_metadata is a small tool =
to
> > > > verify that the metadata being dumped is correct (during the
> > > > development).
> > > > We have a proper (less verbose) selftest in
> > > > {progs,prog_tests}/xdp_metadata.c (over veth).
> > > > This xdp_hw_metadata was supposed to be used for running it against
> > > > the real hardware, so having as much debugging at hand as possible
> > > > seems helpful? (at least it was helpful to me when playing with mlx=
4)
> > >
> > > The only use of bpf_printk is for debugging of bpf progs themselves.
> > > It should not be used in any tool.
> >
> > Hmm, good point. I guess it also means we won't have to mess with
> > enabling/dumping ftrace (and don't need this comment about cat'ing the
> > file).
> > Jesper, maybe we can instead pass the status of those
> > bpf_xdp_metadata_xxx kfuncs via 'struct xdp_meta'? And dump this info
> > from the userspace if needed.
>
> There are so many other ways for bpf prog to communicate with user space.
> Use ringbuf, perf_event buffer, global vars, maps, etc.
> trace_pipe is debug only because it's global and will conflict with
> all other debug sessions.

=F0=9F=91=8D makes sense, ty! hopefully we won't have to add a separate cha=
nnel
for those and can (ab)use the metadata area.
