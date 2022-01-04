Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCCC483FF7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiADKeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiADKen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:34:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5C9C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 02:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cVEsL33VDlCXI6mXM0CqiL0PUax/E1YvZ8pPRTBh6jY=; b=07jjMVDYblOHkE8qvN1ebvddym
        TNj4MrRG83/veai3Y2nvGViDZr+7U1fLmZdGlqkCv0I/8WH7/XfrcqqwcMRanLhtqBrpYU3sNR8+s
        6OHDsPhs5b46+eHh5S8mt+u9sZPk78OZJX1u6sqCnoLb6lWlg1kaT44cMxhRiApjj92UGDXC7D0cq
        u+1KyFbbhrWbEPL8BX/HVmKajudkpgfXvSh12CzQVreyKUwpuG9s68jsi/QaxlA1JwThIK/9PSDwc
        442145qiGgDGQSHPtaC1r2dTGTInhTqTAvAt3Tg1fpPWgrTPsskOhbr+tsE3DS4vLwi0sF5xcBps2
        Hi17G0Mw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56548)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4h9G-0006rq-Ck; Tue, 04 Jan 2022 10:34:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4h9D-00079K-Hz; Tue, 04 Jan 2022 10:34:31 +0000
Date:   Tue, 4 Jan 2022 10:34:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Radhey Shyam Pandey <radheys@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Message-ID: <YdQity1FDX0oNEN5@shell.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
 <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
 <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
 <CAFcVECJeRwgjGsxtcGpMuA23nnmywsNkA2Yngk6aDK_JuVE3NQ@mail.gmail.com>
 <CAFcVEC+N0Y7ESFe-qcfpmkbPjRSvCJ=AOXoM6XSK6xGo=J1YNw@mail.gmail.com>
 <YdQMyfYU0wxHrT40@shell.armlinux.org.uk>
 <BL3PR02MB8187165DAF278F65C8024567C94A9@BL3PR02MB8187.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL3PR02MB8187165DAF278F65C8024567C94A9@BL3PR02MB8187.namprd02.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 09:12:06AM +0000, Harini Katakam wrote:
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Tuesday, January 4, 2022 2:31 PM
> > To: Harini Katakam <harinik@xilinx.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>; Michal Simek <michals@xilinx.com>;
> > Radhey Shyam Pandey <radheys@xilinx.com>; Sean Anderson
> > <sean.anderson@seco.com>; David S. Miller <davem@davemloft.net>;
> > netdev <netdev@vger.kernel.org>; linux-arm-kernel@lists.infradead.org
> > Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
> > 
> > On Tue, Jan 04, 2022 at 01:26:28PM +0530, Harini Katakam wrote:
> > > On Fri, Dec 17, 2021 at 1:55 PM Harini Katakam <harinik@xilinx.com> wrote:
> > > >
> > > > Hi Russell,
> > > >
> > > > On Fri, Dec 17, 2021 at 5:26 AM Russell King (Oracle)
> > > > <linux@armlinux.org.uk> wrote:
> > > > >
> > > > > On Thu, Dec 16, 2021 at 07:15:13AM -0800, Jakub Kicinski wrote:
> > > > > > On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> > > > > > > Convert axienet to use the phylink_pcs layer, resulting in it
> > > > > > > no longer being a legacy driver.
> > > > > > >
> > > > > > > One oddity in this driver is that lp->switch_x_sgmii controls
> > > > > > > whether we support switching between SGMII and 1000baseX.
> > > > > > > However, when clear, this also blocks updating the 1000baseX
> > > > > > > advertisement, which it probably should not be doing.
> > > > > > > Nevertheless, this behaviour is preserved but a comment is added.
> > > > > > >
> > > > > > > Signed-off-by: Russell King (Oracle)
> > > > > > > <rmk+kernel@armlinux.org.uk>
> > > > > >
> > > > > > drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Function
> > parameter or member 'pcs' not described in 'axienet_local'
> > > > >
> > > > > Fixed that and the sha1 issue you raised in patch 2. Since both
> > > > > are "documentation" issues, I won't send out replacement patches
> > > > > until I've heard they've been tested on hardware though.
> > > >
> > > > Thanks for the patches.
> > > > Series looks good and we're testing at our end; will get back to you
> > > > early next week.
> > >
> > > Thanks Russell. I've tested AXI Ethernet and it works fine.
> > 
> > Happy new year!
> > 
> > Thanks - can I use that as a tested-by please, and would you be happy for me
> > to send the patches for merging this week?
> 
> Sure, yes and yes.
> Tested-by: Harini Katakam <harini.katakam@xilinx.com>
> 
> Happy new year to you too!

Thanks. While adding the attributation, I was reminded of this comment in
the commit message:

  One oddity in this driver is that lp->switch_x_sgmii controls whether
  we support switching between SGMII and 1000baseX. However, when clear,
  this also blocks updating the 1000baseX advertisement, which it
  probably should not be doing. Nevertheless, this behaviour is preserved
  but a comment is added.

went back to look at that, and realised that this was not the case at
all, so patch 1 introduces a behaviour that wasn't originally there.
I'll post an update, but essentially the change to patch 1 is:

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a556f0215049..fbe0de4bc8dd 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1533,18 +1533,17 @@ static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	struct axienet_local *lp = netdev_priv(ndev);
 	int ret;
 
-	/* We don't support changing the advertisement in 1000base-X? --rmk */
-	if (!lp->switch_x_sgmii)
-		return 0;
-
-	ret = mdiobus_write(pcs_phy->bus, pcs_phy->addr,
-			    XLNX_MII_STD_SELECT_REG,
-			    interface == PHY_INTERFACE_MODE_SGMII ?
-				XLNX_MII_STD_SELECT_SGMII : 0);
-	if (ret < 0) {
-		netdev_warn(ndev, "Failed to switch PHY interface: %d\n",
-			    ret);
-		return ret;
+	if (lp->switch_x_sgmii) {
+		ret = mdiobus_write(pcs_phy->bus, pcs_phy->addr,
+				    XLNX_MII_STD_SELECT_REG,
+				    interface == PHY_INTERFACE_MODE_SGMII ?
+					XLNX_MII_STD_SELECT_SGMII : 0);
+		if (ret < 0) {
+			netdev_warn(ndev,
+				    "Failed to switch PHY interface: %d\n",
+				    ret);
+			return ret;
+		}
 	}
 
 	ret = phylink_mii_c22_pcs_config(pcs_phy, mode, interface, advertising);

and a corresponding change to patch 2 for the change in code formatting.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
