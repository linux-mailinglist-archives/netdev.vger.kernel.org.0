Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB987267632
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgIKWxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgIKWxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:53:37 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D336C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:53:36 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id p65so9219978qtd.2
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tbSfTA2B1q8DKieRfmbXUaBYmr3tA7346DF0RnGZ3do=;
        b=f3Wk0r8kOiJyyar1UNt3HcsAlRZX38BK6064C9IJovR4pxXa82qHmMXfcqjlkZZVvS
         XBgB8mSrMbuSfud9yw1Z2R7iFa2vDd8Wpp4sOg7PHaRz2B3z+A/7o4fVvj8AkUIoXSOm
         PVry7B58ceVkVewlKjmwTosXe6TtFIQr/ftEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tbSfTA2B1q8DKieRfmbXUaBYmr3tA7346DF0RnGZ3do=;
        b=a77/JkRtToU7/wKdyxKuIORYY5WJDJLaIuFOyMGuuZu+VP40aAMhm0Vw4X4CKUyKY8
         cGqT1kDP9/FsHTgo5T7SenBYRrlpjj6ZUwb0qk4a0Any+sweRDYNxBOoPVO/1wS9Bh4v
         +SovUTXaVUutpohyNu66ndyKxyOT5hDgot8wVdTJ+JTK3kWNP2WLgTxmE7/zs4INLDZy
         wLgyh+yCgcVwyhwZqKmc6cJ+Hl2zKxVSKsaNxCKt++3BTmLq1Hkye6cpRxnzXHW0UFz9
         cwQHdaQQZv9UB1xWDentxvX1FrWe0VUDb52lEq75J3YIWLPvo2BqvHwfXKgAlHpVzHOy
         Q/UA==
X-Gm-Message-State: AOAM532530pfJlDx+gmaV7LDVf0GXEE6rMcOpUe5RamJrl2Ov9unFAFl
        qghkrdueQh8RmZnGO5RogZ6TKYuSuBtSZhefEGA19Q==
X-Google-Smtp-Source: ABdhPJxthc5cIWRPWG+AKOw6+352fnmkH/BrKBKQ3kk7fr1jDJMY7uy+aH2ZQYxjIP7ROTdG7AQaa2T6G0NXJpE/nEw=
X-Received: by 2002:ac8:3fcb:: with SMTP id v11mr4114993qtk.80.1599864815735;
 Fri, 11 Sep 2020 15:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200911195258.1048468-1-kuba@kernel.org> <20200911195258.1048468-6-kuba@kernel.org>
 <CACKFLin6F=Y0jrJZqA75Oa+QwCyAyHK06_QnuB54-WwOqpG8MA@mail.gmail.com> <20200911154343.2a319485@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911154343.2a319485@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 11 Sep 2020 15:53:24 -0700
Message-ID: <CACKFLikDO9+BaJBz+=VBPq7syXkGqgJsRnc8oat=wWO7Fhttmg@mail.gmail.com>
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

On Fri, Sep 11, 2020 at 3:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 11 Sep 2020 15:34:24 -0700 Michael Chan wrote:
> > On Fri, Sep 11, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > These stats are already reported in ethtool -S.
> > > Hopefully they are equivalent to standard stats?
> >
> > Yes.
> >
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > >  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 19 +++++++++++++++++++
> > >  1 file changed, 19 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > index d0928334bdc8..b5de242766e3 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > @@ -1778,6 +1778,24 @@ static void bnxt_get_pauseparam(struct net_device *dev,
> > >         epause->tx_pause = !!(link_info->req_flow_ctrl & BNXT_LINK_PAUSE_TX);
> > >  }
> > >
> > > +static void bnxt_get_pause_stats(struct net_device *dev,
> > > +                                struct ethtool_pause_stats *epstat)
> > > +{
> > > +       struct bnxt *bp = netdev_priv(dev);
> > > +       struct rx_port_stats *rx_stats;
> > > +       struct tx_port_stats *tx_stats;
> > > +
> > > +       if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
> > > +               return;
> > > +
> > > +       rx_stats = (void *)bp->port_stats.sw_stats;
> > > +       tx_stats = (void *)((unsigned long)bp->port_stats.sw_stats +
> > > +                           BNXT_TX_PORT_STATS_BYTE_OFFSET);
> > > +
> > > +       epstat->rx_pause_frames = rx_stats->rx_pause_frames;
> > > +       epstat->tx_pause_frames = tx_stats->tx_pause_frames;
> >
> > This will work, but the types on the 2 sides don't match.  On the
> > right hand side, since you are casting to the hardware struct
> > rx_port_stats and tx_port_stats, the types are __le64.
> >
> > If rx_stats and tx_stats are *u64 and you use these macros:
> >
> > BNXT_GET_RX_PORT_STATS64(rx_stats, rx_pause_frames)
> > BNXT_GET_TX_PORT_STATS64(tx_stats, tx_pause_frames)
> >
> > the results will be the same with native CPU u64 types.
>
> Thanks! My build bot just poked me about this as well.
>
> I don't see any byte swaps in bnxt_get_ethtool_stats() -
> are they not needed there? I'm slightly confused.

No, swapping is not needed since we are referencing the sw_stats.
Every counter has already been swapped when we did the copy and
overflow check from the hw struct to sw_stats.  sw_stats is exactly
the same as the hw struct except that every counter is already swapped
into native CPU u64 and properly adjusted for overflow.
