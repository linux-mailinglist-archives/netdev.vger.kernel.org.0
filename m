Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D83C3D3CEC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhGWPOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:14:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57314 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbhGWPNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:13:55 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 49B65642A5;
        Fri, 23 Jul 2021 17:53:57 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/6] netfilter: nfnl_hook: fix unused variable warning
Date:   Fri, 23 Jul 2021 17:54:12 +0200
Message-Id: <20210723155412.17916-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210723155412.17916-1-pablo@netfilter.org>
References: <20210723155412.17916-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The only user of this variable is in an #ifdef:

net/netfilter/nfnetlink_hook.c: In function 'nfnl_hook_entries_head':
net/netfilter/nfnetlink_hook.c:177:28: error: unused variable 'netdev' [-Werror=unused-variable]

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 50b4e3c9347a..202f57d17bab 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -174,7 +174,9 @@ static const struct nf_hook_entries *
 nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *dev)
 {
 	const struct nf_hook_entries *hook_head = NULL;
+#ifdef CONFIG_NETFILTER_INGRESS
 	struct net_device *netdev;
+#endif
 
 	switch (pf) {
 	case NFPROTO_IPV4:
-- 
2.20.1

