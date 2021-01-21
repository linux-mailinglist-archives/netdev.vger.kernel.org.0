Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1532FDFC9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393298AbhAUCw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436891AbhAUCoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:44:54 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A34C061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:28 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ke15so475182ejc.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8y025S3vriNWkRkdICFZHqI7OsvKLVZnuyKun5pvBcI=;
        b=F6RIKK0lL2bJVxrkZY9a3tCSFnvWsWC+QSZv288BAFJhZuT3AIh+FBv9tRXjY1cqm8
         TE+AndDxF3m9hlVD/ktzJJGoKQxvXp6RBqG4ljHgWP5s7fdm5VnsBCYps+TgxYv9t8J/
         9RyJrrkC34Z04fLGLT/6WF7B6Wan6nQ/bBUFUJuAjAZPdsaW4RFekOVdm5GoQ4sgHoYG
         R17g8rN/Xrtyg3RpYFdNk4LSBZmRcseE6JPPmbD3l4Wo7hlFJqdsjFQz5QGtSfpUgUUX
         bmGnmxs7Nx15ptrVlke1/CEytUmZg0qG5h0hiB5Jwry8OvtKBDaj4+0rz/tr/9oZ3q0z
         CnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8y025S3vriNWkRkdICFZHqI7OsvKLVZnuyKun5pvBcI=;
        b=SzBYYGuQCaDtueHFbMQ9UKYF0Z3zCzZf9XDeDdOHhrNeWPLLAFhvEqsLJmr0v49EOO
         K+SLGGi+YjAM9aaqO/PsOoc099V8TeTT9Ku2fwgFi0UUGBFdYmbylIGjH8Jy/qMsWj3C
         6+40L8sE6HDQXEDC6XdZxZGGX/2r8LR8C/SSpsbeTsnNTgXgLaXQ3ZiBB7+fTRqg1csS
         wxNIFrMLmuRFJu4zMe88wRkSLJlAsUnYdqtJ+qk+xb83vvWM/ThlE15C9i7DZcov1E1X
         tjVr7DkE9D+Wq+fP2qUngad/NbyC1wghcPm2ylJVz/lbaMsBpTB/V5sEZXSX6CSubzQo
         wu7w==
X-Gm-Message-State: AOAM530xKT7HFwEOOFfQc3zzXpS1icem9wmhfx9UYVqxl1EPSQ+TLIN/
        NlzeMtZj8j6o3ZNA0SqejJs=
X-Google-Smtp-Source: ABdhPJwkwASrM5ku29ompjWC196Cb0uJF4lxkY8jGX7IK2GMsKTTvuQltzNJ4aSMhDS+i8PnFGOVqQ==
X-Received: by 2002:a17:907:d25:: with SMTP id gn37mr7539234ejc.381.1611196587300;
        Wed, 20 Jan 2021 18:36:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k22sm2025787edv.33.2021.01.20.18.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 18:36:26 -0800 (PST)
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
Subject: [PATCH v5 net-next 01/10] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Thu, 21 Jan 2021 04:36:07 +0200
Message-Id: <20210121023616.1696021-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121023616.1696021-1-olteanv@gmail.com>
References: <20210121023616.1696021-1-olteanv@gmail.com>
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

