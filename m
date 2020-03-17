Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6C0188315
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCQMJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:09:39 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46586 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgCQMJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:09:38 -0400
Received: by mail-lf1-f68.google.com with SMTP id a28so5125309lfr.13
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 05:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmTVCUwzP2sd2RegUgToB05hVf+yztMs1t67J5XMm00=;
        b=eKcVYTc9qQYhkE1Vi/Z417hbDiE3GtdPrKO4Cc7c/JdRPco1QtbXeyKIXljk94UweA
         LTetgFdKrdZOFkrN7hdUXTWpNrqcvY5Pz4QRsrPOcGKC9x8gSPMQrBTChuqmK/PLJHmh
         vBSF/AmONyIBLVQh/KL85aHRRSZ45u20es0rk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmTVCUwzP2sd2RegUgToB05hVf+yztMs1t67J5XMm00=;
        b=Oc8khcVUa+t5QA+0Nf5UQI1PtyMh687LKMjIA48u+KTS/QAFoHx+bJpKaYJuIJ/PRc
         9e8BApLlXSDz4CdF1KJLCEpSB8ciddhsCDpko6nR85xL1KZOjKfNywaLc841uGbtLN0j
         sYYORIKFfshe+CmSLgzF7n6ytMYVekj8irGRcwIe57XRGdRT21xSv5XyiAXSScq8fcsE
         5v3B/yD048eMONto94dqPE1Ae1CdtlEVMlg9xyneexDIc2HR6Qrg+5/Cw1Lm2iaAgsRN
         GF3RqUGFyryjdGW75mM1k6iF2affLLKJyZIt179VbybfCmftam76CKlNhht84irUKg+6
         3SXg==
X-Gm-Message-State: ANhLgQ2RxUfWLAwnqzXVLc1YtfmraERuP/2uOuxvRXhzLc/FF1QUhade
        DilUi+DXXoHIZNStb2f2uSnsHnmhyGI=
X-Google-Smtp-Source: ADFU+vugWFGwwJhKQb9eK8dDenWdlgqg6g78daI30SkEmNCvy1L/n8cHoAWcl04YtE4oKVZcRUEurw==
X-Received: by 2002:a05:6512:68b:: with SMTP id t11mr2772915lfe.214.1584446974151;
        Tue, 17 Mar 2020 05:09:34 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 23sm2389208lfa.28.2020.03.17.05.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:09:26 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/4] net: bridge: vlan options: rename br_vlan_opts_eq to br_vlan_opts_eq_range
Date:   Tue, 17 Mar 2020 14:08:33 +0200
Message-Id: <20200317120836.1765164-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
References: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is more appropriate name as it shows the intent of why we need to
check the options' state. It also allows us to give meaning to the two
arguments of the function: the first is the current vlan (v_curr) being
checked if it could enter the range ending in the second one (range_end).

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_private.h      | 4 ++--
 net/bridge/br_vlan.c         | 2 +-
 net/bridge/br_vlan_options.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 5153ffe79a01..1f97703a52ff 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1199,8 +1199,8 @@ static inline void br_vlan_notify(const struct net_bridge *br,
 
 /* br_vlan_options.c */
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-bool br_vlan_opts_eq(const struct net_bridge_vlan *v1,
-		     const struct net_bridge_vlan *v2);
+bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
+			   const struct net_bridge_vlan *range_end);
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v);
 size_t br_vlan_opts_nl_size(void);
 int br_vlan_process_options(const struct net_bridge *br,
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6b5deca08b89..09bfda47fbbf 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1694,7 +1694,7 @@ bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 {
 	return v_curr->vid - range_end->vid == 1 &&
 	       range_end->flags == v_curr->flags &&
-	       br_vlan_opts_eq(v_curr, range_end);
+	       br_vlan_opts_eq_range(v_curr, range_end);
 }
 
 static int br_vlan_dump_dev(const struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index cd2eb194eb98..24cf2a621df9 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -7,11 +7,11 @@
 
 #include "br_private.h"
 
-/* check if the options between two vlans are equal */
-bool br_vlan_opts_eq(const struct net_bridge_vlan *v1,
-		     const struct net_bridge_vlan *v2)
+/* check if the options' state of v_curr allow it to enter the range */
+bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
+			   const struct net_bridge_vlan *range_end)
 {
-	return v1->state == v2->state;
+	return v_curr->state == range_end->state;
 }
 
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
-- 
2.24.1

