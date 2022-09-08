Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE46D5B1C03
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiIHL6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiIHL6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:58:47 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3321611C7F2
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:58:46 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id q21so13093858lfo.0
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 04:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=iVlKsCzpSq5xAshl/Osk8jDdbgKPm67ICf/yk8vBtwM=;
        b=PHcQ7gFR5gKKLmQK+Xrs90eh8MKnoZCZyb3BCH32qFH9HAQB4XVFVF3wm2fwz4qWUo
         aSM4IrnbrVs8GZQqfdMZe59jSZCKQx5d/yFakNThfNHJ/dU/3P6tGosWn7u3QAiZxs71
         wqqdGk2a/A58NzuwQ6ai/DNovlDDLEqB3nzNBPdeX7svPliaXdP/53XcS67gDB1uSFG1
         E6oUMCywIhFQhypyHq/2zSpDzDPHC/8YbelxTpKr+NkqWW3yGyL36RZ96qISjl7dABDF
         xFTidiotXr507YMsp5UL7mK3MvKz9Fhg5GLPffDidWOdGAQPqtVTJLYP892NeKsaohs8
         LOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iVlKsCzpSq5xAshl/Osk8jDdbgKPm67ICf/yk8vBtwM=;
        b=znWKXzPJ5/6wVZWioGSuNCwzjwksjE37vzkZn3EAx6h70IYyMbk3La2aGIJhKz2KOh
         RCjTpJv/wyfkKEgZ4yXsvqFKAFLpvrrO4mkW7WJEldtF1WXkXDFuOpTb/6UJLzVyde7B
         rv9/oe+sGjzogmgrt2apdtjNG34v+0E9A6bwAT03aCj3lJLyoqETpQJ6oWStKg6e+nGo
         7dSPm32/T2plKJCfH6GAZdy/Aj3tNf5fJFPqoa5Zi+U2CW4mmQP4+jx6vSmCMKiqV3ue
         GqhO/OwrtgGkdirjn+2ipRDvK3bwSh3ZuBlqCEtAb019Fxt6v4Cw98ARnLgRKtPcgrQ0
         vGiw==
X-Gm-Message-State: ACgBeo1/6BzGZVTiju2PI12MYlBWqsfC/6leTjFbVixtRK3Fql7PKYMh
        oLrhmVyaqwFiTP79sF6sNwdqAF076gfpb5lm
X-Google-Smtp-Source: AA6agR69oCvQ3KpMMc2eVczx3yjzW+G7fAKBfMdk1PszBiwX46HKcW9AWsrLY1/i5katBuEY/HZzjA==
X-Received: by 2002:a05:6512:1109:b0:496:f8cc:5414 with SMTP id l9-20020a056512110900b00496f8cc5414mr2401517lfg.249.1662638324327;
        Thu, 08 Sep 2022 04:58:44 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id s10-20020a2e81ca000000b0026acfbbcb7esm833595ljg.12.2022.09.08.04.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:58:43 -0700 (PDT)
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
Subject: [PATCH net-next v6 2/6] net: dsa: Add convenience functions for frame handling
Date:   Thu,  8 Sep 2022 13:58:31 +0200
Message-Id: <20220908115835.3205487-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908115835.3205487-1-mattias.forsblad@gmail.com>
References: <20220908115835.3205487-1-mattias.forsblad@gmail.com>
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
 net/dsa/dsa.c     | 20 ++++++++++++++++++++
 net/dsa/dsa2.c    |  2 ++
 3 files changed, 36 insertions(+)

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
index be7b320cda76..00d25aa41a55 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -324,6 +324,26 @@ int dsa_switch_resume(struct dsa_switch *ds)
 EXPORT_SYMBOL_GPL(dsa_switch_resume);
 #endif
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout)
+{
+	struct completion *com;
+
+	/* Custom completion? */
+	if (completion)
+		com = completion;
+	else
+		com = &ds->inband_done;
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

