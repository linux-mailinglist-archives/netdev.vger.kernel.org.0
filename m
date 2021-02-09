Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2E3152B0
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhBIPXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbhBIPVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:21:13 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0DDC0617A7;
        Tue,  9 Feb 2021 07:20:04 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id f14so32209912ejc.8;
        Tue, 09 Feb 2021 07:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=33/uyGIN3FY3+rBdv4FUVUP8dhmUMuazcIsOv+i6Gos=;
        b=Jze5auyHPDoC6rfV73gY30Hp1USjjzyfk4eUjoUSm/ZtmJUo0//B9gg5YM1xmx4SGA
         m94yMWYIaoLHQTuURAvVTDpiYHPvDU77il0aNvTjxzRWzpLI3MLnPLZQ49Dn6FDU1YMO
         WCid8yzpagqm6Y7xzh0cHgqLG8Ql5cImK1tQemFDvTKZDl+e9Sk7XVRbfd0+5tuSAy/p
         evF3lWgG/HM/6d/Wdq8YDdLeGNrSErN5MGA0MjwtHrP+Hnljy04hYROZEUD7slwsoc0q
         4LVZ2xKfV1sdpKkuFDA16wmfRF40pE0B8XEdTIEommbKbT94DQTO6GYAR1r0cixMb4mO
         xJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=33/uyGIN3FY3+rBdv4FUVUP8dhmUMuazcIsOv+i6Gos=;
        b=jGfvSZaiLb3kymxyuKSzchO27/YXg2BccCAzJhdeDrjuj/elHLxh1EBmardRgDCUMo
         Jk9WHUjpfy/T9o+65mkupJcIUhOF7A9mfpfdHqX4REr6aufF7J9N5kZE7C672zI+idGG
         3xrWWNPBYsQkv8ht6eESoxmMmgCMekRcGmu2wT5bbMYNvg0FLUkAQsUiqi+2h9h02QuO
         xx3AkXUbP1QHmaEdoYJ2rn0aZVGXXjaPuVjoc3Mrpe3jxTU/p88gnYExcMCc6keVnGpH
         QKSvnmo5RbbzpSC68q7uB859Aj+JmN5ceNrOVieHHSk78306HqO3JySl9IIOcfKFTRWq
         ESzQ==
X-Gm-Message-State: AOAM530O4NBZB3YeVekB8aiMQrTTDIn/jAjrEpaKanHe2vy2V1DjuPgf
        Lw/wKqabWQTGCdzvwv4Kw0w=
X-Google-Smtp-Source: ABdhPJwHMb8dV//9wzvmRBUxMtLkeULCNCUPZ7qXpiVjPoOKJDet9k5bhYqeP5+XbWGve9rt9ntjYg==
X-Received: by 2002:a17:906:364b:: with SMTP id r11mr22773043ejb.447.1612884003462;
        Tue, 09 Feb 2021 07:20:03 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:20:01 -0800 (PST)
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
Subject: [PATCH v2 net-next 08/11] net: bridge: put SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS on the blocking call chain
Date:   Tue,  9 Feb 2021 17:19:33 +0200
Message-Id: <20210209151936.97382-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that br_switchdev_set_port_flag is never called from under br->lock,
it runs in sleepable context.

All switchdev drivers handle SWITCHDEV_PORT_ATTR_SET as both blocking
and atomic, so no changes are needed on that front.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 net/bridge/br_switchdev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index bc63b10b2e67..3b152f2cd9b5 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -79,9 +79,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	attr.u.brport_flags.val = flags;
 	attr.u.brport_flags.mask = mask;
 
-	/* We run from atomic context here */
-	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
-				       &info.info, extack);
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
+						&info.info, extack);
 	err = notifier_to_errno(err);
 	if (err == -EOPNOTSUPP)
 		return 0;
-- 
2.25.1

