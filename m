Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCD8581C4F
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 01:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiGZXKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 19:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240032AbiGZXJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 19:09:54 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDDF32B9F
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 16:09:48 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p11so19908397lfu.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 16:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S8uc04n3AkszIqf2Ejx2rLvr6yxl23UrWq7daIt/QG0=;
        b=YzSML/jeNU5Hqy5um9hcWCYVw4Z5xJjT66h2gZ/FfYMfUvxnK5AmsrycX2lxiqseev
         bpNa9p90zIJELeMTnFXmuesGejGYN1NbTJwFHBu67KFEmhslpNL3cHOKHROWXTcBwtXc
         Tzspcfm2wlS0jxJbBDJQd3PIfpHoub8Z1BUvcTxlDqoAWsdfcB/uVNlEmjg6BlzLf2Vt
         +x1oNBFwMJGMgOhRxiZIvbQ2mdhjRYchJiCGNo5TDnVVz0ZrK845vgO4N0j8+qOHHc4d
         m1xUHvTUF3hNXcRlFwJx7lz+1GDqmgJZ0+MYJJsUgs42mc/lqtftcVJjmB5ojuffOMSt
         HZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S8uc04n3AkszIqf2Ejx2rLvr6yxl23UrWq7daIt/QG0=;
        b=F+qqhoLt3g3brVWbU43+4s8/iEjxs394adNw1KFoKmE3YWVsVqMHtAnRn3N3eGO0p7
         z32A9B21v8CuQisog/9al4vbxN2aC0WIgdQZVwYl8Wve545h6uW8T+fVpa+0kDlHmYLG
         grg1qePD0nDSBxXwXPcKb/an+ZeCKL7sq+ruQFwdKwzud8i9QkKR5QNS8epPW2cHGp+f
         uwfLGLasjEQmV+98HcuYan1dsr4guee7W2AmacWjHMCjh5X5QzXPqfMUImHu1NqKXuSR
         djlmuPD4mD7nqC7uN5PjA3gAUwxl3e2o7Eq5hKJ5JIFA2YOgjsYN+vQFfIJXRDR1x66p
         BFvQ==
X-Gm-Message-State: AJIora9SYLg40ErnJUT4yOiVkDD1NH3DADDpyxabkCujJJgva7PNZiVb
        bs87jYzUipqeoW0aXSTbYTlKeQ==
X-Google-Smtp-Source: AGRyM1vuF/2kcOGe+C40rE5t61NjqOydB7Esj/YwQM6KqS2Tnw2KgnTAQOp1x5q1Afub5kf6QkJrXw==
X-Received: by 2002:ac2:5e84:0:b0:48a:83e0:a501 with SMTP id b4-20020ac25e84000000b0048a83e0a501mr5824524lfq.141.1658876986595;
        Tue, 26 Jul 2022 16:09:46 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id m20-20020a056512359400b0048a9a4d5c5csm917451lfr.244.2022.07.26.16.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 16:09:46 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        upstream@semihalf.com
Subject: [net-next: PATCH v2] net: dsa: mv88e6xxx: fix speed setting for CPU/DSA ports
Date:   Wed, 27 Jul 2022 01:09:18 +0200
Message-Id: <20220726230918.2772378-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
stopped relying on SPEED_MAX constant and hardcoded speed settings
for the switch ports and rely on phylink configuration.

It turned out, however, that when the relevant code is called,
the mac_capabilites of CPU/DSA port remain unset.
mv88e6xxx_setup_port() is called via mv88e6xxx_setup() in
dsa_tree_setup_switches(), which precedes setting the caps in
phylink_get_caps down in the chain of dsa_tree_setup_ports().

As a result the mac_capabilites are 0 and the default speed for CPU/DSA
port is 10M at the start. To fix that, execute mv88e6xxx_get_caps()
and obtain the capabilities driectly.

Fixes: 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
Changelog v1->v2
* Use an on-stack struct phylink_config pl_config.
* Use mv88e6xxx_get_caps() directly.

 drivers/net/dsa/mv88e6xxx/chip.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 37b649501500..07e9a4da924c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3293,7 +3293,12 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * port and all DSA ports to their maximum bandwidth and full duplex.
 	 */
 	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
-		unsigned long caps = dp->pl_config.mac_capabilities;
+		struct phylink_config pl_config = {};
+		unsigned long caps;
+
+		mv88e6xxx_get_caps(ds, port, &pl_config);
+
+		caps = pl_config.mac_capabilities;
 
 		if (chip->info->ops->port_max_speed_mode)
 			mode = chip->info->ops->port_max_speed_mode(port);
-- 
2.29.0

