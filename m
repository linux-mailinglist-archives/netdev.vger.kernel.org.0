Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2366230F1
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKIRC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKIRBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:01:14 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B438725E87;
        Wed,  9 Nov 2022 08:59:46 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EECC05C022D;
        Wed,  9 Nov 2022 11:59:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 09 Nov 2022 11:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=astier.eu; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1668013184; x=1668099584; bh=Er
        CMI9F6Oba0uwk/qXSxRzVt2B71pBRibv3hWqltMGQ=; b=YAoHQI45CwgdOoAqO2
        mWkzXx7Dq+kZsFNiKn0ihFlCnSEsM96UVbalb5vczuO4LKUDPS5TDj69cmevvzc1
        LxmlWpUNvq5GFZQDsbBVzwyAl2EqCckaFOurPE56n0hg5f5TihQeZaR0Nq9UJwQ7
        xMGi4hYgo69xYEFt5OAVXGg+ln5XVqSJDRGJ7eZ0bmLwkyLosXYyETny2EPQ6U/p
        CzjmUgqB0BdUlXwLmsBk5o9mT5QRbl+SeFlBP7yu5uR03h/N2lVFhzap8UgA2BKx
        bsDZYQmVr3qwR+QP5JGHTuiPqemusE0kOVPm6JWbouM8kikNjD3bkE+LIjP/N+YH
        TLMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1668013184; x=1668099584; bh=ErCMI9F6Oba0u
        wk/qXSxRzVt2B71pBRibv3hWqltMGQ=; b=PnwkB2YVbWlRRGvhYfvR4UVdM9CJM
        Z4ZGYuU5S4QQiKcoTBp3s83/eLAFn4QHSfPfWINUlNpHcIhlojxWnrBidpOIE8VZ
        qek74mNGp7y8BobOJNDGmiytc09JhJeOxnb/DzjoNBSLxtJga3RFTfy3y8llL+bR
        6K8ok3NpCSlJKGBCdiexO3LkHpfGeQ8MPaGQ8vXShhm0dAse+0hqFs1iw5Zic5S6
        kDfFuKM+utF3yT3CtSQqCDimREzN2fIlcW6aT3JQQhftnXtRUBB54GQfz7WCY75I
        TJID4DMQchpxwZCJBwQ5Gd/xsLsd7i5kurchbTRoOi4RGCPMVUKxnuCzg==
X-ME-Sender: <xms:gNxrYxcZT35FdqYjr_Z9vHXgcxNbUMztYD10d4XlqdKf274ZEPwXmA>
    <xme:gNxrY_N0YjPqrB4ySmG2qp9HWsz-GPeJUIk1OGQOVyUX2RfH92_DlTujlixtguJUZ
    eOwe0hhnMAsM7yLWpM>
X-ME-Received: <xmr:gNxrY6h1Ytc5IidvqP8URJywWpzuGASYRt15GVDdvR7MjHNWdI3ib-OtU5ffyc_nHwIpV2S55hj3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedvgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeetnhhishhs
    vgcutehsthhivghruceorghnihhsshgvsegrshhtihgvrhdrvghuqeenucggtffrrghtth
    gvrhhnpeduudduheffiefgfeekgfehhfdujeffgfeffffgtddvjeehveefveeuhfehhfet
    feenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnh
    hishhsvgesrghsthhivghrrdgvuh
X-ME-Proxy: <xmx:gNxrY690ZJZiSpcKr8uRK9PxUXFtEhjWDQLO7T2jDcMSUs52knSzmw>
    <xmx:gNxrY9usMtlVOI092t5LDzLTZ21bUhStkY4Iw8zuHcc9mZ5ZcpE4JQ>
    <xmx:gNxrY5H3qsaNbKfFQz6kaF4xbqFFTAWFHwBk8SuMy3kEyqBQTuuCIg>
    <xmx:gNxrY5EQopPw3CAQ68nkHoL2HwcoG0LGSlIftK9bIHW6b71bV_Juvg>
Feedback-ID: iccec46d4:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Nov 2022 11:59:42 -0500 (EST)
From:   Anisse Astier <anisse@astier.eu>
To:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
Cc:     Anisse Astier <an.astier@criteo.com>,
        Erwan Velu <e.velu@criteo.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org,
        Anisse Astier <anisse@astier.eu>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next] net/mlx5e: remove unused list in arfs
Date:   Wed,  9 Nov 2022 17:59:29 +0100
Message-Id: <20221109165929.2222570-1-anisse@astier.eu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Y2f7aaFtzokrhyhX@unreal>
References: <Y2f7aaFtzokrhyhX@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is never used, and probably something that was intended to be used
before one per-protocol hash tables were chosen instead.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 0ae1865086ff..bed0c2d043e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -57,7 +57,6 @@ struct mlx5e_arfs_tables {
 	struct arfs_table arfs_tables[ARFS_NUM_TYPES];
 	/* Protect aRFS rules list */
 	spinlock_t                     arfs_lock;
-	struct list_head               rules;
 	int                            last_filter_id;
 	struct workqueue_struct        *wq;
 };
@@ -376,7 +375,6 @@ int mlx5e_arfs_create_tables(struct mlx5e_flow_steering *fs,
 		return -ENOMEM;
 
 	spin_lock_init(&arfs->arfs_lock);
-	INIT_LIST_HEAD(&arfs->rules);
 	arfs->wq = create_singlethread_workqueue("mlx5e_arfs");
 	if (!arfs->wq)
 		goto err;
-- 
2.34.1

