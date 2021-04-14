Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B734E35F907
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351800AbhDNQdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhDNQds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:33:48 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5086DC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:33:24 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f17so27176871lfu.7
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v+IVNuBBZoNiK9hvyTQ8YjtQe7halQe48d5jPUOcEkk=;
        b=I8OZWdG/hEWao7+psZy0KtjWYoVGPfIlqvvmT1ZY6YOCxXWrMFaTjaGU0D68384Z/u
         5SVKIyweP3GVKiJTSbU9bygHuqrFWoIP2pjDOt4sUquZuxTSzWruL7LBk22t0adHi6Jf
         qJqDs4gSWSCBFV0eD7iBimPosdYZk/YXAI6IkclAf2mfqW+ZId8p/oEHTX44QO6nmbW/
         IJJtEoHPPf7vWbZJcWubYZyD+2/erSbasjJnRts6+jjb3tkwFxSRUM7adbjmgascCv6R
         5xBmUu35XGlZHVw76JZTuzZUR6KucxpmZf0HQ7ZhASn1N+WpxGEyFffNUPDElN93Q4w9
         J+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v+IVNuBBZoNiK9hvyTQ8YjtQe7halQe48d5jPUOcEkk=;
        b=izqVxFnjSvAzUa7Eb8K6Nq4nNxaH/u7aY/0ZWkWB54LrliMYOjG7hXPNqMuArqF6o+
         TD9zgaKnzUBL6ETOWAKYSHUyvTG3BzS6jIKaBRohKHN4WYYzUJBRbR4aPoW8i+mHhx0q
         8Si99hrZFOqPbo94G3qJq8NxT02phhUkfkA9o41wdrEd7A53RM2OWZK4fJyy8BNNXj2P
         9tcbnrJ8+tm0FaSOEaFWd8CZHVE1nIJBaZiUHlouIMMGu9BGcBK8ZGhhPljYMjD0723t
         lXa7fDdPdViijXim9teiuX2aHGW8pzaJ0HiW7xGkkRtZl3XuHx7XzHUK+uLgvhz+Emnu
         lLgA==
X-Gm-Message-State: AOAM531VMz0j0CvO08e2UT8D1Z3MKycvKacfE4Dpn+Om962VN9j54Vd4
        +A3KECfiwCsv2jXrP+Y14+h0gZT5l7eDi0L1pVM=
X-Google-Smtp-Source: ABdhPJxhYCmRcHVaIfYbTT2Dd4NaeVzYGwLcqQxiyhMAvY/ztNVwUlAgtQyMS1Ic6glPyPYDIEDZH4Vr3HPklvu0Uyw=
X-Received: by 2002:a05:6512:23a3:: with SMTP id c35mr5046637lfv.618.1618418002676;
 Wed, 14 Apr 2021 09:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdYzYpv0dvz4X2JE4J6Qg-5D9mnkqe5RpiRC845wQpZhDKDPA@mail.gmail.com>
 <1412-60762b80-423-d9eaa5@27901112> <CAMdYzYpyD1bTN+3Zaf4nGnN-O-c0u0koiCK45fLucL0T2+69+w@mail.gmail.com>
 <2596687.TLnPLrj5Ze@diego> <16102d157576bfa7be341ed7508e70d930e40bab.camel@collabora.com>
In-Reply-To: <16102d157576bfa7be341ed7508e70d930e40bab.camel@collabora.com>
From:   Chen-Yu Tsai <wens213@gmail.com>
Date:   Thu, 15 Apr 2021 00:33:12 +0800
Message-ID: <CAGb2v67ZBR=XDFPeXQc429HNu_dbY__-KN50tvBW44fXMs78_w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Add RK3566/RK3568 SoC support
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 12:14 AM Ezequiel Garcia <ezequiel@collabora.com> w=
rote:
>
> Hi Peter, Heiko,
>
> On Wed, 2021-04-14 at 13:15 +0200, Heiko St=C3=BCbner wrote:
> > Am Mittwoch, 14. April 2021, 13:03:25 CEST schrieb Peter Geis:
> > > On Tue, Apr 13, 2021 at 7:37 PM Ezequiel Garcia <ezequiel@collabora.c=
om> wrote:
> > > > > > +static void rk3566_set_to_rmii(struct rk_priv_data *bsp_priv)
> > > > > > +{
> > > > > > +       struct device *dev =3D &bsp_priv->pdev->dev;
> > > > > > +
> > > > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > > > +               dev_err(dev, "%s: Missing rockchip,grf property=
\n", __func__);
> > > > > > +               return;
> > > > > > +       }
> > > > > > +
> > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RMII);
> > > > > > +}
> > > > > > +
> > > > > > +static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
> > > > > > +                               int tx_delay, int rx_delay)
> > > > > > +{
> > > > > > +       struct device *dev =3D &bsp_priv->pdev->dev;
> > > > > > +
> > > > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > > > +               dev_err(dev, "Missing rockchip,grf property\n")=
;
> > > > > > +               return;
> > > > > > +       }
> > > > > > +
> > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
> > > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > > > +
> > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON0,
> > > > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > > > > +
> > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > > > +
> > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
> > > > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > > >
> > > > > Since there are two GMACs on the rk3568, and either, or, or both =
may
> > > > > be enabled in various configurations, we should only configure th=
e
> > > > > controller we are currently operating.
> > >
> > > Perhaps we should have match data (such as reg =3D <0>, or against th=
e
> > > address) to identify the individual controllers.
> >
> > Hmm, "reg" will be used by the actual mmio address of the controller,
> > so matching against that should be the way I guess.
> >
> > We're already doing something similar for dsi:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c#n1170
> >
>
> I have to admit, I'm not a fan of hardcoding the registers in the kernel.
>
> David Wu solved this in the downstream kernel by using bus_id,
> which parses the devicetree "ethernet@0" node, i.e.:
>
>   plat->bus_id =3D of_alias_get_id(np, "ethernet");

What happens when one adds another ethernet controller (USB or PCIe) to
the board and wants to change the numbering order?

Or maybe only the second ethernet controller is routed on some board
and the submitter / vendor wants that one to be ethernet0, because
it's the only usable controller?

This seems even more fragile than hardcoding the registers.

Regards
ChenYu
