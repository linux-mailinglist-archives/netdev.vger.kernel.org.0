Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378EF6C54EE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCVTaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCVTaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:30:52 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B7464276;
        Wed, 22 Mar 2023 12:30:50 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ew6so14405022edb.7;
        Wed, 22 Mar 2023 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679513449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrQlaEec5B0ZGmryHZC8OLS4jt5SwKguRICHgHnf1bI=;
        b=F5qfAd61GgyM+ravQ2cpL0YIlB6d/Jxc/GQJXNn8B+WLlAmss/Ykt4wOHyfdVRt7p9
         747Evf56A/huI57j4TISAid9yUv2x0VQL3o7mqEq0WtXW+R2OQOnGpC3QkRqkRh1LuDT
         cp/7gCKbpROBt8r4KIZQkp6glIy0UHdQdx/o/EwyVddaMUgQNZ0jkgrVI35EzWEfkp4u
         He6kL5dNrA7fGQob9/Vffh3JxBuEl5nALyJkL1J4M81uv+eJLujXYUXB3MUgTpqPFUVH
         IyIQhkmBCuah6C5W8r/9r/HNBZGimx4iTfg7TxOkeW6ouKgrlOMyyYi3pQUk4Px53Lxg
         kqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679513449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrQlaEec5B0ZGmryHZC8OLS4jt5SwKguRICHgHnf1bI=;
        b=wSKxBbDQXiFCD9Q97560yr4EvRShy8hQRg5xbZuReYAtrKwC5QwTGz5eAX62Jtl3ye
         wZjgALQWX4/sINFreCJYr0dAjiTTIrmqX+sTcSgKjXX5WfQ7Y/rHnd6RE9/A1It/w+y4
         Mry+65qXk5Y2vIEt0IBsNCT98SXha+z7TuAw86PUFag4p+cMQW2egi8sa0pfvbQCEwdZ
         3X1BoYapOEBQmbSprKPAt49kvFzR7kFov6wd4U3LfhmRiGSi8gqnNLd1aZGaNX9RC3CQ
         F64AXGASJmNlqn2LHHTRNfYSaVPxqnqqPvFp0b8jeXo8QqbmQVsGDtQSInY9u9UhmJZM
         zJ4g==
X-Gm-Message-State: AO0yUKUDjS2kbvvHJGrdquYNnpPpp93z3+8R6pbEs9qhV6LbJCzLIWZv
        Cr8UNrIpcUBoTV+x24RINfoJRAEJsbEfexE2n7A=
X-Google-Smtp-Source: AK7set9q1qs+/E5dlv0SRf2iQTk9JRKsI0pGAVe6/06WLrNMVKgHleemIyGTp6evMQg4J1kF4xkhTZcQvsY1onABpdU=
X-Received: by 2002:a17:906:a288:b0:931:3a19:d835 with SMTP id
 i8-20020a170906a28800b009313a19d835mr3755928ejz.3.1679513448996; Wed, 22 Mar
 2023 12:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com> <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
 <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
 <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com> <CAKH8qBvzVASpUu3M=6ohDqJgJjoR33jQ-J44ESD9SdkvFoGAZg@mail.gmail.com>
In-Reply-To: <CAKH8qBvzVASpUu3M=6ohDqJgJjoR33jQ-J44ESD9SdkvFoGAZg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Mar 2023 12:30:37 -0700
Message-ID: <CAADnVQLC7ma7SWPOcjXhsZ2N0OyVtBr7TzCoT-_Dn+zQ2DEyWg@mail.gmail.com>
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

On Wed, Mar 22, 2023 at 12:23=E2=80=AFPM Stanislav Fomichev <sdf@google.com=
> wrote:
>
> On Wed, Mar 22, 2023 at 12:17=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Mar 22, 2023 at 12:00=E2=80=AFPM Stanislav Fomichev <sdf@google=
.com> wrote:
> > >
> > > On Wed, Mar 22, 2023 at 9:07=E2=80=AFAM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
> > > > <jbrouer@redhat.com> wrote:
> > > > >
> > > > >
> > > > >
> > > > > On 21/03/2023 19.47, Stanislav Fomichev wrote:
> > > > > > On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
> > > > > > <brouer@redhat.com> wrote:
> > > > > >>
> > > > > >> When driver developers add XDP-hints kfuncs for RX hash it is
> > > > > >> practical to print the return code in bpf_printk trace pipe lo=
g.
> > > > > >>
> > > > > >> Print hash value as a hex value, both AF_XDP userspace and bpf=
_prog,
> > > > > >> as this makes it easier to spot poor quality hashes.
> > > > > >>
> > > > > >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > > > >> ---
> > > > > >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++=
++++---
> > > > > >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++=
++-
> > > > > >>   2 files changed, 10 insertions(+), 4 deletions(-)
> > > > > >>
> > > > > >> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata=
.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > > >> index 40c17adbf483..ce07010e4d48 100644
> > > > > >> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > > >> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > > >> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> > > > > >>                  meta->rx_timestamp =3D 0; /* Used by AF_XDP a=
s not avail signal */
> > > > > >>          }
> > > > > >>
> > > > > >> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> > > > > >> -               bpf_printk("populated rx_hash with %u", meta->=
rx_hash);
> > > > > >> -       else
> > > > > >> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> > > > > >> +       if (ret >=3D 0) {
> > > > > >> +               bpf_printk("populated rx_hash with 0x%08X", me=
ta->rx_hash);
> > > > > >> +       } else {
> > > > > >> +               bpf_printk("rx_hash not-avail errno:%d", ret);
> > > > > >>                  meta->rx_hash =3D 0; /* Used by AF_XDP as not=
 avail signal */
> > > > > >> +       }
> > > > > >>
> > > > > >>          return bpf_redirect_map(&xsk, ctx->rx_queue_index, XD=
P_PASS);
> > > > > >>   }
> > > > > >> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/t=
ools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > > >> index 400bfe19abfe..f3ec07ccdc95 100644
> > > > > >> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > > >> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > > >> @@ -3,6 +3,9 @@
> > > > > >>   /* Reference program for verifying XDP metadata on real HW. =
Functional test
> > > > > >>    * only, doesn't test the performance.
> > > > > >>    *
> > > > > >> + * BPF-prog bpf_printk info outout can be access via
> > > > > >> + * /sys/kernel/debug/tracing/trace_pipe
> > > > > >
> > > > > > s/outout/output/
> > > > > >
> > > > >
> > > > > Fixed in V3
> > > > >
> > > > > > But let's maybe drop it? If you want to make it more usable, le=
t's
> > > > > > have a separate patch to enable tracing and periodically dump i=
t to
> > > > > > the console instead (as previously discussed).
> > > > >
> > > > > Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardle=
ss of
> > > > > setting in
> > > > > /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enabl=
e
> > > > >
> > > > > We likely need a followup patch that adds a BPF config switch tha=
t can
> > > > > disable bpf_printk calls, because this adds overhead and thus aff=
ects
> > > > > the timestamps.
> > > >
> > > > No. This is by design.
> > > > Do not use bpf_printk* in production.
> > >
> > > But that's not for the production? xdp_hw_metadata is a small tool to
> > > verify that the metadata being dumped is correct (during the
> > > development).
> > > We have a proper (less verbose) selftest in
> > > {progs,prog_tests}/xdp_metadata.c (over veth).
> > > This xdp_hw_metadata was supposed to be used for running it against
> > > the real hardware, so having as much debugging at hand as possible
> > > seems helpful? (at least it was helpful to me when playing with mlx4)
> >
> > The only use of bpf_printk is for debugging of bpf progs themselves.
> > It should not be used in any tool.
>
> Hmm, good point. I guess it also means we won't have to mess with
> enabling/dumping ftrace (and don't need this comment about cat'ing the
> file).
> Jesper, maybe we can instead pass the status of those
> bpf_xdp_metadata_xxx kfuncs via 'struct xdp_meta'? And dump this info
> from the userspace if needed.

There are so many other ways for bpf prog to communicate with user space.
Use ringbuf, perf_event buffer, global vars, maps, etc.
trace_pipe is debug only because it's global and will conflict with
all other debug sessions.
