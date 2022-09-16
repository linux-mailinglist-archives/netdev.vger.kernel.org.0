Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94D65BAD37
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 14:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiIPMSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 08:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiIPMSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 08:18:34 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F125B14F4
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:27 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i26so35266546lfp.11
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=CvmWBRpzq+Y+m5Buda1uuiksL7e1t8crC/iRRLBooAT0qX59TLgG9jW+IhVkbm1d3S
         L1KOaHatK/IDcwSzkSAvKAaQhIqIe2DUrLSiD98I1LtJzGNv+RvAqxJ/pOYavbGL/6ML
         4AjE+HU/ljyhYOdQotCnqkvv5YTGVUPG/FzAsG1pEmtf7pRmsHK0zuN8VBuPARn59kPK
         msBQ+oWPa35Go5l0CD5BIGD6ZD0L2YSaryWV6Cx6drv1TVnkE0KD3ec96zGbjkCLkpyL
         i/CTayIGpnnaj61yw5YaSMtIiZc8NZUwVV5gdH9xDX3J31T8M0qhqadQKy0rqE57VQXr
         XpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=t6DLMlvVPs/YRfVG4WNwTIpBd2Di+I38V613VQf7wiWeAjouFiDQJghv7ElUEEUXR1
         /inoLmnDqSB9XVxGXuBmWzD5k1hQjzXgfcQ+VRiesg3qoCpUgHVn4xQbID4YtThe9arA
         zW5g3Bo2V35sO+5UugegZLFaMPl8DH9uS/x/0k60O69BRN/UNghSz0o4+JB2rLEqR9RU
         TJzfFy3IazI4iJGZ6FrgcLs5J4H88sLNcOAxQIDQ+vZDBX7yCfhSALP576UVKSt6pZTq
         7BWXBQMkdtTAZmnaa6PJDOg7jY4mpYjSTImN7APfkEBa6Y8HJyi2NRgNA3wKAsF3BE1h
         8oZQ==
X-Gm-Message-State: ACrzQf2iaAEQNy8IJahy3M22O77ACr+jOBDTW4aXcOtM4Y4Ft6YuEP34
        oZ7PWlx1esesD33s+GFABoTv/qndMDT1Qd2wdag=
X-Google-Smtp-Source: AMsMyM6SHb8HYg8z7zIrO0s6nQP5WVB/CYYIUFC6KXaqfDVL1P5L60EEeOmEl531BeM3xlb+bemY6g==
X-Received: by 2002:a19:9202:0:b0:49d:7310:742f with SMTP id u2-20020a199202000000b0049d7310742fmr1722655lfd.312.1663330705673;
        Fri, 16 Sep 2022 05:18:25 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id h6-20020a0565123c8600b0049f5358062dsm313824lfv.98.2022.09.16.05.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:18:24 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com, Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v13 2/6] net: dsa: Add convenience functions for frame handling
Date:   Fri, 16 Sep 2022 14:18:13 +0200
Message-Id: <20220916121817.4061532-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add common control functions for drivers that need
to send and wait for control frames.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h | 11 +++++++++++
 net/dsa/dsa.c     | 17 +++++++++++++++++
 net/dsa/dsa2.c    |  2 ++
 3 files changed, 30 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..08f3fff5f4df 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -495,6 +495,8 @@ struct dsa_switch {
 	unsigned int		max_num_bridges;
 
 	unsigned int		num_ports;
+
+	struct completion	inband_done;
 };
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
@@ -1390,6 +1392,15 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
 void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
 				unsigned int count);
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout);
+
+static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
+{
+	/* Custom completion? */
+	complete(completion ?: &ds->inband_done);
+}
+
 #define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
 static int __init dsa_tag_driver_module_init(void)			\
 {									\
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index be7b320cda76..ad870494d68b 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -324,6 +324,23 @@ int dsa_switch_resume(struct dsa_switch *ds)
 EXPORT_SYMBOL_GPL(dsa_switch_resume);
 #endif
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout)
+{
+	struct completion *com;
+
+	/* Custom completion? */
+	com = completion ? : &ds->inband_done;
+
+	reinit_completion(com);
+
+	if (skb)
+		dev_queue_xmit(skb);
+
+	return wait_for_completion_timeout(com, msecs_to_jiffies(timeout));
+}
+EXPORT_SYMBOL_GPL(dsa_switch_inband_tx);
+
 static struct packet_type dsa_pack_type __read_mostly = {
 	.type	= cpu_to_be16(ETH_P_XDSA),
 	.func	= dsa_switch_rcv,
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ed56c7a554b8..a048a6200789 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -874,6 +874,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (ds->setup)
 		return 0;
 
+	init_completion(&ds->inband_done);
+
 	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
 	 * driver and before ops->setup() has run, since the switch drivers and
 	 * the slave MDIO bus driver rely on these values for probing PHY
-- 
2.25.1

