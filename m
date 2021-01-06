Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41CB2EC6C5
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbhAFXTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbhAFXTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:19:11 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1439C06135C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:18:06 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw4so7215729ejb.12
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M2VqyHG2HX9apOvyYcN1fNwb6SDnXCbaKG0Lb94i9BU=;
        b=qPFC4Fd88p0lJ8qSJWPwy03M8rZNicZ0ZHsgHS1btlUfzVy5Ci3olfKX5CKeajwIDJ
         /0A8IAv6SLQgLFHlA/1H+yJRvFlDfEAIMSWou7Ugohhj1dz5gPEvZ+o2Kq3/rIOc/8Av
         bI3aFrnAmpkRBNvBF5f9Si3dQeVHbw1UDDFi/f5ssJ8tbo1i74Afh5RnCnHNKpXz89EZ
         ayz7Bfw24YGZK/zGlHVr7Pvw5psbn3/ia5lg2xgYF+uvfPq6lNuSM6z7A7ZH94P+GPIv
         MN7wrXEcpMeTRiAyQwr1Si7lXdc8KpN7qW6h7xuQYXf/8Pk5AErXs2NL3dqy8ScPfYxA
         wzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M2VqyHG2HX9apOvyYcN1fNwb6SDnXCbaKG0Lb94i9BU=;
        b=QYlm1ZnFF4p2cLLwZ8DrBSrSt3dpKNNigG/6iWgJtXYG1cexrLAXfXaUvvR0Su87VG
         Vsk3Fq/rSMhC8r6ocAcXekGTJq3od88Bvw8zAne1NURA472EIkbdKU/xDLNweRVeD9NY
         PKYboBw3ymJPp8mz6/QmM/Ez5kLhkTAWPfUHhVuqdPT66gegqPLW9ZcRlvVB3vJKjFhE
         SB6Ufu2FDN2TxiZeN1wPtNAVJTK2EkSE706jqaxMpAzVP7ySdeFFiSHHr16n1q6HG0Pw
         JKwlX0JFl2Rq9LO7Nrz/rUE4JsCFvL9qC3qwLVX4RV4UegYe8469qB62ZlwGYtygg0PY
         VMbw==
X-Gm-Message-State: AOAM5324RZy7+zhw3PsfsBUAFmXw6GuLolw37FwjM1ah/Z5qEgWBYhBp
        UKGDUMcfHOIGRQe3l14wVq4=
X-Google-Smtp-Source: ABdhPJwAuKrpWhW0ZiAc/1SqSWeJjpsfpz2y1MP7P+qBEs46BQQTTPYA88N62KaI6NmkVU25WI8Rfw==
X-Received: by 2002:a17:906:26d7:: with SMTP id u23mr4353061ejc.210.1609975085662;
        Wed, 06 Jan 2021 15:18:05 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:18:05 -0800 (PST)
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
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 11/11] net: switchdev: delete the transaction object
Date:   Thu,  7 Jan 2021 01:17:28 +0200
Message-Id: <20210106231728.1363126-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106231728.1363126-1-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com>
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

