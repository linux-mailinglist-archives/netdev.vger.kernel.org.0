Return-Path: <netdev+bounces-10109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E995172C498
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4A95281135
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F536168DA;
	Mon, 12 Jun 2023 12:41:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710F53220
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36612C433EF;
	Mon, 12 Jun 2023 12:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686573683;
	bh=LjpXrEeTcB1Fm83RKr+CRzUCyhnCEVz+Bc2E3LKJa00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/XYks2C6ryLHmOejgKsFrzAqwS+KkEb4b/bj8IluEgvzIdCmvmUZ0KfzV6JtOvPM
	 TE94fMeZtPCL7aBaJcSSgxNcjGyUttsE5YiTb3D4BCBKxbqmRhkMvyFabGPSjz94eg
	 kgr4ccoTNyszdxSB7U5/WnI71j8I0J9gTOudkl4EIZCcYAyP/UJJWKbddULaXPH9SV
	 Gq9CpdC3xXyMzOq4HQn1yk4hgjI4XVYLK9pcDkh8/dhCkTE9zL2rQoWp0rb888XLo3
	 mgVFjY0r9HbfDN8X51PbdKMinlW0MWeriOaBTcyDtlTKPbUIgvHcoFAH5+E0aYtdUd
	 J0EoJo+XOAOMQ==
From: Arnd Bergmann <arnd@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
	linux-omap@vger.kernel.org,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Tero Kristo <kristo@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mao Wenan <maowenan@huawei.com>,
	Andrew Lunn <andrew@lunn.ch>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 2/3] net: ethernet: ti-cpsw:: rename soft_reset() function
Date: Mon, 12 Jun 2023 14:40:05 +0200
Message-Id: <20230612124024.520720-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612124024.520720-1-arnd@kernel.org>
References: <20230612124024.520720-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

While looking at the glob symbols shared between the cpsw drivers,
I noticed that soft_reset() is the only one that is missing a proper
namespace prefix, and will pollute the kernel namespace, so rename
it to be consistent with the other symbols.

Fixes: c5013ac1dd0e1 ("net: ethernet: ti: cpsw: move set of common functions in cpsw_priv")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ti/cpsw.c      | 2 +-
 drivers/net/ethernet/ti/cpsw_new.c  | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index f9cd566d1c9b5..a61edee2289f1 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -679,7 +679,7 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 	struct cpsw_common *cpsw = priv->cpsw;
 
 	/* soft reset the controller and initialize ale */
-	soft_reset("cpsw", &cpsw->regs->soft_reset);
+	cpsw_soft_reset("cpsw", &cpsw->regs->soft_reset);
 	cpsw_ale_start(cpsw->ale);
 
 	/* switch to vlan unaware mode */
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index c61e4e44a78f0..4e7fec1ce8d9c 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -551,7 +551,7 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 	u32 control_reg;
 
 	/* soft reset the controller and initialize ale */
-	soft_reset("cpsw", &cpsw->regs->soft_reset);
+	cpsw_soft_reset("cpsw", &cpsw->regs->soft_reset);
 	cpsw_ale_start(cpsw->ale);
 
 	/* switch to vlan unaware mode */
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index e966dd47e2db3..4ebe8bc325730 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -275,7 +275,7 @@ void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv)
 	slave_write(slave, mac_lo(priv->mac_addr), SA_LO);
 }
 
-void soft_reset(const char *module, void __iomem *reg)
+void cpsw_soft_reset(const char *module, void __iomem *reg)
 {
 	unsigned long timeout = jiffies + HZ;
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 34230145ca0b5..efc5c69e93028 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -456,7 +456,7 @@ int cpsw_tx_poll(struct napi_struct *napi_tx, int budget);
 int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget);
 int cpsw_rx_poll(struct napi_struct *napi_rx, int budget);
 void cpsw_rx_vlan_encap(struct sk_buff *skb);
-void soft_reset(const char *module, void __iomem *reg);
+void cpsw_soft_reset(const char *module, void __iomem *reg);
 void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv);
 void cpsw_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue);
 int cpsw_need_resplit(struct cpsw_common *cpsw);
-- 
2.39.2


