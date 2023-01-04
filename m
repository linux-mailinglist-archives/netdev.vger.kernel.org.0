Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4FB65DE11
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 22:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbjADVGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 16:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbjADVGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:06:30 -0500
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839CA1CB13
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:06:29 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id DAxcpwWwVxN58DAxvpFlKB; Wed, 04 Jan 2023 22:06:27 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 04 Jan 2023 22:06:27 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next 3/3] ezchip: Further clean-up
Date:   Wed,  4 Jan 2023 22:05:34 +0100
Message-Id: <e65e188a837c59c1f1785b491c775a6ee1aed5d4.1672865629.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
References: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that is only call to platform_get_drvdata() is removed, calling
platform_set_drvdata() looks useless. Remove it.

While at it, remove a useless 'err' initialization and change its type to a
more common 'int'

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 21e230150104..139510d9669f 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -574,7 +574,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct net_device *ndev;
 	struct nps_enet_priv *priv;
-	s32 err = 0;
+	int err;
 
 	if (!dev->of_node)
 		return -ENODEV;
@@ -583,7 +583,6 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	if (!ndev)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, dev);
 	priv = netdev_priv(ndev);
 
-- 
2.34.1

