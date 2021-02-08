Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3621312AB4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhBHGaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:30:46 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41913 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbhBHGaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:30:10 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id DAD97580218;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 01:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=T1+J0aCgQkzwe
        JaAMrWxKE3uyhlZOFmpO4MFCRMyHkA=; b=DPQZimSHHsLfHQ2hQj/iLuW4PrQxX
        J/qbq/qWtejw03wpEh8FKYWx1ZlrKa37WPXzeHF+xik81sdOwN64LPLBQDMZDScg
        q4kXOWJOBYhNooYsG+4Vdpp5F6Escsai8h9iurl2ua5AjTNN+YLEucAHTecGY913
        iGCcdOsOjf0jRZq4yMCSjd/tIyOahX160zT/QhzqtCox/EYITsMVbF/QOCQd8SZW
        8lZIs72KRENWXj6Gg7CHAtZeeA39XbbpLfbFdtleQSyrCB/18nYYEsJsDH5Drm0g
        0+SUVpovsaGmklWIT2FK+eUTJ2Y0WKgX/sK0RHa2TpgZ7sL13zKlUlGcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=T1+J0aCgQkzweJaAMrWxKE3uyhlZOFmpO4MFCRMyHkA=; b=n6yPfuYD
        rF9T3VZJ46HKecWAilk+3dNBSleZ+wS2Lr/NGycHOfGgSYbRDFT9o/kgYjaUD4JN
        jYLCumqMSpDixF1jok6vCXUZCERoQmcOTCNFM1h3qsQOy5sCoScvI8dLLQihMCqG
        6bxPLjK+EipXsiJwDaJ6Ec3UCak1S61pwZEU+k8t1qeEUFPJHM1M5TwYUZ4y4s6T
        Ew5VYN8Nw9HP7UBATlT7SpZGJGDChTroR9ttft3GMx1sfHD6E8xeslzF7r+s7x8L
        nfFz5n1EF7Dz/FWE8mW3vDZXEGhqidR60U0PYJxVRl0SvQdPioYS9bDJYCaxmZtv
        LoYNDAi6TQHrZA==
X-ME-Sender: <xms:LtogYL1rOuCn5EfSs4zy0gc8UQyvuOfCDV-6LV5SU2Xq-z9e11hlXg>
    <xme:LtogYKHJ3XUBznwM_jwW_qCJ7Mgiym5GppmP7qZ-g-OLNOhGzl1Q5DgxN-62Kklw6
    iKi1rmQBDtPjXNvTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:LtogYL7XYejp_LguoQuTvG2c_Nsms6Wc1bOatNwdZPbfWwUNWQMaDQ>
    <xmx:LtogYA38iMXrw8xJ2o2yZ_o7VV0uHalYZEcfLvVHmx2xs_dnqpRWcg>
    <xmx:LtogYOHDBgzz6a24bz5tqXn4rSzLu6C8T2cve7vbH_viI6bgMPqaGA>
    <xmx:L9ogYFfOO4l4vlIlSnlZU77YX8v08VebRHLTYJSO1XmhGSr32HZVnw>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F20B1080063;
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
Subject: [PATCH net-next RESEND 2/5] net: stmmac: dwmac-sun8i: Remove unnecessary PHY power check
Date:   Mon,  8 Feb 2021 00:28:56 -0600
Message-Id: <20210208062859.11429-4-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208062859.11429-1-samuel@sholland.org>
References: <20210208062859.11429-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sun8i_dwmac_unpower_internal_phy already checks if the PHY is powered,
so there is no need to do it again here.

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 8e505019adf8..3c3d0b99d3e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1018,10 +1018,8 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 {
 	struct sunxi_priv_data *gmac = priv;
 
-	if (gmac->variant->soc_has_internal_phy) {
-		if (gmac->internal_phy_powered)
-			sun8i_dwmac_unpower_internal_phy(gmac);
-	}
+	if (gmac->variant->soc_has_internal_phy)
+		sun8i_dwmac_unpower_internal_phy(gmac);
 
 	clk_disable_unprepare(gmac->tx_clk);
 
-- 
2.26.2

