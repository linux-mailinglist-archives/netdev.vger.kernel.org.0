Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB221C051E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgD3StU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3StU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:49:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F0FC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:19 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f15so2611553plr.3
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ew4N/RKouucCel3ZWYXPN8Zsx28rufeZAtESGarA2EQ=;
        b=qvAYYIM8udT58NGe+IhvxEujyAFUT+kwYYwggaHuxVXW0+g11l3ogriuefNF9f6rk6
         SrZzYCesweZ9Xgk7odSAE5Tx2mY+T1cw6lsxzaeWINkQO7B+SoOo+pCwd35xfHBH3GHk
         n/oMUdIp3ZXIv2CZho0Mn7cwoIYBay5fp0V9S/iD+I6eXBEhmRuLuvneqbbeCUhtxlGO
         Jf6vRm7xzpGr81yhzjiINCDDGu8C0es62RrPMsXgc3vrH8cSyDwF2M1LMuVaIVMbQFwc
         z/1mrU2I8q9RkkMzVHpTqtN3fhShmazFvIKlMxrTYLAzOOpKf31DxKJnVW83kjH6W2S0
         B4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ew4N/RKouucCel3ZWYXPN8Zsx28rufeZAtESGarA2EQ=;
        b=c6lXJs8jgd9RJ8ZJ9IPlinOKK4yU2/eLfx8VttVFqXS3OIPMZHOKALbAXU8W6u8WbK
         +lSGq6VhK/c7ICEgIIadJC/s4BI3cyY0wwtOmcRUNlAuw2J+cC7AriHVBMaM3AVh/Ut8
         cBjzwZAP7eK2EaVdlJ+NmiED/BPidjaxHNc7TPBkrCWJ5A012GewVIdFJppLiQWHXZiC
         8YIRs00PPCFOa9lhaKRVDWOBDcHs2/xQLwDaxinS9pb882RRKwJWQW5sF+iosRuLrR0r
         p6MkiBovuOVcY/OEulUrMpZSHRhSzOF9VfcNbqnf1Ueqvljj+1W4A0oBQBjFNKgQMDII
         CIrQ==
X-Gm-Message-State: AGi0PuZ+diG7GFL5TVdlDSKNZfACDe3GgOn3Xacla6t1Vlzii+MNqMYs
        vLOGee1PzGkc9Phj8QPOX5UNZlD/
X-Google-Smtp-Source: APiQypKlirI7+aREnBoV8cDjh/H71kPgrDKN9ZNon5krIe1zqsMrQ3RxSpVSkFyu9yqQTlqswAWYlA==
X-Received: by 2002:a17:90a:db0a:: with SMTP id g10mr225981pjv.54.1588272558837;
        Thu, 30 Apr 2020 11:49:18 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a23sm426886pfo.145.2020.04.30.11.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 11:49:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next 2/4] net: dsa: b53: Provide number of ARL buckets
Date:   Thu, 30 Apr 2020 11:49:09 -0700
Message-Id: <20200430184911.29660-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430184911.29660-1-f.fainelli@gmail.com>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for doing proper upper bound checking of FDB/MDB entries
being added to the ARL, provide the number of ARL buckets for each
switch chip we support. All chips have 1024 buckets, except 7278 which
has only 256.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 21 +++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 41b75f41677a..aa0836ac751c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2186,6 +2186,7 @@ struct b53_chip_data {
 	u8 cpu_port;
 	u8 vta_regs[3];
 	u8 arl_bins;
+	u16 arl_buckets;
 	u8 duplex_reg;
 	u8 jumbo_pm_reg;
 	u8 jumbo_size_reg;
@@ -2205,6 +2206,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 16,
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2214,6 +2216,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 256,
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2223,6 +2226,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2235,6 +2239,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2247,6 +2252,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2259,6 +2265,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x7f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2271,6 +2278,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.vta_regs = B53_VTA_REGS,
 		.cpu_port = B53_CPU_PORT,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2283,6 +2291,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0xff,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2295,6 +2304,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2307,6 +2317,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0, /* pdata must provide them */
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_63XX,
 		.duplex_reg = B53_DUPLEX_STAT_63XX,
@@ -2319,6 +2330,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2331,6 +2343,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2343,6 +2356,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2355,6 +2369,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2367,6 +2382,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2379,6 +2395,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans	= 4096,
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2391,6 +2408,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x103,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2403,6 +2421,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans	= 4096,
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
+		.arl_buckets = 1024,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2415,6 +2434,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.vlans = 4096,
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
+		.arl_buckets = 256,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2443,6 +2463,7 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->cpu_port = chip->cpu_port;
 			dev->num_vlans = chip->vlans;
 			dev->num_arl_bins = chip->arl_bins;
+			dev->num_arl_buckets = chip->arl_buckets;
 			break;
 		}
 	}
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 1c5c443d571f..694e26cdfd4d 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -118,6 +118,7 @@ struct b53_device {
 	u8 jumbo_size_reg;
 	int reset_gpio;
 	u8 num_arl_bins;
+	u16 num_arl_buckets;
 	enum dsa_tag_protocol tag_protocol;
 
 	/* used ports mask */
-- 
2.17.1

