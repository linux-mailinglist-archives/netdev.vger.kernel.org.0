Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285182675F8
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgIKWex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgIKWeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:34:37 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF6BC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:34:36 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id p65so9192505qtd.2
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oTo2OCNMVcYHp/536Sikw4aYTAdaxfLiOS6ZTWNK+4Q=;
        b=YdlCkMsBT2tvRKr8wEpYjsPoVA1rBsJ5zZfOJkDS0GtyFl2JtnVmM4V8YH0K4P37fK
         rVSajybISXwIR0Lxwi5G3A+jYT9UEGNvxX4t+kY8z9StWfepIwrlr0ojZkqkPZX3RqUi
         KH9Tnw0fKo4QAtYVFoVs5i9sS57PH4GYHPSi8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oTo2OCNMVcYHp/536Sikw4aYTAdaxfLiOS6ZTWNK+4Q=;
        b=o7A10vpj+veJTnDLtG7k8ItvPOa+HPeoKNFKwRIfsOyts/jY1zXCEvV/cy4IXWZYnf
         fJRlWugs5Vz5CNC9BatRLfmN+Q4ELb+0vAJEIvaGT/rHLa7zXdu8GgLGegUkckpi/T+y
         bxOZ6T6Z4YxMQfjMGLJDqmKXVtkiPMw9wrlAhemjxd4zccyMEMAvUVL0R2hl1McJ0SyJ
         MLmLM2g7+FAdWyrl9Ug4spOH+4hjUEMfgD5r2z2TlOTXwgBFk9oiJpMtYlHoiWEWEt8n
         JYUAhmHl70S+KpvJGuQxEbz96tOCwAJkX6fqjyBnlObstBq8dGOmApVhdqR1g6dt6pel
         rpzg==
X-Gm-Message-State: AOAM532YMY5S/wHRutygmjXJ1FHPkxAkFgmCqIyQrvgCHkQWA23+hw57
        B2aBK17RB1BgXCKFOCrAVtLAOpeEv26NglvKJ2Asog==
X-Google-Smtp-Source: ABdhPJwG8zKRUM1vD2UkaY68n4hN3HAHOh2UNY9nt1eHQtoB6TTjAZ1gSFrE4SrZQfA+wHV2GSZexGZRQeheKtHryx4=
X-Received: by 2002:ac8:319d:: with SMTP id h29mr3968235qte.32.1599863675372;
 Fri, 11 Sep 2020 15:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200911195258.1048468-1-kuba@kernel.org> <20200911195258.1048468-6-kuba@kernel.org>
In-Reply-To: <20200911195258.1048468-6-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 11 Sep 2020 15:34:24 -0700
Message-ID: <CACKFLin6F=Y0jrJZqA75Oa+QwCyAyHK06_QnuB54-WwOqpG8MA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/8] bnxt: add pause frame stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, mkubecek@suse.cz,
        tariqt@nvidia.com, saeedm@nvidia.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> These stats are already reported in ethtool -S.
> Hopefully they are equivalent to standard stats?

Yes.

>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index d0928334bdc8..b5de242766e3 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -1778,6 +1778,24 @@ static void bnxt_get_pauseparam(struct net_device *dev,
>         epause->tx_pause = !!(link_info->req_flow_ctrl & BNXT_LINK_PAUSE_TX);
>  }
>
> +static void bnxt_get_pause_stats(struct net_device *dev,
> +                                struct ethtool_pause_stats *epstat)
> +{
> +       struct bnxt *bp = netdev_priv(dev);
> +       struct rx_port_stats *rx_stats;
> +       struct tx_port_stats *tx_stats;
> +
> +       if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
> +               return;
> +
> +       rx_stats = (void *)bp->port_stats.sw_stats;
> +       tx_stats = (void *)((unsigned long)bp->port_stats.sw_stats +
> +                           BNXT_TX_PORT_STATS_BYTE_OFFSET);
> +
> +       epstat->rx_pause_frames = rx_stats->rx_pause_frames;
> +       epstat->tx_pause_frames = tx_stats->tx_pause_frames;

This will work, but the types on the 2 sides don't match.  On the
right hand side, since you are casting to the hardware struct
rx_port_stats and tx_port_stats, the types are __le64.

If rx_stats and tx_stats are *u64 and you use these macros:

BNXT_GET_RX_PORT_STATS64(rx_stats, rx_pause_frames)
BNXT_GET_TX_PORT_STATS64(tx_stats, tx_pause_frames)

the results will be the same with native CPU u64 types.

Thanks.
