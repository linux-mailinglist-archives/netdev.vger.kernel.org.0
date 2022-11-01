Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9506142BB
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiKABLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiKABLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:11:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA20EE0C
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:11:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c24so12231205pls.9
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zeBMYdMZ1p+Lm3eAVj+hDEsLF6ZsPuh0Td05pqMw4LA=;
        b=T9kXSSEJxsE21WH61OdQ94VYWF4t4yhNq+JNB4JInAbU+UacVYZxmMjZZMlI7DnBOO
         ccf30kthD6BT7dwFyQKdZjpm2/0ZKvuQeEqzvi0mD78XN44pVNOHtBn4lw2ONh1hiDed
         eBy5ILKEF7jd244fvYM/UF6LRMhRyBpRarbK9lkwPZPSAuYhcm0KJ3ZB1Tx2mu5NArFy
         BbfUrboNAjd0py/1bhJgtaVcnsp5O7GYFuiLob61wH324nOLBdEKe7342LOSYAIey/iy
         dKXufj8PweP65FvykoLbX5IMH5jPsChfrwU5OEkroqwkowFHVfKedsHP2r1DmQBfvbWN
         P+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zeBMYdMZ1p+Lm3eAVj+hDEsLF6ZsPuh0Td05pqMw4LA=;
        b=f+FWafBImRUVPkPNTNmV8HJcc12DOeJm7n6eTsyb9zyDZsSQrYntPlPO/2lfGdPLa0
         V/6hBefSr/txF31W90lbQC3o5HRR9ZE7GjfJwUcMMDp/nGe+lFGpaOkvhM3rC1thiedH
         pDx/lOU/qsbe5vVKv620ycLeDT66bSqjwteB6s6ugc+PVGxv12skEQTY6O49M8zV0FVf
         8fqTg4abppBHOLPiTHvuhzNBeebOMygWSiITgZtNwiZMKCPkJw2yOpTIMgSwLb4ketqs
         3jOh22C4u5hmuudfyOa4SezUItpnvOUYvz4nPrVJ/xUM73EWlhES7KNkrhQaM1gR/+Bs
         Vkwg==
X-Gm-Message-State: ACrzQf0My1VgTl2qk8xOVN2g1xbhtWS/5XKX8LW/41wpvIM2zmH0HPlR
        O2hr7P7dIc7WmYViOG9clWwNwA==
X-Google-Smtp-Source: AMsMyM4B0jgEDjy497l6SopIpu1wkozw10ZHKcpyKvpI1a5y333hD2+JbNSwhHScPQj2OGXxhsP3JA==
X-Received: by 2002:a17:902:c1c6:b0:186:994f:6e57 with SMTP id c6-20020a170902c1c600b00186994f6e57mr16841442plc.17.1667265104900;
        Mon, 31 Oct 2022 18:11:44 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id e64-20020a621e43000000b0056be7ac5261sm5230900pfe.163.2022.10.31.18.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 18:11:44 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH net-next] net: axiemac: add PM callbacks to support suspend/resume
Date:   Tue,  1 Nov 2022 09:11:39 +0800
Message-Id: <20221101011139.900930-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support basic system-wide suspend and resume functions

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 441e1058104f..d082f2b10f4d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2217,12 +2217,48 @@ static void axienet_shutdown(struct platform_device *pdev)
 	rtnl_unlock();
 }
 
+static int axienet_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+
+	if (!netif_running(ndev))
+		return 0;
+
+	netif_device_detach(ndev);
+
+	rtnl_lock();
+	axienet_stop(ndev);
+	rtnl_unlock();
+
+	return 0;
+}
+
+static int axienet_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+
+	if (!netif_running(ndev))
+		return 0;
+
+	rtnl_lock();
+	axienet_open(ndev);
+	rtnl_unlock();
+
+	netif_device_attach(ndev);
+
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(axienet_pm_ops,
+				axienet_suspend, axienet_resume);
+
 static struct platform_driver axienet_driver = {
 	.probe = axienet_probe,
 	.remove = axienet_remove,
 	.shutdown = axienet_shutdown,
 	.driver = {
 		 .name = "xilinx_axienet",
+		 .pm = &axienet_pm_ops,
 		 .of_match_table = axienet_of_match,
 	},
 };
-- 
2.36.0

