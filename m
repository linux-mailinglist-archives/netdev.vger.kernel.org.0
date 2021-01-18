Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3AA2FA610
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406662AbhARQZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406016AbhARQSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:18:23 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBC8C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:43 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id by1so18060673ejc.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JiJPyvGU3jXkoRLRz8RxWkW51qs59GzDfc6TYmdS4eo=;
        b=Ud2f3qzcwyb+3xuKxh2CeKWL8zZffOwEX8FhiyRsMNQmyQPD+hh6HuKA5R3kWl9rcu
         fa1OdCug1oKMiERBdyEJAjdA4AkihGcBX5gje3PRWsaSiwVvAGUD3u0WH/icvH4viWKd
         T+FMWgq5EVXsAX1/JWNnt3XlYYnwPViGzeMjBlghZ5QDQ3QxjkBg+GRcqFNFcpkQWLh7
         yFkc+6dl3U6ZKefNrztp3TimEIB7uOC4QTzMeBnWSVKvXsNyayTLNTSDrRMWnK9+FdhZ
         l/Pg3cl9ODwgoknRKRcOxcci1Z/PHFFwuP9Z6Bw1AMYYSglyCRbVP29dLQCPjFcpDIvy
         QRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JiJPyvGU3jXkoRLRz8RxWkW51qs59GzDfc6TYmdS4eo=;
        b=jYr8J8Ycl7f1orLtedGioHMjiYhmOogSRc23v/wIaUtJ/1LkvMISPDXrUXkkmmYH88
         wZaAbGDz7sYtYcDYT4hSYiZ/huW6DQSpHVV3lzrWmuOuX2g05ldS+pXkKtktAZ/BSLC8
         9tN8rRaH0gxhXEnFE7dBY549Q/919aSky6U/OVZobq8f/Xz44Jpau6Hgd5ex4/ESaEVv
         2d0T3gs1YQ7ZrYIyxr1O3542mfMx+ACgNRZBUUUNyDGTNaq7L/GvhhJ99AhIFT3jwBsr
         r4YlaV4KOEpC2t+1MIHFL/mGLdfCquNTAx57ld2jkcuyBRbuSBtQ/2rhYraNqUXpXz+E
         fw4w==
X-Gm-Message-State: AOAM533jngiJwYSkhRzFUngE4WwPRG82saIa6cEpPvfJyMG+WWvYJBzI
        X09rYq5So35xebX/x5l0TC4=
X-Google-Smtp-Source: ABdhPJzRhThuv0ql5GzpM3aNJot0iHtjY1AiOJP7SngWtQRcmx99OA+dGrS0w5RGpPv856jMLgaIsA==
X-Received: by 2002:a17:907:3e06:: with SMTP id hp6mr313028ejc.254.1610986661974;
        Mon, 18 Jan 2021 08:17:41 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:41 -0800 (PST)
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
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 01/15] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Mon, 18 Jan 2021 18:17:17 +0200
Message-Id: <20210118161731.2837700-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
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
---
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

