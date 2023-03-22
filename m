Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1C96C54D5
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCVTXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjCVTXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:23:10 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CF01C5BC
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:23:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id d10so11229141pgt.12
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679512986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+XxDyG1Zb8n7rgGAcE315iKJNtu4d2B1g56wl3T6Ho=;
        b=sh0xLsYm7+j03IqhsmQvsORXPF9KFKuYhTvDijN5C0oFn6Utb4v7tjDLquZu/LWJD9
         yeDhIY3vqdQiau/vcIJMVkYP/zUmmKi+J6iJYX+j5gR9C4MLqCTnYqlALq8u8Hx1hqcB
         pkQ9IxErHrpNI6E50R/NdhCp0tj0aBu8Sr+nTQCyHTGsPZ/M1qtZvh1NWWwVyyWys30R
         nAn2KxZMuVON1RKPPiu9oawz2o1aVCUJs9uPxYcKnCgLiwQ1Z209bAub1jgn15I0v5VI
         9ncILNpTqgU6ZQX+ZrbTKjASTBmBe73FxT5F1zOawnC+W6GJn14+dmMVRCSqNiEQgB2b
         6ivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679512986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A+XxDyG1Zb8n7rgGAcE315iKJNtu4d2B1g56wl3T6Ho=;
        b=CNp6BTXUQtt6B2Qz0nXlyE2np/VpexggLM1zJi7JVb4bhOKsz3xAtAVpu1rUQjhLVH
         3t0sjekiZTF446uNkZA9bNgyn9F8BMgoUzggosPimDpo80ZlXWeFJlYBHqsPmPOQnE14
         gZ6mmAoRgmMrF7jhhrCxGw9VEInAHaCFvuLHFqOqYeSJ7bipGSjYB4mh6PuXcC+g2vEx
         b6Sk08LQgl7FyyPLM4HI3E1sBWL21tSVXAKUVql835wZcB3dRLSsnLM8Ftb0Pg/4h5Ls
         gjzKSxkD98Le2HAwBjgnlEpW89d8hwXuRu9kEq97OZAC0PT2Uz12ghzo+hn7FJQk4CdM
         qRyg==
X-Gm-Message-State: AO0yUKVoLaDvifpNEKpSrE7PQxcTfTnOKbpCZGi/2nh3xXR5nZ8MGUi/
        D5uAVy52uYDf1IEU79I+QXZD0CxePNtq7q+Eo8laMA==
X-Google-Smtp-Source: AK7set/E0fspDnF0EE3Ps3NBksqM1EMUhCA699yeWlh4OzFhsdKBUpjGKFwa/C4OQJOCsmUTQydO4jo+cjRMESk/t8U=
X-Received: by 2002:a65:4801:0:b0:4fc:d6df:85a0 with SMTP id
 h1-20020a654801000000b004fcd6df85a0mr1066021pgs.1.1679512986079; Wed, 22 Mar
 2023 12:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com> <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
 <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com> <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 22 Mar 2023 12:22:54 -0700
Message-ID: <CAKH8qBvzVASpUu3M=6ohDqJgJjoR33jQ-J44ESD9SdkvFoGAZg@mail.gmail.com>
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

On Wed, Mar 22, 2023 at 12:17=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 22, 2023 at 12:00=E2=80=AFPM Stanislav Fomichev <sdf@google.c=
om> wrote:
> >
> > On Wed, Mar 22, 2023 at 9:07=E2=80=AFAM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
> > > <jbrouer@redhat.com> wrote:
> > > >
> > > >
> > > >
> > > > On 21/03/2023 19.47, Stanislav Fomichev wrote:
> > > > > On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
> > > > > <brouer@redhat.com> wrote:
> > > > >>
> > > > >> When driver developers add XDP-hints kfuncs for RX hash it is
> > > > >> practical to print the return code in bpf_printk trace pipe log.
> > > > >>
> > > > >> Print hash value as a hex value, both AF_XDP userspace and bpf_p=
rog,
> > > > >> as this makes it easier to spot poor quality hashes.
> > > > >>
> > > > >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > > >> ---
> > > > >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++=
++---
> > > > >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++=
-
> > > > >>   2 files changed, 10 insertions(+), 4 deletions(-)
> > > > >>
> > > > >> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c=
 b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > >> index 40c17adbf483..ce07010e4d48 100644
> > > > >> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > >> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > > > >> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> > > > >>                  meta->rx_timestamp =3D 0; /* Used by AF_XDP as =
not avail signal */
> > > > >>          }
> > > > >>
> > > > >> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> > > > >> -               bpf_printk("populated rx_hash with %u", meta->rx=
_hash);
> > > > >> -       else
> > > > >> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> > > > >> +       if (ret >=3D 0) {
> > > > >> +               bpf_printk("populated rx_hash with 0x%08X", meta=
->rx_hash);
> > > > >> +       } else {
> > > > >> +               bpf_printk("rx_hash not-avail errno:%d", ret);
> > > > >>                  meta->rx_hash =3D 0; /* Used by AF_XDP as not a=
vail signal */
> > > > >> +       }
> > > > >>
> > > > >>          return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_=
PASS);
> > > > >>   }
> > > > >> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/too=
ls/testing/selftests/bpf/xdp_hw_metadata.c
> > > > >> index 400bfe19abfe..f3ec07ccdc95 100644
> > > > >> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > >> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > > >> @@ -3,6 +3,9 @@
> > > > >>   /* Reference program for verifying XDP metadata on real HW. Fu=
nctional test
> > > > >>    * only, doesn't test the performance.
> > > > >>    *
> > > > >> + * BPF-prog bpf_printk info outout can be access via
> > > > >> + * /sys/kernel/debug/tracing/trace_pipe
> > > > >
> > > > > s/outout/output/
> > > > >
> > > >
> > > > Fixed in V3
> > > >
> > > > > But let's maybe drop it? If you want to make it more usable, let'=
s
> > > > > have a separate patch to enable tracing and periodically dump it =
to
> > > > > the console instead (as previously discussed).
> > > >
> > > > Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardless=
 of
> > > > setting in
> > > > /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable
> > > >
> > > > We likely need a followup patch that adds a BPF config switch that =
can
> > > > disable bpf_printk calls, because this adds overhead and thus affec=
ts
> > > > the timestamps.
> > >
> > > No. This is by design.
> > > Do not use bpf_printk* in production.
> >
> > But that's not for the production? xdp_hw_metadata is a small tool to
> > verify that the metadata being dumped is correct (during the
> > development).
> > We have a proper (less verbose) selftest in
> > {progs,prog_tests}/xdp_metadata.c (over veth).
> > This xdp_hw_metadata was supposed to be used for running it against
> > the real hardware, so having as much debugging at hand as possible
> > seems helpful? (at least it was helpful to me when playing with mlx4)
>
> The only use of bpf_printk is for debugging of bpf progs themselves.
> It should not be used in any tool.

Hmm, good point. I guess it also means we won't have to mess with
enabling/dumping ftrace (and don't need this comment about cat'ing the
file).
Jesper, maybe we can instead pass the status of those
bpf_xdp_metadata_xxx kfuncs via 'struct xdp_meta'? And dump this info
from the userspace if needed.
