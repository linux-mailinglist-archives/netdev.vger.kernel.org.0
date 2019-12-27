Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0A12BB59
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfL0VhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:37:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46559 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfL0VhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:37:03 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so27211087wrl.13
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Re3b0bz8lr1F2HpvCJp0ubBbAeK4gIrOKlD0QBAZeew=;
        b=l+wpcdNfbbP+CmijzBeZysK/ec34EeiIf2H09jZY5/HD6opy5RyVVUVtuwePSdJo59
         SfbgdgxYErgnsWZFRdvppOyI58ueCNwMoHsfA86rOjXHh1Acz2GIEgPJkxtIpVbjqrak
         eP/HcNcyC5bN2sDe0x2qFoiElMOpUeffKXFYXl6nSx6VWQo87yKR5bxobRjbfdWgJScP
         XTNme9PMi1T954BU/mpl26uFvqYlLJ0xFge2RudMqaLEmHWtS533RpYF67ws9ShZr9eD
         2OYmk3r28furj/Pk8fjHBci+VNGDiCuTdT5cSjwU2iPiVgdppFbl2PiSzIZ6lD8aG6d1
         f7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Re3b0bz8lr1F2HpvCJp0ubBbAeK4gIrOKlD0QBAZeew=;
        b=J0V1ddGZodbVAN6YKLvX+cFhaQYoOn/7C59U9IWhIZ5Uj1AQ6zPOc+avXLswV4q3Rs
         lsNZJcTwUNg6zIK0MMsZIG45h1KIWKAW61YAeUIoCSiuz5zqdFvHRuNOys0l93vw9ly7
         UDSWWKbAqJUTPEUpymRcdCX4sAcsrSrB8+VMPFAUDd0a1wjVZAePnIFNSRimA5O7cign
         up0W3JDuTQcRFAI1XaubtuSs4T6KTO8a9H7uX20RrG6I+CQxcUFTlgdhwUmoU/3i3G3Y
         /VmPVlaja1ZlgGw257tiGhobEVtFYGte6bbkuOt9hYS/JcO44QwVm8KfJzSKtxyi+c7i
         tRWg==
X-Gm-Message-State: APjAAAWp/rOWuuN2gRC7KzS++C0ErsF8XL1Q0UAjQbHc5x0yph/jp2nb
        w40/Ra0rkXzleLIH2uKdAjI=
X-Google-Smtp-Source: APXvYqxMF2faVgGV5yQVD2LuQiKSteC10Il9F01sFwgC5J1hKkOfe/w5UgUKvHhGrfiFdHE8wCgNTQ==
X-Received: by 2002:a5d:62d0:: with SMTP id o16mr51190570wrv.197.1577482622153;
        Fri, 27 Dec 2019 13:37:02 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:37:01 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 10/11] net: mscc: ocelot: export ANA, DEV and QSYS registers to include/soc/mscc
Date:   Fri, 27 Dec 2019 23:36:25 +0200
Message-Id: <20191227213626.4404-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
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

