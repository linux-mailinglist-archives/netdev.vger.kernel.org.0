Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6154151BCD2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355044AbiEEKLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354885AbiEEKLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:11:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FD34F9F6
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:07:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B99FBB82C17
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73E8C385A8;
        Thu,  5 May 2022 10:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651745240;
        bh=KgMZhpYNtqq1/zCqQuoZ4G4J9OVfi6Dr20foBMl3KyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCQw93sTBCQEm1myGaAfMkeXrFOYxQ+fbLaIbkFnCp0RRj68UotfxECUL0ELD8muQ
         7LCXjXgLV5g/EN1hL4Ay2edh2AIpFNtbaDXALsarqto3MPXCyq6jAasCkvaZqx3A4b
         TbmUcrOnP2wzg18iHydCZmAoeRrvzxrlIF+cE8UDqu7oTeuDs/B6RvJLAfdND540vQ
         E06M9HyATNPKQ9F4bHs9w6FOUrbssj3+XEgYH+O9eE+UyzLkapddLwMHn3JuB6pmTE
         SzzlzH3UQBVsDUdFJEKz8ePUW8ey+SnjtPoNUewj1TB9Zr13lLBnYibC4EbhQHnudi
         BzF+McfFmaPUw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH ipsec-next 8/8] xfrm: drop not needed flags variable in XFRM offload struct
Date:   Thu,  5 May 2022 13:06:45 +0300
Message-Id: <b0c39ee6e266ee021b810259fd73f5701fa929d1.1651743750.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

After drivers were converted to rely on direction, the flags is not
used anymore and can be removed.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/xfrm.h     | 1 -
 net/xfrm/xfrm_device.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 45422f7be0c5..736c349de8bf 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -136,7 +136,6 @@ struct xfrm_dev_offload {
 	netdevice_tracker	dev_tracker;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
-	u8			flags;
 	u8			dir : 2;
 };
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c818afca9137..35c7e89b2e7d 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -264,8 +264,6 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	xso->dev = dev;
 	netdev_tracker_alloc(dev, &xso->dev_tracker, GFP_ATOMIC);
 	xso->real_dev = dev;
-	/* Don't forward bit that is not implemented */
-	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
 	if (xuo->flags & XFRM_OFFLOAD_INBOUND)
 		xso->dir = XFRM_DEV_OFFLOAD_IN;
@@ -274,7 +272,6 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
-		xso->flags = 0;
 		xso->dev = NULL;
 		xso->dir = 0;
 		xso->real_dev = NULL;
-- 
2.35.1

