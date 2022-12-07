Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95B1645A32
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLGMxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLGMxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:53:48 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AE21275E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:53:47 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3bf4ade3364so185031417b3.3
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 04:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDODjGhBMLvVb1MoKlzH8N7I+N1MGa99AoScKVClC+w=;
        b=l3l51uABhEfohyeMdDsC1g6ZsmBgW1vGILouCiwB1tAkYfro+vYnFlSbLU12IPJ9A5
         WclP42LJByBsqh88sTnUGi+29prdRT/sRe7F27OSUlJ1hi6WBW7v79nKna2R5DclGx9+
         F4l6j5vhpAIKtExRKAf+c9ZrOArPXtk0NpLczS40CBEd77pnjvxb8He3CmGa7QKlmZOz
         2YORJs6RlN7XXgSJwGj3IQgFpYCn6BR13C5tHr1WiY5Vw1bWAeJMD9cV8UYyckUTQJ3X
         8iO4byHgvV2pJ+x4mrlcgKf8FevHvLBeahTvizrGWTOGqhaHfQr1nonmgoYrretVmQ53
         4BoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDODjGhBMLvVb1MoKlzH8N7I+N1MGa99AoScKVClC+w=;
        b=g+hHDfEW7RT6IFib7e2H3u1bBSXKmu1J5eQ2Rr0QuoQ9OgGOJGYDzAY60bRysl/dS7
         Oc/iOhOweco2XRvMWM/xhspMWJNoOJakGFWWx9KaIbteioOovaz+BV3CTifGjYayil42
         Mfzp5zECav5nIXLY88ffj4U9oQkEvgInkwN+t7G3SYdMtgRfdArqZurjghuCr034JlOd
         aNb2DTaRfZ/d4N9tvChWuOK20J5arHvdqJqwjQRDb/anP3zwwten12edrntjNnSBfZFE
         SbyzdhyNJ/xNkr+CD6mO3U4FB944dXwLFBrdmTVF3UZ521zSP05QaJRPACI2MlY/0hFc
         iw2g==
X-Gm-Message-State: ANoB5plIorM3eenCpvXSp9wiRas7T4JErAX7Fu83jo1MW2i7jRp/0oDm
        m94RyE5aggAO+3toWxsqGHGG+zxLR8GRNQByMHBkUg==
X-Google-Smtp-Source: AA0mqf6iqL9UXb/lvn8VCKjnkcAZSgzpSbGgtji30BQnlKrZfJEGiHDnVR7nDe+0chYh+G87PEzydP2ST5BptDg0zyY=
X-Received: by 2002:a81:1e44:0:b0:370:7a9a:564 with SMTP id
 e65-20020a811e44000000b003707a9a0564mr20984563ywe.278.1670417626546; Wed, 07
 Dec 2022 04:53:46 -0800 (PST)
MIME-Version: 1.0
References: <20221206055059.1877471-1-edumazet@google.com> <20221206055059.1877471-3-edumazet@google.com>
 <40ca4e2e-8f34-545a-7063-09aee0a5dd4c@gmail.com>
In-Reply-To: <40ca4e2e-8f34-545a-7063-09aee0a5dd4c@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Dec 2022 13:53:35 +0100
Message-ID: <CANn89iKUYMb_4vJ5GAE0-BUmM7JNuHo_p8oHbfJfatYKBX8ouw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends
 on MAX_SKB_FRAGS
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Dec 7, 2022 at 1:40 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 12/6/2022 7:50 AM, Eric Dumazet wrote:
> > Google production kernel has increased MAX_SKB_FRAGS to 45
> > for BIG-TCP rollout.
> >
> > Unfortunately mlx4 TX bounce buffer is not big enough whenever
> > an skb has up to 45 page fragments.
> >
> > This can happen often with TCP TX zero copy, as one frag usually
> > holds 4096 bytes of payload (order-0 page).
> >
> > Tested:
> >   Kernel built with MAX_SKB_FRAGS=45
> >   ip link set dev eth0 gso_max_size 185000
> >   netperf -t TCP_SENDFILE
> >
> > I made sure that "ethtool -G eth0 tx 64" was properly working,
> > ring->full_size being set to 16.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Wei Wang <weiwan@google.com>
> > Cc: Tariq Toukan <tariqt@nvidia.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 16 ++++++++++++----
> >   1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > index 7cc288db2a64f75ffe64882e3c25b90715e68855..120b8c361e91d443f83f100a1afabcabc776a92a 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > @@ -89,8 +89,18 @@
> >   #define MLX4_EN_FILTER_HASH_SHIFT 4
> >   #define MLX4_EN_FILTER_EXPIRY_QUOTA 60
> >
> > -/* Typical TSO descriptor with 16 gather entries is 352 bytes... */
> > -#define MLX4_TX_BOUNCE_BUFFER_SIZE 512
> > +#define CTRL_SIZE    sizeof(struct mlx4_wqe_ctrl_seg)
> > +#define DS_SIZE              sizeof(struct mlx4_wqe_data_seg)
> > +
> > +/* Maximal size of the bounce buffer:
> > + * 256 bytes for LSO headers.
> > + * CTRL_SIZE for control desc.
> > + * DS_SIZE if skb->head contains some payload.
> > + * MAX_SKB_FRAGS frags.
> > + */
> > +#define MLX4_TX_BOUNCE_BUFFER_SIZE (256 + CTRL_SIZE + DS_SIZE +              \
> > +                                 MAX_SKB_FRAGS * DS_SIZE)
> > +
> >   #define MLX4_MAX_DESC_TXBBS    (MLX4_TX_BOUNCE_BUFFER_SIZE / TXBB_SIZE)
> >
>
> Now as MLX4_TX_BOUNCE_BUFFER_SIZE might not be a multiple of TXBB_SIZE,
> simple integer division won't work to calculate the max num of TXBBs.
> Roundup is needed.

I do not see why a roundup is needed. This seems like obfuscation to me.

A divide by TXBB_SIZE always "works".

A round up is already done in mlx4_en_xmit()

/* Align descriptor to TXBB size */
desc_size = ALIGN(real_size, TXBB_SIZE);
nr_txbb = desc_size >> LOG_TXBB_SIZE;

Then the check is :

if (unlikely(nr_txbb > MLX4_MAX_DESC_TXBBS)) {
   if (netif_msg_tx_err(priv))
       en_warn(priv, "Oversized header or SG list\n");
   goto tx_drop_count;
}

If we allocate X extra bytes (in case MLX4_TX_BOUNCE_BUFFER_SIZE %
TXBB_SIZE == X),
we are not going to use them anyway.
