Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCA1430D72
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 03:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242987AbhJRB35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 21:29:57 -0400
Received: from mx.socionext.com ([202.248.49.38]:22342 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242960AbhJRB34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 21:29:56 -0400
Received: from unknown (HELO kinkan2-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 18 Oct 2021 10:27:44 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan2-ex.css.socionext.com (Postfix) with ESMTP id D00F72059034;
        Mon, 18 Oct 2021 10:27:44 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Mon, 18 Oct 2021 10:27:44 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 55255B62B7;
        Mon, 18 Oct 2021 10:27:44 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net-next 2/2] net: ethernet: ave: Add compatible string and SoC-dependent data for NX1 SoC
Date:   Mon, 18 Oct 2021 10:27:37 +0900
Message-Id: <1634520457-16440-3-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1634520457-16440-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1634520457-16440-1-git-send-email-hayashi.kunihiko@socionext.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic support for UniPhier NX1 SoC. This includes a compatible string
and SoC-dependent data.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 4b0fe0f58bbf..2c48f8b8ab71 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1935,6 +1935,17 @@ static const struct ave_soc_data ave_pxs3_data = {
 	.get_pinmode = ave_pxs3_get_pinmode,
 };
 
+static const struct ave_soc_data ave_nx1_data = {
+	.is_desc_64bit = true,
+	.clock_names = {
+		"ether",
+	},
+	.reset_names = {
+		"ether",
+	},
+	.get_pinmode = ave_pxs3_get_pinmode,
+};
+
 static const struct of_device_id of_ave_match[] = {
 	{
 		.compatible = "socionext,uniphier-pro4-ave4",
@@ -1956,6 +1967,10 @@ static const struct of_device_id of_ave_match[] = {
 		.compatible = "socionext,uniphier-pxs3-ave4",
 		.data = &ave_pxs3_data,
 	},
+	{
+		.compatible = "socionext,uniphier-nx1-ave4",
+		.data = &ave_nx1_data,
+	},
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, of_ave_match);
-- 
2.7.4

