Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671F915A71C
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgBLKzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:55:40 -0500
Received: from mx.socionext.com ([202.248.49.38]:59863 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgBLKzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 05:55:40 -0500
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 12 Feb 2020 19:55:38 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id E178E180B68;
        Wed, 12 Feb 2020 19:55:38 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Wed, 12 Feb 2020 19:55:38 +0900
Received: from plum.e01.socionext.com (unknown [10.213.132.32])
        by kinkan.css.socionext.com (Postfix) with ESMTP id 96A221A01CF;
        Wed, 12 Feb 2020 19:55:38 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net v2] net: ethernet: ave: Add capability of rgmii-id mode
Date:   Wed, 12 Feb 2020 19:55:34 +0900
Message-Id: <1581504934-19540-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows you to specify the type of rgmii-id that will enable phy
internal delay in ethernet phy-mode.

This adds all RGMII cases to all of get_pinmode() except LD11, because LD11
SoC doesn't support RGMII due to the constraint of the hardware. When RGMII
phy mode is specified in the devicetree for LD11, the driver will abort
with an error.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
Changes since v1:
- Add description about LD11 to the commit message

 drivers/net/ethernet/socionext/sni_ave.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index b703242..67ddf78 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1810,6 +1810,9 @@ static int ave_pro4_get_pinmode(struct ave_private *priv,
 		break;
 	case PHY_INTERFACE_MODE_MII:
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		priv->pinmode_val = 0;
 		break;
 	default:
@@ -1854,6 +1857,9 @@ static int ave_ld20_get_pinmode(struct ave_private *priv,
 		priv->pinmode_val = SG_ETPINMODE_RMII(0);
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		priv->pinmode_val = 0;
 		break;
 	default:
@@ -1876,6 +1882,9 @@ static int ave_pxs3_get_pinmode(struct ave_private *priv,
 		priv->pinmode_val = SG_ETPINMODE_RMII(arg);
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		priv->pinmode_val = 0;
 		break;
 	default:
-- 
2.7.4

