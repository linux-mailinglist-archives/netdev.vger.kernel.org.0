Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647E5343001
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCTWgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhCTWf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64403C061574;
        Sat, 20 Mar 2021 15:35:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id j3so14928294edp.11;
        Sat, 20 Mar 2021 15:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UUgWwEswye+b4aK+2bQLBIyYwXBiDuUTJA+VOwNWdDg=;
        b=PDRmZMcSgapKHhYZ7/XzOm2AZoQBVGGqPPm+7Men9VPsp3L4NRNrAbOfhffpStXFgF
         ao31aEDiX4VkFAfJAVaYu/IJD5jhNxWXkoD274Wte4ccHVA14P3+2KZNA5je7plX9L2y
         Fetf4eoAmR8/O2PwdyOr+/DElxS6irjZh7y1UrtzcVbVxLfax3PI15q7wPvjfpzLos6R
         NKFQ/F7R4hX4w8Rl/2vcBI6vtX0zomXt8tyRjq4NVv2K1sLU7QVeClPV6mgqoUM46e5W
         NHh8/mvaWbzajoQAbWUvVVRK7LuAI+xcfY1p1ks0blYVBky5z12vb889cPlgCXEHWsnb
         eYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UUgWwEswye+b4aK+2bQLBIyYwXBiDuUTJA+VOwNWdDg=;
        b=gUK0mZaYuyD5qM5daYTXrxxJ3mgVN5F4zrSIa1vv03j8+/foLWZKHUWICpIyp9Vn1x
         tDjgFd1PMHvIlKyAOFCisxflxU592yGtYb70lWiGdStVmQtuOnmJSiDZvxjXAbQTraO2
         O4C6/3vFLV7zLenjyJ0tHGxXAyOUp2UlvgAvGsMNR/aRoEl0aVhqpflRKRW4i7QA2Sbn
         wZqZQnExxAYOlaa+PDBZZRdJni6PTczKJhs5KrwwTmeOApymTM3KYC+CWv8cXeQX9INj
         OnYa7kBQL3O7sGX5r++poXbOXoq+2T4LAV8mCjJW5//f7Qj+pStizqVz3xLP9/OrOEhx
         fnxw==
X-Gm-Message-State: AOAM5307FJszvozu+lbX3H2zKLlZLWHGdf+ZPjmGUdPdhApt/B1qX0YQ
        n74/jIh7dT5VeKkp1Vc3v7xggE0lz8k=
X-Google-Smtp-Source: ABdhPJxzcRf3pELkQzpNwfHINX/b43Q36CdVMrCXgNpOQfOOUIe31YLIA8EWHOST5LxVIKOS+CgPUg==
X-Received: by 2002:aa7:da46:: with SMTP id w6mr17838479eds.40.1616279727186;
        Sat, 20 Mar 2021 15:35:27 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 06/12] net: dsa: sync multicast router state when joining the bridge
Date:   Sun, 21 Mar 2021 00:34:42 +0200
Message-Id: <20210320223448.2452869-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Make sure that the multicast router setting of the bridge is picked up
correctly by DSA when joining, regardless of whether there are
sandwiched interfaces or not. The SWITCHDEV_ATTR_ID_BRIDGE_MROUTER port
attribute is only emitted from br_mc_router_state_change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

 net/dsa/port.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3f938c253c99..124f8bb21204 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -189,6 +189,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
@@ -212,6 +216,12 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 
 	/* VLAN filtering is handled by dsa_switch_bridge_leave */
+
+	/* Some drivers treat the notification for having a local multicast
+	 * router by allowing multicast to be flooded to the CPU, so we should
+	 * allow this in standalone mode too.
+	 */
+	dsa_port_mrouter(dp->cpu_dp, true, NULL);
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
-- 
2.25.1

