Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5F488D08
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbiAIXQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:16:55 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42124 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbiAIXQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:53 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6CE806468E;
        Mon, 10 Jan 2022 00:14:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/32] netfilter: nft_payload: WARN_ON_ONCE instead of BUG
Date:   Mon, 10 Jan 2022 00:16:12 +0100
Message-Id: <20220109231640.104123-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG() is too harsh for unknown payload base, use WARN_ON_ONCE() instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index bd689938a2e0..f2e65df32a06 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -157,7 +157,8 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 	default:
-		BUG();
+		WARN_ON_ONCE(1);
+		goto err;
 	}
 	offset += priv->offset;
 
@@ -664,7 +665,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 	default:
-		BUG();
+		WARN_ON_ONCE(1);
+		goto err;
 	}
 
 	csum_offset = offset + priv->csum_offset;
-- 
2.30.2

