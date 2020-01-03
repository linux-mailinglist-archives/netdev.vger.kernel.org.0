Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049F112FD63
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgACUCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:02:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36875 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbgACUB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:01:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so9582053wmf.2
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 12:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gOyWZHwWigvTYV6cjaZTxMUtX51yoCmVNOlPeIgPDrg=;
        b=Fa1Tf4p3tr6tUbl1jBemiqp4wqdi0po2K/RRuHK3223mh8s510FVnTHU/2OIhbcXFy
         R68qkOBUf2+f/s96We8jwD2qyts/wPDo/b7shLPbssqIUFYAsbw3q+eLdeGMfoNlF6hu
         wrQD2R73H/s/QM7CUtpStzGYUxaI70+2YmOlNH13xWO3eXvanlBy8+RiMA1pIrHH5yaM
         Xk33m8VylgJI/dTQrflEgplzB2ziHac025w9sw/aGqmX1YGNIaTadzofgEEnLH02inLH
         GrmY10eyr/nJUIeE7vL5UymXvB/e+J4cgfzmG30fAIoBo1ic0+yJd7blZuBXtzs4NTnw
         VHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gOyWZHwWigvTYV6cjaZTxMUtX51yoCmVNOlPeIgPDrg=;
        b=kUvjkz2mRAJfbbiZSjWFwXi76Hh0xh2uoUGJ6gXtGrIgvDO20CfPKr+1bh9gOuHke/
         fTZgN0UfR6YV6Fxj8eR556OGZl7n7mRzRpF+1pZu3aIMI0Vo/BeeT/nj3VwTSgUSiKnF
         ZydPA+I5qE21nRWnLc7V0l6e8eZ6+pADuX0tgz9jr1rvw/DRplMWJ3ql2zffshbhvf9p
         S4u36BhgxXM/JhcfbLTyzwShuU58yZsxyz8uKwKmL22ZUlm6N20ZFerijg9GyJaSroWE
         GBV7yaNj6bsPa+50Rc69YlOeAjmQzvRkhRgx69VHJ4eTuDVvVKOY1tWUDHYvtgUYay6I
         CdyQ==
X-Gm-Message-State: APjAAAU3GwSwps7x6oDro1gyRZmMgdbgwkeeDk2OWL/yB7hUkY9KyrnO
        aDekX5JQMCgsVsD6Y0qaih0=
X-Google-Smtp-Source: APXvYqz1Oc2TC30gdhDBSyLa2Fe7ybv4FmqRA9cKxy89kihSbnGsxaWQVoqixDQIWhZJzgDWJZqk3A==
X-Received: by 2002:a7b:c444:: with SMTP id l4mr20541305wmi.178.1578081715662;
        Fri, 03 Jan 2020 12:01:55 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e12sm60998154wrn.56.2020.01.03.12.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:01:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 8/9] net: mscc: ocelot: export ANA, DEV and QSYS registers to include/soc/mscc
Date:   Fri,  3 Jan 2020 22:01:26 +0200
Message-Id: <20200103200127.6331-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the Felix DSA driver is implementing its own PHYLINK instance due
to SoC differences, it needs access to the few registers that are
common, mainly for flow control.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
- None.

Changes in v3:
- None.

 drivers/net/ethernet/mscc/ocelot.h                       | 6 +++---
 {drivers/net/ethernet => include/soc}/mscc/ocelot_ana.h  | 0
 {drivers/net/ethernet => include/soc}/mscc/ocelot_dev.h  | 0
 {drivers/net/ethernet => include/soc}/mscc/ocelot_qsys.h | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_ana.h (100%)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_dev.h (100%)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_qsys.h (100%)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 7b77d44ed7cf..04372ba72fec 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -18,11 +18,11 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/regmap.h>
 
+#include <soc/mscc/ocelot_qsys.h>
 #include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot.h>
-#include "ocelot_ana.h"
-#include "ocelot_dev.h"
-#include "ocelot_qsys.h"
 #include "ocelot_rew.h"
 #include "ocelot_qs.h"
 #include "ocelot_tc.h"
diff --git a/drivers/net/ethernet/mscc/ocelot_ana.h b/include/soc/mscc/ocelot_ana.h
similarity index 100%
rename from drivers/net/ethernet/mscc/ocelot_ana.h
rename to include/soc/mscc/ocelot_ana.h
diff --git a/drivers/net/ethernet/mscc/ocelot_dev.h b/include/soc/mscc/ocelot_dev.h
similarity index 100%
rename from drivers/net/ethernet/mscc/ocelot_dev.h
rename to include/soc/mscc/ocelot_dev.h
diff --git a/drivers/net/ethernet/mscc/ocelot_qsys.h b/include/soc/mscc/ocelot_qsys.h
similarity index 100%
rename from drivers/net/ethernet/mscc/ocelot_qsys.h
rename to include/soc/mscc/ocelot_qsys.h
-- 
2.17.1

