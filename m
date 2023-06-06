Return-Path: <netdev+bounces-8430-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B045724082
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38C311C20EE5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D861B1548B;
	Tue,  6 Jun 2023 11:09:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C271212B9F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:09:37 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA5A1701
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OyJ7HudZ8Ag2vi7utl+F09jvNp+x+gyHhX+RnVljNy0=; b=UYBOMtv0MJHadJLBdHEVNbgnZd
	QIx3UcYoKuXTrW70JW2zC74SZQbVORTZvdHnnL8CrstGD/t53CfYlb+9FbW4oKFL2qAuuhL6gU4MX
	l2VVYTu5QCRXjuZDOzffJqz0rKE4GJZhrKOh2r4GVTz9cQF7ogiupL+Ph0tx2ZmgQdFq/70O6UbdF
	avaA2sFg1Jn4APy98KeJr0Q37tyj5P+rF1J2nCb+tVmwapOxabvPCaX+/ThImjmNvydCVez2/rF2x
	pu0JhDeEZckJ1gitiqR7FnUE2Mvp7SuH96HIA5OIeeiucfyNSNsw/wmuVqn5Rq9aRcA6P6fhpGWKS
	GP2QStJg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60660)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6UZ6-0005Y9-H8; Tue, 06 Jun 2023 12:09:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6UZ5-00076B-36; Tue, 06 Jun 2023 12:09:27 +0100
Date: Tue, 6 Jun 2023 12:09:27 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
	Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next 0/8] complete Lynx mdio device handling
Message-ID: <ZH8T5xixCeHW6WOE@shell.armlinux.org.uk>
References: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

It looks like patchwork didn't like this submission, which is no
different from any of my previous submissions:

https://patchwork.kernel.org/project/netdevbpf/list/?series=753590

It seems to have no patches associated with the series, yet it does
know that there are patches associated with the series:

https://patchwork.kernel.org/project/netdevbpf/cover/ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk/
https://patchwork.kernel.org/project/netdevbpf/patch/E1q56xm-00BsuT-8I@rmk-PC.armlinux.org.uk/
https://patchwork.kernel.org/project/netdevbpf/patch/E1q56xr-00Bsua-Bg@rmk-PC.armlinux.org.uk/
https://patchwork.kernel.org/project/netdevbpf/patch/E1q56xw-00Bsug-Eb@rmk-PC.armlinux.org.uk/
... etc ...

each of which link back to the series. So there are back-links to the
series but no forward-links. Sounds like a bug in patchwork :(

Any ideas what went wrong with patchwork, and whether this is just a
one-off due to timings of emails hitting patchwork, or something more
fundamental?

On Fri, Jun 02, 2023 at 04:44:59PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> This series completes the mdio device lifetime handling for Lynx PCS
> users which do not create their own mdio device, but instead fetch
> it using a firmware description - namely the DPAA2 and FMAN_MEMAC
> drivers.
> 
> In a previous patch set, lynx_pcs_create() was modified to increase
> the mdio device refcount, and lynx_pcs_destroy() to drop that
> refcount.
> 
> The first two patches change these two drivers to put the reference
> which they hold immediately after lynx_pcs_create(), effectively
> handing the responsibility for maintaining the refcount to the Lynx
> PCS driver.
> 
> A side effect of the first two patches is that lynx_get_mdio_device()
> is no longer used, so patch 3 removes it.
> 
> Patch 4 adds a new helper - lynx_pcs_create_fwnode(), which creates
> a Lynx PCS instance from the fwnode.
> 
> Patch 5 and 6 convert the two drivers to make use of this new helper,
> which simply has to find the mdio device, and then create the Lynx
> PCS from that.
> 
> With those conversions done, lynx_pcs_create() is no longer required
> outside pcs-lynx.c, so remove it from public view.
> 
> Finally, in patch 8 we change lynx_pcs_create() to return an
> error-pointer rather than NULL to bring consistency to the return
> style, and means that we can remove the NULL-to-error-pointer
> conversion from both lynx_pcs_create_fwnode() and
> lynx_pcs_create_mdiodev().
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 21 ++++++-------
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 18 +++--------
>  drivers/net/pcs/pcs-lynx.c                       | 40 ++++++++++++++----------
>  include/linux/pcs-lynx.h                         |  4 +--
>  4 files changed, 39 insertions(+), 44 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

