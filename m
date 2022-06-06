Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26E253EB80
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbiFFNqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239070AbiFFNqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:46:17 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEAA1B1865
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:46:16 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id s12so21853421ejx.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VYeSg1ZVJyO1wF6nKJrR5sFbD4VG+uA01p3eRJoARxI=;
        b=BlqD4OrH8ijJBv3g48jIRjkB144fnXNgPgxahFkUUCU2nkV1FJ0YTeVOOj6rlB/vJf
         0muLJg/FvIipcuViQyVfJPAuh3IjsNCWXVCZnMFqFGgoV6hzjiRXYjmcOTCNR2FKFF9J
         5FGB682nb6m9sUhEAK/HpPpQJmeLhkUYUJU48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VYeSg1ZVJyO1wF6nKJrR5sFbD4VG+uA01p3eRJoARxI=;
        b=nHs1A6RSNIKDKB7JdA9cK4DjxR0+iUEYFjV7PnijlduwbBz02/HMJLRSR9pcSgmFMY
         aLlVqtPg5RZ104j9Ux5GxnUFXYnUE3NGRDDlNJjLWQFQrMB9d8xjiQECVbwXVqE5eYx0
         uvmRLHlFkX0IL7HQ7/Tyosfq8KauuODplqAYREges39rqPXijsIA+xDowQAHSo6dyWop
         V2vCbxNVeHk3ZYHCZkHxADz+XwM2+rEvFdOSusd2AZhLZwWQfD0NQO7dTVEmC0ozh+WL
         kPBp4JwppG+JI2qwc/vT/f7rxAp6iVU7NVAcjXqRdc2vn4001hnNJXsPzaoJ+ZHX5ARL
         j90w==
X-Gm-Message-State: AOAM532aK0D31GXiUH/n/5DRmsOOdtqRYXqJBDt/ZmxhoSmLtHXM/AJC
        mOJmXtU2ZrsS+3uyGRHPljwzqg==
X-Google-Smtp-Source: ABdhPJyfCep4n7xquLlwy7AVxmn0xa/oWVEI+ZOZvyZi6iA+YjNd0eF+CH6vK89MeOD2mZ5kkia2AA==
X-Received: by 2002:a17:907:1c8d:b0:6f2:eb2:1cd6 with SMTP id nb13-20020a1709071c8d00b006f20eb21cd6mr20960665ejc.568.1654523174637;
        Mon, 06 Jun 2022 06:46:14 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id a26-20020a1709062b1a00b006f3ef214db4sm5496538ejg.26.2022.06.06.06.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:46:14 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: dsa: realtek: rtl8365mb: remove port_mask private data member
Date:   Mon,  6 Jun 2022 15:45:50 +0200
Message-Id: <20220606134553.2919693-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220606134553.2919693-1-alvin@pqrs.dk>
References: <20220606134553.2919693-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

There is no real need for this variable: the line change interrupt mask
is sufficiently masked out when getting linkup_ind and linkdown_ind in
the interrupt handler.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 0cc90e96aab7..c64219271a2b 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -564,7 +564,6 @@ struct rtl8365mb_port {
  * @irq: registered IRQ or zero
  * @chip_id: chip identifier
  * @chip_ver: chip silicon revision
- * @port_mask: mask of all ports
  * @learn_limit_max: maximum number of L2 addresses the chip can learn
  * @cpu: CPU tagging and CPU port configuration for this chip
  * @mib_lock: prevent concurrent reads of MIB counters
@@ -579,7 +578,6 @@ struct rtl8365mb {
 	int irq;
 	u32 chip_id;
 	u32 chip_ver;
-	u32 port_mask;
 	u32 learn_limit_max;
 	struct rtl8365mb_cpu cpu;
 	struct mutex mib_lock;
@@ -1540,7 +1538,7 @@ static irqreturn_t rtl8365mb_irq(int irq, void *data)
 
 		linkdown_ind = FIELD_GET(RTL8365MB_PORT_LINKDOWN_IND_MASK, val);
 
-		line_changes = (linkup_ind | linkdown_ind) & mb->port_mask;
+		line_changes = linkup_ind | linkdown_ind;
 	}
 
 	if (!line_changes)
@@ -2029,7 +2027,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
-- 
2.36.0

