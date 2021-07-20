Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8EE3CFA0E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbhGTMXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:23:20 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:53142
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231526AbhGTMWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:22:47 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 5CD2940624;
        Tue, 20 Jul 2021 13:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626786197;
        bh=PQfJRURFWXwxKi9tGQBBw5EhD752Jp+9489PeReXm7s=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=DIklFQHYUL8u1LIL9v/eIds5ob53wIJfgg2kcQbHdHUWwq54qjHQcrHU0LORih4lB
         F1v0X2UBbN5kkMhH0K4IPFhdI8YGtVInuN4KlpwOopyo/OnhDOLYER//RxFMCfSOCp
         fyL2h5NqIdCPvm6N2OJFgP89tcNJebLWEDCFYkDguK2q89LiRVyItPduyBwVkmSFlk
         vxQPzuU0qqBc6sfTJzhr0anr7Iy5sO4yO8U53xIgO1LlKxLlF9wW5XwBgJCUmKrXme
         uiHN9jd3FgHWdv8TKmj6wCEMcO59hMBxDNqbEdm5ITEuIq1Q8xPNkoZECECSr0Ctus
         lGpXwZAW2o1pQ==
From:   Colin King <colin.king@canonical.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: marvell: clean up trigraph warning on ??! string
Date:   Tue, 20 Jul 2021 14:03:11 +0100
Message-Id: <20210720130311.59805-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The character sequence ??! is a trigraph and causes the following
clang warning:

drivers/net/ethernet/marvell/mvneta.c:2604:39: warning: trigraph ignored [-Wtrigraphs]

Clean this by replacing it with single ?.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 76a7777c746d..fc4dbcc58f5f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2666,7 +2666,7 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 		return 0;
 
 	if (skb_headlen(skb) < (skb_transport_offset(skb) + tcp_hdrlen(skb))) {
-		pr_info("*** Is this even  possible???!?!?\n");
+		pr_info("*** Is this even possible?\n");
 		return 0;
 	}
 
-- 
2.31.1

