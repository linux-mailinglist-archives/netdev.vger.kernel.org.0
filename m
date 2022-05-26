Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B50534C00
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiEZIwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiEZIwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:52:22 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CD627FF0;
        Thu, 26 May 2022 01:52:22 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so922809plg.5;
        Thu, 26 May 2022 01:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O0l0jmgNTZS4lxRaBNrQut0lDAnnNlXWN05NXGO2skU=;
        b=GkRhcPGhXF0cc0Kd9KWnd4EIDss1xaIf3p71S50DljqPprh5Piyk6KD8mvhTyjdQHZ
         E8wqfm/ZyBZgCHQq7n4khSkGhbrJBpiIRyZvb17mfVy3Pl4Al+uUFs+MXmJzxp/+XniG
         1C58GzLG5rcaYcZ0/rmzmxmihSJ/QHlOTYhpAhr+dW6OkdB/UT2+4YGRirL+2Iw0XCEt
         XOplL2YlU8GfiLiNDOTehWJY3mdIA8fbX1jgX+yP2UlH4XpWc6x3vnhllu+DIRMcStFA
         zCsm59L50G0NVz4XGwqxGtsa7ACH73gFPjcNAgx27l9l5ocLOhWAxg1JNamxm+37xbZg
         YE0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O0l0jmgNTZS4lxRaBNrQut0lDAnnNlXWN05NXGO2skU=;
        b=YXxI3B3lOVT7fih2YUstpKu8Ctyx43dfI36E3VxpLi0dhKN4Skp3KtIgsJGlnmfp6F
         0WyYVaB5N+QGi6CWbMjNwQ+QmVMv1uUzC9BnLDjdpBi0zoKWHEjP1snP0K1uHgylLfWU
         03EdkaZKdtWDw5PwzBrHXJI4VxhXpMcJKRn0yxoyXJGSVQ4xvqJyWxRuqJejQ8iW3iLk
         L4TpfDas1uA4jv69C9CdvEEpR4MPJBq/46dSp6tDws5iZRv+bCcv396Nim0bw0XjOGgR
         /K2hE1hUiJRllWlzzt5PjGH1SrLrIE8cl9iRlKgL3n/uoBlducsvPGgpxOMtKSummGKM
         FpCg==
X-Gm-Message-State: AOAM533orVLywaEG4EWOCcIBiLUY3RmS6KAwCeAkGbohOsBnGH9igW1y
        8uqmyXlYGKSpUp4f84vltpM=
X-Google-Smtp-Source: ABdhPJxcQpMISbiUZfTf5fgRewsKF7uFMW5ecepOefgosU2+RzgO+1RQpa0BK5eJUuVvIyUurvq2WA==
X-Received: by 2002:a17:90b:2250:b0:1df:665c:79d1 with SMTP id hk16-20020a17090b225000b001df665c79d1mr1511629pjb.220.1653555141818;
        Thu, 26 May 2022 01:52:21 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id o13-20020a17090a4b4d00b001df264610c4sm6039831pjl.0.2022.05.26.01.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 01:52:21 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leon Romanovsky <leon@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Wang Qing <wangqing@vivo.com>,
        Minghao Chi <chi.minghao@zte.com.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks
Date:   Thu, 26 May 2022 12:52:08 +0400
Message-Id: <20220526085211.43913-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
am65_cpsw_init_cpts() and am65_cpsw_nuss_probe() don't release
the refcount in error case.
Add missing of_node_put() to avoid refcount leak.

Fixes: b1f66a5bee07 ("net: ethernet: ti: am65-cpsw-nuss: enable packet timestamping support")
Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 34197c67f8d9..0a398338132c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1788,6 +1788,7 @@ static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
 	if (IS_ERR(cpts)) {
 		int ret = PTR_ERR(cpts);
 
+		of_node_put(node);
 		if (ret == -EOPNOTSUPP) {
 			dev_info(dev, "cpts disabled\n");
 			return 0;
@@ -2662,9 +2663,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (!node)
 		return -ENOENT;
 	common->port_num = of_get_child_count(node);
+	of_node_put(node);
 	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
 		return -ENOENT;
-	of_node_put(node);
 
 	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
-- 
2.25.1

