Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5973EE796E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbfJ1TxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:53:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38522 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731665AbfJ1Twg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:52:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id t26so6389849qtr.5;
        Mon, 28 Oct 2019 12:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Igiz0PHEzjawHkIz8yU4xnNdwU2P3+i3Ihxmg3Ldp0=;
        b=R+6t1Rb2tKs5FgJX0O4GzsK/bmzvGiN2tL60ki5UN1do1P3CrzvKWbuue4YVXG2aGp
         +dIGvyvxmjIg4ZN0ucrzGjJqk7DHD/ethNb6mnl0hDa1v1l7OY2rMFaumzuaaJqExE8q
         mgDgad7cajJWKrlMuHvDOmS85HwoZkCMNc4exProz5ZOdVmLdhK8eyCnc2hmXRd5WDyY
         qIccGA9ZPdH5s5Pf1YQE9weGqUnQAMwJn0MiwKEsZ2ErV8/2u8JLOI/zLPOBv4OPEBiY
         4yxYgG6tpawlYX/xAtb68zWuKO0nkeR7uaqHxoe4bFojD96i9h3GYZYjqebTct/75Wer
         pWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Igiz0PHEzjawHkIz8yU4xnNdwU2P3+i3Ihxmg3Ldp0=;
        b=k6gWS1pNjQHirFdLrTh3rJnq1vdWHwKzWSG4xP1QxyKW9m8SNTfNy9ldxilKSC7Ana
         TXi+ZXoTVl/XX1xiax+u3/aoR8TGA3tpG7g78kZFVUYig92Kn0qENxHYxzi770Jdxp2W
         /V1jeYNpfIiYUa1+FQHgHFtqhyWbqHQYKO/JFZtHRskrF9Hg5/eU3aL4uDfnTTU4t1nM
         CzvJjlJBkF/e8VALOrHpNFBEAwtARJVi2kyholMPn7Yiw1NtkS6k1yt4/0Uu/Ap55Pxa
         2buANyDVYl282VTkCUiexFQjJZw9TgrIScrFfglsSlx/Bj15uBnOr5CKqEYcQWeY7ciB
         2igQ==
X-Gm-Message-State: APjAAAUqni5ne3AClBD+lzeNDb8KsmPHT568n8QDuHjTSxhdih4aNoHH
        MosawzMF94F4iRAWmAZZ+T9BVu5O
X-Google-Smtp-Source: APXvYqzUqult+S7XCSjuTmo0iEoZ75hzMqIPrMJWltXLE457180rrwSnalii34nvRNj7zrlE7mr+Og==
X-Received: by 2002:a0c:95ca:: with SMTP id t10mr18717679qvt.22.1572292353679;
        Mon, 28 Oct 2019 12:52:33 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b185sm7573091qkg.45.2019.10.28.12.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:52:33 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/7] net: dsa: remove switch routing table setup code
Date:   Mon, 28 Oct 2019 15:52:16 -0400
Message-Id: <20191028195220.2371843-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028195220.2371843-1-vivien.didelot@gmail.com>
References: <20191028195220.2371843-1-vivien.didelot@gmail.com>
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
index 248cd13b0ad1..54df0845dda7 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -174,14 +174,13 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
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
@@ -191,25 +190,6 @@ static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
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

