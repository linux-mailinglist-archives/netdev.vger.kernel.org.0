Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5FD1E51EB
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgE0Xld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgE0Xl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:27 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05185C08C5C2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:27 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g9so21695757edw.10
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39Zfhc5/utA8zqF4sGnSYNxaMX4nI5zGv/u+8jITviY=;
        b=fLB6xO3+BZrClCS1e2yz+tJKHm9ncEaLIkOmdWVEJMQ3y4/gNdguphVCf+gh+e1j5Z
         gkm/RvAjupRd5ecPu/u3O8AmKpMQcniCK7dvPVVl5vnZxMhKxs2k3sLCZPg41zmy4I2s
         KcRyrnH8MP9+dYemFEjBi7f29YudxJf7r9GHOXXTSN4WpEGSL7dhYGFWJX9iKkRAEvRG
         BPpELh/HhJZYsknSc/wLBd+jNiCgR2atXFkvSmwtdJL1GTfOVqeiWriEBmz8K7KKmAa4
         cyCCjBODj/VRcAQKaLuFcUypj9iC7ur15sNbzSCzhtY2TPY9FEoGhaLCVmR8SJdvl/73
         9CHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39Zfhc5/utA8zqF4sGnSYNxaMX4nI5zGv/u+8jITviY=;
        b=dQcGMWdjKt84OjFflckDe8axkedPXpMe8SoKsbf+umJmZ0QMTP+QbDSK3Nrp6YiTHG
         Wov/sTmA3cVmBtApnC9TzzGkPRBT9Au/KdhS2AWnl3GBDA/ec6y5cF4nCb7Ti8x9mlv5
         KZPw9z1c2wSkc/JXCZDoBazRkVMPX6uJri6WMmfXPveDV1sAxWyegygyOrL3UjdowHzr
         UazWFyMYrqftI8/K8W/JULeHMzNrvdx4KvmvJUQxN8yjtTWTTpk+1QhfpF/NNnxG0G17
         LP8vZdLK0ZOQ669LPsX3dXFUzfmbYNE/nP1F85psG1lO8oOh5y8Nsg1bilgcEX8lDYlA
         e1AA==
X-Gm-Message-State: AOAM5339/Some5xkXF622YicirW+c0JnBNcc6avII79NPEcOulTDLleL
        sQM7mJ+/ydAc2ePRw7RnGoQ=
X-Google-Smtp-Source: ABdhPJzO8oDb8BCds346VIgrSKiwKQfEUmVHSRXZQUNcUPOcIFDLXoRhUsjQ3PrsWVMQd8y16GZLkA==
X-Received: by 2002:a05:6402:719:: with SMTP id w25mr490093edx.179.1590622885774;
        Wed, 27 May 2020 16:41:25 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 02/11] net: mscc: ocelot: unexport ocelot_probe_port
Date:   Thu, 28 May 2020 02:41:04 +0300
Message-Id: <20200527234113.2491988-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is not being used by any other module except ocelot (i.e. felix
does not use it). So remove the EXPORT_SYMBOL.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e621c4c3ee86..ff875c2f1d46 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2152,7 +2152,6 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 
 	return err;
 }
-EXPORT_SYMBOL(ocelot_probe_port);
 
 /* Configure and enable the CPU port module, which is a set of queues.
  * If @npi contains a valid port index, the CPU port module is connected
-- 
2.25.1

