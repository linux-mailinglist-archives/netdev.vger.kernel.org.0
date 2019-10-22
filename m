Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB706E0B73
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732497AbfJVSbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:31:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34197 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfJVSbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:31:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id k7so8752399pll.1;
        Tue, 22 Oct 2019 11:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PqWdmEQdcmjmFLWvTGjLwPx6VnrOcgWy0kGCVc8BpHs=;
        b=Ba1l/6Dw6t1lnoMAIkJiOq+J0wvmYQt3HrbWxfkZZwJqmgte9pw5puY+Tt/hFyYnuO
         p/RQ20eiVf7492Lv/978INFbuTskGlqwP7+9Lyq5GtztSi6+eC9GIH4a04jB9s8sx7av
         7ZLc0U5W7DySJHpAGeycaVi+yHVUTf88KO7+KGWVE6yRb3On9IWmoZK6mw6/QyQHx/6O
         W5vJppKgGSEbO6Yxq7kENXFnBw+kVNqRqmMUQapgHHd6HRKRuIVV2aTcsoItxhmaiWvJ
         hLVUw1UTXOXT+z1Kk5qTpqTppFVW91Ks6qqPcLPhCJu76FG50wVK/Rb6wmywAZjDi+z/
         C8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PqWdmEQdcmjmFLWvTGjLwPx6VnrOcgWy0kGCVc8BpHs=;
        b=mfmkhgyfYylVst/MB1odNcBa+vcPyBI0t6cxS3aZY45sQBhZGvtvvdlj/GpxJRLUH1
         I8kCiMCNXPNnJ7Mdmhqrs6gSFjsi3nS59/m5REHEzKmLLg7kqq1vbz6m9UdYyZAYMsOb
         QqU8JcAP45rCd8OcwgKj9f7cfVdEXVSL1MaLhFFTV5Ftc1UhbppCJiGtVmENJzZoWU+D
         Cb9mZKqpsNFZVECp/Obe6acmOEUoA9kkfPA0W+feYHUu87Ih/J5qHx8je2XUE+yzTTXs
         NS7Ltd8i8E+OSOJPA2vuUj9h8TTcmIQ83xXfnAxaFZeFcKs0g1nZDVSiEqomMHFIuAuB
         Fn8g==
X-Gm-Message-State: APjAAAWo1ObRQxcFwWmMHSQY8/s3Y38/2uZWfobJmII1TNhxEHjTeCA6
        joBDPtYQ5UBPIEjfdtXCa3Q=
X-Google-Smtp-Source: APXvYqx+EjDcV+i7mxpvdqEU3QZ476yYSpRSo4mPRljkGHInUZyuVnDAxjXmAnuvXtfLdgE96vfwlw==
X-Received: by 2002:a17:902:9a93:: with SMTP id w19mr5033569plp.316.1571769098674;
        Tue, 22 Oct 2019 11:31:38 -0700 (PDT)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com ([2620:10d:c090:200::2398])
        by smtp.gmail.com with ESMTPSA id m19sm16787947pjl.28.2019.10.22.11.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:31:38 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Cc:     Tao Ren <taoren@fb.com>
Subject: [PATCH net-next v10 1/3] net: phy: modify assignment to OR for dev_flags in phy_attach_direct
Date:   Tue, 22 Oct 2019 11:31:06 -0700
Message-Id: <20191022183108.14029-2-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022183108.14029-1-rentao.bupt@gmail.com>
References: <20191022183108.14029-1-rentao.bupt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <taoren@fb.com>

Modify the assignment to OR when dealing with phydev->dev_flags in
phy_attach_direct function, and this is to make sure dev_flags set in
driver's probe callback won't be lost.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
CC: Heiner Kallweit <hkallweit1@gmail.com>
CC: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Tao Ren <taoren@fb.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Changes:
  - nothing is changed in v1-v9: it's given v10 to align with the version
    of patch series.

 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index adb66a2fae18..f1f60bd4865a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1270,7 +1270,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 			phydev_err(phydev, "error creating 'phy_standalone' sysfs entry\n");
 	}
 
-	phydev->dev_flags = flags;
+	phydev->dev_flags |= flags;
 
 	phydev->interface = interface;
 
-- 
2.17.1

