Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68509645A60
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiLGNGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLGNGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:06:31 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3B0554F1
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:06:28 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3b5d9050e48so185665187b3.2
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7171IZgGXT7wu1S/KFSaPQzg32nueT8bxDZb2HuPflI=;
        b=VRjwy4uwprYmeeNf7hROYgzgcq3ENvuQIEJT/zFNTaDYnZiQidGHhf4v8McqpXN3Ty
         +HGl4S1jL3f9jyP3Fe1o1kqaeVffc1/h+aUPCcG5tNLE2o0yJ+ElSFlOg1UruYWs81bY
         OaVLvLXfXpQwhYKu2u7CZshE5IiC4FkcEoqcNbfoETrS+sRKIBxCsZqXvpNNfB0L/gKm
         xvqMEVnVjmrM6qd8Il+FtD1a1pXSW9AmUawEVSet6HglJj3RbOq6vuUoNQUBmq/lUcn5
         LZ+Y5wkXDYn9DDfw5eg8RZc5J0kr6fWJFPPyN44Xao6wht6OGOwuhnW/yQoIC5LA0GgF
         SV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7171IZgGXT7wu1S/KFSaPQzg32nueT8bxDZb2HuPflI=;
        b=QCXrkyAsFk9jGLN+j1lDSGkjTbtP2f0vWe85bJA2cvREcBEjDFBAIptbu0+X5PjG+c
         epH55Tcm1nZcT6ZUOa92J+8qF266UhBibVsiHMZl6bJPZ255RuT1tHZqNjfTlhK7gkzp
         7dRqelQm3I4yw4Q+HlKQ9CjS8Z87ie4F63Ot7b9h8k0QEXWV1TJgJn83lfnJKgi/dyiR
         u4vun64gN5eDr22fZLjBFbAb6XLUWohMMT+Muuzo+6CqCy9Na0nAeAu8hH3JTFYLKDuH
         ExZn7qfay/FqwqFUVrt6TAXjpkthq2fi2KFw0eep4Su+pXo9uykdoYs3O0r1w/hcRSHu
         WMWg==
X-Gm-Message-State: ANoB5pmIia9FfkKWJJ9APkDvT3leCN/zRoWb+W1JMeKp41BQU6hoFMUc
        AXPVrpADubgG8DPEw3x1Rpi4a+exUQ6GSC4qWw11ew==
X-Google-Smtp-Source: AA0mqf4hzfsN4K2eLi5SZF9v2q0VF3ow9ghIdG1UMY04hUhgp94FzoafKn2rSo5KSxqnxc+5td0p7qGZsWP1tKWbHrE=
X-Received: by 2002:a81:a8a:0:b0:37e:6806:a5f9 with SMTP id
 132-20020a810a8a000000b0037e6806a5f9mr5989049ywk.47.1670418387214; Wed, 07
 Dec 2022 05:06:27 -0800 (PST)
MIME-Version: 1.0
References: <20221206055059.1877471-1-edumazet@google.com> <20221206055059.1877471-3-edumazet@google.com>
 <40ca4e2e-8f34-545a-7063-09aee0a5dd4c@gmail.com> <CANn89iKUYMb_4vJ5GAE0-BUmM7JNuHo_p8oHbfJfatYKBX8ouw@mail.gmail.com>
In-Reply-To: <CANn89iKUYMb_4vJ5GAE0-BUmM7JNuHo_p8oHbfJfatYKBX8ouw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Dec 2022 14:06:15 +0100
Message-ID: <CANn89iKpGwej5X_noxU+N7Y4o30dpfEFX_Ao6qZeahScvM7qGQ@mail.gmail.com>
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

On Wed, Dec 7, 2022 at 1:53 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Dec 7, 2022 at 1:40 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
> >
> >
> >
> > On 12/6/2022 7:50 AM, Eric Dumazet wrote:
> > > Google production kernel has increased MAX_SKB_FRAGS to 45
> > > for BIG-TCP rollout.
> > >
> > > Unfortunately mlx4 TX bounce buffer is not big enough whenever
> > > an skb has up to 45 page fragments.
> > >
> > > This can happen often with TCP TX zero copy, as one frag usually
> > > holds 4096 bytes of payload (order-0 page).
> > >
> > > Tested:
> > >   Kernel built with MAX_SKB_FRAGS=45
> > >   ip link set dev eth0 gso_max_size 185000
> > >   netperf -t TCP_SENDFILE
> > >
> > > I made sure that "ethtool -G eth0 tx 64" was properly working,
> > > ring->full_size being set to 16.
> > >
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Reported-by: Wei Wang <weiwan@google.com>
> > > Cc: Tariq Toukan <tariqt@nvidia.com>
> > > ---
> > >   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 16 ++++++++++++----
> > >   1 file changed, 12 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > > index 7cc288db2a64f75ffe64882e3c25b90715e68855..120b8c361e91d443f83f100a1afabcabc776a92a 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > > +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > > @@ -89,8 +89,18 @@
> > >   #define MLX4_EN_FILTER_HASH_SHIFT 4
> > >   #define MLX4_EN_FILTER_EXPIRY_QUOTA 60
> > >
> > > -/* Typical TSO descriptor with 16 gather entries is 352 bytes... */
> > > -#define MLX4_TX_BOUNCE_BUFFER_SIZE 512
> > > +#define CTRL_SIZE    sizeof(struct mlx4_wqe_ctrl_seg)
> > > +#define DS_SIZE              sizeof(struct mlx4_wqe_data_seg)
> > > +
> > > +/* Maximal size of the bounce buffer:
> > > + * 256 bytes for LSO headers.
> > > + * CTRL_SIZE for control desc.
> > > + * DS_SIZE if skb->head contains some payload.
> > > + * MAX_SKB_FRAGS frags.
> > > + */
> > > +#define MLX4_TX_BOUNCE_BUFFER_SIZE (256 + CTRL_SIZE + DS_SIZE +              \
> > > +                                 MAX_SKB_FRAGS * DS_SIZE)
> > > +
> > >   #define MLX4_MAX_DESC_TXBBS    (MLX4_TX_BOUNCE_BUFFER_SIZE / TXBB_SIZE)
> > >
> >
> > Now as MLX4_TX_BOUNCE_BUFFER_SIZE might not be a multiple of TXBB_SIZE,
> > simple integer division won't work to calculate the max num of TXBBs.
> > Roundup is needed.
>
> I do not see why a roundup is needed. This seems like obfuscation to me.
>
> A divide by TXBB_SIZE always "works".
>
> A round up is already done in mlx4_en_xmit()
>
> /* Align descriptor to TXBB size */
> desc_size = ALIGN(real_size, TXBB_SIZE);
> nr_txbb = desc_size >> LOG_TXBB_SIZE;
>
> Then the check is :
>
> if (unlikely(nr_txbb > MLX4_MAX_DESC_TXBBS)) {
>    if (netif_msg_tx_err(priv))
>        en_warn(priv, "Oversized header or SG list\n");
>    goto tx_drop_count;
> }
>
> If we allocate X extra bytes (in case MLX4_TX_BOUNCE_BUFFER_SIZE %
> TXBB_SIZE == X),
> we are not going to use them anyway.

I guess you are worried about not having exactly 256 bytes for the headers ?

Currently, the amount of space for headers is  208 bytes.

If MAX_SKB_FRAGS is 17,  MLX4_TX_BOUNCE_BUFFER_SIZE would be 0x230
after my patch,
so the same usable space as before the patch.
