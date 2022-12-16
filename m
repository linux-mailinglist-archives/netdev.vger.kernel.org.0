Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D1264EED7
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiLPQSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbiLPQR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:17:57 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA52BC02;
        Fri, 16 Dec 2022 08:17:57 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v7so2273668wmn.0;
        Fri, 16 Dec 2022 08:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K32EyFMV6FUh1aAwdxHu1pne9VDoC7iSSDyRiO1hCEI=;
        b=NCdHnRpUbtKwoVmvh4fXZfCpg9PMvdqa4PlkaI3MhlXL/6X99OgI143iir4lw9RmhR
         I5KexamjUSYDgMPyinyf7k22onnd591fjOSm+E2B6V0U4ZgtkziBG4AUmGvXs6KQ1ZPX
         ym4Y89iMRCOAagC4VXhpK7K12+Ln5ww0p/XLnhUATYPdBicpn855U88kdcJFJCbd28bB
         1g/x5GwoLY3UngAo1o2Q0Yci43j72j4B07Wm3oJ7v9Tly/C5AbOvWN6mPMrd4CUU85Hs
         FF0MaM0ivqQZxAn6HorvEPm5KWOs+DvSJNfExi0/kEyhi9GKU96GKfthWh9UUoKIdmk6
         AOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K32EyFMV6FUh1aAwdxHu1pne9VDoC7iSSDyRiO1hCEI=;
        b=SCcc/y1E9NLpB4yNcACboxAwjpdSbDJfmWuetZz+KdqY98JwsoR8PvP/UPBea+EHnm
         ZdcyMBlL+s2LFlc80MGXCyUVzcxcTtn7CArLZiwi1e57txD63CHAUF9FJU/XtckYFQyj
         ReQTfSSV+JUAX7pbG9uyRNAmlyiGuE9dwV/tflVQOjmNN4n3zOFT7v3YFy6jttEDut3g
         GqPB4dpty7ic/xBzVaqf07ObMKVzb2Vz2qsL+NBXLudLf1lGU5udfZT6lYwVJE4np3ia
         k2n2FY3yb/bQxYvl1YakJMchSR2OpUfKcSozs8gRRyc0MSjSXauiSQP4+qRP63yfCCPt
         Gn9g==
X-Gm-Message-State: ANoB5plodnLw4mqFkPWR71YIBC4VXTSnVEs+T/seXVC/8n/AZghHtYLf
        wToHfNvxCxpvAW+OxJ33NBA=
X-Google-Smtp-Source: AA0mqf7wYGqWC7bfiRafmQGtA3gojbHSNlvgDLnCFR1CKkxWwRTwl1oPnMIbUVWut0na8wLloShIsg==
X-Received: by 2002:a05:600c:1d9f:b0:3cf:a80d:69ab with SMTP id p31-20020a05600c1d9f00b003cfa80d69abmr25843506wms.31.1671207475415;
        Fri, 16 Dec 2022 08:17:55 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id bj19-20020a0560001e1300b002238ea5750csm3079720wrb.72.2022.12.16.08.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:17:55 -0800 (PST)
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
Subject: [net PATCH 5/5] net: dsa: qca8k: improve mdio master read/write by using single lo/hi
Date:   Fri, 16 Dec 2022 17:17:21 +0100
Message-Id: <20221216161721.23863-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221216161721.23863-1-ansuelsmth@gmail.com>
References: <20221216161721.23863-1-ansuelsmth@gmail.com>
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

