Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E405ADFDE
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbiIFGfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238465AbiIFGfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:35:04 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D423A192BB
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:34:57 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z6so15832351lfu.9
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 23:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vFi8v81pO94JHK699Iy1mRwzeYWwEi5AK5umhdJeei8=;
        b=JA7enIK+Njg4fzv/LWValQNmdtKo64k5TbI3ikmpBcg6lMdErTEHxg/dMV9GiA7eH+
         iU1or/RWhZKImr97P33MSC20t/abcFqhAIvAxGRfVN3QjH9vK+q1LCulm3ORLrNBQwd+
         YyxaSViDa6cNfOR+j4lPRmBVVV9+HjQhqySCl8lKqIK27WcYq09BKaQijH18PEEbhnIY
         9FoptwjBQn7bgPi7h9OZh0n+5x0GRZMR0py6s3KGJ0OTmH69lp8Ulk4lAlwpJhMWgZrU
         rfupoQkVnR8a1naTaHlD4DIbX64dvArK2K3sh8Exvr4X+SAgqR+Rniy/TTaL7K/a4Vii
         /7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vFi8v81pO94JHK699Iy1mRwzeYWwEi5AK5umhdJeei8=;
        b=qOSeEizWtNva1C9+IUefMTjRKSsd1l5b0FO7v95GDaO4QcpTXNKhD8a93cUavVKR2A
         7JTqomjn1QRLYFUxACxusoL3/kDGEJ4DDpMpK0WFLQnOfjwAezXG2973VjmmxC5CcoEZ
         9IS+X5ipAon3Y5oo4rvEDnClcrJQ5Rg8fqCHlHPUtS3uWCIN1ikA6NDa2+vTmxrgNzVU
         Tfq3/p3LHTmZfwoYWV7dVVs/RJn0CGmnfg1MSmgauzSUfnZCBgGq4cMBFvsvF7OUEXtE
         O7dkZZPx5nnJMebqGlcCfaIRlQU4+ssvR5jtewTLD6D8iWFFHRrdeakKrqDJTU1HwuFi
         i0Dw==
X-Gm-Message-State: ACgBeo0muMM+zogtHJOnFwjpwNlr+HVzkpa8S9mTCNuo9KEEsOKlZws9
        Ob05fAbEOO9xTmrMDYH4QF/iQFrLG3zXolgn
X-Google-Smtp-Source: AA6agR5P1DJpHgn2eBGof1MRI9twVPVV+BAVMwjNJ/CX4eNm8V8rG25D/acPn+M9TmvF+tvx/SRA6g==
X-Received: by 2002:a05:6512:234b:b0:48b:2757:7ca7 with SMTP id p11-20020a056512234b00b0048b27577ca7mr17728554lfu.50.1662446095990;
        Mon, 05 Sep 2022 23:34:55 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z12-20020a2e8e8c000000b00261bf4e9f90sm1646924ljk.66.2022.09.05.23.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:34:55 -0700 (PDT)
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
Subject: [PATCH net-next v4 2/6] net: dsa: Add convenience functions for frame handling
Date:   Tue,  6 Sep 2022 08:34:46 +0200
Message-Id: <20220906063450.3698671-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
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
 include/net/dsa.h | 13 +++++++++++++
 net/dsa/dsa.c     | 28 ++++++++++++++++++++++++++++
 net/dsa/dsa2.c    |  2 ++
 3 files changed, 43 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..70a358641235 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -495,6 +495,8 @@ struct dsa_switch {
 	unsigned int		max_num_bridges;
 
 	unsigned int		num_ports;
+
+	struct completion	inband_done;
 };
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
@@ -1390,6 +1392,17 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
 void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
 				unsigned int count);
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout);
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
index be7b320cda76..2d7add779b6f 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -324,6 +324,34 @@ int dsa_switch_resume(struct dsa_switch *ds)
 EXPORT_SYMBOL_GPL(dsa_switch_resume);
 #endif
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout)
+{
+	int ret;
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
+	ret = wait_for_completion_timeout(com, msecs_to_jiffies(timeout));
+	if (ret <= 0) {
+		dev_dbg(ds->dev, "DSA inband: timeout waiting for answer\n");
+
+		return -ETIMEDOUT;
+	}
+
+	return ret;
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

