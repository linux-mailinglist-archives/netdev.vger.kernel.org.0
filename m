Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701C7608E50
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 18:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJVQD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 12:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJVQDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 12:03:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A41194209
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 09:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666454632; x=1697990632;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=75pKBPvS9kgzl2DtFvrrPkPTEFENLUZNmkkkdo8ZEuo=;
  b=d+aGk7369QcVEgZzs9qETRbOm6W4lSDvj11p4DhTHyxmWKenfMG8sjoY
   ThwbdDAts+8e0f9/+94k7OVLWi1uIBcIxtI2vjj4cALk1YUxR5BXbLNws
   LhTARHwuyIEuaYRfMkNY6HZosoNsOAmXCL4rfQoOhja0hiilX/lf+SqeS
   hPDRDgoVGuJgWyy+sRCjrsQ9UMl+mz1BbYrv5Du1I70J6mkWTWC18jAQQ
   2kTHpjH/ZxwALYMbjzMCOrVGUTWjmAGwGELHOprImWEXKnz1jhwyW+H3n
   PZmpLhlbdyOnYLekr76XEmwO15w7jSxs5DbeR1ErmI2/r31nxwrEkB0OE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10508"; a="294593379"
X-IronPort-AV: E=Sophos;i="5.95,205,1661842800"; 
   d="scan'208";a="294593379"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2022 09:03:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10508"; a="633269920"
X-IronPort-AV: E=Sophos;i="5.95,205,1661842800"; 
   d="scan'208";a="633269920"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by fmsmga007.fm.intel.com with ESMTP; 22 Oct 2022 09:03:49 -0700
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, linuxwwan_5g@intel.com
Subject: [PATCH V5 net-next 1/2] net: wwan: t7xx: use union to group port type specific data
Date:   Sun, 23 Oct 2022 03:01:30 +0530
Message-Id: <20221022213130.1769470-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Use union inside t7xx_port to group port type specific data members.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
--
v5:
 * Date correction.
---
 drivers/net/wwan/t7xx/t7xx_port.h      |  6 +++++-
 drivers/net/wwan/t7xx/t7xx_port_wwan.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
index dc4133eb433a..fbc6d724b7c2 100644
--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -99,7 +99,6 @@ struct t7xx_port_conf {
 struct t7xx_port {
 	/* Members not initialized in definition */
 	const struct t7xx_port_conf	*port_conf;
-	struct wwan_port		*wwan_port;
 	struct t7xx_pci_dev		*t7xx_dev;
 	struct device			*dev;
 	u16				seq_nums[2];	/* TX/RX sequence numbers */
@@ -122,6 +121,11 @@ struct t7xx_port {
 	int				rx_length_th;
 	bool				chan_enable;
 	struct task_struct		*thread;
+	union {
+		struct {
+			struct wwan_port		*wwan_port;
+		} wwan;
+	};
 };

 struct sk_buff *t7xx_port_alloc_skb(int payload);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
index 33931bfd78fd..24bd21942403 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -109,12 +109,12 @@ static int t7xx_port_wwan_init(struct t7xx_port *port)

 static void t7xx_port_wwan_uninit(struct t7xx_port *port)
 {
-	if (!port->wwan_port)
+	if (!port->wwan.wwan_port)
 		return;

 	port->rx_length_th = 0;
-	wwan_remove_port(port->wwan_port);
-	port->wwan_port = NULL;
+	wwan_remove_port(port->wwan.wwan_port);
+	port->wwan.wwan_port = NULL;
 }

 static int t7xx_port_wwan_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
@@ -129,7 +129,7 @@ static int t7xx_port_wwan_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
 		return 0;
 	}

-	wwan_port_rx(port->wwan_port, skb);
+	wwan_port_rx(port->wwan.wwan_port, skb);
 	return 0;
 }

@@ -158,10 +158,10 @@ static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int
 	if (state != MD_STATE_READY)
 		return;

-	if (!port->wwan_port) {
-		port->wwan_port = wwan_create_port(port->dev, port_conf->port_type,
-						   &wwan_ops, port);
-		if (IS_ERR(port->wwan_port))
+	if (!port->wwan.wwan_port) {
+		port->wwan.wwan_port = wwan_create_port(port->dev, port_conf->port_type,
+							&wwan_ops, port);
+		if (IS_ERR(port->wwan.wwan_port))
 			dev_err(port->dev, "Unable to create WWWAN port %s", port_conf->name);
 	}
 }
--
2.34.1

