Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6758561BA9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiF3Nqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiF3Nqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:46:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFC521274;
        Thu, 30 Jun 2022 06:46:34 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id fw3so11472710ejc.10;
        Thu, 30 Jun 2022 06:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WpUG/1Adlro4yhfIfUNT1zQ44D9g1crkrWmNqAskdRQ=;
        b=XdyaQI4bpl3rJeGqJ7aKTdzqGPKYOk0JKqHMymVALHU8U40ZV/bQRSUEy4zPafkGSY
         h3DQr2JOUJ/VYZqt6zgDPbLV4tlzjAokSYethVPC8lXnTqoX3h0V8NT9KIr1xBQGQhuc
         +9/6Y+B9qoOrsAVI3vy/ZBxpKI5J/JwiZvWlxX52h6IbJicVx/coPBN8nveFtW3ouOMV
         9/7y2UGv1dVMvoLELH9AmGmE6NnC4urs3ClM1rokPaNhmAUrxbBswwn2DOAXTiLfPpTn
         0TXVc6JhvUUWKC+dv7e6+uAc0TBMlWc+YWe1OGV4/ezeNwhofTtTSJAji5gPMPfJkrkH
         4pQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WpUG/1Adlro4yhfIfUNT1zQ44D9g1crkrWmNqAskdRQ=;
        b=HiM1eVaiQTRN548SRVOwVLVANC3sgDp6sT1vJ+e18zn5F9eK8P8rmTHJyHSyr+dvFn
         uk1HsEOMokwo3W2KR6LzxpaDGkfXJRkf3cfjgPOGLmHyZg6E8uqO3FL5+YMLyclSyfTu
         UHZfbAoT4Mh4G4UtIalKB4vUVcwKYXok9svwtWUeb0RnikyrR0wR7OVV228kooKtuDnn
         yWUDP6KZ+M9+TBuyigEz2k1g0KE9lQQrm0+fmqxcxWKDW1NavqmWbE2/Nd6pM6icgZIP
         HBwe9FPxVRkBQ7IoWlM0QhKTNXKX3lwiFDYhquE57MwOxTc9CLQHr8XMtazEocUBah+N
         4WeQ==
X-Gm-Message-State: AJIora/EuO+ySNXK7r7hjGfPgiLpJD9d22Cyx271BSXzCX08wa3qZqjF
        IuLx0Kjxvnrd38bo80+jrzo=
X-Google-Smtp-Source: AGRyM1v/saxokxA3Z1/0oWe8gdZOE0DUfGiMLl3Mrmq+LzIasuT/CYNL75AKaoF7LOGKSfDab6f9HQ==
X-Received: by 2002:a17:907:968a:b0:722:e508:fc15 with SMTP id hd10-20020a170907968a00b00722e508fc15mr9385020ejc.188.1656596793056;
        Thu, 30 Jun 2022 06:46:33 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id bk8-20020a170906b0c800b0071c6dc728b2sm9016615ejb.86.2022.06.30.06.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 06:46:32 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH RFC] net: dsa: qca8k: move driver to qca dir
Date:   Thu, 30 Jun 2022 15:46:06 +0200
Message-Id: <20220630134606.25847-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Move qca8k driver to qca dir in preparation for code split and
introduction of ipq4019 switch based on qca8k.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---

Posting this as a RFC to discuss the problems of such change.

This is needed as in the next future the qca8k driver will be split
to a common code. This needs to be done as the ipq4019 is based on qca8k
but will have some additional configuration thing and other phylink
handling so it will require different setup function. Aside from these
difference almost all the regs are the same of qca8k.

For this reason keeping the driver in the generic dsa dir would create
some caos and I think it would be better to move it the dedicated qca
dir.

This will for sure creates some problems with backporting patch.

So the question is... Is this change acceptable or we are cursed to
keeping this driver in the generic dsa directory?

Additional bonus question, since the ethernet part still requires some
time to get merged, wonder if it's possible to send the code split with
qca8k as the only user (currently) and later just add the relevant
ipq4019 changes.

(this ideally is to prepare stuff and not send a big scary series when
it's time to send ipq4019 changes)

 drivers/net/dsa/Kconfig           | 8 --------
 drivers/net/dsa/Makefile          | 1 -
 drivers/net/dsa/qca/Kconfig       | 8 ++++++++
 drivers/net/dsa/qca/Makefile      | 1 +
 drivers/net/dsa/{ => qca}/qca8k.c | 0
 drivers/net/dsa/{ => qca}/qca8k.h | 0
 6 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/net/dsa/{ => qca}/qca8k.c (100%)
 rename drivers/net/dsa/{ => qca}/qca8k.h (100%)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 702d68ae435a..d8ae0e8af2a0 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -60,14 +60,6 @@ source "drivers/net/dsa/sja1105/Kconfig"
 
 source "drivers/net/dsa/xrs700x/Kconfig"
 
-config NET_DSA_QCA8K
-	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
-	select NET_DSA_TAG_QCA
-	select REGMAP
-	help
-	  This enables support for the Qualcomm Atheros QCA8K Ethernet
-	  switch chips.
-
 source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_RZN1_A5PSW
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index b32907afa702..16eb879e0cb4 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -8,7 +8,6 @@ endif
 obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
-obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
 obj-$(CONFIG_NET_DSA_RZN1_A5PSW) += rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
index 13b7e679b8b5..ba339747362c 100644
--- a/drivers/net/dsa/qca/Kconfig
+++ b/drivers/net/dsa/qca/Kconfig
@@ -7,3 +7,11 @@ config NET_DSA_AR9331
 	help
 	  This enables support for the Qualcomm Atheros AR9331 built-in Ethernet
 	  switch.
+
+config NET_DSA_QCA8K
+	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
+	select NET_DSA_TAG_QCA
+	select REGMAP
+	help
+	  This enables support for the Qualcomm Atheros QCA8K Ethernet
+	  switch chips.
diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
index 274022319066..40bb7c27285b 100644
--- a/drivers/net/dsa/qca/Makefile
+++ b/drivers/net/dsa/qca/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
+obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca/qca8k.c
similarity index 100%
rename from drivers/net/dsa/qca8k.c
rename to drivers/net/dsa/qca/qca8k.c
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca/qca8k.h
similarity index 100%
rename from drivers/net/dsa/qca8k.h
rename to drivers/net/dsa/qca/qca8k.h
-- 
2.36.1

