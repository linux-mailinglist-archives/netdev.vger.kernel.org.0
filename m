Return-Path: <netdev+bounces-3360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 889F2706AA4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29B9B2816A9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813842C757;
	Wed, 17 May 2023 14:11:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B0418B16
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:11:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C9761B3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YtAtbLJoWhxfpJS82WWCGIBvTD939VldEdVeMkkiOSY=; b=fl52LgBTyRKa9H0M6fPg72N9N5
	tEzNXoNWq2w5tmUl4sWz8v5KkclSSWt+FGi+1LuXBG73KPHw6fv615ojbJ6jKfbVloC6yiQl+S3gj
	FVCHk9qRH1DpvjLqwIfp9Hc2+8tOmJbpKWCOyhAEFOGGjJ3xVaXPPfsQlCqVwyKDzUhD1TrAfvImc
	uk4sUhb+YDmubcjazHP+GOeQk5Tfmu2JhPqbvhU5MyGj75mHSopMS380p7/QcSm3HX1Y74guRqYt4
	hZrV/IIOpdZPZRNwilJ0XO0nou47cq9B1EodFG9/T+9L4B9hV6+9QDuzs1OpeixvOEtk9XtcpSJlP
	4R4x9igg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60672)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pzHsO-0007zL-AN; Wed, 17 May 2023 15:11:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pzHsL-0001vJ-EY; Wed, 17 May 2023 15:11:33 +0100
Date: Wed, 17 May 2023 15:11:33 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC v2 net-next 0/9] net: pcs: xpcs: cleanups for clause 73
 support
Message-ID: <ZGTglYakbbnWEIkw@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This series cleans up xpcs code, moving much of the clause 73 code
out of the driver into places where others can make use of it.

Specifically, we add a helper to convert a clause 73 advertisement
to ethtool link modes to mdio.h, and a helper to resolve the clause
73 negotiation state to phylink, which includes the pause modes.

In doing this cleanup, several issues were identified with the
original xpcs implementation:

1) it masks the link partner advertisement with its own advertisement
   so userspace can't see what the full link partner advertisement
   was.
2) it was always setting pause modes irrespective of the advertisements
   on either end of the link.
3) it was reading the STAT1 registers multiple times. Reading STAT1
   has the side effect of unlatching the link-down status, so
   multiple reads should be avoided.

This patch series addresses the first two first by addressing the
issues, and then by moving over to the new helpers. The third issue
is solved by restructuring the xpcs code.

Obviously untested as I don't have xpcs hardware, so please can
someone test these changes and give a tested-by for them? Thanks.

v2: add attributations, fix spelling mistake in patch 8, fix build
error in patch 9.

 drivers/net/pcs/pcs-xpcs.c | 159 ++++++++++++++++++---------------------------
 drivers/net/pcs/pcs-xpcs.h |   3 -
 drivers/net/phy/phylink.c  |  54 +++++++++++----
 include/linux/mdio.h       |  39 +++++++++++
 include/linux/phylink.h    |   2 +
 include/uapi/linux/mdio.h  |  24 +++++++
 6 files changed, 170 insertions(+), 111 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

