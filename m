Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDA256C4F5
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGHX5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGHX5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:57:53 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5D264E21
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:57:51 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id e12so194531lfr.6
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 16:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/jxC1JjCm62YabzFufDUJocIDmCx9DnXigWUB8EgFBU=;
        b=V/9C1dg6QUXjaq1Z42eKO3+gppZcwczSEcVUnrPxoecYZEk4n02NCttORT+wYJX0cq
         Bbe/ItpQcpNA6Rod6Wl0CGRmnVxCXdCdeTFjHkuqo/vlMJDj1Czl8iFgV5A8ii26oLft
         joILYDfxSuznWFbVq1t1BeJhIdZIdQe3jqMQWrzjAYbl4GIWvak1Eg4DVYm0mM8l4kAU
         AOk7FCYG8EbcPR6ccOFC1df6NdFpO97qPmCyWRRlslow6o5lpBw7ZzDyFkY3X6puRSgz
         gCls+R1vbubVzJLpZb3TQ8uDr5ew3V3Hit/wNmg1KFYkXJUhzFuMqj1xnV7B0+qZZ2sf
         WY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/jxC1JjCm62YabzFufDUJocIDmCx9DnXigWUB8EgFBU=;
        b=qKz9ZKxdQuxmv5A2bwVXXgt8pkHyhkEvB7IYxyED9AnO58cE17poyLq8lEag/z/Xnx
         EagWT0bew8Ec2MybTwULSOWPrjqsTedmCkuP5XyDCOnZUdA6kbtHuwV5MAb8n4P9GJ/Y
         JQMA/G+UfmNcdj11P7yytlrQKgHHFUf5WwY4rsBd9LXT/Hx2lv9rYr9elhHXy2N7ioNR
         qQ8hWAte7raEPvZFsv4VqmCUbE+Q/jU8RCc+QXTf7vBo4rjbzEqzXO5796cjHxQODP6O
         6t7o3HMwE4SoYcksWQoxMBlykp4vKbfJGESeLc97o4jL0y23PesDZgwtb68LIeC8lHcn
         p5VQ==
X-Gm-Message-State: AJIora/VI0keQlkhv2BJE+VA08K22kdRVfOyfoKrnt1M6zvMRlpuJ6k3
        UDblNtVpCd5Vau962wzY8fFN2gEJnGD0lA==
X-Google-Smtp-Source: AGRyM1tHFLDIleQF/l+unkoe09LeZuJbygt/0eEFmR19uu8nctQsW/Lg6VggB/HsuNxqz+ssGRT1kw==
X-Received: by 2002:a05:6512:3b8e:b0:481:1a75:452 with SMTP id g14-20020a0565123b8e00b004811a750452mr4256038lfv.238.1657324670088;
        Fri, 08 Jul 2022 16:57:50 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s25-20020a056512203900b0047f6b4a53cdsm71603lfs.172.2022.07.08.16.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 16:57:49 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 2/2] ixp4xx_eth: Set MAC address from device tree
Date:   Sat,  9 Jul 2022 01:55:30 +0200
Message-Id: <20220708235530.1099185-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708235530.1099185-1-linus.walleij@linaro.org>
References: <20220708235530.1099185-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a MAC address specified in the device tree, then
use it. This is already perfectly legal to specify in accordance
with the generic ethernet-controller.yaml schema.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index a5d1d8d12064..3591b9edc9a1 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -29,6 +29,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/of.h>
 #include <linux/of_mdio.h>
+#include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/ptp_classify.h>
@@ -156,7 +157,7 @@ struct eth_plat_info {
 	u8 phy;		/* MII PHY ID, 0 - 31 */
 	u8 rxq;		/* configurable, currently 0 - 31 only */
 	u8 txreadyq;
-	u8 hwaddr[6];
+	u8 hwaddr[ETH_ALEN];
 	u8 npe;		/* NPE instance used by this interface */
 	bool has_mdio;	/* If this instance has an MDIO bus */
 };
@@ -1387,6 +1388,7 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
 	struct of_phandle_args npe_spec;
 	struct device_node *mdio_np;
 	struct eth_plat_info *plat;
+	u8 mac[ETH_ALEN];
 	int ret;
 
 	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
@@ -1428,6 +1430,12 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
 	}
 	plat->txreadyq = queue_spec.args[0];
 
+	ret = of_get_mac_address(np, mac);
+	if (!ret) {
+		dev_info(dev, "Setting macaddr from DT %pM\n", mac);
+		memcpy(plat->hwaddr, mac, ETH_ALEN);
+	}
+
 	return plat;
 }
 
-- 
2.36.1

