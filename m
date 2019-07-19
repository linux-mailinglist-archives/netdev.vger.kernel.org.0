Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E006E990
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732164AbfGSQqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:46:35 -0400
Received: from mail.us.es ([193.147.175.20]:50244 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732115AbfGSQqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:46:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 67A14BAEE6
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:46:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 588751150CC
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:46:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4C7E71150B9; Fri, 19 Jul 2019 18:46:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59101DA708;
        Fri, 19 Jul 2019 18:46:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:46:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BBA774265A2F;
        Fri, 19 Jul 2019 18:46:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/14] netfilter: bridge: NF_CONNTRACK_BRIDGE does not depend on NF_TABLES_BRIDGE
Date:   Fri, 19 Jul 2019 18:46:17 +0200
Message-Id: <20190719164618.29581-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164618.29581-1-pablo@netfilter.org>
References: <20190719164618.29581-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Place NF_CONNTRACK_BRIDGE away from the NF_TABLES_BRIDGE dependency.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 154fa558bb90..30d8241b426f 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -25,6 +25,8 @@ config NF_LOG_BRIDGE
 	tristate "Bridge packet logging"
 	select NF_LOG_COMMON
 
+endif # NF_TABLES_BRIDGE
+
 config NF_CONNTRACK_BRIDGE
 	tristate "IPv4/IPV6 bridge connection tracking support"
 	depends on NF_CONNTRACK
@@ -39,8 +41,6 @@ config NF_CONNTRACK_BRIDGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-endif # NF_TABLES_BRIDGE
-
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
 	depends on BRIDGE && NETFILTER && NETFILTER_XTABLES
-- 
2.11.0


