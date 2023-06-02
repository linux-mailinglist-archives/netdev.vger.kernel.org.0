Return-Path: <netdev+bounces-7465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D260C720670
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 558FE1C20F48
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5731B8FB;
	Fri,  2 Jun 2023 15:45:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCA919E63
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:45:10 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C90197
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LD9Li3MloyOoBrM0qpNclY5RVIp9NVgagkuhhB2Jp2c=; b=eXG6AWOlucnUap5oygpGwB8UOn
	/9BWjpIJhWn7srccY+HLYAjBDdkCoF4jXdznvKpM5pM+IwJeOqPouZ1XTBzfZ5nQPdd1DkGsJPT4S
	AfnHdW3clyIDBnyX/wZ82uWOOq8zGJKPmoeOyjKWYWXWHc8H/DMGMAut0FX9Tgr31DcZUTdRvv6Zf
	Jr3wU5b8fwHciy9wBqdlkG5DYYMuTW7+Kv8WIEb7N0uCF7wI8Pza6rlaz/Dtlymtbeiah4H6KeDdL
	BqTR60dY9lnpB2LyUOc5omEMRAFIpwIaSbRbDRnWAFdMzmOicZBgMggnYl8K/osx76DBvX3YVZutr
	7uYJvI3w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52062)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q56xa-0008Cy-7u; Fri, 02 Jun 2023 16:45:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q56xX-00034p-Pq; Fri, 02 Jun 2023 16:44:59 +0100
Date: Fri, 2 Jun 2023 16:44:59 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 0/8] complete Lynx mdio device handling
Message-ID: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
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

This series completes the mdio device lifetime handling for Lynx PCS
users which do not create their own mdio device, but instead fetch
it using a firmware description - namely the DPAA2 and FMAN_MEMAC
drivers.

In a previous patch set, lynx_pcs_create() was modified to increase
the mdio device refcount, and lynx_pcs_destroy() to drop that
refcount.

The first two patches change these two drivers to put the reference
which they hold immediately after lynx_pcs_create(), effectively
handing the responsibility for maintaining the refcount to the Lynx
PCS driver.

A side effect of the first two patches is that lynx_get_mdio_device()
is no longer used, so patch 3 removes it.

Patch 4 adds a new helper - lynx_pcs_create_fwnode(), which creates
a Lynx PCS instance from the fwnode.

Patch 5 and 6 convert the two drivers to make use of this new helper,
which simply has to find the mdio device, and then create the Lynx
PCS from that.

With those conversions done, lynx_pcs_create() is no longer required
outside pcs-lynx.c, so remove it from public view.

Finally, in patch 8 we change lynx_pcs_create() to return an
error-pointer rather than NULL to bring consistency to the return
style, and means that we can remove the NULL-to-error-pointer
conversion from both lynx_pcs_create_fwnode() and
lynx_pcs_create_mdiodev().

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 21 ++++++-------
 drivers/net/ethernet/freescale/fman/fman_memac.c | 18 +++--------
 drivers/net/pcs/pcs-lynx.c                       | 40 ++++++++++++++----------
 include/linux/pcs-lynx.h                         |  4 +--
 4 files changed, 39 insertions(+), 44 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

