Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9414F2B3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 20:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgAaTYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 14:24:43 -0500
Received: from correo.us.es ([193.147.175.20]:36812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaTYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 14:24:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 611EEFC602
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 20:24:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53495DA711
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 20:24:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 481CBDA70E; Fri, 31 Jan 2020 20:24:38 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54A49DA710;
        Fri, 31 Jan 2020 20:24:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 20:24:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2679442EFB80;
        Fri, 31 Jan 2020 20:24:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/6] netfilter: flowtable: Fix setting forgotten NF_FLOW_HW_DEAD flag
Date:   Fri, 31 Jan 2020 20:24:27 +0100
Message-Id: <20200131192428.167274-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200131192428.167274-1-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

During the refactor this was accidently removed.

Fixes: ae29045018c8 ("netfilter: flowtable: add nf_flow_offload_tuple() helper")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c8b70ffeef0c..83e1db37c3b0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -675,6 +675,7 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 {
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
-- 
2.11.0

