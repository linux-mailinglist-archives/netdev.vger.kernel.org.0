Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D864FBBB7
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345708AbiDKMJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343730AbiDKMI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:08:57 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D5D3E5F1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:43 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 15so4990539ljw.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5WkJnGKcklgXkfGMCLvHjH3UFxshtzm1KBU3E5R4Uxo=;
        b=G8KPzsunv4cruerA06oHDXJe+pU63pErEVUQPmc0JZqKvpxxXeXRh4cOSgi+gi5Dnw
         qo06UQeUvAKaEwy5+kwO+1RY1i1/zA/TcEz6rKFbzx7K4xZkOVJW38WWpMqCw3Ro37wC
         N5P5WBeaB/PrOgTBu5Sp5XHJiEP3Xnew2JEyErfbr0QW9AaEZiOpq0mQ/osUb6+NQbIY
         rke2CptHmd3TTE/BxmlDidWSJs+NaQn6bgoMvW2D6aq6cqOqWIyurfXC6vUhbQSVXz+V
         FcExAt9H1f0irwTa4vlosFqZxZzIy7tp13VikoJgtABS9gNWUc8edxUfGd+9ZesgD9eu
         Jr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5WkJnGKcklgXkfGMCLvHjH3UFxshtzm1KBU3E5R4Uxo=;
        b=FZCAZJbetNSaScYqXS/CHA9rDGm+rcsT6mB9de5TEobSlZZFZjb4iIMDW+xTXd0kU/
         c19xnpNVTDtI0x5DK2KMCyaeblgf4iYXyygXv5dQiNpMQf1iP8zCyVy8NXOuutMoCn8y
         tFIyjUm3zmhvU6WqvaFdVFfn29FBAExXHFUHC9KzONrS0Q597a8YhmcE16bhLFshkdc8
         83d97RZNjvRHDoejqXBmv6g9ACJIy3db4wWThF9OB5BQQW+Yahz4m4zsFJJthvOkyzA1
         lj+l9wzj3H29/ZFJpfnTD2ScZO2cDuoc+zjfTuEK+StBnx6RE23gzAT/BHfK5j4XVHdt
         S5EA==
X-Gm-Message-State: AOAM53390eUQstfTrnw/830gG28rB5QyBcTRRMkdtdwdsH7WVBxlCbPP
        0ZWYTm8Gh6vX1BIrw6vHR9QjztsJ8TUHgQ==
X-Google-Smtp-Source: ABdhPJxAhQM4RpUnsHQcEr9o3MtBGg/UffyWFgZnoWojiTjx7IPEa6jn+riknc5n1orIarqFm+470Q==
X-Received: by 2002:a2e:381a:0:b0:24b:68ae:4169 with SMTP id f26-20020a2e381a000000b0024b68ae4169mr1158818lja.208.1649678801406;
        Mon, 11 Apr 2022 05:06:41 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a19ad4a000000b0044826a25a2esm3297627lfd.292.2022.04.11.05.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 05:06:40 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH v4 net-next 3/3] net: dsa: mv88e6xxx: Add HW offload support for tc matchall in Marvell switches
Date:   Mon, 11 Apr 2022 14:06:33 +0200
Message-Id: <20220411120633.40054-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411120633.40054-1-mattias.forsblad@gmail.com>
References: <20220411120633.40054-1-mattias.forsblad@gmail.com>
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

Add the ability to handle tc matchall drop HW offloading for Marvell
switches.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64f4fdd02902..cbffba18e240 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1436,7 +1436,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	 * bridge group.
 	 */
 	dsa_switch_for_each_port(other_dp, ds)
-		if (other_dp->type == DSA_PORT_TYPE_CPU ||
+		if ((other_dp->type == DSA_PORT_TYPE_CPU && dp->bridge->local_rcv_effective) ||
 		    other_dp->type == DSA_PORT_TYPE_DSA ||
 		    dsa_port_bridge_same(dp, other_dp))
 			pvlan |= BIT(other_dp->index);
@@ -6439,6 +6439,20 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
 	mutex_unlock(&chip->reg_lock);
 }
 
+static int mv88e6xxx_bridge_local_rcv(struct dsa_switch *ds, struct dsa_bridge *bridge)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mutex_lock(&chip->reg_lock);
+
+	err = mv88e6xxx_bridge_map(chip, *bridge);
+
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
 static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 					   struct switchdev_brport_flags flags,
 					   struct netlink_ext_ack *extack)
@@ -6837,6 +6851,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
 	.port_mirror_add	= mv88e6xxx_port_mirror_add,
 	.port_mirror_del	= mv88e6xxx_port_mirror_del,
+	.bridge_local_rcv	= mv88e6xxx_bridge_local_rcv,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
 	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
 	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
-- 
2.25.1

