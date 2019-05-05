Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544CC14302
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfEEXdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:18 -0400
Received: from mail.us.es ([193.147.175.20]:34090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbfEEXdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C5DF411ED8D
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3BEFDA70A
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9721DA708; Mon,  6 May 2019 01:33:15 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA257DA701;
        Mon,  6 May 2019 01:33:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 753364265A31;
        Mon,  6 May 2019 01:33:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/12] netfilter: nf_tables: drop include of module.h from nf_tables.h
Date:   Mon,  6 May 2019 01:32:56 +0200
Message-Id: <20190505233305.13650-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

Ideally, header files under include/linux shouldn't be adding
includes of other headers, in anticipation of their consumers,
but just the headers needed for the header itself to pass
parsing with CPP.

The module.h is particularly bad in this sense, as it itself does
include a whole bunch of other headers, due to the complexity of
module support.

Since nf_tables.h is not going into a module struct looking for
specific fields, we can just let it know that module is a struct,
just like about 60 other include/linux headers already do.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 706f744f7308..5b8624ae4a27 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -2,7 +2,6 @@
 #ifndef _NET_NF_TABLES_H
 #define _NET_NF_TABLES_H
 
-#include <linux/module.h>
 #include <linux/list.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -13,6 +12,8 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netlink.h>
 
+struct module;
+
 #define NFT_JUMP_STACK_SIZE	16
 
 struct nft_pktinfo {
-- 
2.11.0

