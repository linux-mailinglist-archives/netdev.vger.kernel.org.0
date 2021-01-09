Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330CE2EFBFF
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAIADk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAIADi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:03:38 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED0FC061798
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:30 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id jx16so16735644ejb.10
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kJEN/ZsKhzA6SSAWwS2AkWGKrA4EmtsC7G6dJPP/t3I=;
        b=Jt2No+hFLOll1wZdLQNu+RM1VWLtUsz544V7m6CpqjRQYA8TeUWjomL4dWFGb5syQG
         r205YOoG6SqS4PyxGnd1SnQK90qbhDuz4qlAH2UEuIkKjbDIntIdE+4mu1NAgqNat09R
         9OIqojqKVnn7MY9P/7JgzCm66FsQOIU8XxgHXNXCd8TKDkUvzelpA5YawN6mGy8cs8wj
         8u0rT0hyZjBBzB6bhL3l3vrgFw1OWdYI6DabRLOTJUNIacec0C8Rh0nxnD0KgUG2mopR
         DzMD/nqNbu1z/iCSqQqrM64A3V3Px/8H07H6nrkuQfU92OR+JGNNVodQwVCkLf7aCF3Q
         ud6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kJEN/ZsKhzA6SSAWwS2AkWGKrA4EmtsC7G6dJPP/t3I=;
        b=nu5vEXydnE4jgIJB4+hhwEaPl8P3PISQorUSYtkEn17tZ8xokEVeHHeTAScqLSr1pJ
         S++bIN9UOb/P/PrOLXUKFQF7RlSxwUCJ5j44yhxymESbjFzg/u1jsM2UJIWMM3OGhJDW
         bwTCl91/O1ET1rIVs38hPFhOn2+2h/6cJnVFQyYgVsZG0uVQ9RwU+SCdOJWoQ7e3D+Ud
         tIoR6iKdWeGFO7XyJzMn0ToyIi04n6kV24U1JoavV9GgtqD9H/S/6dugEkW63fjFFlZ1
         5U34ru7Ub0OiKHMn9JWKzsBBmlUEEkJpNMSgay9Cs5Eg/CWUMdI2lcXWfCWdsiMKxH1f
         L0ZQ==
X-Gm-Message-State: AOAM533fSlfYgHjehNe/1tg2kdI2aiDZ31A2elldUG50GdFrGHdY6cYa
        4YsgPKzi8ff82hx41vUGRqo=
X-Google-Smtp-Source: ABdhPJxgoHdB+cmpdddNuRyWOAYOcyu3cdgIATd3XERcwUQs8uGr/mGbuF9pLHIXp5hAIsf18frYpA==
X-Received: by 2002:a17:906:934c:: with SMTP id p12mr4315926ejw.361.1610150549244;
        Fri, 08 Jan 2021 16:02:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 11/11] net: switchdev: delete the transaction object
Date:   Sat,  9 Jan 2021 02:01:56 +0200
Message-Id: <20210109000156.1246735-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that all users of struct switchdev_trans have been modified to do
without it, we can remove this structure and the two helpers to determine
the phase.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 include/net/switchdev.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index f873e2c5e125..88fcac140966 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -16,20 +16,6 @@
 #define SWITCHDEV_F_SKIP_EOPNOTSUPP	BIT(1)
 #define SWITCHDEV_F_DEFER		BIT(2)
 
-struct switchdev_trans {
-	bool ph_prepare;
-};
-
-static inline bool switchdev_trans_ph_prepare(struct switchdev_trans *trans)
-{
-	return trans && trans->ph_prepare;
-}
-
-static inline bool switchdev_trans_ph_commit(struct switchdev_trans *trans)
-{
-	return trans && !trans->ph_prepare;
-}
-
 enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_UNDEFINED,
 	SWITCHDEV_ATTR_ID_PORT_STP_STATE,
-- 
2.25.1

