Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144164DA75B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352401AbiCPB0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 21:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240434AbiCPB0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:26:02 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76642C112;
        Tue, 15 Mar 2022 18:24:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g19so1700192pfc.9;
        Tue, 15 Mar 2022 18:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=al/nPgKJobqnMBoRb1FUok0zveRpWShtjvjFYFm8F4o=;
        b=FNEj+f37IjPmKpNEzLjn9Jd3NLm1/lbrUHcNLBNkkNz1i9OmYB2CXwJcoowRnryhnN
         b1uejqI+bc0WZg3S/JZlLUDSFU8oUWdPdxVUmItUrvnBcmVnbPimClmPvmWWG9Xo4us8
         DSIZTYfBwm5wDKkA8u6C4kadMcfR5+N28mRlXhg8AxyvQJrTd9M+ypvyaCLTx2XxnUbp
         1uIsnhZ9jh5SIlaQMwWIkJYJ/vq4EVejZUsS1a0VxqmtcEvkk4CWHqinFgTpjpjGWqHU
         8VQRWm3gxzHQnhwfBh3gqV3ws+gZ8HzXLrOvx1JvWrc8/nD6sqTK7WaZJFqTPy33p/OK
         +RiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=al/nPgKJobqnMBoRb1FUok0zveRpWShtjvjFYFm8F4o=;
        b=ttEFS3rKoY9pv63HPZ76fLtrIX2TyKgDecJnS9GJuQXqEe8s+kEik53icBg5VecqLU
         6wxI9Uwq0CQLV9+gMGD+N8RK5EtOKf6YeLqfZ2Qc60LaVFoXY6o9hfVZaPzI6vD6/d9E
         XSCDAucJj3svZ+dh41FPeMjbkJYr07xLpI8lwL9Cbvxd7GXJHJvKs45ewGieakW37irn
         lBVRvEwxFG37Ak+1qEs2zERgtoY9LORakQFp6uVBxNVc4kolPCKdQLkVsMnqDgoIPbIy
         7/C43+DhkUYz6snwOd+L07sy1xAemn2zv5iJ/uDvST8CElq1uQ3+vkwlUcdqSj2ZH8YT
         q16w==
X-Gm-Message-State: AOAM533YIfrZ2Hdv5gESWnOUFli9qcUrVEKHE3tQAkKLrCsLllE1ORkT
        /Is2oveQEZNemeVKrCgEmEM=
X-Google-Smtp-Source: ABdhPJxw9JhMNMJKLq+xJmWLvc50gNVjSyRIj3IPmi1wv13K/O3+tVnfuU3FuQY7DR87WAixXtfvrA==
X-Received: by 2002:a63:4b1e:0:b0:365:8bc:6665 with SMTP id y30-20020a634b1e000000b0036508bc6665mr26894661pga.445.1647393889176;
        Tue, 15 Mar 2022 18:24:49 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a640300b001c617b9b463sm4239043pjj.9.2022.03.15.18.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 18:24:48 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kuba@kernel.org
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] net: mv643xx_eth: undo some opreations in mv643xx_eth_probe
Date:   Wed, 16 Mar 2022 01:24:44 +0000
Message-Id: <20220316012444.2126070-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Minghao Chi <chi.minghao@zte.com.cn>

Cannot directly return platform_get_irq return irq, there
are operations that need to be undone.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
v1->v2:
  - Use goto out;
 drivers/net/ethernet/marvell/mv643xx_eth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index e6cd4e214d79..5f9ab1842d49 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3189,8 +3189,10 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 
 
 	irq = platform_get_irq(pdev, 0);
-	if (WARN_ON(irq < 0))
-		return irq;
+	if (WARN_ON(irq < 0)) {
+		err = irq;
+		goto out;
+	}
 	dev->irq = irq;
 
 	dev->netdev_ops = &mv643xx_eth_netdev_ops;
-- 
2.25.1

