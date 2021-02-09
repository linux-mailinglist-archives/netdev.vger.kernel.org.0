Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7400F3152A3
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhBIPVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbhBIPVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:21:09 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4176C061793;
        Tue,  9 Feb 2021 07:19:57 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id t5so24173402eds.12;
        Tue, 09 Feb 2021 07:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AkDQjrnrduVZMAhweD9hW9j4GkN22HKFVzGcpRaV+qE=;
        b=e2T4P1lz4I17kuV+wPzF1odR3ie/Bvx7chGzyBa5nLxDS8zpjyOYw8E+gekxi6Njg9
         ulUBBz8A8aEw+NvwMpr0MF+G1OJwGToo92OHEW3NLxI0xqx1P7AlcP+NzOYNcxadP5AS
         WK4ofM/FGyYPIoMFl3mP0MWvBuXplNVio5f69uaUqTR5lFdls58Nv3Hq+Rte3izKImPA
         YCod4c7oT1Z/WDDmZAXNgyRjPW4RHyNLszvIPSVzKPBsTwQjxwKUEID5lzKBN7yCcaIp
         jouIKljFoOWvTyqSUDR8Brx2jsMHaYw06yglaGx/QJHduZF6+x0auRXnfR+gNzyUv8Vt
         FobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AkDQjrnrduVZMAhweD9hW9j4GkN22HKFVzGcpRaV+qE=;
        b=GrGCcv+8nCza39kc+Ji3L9XWDTHvZR6n4foo3vawBz3zmusRuELN1fcT0OgeR2d+Qy
         7yZqclIo4sXoySs5kbfz26ZLlR2lpK9i0Pt9f9/Fps13gHFlN0eMyo0+7PlMyJPhvEYI
         EcSgXpOZCoGLIrk55Tij5rXUkGXelOfQ5Qw14qdEktJ4sQbQ0X7m/bWPnE+XYzZeJJvV
         wUuH+Fx3voCsqdUoY4ICVpBqZl520GCNbthVTo5f8nh0U0p1CeMpBbBVxj8fDvhl0Fi4
         cPMfsfuM4GCiJaNal8UGEigH6/YxEnMKIF7BX4KU/uzLh39ayriqclGLbIrBmrtknuuW
         7m0w==
X-Gm-Message-State: AOAM532tcvWwH1Vd96a/rJYnzfk2siqGpUb2WTeaCZH5nvdiQ1nwPN/0
        UelkCA/IsXAXeXc21kcbkwE=
X-Google-Smtp-Source: ABdhPJzuQ7mcFJMPpcDbAQrcHufwzjpf1Hv43yQmuPKOGw0AryBbWqbIGRzaRdH0jH3N8t3NrTFg4A==
X-Received: by 2002:aa7:ce15:: with SMTP id d21mr24001894edv.246.1612883996701;
        Tue, 09 Feb 2021 07:19:56 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:19:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v2 net-next 05/11] net: dsa: stop setting initial and final brport flags
Date:   Tue,  9 Feb 2021 17:19:30 +0200
Message-Id: <20210209151936.97382-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

With the bridge driver doing that for us now, we can simplify our
mid-layer logic a little bit, which would have otherwise needed some
tuning for the disabling of address learning that is necessary in
standalone mode.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/port.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 5e079a61528e..aa1cbba7f89f 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -132,11 +132,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	};
 	int err;
 
-	/* Set the flooding mode before joining the port in the switch */
-	err = dsa_port_bridge_flags(dp, BR_FLOOD | BR_MCAST_FLOOD);
-	if (err)
-		return err;
-
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
 	 */
@@ -145,10 +140,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
 
 	/* The bridging is rolled back on error */
-	if (err) {
-		dsa_port_bridge_flags(dp, 0);
+	if (err)
 		dp->bridge_dev = NULL;
-	}
 
 	return err;
 }
@@ -172,9 +165,6 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
-	/* Port is leaving the bridge, disable flooding */
-	dsa_port_bridge_flags(dp, 0);
-
 	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
 	 */
-- 
2.25.1

