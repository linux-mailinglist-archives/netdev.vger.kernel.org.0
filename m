Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98AA46623
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfFNRtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:49:36 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42582 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfFNRtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:49:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id b18so2201002qkc.9;
        Fri, 14 Jun 2019 10:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wRAhZhrLfLhhdV/Rq1dlOYLTb1hbSAlGeDPpuNAv19w=;
        b=WYN27ktBEvZ17pvuTBeb8VPMh14T/DwYMafCxoLupBFHzYclpiMQ3kEY9pYz+v+rce
         rQUojwVQpkHhE2h3N+cErrXj1XcpssfhEunAR7KYq4R67IVm06h9ypkWFMg7LJAtaMGt
         z9unkhSBrF61q4BDu8Tn3fNv77e1Cwq/XM8J4HL1czm4IE83W2y9HVC4yb0GSrVNEeDk
         39BtBWqXOeEF/4g5fpfJw5LNbJqQ6tC/RJak/5CJJ1tDiOYyheXWuisS8+aPUUu2H95K
         z8U0LnK32oA2MmCp5CrjXHco0wKMPof7FpABTsPEBBEIc58CC/cnmimUb9eHSJAHmRYW
         OgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wRAhZhrLfLhhdV/Rq1dlOYLTb1hbSAlGeDPpuNAv19w=;
        b=rVHuGS+2IrUnWNph9NmVshTNAitJGkNhGnoXDVqYVNqA0PfIZ5FvPKaRUINTC9ZYld
         m3zCcjHBJTexZXYTHac14s+Ri2dej92Yy1KPK/bcOXaI1mJMGyI/oXgVqf2/uqxx6/n/
         vlnGaS6zX4cICuLQvWvL0w88bElVJW4+R9wka3M1mgUkE1YdZHZTsyu9hU5zmuKpmK+f
         JeCAEhP0B7NXyXkx8V12hoYZFQf0+HJ7s5YfBCnvRujvD4POMkLD3gbiukSnbUwfjlTf
         8KNIWB/bjr3dFjD/XJ/U6YJO7yqF96irrokcl1BAH71ae5XF+oToUIYGahkjsaSMzeDt
         XVmw==
X-Gm-Message-State: APjAAAXXcopddsC0Uci6dDJF61zWrcqAf+H8A/a1qeZuYBExdMtF+KP7
        BccsnLMWf4OjGUe/hHiFVfkhCwcDjIo=
X-Google-Smtp-Source: APXvYqyn694Htit39U1sPkMzwhGTOKbQfkn8EbEZCaIKSU9wfrjy0WdUQ2SVGfYw9QS5ZKOEwrDR/Q==
X-Received: by 2002:ae9:e842:: with SMTP id a63mr74198002qkg.143.1560534574016;
        Fri, 14 Jun 2019 10:49:34 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id h26sm2751888qta.58.2019.06.14.10.49.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 10:49:33 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next v2 3/4] net: dsa: make dsa_slave_dev_check use const
Date:   Fri, 14 Jun 2019 13:49:21 -0400
Message-Id: <20190614174922.2590-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614174922.2590-1-vivien.didelot@gmail.com>
References: <20190614174922.2590-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switchdev handle helpers make use of a device checking helper
requiring a const net_device. Make dsa_slave_dev_check compliant
to this.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 289a6aa4b51c..cb436a05c9a8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -22,7 +22,7 @@
 
 #include "dsa_priv.h"
 
-static bool dsa_slave_dev_check(struct net_device *dev);
+static bool dsa_slave_dev_check(const struct net_device *dev);
 
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
@@ -1408,7 +1408,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	free_netdev(slave_dev);
 }
 
-static bool dsa_slave_dev_check(struct net_device *dev)
+static bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
 }
-- 
2.21.0

