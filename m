Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E5131B5A4
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 08:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBOHax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 02:30:53 -0500
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:41544 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhBOHar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 02:30:47 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 11F7SD8j007731; Mon, 15 Feb 2021 16:28:14 +0900
X-Iguazu-Qid: 2wGqsXjpwIf1LbOLGW
X-Iguazu-QSIG: v=2; s=0; t=1613374093; q=2wGqsXjpwIf1LbOLGW; m=lVkVkCKaQ0GTmF5HnUvU37rAumj/q4/KAOhciklpZiY=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1112) id 11F7SBOk037567;
        Mon, 15 Feb 2021 16:28:12 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11F7SBcd018818;
        Mon, 15 Feb 2021 16:28:11 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11F7SAKc025869;
        Mon, 15 Feb 2021 16:28:10 +0900
Date:   Mon, 15 Feb 2021 16:28:09 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Leon Romanovsky <leon@kernel.org>
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
X-TSB-HOP: ON
Message-ID: <20210215072809.n3r5rdswookzri6j@toshiba.co.jp>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp>
 <YCoPmfunGmu0E8IT@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCoPmfunGmu0E8IT@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for your review.

On Mon, Feb 15, 2021 at 08:07:21AM +0200, Leon Romanovsky wrote:
> On Mon, Feb 15, 2021 at 02:06:53PM +0900, Nobuhiro Iwamatsu wrote:
> > Add dwmac-visconti to the stmmac driver in Toshiba Visconti ARM SoCs.
> > This patch contains only the basic function of the device. There is no
> > clock control, PM, etc. yet. These will be added in the future.
> >
> > Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
> >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >  .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 285 ++++++++++++++++++
> >  3 files changed, 294 insertions(+)
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > index 53f14c5a9e02..55ba67a550b9 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > @@ -219,6 +219,14 @@ config DWMAC_INTEL_PLAT
> >  	  This selects the Intel platform specific glue layer support for
> >  	  the stmmac device driver. This driver is used for the Intel Keem Bay
> >  	  SoC.
> > +
> > +config DWMAC_VISCONTI
> > +	bool "Toshiba Visconti DWMAC support"
> > +	def_bool y
> 

Sorry, I sent the wrong patchset that didn't fix this point out.

> I asked it before, but never received an answer.

I have received your point out and have sent an email with the content
to remove this line. But it may not have arrived yet...

> Why did you use "def_bool y" and not "default y"? Isn't it supposed to be
> "depends on STMMAC_ETH"? And probably it shouldn't be set as a default as "y".
> 

The reason why "def_bool y" was set is that the wrong fix was left when
debugging. Also, I don't think it is necessary to set "default y".
This is also incorrect because it says "bool" Toshiba Visconti DWMAC
support "". I change it to trustate in the new patch.

And this driver is enabled when STMMAC_PLATFORM was Y. And STMMAC_PLATFORM
depends on STMMAC_ETH.
So I understand that STMMAC_ETH does not need to be dependents. Is this
understanding wrong?

> Thanks
> 

Best regards,
  Nobuhiro
