Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA0A613BC9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiJaQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiJaQ4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:56:15 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2485CE55;
        Mon, 31 Oct 2022 09:56:13 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 427EC5C0004;
        Mon, 31 Oct 2022 12:56:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 31 Oct 2022 12:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=astier.eu; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1667235370; x=1667321770; bh=YqNIjEX0DUfZxwgyqz4sY9XuJ
        l8eLqitY7OJaFOUg7E=; b=ku7X3tEzyRFPSH+ITdX+E6xvjkO5GT/DZAU+K981j
        aOD3xzc7lisvWnAF+np0NULFavMOt5dZLWHYcuniIV5Suhcd0FjAzhy0kh/dpeI5
        c+pu2fbyQ7tpx07UAWExjzWVQwmyE4S/s2fTa+FXZ8lprvA6RcJn6odxcScGV/Fb
        XKW3bElwXY1Az2g0nU+7uR2VWFJiEAH0pHFN1PgwWz1Y1F4LLnrgpJkqGqZu4ANP
        EhwH+nBDMXjoZ1RzbG7Bd7qFUQEVWKXXLd1n1ucipV7zGABL3ZwnVy1uIBZc2xyA
        fNGPfSwcNieXtxdb9qvWfMGpGbpaMUuFu9VWdpsYy1Riw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1667235370; x=1667321770; bh=YqNIjEX0DUfZxwgyqz4sY9XuJl8eLqitY7O
        JaFOUg7E=; b=dap1oDyhSypv/2MgZMnoKC94VKlpYpwoffmzP9Jq1Aeb2cWk1vp
        GTLVutNeuGD4kq4U4wHvxWH007EhuRKUMnL02sHx2VVUJBIUdDID3w+XjjcU4lDu
        SCagaNPwBe1cze5JcaokhSoOYdXHmjQIiAeN//nG20bYIbwFwGv35Ni5WSM3pNMK
        O/d1+9fBKiRuZIswccI91htrd7kgvZ8Q7LQOT9+I7ma57XQMQnoYXOirMTBWt6ou
        GsBY6zT6wwDC1D9hHWccMyxCVp4B3KtBAb9Y1CGbsEHkTr76Tvw9bFy1TKPPdgzD
        fW+13GbZHfMinJ2sLZtwletJE2KzdeliLMQ==
X-ME-Sender: <xms:Kf5fY2m2FAJya5VTuxOph3ibOdO3Z-ehdQWaUYIhI-zIT8ahIO3VVw>
    <xme:Kf5fY90cdv3MXKxfzONNReykREnBgrQ6hsGsRgnbBg2WoGyAFZXbewHb5FRmd8AmQ
    I7lX9S6-gZ_aiJc-iE>
X-ME-Received: <xmr:Kf5fY0owVUJtJTCYCoD9tw2e82_ZsRkZB-AwU83q2YsTBCFbuP8oAHFMCO--eoYVM0mdXUPsmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudefgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetnhhishhsvgcu
    tehsthhivghruceorghnihhsshgvsegrshhtihgvrhdrvghuqeenucggtffrrghtthgvrh
    hnpedtfffhleekhefhheeftedthfejgfffvddtleehffdtjefftdehkeetfeefieelkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhhish
    hsvgesrghsthhivghrrdgvuh
X-ME-Proxy: <xmx:Kf5fY6l3w7wfMaEkf--sbxTRYUakSz4WZiyYSxWVVoPntR6XQ9vgQg>
    <xmx:Kf5fY02NyxZNlMjziE5-eH-v84fbZpkiaeuD4bMd0r4S5PSvMIv1Zg>
    <xmx:Kf5fYxv0gB9lWXHPR3Gj3CcinSV-HjF16bIgg_e6O_yPRpOP0mePSA>
    <xmx:Kv5fY9sMFNiBhuDMurR-LpXH4lwKsgsPHlSnoRcJz2olRjbFJQuDpg>
Feedback-ID: iccec46d4:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Oct 2022 12:56:07 -0400 (EDT)
From:   Anisse Astier <anisse@astier.eu>
To:     netdev@vger.kernel.org
Cc:     Anisse Astier <an.astier@criteo.com>,
        Erwan Velu <e.velu@criteo.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org,
        Anisse Astier <anisse@astier.eu>
Subject: [PATCH] net/mlx5e: remove unused list in arfs
Date:   Mon, 31 Oct 2022 17:56:04 +0100
Message-Id: <20221031165604.1771965-1-anisse@astier.eu>
X-Mailer: git-send-email 2.34.1
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
before per-protocol hash tables were chosen instead.

Signed-off-by: Anisse Astier <anisse@astier.eu>
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

