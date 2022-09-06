Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059B65AE067
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiIFG62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiIFG61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:58:27 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256B772FEB
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:58:26 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id x10so11263460ljq.4
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 23:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date;
        bh=D3Hllf81lTvXZZowRJzBDAczHqiEfwobrdq5tqmcJxs=;
        b=FFYqu+lwDnEiVXwnsyfgtpusn5+yaSIAzbl/IJqx3D1pw5Hsmpd3SyUxukKyFslAgk
         HSn2AEA2Pe7TX4RKEZpNimnuAFNpZESDMiKS1E8WT6SonHRYEmmdxTZdU3n/nReP+BzF
         blb7FppsNkasWkKP77mzC5LRq7v+BTRMxYnUhsuJbmzphrH0CTC4nu+HNWWeWezIaWyA
         O+RiDKtPxIdXwG/baq6Z2GHJWAnXrZ5/71xd98Q91nTT9QJqfMQ8Br4xfMR5hnq8e5Ue
         O2fI8iitwu26ZWlQz/KeZrb+3myYQis8GkRmc6+uBijvj9Sp/ki2xU/WWVX2A+w3ATjx
         A/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=D3Hllf81lTvXZZowRJzBDAczHqiEfwobrdq5tqmcJxs=;
        b=g6TiZCNyn2IdSHleUpKpLnvC556hZaPVE6z0t+a5LVOPvZ0MaZkrVGCUP7Z++vm8uC
         kxD6IQPQE4ac4yltVs/qqanKcH1i2RVjm7GABJWjSmocQHJeob3FGkjkww/apuy8bFHT
         1n5Ve7jB+Lj2IE1azmiQqrOQ3O4MJOznzVzsipX3rfU2TAfMNp/82TJip9mJ4nbNYIyE
         RHFld0q1h1pz9ibmxkjVHVVKr2sKLbYlC+dczxgAh5ubOQj0GWU9/27ltfwLFhLyRtDd
         c46KV6yVl/029E0Mpo9F1YToL1NGjvVSGW1eh1c0VyrMUV/8NVt081dt2utmbzkClVps
         yh7Q==
X-Gm-Message-State: ACgBeo0fanyA3HQPEobUVVfYLA4qTAVafAeotOFZw0oatVLaK9w60JEh
        2RsIA25hR/P1Oezmti4g5Ik=
X-Google-Smtp-Source: AA6agR4oClcKHKlMdoD3lJTYWz+HGIHPHZzoaW9mJPT7eAJjsK2uxj91DKe5JJkU3KrhYTR3jCP8Jw==
X-Received: by 2002:a2e:9f50:0:b0:267:7e8e:5396 with SMTP id v16-20020a2e9f50000000b002677e8e5396mr9308269ljk.222.1662447504408;
        Mon, 05 Sep 2022 23:58:24 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id b23-20020a056512071700b0049600497ed1sm1027464lfs.26.2022.09.05.23.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:58:23 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Casper Andersson <casper.casan@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2 net-next] net: sparx5: fix function return type to match actual type
Date:   Tue,  6 Sep 2022 08:58:15 +0200
Message-Id: <20220906065815.3856323-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function returns error integer, not bool.

Does not have any impact on functionality.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
Sorry Dan, I forgot to include you in the first version.

 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c | 4 ++--
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index a5837dbe0c7e..4af285918ea2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -186,8 +186,8 @@ bool sparx5_mact_getnext(struct sparx5 *sparx5,
 	return ret == 0;
 }
 
-bool sparx5_mact_find(struct sparx5 *sparx5,
-		      const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2)
+int sparx5_mact_find(struct sparx5 *sparx5,
+		     const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2)
 {
 	int ret;
 	u32 cfg2;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 9b4395b7a9e4..8b42cad0e49c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -321,8 +321,8 @@ int sparx5_mact_learn(struct sparx5 *sparx5, int port,
 		      const unsigned char mac[ETH_ALEN], u16 vid);
 bool sparx5_mact_getnext(struct sparx5 *sparx5,
 			 unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2);
-bool sparx5_mact_find(struct sparx5 *sparx5,
-		      const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2);
+int sparx5_mact_find(struct sparx5 *sparx5,
+		     const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2);
 int sparx5_mact_forget(struct sparx5 *sparx5,
 		       const unsigned char mac[ETH_ALEN], u16 vid);
 int sparx5_add_mact_entry(struct sparx5 *sparx5,
-- 
2.34.1

