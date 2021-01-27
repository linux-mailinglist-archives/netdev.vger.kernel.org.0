Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147413050EE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbhA0Eal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhA0CzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 21:55:11 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AD5C06178A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 18:17:26 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ox12so517562ejb.2
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 18:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Px6CF6fv6xR+35dat/DxPNwYvbDtyDvPg05jiglxqHo=;
        b=ppAvg/Kg7GDfglm1zsf2JjZfRpLW2NeZrQz3XXHDWqiB+dAoDJeSk4dMZAd5dbxG/0
         3LOWRTyG0/BVIDX6hovztOkSs1s3XLQiW4zYnh7MshElVj5jY8kQCIvRyEMxuaYZR4Eh
         e/dPT0LfQKc3rhs1ecTB5bYJ6TmrV5ieiYhVxI7JPTpTGihDyjRE4yN+sMbyXSp/n3Od
         xDM7N6lz1kuID1ZiWfq6AbrltRJcrrDPsstz77t8Tt9m/PLz8+0+K1bHwsMAmzYO7XAL
         VwMf5eXgKCR5QFWc5DQMP1KcVIr1dEE4CpNAhmaepYgbo+6qYZAFDwMIuxK+l0SocuqG
         uDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Px6CF6fv6xR+35dat/DxPNwYvbDtyDvPg05jiglxqHo=;
        b=PGCxZxJBDr5/DY52+3aefO2d5L1uNp98eV1hXPYkNkJY+VUIvNBSYWS4o+6zG0l5Ye
         VL7z5UHN+54vkcJI0F8j9UIAyudA3lrhuH88WzpfnswtOiXvCFJwLOjGStTYMx27dkn3
         AsA13ZasaUby8E3pVA3n1PbxsbXgl2p81Gf6qVdhpL4sWLDBFzIbMPEPsOCJzDiBMeHn
         DiUWZT78JoP9Y6JtRFUvsEV1HmvkMPAMleN2UmIWGNXLZdtM5oL3nKa6M6nX5g3ovbmW
         BD+NylFl+IL9O/TQ0QqpT3ceMxVHjD+nTTRJ0Q+8dKVMPnfRJJx9XQoIec3lMkMBqQC4
         tlQw==
X-Gm-Message-State: AOAM532Laa84gW8mZLH6Wg7J4wIH/FLNJJhodlvUNZTYkPWR6Q1YWgnT
        eyW/nJgf22DyGeT3z0kAVI+jOOfYOZ/cB+tohVbHTrJs
X-Google-Smtp-Source: ABdhPJw2/aAif+cw1cOCoxEPWlSpAJpqfBsICX3q/4D0m/Y8pYvDWo199NfaorEeB5AXGLea5ruD4DyJe74ZkGuHv4c=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr5319479ejd.119.1611713845382;
 Tue, 26 Jan 2021 18:17:25 -0800 (PST)
MIME-Version: 1.0
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
 <20210126115854.2530-3-qiangqing.zhang@nxp.com> <CAF=yD-JEU2oSy11y47TvgTr-XHRNq7ar=j=5w+14EUSyLj7xHA@mail.gmail.com>
 <DB8PR04MB6795C4AFFBC2CC1FB189F1FBE6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795C4AFFBC2CC1FB189F1FBE6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 26 Jan 2021 21:16:48 -0500
Message-ID: <CAF=yD-LFvdfE3kwt3=CNJ5iy7tGLkbk3Ytg8NAESd6v4H+Gn+w@mail.gmail.com>
Subject: Re: [PATCH V3 2/6] net: stmmac: stop each tx channel independently
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 8:44 PM Joakim Zhang <qiangqing.zhang@nxp.com> wrot=
e:
>
>
> > -----Original Message-----
> > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Sent: 2021=E5=B9=B41=E6=9C=8827=E6=97=A5 7:10
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> > <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>; David
> > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Network
> > Development <netdev@vger.kernel.org>; dl-linux-imx <linux-imx@nxp.com>;
> > Andrew Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>
> > Subject: Re: [PATCH V3 2/6] net: stmmac: stop each tx channel independe=
ntly
> >
> > On Tue, Jan 26, 2021 at 7:03 AM Joakim Zhang <qiangqing.zhang@nxp.com>
> > wrote:
> > >
> > > If clear GMAC_CONFIG_TE bit, it would stop all tx channels, but users
> > > may only want to stop secific tx channel.
> >
> > secific -> specific
>
> Thanks. Will correct it.
>
> > >
> > > Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
> > > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > ---
> > >  drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 4 ----
> > >  1 file changed, 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> > > b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> > > index 0b4ee2dbb691..71e50751ef2d 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> > > @@ -53,10 +53,6 @@ void dwmac4_dma_stop_tx(void __iomem *ioaddr,
> > u32
> > > chan)
> > >
> > >         value &=3D ~DMA_CONTROL_ST;
> > >         writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
> > > -
> > > -       value =3D readl(ioaddr + GMAC_CONFIG);
> > > -       value &=3D ~GMAC_CONFIG_TE;
> > > -       writel(value, ioaddr + GMAC_CONFIG);
> >
> > Is it safe to partially unwind the actions of dwmac4_dma_start_tx
> >
> > And would the same reasoning apply to dwmac4_(dma_start|stop)_rx?
>
> Sorry, I am not quite understand what you means.
>
> What this patch did is to align to dwmac4_(dma_start|stop)_rx.
>
> dwmac4_dma_start_rx: assert DMA_CONTROL_SR bit for each channel, and asse=
rt GMAC_CONFIG_RE bit which targets all channels.
> dwmac4_dma_stop_rx: only need clear DMA_CONTROL_SR bit for each channel.
>
> After this patch applied:
> dwmac4_dma_start_tx: assert DMA_CONTROL_ST bit for each channel, and asse=
rt GMAC_CONFIG_TE bit which targets all channels.
> dwmac4_dma_stop_tx: only need clear DMA_CONTROL_ST bit for each channel.

Oh indeed. Sorry, I should have seen that it exactly brings the tx
logic into agreement with rx. Thanks.
