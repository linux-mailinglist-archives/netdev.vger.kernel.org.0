Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F39658F2E
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbiL2Qo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiL2Qn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:43:57 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD1FA199;
        Thu, 29 Dec 2022 08:43:56 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id bs20so15756695wrb.3;
        Thu, 29 Dec 2022 08:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K32EyFMV6FUh1aAwdxHu1pne9VDoC7iSSDyRiO1hCEI=;
        b=pSkPAgYPmTUsCz9MOADVcqzejZRlI6eIfVrwwxMi5xPpVG5WAJGvumXbnKi0KpfSIm
         8njcding+K2xqa5q8U/6q/NKKF4+y/h+98qPb+zJ8P+taQCH+38zrAGfnZ73uKdJ0aBP
         agzCuf1SePxSpi7ucVkPWZ1OCNQ//EgFjFa0oH9QskLHJaTuRX2vsTM7S6zC1sfcaer6
         hQ/IRq3oRdTvD1FBYlPM4aL42/RLIKkPG3naFFEzTXfbRrgdQrkneYNgPb4AZUaZ6aPi
         zVvwPV5LlLWEUkSsjSyF6PNOKIaQALXGhFPDsEp67Jm8TQxCu8jSH8ydIT2oyehkKB38
         PueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K32EyFMV6FUh1aAwdxHu1pne9VDoC7iSSDyRiO1hCEI=;
        b=BXNh4Q1hrwqdXtVE0ssbRK+g8m7wlk8Inksk2k2aq0kRWNmRalTBJ/GC+NUJP/ok4C
         wGxK0+e7ZW1MS9tOdRyvsuwXW1ZgEzOvXHIveyGuCaH+MBgU1daG2Yfjk7TBrafPTmfE
         g56yrOaOgKy+VgxqoYzYZgxV5++WAWOlVkRmNSTUJcv8VVS2VhoMaV2dIC+6U9hRFJWt
         grIO/+liG83bpysKptL3cu8WS2L/VYD4lDZCg/ETU80npymi8FJ0hCb+ZasDQxEsMcr0
         /Q2U/0WFfy2CL16zdcx+OyycNV5gizYOwxrwLsa4OPEOhNiYwv+vszdOdYZeIE5WILoV
         b2mg==
X-Gm-Message-State: AFqh2krWH3+nyuwYEWSpFU5vpyshBTwO07+sMamPdeTVM9fpaUzmOZYc
        Pg7YiSLIvoryWZ/LcTrV9YA=
X-Google-Smtp-Source: AMrXdXt193ntq7YVwH06QLbN7vp5FVX4Y4woutywB3i5Ywf1qycBRuLUCEju8SoCJw8IEFCqUu5gTA==
X-Received: by 2002:adf:f305:0:b0:277:2e27:61fa with SMTP id i5-20020adff305000000b002772e2761famr12109903wro.9.1672332235404;
        Thu, 29 Dec 2022 08:43:55 -0800 (PST)
Received: from localhost.localdomain (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.googlemail.com with ESMTPSA id t18-20020a5d42d2000000b00288a3fd9248sm4326586wrr.91.2022.12.29.08.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 08:43:55 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ronald Wahl <ronald.wahl@raritan.com>
Subject: [net PATCH v2 5/5] net: dsa: qca8k: improve mdio master read/write by using single lo/hi
Date:   Thu, 29 Dec 2022 17:33:36 +0100
Message-Id: <20221229163336.2487-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221229163336.2487-1-ansuelsmth@gmail.com>
References: <20221229163336.2487-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve mdio master read/write by using singe mii read/write lo/hi.

In a read and write we need to poll the mdio master regs in a busy loop
to check for a specific bit present in the upper half of the reg. We can
ignore the other half since it won't contain useful data. This will save
an additional useless read for each read and write operation.

In a read operation the returned data is present in the mdio master reg
lower half. We can ignore the other half since it won't contain useful
data. This will save an additional useless read for each read operation.

In a read operation it's needed to just set the hi half of the mdio
master reg as the lo half will be replaced by the result. This will save
an additional useless write for each read operation.

Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 92c4bfef7c97..2f224b166bbb 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -740,9 +740,9 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	ret = read_poll_timeout(qca8k_mii_read32, ret1, !(val & mask), 0,
+	ret = read_poll_timeout(qca8k_mii_read_hi, ret1, !(val & mask), 0,
 				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				bus, 0x10 | r2, r1, &val);
+				bus, 0x10 | r2, r1 + 1, &val);
 
 	/* Check if qca8k_read has failed for a different reason
 	 * before returnting -ETIMEDOUT
@@ -784,7 +784,7 @@ qca8k_mdio_write(struct qca8k_priv *priv, int phy, int regnum, u16 data)
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write_hi(bus, 0x10 | r2, r1 + 1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -814,18 +814,18 @@ qca8k_mdio_read(struct qca8k_priv *priv, int phy, int regnum)
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write_hi(bus, 0x10 | r2, r1 + 1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 	if (ret)
 		goto exit;
 
-	ret = qca8k_mii_read32(bus, 0x10 | r2, r1, &val);
+	ret = qca8k_mii_read_lo(bus, 0x10 | r2, r1, &val);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write_hi(bus, 0x10 | r2, r1 + 1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
-- 
2.37.2

