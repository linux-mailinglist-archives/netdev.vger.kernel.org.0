Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C73224835
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 05:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgGRDFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 23:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGRDFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 23:05:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6DBC0619D2;
        Fri, 17 Jul 2020 20:05:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so6270360pfe.5;
        Fri, 17 Jul 2020 20:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QIZiS6mr/TwrYTrY5S1CUMAvOM+aBt0rbCkTcpL/Zk=;
        b=Qw3FHzHNXn53dwXGATc+cgkVQ0VI9JZ8ZvbDf9I+iVAudvjl1sfggEqr4MmaSlsT7F
         F94ds1HwwkGvpBgAFo+XUIN9UWO2gccgCfsiYwon5IWvoXOE3Q6KIlro+vpXHQ2zeQsj
         5juPvYPapZlmonXzIpXlNCXDonFAg9Mx56jIwWFkio5msyFs8DWycsAPAchKmXGFw98j
         UgoezROxrV+2x6blmdVS3qWlkvM5LA1/yCrLwdD2SefhZ9Vxpm00UAArI5sGNDvt/SrT
         hFvR0I4e3PkuURqu6d+1ZnLBRZh/+xnEOGHBq+ZPFDDgYn95WxBbAeFtAFNPuiaolfDZ
         YUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QIZiS6mr/TwrYTrY5S1CUMAvOM+aBt0rbCkTcpL/Zk=;
        b=j4Lq8j1sXEyCitE6dGzKM/W+Jcu6vsswJA8Alq9c1iZVcxlVxgcrBGfH/bLJ5i/fqc
         VaDWaSYRCt9HytM1ZqivOYJs4WL3DHp1A7zFei18bSmw7JZnar4UQs4pRkbM+RmUH+j3
         YIaZjQKjFqrtZq/ZxnHsi6kJ+DvqukNxc/UYbMlbBObOcOSMYFlGT54y4PLlPWOtzBXS
         8Ka211TXHyGUMGZppJTVoSbRI2fE2YHBKd2DBjhIxRysxyarxONWIy5snFbbCrhVvLnU
         9QYHmhAX5oGlnCfSv/JnZkGHhYS4wWJHfU3z/z+L9OdhIaXABnBYoNfR/SFOilSqgwEc
         XNqw==
X-Gm-Message-State: AOAM533+iphVknms4hVRiIEL8B8NbnI+q2p/MJzQ4syDCEFanyY/Rfty
        IEN8HDAA4ekaMwulHUnRM9QGo0z3
X-Google-Smtp-Source: ABdhPJwnpwR5W8DgJX/CzBi2EGq1EyP3rQbR18mIyrgYtccz/GBFcRfOHx52ti+7YeY4qMpn0u8nYA==
X-Received: by 2002:a62:3204:: with SMTP id y4mr10147026pfy.50.1595041545294;
        Fri, 17 Jul 2020 20:05:45 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c9sm617331pjr.35.2020.07.17.20.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 20:05:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/4] net: Wrap ndo_do_ioctl() to prepare for DSA stacked ops
Date:   Fri, 17 Jul 2020 20:05:30 -0700
Message-Id: <20200718030533.171556-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200718030533.171556-1-f.fainelli@gmail.com>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for adding another layer of call into a DSA stacked ops
singleton, wrap the ndo_do_ioctl() call into dev_do_ioctl().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/core/dev_ioctl.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 547b587c1950..a213c703c90a 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -225,6 +225,22 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	return 0;
 }
 
+static int dev_do_ioctl(struct net_device *dev,
+			struct ifreq *ifr, unsigned int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	int err = -EOPNOTSUPP;
+
+	if (ops->ndo_do_ioctl) {
+		if (netif_device_present(dev))
+			err = ops->ndo_do_ioctl(dev, ifr, cmd);
+		else
+			err = -ENODEV;
+	}
+
+	return err;
+}
+
 /*
  *	Perform the SIOCxIFxxx calls, inside rtnl_lock()
  */
@@ -323,13 +339,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 		    cmd == SIOCSHWTSTAMP ||
 		    cmd == SIOCGHWTSTAMP ||
 		    cmd == SIOCWANDEV) {
-			err = -EOPNOTSUPP;
-			if (ops->ndo_do_ioctl) {
-				if (netif_device_present(dev))
-					err = ops->ndo_do_ioctl(dev, ifr, cmd);
-				else
-					err = -ENODEV;
-			}
+			err = dev_do_ioctl(dev, ifr, cmd);
 		} else
 			err = -EINVAL;
 
-- 
2.25.1

