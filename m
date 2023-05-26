Return-Path: <netdev+bounces-5618-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4E4712454
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:14:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 730951C20F9C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DAD156DC;
	Fri, 26 May 2023 10:14:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CB4156CB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:14:30 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA99DF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gIbo2OHXFMVJ6gyvgDlZbweRhKVO88XqXsauWqjJJGQ=; b=DSkLujtz9AOVB+vvmi/42gjSnq
	uoUlG7ED9r8gJ0Qj+5nEnvcDkXs7+nwqXPwkpJYsOC5QfvqKyKC8DsX/uNZwp92LV4Yo5lAGPfu8w
	7Evr+/NSpNA/1RBChiFAX6PiLdAlwTEKLBYJth+sMpjfhQw7kEUAmRZerkTT+FsnW8JS2hAW89oyL
	I+awrXYTmwcnjG2ywmVqSxaLJ3E84TQJseaZnWPnyXtUM47V8fus1y2O4omvTGoMdAgrgMnJcfIuh
	MlKlJaLu5Lsxaa5pZZk37lr3sBnr5cKi4ds3WMfyXVc1kWHqg2mEek70C8HgjEw8z5NFM/630XEma
	ohjVJwaA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55470)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q2USW-0005OU-5d; Fri, 26 May 2023 11:14:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q2USN-0003e9-Ec; Fri, 26 May 2023 11:13:59 +0100
Date: Fri, 26 May 2023 11:13:59 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	UNGLinuxDriver@microchip.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/6] net: pcs: add helpers to xpcs and lynx to
 manage mdiodev
Message-ID: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This morning, we have had two instances where the destruction of the
MDIO device associated with XPCS and Lynx has been wrong. Rather than
allowing this pattern of errors to continue, let's make it easier for
driver authors to get this right by adding a helper.

The changes are essentially:

1. Add two new mdio device helpers to manage the underlying struct
   device reference count. Note that the existing mdio_device_free()
   doesn't actually free anything, it merely puts the reference count.

2. Make the existing _create() and _destroy() PCS driver methods
   increment and decrement this refcount using these helpers. This
   results in no overall change, although drivers may hang on to
   the mdio device for a few cycles longer.

3. Add _create_mdiodev() which creates the mdio device before calling
   the existing _create() method. Once the _create() method has
   returned, we put the reference count on the mdio device.

   If _create() was successful, then the reference count taken there
   will "hold" the mdio device for the lifetime of the PCS (in other
   words, until _destroy() is called.) However, if _create() failed,
   then dropping the refcount at this point will free the mdio device.

   This is the exact behaviour we desire.

4. Convert users that create a mdio device and then call the PCS's
   _create() method over to the new _create_mdiodev() method, and
   simplify the cleanup.

We also have DPAA2 and fmem_memac that look up their PCS rather than
creating it. These could also drop their reference count on the MDIO
device immediately after calling lynx_pcs_create(), which would then
mean we wouldn't need lynx_get_mdio_device() and the associated
complexity to put the device in dpaa2_pcs_destroy() and pcs_put().
Note that DPAA2 bypasses the mdio device's abstractions by calling
put_device() directly.

 drivers/net/dsa/ocelot/felix_vsc9959.c            | 20 +++------------
 drivers/net/dsa/ocelot/seville_vsc9953.c          | 20 +++------------
 drivers/net/ethernet/freescale/enetc/enetc_pf.c   | 22 +++-------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 15 +++--------
 drivers/net/pcs/pcs-lynx.c                        | 31 +++++++++++++++++++++++
 drivers/net/pcs/pcs-xpcs.c                        | 28 ++++++++++++++++++++
 include/linux/mdio.h                              | 10 ++++++++
 include/linux/pcs-lynx.h                          |  1 +
 include/linux/pcs/pcs-xpcs.h                      |  2 ++
 9 files changed, 87 insertions(+), 62 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

