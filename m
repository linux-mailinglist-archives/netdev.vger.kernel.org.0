Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB346C397F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCUSsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCUSsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:48:21 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4358D53DA8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:47:43 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id n20so5041269pfa.3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679424461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMXuzSvBcY6wo6gmjxQswt5Hcr72mV9P0nbNbA0RBpw=;
        b=ZVKAN6kZNKLbFLMXMn11gxilOycK7pM2JzP5L2Vi9pFmOYeGSh16g6d/UjSJnlB+NC
         v1AVILgWnUG9M8V4H/5NTtBbGP4AA31HYsqWTFeFrtv5iYFy9BqYK7yi/ePOcFRo3rDz
         N4OOdtB7HhCoAI6ndLZ7jsYyxK9ZfhYl5zF+N78jlOwJJuX+EkoD6HYOMP1XIg4Q/2Ke
         jZ6qAtRbbZ3psYk1aZCfuFAbjnnkQmq1lfpkKWpUMaRnWzi9Wx47EYcfu3r7ZiWuBJ21
         zj9WDnDPqdlgk83oEBRac/zye3mYkoQpm97HsC6cYn8Ppo10uX+1frxyupPPgt7Wg/Mk
         oCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMXuzSvBcY6wo6gmjxQswt5Hcr72mV9P0nbNbA0RBpw=;
        b=dlPMDgqU0pIRxXN8sbU2+voVpRmkV6WI3L/Z7t0u/hN7ybKgQJv/8Mw1K2ICfEYkGy
         MJE/Wc48eXVYOzASsSWDnIZM6DRchtldgzqsxsFAzlCBCikqvsQSiXddmFkaX+cah98B
         94BiKeDKbPKdcg4jKs4V+mzVCcTbKl9i+yrWt1rGXQOSCN8r/oNCy79zHIcH8CW3B/vf
         VjM+5HPv2mkTUb06MPHYt0YA9U0hWPpeZ3/cCj2MQ4el6TuXFoNsRg2RYpCqXNsWtwKw
         Gc6lmltWNFsD2moPLrGNfs21bGEtrxz8p055CEawOIiI6243300Mj1Vf/yYL9ftdwBDq
         7K4g==
X-Gm-Message-State: AO0yUKWPaArrXxwZle7pwTj6bXAdWWMpVtA8dn/NPSL3erobX+xko+ur
        wrnx5iScXvzYeUhM3T7syfzCmH7Y7J9TIqzaI7A3lg==
X-Google-Smtp-Source: AK7set/dRzPdTcuUTfjVGXOOTTi/AD0/54Cm5YH/fj/MLar3MvUn+tnk4s1XttRr3kjfRHV/EbKh+QlG18P9jNVp840=
X-Received: by 2002:a65:4247:0:b0:503:7bcd:89e9 with SMTP id
 d7-20020a654247000000b005037bcd89e9mr18351pgq.1.1679424460710; Tue, 21 Mar
 2023 11:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul> <167940643669.2718137.4624187727245854475.stgit@firesoul>
In-Reply-To: <167940643669.2718137.4624187727245854475.stgit@firesoul>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 21 Mar 2023 11:47:28 -0700
Message-ID: <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> When driver developers add XDP-hints kfuncs for RX hash it is
> practical to print the return code in bpf_printk trace pipe log.
>
> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
> as this makes it easier to spot poor quality hashes.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
>  tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/=
testing/selftests/bpf/progs/xdp_hw_metadata.c
> index 40c17adbf483..ce07010e4d48 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
>                 meta->rx_timestamp =3D 0; /* Used by AF_XDP as not avail =
signal */
>         }
>
> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> -               bpf_printk("populated rx_hash with %u", meta->rx_hash);
> -       else
> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> +       if (ret >=3D 0) {
> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash=
);
> +       } else {
> +               bpf_printk("rx_hash not-avail errno:%d", ret);
>                 meta->rx_hash =3D 0; /* Used by AF_XDP as not avail signa=
l */
> +       }
>
>         return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>  }
> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testin=
g/selftests/bpf/xdp_hw_metadata.c
> index 400bfe19abfe..f3ec07ccdc95 100644
> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> @@ -3,6 +3,9 @@
>  /* Reference program for verifying XDP metadata on real HW. Functional t=
est
>   * only, doesn't test the performance.
>   *
> + * BPF-prog bpf_printk info outout can be access via
> + * /sys/kernel/debug/tracing/trace_pipe

s/outout/output/

But let's maybe drop it? If you want to make it more usable, let's
have a separate patch to enable tracing and periodically dump it to
the console instead (as previously discussed).

With this addressed:
Acked-by: Stanislav Fomichev <sdf@google.com>

> + *
>   * RX:
>   * - UDP 9091 packets are diverted into AF_XDP
>   * - Metadata verified:
> @@ -156,7 +159,7 @@ static void verify_xdp_metadata(void *data, clockid_t=
 clock_id)
>
>         meta =3D data - sizeof(*meta);
>
> -       printf("rx_hash: %u\n", meta->rx_hash);
> +       printf("rx_hash: 0x%08X\n", meta->rx_hash);
>         printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
>                (double)meta->rx_timestamp / NANOSEC_PER_SEC);
>         if (meta->rx_timestamp) {
>
>
