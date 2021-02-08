Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866A8312AB1
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBHGaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:30:19 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:51299 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229615AbhBHGaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:30:09 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7FE54580217;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 01:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=QaX4dbz8bYwhB
        LwW47Eu9IxjfHORPdrlkULng/kPy4A=; b=UnD7dvmx6ArgPC+GsxA217yceUwGb
        Ry6k70nj+VI6I7PPvuMXL0TGgU0tC4a102sFwXTkH0bIxGlqzxwcHpOwOP4IyYFX
        6ghs1+JCJR2dlcFrfEvVlhSLG4G69ShY1VjfjXzdz+HEYaror7cyVsowHhjPATcb
        XcgWU4Ayk7/L31vL3OQocbdrFMY4exxJzAVqOFESyq2BaqOQEBqkyWCPJEg4tjsn
        EaQIBKfGAyw2WY9n7p0SL+8a1cu8yypPhfCH7e/fWv+UvRtS3W1cnws04bP8oDFw
        zY1aDJonKhuJ/v+XH4JwW071ee5hXVYY9t+eOg+dIqlu27a+bJBOS/Uhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=QaX4dbz8bYwhBLwW47Eu9IxjfHORPdrlkULng/kPy4A=; b=K8oabRGp
        3sOQhRp85wxt/nJekNb+6Jrhua8orbTtMvMmK9CTRXyiWRD0jTGhYUyt5xxgy7x3
        SJbnS3xSaqCqqW6m6O0yTZ7tddGNwdYTj9K9Tf445pZHotD+7c762LbuVahXImNw
        i5Hbcy9bH1FW43PBcwBFgcUqCt3Kyt6QF6Mv95lUNcZ3qUNnf4QhULJxQtaeB3xK
        QxGzUVFQtosITnXPt2xWjKC1QHNiwrvLpnCEfStrY4lncDpLKiplD8vBwIZCWJSN
        ZtTv5ppccybYZ/F8ESUtuPeumwOvKB771mLiw8OiX+R4jniAa9AKDxeutG7RUGy8
        Af23Z0YBRuN0hQ==
X-ME-Sender: <xms:L9ogYENakmMYxQEBDAtA6xtx3ciHe_siDQylh06sweCz4pD10AA1KA>
    <xme:L9ogYK-8InpjmeFsyGAcX3cVRihUZzganl1PiJNapdYhqMzkR6VTB3R2bZQVy9oXW
    NhfYrGJlSBE-D3ibw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:L9ogYLToA-EAMOAwyIsFnA7li4wglN15GUzfnTy_wAiiL-rT4xlBYA>
    <xmx:L9ogYMs4jzQdBTl2xGVEOFCIesQED2nug16cVBeSx4FQe1vKJ5FYrQ>
    <xmx:L9ogYMdUaa-jiN-27Htb5mZXmAnVaoYvRoWq912XCQLczq9RZQm4Cw>
    <xmx:L9ogYC16-WXaLmtnBWV-Ia56AU8XdkpM8FjQOdMLRQ8OmWSfAqDAhQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB33F1080064;
        Mon,  8 Feb 2021 01:29:02 -0500 (EST)
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
Subject: [PATCH net-next RESEND 3/5] net: stmmac: dwmac-sun8i: Use reset_control_reset
Date:   Mon,  8 Feb 2021 00:28:57 -0600
Message-Id: <20210208062859.11429-5-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208062859.11429-1-samuel@sholland.org>
References: <20210208062859.11429-1-samuel@sholland.org>
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 3c3d0b99d3e8..0e8d88417251 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -806,11 +806,9 @@ static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv)
 	/* Make sure the EPHY is properly reseted, as U-Boot may leave
 	 * it at deasserted state, and thus it may fail to reset EMAC.
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

