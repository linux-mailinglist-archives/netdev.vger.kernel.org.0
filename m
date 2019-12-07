Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47725115D37
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 15:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfLGOkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 09:40:40 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:41333 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfLGOkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 09:40:39 -0500
Received: by mail-pj1-f68.google.com with SMTP id ca19so3969432pjb.8;
        Sat, 07 Dec 2019 06:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dJSkc7mHy0Apqqs0LOjlNBmO4HliOsLD/T1QQYCdge0=;
        b=JyikBE6LfTErMnXoY2J7brZ22XidEnntk3Ppx7Q0+EPwbg43lZiK2Yka3L/J6PxB0S
         1ucxh4+rFD5eFPnKDL9xE7n4Bwv6cKcJgeXw8eMxNrAv8hejyMlVbjFyeJAeaTJUXsS0
         COWPlU8WEs5vKtLDQyddg7xDBDvtRMVuQPOyVMU7i8NS2++KR9awdNic92RJZlbu0ByH
         t+JAlXn2HodC3SBMHdytNVqRih6zILWWstixUp7OLU3nzQCIyqKL3GfFOnkJjqtg60Kf
         O82ySCpooMwCCB7WMUimPNT4Q2wjShP/mct4fqAFVrTii+uP5uphFKp7CLcJ0L5j2tV2
         gIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dJSkc7mHy0Apqqs0LOjlNBmO4HliOsLD/T1QQYCdge0=;
        b=FtaqwWTEuDDWHZQO7jUHJ5O4e1oNxkozL/6gXq4uQZR7l0JrpBqKpbpPWi41f3P6+S
         GRmXhTp1dJYR+pnHI8OSmoW7FvDSTCj/gMH+TlqP+PGPvLpIK+R38ljAvsClRkpbwdLK
         Qhg6t1WzlLvCS5nBH7bkXkgzGVMTtOhmU2v5YcwevBzFaE0JpgLzK0TxWLf4ShGgopkR
         kxBFXgLStwVzljapu3bByqFBKUwAPXCfx/bngMfQNo78kjPPb+0hDH9npIAIexEoUFj5
         uynR1g1FeLKlIA4o24GLEQMQNg1cvsoH+VpaPQnSjkLtiqwz4QGgg5gLub5OZG+vGx4N
         z4oA==
X-Gm-Message-State: APjAAAXCG9fKMA/IKwBTSSavzVmjgaoYUYlX/HYemX9THpN0SbpyBOOJ
        x8ksR2MCN4hKIQ5JSFETpio=
X-Google-Smtp-Source: APXvYqyhI1pG5nAXc/pHudbfYrkR33RqCzn2sb/j7axjYc+uYRSF61b+kjuWISg7fALPS8zdpquqLw==
X-Received: by 2002:a17:90a:9f04:: with SMTP id n4mr21892610pjp.76.1575729639021;
        Sat, 07 Dec 2019 06:40:39 -0800 (PST)
Received: from localhost.localdomain ([222.209.84.125])
        by smtp.gmail.com with ESMTPSA id 23sm6925126pjx.29.2019.12.07.06.40.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 07 Dec 2019 06:40:38 -0800 (PST)
From:   Xiaolong Huang <butterflyhuangxx@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>
Subject: [PATCH] can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices
Date:   Sat,  7 Dec 2019 22:40:24 +0800
Message-Id: <1575729624-5917-1-git-send-email-butterflyhuangxx@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uninitialized Kernel memory can leak to USB devices.

Using kzalloc() instead of kmalloc()

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 07d2f3a..ae4c37e 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -608,7 +608,7 @@ static int kvaser_usb_leaf_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 	struct kvaser_cmd *cmd;
 	int err;
 
-	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1140,7 +1140,7 @@ static int kvaser_usb_leaf_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 	struct kvaser_cmd *cmd;
 	int rc;
 
-	cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1206,7 +1206,7 @@ static int kvaser_usb_leaf_flush_queue(struct kvaser_usb_net_priv *priv)
 	struct kvaser_cmd *cmd;
 	int rc;
 
-	cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
-- 
2.7.4

