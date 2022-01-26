Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAC349C77A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbiAZK1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:27:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57604 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbiAZK1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:27:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B86B81978
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 10:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1F2C340E7;
        Wed, 26 Jan 2022 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643192840;
        bh=6rkw8p+yAJlGixi398275Nx9SiWAH65YdfiEe76C6DI=;
        h=From:To:Cc:Subject:Date:From;
        b=AXGD59uyEezGHcT/4r0Mgu0JOlt3bqsU/PLvB4L9y2/V+ZeBCgvb3RWtHcGAcfnY+
         o4fC0BJUnKc9+NrcTXA5UZy4lgIVUixi1A1wEC1czxtd01S7PkBMrULvvGY7ZwHvxa
         uvg6mbPH/vJT2dRBpc8nk5K0HTA8T0z71vpxyrZlVN3yrdrAP/M380HzCftdKdC18W
         rq30QoVPvFbnbnt5uNos8wNajsCnuTlL0l9Yxi1K9bBsN4pvrAN8RfSDMa8HmQZZKl
         2vbwohzIAoaVg8DJMGehtFa0k/IC8GiFcXtvr/+TvLy5L2K4E9B4qwSZZLqHF/gwjU
         oB6yqYFnp/opw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, bgolaszewski@baylibre.com
Subject: [PATCH net-next] net: ethernet: mtk_star_emac: fix unused variable
Date:   Wed, 26 Jan 2022 11:27:05 +0100
Message-Id: <9da2bbc0fc7f785f6ea43128b72bc6b8b4e23093.1643192687.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following warning in mtk_star_emac.c if CONFIG_OF is not set:

drivers/net/ethernet/mediatek/mtk_star_emac.c:1559:34:
    warning: unused variable 'mtk_star_of_match' [-Wunused-const-variable]
    static const struct of_device_id mtk_star_of_match[] = {

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 89ca7960b225..4cd0747edaff 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1556,6 +1556,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 	return devm_register_netdev(dev, ndev);
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id mtk_star_of_match[] = {
 	{ .compatible = "mediatek,mt8516-eth", },
 	{ .compatible = "mediatek,mt8518-eth", },
@@ -1563,6 +1564,7 @@ static const struct of_device_id mtk_star_of_match[] = {
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mtk_star_of_match);
+#endif
 
 static SIMPLE_DEV_PM_OPS(mtk_star_pm_ops,
 			 mtk_star_suspend, mtk_star_resume);
-- 
2.34.1

