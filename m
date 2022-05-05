Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E612451BCC6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350034AbiEEKKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbiEEKKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:10:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC5113F1D
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D37BA618BC
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABD5C385AA;
        Thu,  5 May 2022 10:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651745221;
        bh=4FIpCY9Z01WPoEn/gyFFBr4Y7yZVetS0OrJ9FRv+qSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7mo4we4SqBaYjh3WCoo8c9/za3BMutBLK2iT3a21nkZJTo8QgwjWIBehv9xEqPM4
         UHpxdn3AEiDfHVaYejXFrvw3bitPgRvnoFVJz1nsCJolq0XhASXzHsGNs7yIPnXC4b
         roEfdU+jNgXxoQtdm57tmQiZLN6yvglv2rK88vZ0om9Mdv7eP63pTcVZ94NQ/+wUQU
         zkO2zf9Ub5uGExAVKJtUDbBfEE2u/OeD1Pvd5J0SLdtiQACBs40NaJfLbIMVADg40v
         8uPKUBn+p2TUUxJeiMons//qmV5Qo1ioTTXWfENJ3g5b4Yjp4sxj4LXqoyLbHOSoOg
         Op2KADFh46pew==
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
Subject: [PATCH ipsec-next 2/8] xfrm: delete not used number of external headers
Date:   Thu,  5 May 2022 13:06:39 +0300
Message-Id: <099569952c609251ea4c156d6c6aed6031abafa7.1651743750.git.leonro@nvidia.com>
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

num_exthdrs is set but never used, so delete it.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/xfrm.h     | 1 -
 net/xfrm/xfrm_device.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b41278abeeaa..4e097423116c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -131,7 +131,6 @@ struct xfrm_state_offload {
 	netdevice_tracker	dev_tracker;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
-	unsigned int		num_exthdrs;
 	u8			flags;
 };
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 36aa01d92b65..dbd923e1d5f0 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -264,13 +264,11 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	xso->dev = dev;
 	netdev_tracker_alloc(dev, &xso->dev_tracker, GFP_ATOMIC);
 	xso->real_dev = dev;
-	xso->num_exthdrs = 1;
 	/* Don't forward bit that is not implemented */
 	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
-		xso->num_exthdrs = 0;
 		xso->flags = 0;
 		xso->dev = NULL;
 		xso->real_dev = NULL;
-- 
2.35.1

