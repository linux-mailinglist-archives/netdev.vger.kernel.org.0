Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FDB5AFD8C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIGHak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiIGHaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:30:03 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D840E2D
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 00:29:57 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id z23so14963955ljk.1
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 00:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=iVlKsCzpSq5xAshl/Osk8jDdbgKPm67ICf/yk8vBtwM=;
        b=qpJwz0ScUgsyl6R47K/hfaUDbOhtXh6zsfkRMleRzJp4WtPlXa4KC+8KSapsQsQzsE
         u79G4nC7q/76FEk7xx8jmZN04vEj/bDdvF8mP7kykPYyYdivt24SZPwEfZTDq/eskivR
         HdxlS+hH3j5KHib7ARmLwpgLMC8o6fHyjlCnEcewOqp3EvZ1bh5LSaO3HbGgAhxqtBsd
         tYBXrXkDuQSV0BCDZ760JFsASQC4IZAiulH50H8k/iAJSk3uXM5M0t1Z/g6zIK5/0HSg
         /aci1Qka0sjtv/pX0tyoQ/rrTahHJ1uywmO/TOpEZUF1DbJyv9l1QajF6LDg4tk+xnGi
         k0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iVlKsCzpSq5xAshl/Osk8jDdbgKPm67ICf/yk8vBtwM=;
        b=MKF0tmGqE9W+jiDxwPCP2jHdxOo5sN3M8UQ8sTlwG4q5pv1MtxlYA4BzghbTOfC6qT
         W/uMkaUF9wxmZ9RM9Laz+/dMUVosDfpktWXwF+HGmIqDO/wL2CeHZ08ZVLLYLeT5VBSe
         W5aW60T1hqO44FjrFZO3LmiWVdmmWfakenicOyOlx7XW4CUfd/yh5f9y3H4a/S9maJhd
         FQb8KfXCHaekFD4ALm6wvvjLSBxrdGwS0mMoPUqZre/Pgvv8uFoifgY9nO+tYHcHkuWM
         oKwN3TCi4qtfphy6EAih9w9P5r+Kq1CGuhbibX3A/uY0O/800zZfZ7FUbvmALvASUcvf
         fEhA==
X-Gm-Message-State: ACgBeo2vdZhP8DQmLowGNRTbWY8Y0VF1964ERPhM21oCNBJiZ0bphsoX
        57URln5cD2EaPWwKFzU98vYJaQfGLEIxVrKW
X-Google-Smtp-Source: AA6agR5XFatDaXnV5pLq5X7tTlBWj6bao2aQyelEZzJccT3nJJrlne7IVY+qIWn8z4b/M4j1KFn59w==
X-Received: by 2002:a05:651c:54b:b0:268:a2ad:b8e3 with SMTP id q11-20020a05651c054b00b00268a2adb8e3mr565258ljp.281.1662535795999;
        Wed, 07 Sep 2022 00:29:55 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id w3-20020ac25983000000b0048a83336343sm2275507lfn.252.2022.09.07.00.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:29:55 -0700 (PDT)
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
Subject: [PATCH net-next v5 2/6] net: dsa: Add convenience functions for frame handling
Date:   Wed,  7 Sep 2022 09:29:46 +0200
Message-Id: <20220907072950.2329571-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
References: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
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

