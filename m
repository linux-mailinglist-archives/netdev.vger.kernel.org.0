Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1679424CDF1
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHUGYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgHUGYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:24:00 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD0B20738;
        Fri, 21 Aug 2020 06:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597991039;
        bh=f9GHoSI3bj3B0+EkJHo25oUBA3rd6294XyDZilj+fEs=;
        h=Date:From:To:Cc:Subject:From;
        b=tdWP0HC4nS4OTp7GxkJIYy/4Usben0/It8Y42dYIPZwx++UKa8sWvrGywcBPvtfff
         TQKIznP5kusWxSracY7nCJSMOvcaYD6JKR6WdAwoBpcYc4AVy23aQtbawF3nUvvTAL
         xnrHp23cYRgAwbwb83B4D5+Ultgf8hpuonPOhSOk=
Date:   Fri, 21 Aug 2020 01:29:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] prism54: Use fallthrough pseudo-keyword
Message-ID: <20200821062947.GA10202@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intersil/prism54/isl_38xx.c   | 2 +-
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  | 2 +-
 drivers/net/wireless/intersil/prism54/islpci_dev.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/prism54/isl_38xx.c b/drivers/net/wireless/intersil/prism54/isl_38xx.c
index a1f956707887..ae964de347f7 100644
--- a/drivers/net/wireless/intersil/prism54/isl_38xx.c
+++ b/drivers/net/wireless/intersil/prism54/isl_38xx.c
@@ -223,7 +223,7 @@ isl38xx_in_queue(isl38xx_control_block *cb, int queue)
 		/* send queues */
 	case ISL38XX_CB_TX_MGMTQ:
 		BUG_ON(delta > ISL38XX_CB_MGMT_QSIZE);
-		/* fall through */
+		fallthrough;
 
 	case ISL38XX_CB_TX_DATA_LQ:
 	case ISL38XX_CB_TX_DATA_HQ:
diff --git a/drivers/net/wireless/intersil/prism54/isl_ioctl.c b/drivers/net/wireless/intersil/prism54/isl_ioctl.c
index 3ccf2a4b548c..9192c5a3923e 100644
--- a/drivers/net/wireless/intersil/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/intersil/prism54/isl_ioctl.c
@@ -1691,7 +1691,7 @@ static int prism54_get_encodeext(struct net_device *ndev,
 	case DOT11_AUTH_BOTH:
 	case DOT11_AUTH_SK:
 		wrqu->encoding.flags |= IW_ENCODE_RESTRICTED;
-		/* fall through */
+		fallthrough;
 	case DOT11_AUTH_OS:
 	default:
 		wrqu->encoding.flags |= IW_ENCODE_OPEN;
diff --git a/drivers/net/wireless/intersil/prism54/islpci_dev.c b/drivers/net/wireless/intersil/prism54/islpci_dev.c
index efd64e555bb5..8eb6d5e4bd57 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_dev.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_dev.c
@@ -918,7 +918,7 @@ islpci_set_state(islpci_private *priv, islpci_state_t new_state)
 	switch (new_state) {
 	case PRV_STATE_OFF:
 		priv->state_off++;
-		/* fall through */
+		fallthrough;
 	default:
 		priv->state = new_state;
 		break;
-- 
2.27.0

