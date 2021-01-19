Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1322FC353
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbhASWYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbhASWYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:24:24 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4114AC061575;
        Tue, 19 Jan 2021 14:23:43 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p72so18211526iod.12;
        Tue, 19 Jan 2021 14:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMd4G6Vw+iokzlycIBszbMWea4hqYJQXqXCw+KiiIAo=;
        b=vONKQuqSeYLNbI0hx++5jXZ9CVRE4w+KkUnZYocBO8H0WtHln+qkHIzoY+EDJ0ck1P
         SO1GdgosqsPYY6kejJkbnFKYDuMwJmVGUOXtwjkiU8Xt9x2bPX0C0hOZabO5jJoB2Qim
         n85Qd2XJHrmEGFAgHjsOEQcT6RiydxnJ7uzSNjDn2O7DoRdAbRA7l9du4ueWlCkK+1Cb
         mTkPz4YYAC6B/bFqnPAfd7f4DHiesxoTy9sVQqxME137nxLS5Ug+EoKAuMP7i9hU2bOu
         YpzWeWS8JA21ZUrscWb0YogjsRanzFXc08DlNpRpQ0kcU8uqpj2f8QPyB9iQwLlmK2ZP
         Rahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMd4G6Vw+iokzlycIBszbMWea4hqYJQXqXCw+KiiIAo=;
        b=nVBzf/ZYO8cExPWaiet+Oj9g8KL4bmiysIMXv0Cc4gTOcVe+SgYLFmR+dfNGdIeeqf
         pLAjZRiywfD7rFAHjBr3PWJrEZzwEnwedAWKsmGJYJOz+g+GDHgKeIwlsZtSmgQ9JQBg
         2SLdS49pA2xAOKcXvhinkXU3JWX7lsXhHp1N+uHUVkdmD/lWos5k8k6VHucBF9jq/Ded
         UQnFUUJ8MbW6grOkVqn6hfWG/PBwc28nIC5PxIGSaKze//cwCeK3NGFuR1cadnYEjLzo
         Dm06a3FWEytyTQUsqAo01zGlSZcJfj1YEzo0PZmN+6gGTgsCjDoLzxkR+5tSG9ublYEe
         LF+g==
X-Gm-Message-State: AOAM532Ial1P07FhnYSYjnsYfyWQAy8DHy0yQgOKGHUze0dfjpEM84Cz
        CQGXjPM9OxEB1cbEntlsWZBKfhd4rrmDahoyz/4=
X-Google-Smtp-Source: ABdhPJwQqyhnQXHUQZu0t9aXfZLVUu9i99yt3aQohHcdEu+bmP71nZHwmE+1DwfmULPKfKxtFsUpF3mGkdFdXl3dcao=
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr5146752ilt.42.1611095022624;
 Tue, 19 Jan 2021 14:23:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610777159.git.lucien.xin@gmail.com> <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:23:31 -0800
Message-ID: <CAKgT0UduX4M-N1Kyo-M2=05EO_rAs2c_CDrUwWMKk2oDOgxd2Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] net: add inline function skb_csum_is_sctp
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 10:13 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patch is to define a inline function skb_csum_is_sctp(), and
> also replace all places where it checks if it's a SCTP CSUM skb.
> This function would be used later in many networking drivers in
> the following patches.
>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

One minor nit. If you had to resubmit this I might move the ionic
driver code into a separate patch. However It can probably be accepted
as is.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 +-
>  include/linux/skbuff.h                           | 5 +++++
>  net/core/dev.c                                   | 2 +-
>  3 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> index ac4cd5d..162a1ff 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> @@ -979,7 +979,7 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
>                 stats->vlan_inserted++;
>         }
>
> -       if (skb->csum_not_inet)
> +       if (skb_csum_is_sctp(skb))
>                 stats->crc32_csum++;
>         else
>                 stats->csum++;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index c9568cf..46f901a 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4621,6 +4621,11 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
>  #endif
>  }
>
> +static inline bool skb_csum_is_sctp(struct sk_buff *skb)
> +{
> +       return skb->csum_not_inet;
> +}
> +
>  static inline void skb_set_kcov_handle(struct sk_buff *skb,
>                                        const u64 kcov_handle)
>  {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0a31d4e..bbd306f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3617,7 +3617,7 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
>  int skb_csum_hwoffload_help(struct sk_buff *skb,
>                             const netdev_features_t features)
>  {
> -       if (unlikely(skb->csum_not_inet))
> +       if (unlikely(skb_csum_is_sctp(skb)))
>                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
>                         skb_crc32c_csum_help(skb);
>
> --
> 2.1.0
>
