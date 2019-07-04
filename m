Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DD75FEC1
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfGDXtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:49:32 -0400
Received: from mail.us.es ([193.147.175.20]:33468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbfGDXt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 19:49:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E146881408
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D07E01150CB
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CBDD1114D9C; Fri,  5 Jul 2019 01:49:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 315FBDA4D1;
        Fri,  5 Jul 2019 01:49:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 01:49:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E9DBC4265A32;
        Fri,  5 Jul 2019 01:49:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com
Subject: [PATCH 08/15 net-next,v2] net: cls_api: do not expose tcf_block to drivers
Date:   Fri,  5 Jul 2019 01:48:36 +0200
Message-Id: <20190704234843.6601-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704234843.6601-1-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the block_shared flag which is what drivers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix incorrect correction of block_shared in net/sched/cls_api.c

 drivers/net/ethernet/mscc/ocelot_tc.c               | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 2 +-
 include/net/pkt_cls.h                               | 2 +-
 net/sched/cls_api.c                                 | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 5c3bf639f87c..a52c233da571 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -140,7 +140,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = ocelot_setup_tc_block_cb_ig;
-		port->tc.block_shared = tcf_block_shared(f->block);
+		port->tc.block_shared = f->block_shared;
 	} else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
 		cb = ocelot_setup_tc_block_cb_eg;
 	} else {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index fa44dce810ed..a19f4aafc3af 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1313,7 +1313,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	repr_priv = repr->app_priv;
-	repr_priv->block_shared = tcf_block_shared(f->block);
+	repr_priv->block_shared = f->block_shared;
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index cb899c4552f4..cc64dd45dfc2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -663,7 +663,7 @@ struct tc_block_offload {
 	enum tcf_block_binder_type binder_type;
 	struct list_head cb_list;
 	struct net *net;
-	struct tcf_block *block;
+	bool block_shared;
 	struct netlink_ext_ack *extack;
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3f036d50af65..e546d56c1a39 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1073,7 +1073,7 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 		.command	= command,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.net		= dev_net(indr_dev->dev),
-		.block		= indr_dev->block,
+		.block_shared	= tcf_block_shared(indr_dev->block),
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
@@ -1164,7 +1164,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 		.command	= command,
 		.binder_type	= ei->binder_type,
 		.net		= dev_net(dev),
-		.block		= block,
+		.block_shared	= tcf_block_shared(block),
 		.extack		= extack,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
@@ -1194,7 +1194,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 	bo.net = dev_net(dev);
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
-	bo.block = block;
+	bo.block_shared = tcf_block_shared(block);
 	bo.extack = extack;
 	INIT_LIST_HEAD(&bo.cb_list);
 
-- 
2.11.0

