Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9F2FC978
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKNPE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37231 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfKNPEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id t1so6857527wrv.4
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T49MobWH9NfcTlIPsIH+m8wuOKBBNX39cOTFiITphAQ=;
        b=X9lgku/RXNzoQgBfw5MzdF0cWGO71NHgOKtA7+kyl2nHJxEq/psMSmFKKxixAAhJo2
         7bcXtLQAM8bbjmvF0CPnX17ZySfkUPM+IxMq/T5iSw6m++X7uJXVrqHa5cXp+5DDz04s
         8EoNnupNJnhGxWgEWiqanvSFmob38Koqi7uj14RdISVjY1MLYZb/qiXrmpuceIAMmAKn
         mWSY5Akf+c7W3t65+/aAKO9zowxyJVAwrT/2cpnoLXUGCkzDWXhDw4zg0J2UOxiz6RSv
         IKDXYooeq1SIM+ESSxALhS/MZo0RCefDW99etYG9EDUDqe8fkAPnqISdN0aBQq+vj46u
         7N8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T49MobWH9NfcTlIPsIH+m8wuOKBBNX39cOTFiITphAQ=;
        b=M7SXpX6gKWLn/j7cRaXuvUm6XSqBWvgCcS3MvNP6blbw1lVbTDnUnVK3uDXG5qNZu5
         V4PJtg/q6XqtBQ78aMaS6di8UfSOkTQujLNydtvb+1lG7Ih5d24FcETrSYCD4AMjOK+8
         PV23IY6pNaf+UTAr4TVP5KG+/igDluLxZN+335AL7U7wRLJRbLMgewc4dEvsun1V40UW
         dpvxUn0nTDds8WpETQ6H38Wjhaur71A7lZ7vgNjb13Drn88DaKbJWVRweyq9d+2yGi4c
         HBvROJYEXsBy+aG+bLwBLe1QQwas0m8C4i1ityf3F5bMxe1iWqznmXra5E/u7aUKnaZE
         Tr4A==
X-Gm-Message-State: APjAAAWYT1XbH1C8ct9CYC2/IPh7ubsADD/XotSyaVhZh6d3HsyXSTx4
        trlgfoTLCdrcetaXD6/IJOM=
X-Google-Smtp-Source: APXvYqw0w2IBY+44ayw1xTExaUlS3HBtAq8eimQAIvpEQT06AGS0J51Farhxg3KLAkbSAX39jF4Gtw==
X-Received: by 2002:adf:ea0a:: with SMTP id q10mr6919366wrm.275.1573743863872;
        Thu, 14 Nov 2019 07:04:23 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:23 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 09/11] net: mscc: ocelot: publish ocelot_sys.h to include/soc/mscc
Date:   Thu, 14 Nov 2019 17:03:28 +0200
Message-Id: <20191114150330.25856-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Felix DSA driver needs to write to SYS_RAM_INIT_RAM_INIT for its own
chip initialization process.

Also update the MAINTAINERS file such that the headers exported by the
ocelot driver are under the same maintainers' umbrella as the driver
itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Updated the MAINTAINERS file, and noted this fact in the commit message.

 MAINTAINERS                                             | 1 +
 drivers/net/ethernet/mscc/ocelot.h                      | 2 +-
 {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h | 0
 3 files changed, 2 insertions(+), 1 deletion(-)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e57fc1d9962..d09a3205da37 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10834,6 +10834,7 @@ M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/mscc/
+F:	include/soc/mscc/ocelot*
 
 MICROSOFT SURFACE PRO 3 BUTTON DRIVER
 M:	Chen Yu <yu.c.chen@intel.com>
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 325afea3e846..32fef4f495aa 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -18,12 +18,12 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/regmap.h>
 
+#include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
 #include "ocelot_ana.h"
 #include "ocelot_dev.h"
 #include "ocelot_qsys.h"
 #include "ocelot_rew.h"
-#include "ocelot_sys.h"
 #include "ocelot_qs.h"
 #include "ocelot_tc.h"
 #include "ocelot_ptp.h"
diff --git a/drivers/net/ethernet/mscc/ocelot_sys.h b/include/soc/mscc/ocelot_sys.h
similarity index 100%
rename from drivers/net/ethernet/mscc/ocelot_sys.h
rename to include/soc/mscc/ocelot_sys.h
-- 
2.17.1

