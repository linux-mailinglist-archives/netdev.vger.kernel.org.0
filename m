Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893E03368F8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhCKAg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:57 -0500
Received: from correo.us.es ([193.147.175.20]:50178 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230081AbhCKAg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 348B412E83B
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2703CDA792
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B462DA78E; Thu, 11 Mar 2021 01:36:27 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3F6BDA78A;
        Thu, 11 Mar 2021 01:36:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id AEDAB42DC6E2;
        Thu, 11 Mar 2021 01:36:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 18/23] net: flow_offload: add FLOW_ACTION_PPPOE_PUSH
Date:   Thu, 11 Mar 2021 01:35:59 +0100
Message-Id: <20210311003604.22199-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an action to represent the PPPoE hardware offload support that
includes the session ID.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e6bd8ebf9ac3..b903874e4c47 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -147,6 +147,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
 	FLOW_ACTION_GATE,
+	FLOW_ACTION_PPPOE_PUSH,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -272,6 +273,9 @@ struct flow_action_entry {
 			u32		num_entries;
 			struct action_gate_entry *entries;
 		} gate;
+		struct {				/* FLOW_ACTION_PPPOE_PUSH */
+			u16		sid;
+		} pppoe;
 	};
 	struct flow_action_cookie *cookie; /* user defined action cookie */
 };
-- 
2.20.1

