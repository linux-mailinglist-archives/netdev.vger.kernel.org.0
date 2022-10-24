Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32649609FB8
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 13:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiJXLFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 07:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiJXLEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 07:04:47 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A791B798;
        Mon, 24 Oct 2022 04:04:00 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 29OB2GTB015664-29OB2GTE015664
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 24 Oct 2022 19:02:20 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Julia Lawall <Julia.Lawall@inria.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: usb: ucan: modify unregister_netdev to unregister_candev
Date:   Mon, 24 Oct 2022 19:00:30 +0800
Message-Id: <20221024110033.727542-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From API pairing, modify unregister_netdev to unregister_candev since
the registeration function is register_candev. Actually, they are the
same.

Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/net/can/usb/ucan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 7c35f50fda4e..60f730094e5d 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1581,7 +1581,7 @@ static void ucan_disconnect(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 
 	if (up) {
-		unregister_netdev(up->netdev);
+		unregister_candev(up->netdev);
 		free_candev(up->netdev);
 	}
 }
-- 
2.35.1

