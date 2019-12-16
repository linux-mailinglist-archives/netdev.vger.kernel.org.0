Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F37D1216FD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbfLPSdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:33:08 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33966 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730772AbfLPSdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:33:03 -0500
Received: by mail-pj1-f65.google.com with SMTP id j11so3369144pjs.1
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X1zMAvxCxhNskiOgc/FddBrf0+UkJNkVR3iWyW4+/VY=;
        b=TMhmToLvRQp7S5PBPOfHiUUGksvPcQcvqxmiCD3+MZ97QglcZ4fHgSxHtFKa+GN0Fy
         SEyD/TX8F7mW2eKPrGsE+3liuilWz7QkuFpBmfO/VFvtb9/6JbBG/U0tnGgR5bXGPL33
         9H3vzg6Qd0Ii7R++kF7UKiUzmJipvTEtBILZASk9QYsR3QHgNx4fblWUNR3x8Ldp3jcK
         9FxM81lPQbBBsKJBO//GaEmhAa9OQhfXhxfKm1G1eH10ihLPNd/u/r24/Hb/1utjUWXd
         TQ7mNlRzhYK7nGd3HRmAnjX+QAcQucFGFfeP8uG0iKO5J73L3Fl+D1Q378lTpXljntkK
         R0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X1zMAvxCxhNskiOgc/FddBrf0+UkJNkVR3iWyW4+/VY=;
        b=jhoPJagwC6SZutKM67/TE9wiKfY/JOA+lsegMVaLsRRK+FzWg9n7ccU7H2HETmkwzR
         ZcEmjO+E4pWoW1HUqU40NhAZpAfQMOtYCdE83TKhBVlPEB1lFYx39sqdza9dAToA2ys5
         CaCrGbPTc/PlHndoaxWoOvUh5u0jK7YsFMCWdBU9eZMhrO4e5j4a77xE9uF8j6I2moOu
         ZMuWcPS9M1v52T9FD0QTRAjLupu5Tr1Hg9DKO+FxZsjfINrJrOV8hh/v9oje7cKXTBlS
         o0Z0uV0jVEeENJsYboLVbY2QxG4SCGyzJ9THycbn3rhW7y0qRbFyBBHEAgMuDx9VrJh/
         1pqA==
X-Gm-Message-State: APjAAAVU1LNekgwdU6kV6g/FFtmH0lHmRr7FR9ZgtGqsMCzObrPVMw/p
        RFhdapIPXg6TmJNYKr5nSRlw3gdm
X-Google-Smtp-Source: APXvYqzYPP3GI6b+mc7I95bJF2flZn6xh7EvsGcWzXAw1CEIntK0FV1qXcs9LWm/EAIJ4kPexaeDsA==
X-Received: by 2002:a17:90b:90e:: with SMTP id bo14mr613573pjb.17.1576521182870;
        Mon, 16 Dec 2019 10:33:02 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d65sm23400738pfa.159.2019.12.16.10.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:33:02 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 3/3] net: axienet: Pass ioctls to the phy.
Date:   Mon, 16 Dec 2019 10:32:56 -0800
Message-Id: <361f63095be92df10e8e953af3b981cdac58d98e.1576520432.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576520432.git.richardcochran@gmail.com>
References: <cover.1576520432.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow PHY drivers to handle ioctls, the MAC driver must pass
the calls through.  However, the axienet driver does not support ioctls
at all.  This patch fixes the issue by handing off the invocations to the
PHY appropriately.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c  | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 05fa7371c39a..d0b996f220f5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1067,6 +1067,23 @@ static int axienet_change_mtu(struct net_device *ndev, int new_mtu)
 	return 0;
 }
 
+static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	switch (cmd) {
+	case SIOCGMIIPHY:
+	case SIOCGMIIREG:
+	case SIOCSMIIREG:
+	case SIOCSHWTSTAMP:
+	case SIOCGHWTSTAMP:
+		return phy_mii_ioctl(dev->phydev, rq, cmd);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 /**
  * axienet_poll_controller - Axi Ethernet poll mechanism.
@@ -1095,6 +1112,7 @@ static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = axienet_set_multicast_list,
+	.ndo_do_ioctl = axienet_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = axienet_poll_controller,
 #endif
-- 
2.20.1

