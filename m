Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9472EBBE5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbhAFJwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbhAFJwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:52:50 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B66C061359;
        Wed,  6 Jan 2021 01:52:10 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lt17so4279998ejb.3;
        Wed, 06 Jan 2021 01:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oyqqq/X9qdu3xx65zVGG4PWH/PNLT4F1km7kqg9CwhU=;
        b=gzddoHJOCVay1ZtwAg6gpZYehIhSRqUIQSdK4JUH+wPjfbt4c780257hgbJRUZZ0ZC
         i9KHrBmIsFtgQvFjDsTf2XoSa4rJGVoyx/WKywr3FvG1ot0/gXU9nB+lWK6l+aFqxR0R
         LvcGmC+ZWUIbjKMYyuMmV6a7Ur40nOQSw/CVGIrtgjg778xGuFveUJfmadVczelFyf0W
         M/0XtJ4D4x2wgj7yI+dTV5HRtqEtO410+bkvou21VP4UP767x4tRzG2mSrouCS+UN7Ic
         7yhz8MtN27k2KQwgU83zQiyXSq13jEdR2prrmCrKgp+BkOJML+CaYOOFNa/sWxQJ5igr
         0HvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oyqqq/X9qdu3xx65zVGG4PWH/PNLT4F1km7kqg9CwhU=;
        b=K/s8h7TXHjbnBNbOzkq24YfU2iunsLSRrB6KOXlz7hy5rYSQ6c3PTu4Ix4OwXUGTxw
         eTcWK7bYOW3/ScGhPSGp/nV3RgyycyYqMtaxip7Uuw9uaeHV/ON+zEstsi816ZnQsd5+
         oBnsIjsDEmhcq53jZIJ4YIET0tO+jXbO+J8U4HyAJ4CNzHpm6MKm38giySURFwlkURtc
         R7l3pN2jscphi2xfzNYXtGmjsM4pWb2a4oNbJGI9Vtm7wGD8Ff4fopNwoDd3svMPPFRI
         E+ESb7T7dI0TqWSTN8k3NC7T3acMWe0PAz86FGhvqwibo/8ynTWitJoVcnAhEd5OV4vE
         3OUQ==
X-Gm-Message-State: AOAM5326clLf2/cumM3lROizvqkdf4cGtTjwQ8x5+JMGSQmg+SpGTgyd
        h/v93sUaRSelgBvlcQryf7k=
X-Google-Smtp-Source: ABdhPJzq0FCe5EV/63tubiMzkQ44Wkkk+QVgy3AIICkXzaUOGz8TCuIvKt45D+hHVgZ5EO/NiUKvjg==
X-Received: by 2002:a17:906:118c:: with SMTP id n12mr2377284eja.167.1609926729109;
        Wed, 06 Jan 2021 01:52:09 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n8sm1019587eju.33.2021.01.06.01.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 01:52:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 2/7] net: dsa: be louder when a non-legacy FDB operation fails
Date:   Wed,  6 Jan 2021 11:51:31 +0200
Message-Id: <20210106095136.224739-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106095136.224739-1-olteanv@gmail.com>
References: <20210106095136.224739-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dev_close() call was added in commit c9eb3e0f8701 ("net: dsa: Add
support for learning FDB through notification") "to indicate inconsistent
situation" when we could not delete an FDB entry from the port.

bridge fdb del d8:58:d7:00:ca:6d dev swp0 self master

It is a bit drastic and at the same time not helpful if the above fails
to only print with netdev_dbg log level, but on the other hand to bring
the interface down.

So increase the verbosity of the error message, and drop dev_close().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
None.

Changes in v3:
Patch is new.

 net/dsa/slave.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..d5d389300124 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2072,7 +2072,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		err = dsa_port_fdb_add(dp, fdb_info->addr, fdb_info->vid);
 		if (err) {
-			netdev_dbg(dev, "fdb add failed err=%d\n", err);
+			netdev_err(dev,
+				   "failed to add %pM vid %d to fdb: %d\n",
+				   fdb_info->addr, fdb_info->vid, err);
 			break;
 		}
 		fdb_info->offloaded = true;
@@ -2087,9 +2089,11 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
 		if (err) {
-			netdev_dbg(dev, "fdb del failed err=%d\n", err);
-			dev_close(dev);
+			netdev_err(dev,
+				   "failed to delete %pM vid %d from fdb: %d\n",
+				   fdb_info->addr, fdb_info->vid, err);
 		}
+
 		break;
 	}
 	rtnl_unlock();
-- 
2.25.1

