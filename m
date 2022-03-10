Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75714D54B3
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244735AbiCJWk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbiCJWk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:40:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B370E18460B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5432461C03
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 22:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F132C340E8;
        Thu, 10 Mar 2022 22:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646951994;
        bh=WbAjYD2ESe0Qa65ZkR/7om0j8nPWeipnugCg3SJmtlQ=;
        h=From:To:Cc:Subject:Date:From;
        b=VXGBLy0lW7Hl9HQmQQlw1tW44IC8Y6CERvmhmSWMr3Sc9OVt27CAOiARcRrDk3y7q
         S+6NaJGTwYZQ8Ygl5jsSWqqj7zeHPkRFm7796OOR7k4DFTdmFICVKM91cAPFKPeu4m
         CnaiI0uPzmLg2CoVG0JQo15JTrCpzhYgecde9DcO4VwcBmkvQgyoF7tlt4nKaanah5
         nxMZGLf2ewvwLfuKaXNz9WxHKSwbu9K7+uQmXj70ePYbngUOH3yC6evXG738TC03d/
         n7jMKHy9wYF2vp4at2Dge7orMIeFVfKozIqcAH1f1jX2M3WAuvAh+D/KoF7pNM7R8f
         u4o+0gJ44uPNQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: remove exports for netdev_name_node_alt_create() and destroy
Date:   Thu, 10 Mar 2022 14:39:52 -0800
Message-Id: <20220310223952.558779-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_name_node_alt_create() and netdev_name_node_alt_destroy()
are only called by rtnetlink, so no need for exports.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ba69ddf85af6..7ed27c178a1f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -340,7 +340,6 @@ int netdev_name_node_alt_create(struct net_device *dev, const char *name)
 
 	return 0;
 }
-EXPORT_SYMBOL(netdev_name_node_alt_create);
 
 static void __netdev_name_node_alt_destroy(struct netdev_name_node *name_node)
 {
@@ -368,7 +367,6 @@ int netdev_name_node_alt_destroy(struct net_device *dev, const char *name)
 
 	return 0;
 }
-EXPORT_SYMBOL(netdev_name_node_alt_destroy);
 
 static void netdev_name_node_alt_flush(struct net_device *dev)
 {
-- 
2.34.1

