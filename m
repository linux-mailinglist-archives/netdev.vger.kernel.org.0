Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7AE3E2A1F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343500AbhHFLwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:52:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33254 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbhHFLwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:52:35 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id E48BF6002F;
        Fri,  6 Aug 2021 13:51:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/9] netfilter: nfnetlink_hook: strip off module name from hookfn
Date:   Fri,  6 Aug 2021 13:52:02 +0200
Message-Id: <20210806115207.2976-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806115207.2976-1-pablo@netfilter.org>
References: <20210806115207.2976-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFNLA_HOOK_FUNCTION_NAME should include the hook function name only,
the module name is already provided by NFNLA_HOOK_MODULE_NAME.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 202f57d17bab..ca453c61dbdf 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -135,6 +135,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	if (module_name) {
 		char *end;
 
+		*module_name = '\0';
 		module_name += 2;
 		end = strchr(module_name, ']');
 		if (end) {
-- 
2.20.1

