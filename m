Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D182FF04E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbhAUQaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387603AbhAUQDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:03:03 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42019C061756
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:23 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id kg20so2842991ejc.4
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w7P1tLFexVDYB6k5zrT1PxDldYYnJoQE5NuUjASNLGw=;
        b=LFmlLtt+Acxh/qwT73ObWB1useEO3WuD7DZY5hr+3hrwC+sosbwgGWIeMLVar93Wdt
         ELXegr1NGc4C1tAn4vzg/RSQoo/9gvT33ylTfYWNbWSPS4RDmi/Qu0jwjc31hG5HIiWY
         /mYhL0AOD8RSthuW7FVq6pniz18d4BLbvN+eMApNT9qS7iPBPTzNYjtxcqg6ngTvML2z
         /InQQRRfeKvAaV+UBKUisD1LAuCdd9EyVlkfRLnHRQN6C7XdIP2FzZxoi3QPF8HAxffF
         YolNrFfbLVTcD7Ioh2s0ANpOaFQxfVe2Y7U0wRj8KN0qfqK9HysQ1RVEbzcmmq31/NKI
         +tkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w7P1tLFexVDYB6k5zrT1PxDldYYnJoQE5NuUjASNLGw=;
        b=jobGi1+Zlrb/4PZ1Dg+Iwj/AfmQTi74fxAYDdRDp6XTpmBhAlcjur1zNcR2ijTDao4
         JvojOffYwiiAL2zFSrgydQm3rTJH6tRfUzBuAYgljU0JcT7dhZiOhXCuTLsu0rkHqIbD
         6tVBRmEbVqKj+HBsjBiG14749iHUnbv25VPUOKPkXR3NKyJF0Rx48khy6eWYf4PL93cN
         wDGsasY6VPjh5kIha0qevgfEJ98FkuEwHKcfgfRj8LMlipS6FVfkxmYEMOBlAYNj5aj9
         0HcImuwFC4CI4o43QprHZlepU9hFcQwaCxV4Wir9NrFe5IyMO08e3yZUFIcqsx3N/x7K
         FgjA==
X-Gm-Message-State: AOAM530xVzGuQtKXhiPzBfs8ugLranx01JIE80LEtwlGiG/WWsJeaxga
        zvQhCnjMdHrOklMTXg3znaE=
X-Google-Smtp-Source: ABdhPJwpPohXvaTBXG3seySv2XWVJhLTsrp7ScSiJ4L6MCR5anN3H5P3OFSY8CzxEqg7RmJ5us5Ozg==
X-Received: by 2002:a17:906:3401:: with SMTP id c1mr126504ejb.156.1611244942037;
        Thu, 21 Jan 2021 08:02:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk10sm2419973ejb.10.2021.01.21.08.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:02:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 01/10] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Thu, 21 Jan 2021 18:01:22 +0200
Message-Id: <20210121160131.2364236-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121160131.2364236-1-olteanv@gmail.com>
References: <20210121160131.2364236-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 implementation can be blind about this, but the felix driver
doesn't do exactly what it's being told, so it needs to know whether it
is a TX or an RX VLAN, so it can install the appropriate type of TCAM
rule.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 include/linux/dsa/8021q.h | 14 ++++++++++++++
 net/dsa/tag_8021q.c       | 15 +++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 88cd72dfa4e0..b12b05f1c8b4 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -64,6 +64,10 @@ int dsa_8021q_rx_source_port(u16 vid);
 
 u16 dsa_8021q_rx_subvlan(u16 vid);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid);
+
 bool vid_is_dsa_8021q(u16 vid);
 
 #else
@@ -123,6 +127,16 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 	return 0;
 }
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return false;
+}
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return false;
+}
+
 bool vid_is_dsa_8021q(u16 vid)
 {
 	return false;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8e3e8a5b8559..008c1ec6e20c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -133,10 +133,21 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_rxvlan);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_txvlan);
+
 bool vid_is_dsa_8021q(u16 vid)
 {
-	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
-		(vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX);
+	return vid_is_dsa_8021q_rxvlan(vid) || vid_is_dsa_8021q_txvlan(vid);
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
-- 
2.25.1

