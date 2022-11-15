Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AF262929F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiKOHoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKOHoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:44:03 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5111C418
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:44:01 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id z24so16439378ljn.4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrOEygdWi3pXEJQNDPsb806sEtq19Rqxin4IiMd3olc=;
        b=aHw8ddTPEpBYzI9XNrZBUhY7QEUdAqdwK+4DIhY5/ttzsxZHXagVnVZWwqbSsnR/L9
         BAtWJEJ8HlDMOz1lFNo69MeWGGDA/mXbKhmo5RsHGZg+Of1ZN2snQqbQee0Tit1FOC/Q
         kS64xE0nlozCRV7MIF7KZMgdp+69c5/9FBIe0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XrOEygdWi3pXEJQNDPsb806sEtq19Rqxin4IiMd3olc=;
        b=Xc5YTCLTEj6a9rBcY4SYsycXEusyKaBDsey7K0ka4rnzia7q66YmNF/nuUzZRm0t/H
         8op9OkGmVQWLVW3j+1TVkfu2p0abQr9KRq6wxKn5AueOWIBn6zheuOUK+ltrouBsNUCH
         NItOBPsxwW84gcm4FOMBrZFfdtQOdjANKhxpQnwxlkn9z6xRDylsx9HAAIc0KW86kpUD
         Tbhfq3fvZxHCj/OwlYHgPJAJFuBfSys8RJyOrRiItQTA0gWijJ4CkOacfHNOfrLaGzrX
         wPjcIFupfH/K2hJ3+ZT8KE8Y6rTjGuPoEntdu6UoKCbRv3/RDziAhYzFtCydCAkrskKv
         ZdDA==
X-Gm-Message-State: ANoB5plX26r/Icia/laV8R5tzfkptk+twpfs2zFj+hm1SzATs4TAeSz8
        v5/qpAHmsa8bZnYvo+JRExMlmw==
X-Google-Smtp-Source: AA0mqf6yh85DBb6cczRp8W3NVkP6JMvYmIva2InW8EL+ciD1s5uuGjAC6Z/+J12112Mquj26vFgGfQ==
X-Received: by 2002:a2e:8544:0:b0:277:e01:610f with SMTP id u4-20020a2e8544000000b002770e01610fmr4948523ljj.60.1668498239466;
        Mon, 14 Nov 2022 23:43:59 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id m20-20020a056512359400b00498fc3d4cfdsm2119742lfr.189.2022.11.14.23.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 23:43:58 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: dsa: use more appropriate NET_NAME_* constants for user ports
Date:   Tue, 15 Nov 2022 08:43:55 +0100
Message-Id: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
References: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a user port has a label in device tree, the corresponding
netdevice is "predictably named by the kernel".

Expose that information properly for the benefit of userspace tools
that make decisions based on the name_assign_type attribute,
e.g. a systemd-udev rule with "kernel" in NamePolicy.

Similarly, when we fall back to the eth%d scheme, the proper constant
to use is NET_NAME_ENUM. See also commit e9f656b7a214 ("net: ethernet:
set default assignment identifier to NET_NAME_ENUM"), which in turn
quoted commit 685343fc3ba6 ("net: add name_assign_type netdev
attribute"):

    ... when the kernel has given the interface a name using global
    device enumeration based on order of discovery (ethX, wlanY, etc)
    ... are labelled NET_NAME_ENUM.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

v2: switch to NET_NAME_ENUM in the eth%d case (Andrew, Jakub). Update
commit message accordingly.

 net/dsa/dsa2.c  |  3 ---
 net/dsa/slave.c | 13 +++++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e504a18fc125..522fc1b6e8c6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1364,9 +1364,6 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 
 static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
 {
-	if (!name)
-		name = "eth%d";
-
 	dp->type = DSA_PORT_TYPE_USER;
 	dp->name = name;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a9fde48cffd4..821ab79bb60a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2374,16 +2374,25 @@ int dsa_slave_create(struct dsa_port *port)
 {
 	struct net_device *master = dsa_port_to_master(port);
 	struct dsa_switch *ds = port->ds;
-	const char *name = port->name;
 	struct net_device *slave_dev;
 	struct dsa_slave_priv *p;
+	const char *name;
+	int assign_type;
 	int ret;
 
 	if (!ds->num_tx_queues)
 		ds->num_tx_queues = 1;
 
+	if (port->name) {
+		name = port->name;
+		assign_type = NET_NAME_PREDICTABLE;
+	} else {
+		name = "eth%d";
+		assign_type = NET_NAME_ENUM;
+	}
+
 	slave_dev = alloc_netdev_mqs(sizeof(struct dsa_slave_priv), name,
-				     NET_NAME_UNKNOWN, ether_setup,
+				     assign_type, ether_setup,
 				     ds->num_tx_queues, 1);
 	if (slave_dev == NULL)
 		return -ENOMEM;
-- 
2.37.2

