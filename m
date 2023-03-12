Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DB66B6860
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 17:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCLQqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 12:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjCLQqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 12:46:12 -0400
Received: from ocelot.miegl.cz (ocelot.miegl.cz [195.201.216.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FEB1CAD2;
        Sun, 12 Mar 2023 09:46:11 -0700 (PDT)
From:   Josef Miegl <josef@miegl.cz>
Cc:     Eyal Birger <eyal.birger@gmail.com>, Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: geneve: set IFF_POINTOPOINT with IFLA_GENEVE_INNER_PROTO_INHERIT
Date:   Sun, 12 Mar 2023 17:45:57 +0100
Message-Id: <20230312164557.55354-1-josef@miegl.cz>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GENEVE tunnel used with IFLA_GENEVE_INNER_PROTO_INHERIT is
point-to-point, so set IFF_POINTOPOINT to reflect that.

Signed-off-by: Josef Miegl <josef@miegl.cz>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 32684e94eb4f..78f9d588f712 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1421,7 +1421,7 @@ static int geneve_configure(struct net *net, struct net_device *dev,
 		dev->type = ARPHRD_NONE;
 		dev->hard_header_len = 0;
 		dev->addr_len = 0;
-		dev->flags = IFF_NOARP;
+		dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 	}
 
 	err = register_netdevice(dev);
-- 
2.37.1

