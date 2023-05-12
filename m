Return-Path: <netdev+bounces-2238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42CCE700DD0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D4A9281C64
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAAC200D2;
	Fri, 12 May 2023 17:26:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B34E200C2
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:26:53 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3BB10E5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fG5nxHalm7B+5RHWkvZgvBoGAsg/eqluoPesSuKc094=; b=Nm+ATPE37v0sppxQ7kHZwj8hpD
	nA1Ah/dg9VqAkcGU+znxvqfe2v3ZiUJYDWOvVN0S44MHUlu9B7lKJwCT+H+MqUhUddYdrCz3jWxXq
	clJx2Uz6EeExo0tfvojmQqQ7GZFvB65oqDVM1BVwyQOxveVSSaG2bBbFBepwErTHUSMLOBWpJGEHo
	8Wd1XsE5lJKbjVqAdknKQahf1PTjgsAxCJ/HAg91ZTl0Tu5kHboe2KLqAIQS2qXpHbcGLhSqCpO8I
	hbx0hB3d9kOjtwXMlr3WNgzdnCczzi1bCFlW47+D3gGAZ5/339aFXDn/TTwkmCFAsk6FHINFeyIa4
	Ry4kMh7A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48074)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxWXW-0000CX-94; Fri, 12 May 2023 18:26:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxWXP-0005Et-Rn; Fri, 12 May 2023 18:26:39 +0100
Date: Fri, 12 May 2023 18:26:39 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC net-next 0/9] net: pcs: xpcs: cleanups for clause 73
 support
Message-ID: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
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

