Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF40635021F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhCaO0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:26:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55598 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbhCaO0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:26:10 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lRbnK-0008UR-IX; Wed, 31 Mar 2021 14:26:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] netfilter: nf_log_bridge: Fix missing assignment of ret on a call to nf_log_register
Date:   Wed, 31 Mar 2021 15:26:06 +0100
Message-Id: <20210331142606.1422498-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the call to nf_log_register is returning an error code that
is not being assigned to ret and yet ret is being checked. Fix this by
adding in the missing assignment.

Addresses-Coverity: ("Logically dead code")
Fixes: 8d02e7da87a0 ("netfilter: nf_log_bridge: merge with nf_log_syslog")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_log_syslog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 025ab9c66d13..2518818ed479 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1042,7 +1042,7 @@ static int __init nf_log_syslog_init(void)
 	if (ret < 0)
 		goto err4;
 
-	nf_log_register(NFPROTO_BRIDGE, &nf_bridge_logger);
+	ret = nf_log_register(NFPROTO_BRIDGE, &nf_bridge_logger);
 	if (ret < 0)
 		goto err5;
 
-- 
2.30.2

