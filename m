Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDB9316DD5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhBJSF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:05:26 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:52342 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbhBJSB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:01:57 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 11AHxdZw012724; Thu, 11 Feb 2021 02:59:39 +0900
X-Iguazu-Qid: 34tMdHaKfB3KnWgQ2C
X-Iguazu-QSIG: v=2; s=0; t=1612979979; q=34tMdHaKfB3KnWgQ2C; m=w+r9R3BCnx0ieRU1JliZZ+qBHax/h5ycHAnyWnDfMIg=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id 11AHxbKX015468;
        Thu, 11 Feb 2021 02:59:38 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11AHxbYi005268;
        Thu, 11 Feb 2021 02:59:37 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11AHxbYi020770;
        Thu, 11 Feb 2021 02:59:37 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rusaimi Amira Ruslan <rusaimi.amira.rusaimi@intel.com>,
        "Vineetha G . Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
Cc:     netdev@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH] net: stmmac: dwmac-intel-plat: remove unnecessary initialization
Date:   Thu, 11 Feb 2021 02:59:35 +0900
X-TSB-HOP: ON
Message-Id: <20210210175935.3967631-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

plat_dat is initialized by stmmac_probe_config_dt().
So, initialization is not required by priv->plat.
This removes unnecessary initialization and variables.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index ba0e4d2b256a..6c19fcc76c6f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -74,8 +74,6 @@ MODULE_DEVICE_TABLE(of, intel_eth_plat_match);
 
 static int intel_eth_plat_probe(struct platform_device *pdev)
 {
-	struct net_device *ndev = platform_get_drvdata(pdev);
-	struct stmmac_priv *priv = netdev_priv(ndev);
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
 	const struct of_device_id *match;
@@ -83,7 +81,6 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	unsigned long rate;
 	int ret;
 
-	plat_dat = priv->plat;
 	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
 	if (ret)
 		return ret;
-- 
2.30.0

