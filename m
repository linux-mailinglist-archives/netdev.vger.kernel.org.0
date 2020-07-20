Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D9B225651
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgGTDuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgGTDuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 23:50:07 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C28CC0619D2;
        Sun, 19 Jul 2020 20:50:07 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gc9so9497071pjb.2;
        Sun, 19 Jul 2020 20:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s0bPXMdX/gLeZJkA8kYL9ZRzdQQF5fbDlom5NC+jb10=;
        b=LMlDy9vthgMMQ247QmiXj3FQudMGnP1riki5Am5zx1I+yOgOKi/pmY2/LwDzrZ9xXC
         gdjAEKW2wNTvaeieD8gezVXCMCYutAlZeoTw3hOpLECG+U7mbYyUoqDpMJ7+3h6JlM7f
         K19mT7xQKequTi/ozMet0Y81HvGXfS0ys4cUvMPtPYht4icRXWpLZLOvWiKyzf74KjtV
         lwgKuKTOsrLBimxs1tsCua6htOddCqtWwroR2JKh+52oYayfR40qdfLB7HwnplXuGS+e
         OazKvUO19nVUAhTi5FNE24OHGJnuvY4NT5hgc1Glp2ivXNImRdTYOJZ4jxhV+LR8bH8W
         lDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s0bPXMdX/gLeZJkA8kYL9ZRzdQQF5fbDlom5NC+jb10=;
        b=XAtvo0R+VLHH/U4pjyuZLl4KNZquoWN27ksrV06UU44kPks0X08Iz9Ps7OEtqCFBtf
         5ISS4tDDBra3ZO8aQGGOUhc2jPD/kkbibG5uc8cy+p7CiQ9alHB+ChHYp6e2z/maToOD
         CUwjG97J1YjvH6O74A8gkDXHziqQYZx+dTfaKIBVjx5eKGZL8Hf5LaflnA1269ERXzsK
         FzC9ujzdxFwKFBOEfdaFTDGAYRBaIDrndFyaHN3iK1Y4rysVCp8W1xNgsxiaTcXwBzmU
         JhY8kJb+e6lkeSbmLt+399sPCM0IknweqM6yk5+Kiy1JyWIH8PZCf63MFOKWtWWQgprb
         1k9Q==
X-Gm-Message-State: AOAM5326yLe3Mu1DQte9ZABcmb1C6FmrpbkMu7aCkTh1W2c9whTe1DB9
        xXj+9tBUE/pnj0A8tn8LZurqP4w0
X-Google-Smtp-Source: ABdhPJxRR9n13AVDdTqGQQ1JQGXKrpmqqzAhDdjljuIhKtElgFuyWvR8pUW5i/QR0KEugRhvpu2gtw==
X-Received: by 2002:a17:90a:fa09:: with SMTP id cm9mr8052824pjb.146.1595217006195;
        Sun, 19 Jul 2020 20:50:06 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z11sm15183445pfj.104.2020.07.19.20.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 20:50:05 -0700 (PDT)
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
        linux-kernel@vger.kernel.org (open list), olteanv@gmail.com
Subject: [PATCH net-next v2 3/4] net: Call into DSA netdevice_ops wrappers
Date:   Sun, 19 Jul 2020 20:49:53 -0700
Message-Id: <20200720034954.66895-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720034954.66895-1-f.fainelli@gmail.com>
References: <20200720034954.66895-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the core net_device code call into our ndo_do_ioctl() and
ndo_get_phys_port_name() functions via the wrappers defined previously

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/core/dev.c       | 5 +++++
 net/core/dev_ioctl.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 062a00fdca9b..19f1abc26fcd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -98,6 +98,7 @@
 #include <net/busy_poll.h>
 #include <linux/rtnetlink.h>
 #include <linux/stat.h>
+#include <net/dsa.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/pkt_sched.h>
@@ -8602,6 +8603,10 @@ int dev_get_phys_port_name(struct net_device *dev,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 
+	err  = dsa_ndo_get_phys_port_name(dev, name, len);
+	if (err == 0 || err != -EOPNOTSUPP)
+		return err;
+
 	if (ops->ndo_get_phys_port_name) {
 		err = ops->ndo_get_phys_port_name(dev, name, len);
 		if (err != -EOPNOTSUPP)
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index a213c703c90a..b2cf9b7bb7b8 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -5,6 +5,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/net_tstamp.h>
 #include <linux/wireless.h>
+#include <net/dsa.h>
 #include <net/wext.h>
 
 /*
@@ -231,6 +232,10 @@ static int dev_do_ioctl(struct net_device *dev,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err = -EOPNOTSUPP;
 
+	err = dsa_ndo_do_ioctl(dev, ifr, cmd);
+	if (err == 0 || err != -EOPNOTSUPP)
+		return err;
+
 	if (ops->ndo_do_ioctl) {
 		if (netif_device_present(dev))
 			err = ops->ndo_do_ioctl(dev, ifr, cmd);
-- 
2.25.1

