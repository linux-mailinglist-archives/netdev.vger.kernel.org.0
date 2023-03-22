Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C658C6C500A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCVQH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCVQH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:07:57 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0FE62DAF;
        Wed, 22 Mar 2023 09:07:54 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w9so75103621edc.3;
        Wed, 22 Mar 2023 09:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679501273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOzog1rcJBIJ0IWpoVcxs5p5wXubMGjNYuLplz2RPz0=;
        b=KwKrLt++JgVHYPV+zzH2vsrhxtmgPAAlhxhmkHaW5Tn1Uv3QfKENWI9nJhy7yvpxlK
         /lftz09YJtHFS1Oim2MNM2FSKBdNhIeP1Tuz6Tvxn6XgLNhixDP3VM7Zdc9xkrUHQy7C
         VMc0wxBq0ghfmRfS1WRhg+boL8oug5wZzjhS3yLiSxkglMV5ZKWPWp3eMfI8Fq0dSSbL
         OA/ey/3LS7BhlvFaMUCQOqORHj7aOrCJqsgFP4wgCuQd+duVn2oCa4eGxPH7LyqAIDFd
         HyDXN8k1c55LycGNCDmyMDTNFn+bwi9f0ok4XeLJrAh3GtQC7nFbKP8H96/S7vfjKn4b
         6ENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679501273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOzog1rcJBIJ0IWpoVcxs5p5wXubMGjNYuLplz2RPz0=;
        b=4GOB3qIbItGd08sCzA+Oycwz5YnrghyEoWH0RoktHu16ImF1waY11HMTTJQXxXFeLz
         27AYiIKylxSCdhl9p89iJwb7vBGIRCBVBortTCcJINVHvupzI6FdVQkVadABWKB6JfUQ
         ooNHNrkKHVNurWvxZIqgW5aCrrlZqfqmRJUplYATSYOBK/GDnBVUqaJF0RPyILxKQ8cw
         KzSrHFUhWzeEOgtty3cIBQ0fV418m09IhY7UEqjAV8+mi/1TzTsaJI/EemtntifDbKpl
         hPoHd8EjlG/IFYZfSvfElHByZbBwoLPPhT4jIF1VpaQqEBXS6Hv95aChdt57ajwOQbrg
         PtNw==
X-Gm-Message-State: AO0yUKVaZr/r1lJIACovOm8mu/51IOOhJmBGawJ6TERX1hFBH57boiLF
        Q7JAKyXSyOM4HxO6Ai1Y18lIEuVeHRTH9w1y0ys=
X-Google-Smtp-Source: AK7set8U2axS8vjpTT71ShGMMBPNsw6nJfxB/FJqNUP5haOFL3RpVeqtsMlGUxJwfDHo3l1mRyT0yLGgeSBExss0N70=
X-Received: by 2002:a17:906:2cc5:b0:931:c1a:b517 with SMTP id
 r5-20020a1709062cc500b009310c1ab517mr3409072ejr.3.1679501273106; Wed, 22 Mar
 2023 09:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com>
In-Reply-To: <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Mar 2023 09:07:41 -0700
Message-ID: <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
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

On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 21/03/2023 19.47, Stanislav Fomichev wrote:
> > On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> >>
> >> When driver developers add XDP-hints kfuncs for RX hash it is
> >> practical to print the return code in bpf_printk trace pipe log.
> >>
> >> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
> >> as this makes it easier to spot poor quality hashes.
> >>
> >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >> ---
> >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
> >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
> >>   2 files changed, 10 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/too=
ls/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >> index 40c17adbf483..ce07010e4d48 100644
> >> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> >>                  meta->rx_timestamp =3D 0; /* Used by AF_XDP as not av=
ail signal */
> >>          }
> >>
> >> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> >> -               bpf_printk("populated rx_hash with %u", meta->rx_hash)=
;
> >> -       else
> >> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> >> +       if (ret >=3D 0) {
> >> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_h=
ash);
> >> +       } else {
> >> +               bpf_printk("rx_hash not-avail errno:%d", ret);
> >>                  meta->rx_hash =3D 0; /* Used by AF_XDP as not avail s=
ignal */
> >> +       }
> >>
> >>          return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
> >>   }
> >> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/tes=
ting/selftests/bpf/xdp_hw_metadata.c
> >> index 400bfe19abfe..f3ec07ccdc95 100644
> >> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> @@ -3,6 +3,9 @@
> >>   /* Reference program for verifying XDP metadata on real HW. Function=
al test
> >>    * only, doesn't test the performance.
> >>    *
> >> + * BPF-prog bpf_printk info outout can be access via
> >> + * /sys/kernel/debug/tracing/trace_pipe
> >
> > s/outout/output/
> >
>
> Fixed in V3
>
> > But let's maybe drop it? If you want to make it more usable, let's
> > have a separate patch to enable tracing and periodically dump it to
> > the console instead (as previously discussed).
>
> Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardless of
> setting in
> /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable
>
> We likely need a followup patch that adds a BPF config switch that can
> disable bpf_printk calls, because this adds overhead and thus affects
> the timestamps.

No. This is by design.
Do not use bpf_printk* in production.
