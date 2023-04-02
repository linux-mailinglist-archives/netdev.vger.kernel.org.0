Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07F16D38E2
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjDBPuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjDBPuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:50:03 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCD7E042;
        Sun,  2 Apr 2023 08:50:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cn12so108143938edb.4;
        Sun, 02 Apr 2023 08:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680450600; x=1683042600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3H+yKErz+asdo8QewHRhcyQgjCu7p9+bA2Tn/wzQyc=;
        b=AXrfuLSQ2rAeeY46rK+Ifd00OqdmfpQpSBpyMtqEIYfzKeOIpil2Yr1FMG4TG2kyIU
         sM2807/dLEcUCCq7F3iTsJjroIsEdp3/6uyqKLWztzzZPmFHAeYTkclQizNuFjxOO2L2
         MLCoOPenyvuv9yxgFCMU9dbt+OCF4E5KvvHWZonDhVPBxWmin07ve190M9A0/w60VcUn
         n+EY/QLp3zkRDIAYQnnlXVZeCRw6E3ZVBWwV1EvPae2AA/s4jIjc9IAuMI01l4WhLSj4
         72QguFFCOrWWAkczf5Jz0ihnb5MMLHh9vPHB4eiUjQCVqBWEYuYDBTVMf7tLx4wteBdx
         RGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680450600; x=1683042600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A3H+yKErz+asdo8QewHRhcyQgjCu7p9+bA2Tn/wzQyc=;
        b=v/Bkafwi6LXLqc5SCQD5meFY3poQdNfODp16mbKszdcimcVROhT6onqjMsB/6lfWzG
         Lhb99pTsHkG8iVwRI7EtWQlV7BXJUoLw/nUr9DIQE/kZPCTi/quf+eXNIC0zCcFcBg7w
         Xd0L2eZGUSSkQe9mz+xX2i7OGBoKn20HDhOjhW8gLg8abTaC4ZlY5shf0XAEZ/G79YZ9
         POWMZS/eWTS0iOFtLEHKnV/TTX0Gl7/nzdreYeZ+pEffrs1u9DWlfF6Gp42FEDr9Cj3T
         9mSzxTsIbtzBIqnEQoZ7AMgO4Y1F9+hvlkglAxEwJuPE1UbdmSmr75jJuRdH+bbK2u5t
         z+OA==
X-Gm-Message-State: AAQBX9ff6imp1hwK6b6bUsdSiF2JvwiNPStLxCG77OxsvXnGB3I9wjIj
        zUwgct3wjUqjuK7yHFlz1fUEdbiHus8ZbHWu3H4=
X-Google-Smtp-Source: AKy350ax2HWtO6rXgzdemCo1alFkS8HV4Clz+W1EVu6BR1XzxsyNuc7e1sTnlgfbloPRYVtbjT3fruEPtP2eFcoMP5Y=
X-Received: by 2002:a50:9502:0:b0:4fb:2593:846 with SMTP id
 u2-20020a509502000000b004fb25930846mr3463253eda.3.1680450600264; Sun, 02 Apr
 2023 08:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <168042409059.4051476.8176861613304493950.stgit@firesoul> <168042420344.4051476.9107061652824513113.stgit@firesoul>
In-Reply-To: <168042420344.4051476.9107061652824513113.stgit@firesoul>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 2 Apr 2023 08:49:49 -0700
Message-ID: <CAADnVQ+JEP0sOyOOWbYKHackb4PmNYYcDGXnksucJt2mQGwi7g@mail.gmail.com>
Subject: Re: [PATCH bpf V6 5/5] selftests/bpf: Adjust bpf_xdp_metadata_rx_hash
 for new arg
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
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

On Sun, Apr 2, 2023 at 1:30=E2=80=AFAM Jesper Dangaard Brouer <brouer@redha=
t.com> wrote:
>
> Update BPF selftests to use the new RSS type argument for kfunc
> bpf_xdp_metadata_rx_hash.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/xdp_metadata.c        |    2 ++
>  .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   14 +++++++++-----
>  tools/testing/selftests/bpf/progs/xdp_metadata.c   |    6 +++---
>  tools/testing/selftests/bpf/progs/xdp_metadata2.c  |    7 ++++---
>  tools/testing/selftests/bpf/xdp_hw_metadata.c      |    2 +-
>  tools/testing/selftests/bpf/xdp_metadata.h         |    1 +
>  6 files changed, 20 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tool=
s/testing/selftests/bpf/prog_tests/xdp_metadata.c
> index aa4beae99f4f..8c5e98da9ae9 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
> @@ -273,6 +273,8 @@ static int verify_xsk_metadata(struct xsk *xsk)
>         if (!ASSERT_NEQ(meta->rx_hash, 0, "rx_hash"))
>                 return -1;
>
> +       ASSERT_EQ(meta->rx_hash_type, 0, "rx_hash_type");
> +
>         xsk_ring_cons__release(&xsk->rx, 1);
>         refill_rx(xsk, comp_addr);
>
> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/=
testing/selftests/bpf/progs/xdp_hw_metadata.c
> index 4c55b4d79d3d..7b3fc12e96d6 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -14,8 +14,8 @@ struct {
>
>  extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
>                                          __u64 *timestamp) __ksym;
> -extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
> -                                   __u32 *hash) __ksym;
> +extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, __u32 *has=
h,
> +                                   enum xdp_rss_hash_type *rss_type) __k=
sym;
>
>  SEC("xdp")
>  int rx(struct xdp_md *ctx)
> @@ -74,10 +74,14 @@ int rx(struct xdp_md *ctx)
>         else
>                 meta->rx_timestamp =3D 0; /* Used by AF_XDP as not avail =
signal */
>
> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> -               bpf_printk("populated rx_hash with %u", meta->rx_hash);
> -       else
> +       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash, &meta->rx_hash=
_type)) {
> +               bpf_printk("populated rx_hash:0x%X type:0x%X",
> +                          meta->rx_hash, meta->rx_hash_type);
> +               if (!(meta->rx_hash_type & XDP_RSS_L4))
> +                       bpf_printk("rx_hash low quality L3 hash type");
> +       } else {
>                 meta->rx_hash =3D 0; /* Used by AF_XDP as not avail signa=
l */
> +       }

Didn't we agree in the previous thread to remove these printks and
replace them with actual stats that user space can see?
