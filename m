Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FD2215093
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 02:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgGFAp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 20:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgGFAp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 20:45:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F35C061794;
        Sun,  5 Jul 2020 17:45:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id t11so11408601pfq.11;
        Sun, 05 Jul 2020 17:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4OaY8bZwpJuqmoIiivxLlaUVMaXxlk23RnTZnLFJFaY=;
        b=kd2w6hJIZW9PFP0lMor0Df7aUbziEFd/nGD0zMJOBuuWd21lAfqEipSBJb29CnzV6O
         0IrRM13BFz+vsC6/9Zykj4l47i8zCsw6O9fnI24mxY9GAQKldLqnA/sqOBX9zfVTTLoX
         +1s//whclybYcTOEZL22qwzGJNLYXnxCXcO7MSRysvfNpZj8/sMQRnMVXynCW99vpeo4
         rid4eAngZ438yS4XzZlqtwOg24OmCqeVkg4rbOuqt8LUpDUEEetfvGlzCocBqDBGzkVH
         kqSW5OdhEIKTLzddRU25moBgkZwDhh0PSHDyKHRAI9ih5RnuJbWyc2bQ0IC9nQk197dW
         zqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4OaY8bZwpJuqmoIiivxLlaUVMaXxlk23RnTZnLFJFaY=;
        b=O30eYB1WvWYEsAQWTfm3c22ZrThtvLNN0FYg22tDc/jWkrJDz+BYk2bdUn7vIPlUPU
         Mzxed0xj/YsM00ZeEmP87z+H6y2HSAKllGbHaIZCqI6ioQea9GYH8vu6usMkVQoiL+0d
         BzxX92HkNRLo41TOWdKNxq9vArGyDGbDqNcR33Lfx5ElojRNI5U3nu8khW1+b9vsLDrd
         KGicnx4V70fX3J4bwdWqWKBhuEdaBvrLewq5SkKlqUQZuepODRIfwOxh4F1JIfsZ7KQZ
         DJbmp4Lts7gLd4zfjmhIQhyCL4JRRUorj3NCjHk6/uZZkaSY97NTB1MhTjKfUz3tk39h
         zUNg==
X-Gm-Message-State: AOAM530te4NHKJtmDB7ezckAnTvIuutIJaoSiSk4lxWTZ7pHeWepUKhZ
        rrd09PPE1rtFdS9IYgT8q80=
X-Google-Smtp-Source: ABdhPJwC2Hju+ZSHzN/fJl4gpu4jFAAKkvYojCNR+ygw0BPcIN7IJo5ZQ3B3US/pm4hPJWClOzW6CQ==
X-Received: by 2002:aa7:8513:: with SMTP id v19mr34056031pfn.74.1593996327546;
        Sun, 05 Jul 2020 17:45:27 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:70cf:a866:7e6:bda8])
        by smtp.gmail.com with ESMTPSA id u26sm17547457pfn.54.2020.07.05.17.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 17:45:27 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        Xie He <xie.he.0141@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Subject: [PATCH v2] drivers/net/wan/lapbether: Fixed the value of hard_header_len
Date:   Sun,  5 Jul 2020 17:45:21 -0700
Message-Id: <20200706004521.78091-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When this driver transmits data,
  first this driver will remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes,
  then this driver will prepend a length field of 2 bytes,
  then the underlying Ethernet device will prepend its own header.

So, the header length required should be:
  -1 + 3 + 2 + "the header length needed by the underlying device".

This patch fixes kernel panic when this driver is used with AF_PACKET
SOCK_DGRAM sockets.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
Change in v2: added a comment in the code

 drivers/net/wan/lapbether.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index e30d91a38cfb..284832314f31 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -303,7 +303,6 @@ static void lapbeth_setup(struct net_device *dev)
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->type            = ARPHRD_X25;
-	dev->hard_header_len = 3;
 	dev->mtu             = 1000;
 	dev->addr_len        = 0;
 }
@@ -324,6 +323,14 @@ static int lapbeth_new_device(struct net_device *dev)
 	if (!ndev)
 		goto out;
 
+	/* When transmitting data:
+	 * first this driver removes a pseudo header of 1 byte,
+	 * then the lapb module prepends an LAPB header of at most 3 bytes,
+	 * then this driver prepends a length field of 2 bytes,
+	 * then the underlying Ethernet device prepends its own header.
+	 */
+	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
+
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
 
-- 
2.25.1

