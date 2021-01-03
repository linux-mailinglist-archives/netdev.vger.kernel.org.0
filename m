Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78F22E8BF7
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbhACL1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:27:19 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:51585 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726015AbhACL1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:27:18 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 9A7DA560;
        Sun,  3 Jan 2021 06:25:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=tlnaBS7FSiuy8
        9dtVFPSHFaRijf3RFl2XE8UL3ebeVg=; b=A9e8wgKMfa37hxsHSSJiRVBTIrFZI
        1HT8//uK1OtNmGQGz/g/3IWs9q3N84SV5Sy2jmlFYdroFCj2DUQDVVKc14hyTt9f
        Qi6w7wYnp4qTmzU2JYom0kWTrlPv186lePm+HJBLRCBygqbehAcAlvNtnjKyzZYR
        b94wySQDqnE4RxAQcdPBeiov7UrzPpSHuWPy0DU5NkWKRvF//epwkhBRATJwROZ1
        7dyc8xP/3kBSuShzCQOCQWcmv5n2nkVv3JxeY72eOnoRW0RaZ7aB9yaedU4rIF6k
        EKNQJk8yjHExW40KbUP/eIuRlIbk/LbAiFH3Zqgu4R5fxIHFZnA7SejFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=tlnaBS7FSiuy89dtVFPSHFaRijf3RFl2XE8UL3ebeVg=; b=q3idQXzM
        OEXMQd8zvA3a/jW1H/U7Fkg1PUoRWRqch+rYReTm7/S8mSZps/0Ym2wrmSPBtCRu
        16CBUuz8yeLQdj5nNAhW0zxqCg3Ot91Xu7tAnLldX9F29AS8Edetl/yVF2wuboes
        NgQuf6ZGgPZ4wvJKn1fEMIhSvKuRI0+KhNRZ0QJK0LKW0iGz+x6CE5y7bQAaRY7p
        ECLwxi5pVtRz4Lty0I24jX82Isz/EX7W+yJj5GPkJygeIfj4149/7NBIKxtxs9mw
        /Sh37xvRjWF6K8c4/5sKAQA5IjCsTN3xizURaW2zteQgo4Q6uY2KHwdZhyUZGmqB
        RywOVHvTprK9NQ==
X-ME-Sender: <xms:u6nxX5kq1jj0JAsp2sbczOl79EvCuDyK1e-2hzL7Tlblp15ubB_WMg>
    <xme:u6nxX021d9hhyiren1lyl32ijqrC0pYaIpxdFwHsX1D3sAFCx2wQX9DIC9wy60IMq
    BM_dBcAprBAC7zJpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:u6nxX_q3N5g9owRrif_e5FmQbymTnooXJaBNKcyOVgssOIaCeID9dg>
    <xmx:u6nxX5ldX4pGAOw5qaQf2iZeNDnJPGjtDvu0qN8B_kh8_FhY8YaCBw>
    <xmx:u6nxX30UAsxNjX5eedkGS_GxOEhgoLmXaW5j96LOdM2o-N82rR0hhw>
    <xmx:u6nxX1Pt_4NgeN1ew6JF-F8ZGsTd1j9oJfXm9fco1lw_6UPZKjUi9Xk9Hnc>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3E8C1080064;
        Sun,  3 Jan 2021 06:25:45 -0500 (EST)
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
Subject: [PATCH net-next 5/5] net: stmmac: dwmac-sun8i: Add a shutdown callback
Date:   Sun,  3 Jan 2021 05:25:42 -0600
Message-Id: <20210103112542.35149-6-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103112542.35149-1-samuel@sholland.org>
References: <20210103112542.35149-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet MAC and PHY are usually major consumers of power on boards
which may not be able to fully power off (that have no PMIC). Powering
down the MAC and internal PHY saves power while these boards are "off".

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

