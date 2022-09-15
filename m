Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE955B9D77
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiIOOi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiIOOig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:38:36 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49AF8E98E
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:10 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w8so30693008lft.12
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=ce4l+QHX6thjJ3lhwLcLeBPuLPyyeyfi+sCWqJAyX6AzEIqWSxxx7Q6OomxLgAC4qW
         dG/H9+AZePpOJ5HZYIHr7YRGugRtxWdi0TecLh1AlZAiDK1F9DczM/l3WGnwfmztQyKj
         nSCmT9mTkc56nSmU9JiWUblG6tWm+sqFdb3czDfcGqGbnWSC+x0dMVemZnkm9eQKJlJo
         EONeZKt3UvD7kV4vvg7s5bCVmxz9U7nmG6Vsu0C4QvASklVUrNtHEXcD1Je07wEob9V7
         w+/ldMy0/qaqG3PaTY5hDNOoPMavUlQUi8Y1g/5EBZuPNjkCF71StLPFoDBgEK+Uc7Me
         zgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=R1goCWflQwWIxbERua5eFehwFAqkJSVRd7DT/mq604g6HQxgZDddfvOKfFV9KFuCfu
         TGw7VGc99cLnVc4mbUka9g6ft3Cx9bQV4Hv7Ck+zKqN5BZIfSGtejv2ANI4iBKe/cHFb
         UTiqFA5UhAdqCffENCOCa2IUkydDUCwVaOLcRNexC6NGPYUGmReaJoKVnIhSuzW9Dxsh
         qeBlAxntjKUUWwjSEivsSEPTVNt2oRu2t5SilYyi18FN+VQGInHR8mVEl/YErOGej/Wm
         CavWMTtqTbcin7EeRSU4JZQ74tYnQKgnD/kKKpbiU9BFlSIYevdMkkaqErVKuN5mgNv8
         i4yw==
X-Gm-Message-State: ACrzQf2qIBbbwuAWndqtnDr1z+4NbauIupCGDrsIgE7hF+Lo/miDEnBK
        cXUrVsngmKtSibv2umvGAWbzpPLuUlbdN45a
X-Google-Smtp-Source: AMsMyM4snU0fF+2x0mmW9iLWHX2qqMLVJ9FL0fcZQexQ+vXLAVJCDYDNBMn1j3KNe27XxWH6A0/NKA==
X-Received: by 2002:a05:6512:1329:b0:492:e050:b0dc with SMTP id x41-20020a056512132900b00492e050b0dcmr88409lfu.136.1663252626748;
        Thu, 15 Sep 2022 07:37:06 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id x15-20020ac259cf000000b004984ab5956dsm2995794lfn.202.2022.09.15.07.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 07:37:06 -0700 (PDT)
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
Subject: [PATCH net-next v12 2/6] net: dsa: Add convenience functions for frame handling
Date:   Thu, 15 Sep 2022 16:36:54 +0200
Message-Id: <20220915143658.3377139-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
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

