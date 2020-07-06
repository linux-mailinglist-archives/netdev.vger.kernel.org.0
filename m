Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7B22151A3
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 06:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgGFE2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 00:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGFE2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 00:28:07 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B4EC061794;
        Sun,  5 Jul 2020 21:28:07 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so770968pfe.5;
        Sun, 05 Jul 2020 21:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v8CLcC3ysliK6+4sr4xmqbMa0bZ4Dm3ZHnrxJuH9exM=;
        b=kbhTQ/a2J56gJybm542XyAxj3WJntcZnxGMoE7eudEkv+nyq6aMgfIDTRjjk8ibT1/
         mEZOa19zIk2pCI7Tr04uP46Gk1pkqInW4zTppSeQGcoZROTjARL3dEzSnvKVbxdJOKWu
         qVgiS/do/JC1C8JlDZpzYcibmKV/30QZ5Yo4ZZOhwpQM0jK0LcLmi7sxdEIU9oEr8vsX
         bg/h4g4tjxQlE+KK75DF/mEHSok7fs/s5GJLA0CG7WtXzciNeIuR6vUY4YNq+w13sEFb
         F4yJX0J1Uydx8HPB4cMBZv60Vhdg4m6pjgd5d+OGNmeACnXxk+vhqqBHpKbkgqxqEuDh
         Besw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v8CLcC3ysliK6+4sr4xmqbMa0bZ4Dm3ZHnrxJuH9exM=;
        b=qnA0HfVuqabvK1+LvJVDx8gOSJq0JtCr9e5uIUEFJXJu3QlGLsHCMBTfPYPkD/UIHK
         rDQfOScoDBV27DjIJQf/cJf0qp/H27uGxnZP2ftX4xW0UOQnKNNImIbpIjNAwkSWqdZ6
         lotFod+YpP4FeF5tKkouEhXITvxXcrA/kuIWNyePvKTO7uIEEOYdYP8nDpKxUsWQHX10
         zg3bpCQFrKQqbaiYo5dfcFkxicCxUYMxf5zjuxOSkzfhhSWe4qYjgmxTWv9uVox1Qtkk
         uikZvdi21RSIQQ2JHBh2DUipT0cZda+Bq9w5d7vjeWzZLWJVtZH7Ck/aoU1lTkmLYkXO
         RbgQ==
X-Gm-Message-State: AOAM531MJs2Tde6VuP/jF2e63xKaFTABaSO6Xh9kCqSatXdtCPJI2VLC
        76t3jALVMIdK8GRGyAEL4mIeIIF4
X-Google-Smtp-Source: ABdhPJwpMktroHvkI9HxHCORyeJLKApJPpGKz+krKplES+ZZ5aRN5OATty3DjREunag0tYZUycfWIw==
X-Received: by 2002:a05:6a00:1342:: with SMTP id k2mr41987550pfu.32.1594009686770;
        Sun, 05 Jul 2020 21:28:06 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ia13sm16558680pjb.42.2020.07.05.21.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 21:28:06 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 2/3] net: phy: Register ethtool PHY operations
Date:   Sun,  5 Jul 2020 21:27:57 -0700
Message-Id: <20200706042758.168819-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706042758.168819-1-f.fainelli@gmail.com>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize ethtool_set_ethtool_phy_ops to register a suitable set of PHY
ethtool operations in a dynamic fashion such that ethtool will no longer
directy reference PHY library symbols.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index eb1068a77ce1..94a5aa30b70f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3029,6 +3029,11 @@ static struct phy_driver genphy_driver = {
 	.set_loopback   = genphy_loopback,
 };
 
+static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
+	.start_cable_test	= phy_start_cable_test,
+	.start_cable_test_tdr	= phy_start_cable_test_tdr,
+};
+
 static int __init phy_init(void)
 {
 	int rc;
@@ -3037,6 +3042,7 @@ static int __init phy_init(void)
 	if (rc)
 		return rc;
 
+	ethtool_set_ethtool_phy_ops(&phy_ethtool_phy_ops);
 	features_init();
 
 	rc = phy_driver_register(&genphy_c45_driver, THIS_MODULE);
@@ -3058,6 +3064,7 @@ static void __exit phy_exit(void)
 	phy_driver_unregister(&genphy_c45_driver);
 	phy_driver_unregister(&genphy_driver);
 	mdio_bus_exit();
+	ethtool_set_ethtool_phy_ops(NULL);
 }
 
 subsys_initcall(phy_init);
-- 
2.25.1

