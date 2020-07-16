Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8AB222F2A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGPXjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgGPXjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:39:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0A8C061755;
        Thu, 16 Jul 2020 16:39:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o8so12104658wmh.4;
        Thu, 16 Jul 2020 16:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9JMwR527r9eNpJo4hJyPTUesaRtBeCH+5tZ3xcT2Rm8=;
        b=tTU9gCaXrp51Id/kfdWKN1O0uzrOidYO8xs9DcOYM9hj8BzJ75ps5/kZlHuTC0B5g8
         U8IKsC86Nc2WXf7WaR8mpclYwG5uBdGDHc97UPB3Hzs8TKyEokZENAmLT7ZT11hg4cm9
         2e4qW84HvpNqqeTwiTrcmGMci7GHHYeV8nrQtPXD13UixuY8C7gfLSXNLQXg+tb7JKA6
         YXwa2yBkjefRSKIE6ziE4UBz7Ore0RUo9qUPqsRcs/rMwAvqSFa7roZgWni0BaC8wK3/
         XNxOYYxq/jmK68SPMoJl5I4AuT8aTZn/8DXCrc/giYpvD6EY2UX8bk7aQMMQ9LSIZKn9
         afew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9JMwR527r9eNpJo4hJyPTUesaRtBeCH+5tZ3xcT2Rm8=;
        b=Lv7LTr27OD+mj8Y3Vhr5J2TsxVF4PSQOqcDIgJLfZbs2Fc3NrjkttizHGRvWESDxN1
         SxlFWKrc/L1csMrcgNd0wSKIKf3CuCVmN7DvnnT1huiChNoE5S03+oPHzO8trBjSHfZd
         tTvxTyV9tUWx1vMLigFvsvtPeF5pRiJKN8l5P2VGzPw6kVONbg5b3cYJZTTXcbzjckRV
         5F/4AQU9BrAqTkZHTZbUVClRFid3S6SxOUSYQ+zkPHhYy16H7blUGki5wm0JJPl3eSww
         qHBkhChugMDQYNMcNMcGmt9aWGZt9iQEno/ZgcWlHjuPDcF4eH19gBSx8q+4cop28b4E
         kXJQ==
X-Gm-Message-State: AOAM5338Y7rL/eKDz1ULkBOj1xoxsTo7ny7Hp7/wbe3LEHUI4OVsBv41
        Zr61tePSX5xTyjWglD1mF9Q=
X-Google-Smtp-Source: ABdhPJwpl+WtdAdEL6e/tFRp1Bi06kGdMC+z1nikEAyDuwgucFf+sIZmUhdhko1w1Ho1NVrQd9M+EQ==
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr6473908wmi.95.1594942746024;
        Thu, 16 Jul 2020 16:39:06 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u65sm11278013wmg.5.2020.07.16.16.39.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 16:39:05 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 2/3] net: bcmgenet: test RBUF_ACPI_EN  when resuming
Date:   Thu, 16 Jul 2020 16:38:16 -0700
Message-Id: <1594942697-37954-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
References: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the GENET driver resumes from deep sleep the UMAC_CMD
register may not be accessible and therefore should not be
accessed from bcmgenet_wol_power_up_cfg() if the GENET has
been reset.

This commit adds a check of the RBUF_ACPI_EN flag when Wake
on Filter is enabled. A clear flag indicates that the GENET
hardware must have been reset so the remainder of the
hardware programming is bypassed.

Fixes: f50932cca632 ("net: bcmgenet: add WAKE_FILTER support")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index def990dbf34f..1c86eddb1b51 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -229,9 +229,13 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	}
 
 	/* Disable WAKE_FILTER Detection */
-	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
-	reg &= ~(RBUF_HFB_EN | RBUF_ACPI_EN);
-	bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+	if (priv->wolopts & WAKE_FILTER) {
+		reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+		if (!(reg & RBUF_ACPI_EN))
+			return;	/* already reset so skip the rest */
+		reg &= ~(RBUF_HFB_EN | RBUF_ACPI_EN);
+		bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+	}
 
 	/* Disable CRC Forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-- 
2.7.4

