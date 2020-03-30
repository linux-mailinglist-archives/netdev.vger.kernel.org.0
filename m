Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4ADF19715A
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgC3AhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:37:23 -0400
Received: from correo.us.es ([193.147.175.20]:57158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgC3AhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45A8AEF43A
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34CE0100A48
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2A30D100A59; Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43D5C100A48;
        Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1487742EF42A;
        Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/26] netfilter: ctnetlink: Add missing annotation for ctnetlink_parse_nat_setup()
Date:   Mon, 30 Mar 2020 02:36:49 +0200
Message-Id: <20200330003708.54017-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>

Sparse reports a warning at ctnetlink_parse_nat_setup()

warning: context imbalance in ctnetlink_parse_nat_setup()
	- unexpected unlock

The root cause is the missing annotation at ctnetlink_parse_nat_setup()
Add the missing __must_hold(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6a1c8f1f6171..eb190206cd12 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1533,6 +1533,7 @@ static int
 ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			  enum nf_nat_manip_type manip,
 			  const struct nlattr *attr)
+	__must_hold(RCU)
 {
 	struct nf_nat_hook *nat_hook;
 	int err;
-- 
2.11.0

