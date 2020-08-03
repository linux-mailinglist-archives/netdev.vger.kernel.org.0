Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1A623ADEC
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgHCUEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbgHCUEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:04:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C49C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:04:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o5so2695389pgb.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CSseXwXnluq7t5g5Wz8yrvikyKfhawFC9+F/2pv8ZFg=;
        b=aCgsaSY3ChwkzckfsxeXRowR9n6wmc//OdxxNf9aLB40/AkFI3pJHLEq8RHqC6dw04
         iD6c4pKEirUDr3J9AJVPDdzPy7JL9qLzqQNSjNryYYeddM8sU9TymNLslICLUTpwWWS+
         X8ICBkrXfVGtMBv2eBTiELZwHMTyVWlwtGmsBR2E0eThEiEgzkEco91Pxe4QMzYx8x9J
         YMK6rRJ3Z9E8kndRep3NaI556UJ02AV+qP5zS+PglY3JQytyvJv5hd+v4qShKZzImlYD
         06sPtybhpJlZ93aDXgTlzJm4YS62wSb+ZfvgU5acrmDebeiXSjDtSNoEgL/osqhROYAz
         1gCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CSseXwXnluq7t5g5Wz8yrvikyKfhawFC9+F/2pv8ZFg=;
        b=LR6uWkxKGonEGdCbBxcrcwQp5zf+Mp4kq/4SqfkpibThmAfDrNmDSWrKzvUBCV8Bdm
         mp0WfdvVySW7MTMlvzrGKXiYgDvk2rixNGz1vwcbCaPQZLqEKdjfrSGTytxP/CcOd7fr
         2f2q699lR71Pr55bORiLz+Ify22QyWh8zXv4xpQqXMthB083pSCQwnMXQfCVBub7VrGX
         A5WeQv/1h1YCWdjlhgtKvuA7Uob2dmNQbLQknvJ02Crh/7+ez1b8FoCd8uY4nOea8rlS
         vRs8hrVZX/LrugV53s3uw44vQRoqJlnYKkM8M347hYnPyznPagF58MtKBbGGmEYkV+0R
         ZTxg==
X-Gm-Message-State: AOAM532oAv8Dc4NzXRzP/W/bkphjMQ31EEgDN8y9xUifjUBGM0dizHwb
        bnfTUzlMajAxf2+JJD4Nl4GYJBCu
X-Google-Smtp-Source: ABdhPJzngm4Wq6hpyfjOXtf0pbBQ6TlOcmu66idBMfVAmJtcmCDNjldkLpJ1Do0HDDt49ANGqFGyGg==
X-Received: by 2002:a63:6dc2:: with SMTP id i185mr15005648pgc.104.1596485039429;
        Mon, 03 Aug 2020 13:03:59 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u24sm20017521pfm.211.2020.08.03.13.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:03:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/5] net: dsa: loop: PVID should be per-port
Date:   Mon,  3 Aug 2020 13:03:50 -0700
Message-Id: <20200803200354.45062-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803200354.45062-1-f.fainelli@gmail.com>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PVID should be per-port, this is a preliminary change to support a
802.1Q data path in the driver.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index f8bc85a6e670..4a57238cdfd8 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -45,6 +45,7 @@ static struct dsa_loop_mib_entry dsa_loop_mibs[] = {
 
 struct dsa_loop_port {
 	struct dsa_loop_mib_entry mib[__DSA_LOOP_CNT_MAX];
+	u16 pvid;
 };
 
 #define DSA_LOOP_VLANS	5
@@ -55,7 +56,6 @@ struct dsa_loop_priv {
 	struct dsa_loop_vlan vlans[DSA_LOOP_VLANS];
 	struct net_device *netdev;
 	struct dsa_loop_port ports[DSA_MAX_PORTS];
-	u16 pvid;
 };
 
 static struct phy_device *phydevs[PHY_MAX_ADDR];
@@ -224,7 +224,7 @@ static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 
 	if (pvid)
-		ps->pvid = vid;
+		ps->ports[port].pvid = vid;
 }
 
 static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
@@ -234,7 +234,7 @@ static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
 	struct dsa_loop_priv *ps = ds->priv;
 	struct mii_bus *bus = ps->bus;
 	struct dsa_loop_vlan *vl;
-	u16 vid, pvid = ps->pvid;
+	u16 vid, pvid = ps->ports[port].pvid;
 
 	/* Just do a sleeping operation to make lockdep checks effective */
 	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
@@ -252,7 +252,7 @@ static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
 		dev_dbg(ds->dev, "%s: port: %d vlan: %d, %stagged, pvid: %d\n",
 			__func__, port, vid, untagged ? "un" : "", pvid);
 	}
-	ps->pvid = pvid;
+	ps->ports[port].pvid = pvid;
 
 	return 0;
 }
-- 
2.25.1

