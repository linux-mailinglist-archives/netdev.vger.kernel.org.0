Return-Path: <netdev+bounces-6756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C000F717CFE
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1858281473
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC2E13AD7;
	Wed, 31 May 2023 10:16:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981CED2F6;
	Wed, 31 May 2023 10:16:26 +0000 (UTC)
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFFB10E;
	Wed, 31 May 2023 03:16:24 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-6260adf44daso8437186d6.1;
        Wed, 31 May 2023 03:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685528184; x=1688120184;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6ouue5IsJewxZcqyzngzCLx+A1R2cc7DroC8/ReaYIA=;
        b=q7lB4WDRaJLozHwEeHv/4jbn6TIrHQNpAHY1zqtaDPjwSc9Z2GkqzPH/bLqHoRgSI9
         FDeoqDhzhKXNAqlnjbpUbadcRqM8Mfu59lDp7YYalb147/wn/RNKbWGiLRIxyfkYtNpH
         nzTO8c/3eMucEZO2MgjAIv9xW0DAtQVnGTIMpvHRJEDUCPTR1JPV7aB8FFkOvFd65Yj7
         l4cJYQxeggpcOmf5wtheuJSU0OpTUGonqvdf/mYBImxOM0NVNNyeO7AffC/X1sPeFa7F
         eXqTv9G/S07TwkVt4kMUamK0VKj6cm2Qi+Rt9ngvyDznVsRy48Cv6igZhTcHzmCK15s4
         Scpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685528184; x=1688120184;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ouue5IsJewxZcqyzngzCLx+A1R2cc7DroC8/ReaYIA=;
        b=d++epVuYzm7b4FpuU9F6UBKX/kXpnxvgk52oS00Cei7wH4qmKNycJzFI1Am5U6GPQ5
         lxYqsXFlDOtmrJQ25hnlOGfP0pKbOhxtxWOgdEPLKjTG5HmX9wMVAAwkzIhv9QFc9Rqb
         /iXwet2AvQG5RIH8vr49XHuv11cD1HtjiOAjHGKlWIsV90S3Ol7fqnHTEcdnwYy23V+o
         uDgESKxqb6MRVzSzumWh1ptghf4XYXsuUYeq31xdv5ZLtLyDBwqpfwFKS520+LYC/3HH
         dZ1sHtjYVJEe9lvj2ieUeiwmW3U6NArNF+WHJBv2/YgowXbGHGt8NWIw/YUObNkaFas5
         0Rig==
X-Gm-Message-State: AC+VfDyXqPuaTy/oMupAg68JQ+Ezg/cf9MJ76g7j0LH7HATQk05xyWQL
	UDGpMmc6GW1UZhyCQfBS7/KqTdHUMuUNrXAUOqrsNrz+Ut/GITpQ
X-Google-Smtp-Source: ACHHUZ5nJFyjdUTnnf2JW7HgSXWRoRMfXz6yMQ/eXD+cDlKxw9hYvPd4b2Yw5SVwMt/y4CxHqVW8XoWlKMrrFAPYHkw=
X-Received: by 2002:ad4:5966:0:b0:61b:76dd:b643 with SMTP id
 eq6-20020ad45966000000b0061b76ddb643mr1556283qvb.4.1685528184000; Wed, 31 May
 2023 03:16:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com> <20230529155024.222213-14-maciej.fijalkowski@intel.com>
In-Reply-To: <20230529155024.222213-14-maciej.fijalkowski@intel.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Wed, 31 May 2023 12:16:13 +0200
Message-ID: <CAJ8uoz1qa-XgntqSUtwjU_vCajDAbZqYgEVSajZxidmpG0cOFQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 13/22] xsk: report ZC multi-buffer capability
 via xdp_features
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, netdev@vger.kernel.org, magnus.karlsson@intel.com, 
	bjorn@kernel.org, tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 29 May 2023 at 17:57, Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Introduce new xdp_feature NETDEV_XDP_ACT_NDO_ZC_SG that will be used to
> find out if user space that wants to do ZC multi-buffer will be able to
> do so against underlying ZC driver.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  include/uapi/linux/netdev.h | 4 ++--
>  net/xdp/xsk_buff_pool.c     | 6 ++++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index 639524b59930..bfca07224f7b 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -33,8 +33,8 @@ enum netdev_xdp_act {
>         NETDEV_XDP_ACT_HW_OFFLOAD = 16,
>         NETDEV_XDP_ACT_RX_SG = 32,
>         NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> -
> -       NETDEV_XDP_ACT_MASK = 127,
> +       NETDEV_XDP_ACT_NDO_ZC_SG = 128,

Since this flag has nothing to do with an NDO, I would prefer the
simpler NETDEV_XDP_ACT_ZC_SG. What do you think?

> +       NETDEV_XDP_ACT_MASK = 255,
>  };
>
>  enum {
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 0a9f8ea68de3..43cca5fa90cf 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -189,6 +189,12 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>                 goto err_unreg_pool;
>         }
>
> +       if (!(netdev->xdp_features & NETDEV_XDP_ACT_NDO_ZC_SG) &&
> +           flags & XDP_USE_SG) {
> +               err = -EOPNOTSUPP;
> +               goto err_unreg_pool;
> +       }
> +
>         bpf.command = XDP_SETUP_XSK_POOL;
>         bpf.xsk.pool = pool;
>         bpf.xsk.queue_id = queue_id;
> --
> 2.35.3
>
>

