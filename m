Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B1D2C93E5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389115AbgLAA0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389108AbgLAA0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:26:37 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF2BC0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:25:56 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id p6so88736plr.7
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G3VQbjm0y4Z02ETG2i1t0wc1IBQxjIaQMqDP66FdEXQ=;
        b=sDGoNzgAXMZwSosyJpsGBFkWfu3+WdwFNlJAfzoUwdgbGcK6pFACn1kXMbtGI+8hFK
         LPP3LgMHES8xhiEiVCiZlydr1v+7kwX50TnxR2X60MEMgjOXtENHth59rrzM7VmucdC6
         oxHxYKNrqZpjECHYREBaNr3kUVVb5+uVzCWhuD3jp/LX7lPCMd+T1oiy5XLZnfgOLBbO
         5QG7QijsUoXi3MvfUdC7VvxT14PClS1LH7JmUAYFpgVqgimdLtN4uPp2XJjQEdGrWjFn
         x/XFNZo0vhW+crJlEXWdnSAbt+luy0K2KKzFBTBUPp/O9bq+psOcMEPL692zYCzCNgrG
         yYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G3VQbjm0y4Z02ETG2i1t0wc1IBQxjIaQMqDP66FdEXQ=;
        b=tm5vWY+vHYiO05O03wJgoGfHXOcacnaInkY4yvWvDt6Rx874HlXIjYV/Yc/0EscQyC
         cvwQxVOnbGDueE6jU+7sKmZ1kWKvBV0yENFqdnSzfaMZ3NAYcaTTL92hzuynTRW0ueSH
         eZZYdO5yWcEXKKRLYZVnFvQCmcMPz2y1pVuR/CEFFgDa5CW1jrbaHp7H6addeWV3sQoh
         CEvzaaGRuROLXvA/j0jyLgH4szwVU3fwpPmBMpXaPSv9ZTMsZ8oDBV0mIaFbgL7SrpGU
         4d7ibQL0FgW/InP/4hZMV8QV8S6snglicV/UCrpw6LwrH1QRBOAKDdNWDYfELYs69wKy
         hJ1g==
X-Gm-Message-State: AOAM531GE9oBbzZCfhS7LHXe2oo5fQUQ2bxLexNg8eC2K8mMUwknDsC3
        Uy5EJUJvZiHVqdXER19Ghi34ZEdXGHh/yA==
X-Google-Smtp-Source: ABdhPJwe1N6F7gTIVz1AARnwILK48JMI1aDWlUBAYXa8icVQIl9sjVgghkIpK9u6PSbAPSlQYTit1A==
X-Received: by 2002:a17:90a:f694:: with SMTP id cl20mr403909pjb.179.1606782355877;
        Mon, 30 Nov 2020 16:25:55 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id q12sm172632pgv.91.2020.11.30.16.25.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 16:25:55 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/2] ionic: remove some unnecessary oom messages
Date:   Mon, 30 Nov 2020 16:25:45 -0800
Message-Id: <20201201002546.4123-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201002546.4123-1-snelson@pensando.io>
References: <20201201002546.4123-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove memory allocation fail messages where the OOM stack
trace will make it obvious which allocation request failed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c  | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 8 +++-----
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 4 +---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 318db5f77fdb..fb2b5bf179d7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -142,7 +142,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (!work) {
-				dev_err(ionic->dev, "%s OOM\n", __func__);
+				dev_err(ionic->dev, "LIF reset trigger dropped\n");
 			} else {
 				work->type = IONIC_DW_TYPE_LIF_RESET;
 				if (fw_status & IONIC_FW_STS_F_RUNNING &&
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0afec2fa572d..0b7f2def423c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -842,7 +842,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 	case IONIC_EVENT_RESET:
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
 		if (!work) {
-			netdev_err(lif->netdev, "%s OOM\n", __func__);
+			netdev_err(lif->netdev, "Reset event dropped\n");
 		} else {
 			work->type = IONIC_DW_TYPE_LIF_RESET;
 			ionic_lif_deferred_enqueue(&lif->deferred, work);
@@ -1051,10 +1051,8 @@ static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
 
 	if (!can_sleep) {
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work) {
-			netdev_err(lif->netdev, "%s OOM\n", __func__);
+		if (!work)
 			return -ENOMEM;
-		}
 		work->type = add ? IONIC_DW_TYPE_RX_ADDR_ADD :
 				   IONIC_DW_TYPE_RX_ADDR_DEL;
 		memcpy(work->addr, addr, ETH_ALEN);
@@ -1183,7 +1181,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
 		if (!can_sleep) {
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (!work) {
-				netdev_err(lif->netdev, "%s OOM\n", __func__);
+				netdev_err(lif->netdev, "rxmode change dropped\n");
 				return;
 			}
 			work->type = IONIC_DW_TYPE_RX_MODE;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index d355676f6c16..fbc57de6683e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -511,10 +511,8 @@ int ionic_port_init(struct ionic *ionic)
 						     idev->port_info_sz,
 						     &idev->port_info_pa,
 						     GFP_KERNEL);
-		if (!idev->port_info) {
-			dev_err(ionic->dev, "Failed to allocate port info\n");
+		if (!idev->port_info)
 			return -ENOMEM;
-		}
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
-- 
2.17.1

