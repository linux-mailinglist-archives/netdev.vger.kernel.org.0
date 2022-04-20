Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88E0508691
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 13:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377901AbiDTLHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 07:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377925AbiDTLHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 07:07:32 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24BF40922;
        Wed, 20 Apr 2022 04:04:45 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id bg9so1287441pgb.9;
        Wed, 20 Apr 2022 04:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=istBcC3E+ZfmnTVNwIQY13Lw4u8eYbcp2nzpLROkbBI=;
        b=OICJCxQMDwd1vs4XzPMekvCpmXwSxW2ZGh51UdQuKK/laHpnboXnd0SWvXxloUdK5y
         +ldYsum6A30rGWFxEi907juiG+AU3JoYb7T9UzB7RhD4FF3XZlFxm6MW9jGxhJL5SCiU
         C6nTPo+4cBm3t4p4D3HrfUa+QKqvs4EMa8prxdIYrcscyIcZikoyumtnyH/Kp32CMuk8
         jOuHOSguzTe8kn9qSavT+2/90JqzW/30wNyzROD/bTYWoT5Mj5yK90G1KDHcNExT/JNG
         Z8hJiJcJ6kJvPwxW8KqjZFxRgo1NeCzZapnMPxBXFi0Qf+PYp7oj/LucgPDY6uFWPoim
         DLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=istBcC3E+ZfmnTVNwIQY13Lw4u8eYbcp2nzpLROkbBI=;
        b=DzgeH8V229NKlaoa+nbiw6pXmMHDhjfJ5IaOLSCJRUy9I3WIdX+jiFVkaF+OZ5I1uJ
         G05aWslkZmZp13Ou5nGa10EDBLWgNZighVkjUOV+W+lqVN8lHwIxCymqAnJ2mLoMjkXM
         7j2Df2az8k9OOCm10qtHoz+iBy5egehxRMAbH3NrlAIPqIHJvvRVkDGaJObXotd0tAxr
         AS8izVabhrKOrTNRlSzeQxCyYDRrzNBQMRV9y5L7UNxyhKbTxnNYnw+g5LyGGRimINey
         p8F3BwSOnrH7fRAcvm7cNQ6x8vP8nGtio4kQOeTS/sFpvOOgmsMCMQr1GDQtv4Y16j+l
         02LA==
X-Gm-Message-State: AOAM530JNCvUnDfZSllwYTD2M7cj6hRwxbBz9+g3TsxLKzN0jyXJbA5x
        9xLns5q6kj7sGiCmSlj0t6o7J4mUjWxzCtw2J7Q=
X-Google-Smtp-Source: ABdhPJxn8fjBrGRORfApKRIdrWwb1dxLHKva9lU9NPKnQthxOu1OcjREgtVL0Rwq5+NTxtjogYlfQA==
X-Received: by 2002:a62:87c5:0:b0:50a:9380:3d26 with SMTP id i188-20020a6287c5000000b0050a93803d26mr8746908pfe.27.1650452685208;
        Wed, 20 Apr 2022 04:04:45 -0700 (PDT)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id b11-20020a621b0b000000b00505c6892effsm19660658pfb.26.2022.04.20.04.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 04:04:44 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: dsa: Add missing of_node_put() in dsa_port_link_register_of
Date:   Wed, 20 Apr 2022 19:04:08 +0800
Message-Id: <20220420110413.17828-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.
of_node_put() will check for NULL value.

Fixes: a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 net/dsa/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 32d472a82241..cdc56ba11f52 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1620,8 +1620,10 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
+			of_node_put(phy_np);
 			return dsa_port_phylink_register(dp);
 		}
+		of_node_put(phy_np);
 		return 0;
 	}
 
-- 
2.17.1

