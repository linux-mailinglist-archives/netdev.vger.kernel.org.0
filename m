Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D10A530F3B
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiEWKn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbiEWKnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:11 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981CC15813
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:09 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id m20so27841498ejj.10
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SA7kBUptP8owYsc/aym4C6KLeT4j+GV9lz0/ZYTVUvQ=;
        b=gsB/gfxA3ZZHAMA6Zpzh5QuZ4Sjr/R1YN0tXsyivGIVCHfiFO6sBn0htt/ugOVKXKV
         GRbS7esABsM3TXx/KRpYPoD092ZfkqaL38SW2dhP7xg8Ukhjy8X+QRxb65y5a5hAsqSp
         b9iod8EQfLcacWmpzinURdGemcv+wlUXkPPQvVVe23H2z6zf5kd/dMh6KpHXvux+Dw4h
         cQFidIl7gdyEWI6oHTfg/v9ZS4tgKe4pQiSsVAqfysk2KeI4MDlDRkZnqRzvzDtAkKC1
         T/oVerFP1n0GGzyBPGnd3X+oj4ZM520BlINR3B+hvRH9yJ5bXs5yQluQ9dbk3ML81s+J
         ZVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SA7kBUptP8owYsc/aym4C6KLeT4j+GV9lz0/ZYTVUvQ=;
        b=bjacq5GUwi/Ro3T1P0YeEnMdx42UQiZjND0kHA0sk+wo9xTXxlS+II3wvzfFoAVo2Y
         TJUvd5UDRi8H20dymomb+GGCR8KDsrVKaiq3LoSvpMuQg/HySDqqL3CvgDCTmdYkV9sI
         WeNcLd+4vfXxGGe4HGVj39rB1hYiRnupXrQJ2raD+ejJZQMzjC/lagEY9f30Ek8nseFw
         837rUdbDYEvICpp3tOidaIGL/zxvplZgmcYBIe2z8qPbwfc0mOzJjRpCMeR5soBJGlBX
         IH99agGNxgwaoJVzFUqlq7b9r/Ov02E7QqmE60Hj3nb9HjVnHhG3PsA2pfiUW0sja4ua
         Dl1g==
X-Gm-Message-State: AOAM533bkIyJ9+LUzD9IgPGADkyf5yez1AEt7sW5Yjyc6rYDfK6Cvgtz
        2Ez+aWbpYbx1DL1mT7Io1AFRlP4zdXg=
X-Google-Smtp-Source: ABdhPJzgS6RYQOTX0AQzQsbFVb95dzMJUj7AEv5qUahGoMpTFDCxkMJiuyzV2fGZqF81dPPlaWIc5A==
X-Received: by 2002:a17:906:544e:b0:6f3:bd59:1a93 with SMTP id d14-20020a170906544e00b006f3bd591a93mr18705421ejp.421.1653302587023;
        Mon, 23 May 2022 03:43:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 03/12] net: dsa: don't stop at NOTIFY_OK when calling ds->ops->port_prechangeupper
Date:   Mon, 23 May 2022 13:42:47 +0300
Message-Id: <20220523104256.3556016-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

dsa_slave_prechangeupper_sanity_check() is supposed to enforce some
adjacency restrictions, and calls ds->ops->port_prechangeupper if the
driver implements it.

We convert the error code from the port_prechangeupper() call to a
notifier code, and 0 is converted to NOTIFY_OK, but the caller of
dsa_slave_prechangeupper_sanity_check() stops at any notifier code
different from NOTIFY_DONE.

Avoid this by converting back the notifier code to an error code, so
that both NOTIFY_OK and NOTIFY_DONE will be seen as 0. This allows more
parallel sanity check functions to be added.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8d62c634c331..d8768e8f7862 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2685,7 +2685,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		int err;
 
 		err = dsa_slave_prechangeupper_sanity_check(dev, info);
-		if (err != NOTIFY_DONE)
+		if (notifier_to_errno(err))
 			return err;
 
 		err = dsa_slave_prechangeupper(dev, ptr);
-- 
2.25.1

