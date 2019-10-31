Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13ABEA918
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfJaCJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:09:39 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41899 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfJaCJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:09:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id m125so5236394qkd.8;
        Wed, 30 Oct 2019 19:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9gGxsqz2ap3fWHU1T7SJzHxfkL9fiW1B2i5/1UDDuY4=;
        b=neFaPwdUmDFj5tlUjM/4S8UWVJO7OBBHelnvSZYEZ9QZmFFp0CJFojg+LG/GtIOj+s
         dOK5w+YQiSRFI58Pr10Tb7NHYRy9uAbeEuylAiVB39g26u9Q+ADGH9wpEgEIPB9Lt7Xk
         mbJP44V26LaB6jN5qk5c9wfnnUARJLhckB1qKwCMIHFhhXAgOBIcLSwp0OuxZkCOjz2w
         wMGmOr19mRr+DTclzEMT2PIMWc1LZAkn4btO6ijwCuNMWYCdeVmxgyQUmT7rgqS3YmQp
         V600XY7obXzEoPPCZWKkKvp52UXSaKBO1fJPL3rB4gpUL+aNvJnQncnTW/dqlguB+/2h
         K7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9gGxsqz2ap3fWHU1T7SJzHxfkL9fiW1B2i5/1UDDuY4=;
        b=g4DuuufZjOeif+x9nUpgX4FaFZpd/k1QIKX70tfgpjAcZ99akVKIGV+Q0cUShmb1fa
         6PTMX31m4z0AEyo877pCbbLPCz094mfhZ0040oH+ghuHoZYqAJ7egiOU7H3ItqbaV2qH
         jGslJwM5RZrpAfjo63Gqu991dTMjkCTfQWBeyvSokDsTmuZ0ZJ1/KyJkDNIg0uZTXrPq
         x2/UX4EgHhn0dXrEgYCl+L9dCYveey6NrFhQGP+XfUXN+lQ3OPRc8mmUfRZxr9mfJTp6
         p4G21q7BPO3Y/i9GHLdcPEHJ/P3FcLylDxwLWdecEiWhQJ7VLbKUbyTjFj+LnB28LSPR
         AttQ==
X-Gm-Message-State: APjAAAUCEn63qLttdEBoYTK9XBBlnY3q+6XjJ4T7qYbUupfLd1dSR+Od
        Xq2E6Wbstqdl92Q6oTOx2dk=
X-Google-Smtp-Source: APXvYqzM9Cv/eBogir5yjZZlUuQNNOde0BjIgqM340YgiWT5/xw9dBWSPPsK5e0PVfABEOpwVgwo/g==
X-Received: by 2002:ae9:f80d:: with SMTP id x13mr3185994qkh.63.1572487777633;
        Wed, 30 Oct 2019 19:09:37 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id r36sm1353041qta.27.2019.10.30.19.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:09:37 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/7] net: dsa: remove switch routing table setup code
Date:   Wed, 30 Oct 2019 22:09:15 -0400
Message-Id: <20191031020919.139872-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191031020919.139872-1-vivien.didelot@gmail.com>
References: <20191031020919.139872-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa_switch structure has no routing table specific data to setup,
so the switch fabric can directly walk its ports and initialize its
routing table from them.

This allows us to remove the dsa_switch_setup_routing_table function.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index efd7453f308e..a887231fff13 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -176,14 +176,13 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
 	return true;
 }
 
-static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
+static bool dsa_tree_setup_routing_table(struct dsa_switch_tree *dst)
 {
-	struct dsa_switch_tree *dst = ds->dst;
 	bool complete = true;
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (dp->ds == ds && dsa_port_is_dsa(dp)) {
+		if (dsa_port_is_dsa(dp)) {
 			complete = dsa_port_setup_routing_table(dp);
 			if (!complete)
 				break;
@@ -193,25 +192,6 @@ static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
 	return complete;
 }
 
-static bool dsa_tree_setup_routing_table(struct dsa_switch_tree *dst)
-{
-	struct dsa_switch *ds;
-	bool complete = true;
-	int device;
-
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
-
-		complete = dsa_switch_setup_routing_table(ds);
-		if (!complete)
-			break;
-	}
-
-	return complete;
-}
-
 static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
-- 
2.23.0

