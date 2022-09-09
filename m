Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3765B3259
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 10:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiIIIv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 04:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiIIIvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 04:51:48 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF3C110AB2
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 01:51:45 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f14so584493lfg.5
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 01:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=bWmhNNVHl3R8ha6SYx0y73Iir+uSkgTqxcDApePcL38=;
        b=NIJLiQFRGts7mJdelZ/NjPIljSf/hbBhbl174StI8FasY6sqY342Anwn/xIxwE/f6k
         TI4wDWZtnRz2Z5Hc5oyS+rLcGPgMr3pLQhWI4BAq9ODLFxMSELO85gAwVA53ZB4Ls78P
         iSz7TigpvxhWdpjn/OTq9FffIFRLsoDktz3xiT5J7JT22yWFA73ikbI7nA75NtEmwDo7
         t/xBPIxSE+WV39EmAjXe8uNihUOnmCcuNESk2lp51h9YD/ubAM/ySzUFCoYZR+aAZ3Zh
         NTVDXZZMdywHQsLwzwHOP9AFDT0SK7AfhcmgYUThv4gYcvf0+2RCwM0EX6w6o2lFGxo5
         YncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bWmhNNVHl3R8ha6SYx0y73Iir+uSkgTqxcDApePcL38=;
        b=a1+T711IQ4Bf/+A3CuJDc2NEXBlnH1fgk2l0IMoM+AdwWfD1BOmr9HWQ56MRbp3fjD
         nzKFW/kxRElBj23P0s5Pjwm9tC+ji5fsU1V7egO7uDLZdQDZ8GCNzjIzyIU2gZQTk9fk
         8fwyD6oIxVeYcY3UKL9qLIRBbl1NAjDgR5KEIv2HqOaoBJeNDjowBflUmtUqrBpHimxS
         PHa1MMBvH5qv8nYbZzcA4KpPJ1fenrRYjg66Jq7HWVJ4YwuFlt2xYydj5f+n2aqud66/
         4gV3U9zY4ygBrsjvUnvwg7978OiG9fAj08RHCQoqnuE97Jy4WZf6ZCMFuZfMQOVtXeXw
         4Xng==
X-Gm-Message-State: ACgBeo3V9RzwHGgwfMlOnU1QBbas0jyAqXx0mtoEed7ONqsaxaQ9bicZ
        /ANLAwW5j/1cBlDRcbbwaZOQH5vqW32GeTr1
X-Google-Smtp-Source: AA6agR6Eq8Z1KHoOWSX9niqQDImrohMAcZ4yMX48BdY2RWSk6Awp/Ammyshum8oKrVc+iJb7kGMmHw==
X-Received: by 2002:ac2:5d22:0:b0:494:a1c0:b2ed with SMTP id i2-20020ac25d22000000b00494a1c0b2edmr4327880lfb.482.1662713503807;
        Fri, 09 Sep 2022 01:51:43 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id q17-20020a05651c055100b00262fae1ffe6sm193956ljp.110.2022.09.09.01.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 01:51:43 -0700 (PDT)
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
Subject: [PATCH net-next v8 2/6] net: dsa: Add convenience functions for frame handling
Date:   Fri,  9 Sep 2022 10:51:34 +0200
Message-Id: <20220909085138.3539952-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
References: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
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

