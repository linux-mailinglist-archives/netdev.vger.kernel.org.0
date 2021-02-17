Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4731A31D496
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhBQEXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:23:42 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44405 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhBQEVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:21:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 763B3580377;
        Tue, 16 Feb 2021 23:20:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 Feb 2021 23:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=QxEMMj3Dp9DFj
        qxYAtIXcSZ4AlixuxTBgKzn45m1S4o=; b=Zv1TjsD6JixTxUQLR7+KV2ldmp0k7
        dWfz6Q3T+/eabAN/gygQdgwe77GjcHq/WPbKUZgQtdAU0oHP3Y4wulR7qwhhKf/R
        e6qAyvtz1YiNX37phIKZ7bz0vYRY7sg35r2ObioVsv82XI+L29IC5W35j04uoB1i
        XgU5/+qNMT3/eZd1GGfBVGRByay4Pncr7fJE+0BnvIbkZn2eOiXJnLoBZxrEnsq0
        YodautgslkgL7dqRizER0oDhqfGFDk6Ixqpm7FEiKuHwQ8OiJNL5MThxeVsArEDW
        3mnlBRtMziT7sBtVLovuFapXpx+RLSAPDf9/Ue/Va0He47XwglSxU7nXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=QxEMMj3Dp9DFjqxYAtIXcSZ4AlixuxTBgKzn45m1S4o=; b=htDgzHnq
        QEFjpNJf1TgckBXIaseY0dgZKHoooiRvz5loptxGbamcAYHeh5USB8C0Fx1DwxQe
        q2oZ5WxzhIQ7pF4s8KQ+oErcKOMI9y8dGDLXaTaCiC+evNbJH0CyGUUUh4FKPGEh
        jIV26td48NSyUBLygaPvFlYl15cYJwBidWRVjdtJByPpU7v3rXLT9IjVQ4d10slb
        +G/I6ELUGpWGmATqays8vKYh1lJJxt8KDSnlHJC8FyPq+rIcowcQuCutwZQbQPMd
        DRMBtoMteZEC88l7Hg/5L//Dsvql7FwVPvgJs/EWLfd+06ts4qLhOunHMEtPXbH8
        6XXFgRy59FxdPQ==
X-ME-Sender: <xms:eZksYJGslb705nffwFNZvxYkI-n0Mz_ysV_6fgzi_qVHg6Ett6zcSg>
    <xme:eZksYORA5to7DBmEwT_sr2iPC_yrOe-q1qAx8Fn8d_PAfl1ZDAxASzAP0CXFZD214
    F99xdqUV-I1QUF6eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrjedugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:eZksYIBuqz0umpKk6pYAiei9Q9z_vyuD-BMAQc5zc8_LAex6JUnPgw>
    <xmx:eZksYG357-aQ9iK5KpRvy-NFQXk1ORqVaozO8D90Apm6EKZSAX7sDw>
    <xmx:eZksYOUqwHP3LImpoXtY8W64B2_8wzlyVstCwQIKiZLjJxcC8tVlaQ>
    <xmx:eZksYLBvMT__qietjT8_B23JJsN_lVkVCt2zSm3z0goWsPtlKEtf8A>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id D22EA240064;
        Tue, 16 Feb 2021 23:20:08 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>
Subject: [PATCH net-next v2 3/5] net: stmmac: dwmac-sun8i: Use reset_control_reset
Date:   Tue, 16 Feb 2021 22:20:04 -0600
Message-Id: <20210217042006.54559-4-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210217042006.54559-1-samuel@sholland.org>
References: <20210217042006.54559-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the appropriate function instead of reimplementing it,
and update the error message to match the code.

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 3c3d0b99d3e8c..b61f442ed3033 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -805,12 +805,12 @@ static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv)
 
 	/* Make sure the EPHY is properly reseted, as U-Boot may leave
 	 * it at deasserted state, and thus it may fail to reset EMAC.
+	 *
+	 * This assumes the driver has exclusive access to the EPHY reset.
 	 */
-	reset_control_assert(gmac->rst_ephy);
-
-	ret = reset_control_deassert(gmac->rst_ephy);
+	ret = reset_control_reset(gmac->rst_ephy);
 	if (ret) {
-		dev_err(priv->device, "Cannot deassert internal phy\n");
+		dev_err(priv->device, "Cannot reset internal PHY\n");
 		clk_disable_unprepare(gmac->ephy_clk);
 		return ret;
 	}
-- 
2.26.2

