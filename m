Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B00D30956
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 09:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfEaH2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 03:28:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45060 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbfEaH2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 03:28:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id b18so5725741wrq.12
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 00:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=349bO3eKWo36+YLW2izUvQ+NabomJ8/oiHBTBWo5iAw=;
        b=mcpXksvNecWmEad6A9O9z6z4TbMSb38IaPy5U9xh/ChgB21Cn7Ccj8gUOXoFOHUIVr
         8mNjkfFvOSL0xKKy7NQH8LCQa2sP7PeOiupRiyM38ynt6Y0bt4awXv+yW1K7Pj0ySX8C
         cfSPhYYQ8mjrwUcIVOraaVm5DNxJdZjn+gsP9OkOJXYwVd1D+iAX+kvUz8bDglVqrIFb
         ZFNBy0lMWFCbgNTyED0DxqosqhZy8WCPY5Yv1R0wL+H3IwC0W4w8cFhfcHUCtOQdcq9b
         Vjx//oFgvMqrM1ziw3xjhK6qyHexSr1jfpbkVl/VkVhlR+gJ9eL1h8SZ19Hbns2KLNjK
         ljQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=349bO3eKWo36+YLW2izUvQ+NabomJ8/oiHBTBWo5iAw=;
        b=NYx5/MBIERUMO+cqjKSB06tsluM6I5olukItfTf1VuSHNyUeWvljLLFqsYqy16bNe3
         6F8TP+us9etsukCRSeyWtQjZ2XG9NrWkkh4VPUN6d+dxPVHgDifVnQfysUqaQy/2HiSq
         1e6XyTpaMqK+Hj6O/yGrkK4WAimShLHOXRdGKxArf2AjXsspVK+d7U0gmQnTKCF3OjKc
         9hw7t61JpwyEhdHsbPZwBS9APo3tiVXw6uPt9F0igJMPr/akpyp3IoV2lmx9vH4d5EqT
         OZI+6+bkx4ZG68lwhj5a/eukdq1zikAUulE/OiDpkKHdj99yBAEhP+krWa4T0H6ZRQeD
         Qq3Q==
X-Gm-Message-State: APjAAAU62DBbz8Xj0X0CiiWla7hNPimVb8zUCMJNSoRny08EuQg4J0N2
        5BLqA8pr2T5U0/Ap+L7gZxK5dg==
X-Google-Smtp-Source: APXvYqzRSlmRgkwS8ktZa2OrrW3pe+Ou5C7Zfpqnk9FCgMzvRD6oVAi63eIdPX6etNJnqABbaTVj5w==
X-Received: by 2002:adf:e584:: with SMTP id l4mr5319382wrm.54.1559287693057;
        Fri, 31 May 2019 00:28:13 -0700 (PDT)
Received: from cobook.home (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id u9sm11324302wme.48.2019.05.31.00.28.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 00:28:12 -0700 (PDT)
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0
Date:   Fri, 31 May 2019 10:27:07 +0300
Message-Id: <20190531072707.1755-1-nikita.yoush@cogentembedded.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When non-bridged, non-vlan'ed mv88e6xxx port is moving down, error
message is logged:

failed to kill vid 0081/0 for device eth_cu_1000_4

This is caused by call from __vlan_vid_del() with vin set to zero, over
call chain this results into _mv88e6xxx_port_vlan_del() called with
vid=0, and mv88e6xxx_vtu_get() called from there returns -EINVAL.

On symmetric path moving port up, call goes through
mv88e6xxx_port_vlan_prepare() that calls mv88e6xxx_port_check_hw_vlan()
that returns -EOPNOTSUPP for zero vid.

This patch changes mv88e6xxx_vtu_get() to also return -EOPNOTSUPP for
zero vid, then this error code is explicitly cleared in
dsa_slave_vlan_rx_kill_vid() and error message is no longer logged.
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 28414db979b0..6b77fde5f0e4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1392,7 +1392,7 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	int err;
 
 	if (!vid)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	entry->vid = vid - 1;
 	entry->valid = false;
-- 
2.11.0

