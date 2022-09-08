Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F405B1E9C
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiIHNV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiIHNVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:21:21 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FE7DEAB
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:21:17 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id q21so13462625lfo.0
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 06:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=R/2Z6ZQoZzqpL1LfavqO+X5S24pYhQKeMt7hudS7Sd8=;
        b=av1LyBbQ3hr/bw8fUAkAig2axheXObLSpMLxGEB7qthP2Gfh5plVCQhC5oTzHHOr5T
         tBfKthn6BKLCGthnPt3E6ZahpB9GRd8FbPt2Nch+1fZLO2+qvr+dug/IP/dF4rsrsQuu
         lOD77NsAMpT/bQVoH0eXNZyIq0apKO+1uc5EDwKU/mBI5OSbpd0ES25JvRFb2bZH4SAE
         buK5bh/mdCK0mpzt2my8LovgG4biar/jxzqI7Pt2uEUaOQ96xYORHUHXz8qX6qIjreAY
         7iHG3yYV6YuuokQDsDmrMVp96yiEm3c6BwcQh5u9v/I0RWevMQxLK7xE0m/9xdVCZ8Ow
         ht0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=R/2Z6ZQoZzqpL1LfavqO+X5S24pYhQKeMt7hudS7Sd8=;
        b=CwILBbPpPgNUmuwTeb9gWXNU57NtwAwSmB83CDssClnjUU5X0G3AIQ6/XIpt2wgniy
         s7a05slzItY9zFin9ORc1WtAe7W/X3Ss3VipIoYIj4FYxTZ16q2WYd89BonKBZP0SHLa
         +A6R0+m33l5WKYFV4WEWVxGCa7VbjCKOipTe6i0mVjEswZdibHDTaWizQqBKXVM/Z1MY
         EdqVmE48kJsxChul9ImQTz4HtWMCX8loRBUvopQ1LWfQDLxDhI3gpiPLSMBqpXNKn9wH
         4uKoE2RzcJl6656Y/haDjZHZDRxgdbxeEg+V7oRqUvZNSMjG9JEh4F/+Zz9yC0FAx6lI
         1qqg==
X-Gm-Message-State: ACgBeo1+KESG2wO34gsc0q1cxaKgZArIsM5L8gVV4YaWLjDI+b0HU6+S
        HRHVHepMJf0zHCze2RDNOM4UKtMsWu8sCuhd
X-Google-Smtp-Source: AA6agR5K0Nkv/Qk4uUuFnEjQm4GKmX6XtTsgMyIYY6LyAT43q3w4pXTMWt5GYb0fmLHsAGAj5/0deA==
X-Received: by 2002:a05:6512:b98:b0:494:6a8b:53e6 with SMTP id b24-20020a0565120b9800b004946a8b53e6mr2854890lfv.113.1662643274809;
        Thu, 08 Sep 2022 06:21:14 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id j6-20020a056512344600b00498f32ae907sm104837lfr.95.2022.09.08.06.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:21:14 -0700 (PDT)
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
Subject: [PATCH net-next v7 2/6] net: dsa: Add convenience functions for frame handling
Date:   Thu,  8 Sep 2022 15:21:05 +0200
Message-Id: <20220908132109.3213080-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
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

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h | 14 ++++++++++++++
 net/dsa/dsa.c     | 17 +++++++++++++++++
 net/dsa/dsa2.c    |  2 ++
 3 files changed, 33 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..0e8a7ef17490 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -495,6 +495,8 @@ struct dsa_switch {
 	unsigned int		max_num_bridges;
 
 	unsigned int		num_ports;
+
+	struct completion	inband_done;
 };
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
@@ -1390,6 +1392,18 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
 void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
 				unsigned int count);
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout);
+
+static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
+{
+	/* Custom completion? */
+	if (completion)
+		complete(completion);
+	else
+		complete(&ds->inband_done);
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
index ed56c7a554b8..a1b3ecfdffb8 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1746,6 +1746,8 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 		dsa_tree_put(dst);
 	}
 
+	init_completion(&ds->inband_done);
+
 	return err;
 }
 
-- 
2.25.1

