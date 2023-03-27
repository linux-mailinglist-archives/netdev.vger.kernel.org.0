Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C2D6C9A5A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjC0Dst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjC0Dsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:48:47 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBF04493;
        Sun, 26 Mar 2023 20:48:45 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id cu4so5921487qvb.3;
        Sun, 26 Mar 2023 20:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679888925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FeDfkMMrQT4BDoir4JGzfzhAzX0w2OMMWqn887G1Eo=;
        b=A2Iugkarl99Xefq1xw10HIk/9BMvoZdl5gaOzCfGEadbdbudzs3hSFwdZkDVz1hKoX
         VdqpYuIxJ0pXyAl5j+ZzgOmfFkCIFVIivvlkxENj1GLiMVoaEjbA0YbydIsAlzv4bMl4
         phXAlTAXOX17SD/YtnDW2zWgPEpSpIxq59KXKOz806++goc+HZ2WF3geK4q4NTTWKx+D
         mB9LjiOokNTL6GiAg97aSXKaHy7mSLcyoiyAfZx448xA/qongVBP8mItPCIE6PzC0S/E
         nnQgJA9DOUlsA8FgarwXtxdT8SRgp3lrhWITjI1P6k24XXB3G0BhUuzy9vv5V4OBrJh5
         xJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679888925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FeDfkMMrQT4BDoir4JGzfzhAzX0w2OMMWqn887G1Eo=;
        b=d9i2T+5uv9TWSAhM3ToNO2qBO/b61k4kPwKabZ4hAMtW+oLlrlvTpVFcJjR8d+t0oZ
         5ToDwtSSF3PGv7hcvlod6Dej5spEO9rw1F4PWc/J/WHBhZmhzu342jcvybOenqH8AmPz
         IhN2pEyLIeSsxEUVW14VJmzis5eiOgsZ1K6gq2Z9MEHf70Rx/jcUVsPlDHyEtNOde6Sr
         IedKohDHigjRCGIYC3g0fIQfcG4YkT0e9GJJmMkJ44Vbm+1DyHv5/DIS3kblaSaQ3DXb
         h7yLru6sQfpi1ncb2g3SavuYZ5i0ybAyS3+yprzvtf/ZqfuHdtuBpoEAGPU238A6+njJ
         Kcow==
X-Gm-Message-State: AAQBX9dv5QPKfPDEoOkbfUK9zEGj89yeBXDVu5T1jA5VdGHI42UL3Y3s
        RYGFR+6YEpGlunbxQgq2hwz0Djd/DOxhJRwTUSKydXCZsexcUqUm
X-Google-Smtp-Source: AKy350aFYcs9gGpXm+APkz8hI/e4rajCNWrHEygpCdMoraFWrr/3/dlVPc5wTlPKyGcxF56qvA1wsbkKps2hPNW/vfs=
X-Received: by 2002:a05:6214:1863:b0:56e:ace8:866f with SMTP id
 eh3-20020a056214186300b0056eace8866fmr1792699qvb.3.1679888924973; Sun, 26 Mar
 2023 20:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230326221612.169289-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20230326221612.169289-1-xiyou.wangcong@gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 27 Mar 2023 11:48:09 +0800
Message-ID: <CALOAHbCyGJzp1yH2NTsikre0RuQ+4WoZCsAc110_+tW=L8FgQg@mail.gmail.com>
Subject: Re: [Patch bpf-next] sock_map: include sk_psock memory overhead too
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
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

On Mon, Mar 27, 2023 at 6:16=E2=80=AFAM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> When a socket is added to a sockmap, sk_psock is allocated too as its
> sk_user_data, therefore it should be consider as an overhead of sockmap
> memory usage.
>
> Before this patch:
>
> 1: sockmap  flags 0x0
>         key 4B  value 4B  max_entries 2  memlock 656B
>         pids echo-sockmap(549)
>
> After this patch:
>
> 9: sockmap  flags 0x0
>         key 4B  value 4B  max_entries 2  memlock 1824B
>         pids echo-sockmap(568)
>
> Fixes: 73d2c61919e9 ("bpf, net: sock_map memory usage")
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/sock_map.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 7c189c2e2fbf..22197e565ece 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -799,9 +799,17 @@ static void sock_map_fini_seq_private(void *priv_dat=
a)
>
>  static u64 sock_map_mem_usage(const struct bpf_map *map)
>  {
> +       struct bpf_stab *stab =3D container_of(map, struct bpf_stab, map)=
;
>         u64 usage =3D sizeof(struct bpf_stab);
> +       int i;
>
>         usage +=3D (u64)map->max_entries * sizeof(struct sock *);
> +
> +       for (i =3D 0; i < stab->map.max_entries; i++) {

Although it adds a for-loop, the operation below is quite light. So it
looks good to me.

> +               if (stab->sks[i])

Nit, stab->sks[i] can be modified in the delete path in parallel, so
there should be a READ_ONCE() here.

> +                       usage +=3D sizeof(struct sk_psock);
> +       }
> +
>         return usage;
>  }
>
> @@ -1412,7 +1420,7 @@ static u64 sock_hash_mem_usage(const struct bpf_map=
 *map)
>         u64 usage =3D sizeof(*htab);
>
>         usage +=3D htab->buckets_num * sizeof(struct bpf_shtab_bucket);
> -       usage +=3D atomic_read(&htab->count) * (u64)htab->elem_size;
> +       usage +=3D atomic_read(&htab->count) * ((u64)htab->elem_size + si=
zeof(struct sk_psock));
>         return usage;
>  }
>
> --
> 2.34.1
>


--=20
Regards
Yafang
