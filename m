Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B6C546987
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346131AbiFJPjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345343AbiFJPjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:39:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCA528CEA2
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:16 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id fu3so52713889ejc.7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XE/B3EfYYQf1mtimqgsF3ZVDA9bOVjSyLpITpl2gz98=;
        b=BVgwujirHOUIeTwEYAOXz/Fa5gPyFbFTfBDPBTeofutQ98qdf624mz/DQ/iM7jHM4b
         iFAOdv3EzLvZCXsZ7GL4ihxUy3hnmkmqIJgGoYQmGwpqieCZLXhuxYW70pJmnAg6/VCS
         0ahZBTABoQZFRCU0zIqF0rLGArZvPdL8Wt0Ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XE/B3EfYYQf1mtimqgsF3ZVDA9bOVjSyLpITpl2gz98=;
        b=m4WlzY+2CjSDbnZD4bnaTONp8Fgc6mfRCKp7v/5dEO8fT2RzJidaDuqwT98pwBKwi1
         J51D4QPHDf/fAY4GWu3S6o6SrzOSaQdQ/1c5Wp3hnA+VY+pkeVwj+aeh6b+T2qJ1mvcF
         H0BrYaVpzHAMgcLNFvi5mT5YvwHVbX3u6o6zK9j85GH+JX45Upl9HJHjDcrWT6aJoYoL
         ab8G5xgKTOmgd4Omv89S8auoXvJEaVkaeXkUzzCBfDXHoWdzZSnJYfid3OUkhIy2cWtH
         bFpPAho3Zkgyi3MFLIqFuSraMp/p/+AMKJ5d1UJNr1kgQNsxocXpFRnBX/YLlJHI3M7J
         JqQw==
X-Gm-Message-State: AOAM5314pEt8OX0VvNwZ5LsEZAzZk5u3OM6HwEVJTQUQejoWf2Z2N8/n
        xBZ7VUKe4/6PAPdouvo/nDNG5A==
X-Google-Smtp-Source: ABdhPJwTbMezAtGxCn6LQq/LfANqqR2V4XCYQzJqALFJsXWfYQJAKH5hK+hEoU2+ewgtG9IEBh2EiQ==
X-Received: by 2002:a17:907:6287:b0:6e1:6ac:c769 with SMTP id nd7-20020a170907628700b006e106acc769mr41817915ejc.388.1654875555111;
        Fri, 10 Jun 2022 08:39:15 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id h24-20020a170906829800b0070f7d1c5a18sm9783857ejx.55.2022.06.10.08.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:39:14 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     hauke@hauke-m.de, Linus Walleij <linus.walleij@linaro.org>,
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
Subject: [PATCH net-next v2 2/5] net: dsa: realtek: rtl8365mb: remove port_mask private data member
Date:   Fri, 10 Jun 2022 17:38:26 +0200
Message-Id: <20220610153829.446516-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610153829.446516-1-alvin@pqrs.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
 drivers/net/dsa/realtek/rtl8365mb.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 905056250b88..42afba122bb4 100644
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
@@ -1489,13 +1487,10 @@ static irqreturn_t rtl8365mb_irq(int irq, void *data)
 {
 	struct realtek_priv *priv = data;
 	unsigned long line_changes = 0;
-	struct rtl8365mb *mb;
 	u32 stat;
 	int line;
 	int ret;
 
-	mb = priv->chip_data;
-
 	ret = rtl8365mb_get_and_clear_status_reg(priv, RTL8365MB_INTR_STATUS_REG,
 						 &stat);
 	if (ret)
@@ -1520,7 +1515,7 @@ static irqreturn_t rtl8365mb_irq(int irq, void *data)
 
 		linkdown_ind = FIELD_GET(RTL8365MB_PORT_LINKDOWN_IND_MASK, val);
 
-		line_changes = (linkup_ind | linkdown_ind) & mb->port_mask;
+		line_changes = linkup_ind | linkdown_ind;
 	}
 
 	if (!line_changes)
@@ -2009,7 +2004,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
-- 
2.36.1

