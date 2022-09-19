Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE895BCA44
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiISLI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiISLIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:08:55 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ED5E03C
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:54 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id s6so35121009lfo.7
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=pc0+QCAGiVNaE23IqtysKPw8Ch3HDcsW5KXzRut7Iv1uboBD9eHlOE7I/PK8pSNmHi
         cXSLASLBlyovycETtkl1GNCWkG0kY0Ji4WPyY0DO9oAxDjSYeAc+L4BCn4SUYJKTHF1+
         TFwN+leTLrUbqUjcwY7FvHMEXQEmhFPWxcReV0gCkeEukcUwlTq14nIyQxPydpwgVX21
         3ACZi2JXHomPibr4STw+rDxEfrkMyQkSjAqrNcv55OQv+yz/1aL332Q3aWlvz3xordmJ
         MAZ4U/seBYZo4ZC6fMM7f+vh63np1XRPIMH0Rx5u4dAionklqVrcziJvZ+RDoD65vNOI
         c9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=6zCXnOMz1fQw+7L+RW+HREt0Z1GiYlAvKqhL6esGTD5eBE8fgC4s92Sjf2SvP5uw81
         3b58WsPtoi34q/1tpJbLf52kmanV3lWEGxGVXxr5f/4s+A5DtnJnyfqe8+zFPSL8U0np
         8k4p6331VPYIfs1diSqGMrMzvlDOaJPF4q75QAaqbhOvTvBnluDHSRky5C+11A4Y6EYx
         9S1Nhlu5XeeBpftGGUxWAAGlmHUnL9jN2vseTVr2e7lf9VdfVzyXqGupJKu6K+o1Zp/h
         mb1XRPtA5MCQdSHSQC3Sa67I3InjfyIZ5oHSTW1v7W0mGYmDe5o8UwYj4ELZXxA2EOMy
         VZwQ==
X-Gm-Message-State: ACrzQf1GWPXI3eZq6B/3vaRc3nhGXZ9oFbeMFbW+K65R8IjNUS29WCbM
        0H0TU2d+Unt+MK8iEv8N6JBhge1g2iWnhQ==
X-Google-Smtp-Source: AMsMyM4SYa8h2DpwjbsnvWoqnQlLegJ6jRxJqE+Ci2JrZ9r0T2mrPMg27fBiM3mHa8NYeHvtaI7ZkA==
X-Received: by 2002:a05:6512:a89:b0:49d:b866:6330 with SMTP id m9-20020a0565120a8900b0049db8666330mr5696115lfu.346.1663585732912;
        Mon, 19 Sep 2022 04:08:52 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id t13-20020a05651c204d00b00266d3f689e1sm4879261ljo.43.2022.09.19.04.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 04:08:52 -0700 (PDT)
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
Subject: [PATCH net-next v14 2/7] net: dsa: Add convenience functions for frame handling
Date:   Mon, 19 Sep 2022 13:08:42 +0200
Message-Id: <20220919110847.744712-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220919110847.744712-1-mattias.forsblad@gmail.com>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
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

