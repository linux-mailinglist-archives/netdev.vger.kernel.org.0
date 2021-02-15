Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EBA31B655
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhBOJXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhBOJXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 04:23:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07AE364E02;
        Mon, 15 Feb 2021 09:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613380957;
        bh=xd8bZcaDbO5f52i56dPShfWe0KatiGLNJgnknX+pjYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXDLCGaUD+eHBlXw3jpImAWESxqz+GW25G/L1KTcErrsJ05Mr3vNnQUoTwcFRpFN8
         IhFv9Gu9Nk7GUGaD3gT8JU3rhuuSCSds1EnPCnjIsGISPsGGs18+jjx6cPvAZmZrSm
         qTXDTQzjlGcFolDd+8yI/BeucmgrspgHEZkhpkPK6oq8QR9W6j5/UUv/Nso9VszZYS
         ep1kT8I1LC6+HzCPedCLJw0KRiOYnEWDo2iS805a0I2/5+POJ/hbExstsuXaRg5ZPG
         x1c6Ro/1Vdm/ZQ/qhrcysbc72nYb3BPFUJzdhzkaZzQfgf+xnMv57QCAM3Zea/SoB1
         XW0opUOYxxLsw==
Date:   Mon, 15 Feb 2021 11:22:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, arnd@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Message-ID: <YCo9WVvtAeozE42k@unreal>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp>
 <YCoPmfunGmu0E8IT@unreal>
 <20210215072809.n3r5rdswookzri6j@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215072809.n3r5rdswookzri6j@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 04:28:09PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
>
> Thanks for your review.
>
> On Mon, Feb 15, 2021 at 08:07:21AM +0200, Leon Romanovsky wrote:
> > On Mon, Feb 15, 2021 at 02:06:53PM +0900, Nobuhiro Iwamatsu wrote:
> > > Add dwmac-visconti to the stmmac driver in Toshiba Visconti ARM SoCs.
> > > This patch contains only the basic function of the device. There is no
> > > clock control, PM, etc. yet. These will be added in the future.
> > >
> > > Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> > > ---
> > >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
> > >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> > >  .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 285 ++++++++++++++++++
> > >  3 files changed, 294 insertions(+)
> > >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
> > >
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > index 53f14c5a9e02..55ba67a550b9 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > @@ -219,6 +219,14 @@ config DWMAC_INTEL_PLAT
> > >  	  This selects the Intel platform specific glue layer support for
> > >  	  the stmmac device driver. This driver is used for the Intel Keem Bay
> > >  	  SoC.
> > > +
> > > +config DWMAC_VISCONTI
> > > +	bool "Toshiba Visconti DWMAC support"
> > > +	def_bool y
> >
>
> Sorry, I sent the wrong patchset that didn't fix this point out.
>
> > I asked it before, but never received an answer.
>
> I have received your point out and have sent an email with the content
> to remove this line. But it may not have arrived yet...
>
> > Why did you use "def_bool y" and not "default y"? Isn't it supposed to be
> > "depends on STMMAC_ETH"? And probably it shouldn't be set as a default as "y".
> >
>
> The reason why "def_bool y" was set is that the wrong fix was left when
> debugging. Also, I don't think it is necessary to set "default y".
> This is also incorrect because it says "bool" Toshiba Visconti DWMAC
> support "". I change it to trustate in the new patch.
>
> And this driver is enabled when STMMAC_PLATFORM was Y. And STMMAC_PLATFORM
> depends on STMMAC_ETH.
> So I understand that STMMAC_ETH does not need to be dependents. Is this
> understanding wrong?

This is correct understanding, just need to clean other entries in that
Kconfig that depends on STMMAC_ETH.

Thanks

>
> > Thanks
> >
>
> Best regards,
>   Nobuhiro
