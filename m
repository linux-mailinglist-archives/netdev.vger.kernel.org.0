Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DA3B1C44
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbfIMLbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:35 -0400
Received: from correo.us.es ([193.147.175.20]:42626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388182AbfIMLbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA7A24FFE06
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB3CFA7E1E
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C0F70A7E0F; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0C00A7E16;
        Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7304C4265A5A;
        Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 26/27] netfilter: conntrack: remove CONFIG_NF_CONNTRACK checks from nf_conntrack_zones.h.
Date:   Fri, 13 Sep 2019 13:31:01 +0200
Message-Id: <20190913113102.15776-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

nf_conntrack_zones.h was wrapped in a CONFIG_NF_CONNTRACK check in order
to fix compilation failures:

  37ee3d5b3e97 ("netfilter: nf_defrag_ipv4: fix compilation error with NF_CONNTRACK=n")

Subsequent changes mean that these failures will no longer occur and the
check is unnecessary.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_zones.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 33b91d19cb7d..48dbadb96fb3 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -3,9 +3,6 @@
 #define _NF_CONNTRACK_ZONES_H
 
 #include <linux/netfilter/nf_conntrack_zones_common.h>
-
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
 #include <net/netfilter/nf_conntrack.h>
 
 static inline const struct nf_conntrack_zone *
@@ -88,5 +85,5 @@ static inline bool nf_ct_zone_equal_any(const struct nf_conn *a,
 	return true;
 #endif
 }
-#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_ZONES_H */
-- 
2.11.0

