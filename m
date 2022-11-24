Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6B7637BA3
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiKXOoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKXOoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:44:44 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AF6E0B77
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:44:43 -0800 (PST)
Received: (Authenticated sender: sd@queasysnail.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 4A66FC0009;
        Thu, 24 Nov 2022 14:44:42 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 3/7] xfrm: add extack to xfrm_del_sa
Date:   Thu, 24 Nov 2022 15:43:40 +0100
Message-Id: <0afb3eb4dfdf8bfaa7b6f5773c6ed6f2d31232f5.1668507420.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668507420.git.sd@queasysnail.net>
References: <cover.1668507420.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 1664baefae80..06a379d35ebb 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -862,12 +862,12 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 
 	if (xfrm_state_kern(x)) {
+		NL_SET_ERR_MSG(extack, "SA is in use by tunnels");
 		err = -EPERM;
 		goto out;
 	}
 
 	err = xfrm_state_delete(x);
-
 	if (err < 0)
 		goto out;
 
-- 
2.38.0

