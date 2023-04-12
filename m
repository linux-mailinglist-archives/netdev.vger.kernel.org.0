Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362A56DFE29
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 20:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjDLS5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 14:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjDLS5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 14:57:33 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98A66E81
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 11:57:05 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q191so14009214pgq.7
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 11:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681325821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sHYXkYaef6xMNFmaZnkKzH+IKK7bhNbi9t2F6EAC6M8=;
        b=TuoQ6JVKp2k/cFPXNyeuO/F/TOiztKMjN9sXg8H64JYl6kg3bdh2aWRaJL6RRsNcKW
         DJOzoEtWM9RiDETkmdPHNEJQUN+f4QvXeR28ACr0ns+ASVmBQTaFxSYOJguvjPSXOf/L
         1A4RSQ6Q16cm87R23Tqns/d9AfqB7Tb41aTuaFulG/wxXXKGEK8DcriRQVZne1xIxoIa
         wrOUXDRrrYKApE4p6AVzkwq942bKDane/X3ICADPACDDMki5/AEJkV0+9eHSOdLC/1ni
         j8Y+H2FjR7EyDfl1hNal8++dP0IIQNIgQHybab0EHhxH23u5mcmzQakJzPmfMb5rsN4f
         FtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681325821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sHYXkYaef6xMNFmaZnkKzH+IKK7bhNbi9t2F6EAC6M8=;
        b=cY4lnBcYxue4jksQojKlEVwyZY668HaIwJ5fd8OOLGwq3I0jbQKecMEZWaJbhX/1dh
         36FA843VzNTRdvvowOyt0/+gH3HvwTO4O6xI2ovewEalwYdSqR92PLPWJEoljnKNKChP
         fiH4vbZRJXAgK9gBFye0fXr09DNF8U1q750Ati0KNnY88Rpycrkrz8IgFJuQssXHyi/K
         8orTy/BC8TImlL28sdfKUvKzVuLa6/w5uacj/Pmwc4VG08pWptxuNZSEze18hJVzGObG
         3iB8V7jGR8PPy2EIDAUB8bnswO9F3WHY+EUKHfQw6auvX6BxqF3TCP2XIbm6mW4ub0dV
         8UJg==
X-Gm-Message-State: AAQBX9emuVrBFsY5en2oxrgGrewSXpgnZrXs3qrOosJij6RuCpbkdLyO
        2bqgGWjJf/fv1heb+GCRmHI+4LxUZb6QxoHOkwSHfQ==
X-Google-Smtp-Source: AKy350asSOWvzYYWk3xZPCNn85M1GUh5aXVd/UqL2CaLUxUIrW5LUiHM1WCh8gu/XhXgKmAXccrklI07joG66CYJ6E4=
X-Received: by 2002:a65:4681:0:b0:513:6b94:8907 with SMTP id
 h1-20020a654681000000b005136b948907mr880151pgr.1.1681325820765; Wed, 12 Apr
 2023 11:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <168132448251.317773.2526885806604122764.stgit@firesoul> <168132451707.317773.15960209122204110352.stgit@firesoul>
In-Reply-To: <168132451707.317773.15960209122204110352.stgit@firesoul>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 12 Apr 2023 11:56:49 -0700
Message-ID: <CAKH8qBu0B1tQBKtGp0-n8eet+4rQRTPE3rrCr5Ve0CG6uYR7Kg@mail.gmail.com>
Subject: Re: [PATCH bpf V9 1/6] selftests/bpf: xdp_hw_metadata remove
 bpf_printk and add counters
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 11:35=E2=80=AFAM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> The tool xdp_hw_metadata can be used by driver developers
> implementing XDP-hints metadata kfuncs.
>
> Remove all bpf_printk calls, as the tool already transfers all the
> XDP-hints related information via metadata area to AF_XDP
> userspace process.
>
> Add counters for providing remaining information about failure and
> skipped packet events.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

nit: maybe those ++ should be __sync_add_and_fetch instead? Then you
should be able to drop volatile..

> ---
>  .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   36 ++++++++++++--=
------
>  tools/testing/selftests/bpf/xdp_hw_metadata.c      |    4 ++
>  2 files changed, 24 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/=
testing/selftests/bpf/progs/xdp_hw_metadata.c
> index 4c55b4d79d3d..8a042343cb0c 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -12,6 +12,10 @@ struct {
>         __type(value, __u32);
>  } xsk SEC(".maps");
>
> +volatile __u64 pkts_skip =3D 0;
> +volatile __u64 pkts_fail =3D 0;
> +volatile __u64 pkts_redir =3D 0;
> +
>  extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
>                                          __u64 *timestamp) __ksym;
>  extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
> @@ -26,7 +30,7 @@ int rx(struct xdp_md *ctx)
>         struct udphdr *udp =3D NULL;
>         struct iphdr *iph =3D NULL;
>         struct xdp_meta *meta;
> -       int ret;
> +       int err;
>
>         data =3D (void *)(long)ctx->data;
>         data_end =3D (void *)(long)ctx->data_end;
> @@ -46,17 +50,20 @@ int rx(struct xdp_md *ctx)
>                         udp =3D NULL;
>         }
>
> -       if (!udp)
> +       if (!udp) {
> +               pkts_skip++;
>                 return XDP_PASS;
> +       }
>
> -       if (udp->dest !=3D bpf_htons(9091))
> +       /* Forwarding UDP:9091 to AF_XDP */
> +       if (udp->dest !=3D bpf_htons(9091)) {
> +               pkts_skip++;
>                 return XDP_PASS;
> +       }
>
> -       bpf_printk("forwarding UDP:9091 to AF_XDP");
> -
> -       ret =3D bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
> -       if (ret !=3D 0) {
> -               bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
> +       err =3D bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
> +       if (err) {
> +               pkts_fail++;
>                 return XDP_PASS;
>         }
>
> @@ -65,20 +72,19 @@ int rx(struct xdp_md *ctx)
>         meta =3D data_meta;
>
>         if (meta + 1 > data) {
> -               bpf_printk("bpf_xdp_adjust_meta doesn't appear to work");
> +               pkts_fail++;
>                 return XDP_PASS;
>         }
>
> -       if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
> -               bpf_printk("populated rx_timestamp with %llu", meta->rx_t=
imestamp);
> -       else
> +       err =3D bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp);
> +       if (err)
>                 meta->rx_timestamp =3D 0; /* Used by AF_XDP as not avail =
signal */
>
> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> -               bpf_printk("populated rx_hash with %u", meta->rx_hash);
> -       else
> +       err =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> +       if (err)
>                 meta->rx_hash =3D 0; /* Used by AF_XDP as not avail signa=
l */
>
> +       pkts_redir++;
>         return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>  }
>
> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testin=
g/selftests/bpf/xdp_hw_metadata.c
> index 1c8acb68b977..3b942ef7297b 100644
> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> @@ -212,7 +212,9 @@ static int verify_metadata(struct xsk *rx_xsk, int rx=
q, int server_fd)
>         while (true) {
>                 errno =3D 0;
>                 ret =3D poll(fds, rxq + 1, 1000);
> -               printf("poll: %d (%d)\n", ret, errno);
> +               printf("poll: %d (%d) skip=3D%llu fail=3D%llu redir=3D%ll=
u\n",
> +                      ret, errno, bpf_obj->bss->pkts_skip,
> +                      bpf_obj->bss->pkts_fail, bpf_obj->bss->pkts_redir)=
;
>                 if (ret < 0)
>                         break;
>                 if (ret =3D=3D 0)
>
>
