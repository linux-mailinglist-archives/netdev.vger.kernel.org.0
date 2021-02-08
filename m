Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FCC312ABB
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBHGcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:32:07 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39493 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229815AbhBHGbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:31:02 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id A4E0D58021F;
        Mon,  8 Feb 2021 01:29:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 01:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=daqee4/YfWrBT
        wdQcL/9RUOofu39a/j2M6J+Y7w578s=; b=mOCETWsRHXK4ll6tgx3PBs5WM8BVP
        Zs68YVF+dr/9lrPoJCJEdqjdPXR2VH9s83/iTQ3KWoNpHuWEoNBsUpAbd1ZOZta9
        RV5CHm6CrLjSR7dboVOlXlwV3fFDHSXCIUBYDYpvwSRI1YtYKu2lwWRbWB3c+H0S
        ZQoFsLf4g1H9MPDhvm0sBQ9cfUIEVfUdME5y6iZ/sdUE4grlXXwwPoAvLWrx5Oh9
        BawilUWLAZqRfZq0MEC0glVWE2kdjE8RAZDpvUE3TidIOINH+RMYDzZLlkkLWGgb
        PIbf5NgsgEUfk1nK0NvOJCGD6NAdj05k1pwDnqOjp8IVEpFpgJCK0y1ww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=daqee4/YfWrBTwdQcL/9RUOofu39a/j2M6J+Y7w578s=; b=SkxXEBDU
        XYW9Lht4IOQH8B4AePpTXdKNRNIRVSbSNMdA7fBqYy0WAsv3sZxh6LvXbKoI9CcX
        Zp79b9bCLCgmwvge0Y5PSHnTsqgTbgtV71cQAmWTA22EmQYgABKhJHOv3xy6r86O
        Q1SES6deavq0VgDXFBiwylBY0/PaKPRniK3xBbGTAo3VmsWnbWtbgmBgHwfTnrlj
        fdBnFoZrb1dMPJKX5c9QWR5LkaRf6SjJ9L7boUetvepRT3DvjGlV20nZGvv4DuDm
        cuX5f4d/1+UxCEB66ikInwLs6L80rb6KZ6Q5fLIntTvjrNEUQLFJx70iA27ApOAF
        dCIciEAzQ1nxEA==
X-ME-Sender: <xms:MNogYNNZjgJXH8rP_Te6qmw54kS3bYh0-p0Eki7ruMJKQpG7XH_WOw>
    <xme:MNogYP_syQvta8KY0mnMLaoADH-HKfnOhNWBSGpNkJWiPdHqeUQ9ljT17Wiqhf2D4
    ucPNqFX-u5Btkbo6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:MNogYMRaWwRFF7GPqxzQ3za8wSaqph7nsHBNUKAhQe-Cg2PRzUN6dA>
    <xmx:MNogYJspBdgv11Ilr3drHzbAwbQmRMiMcEK1DEaXUpXJGctAW62iqw>
    <xmx:MNogYFe9u566CWdTJacvJyLdsOw7DtRH_Nm_oi2_mZc4rsrOO4VW2g>
    <xmx:MNogYD3hwh2x5jMCbKDQoUtJXaba9lAVbGSco6cWtI1gP0iX-zd3rg>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0BAE1080057;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
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
Subject: [PATCH net-next RESEND 5/5] net: stmmac: dwmac-sun8i: Add a shutdown callback
Date:   Mon,  8 Feb 2021 00:28:59 -0600
Message-Id: <20210208062859.11429-7-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208062859.11429-1-samuel@sholland.org>
References: <20210208062859.11429-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet MAC and PHY are usually major consumers of power on boards
which may not be able to fully power off (those with no PMIC). Powering
down the MAC and internal PHY saves power while these boards are "off".

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 4638d4203af5..926e8d5e8963 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1282,6 +1282,15 @@ static int sun8i_dwmac_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void sun8i_dwmac_shutdown(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct sunxi_priv_data *gmac = priv->plat->bsp_priv;
+
+	sun8i_dwmac_exit(pdev, gmac);
+}
+
 static const struct of_device_id sun8i_dwmac_match[] = {
 	{ .compatible = "allwinner,sun8i-h3-emac",
 		.data = &emac_variant_h3 },
@@ -1302,6 +1311,7 @@ MODULE_DEVICE_TABLE(of, sun8i_dwmac_match);
 static struct platform_driver sun8i_dwmac_driver = {
 	.probe  = sun8i_dwmac_probe,
 	.remove = sun8i_dwmac_remove,
+	.shutdown = sun8i_dwmac_shutdown,
 	.driver = {
 		.name           = "dwmac-sun8i",
 		.pm		= &stmmac_pltfr_pm_ops,
-- 
2.26.2

