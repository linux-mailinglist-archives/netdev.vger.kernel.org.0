Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8153C4BF96B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiBVNaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiBVNaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:30:20 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4C915DDFE;
        Tue, 22 Feb 2022 05:29:47 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id v22so17638743ljh.7;
        Tue, 22 Feb 2022 05:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=oETJ8BHkapcELva/Ym67RlDH1CS2/CVd4pT03JpAmjk=;
        b=j12X/FWRwP1+D8mxEcvX9o1jdK90B92UFl6uKY24B15j42WEP+srspWV5F6vGLS3en
         5VCaV/Gj4M0nNhycL7FB8zZgyWIDNhdMoxS0iRvH41gMixqELiqCg5nim0zw47KXtHtW
         ELNq6gZY3gg8tnJifGB04Cdp/JgrWC6J9lfsk2I3e2su10YMStxSFwFXSNY5AapTe2IU
         kk0Sth4aVEs8jIxztVhiV2ZMYcpHQSeMgSc/TfK02AjxIiIki5+BtqeRAFI469BH85e7
         1PpvbjDd8Ygfb+IBp28O6yT+RHo79Zsswq2z8foV6zP7xRqKC5iN/YcKi708AJG5fHVa
         ZHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=oETJ8BHkapcELva/Ym67RlDH1CS2/CVd4pT03JpAmjk=;
        b=b9OM9+hC5IQySSxdOvlrK/5wAKaUdtqqNqczfKU6KS9BETBHlBxWhcTIPcwaioBGPb
         rZiUuc0EAbOMu4DYCTJD5aOkiVHgcXElwECfW1UPfgI409CaMUT27IMMfprHxoetNt5/
         DbUPUTRt8u8CogR3773IR5c47rVmnh99ZnEI9ja/JRoZ9yrPsPCa39rXdTBxrrvWVbz5
         krAgZpw8yfsqOKw9nYmF4wHLdcN8TuzeUz4e6P4VQTBKkx69bFHjnr0frh4a0p2ME2re
         TUe2wEha4DECs2F5W0OHVQVWOTus3TmV8zHzIIGg5Ht/dE+SLsMpjx+DJaFTZ08MZW4O
         Y3UQ==
X-Gm-Message-State: AOAM530WzE2HRYzub3iS6NEDHN4QV3HrIScgk1fYyHoxTlsygK9zpSqA
        pbOnacWvlLPutnCXDsb+Xf4=
X-Google-Smtp-Source: ABdhPJxwB+q7fkT4IJ7EndAKT1ahOl0DgKmvFhWAHFnAngrAcpm5HSGA7KZwvbpqXldPfYV8tXdcZg==
X-Received: by 2002:a2e:2e0e:0:b0:246:1570:f001 with SMTP id u14-20020a2e2e0e000000b002461570f001mr17306006lju.217.1645536586366;
        Tue, 22 Feb 2022 05:29:46 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id e22sm1703685ljb.17.2022.02.22.05.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 05:29:46 -0800 (PST)
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
Subject: [PATCH net-next v4 4/5] net: dsa: mv88e6xxx: Add support for bridge port locked mode
Date:   Tue, 22 Feb 2022 14:28:17 +0100
Message-Id: <20220222132818.1180786-5-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
References: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
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

