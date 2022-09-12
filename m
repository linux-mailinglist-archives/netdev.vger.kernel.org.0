Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8483B5B594B
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiILL3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiILL3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:29:04 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4582A43C
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:29:03 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id a8so14257297lff.13
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=UMelN4XpRNqnIpRs/BvqcJOEEgbe+5kgfg5So8skyyT1+MsaggeY9RMqC1nvI0v7Eg
         QnPfaoJ5zm0cG/lrUmC0hsN2cemNvNziQizPLP9D9OK8VqM+GT2BtJArmVTTd0IHiTEo
         hAi7B8fJPpYzM7Prp7jgjIDkdXhrE8a2ljTqcbc7C7wsBJBTTs794EMnX1BbwhgxEi+N
         KXrtf4DE65vR2sadNk0956Vgd00b9C1lAvdWnwRNPAoVoPjXEcXpG2F/Q4LyOnydsT8v
         NQLHPLFAVV7MIg4K4DB1nAJPf07BFElZ9WnqLfR/G6CH2A+30Xe1953oSx/inh1pAZRd
         fE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=uHD7aJZ9PA4Cr6mArn8MYfvPqjhj68KPOiGQiBquh/ekiEf3EwZRP5mZZjI/9glV93
         k5Ah7khjqzBBRf732qUvT0Se/ISHYctV7La1Ho501VAY7bBVwgMdsomGjfSsVCmgJSss
         wRfFuVxA4bS0loQcsUCvXadtzvvegZXL+HcY1cXPrLE8gIpYEYG3vVtpAeBlnZvE6Set
         0ZLN57pJ39xBfeXA6plexoAQdnX+7vV4F2pvfdVXgO8I4RNYWJprTCvm/D90NilWrFgX
         litgicoMl/PzcpNJMmhf1IvvJoBoxRxDSJh+bHB0B2RW2x7kaThgH1mtTf6mVwsnhL0N
         zi6Q==
X-Gm-Message-State: ACgBeo2sBuPv9VGSZihEzv1TqSauhFwn+TRKbAIbTfAKet2e0v8j8JHr
        pUzDfcOX5pq8R8DipQr8XrJZ4elTEz15L7gd
X-Google-Smtp-Source: AA6agR5aEz/XbDNwWs9LBiSiqvmpawwn2metXYlYczNH1WSPXoq/3A1lserR8Uchro3Cvfh1Q0c4/g==
X-Received: by 2002:a05:6512:3b9d:b0:498:fc06:320b with SMTP id g29-20020a0565123b9d00b00498fc06320bmr4834022lfv.21.1662982141661;
        Mon, 12 Sep 2022 04:29:01 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id i14-20020a2e808e000000b0026acf2ae007sm1043269ljg.89.2022.09.12.04.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 04:29:01 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v9 2/6] net: dsa: Add convenience functions for frame handling
Date:   Mon, 12 Sep 2022 13:28:51 +0200
Message-Id: <20220912112855.339804-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220912112855.339804-1-mattias.forsblad@gmail.com>
References: <20220912112855.339804-1-mattias.forsblad@gmail.com>
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

