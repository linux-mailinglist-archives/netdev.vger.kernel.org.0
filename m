Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99302214DAC
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGEPea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgGEPea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:34:30 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25944C061794;
        Sun,  5 Jul 2020 08:34:30 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k4so30215963oik.2;
        Sun, 05 Jul 2020 08:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5HJIdd7gKlD53rdhkJtd0Sa3kCw7Ak/DxXpdwM9MXZM=;
        b=dl9FtyNp4AIe7c4jh3KeUdz1KrBSELg99uF8Z5iTiUO19NkyfKaAIP+LkaP0iJ1xka
         nJcy86ERAxvU1YDqYNDVvZqoSE0LCB44J05s9u3UE9FiSZVO7RfmMZClugEUceOrvIoQ
         KZ3F+45dZgECnzPvAD0pUhg1qTDj1AgR1j9DREnzv+yNOr9fqEwVGkgG2FJcTIeG/J6q
         qKSKuF+Ph9xsU31hXSdgJ3MAZvdUf0gFd7iEnTvgWB7l5LjB8XLMZ+LHI5yplbAQmNZE
         cwubV30g3SqxGBKbt9p5XVzpo2q0VnQXiP6Hjmk7QmUT8he5wQxs9y5PmrF/wM9V87AT
         RCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5HJIdd7gKlD53rdhkJtd0Sa3kCw7Ak/DxXpdwM9MXZM=;
        b=iCSRuOaZ0/MJ95dy0BjTV87Ts4n1IwE6vlxoZGSaD1XHIjTuUamdrHLZzcO9vb0T6x
         K6uyJ/FkLSV4cHcPFxSS5rjWoMAv5aaQT6QLbiw+9F9sLYPpkZFE1ZvzrbnZE4dUmzUp
         Yj3htLxlssQYpr7madsh/cZj50dhHLH0RnGHiJY+tamxKE4lKZHdqV4tsoO1B9ngIkMx
         L8jD/23jTUuftyGBUtYa2eDXLwGLiDzP0APRPFB/O0720o0ec81P/LQxOvDVPD6zPHGy
         95dNIz0NhSvpt+L3ViAjnzuyHXHPoE8KZ4jQjtgek7bMOnwfPOcMkJaEDGgEw7AUerb/
         sAdg==
X-Gm-Message-State: AOAM532lt5dAK2+LOsERgGYr1dmhrYFCavOMlPvKi30FHGSACizQE423
        cQKasVLk0v3TzGtyYXdXO0uRiimE4BCYHLJZpn8=
X-Google-Smtp-Source: ABdhPJyyJZ77mDPIvsdV6TjKCH4oypKdCmfebWnB6v2kvJ4ptKycucICKlPQEGgCMRGl1AaCgA67EhIwQCEJ5Z5YgyQ=
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr31219068oih.92.1593963269320;
 Sun, 05 Jul 2020 08:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200702175352.19223-1-TheSven73@gmail.com> <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com> <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sun, 5 Jul 2020 11:34:18 -0400
Message-ID: <CAGngYiWc8rNVEPC-8GK1yH4zXx7tgR9gseYaopu9GWDnSG1oyg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, thank you so much for your time and attention. See below.

On Sun, Jul 5, 2020 at 10:45 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> Don't consider it complex, GPR5[9] just select the rgmii gtx source from =
PAD or internal
> Like=EF=BC=9A
> GPR5[9] is cleared: PAD -> MAC gtx
> GPR5[9] is set: Pll_enet -> MAC gtx
> As you said, register one clock mux for the selection, assign the clock p=
arent by board dts
> file, but now current clock driver doesn't support GPR clock.

Ok, so for imx6q plus only, we create two new clocks (MAC_GTX and PAD)
and a new clock mux, controlled by GPR5[9]:

  enet_ref-o------>ext>---pad------| \
           |                       |M |----mac_gtx
           o-----------------------|_/

Where M =3D mux controlled by GPR5[9]

clk_mac_gtx -> clk_pad -> clk_enet_ref is the default. when a board
wants internal routing, it can just do:

&fec {
assigned-clocks =3D <&clks IMX6QDL_CLK_MAC_GTX>;
assigned-clock-parents =3D <&clks IMX6QDL_CLK_ENET_REF>;
};

But, how do we manage clk_pad? It is routed externally, and can be
connected to:
- enet_ref (typically via GPIO_16)
- an external oscillator
- an external PHY clock

  ext phy---------| \
                  |  |
  enet_ref-o------|M |----pad------| \
           |      |_/              |  |
           |                       |M |----mac_gtx
           |                       |  |
           o-----------------------|_/


How do we tell the clock framework that clk_pad has a mux that can
be connected to _any_ external clock? and also enet_ref?
