Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E4F4EEAF2
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 12:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344905AbiDAKHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 06:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344902AbiDAKHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 06:07:00 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62594173F58
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:05:11 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m3so3908975lfj.11
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 03:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kugPTravw/pWjMItvRqIfrO55/1h/afpYQ2vDHdA2dc=;
        b=RyPCXTzyq9SWZ6h+cRcDbwfd6OjSZAkGqxxhCAfmyIbxx7RjG0FkkESQcXH738rULP
         Qfv5ikG4gDeOuNIKQPskLK1wcz8Jai0v9Yn8AE6CJ1KqRM34A8OAsjdIbzO9pwZtuptg
         v9d4UmNNc2lRv4R8iDa/nPa/fc1uWizvEok/2J705c+nedoai01UeCM/TAt10en8Z+AY
         nbvFavbkrFJFOHiIsjf10QMoMTraAQKwyfZImgevqDqDeD62F3HWb0oxFUAnAyRDpk9D
         W9Yoddm0tJ3B0Ft7CbKXKxh4QqWKjDU9a2ynGJiy2WfxoxLY2ZrQeb3cX+nZnOcAXzaz
         1q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kugPTravw/pWjMItvRqIfrO55/1h/afpYQ2vDHdA2dc=;
        b=scfY642Pc0/ML1WJ6VIHlQVSbta9FBwixtW67CVw50KlFXfTuB7h5GVlyB8+OYje/Q
         yz3+8HCWgx2j/f0lvxRKVWCPssyIzj+ADLGGJbQa8+WONLeCF6vQAfzcSTY27QtthJse
         jcNiA0KqSpT08tRyR0LWTIo5zcoMj2zDSYcmztyWuLd5QWiLoNYNpL3f2JZWVdeE5KV5
         YPTyamenBdEKRsbRSXl+SbdHGd1Xu8Vv4DuoVzJqAkAIQ6ugXJD1Es6xEk0qMUB92jJ7
         +ltewB5R/+CzwNgwPt+4/X4d0bd7BhWOVF9xN1H6Z34bS4EAxBSYP7XZlmMv7Lw2cp9T
         a+gA==
X-Gm-Message-State: AOAM530h81FrQ1wuFCDZZgURQuUQ0pN2kCBWMyg6MdPEU19o73LgZMfN
        2Z8oc8zeYizg2+8nyPvpehZ9/mlOMvWYZA==
X-Google-Smtp-Source: ABdhPJzBGW5IdtXgGP0HgPvJiRf4YxJ8Vm2zwXF1+AUmW5fUleAJ9QCs9gVGOGd2qcazKv3RBqoaOg==
X-Received: by 2002:a05:6512:1295:b0:44a:27fd:cd00 with SMTP id u21-20020a056512129500b0044a27fdcd00mr13061809lfs.196.1648807509396;
        Fri, 01 Apr 2022 03:05:09 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a19e211000000b0044a1348fc87sm197903lfg.43.2022.04.01.03.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 03:05:08 -0700 (PDT)
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
Subject: [PATCH v1 net-next 2/2] net: dsa: Implement tc offloading for drop target.
Date:   Fri,  1 Apr 2022 12:04:18 +0200
Message-Id: <20220401100418.3762272-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401100418.3762272-1-mattias.forsblad@gmail.com>
References: <20220401100418.3762272-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64f4fdd02902..84e319520d36 100644
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
@@ -6439,6 +6439,26 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
 	mutex_unlock(&chip->reg_lock);
 }
 
+static int mv88e6xxx_bridge_local_rcv(struct dsa_switch *ds, int port,
+				      struct dsa_mall_drop_tc_entry *drop)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_port *dp;
+	int err;
+
+	dp = dsa_to_port(ds, port);
+	if (!dp)
+		return -EINVAL;
+
+	mutex_lock(&chip->reg_lock);
+
+	err = mv88e6xxx_bridge_map(chip, *dp->bridge);
+
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
 static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 					   struct switchdev_brport_flags flags,
 					   struct netlink_ext_ack *extack)
@@ -6837,6 +6857,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
 	.port_mirror_add	= mv88e6xxx_port_mirror_add,
 	.port_mirror_del	= mv88e6xxx_port_mirror_del,
+	.bridge_local_rcv	= mv88e6xxx_bridge_local_rcv,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
 	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
 	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
-- 
2.25.1

