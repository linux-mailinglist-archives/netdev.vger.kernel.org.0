Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000C735F588
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349092AbhDNNuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:50:03 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45786 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351719AbhDNNt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 09:49:29 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id A595E1F423E5
Message-ID: <07eb0394bb98b8b4085f9febf6bcaad79a272f80.camel@collabora.com>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Add RK3566/RK3568 SoC support
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Date:   Wed, 14 Apr 2021 10:48:59 -0300
In-Reply-To: <CAMdYzYpyD1bTN+3Zaf4nGnN-O-c0u0koiCK45fLucL0T2+69+w@mail.gmail.com>
References: <CAMdYzYpv0dvz4X2JE4J6Qg-5D9mnkqe5RpiRC845wQpZhDKDPA@mail.gmail.com>
         <1412-60762b80-423-d9eaa5@27901112>
         <CAMdYzYpyD1bTN+3Zaf4nGnN-O-c0u0koiCK45fLucL0T2+69+w@mail.gmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-14 at 07:03 -0400, Peter Geis wrote:
> On Tue, Apr 13, 2021 at 7:37 PM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > 
> > On Tuesday, April 13, 2021 19:51 -03, Peter Geis <pgwipeout@gmail.com> wrote:
> > 
> > > On Tue, Apr 13, 2021 at 5:03 PM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > > > 
> > > > From: David Wu <david.wu@rock-chips.com>
> > > > 
> > > > Add constants and callback functions for the dwmac present
> > > > on RK3566 and RK3568 SoCs. As can be seen, the base structure
> > > > is the same, only registers and the bits in them moved slightly.
> > > > 
> > > > RK3568 supports two MACs, and RK3566 support just one.
> > > 
> > > Tested this driver on the rk3566-quartz64.
> > > It fails to fully probe the gmac with the following error:
> > > [    5.711127] rk_gmac-dwmac fe010000.ethernet: IRQ eth_lpi not found
> > > [    5.714147] rk_gmac-dwmac fe010000.ethernet: no regulator found
> > > [    5.714766] rk_gmac-dwmac fe010000.ethernet: clock input or output? (input).
> > > [    5.715474] rk_gmac-dwmac fe010000.ethernet: TX delay(0x4f).
> > > [    5.716058] rk_gmac-dwmac fe010000.ethernet: RX delay(0x25).
> > > [    5.716694] rk_gmac-dwmac fe010000.ethernet: integrated PHY? (no).
> > > [    5.718413] rk_gmac-dwmac fe010000.ethernet: clock input from PHY
> > > [    5.724140] rk_gmac-dwmac fe010000.ethernet: init for RGMII
> > > [    5.726802] rk_gmac-dwmac fe010000.ethernet: Version ID not available
> > > [    5.727525] rk_gmac-dwmac fe010000.ethernet:         DWMAC1000
> > > [    5.728064] rk_gmac-dwmac fe010000.ethernet: DMA HW capability
> > > register supported
> > > [    5.729026] rk_gmac-dwmac fe010000.ethernet: Normal descriptors
> > > [    5.729624] rk_gmac-dwmac fe010000.ethernet: Ring mode enabled
> > > [    5.731123] rk_gmac-dwmac fe010000.ethernet: Unbalanced pm_runtime_enable!
> > > [    5.873329] libphy: stmmac: probed
> > > [    5.905599] rk_gmac-dwmac fe010000.ethernet: Cannot register the MDIO bus
> > > [    5.906335] rk_gmac-dwmac fe010000.ethernet: stmmac_dvr_probe: MDIO
> > > bus (id: 1) registration failed
> > > [    5.914338] rk_gmac-dwmac: probe of fe010000.ethernet failed with error -5
> > > 
> > > This is due to the lack of setting has_gmac4 = true.
> > > 
> > 
> > You are probably missing a "snps,dwmac-4.20a" in your compatible string, i.e.:
> >   compatible = "rockchip,rk3566-gmac", "snps,dwmac-4.20a";
> 
> Ah yes, I had disabled that because my variant took a different path.
> Thanks!
> 

Is that a Tested-by :-) ?

Thanks,
Ezequiel

