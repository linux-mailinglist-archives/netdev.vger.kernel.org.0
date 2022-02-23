Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E446D4C101C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiBWKSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239580AbiBWKSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:18:04 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AED8BF2C;
        Wed, 23 Feb 2022 02:17:32 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id i11so30157634lfu.3;
        Wed, 23 Feb 2022 02:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=oETJ8BHkapcELva/Ym67RlDH1CS2/CVd4pT03JpAmjk=;
        b=niLwSzOyLHWERXqZJHx2dzbnAu9sBRR0CeAA6LttC/cVpasLf8KoH1o9+3Kk4dYtn2
         K+ASu7wOOm7npfuE4pl+6MKzQM/L+cIp2rkZXe4kz1LDmGSsOzhZSu+srpY6VUDnUIIR
         ZuS6jepKgiXavQyQVN2h577+noHVYnITJDxA9Qpn9CE61n5h7p+dW6Fsk8k1ZFLw6RzE
         qU216CveivbgsoRFFBhOVPIKwrq/qWnAzCiqGg8FFhi+nctUJYlMWjjnZho5FLs7B1oK
         M+dSNqife8xnMbYSm9SETUuIsuWrfyt6H/cKtk/tDJxjMNliDS1q7o3fPaKALsJKbXQL
         sEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=oETJ8BHkapcELva/Ym67RlDH1CS2/CVd4pT03JpAmjk=;
        b=f/uMgwSJwOoZ28HBWzcFShvVAHEsmJpVSjHJhBI5b34kh048CdQHDgKInZaGRfrqKY
         xuN7z38X41tYFY5d21HovjjpEkyb2bWae++oPg6Ti58E8921+l2MF7XRM80veHN/isW4
         Iu18PkHy5eD8XhDoUNBp17zkdtixB1AvrMsn0R2oz3Vy3L6BneG4fiwmMExqKZH7PI4e
         s8LV7prwqMXOK6YoC6SE+g79RZGa7j4glkoKi6SE+FfJMXG7LrgGgAHh2M84zInRKPCm
         buOfbCCgcYS2ULaEkm2Q+fxMEwMleQYQPZ8ZJ0eUb9u2fibE7sMXlfgLzTTfyAW8nZQM
         RD2g==
X-Gm-Message-State: AOAM532pVryDij6YWQqR8gHRD9TI5Dfgsoxw20CmCE2mHWdK6bgZt+xa
        odEhwCX9DWTbup296v1i86o=
X-Google-Smtp-Source: ABdhPJxUpI2v1ML4RH6CxYioCpG6eXJZsIWfYHtDZ7Z6Ism3hgfELJYfGbFge4bV9mCerBVr3Oao8g==
X-Received: by 2002:a05:6512:224d:b0:43e:da3e:46c9 with SMTP id i13-20020a056512224d00b0043eda3e46c9mr19709388lfu.581.1645611450237;
        Wed, 23 Feb 2022 02:17:30 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id d5sm1613102lfs.307.2022.02.23.02.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 02:17:29 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v5 4/5] net: dsa: mv88e6xxx: Add support for bridge port locked mode
Date:   Wed, 23 Feb 2022 11:16:49 +0100
Message-Id: <20220223101650.1212814-5-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
References: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Supporting bridge ports in locked mode using the drop on lock
feature in Marvell mv88e6xxx switchcores is described in the
'88E6096/88E6097/88E6097F Datasheet', sections 4.4.6, 4.4.7 and
5.1.2.1 (Drop on Lock).

This feature is implemented here facilitated by the locked port flag.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  9 ++++++++-
 drivers/net/dsa/mv88e6xxx/port.c | 29 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  9 ++++++++-
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58ca684d73f7..eed3713b97ae 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5881,7 +5881,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	const struct mv88e6xxx_ops *ops;
 
 	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-			   BR_BCAST_FLOOD))
+			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -5939,6 +5939,13 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 			goto out;
 	}
 
+	if (flags.mask & BR_PORT_LOCKED) {
+		bool locked = !!(flags.val & BR_PORT_LOCKED);
+
+		err = mv88e6xxx_port_set_lock(chip, port, locked);
+		if (err)
+			goto out;
+	}
 out:
 	mv88e6xxx_reg_unlock(chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index ab41619a809b..b71061009fd4 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1234,6 +1234,35 @@ int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
 	return err;
 }
 
+int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
+			    bool locked)
+{
+	u16 reg;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
+	if (err)
+		return err;
+
+	reg &= ~MV88E6XXX_PORT_CTL0_SA_FILT_MASK;
+	if (locked)
+		reg |= MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, &reg);
+	if (err)
+		return err;
+
+	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
+	if (locked)
+		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
+}
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03382b66f800..3f70557f0d48 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -142,7 +142,11 @@
 /* Offset 0x04: Port Control Register */
 #define MV88E6XXX_PORT_CTL0					0x04
 #define MV88E6XXX_PORT_CTL0_USE_CORE_TAG			0x8000
-#define MV88E6XXX_PORT_CTL0_DROP_ON_LOCK			0x4000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_MASK			0xc000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DISABLED			0x0000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK		0x4000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_UNLOCK		0x8000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_CPU		0xc000
 #define MV88E6XXX_PORT_CTL0_EGRESS_MODE_MASK			0x3000
 #define MV88E6XXX_PORT_CTL0_EGRESS_MODE_UNMODIFIED		0x0000
 #define MV88E6XXX_PORT_CTL0_EGRESS_MODE_UNTAGGED		0x1000
@@ -365,6 +369,9 @@ int mv88e6xxx_port_set_fid(struct mv88e6xxx_chip *chip, int port, u16 fid);
 int mv88e6xxx_port_get_pvid(struct mv88e6xxx_chip *chip, int port, u16 *pvid);
 int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
 
+int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
+			    bool locked);
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode);
 int mv88e6095_port_tag_remap(struct mv88e6xxx_chip *chip, int port);
-- 
2.30.2

