Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A60F8FE1
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfKLMpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:45:07 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35372 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfKLMox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:53 -0500
Received: by mail-wm1-f67.google.com with SMTP id 8so2829453wmo.0
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zwoRpnw7BYLIDi5PWw+P04IckXZv8MVK51DwfIh7onc=;
        b=udGt1a3E7oWJXaULqj/LQMvl0+1ODfOjFpj8yecafnVIYN3BkLW6/VKm43aBEg7w1x
         +xJamSTqJkoUqCz511sY9z8WXvSZGhGfP5Qdvqq2k7w/0K9RgoBy+33R0lyBOw31SsYx
         6mdWJH0qMQNWKMPy8/BdOlrWVII6sS4Wr4vKZCCOoJrzrt8teUE2SjZWFCCqzWiW2h+O
         WGpfZrzNRan3PfbiopT0J300PvirVM1lDXsYAaJvaefb+svNA4nLY7BP22ozx4y/1dqP
         jafSEUHZFUFicQnR+LKW/cZSYS5prHGyts3Q/DwaxLmem3rPOR5GtKH+o1NuF4kuy+wl
         BpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zwoRpnw7BYLIDi5PWw+P04IckXZv8MVK51DwfIh7onc=;
        b=uNWKXxw4vNf7tWXdpmWOC57DSYNrtoOcUHpktHj48FH8jNvcSo0/Jg8zTNuGsoHbGs
         hnUJkyhjc349lZyub/f8jbynS0ZWgvdwa4IOXaGmwF66sUU+wIArJvoLxHxXIHrswJLX
         NvKLDRMKk7iQ/sNb433fs7adYyzwrmauCtRqmrsUpyFYzrRrxE3uCciNTDt0cItYXNMp
         F72cuKE2ky2XAnM3q4PLBhRHyLDadiClkfU9zrHsZFSQei3Xz8C42vWQzyZFnp+9SSPo
         rtT3gcS6bvynlyW6QwPkRSFAFNKLku1Zk05CooUGu2SpqDDT7XKnHU8dLcnx8mUy8Zog
         q9Gw==
X-Gm-Message-State: APjAAAWmvlnEDycArte4pNCrc5D/SeizcfFYN8nDLqaIS24siEPGZJuA
        JYHRQbAQXCjtyW5TPMlHjJU=
X-Google-Smtp-Source: APXvYqxFNWbNtQbhCqYCJBUXP2Ed5k3nD2GPJb3gmUfYKLy73zQyAcoer7r1zJLfvhJYbJE5UJe9fQ==
X-Received: by 2002:a1c:a556:: with SMTP id o83mr3609342wme.165.1573562691061;
        Tue, 12 Nov 2019 04:44:51 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:50 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 09/12] net: mscc: ocelot: publish ocelot_sys.h to include/soc/mscc
Date:   Tue, 12 Nov 2019 14:44:17 +0200
Message-Id: <20191112124420.6225-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Felix DSA driver needs to write to SYS_RAM_INIT_RAM_INIT for its own
chip initialization process.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.h                      | 2 +-
 {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h (100%)

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

