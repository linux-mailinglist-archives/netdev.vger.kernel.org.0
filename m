Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065A2130BCF
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgAFBgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:36:18 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34351 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgAFBen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so48000501wrr.1
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gTh/LlV1TIE15Ze+IGDd/6z1pTVXAITlE2/gRk4mH7Y=;
        b=OnBcWSJglLxhpul7k5A0Tzi2o37gQJLXqN/5FWX41SKthmuj9aIWYI77lG8ZjdCTlQ
         tdwPIyp9pUJls/T7yYyCOIkOWcmWvbu9STKABN1B52sjOUlRdJRMr2AZUGOKgCEQ9Gzn
         a+pAIhpXwZ1HuCyGkIZfTB8cRVNCaIJWXGuRLX+Pk2GTnzERgQTla7PFtVDvMAEt/hFN
         5Xn3liwwKYwDuDaHu8X1XqrVna0kF9mV37HJGnmNVcUgczs4P4k3xbMUPGcsdzn33WyS
         WkeXbyq7hqwFAIgZ/b6WS4IbKLKqIynt7QgIxbLZIbgVVt3OnFhiPdxxMj9CZytWlxXU
         SXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gTh/LlV1TIE15Ze+IGDd/6z1pTVXAITlE2/gRk4mH7Y=;
        b=auFx2cZx5irWge0OEoGV9DY5G2IdFI5C9xW02w+yf+nd9hCoAq+KmDFVGaktE1Iu6J
         ELmCLepVE4/coAU/E712G4vzPvqYGIAmv64eRva+p39w3qIb/4l/cZBZashx8h+Pue0U
         yhNpTX7EhYDrmREdvBIOEYMW9H1NyOQ7nmIBifQQB+Zo+Lfj+BmWh7Em5aRa+harGnwx
         kF1qxrxvm9wKpdXX+8s5YnVzW0FmzNpwcJyJDFXdUCm9XTwj1XVt2uNx9CayO58tEYJU
         66QQcXoSb0PqyfYAwTHJdv19VVSR4x+BGPhzHJyRXzs1DjthdBtqsqtfqxsc1g8laF7o
         QEmA==
X-Gm-Message-State: APjAAAXTYwC/6IE7HYqVP8GD4YnHjK4DrkroWqChw4HiRyvZOI5T7wvV
        pyAap8C6C9oVrAo3NcSsNvA=
X-Google-Smtp-Source: APXvYqx45Uuw5evy9K62m6QwLkZ4bjHyTEP8PlPNmYphBORa9aRIu8R2VUphr6H8/jiH9YbGJTCXCQ==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr103423008wrh.371.1578274481731;
        Sun, 05 Jan 2020 17:34:41 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 8/9] net: mscc: ocelot: export ANA, DEV and QSYS registers to include/soc/mscc
Date:   Mon,  6 Jan 2020 03:34:16 +0200
Message-Id: <20200106013417.12154-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106013417.12154-1-olteanv@gmail.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
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
Changes in v5:
- None.

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

