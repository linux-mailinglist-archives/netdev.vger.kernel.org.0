Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E7B312AB3
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBHGab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:30:31 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:55707 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhBHGaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:30:10 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7E2EB580216;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 08 Feb 2021 01:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=v7LiBfCgUaEJW
        aOObaSvz5xohJwmHhm4OefGv0SLrig=; b=qoncyoLDt1Gec0D8z1qI9m76DUgZH
        AkcK2HARZzk1TpwKDMUljssSG5kcQUtyehQCFgSy+EjUZrh4NLi27plYLAPqtdcu
        UXmxyyUyXTycBvCaLgPb3pYRiUIzjbxu7xMiW0DgLzBA0zQhVmRdmPNmfBrFDDJd
        asGOVQ8mNHPaw31gFmPyf/TSCngT4yyvYeBDJMqMz/4eKkcQ6nCoV1foR5Qcn4l3
        1tOGw2aG+miStA018T/bTdMmEspG+F0bULyLRJ2TbTOP2sGKL5lY1IFHG+n2NWvs
        +T52i9+dAUAGQv+5BTLRT0sYa8GiKKtuwiQ7mvbJKDywcGZZ05zEE++mQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=v7LiBfCgUaEJWaOObaSvz5xohJwmHhm4OefGv0SLrig=; b=rVRG0yEO
        KHdUgBUHPTc1++49VCRNEbO+y3e0aX5gZ/JEbYwVmOYIulqRcEcVukRQ4q3VxsJH
        9hc30dfhJunvaWZxSyiQ4TIfmcrB3nWt6lx0F63j+28NM8rwSuRCVjQvveu1sWCg
        V09xWH+J2T04uKwYUivhuXzcW5ywgfZinrQZniGivNtKmzXlGiKV8catNR4EGK74
        C2bwN7vpkrMlP7nb1KbswywmQ3cBpPQRzdrrF21s+S+n6b5bl6PB7qjfKfrvGiEa
        e0avLOAJYEx0p40H223kD1VOTj6bkDNIJGupFnO/VGmfDDseFU9xYyGGrWLmAVkP
        n1uRgh0CGEIm5A==
X-ME-Sender: <xms:LtogYNXmwZV9X7aZxn7hReAnwq7-405fju1CIrk7Yd90DdKgpD90LA>
    <xme:LtogYNgnxOOEjodD2UWRBBgaY_sJJFbLMEM6QrXy9wW2EWEg1dKBSWfdlqU0GBT4u
    yYHbxXN08wvpykK9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:LtogYGT8leLeqYXSoc8TMEPMB_Pz5zEs8pAFtcCdXbgBjSphOSso1w>
    <xmx:LtogYIE7eWBSAyWJRmAiLrEGVLks6Rhi18Nxt26bg7OlilQw1xgqAA>
    <xmx:LtogYGlF_8bXNoa-ZA37e1EM7nHd7WLq1rxDn-ScBPri3jjlqnOtPQ>
    <xmx:L9ogYNTIvv2BuiUOqIyMYB-sqnLdYsVoQrkpSH3KgbkiV0EoM8OhCg>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 865F81080057;
        Mon,  8 Feb 2021 01:29:01 -0500 (EST)
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
Subject: [PATCH net-next RESEND 1/5] net: stmmac: dwmac-sun8i: Return void from PHY unpower
Date:   Mon,  8 Feb 2021 00:28:55 -0600
Message-Id: <20210208062859.11429-3-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208062859.11429-1-samuel@sholland.org>
References: <20210208062859.11429-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a deinitialization function that always returned zero, and that
return value was always ignored. Have it return void instead.

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index a5e0eff4a387..8e505019adf8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -820,15 +820,14 @@ static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv)
 	return 0;
 }
 
-static int sun8i_dwmac_unpower_internal_phy(struct sunxi_priv_data *gmac)
+static void sun8i_dwmac_unpower_internal_phy(struct sunxi_priv_data *gmac)
 {
 	if (!gmac->internal_phy_powered)
-		return 0;
+		return;
 
 	clk_disable_unprepare(gmac->ephy_clk);
 	reset_control_assert(gmac->rst_ephy);
 	gmac->internal_phy_powered = false;
-	return 0;
 }
 
 /* MDIO multiplexing switch function
-- 
2.26.2

