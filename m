Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B074030F69
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfEaN6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:58:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbfEaN6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 09:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CtGXzIswEZcMsfKi3FX3ncQPxxc/qDLfdACtjnnjE/0=; b=qF1yNWYUOI2N2DyiDhc6t8aApe
        n4Y6zgq2D0XaGIq1HFQ0p/y0k9sxUVScc77lM/A9s37YwdaekGfMYR09YZ4ToY6aZ376+Jfx9qH2N
        D2G6FJ4T/v7fd9yWCznPxuG1FoDFLJiboMAXW+olA2h9qlZvezmTHsKAvzU0iuxvqmqE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWi3F-0006Bs-K4; Fri, 31 May 2019 15:58:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     linville@redhat.com
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
Date:   Fri, 31 May 2019 15:57:48 +0200
Message-Id: <20190531135748.23740-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190531135748.23740-1-andrew@lunn.ch>
References: <20190531135748.23740-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel can now indicate if the PHY supports operating over a
single pair at 100Mbps or 1000Mbps.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool.8.in | 2 ++
 ethtool.c    | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 430d11b915af..6af63455c636 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -639,8 +639,10 @@ lB	l	lB.
 0x002	10baseT Full
 0x004	100baseT Half
 0x008	100baseT Full
+0x80000000000000000	100baseT1 Full
 0x010	1000baseT Half	(not supported by IEEE standards)
 0x020	1000baseT Full
+0x100000000000000000	1000baseT1 Full
 0x20000	1000baseKX Full
 0x20000000000	1000baseX Full
 0x800000000000	2500baseT Full
diff --git a/ethtool.c b/ethtool.c
index 66a907edd97b..05fe05a080cd 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -545,6 +545,8 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
 		ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT,
 		ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
+		ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
+		ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
 	};
 	static const enum ethtool_link_mode_bit_indices
 		additional_advertised_flags_bits[] = {
@@ -634,10 +636,14 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "100baseT/Half" },
 		{ 1, ETHTOOL_LINK_MODE_100baseT_Full_BIT,
 		  "100baseT/Full" },
+		{ 0, ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
+		  "100baseT1/Full" },
 		{ 0, ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
 		  "1000baseT/Half" },
 		{ 1, ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
 		  "1000baseT/Full" },
+		{ 0, ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
+		  "1000baseT1/Full" },
 		{ 0, ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
 		  "1000baseKX/Full" },
 		{ 0, ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
-- 
2.20.1

