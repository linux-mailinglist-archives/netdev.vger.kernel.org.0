Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03FF2FC477
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbhASXJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbhASXIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:08:43 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC218C061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:01 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a10so14280218ejg.10
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yFdeO5pbvs0oUv+cj/w2+IaBK0rT2rHtLkBoBasLdpI=;
        b=tJKrWbqYtlGmIi0GJ7QAiMMxccgHNpFYfYPIsKmc8IfqCDfy1lgmDfXUzByaUomQXL
         8kNMF1lKapQop7h4mqOsIybPeuJkB7CwiSVDBxBJetapEyD8zvzk4b16A84C7NbljQ+b
         NLFFOCCNe3c7pQWOeApoKfEnnEesgfw2P4HACxwayPUgC6X9GXoX0b/YvKmUAteuqMyi
         1KgxjQ2B/p1BXyKFehzH/JAP7io+PY7TBxQqtOWaR3XPIu9+KMCvBvO7ZNnG/q84r7cE
         9QNRiBDcQ94j/Pgh2pzoQ/KhlsdnmsvV3Sm1Y+9OHtSmivv82GPsNnAobqUlGij3gyKn
         lRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFdeO5pbvs0oUv+cj/w2+IaBK0rT2rHtLkBoBasLdpI=;
        b=jZukHZG7SS/zwfNKBaYFEOpdncASl1VrleGuWU9nVmIR4nVy3aD41+YNRnGCGMmE2k
         f8ccX1vqoxnbFWf6FAH8dJMW6nt3sFZc6OEJrV0vkhGp/WMqTZhbRQTu6lfZsvRZqsL1
         KNuHamceLSVP5FERpTxkFFGQrFrBcjld4U16KpQG/mo+1NULMTsg+F7FFkxOOMWJNIBx
         Bqk0fheziITBpgw3rFPLYeX/XaSLexC0C4uz943vofzgAfG2zpvFD2SYQgZ3tUGIXjRO
         39133o8Ro0C3hfQ6N7x6SIMhjLKW4ZdWCUhx/mETONSgHHLYOlukaymNNCYVwsHlmXq/
         jdDQ==
X-Gm-Message-State: AOAM531lGVFCaV5ZvzhWMGTaqQww0UKoMt6PMF2D16Em00KaMgxeJ65X
        t/2C+P/+JQ1sArWVeZdM4mM=
X-Google-Smtp-Source: ABdhPJxg+Iki1tTgufiC1gbpn7A0RSZEsPfpeTl1jFxIfaN1WoX3EQ5+8eOEsS+tPgi8f6FKYTolwA==
X-Received: by 2002:a17:906:c9cc:: with SMTP id hk12mr2459254ejb.134.1611097680597;
        Tue, 19 Jan 2021 15:08:00 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:00 -0800 (PST)
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
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 01/16] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Wed, 20 Jan 2021 01:07:34 +0200
Message-Id: <20210119230749.1178874-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
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

