Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E223B1CC23
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfENPqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:46:15 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:35836 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726501AbfENPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:45:42 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E1E81C01B3;
        Tue, 14 May 2019 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557848732; bh=87qMI7z9d1Uv1YsqslX0Keb+m0ZvPiaxNErrA74vtSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=EHQ9jA6thzPlDM4TKhWyqOEHojxrXzFTFrg/WAEsTuIy6zLs/hiSkGdVzENp0wxs9
         zWIw1wTObo92jXAmZg7YdQfQqZUjv2Dm7dsK+8wTWqKJgpa0+mzinpeXUINXiV2Abg
         iqN2gesUSJJ+1JYiUpf5ZDmfJl8awnDM1KbxD6lA2cuyO5Ua6NiWEL2xIkSsPzvzKT
         m1c26P1KhxgCXHRUAtKwIG6s7IZzzXNRkr2vcD9QQUZ5EJ9IqGXjuKrFoz8TqEZiuf
         +DYHdgVS3A+6zQh2O8wDXybSPJpxNSyca4KJvclHIpR7qzu2Xeb+qlYN7c1QWlcQ6S
         y8lJ3Fm8hG3bQ==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1A7D9A00AB;
        Tue, 14 May 2019 15:45:42 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 246CB3EA40;
        Tue, 14 May 2019 17:45:40 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [RFC net-next v2 14/14] net: stmmac: dwmac4/5: Fix Hash Filter
Date:   Tue, 14 May 2019 17:45:36 +0200
Message-Id: <a9fffe7f06f8aaaa86d85f4f944cc8b79acd8928.1557848472.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for hash filter to work we need to set the HPF bit.

Fout out while running stmmac selftests

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index c3cbca804bcd..01c10893b7a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -65,6 +65,7 @@
 #define GMAC_PACKET_FILTER_HMC		BIT(2)
 #define GMAC_PACKET_FILTER_PM		BIT(4)
 #define GMAC_PACKET_FILTER_PCF		BIT(7)
+#define GMAC_PACKET_FILTER_HPF		BIT(10)
 
 #define GMAC_MAX_PERFECT_ADDRESSES	128
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 02a3a7e2db6e..094bd069c093 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -438,6 +438,8 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		writel(mc_filter[1], ioaddr + GMAC_HASH_TAB_32_63);
 	}
 
+	value |= GMAC_PACKET_FILTER_HPF;
+
 	/* Handle multiple unicast addresses */
 	if (netdev_uc_count(dev) > GMAC_MAX_PERFECT_ADDRESSES) {
 		/* Switch to promiscuous mode if more than 128 addrs
-- 
2.7.4

