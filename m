Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8623729492F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 10:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502163AbgJUIHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 04:07:53 -0400
Received: from mail-m964.mail.126.com ([123.126.96.4]:54270 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407580AbgJUIGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 04:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=eictmf52OPpcOGd4A4
        gKYbSSk3VTWSCn1R/rLn4YWto=; b=Kd0PXqQDD3NT49s1aE7PIISCuzbmjOoUiL
        dyY/RzBnXOLZTHhYc8DUWIGJLK0BSSFsBAGLQolPWe1emQxXFPpehPxGUow4cBES
        a3+jUzr8cRTp4R8JqMGh9yJIIbeWlW9IrMlYsQ0O4iqysB//m5kt9aJonb9RF2Wj
        U4SSIBog0=
Received: from localhost.localdomain (unknown [36.112.86.14])
        by smtp9 (Coremail) with SMTP id NeRpCgAXEgRO5I9fcz9fMQ--.11117S2;
        Wed, 21 Oct 2020 15:33:35 +0800 (CST)
From:   Defang Bo <bodefang@126.com>
To:     siva.kallam@broadcom.com
Cc:     prashant@broadcom.com, mchan@broadcom.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Defang Bo <bodefang@126.com>
Subject: [PATCH v2] tg3: Avoid NULL pointer dereference in netif_device_attach()
Date:   Wed, 21 Oct 2020 15:33:22 +0800
Message-Id: <1603265602-8887-1-git-send-email-bodefang@126.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: NeRpCgAXEgRO5I9fcz9fMQ--.11117S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF17trW7Jw17GFy5Kr1xZrb_yoW3CFX_KF
        1UZrZ3Gr4UGry2kr4Ykr43Ar98Kan0vayF9F1Iv3yaqrZF9r1UJFWkZryfArnrWrWUtF9r
        tr13tFWfGw4jkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8PKsUUUUUU==
X-Originating-IP: [36.112.86.14]
X-CM-SenderInfo: pergvwxdqjqiyswou0bp/1tbitArE11pEBwQX1QAAsy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit<1b0ff89852d7>("tg3: Avoid NULL pointer dereference in tg3_io_error_detected()")
This patch avoids NULL pointer dereference add a check for netdev being NULL on tg3_resume().

Signed-off-by: Defang Bo <bodefang@126.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ae756dd..345c6aa 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18099,7 +18099,7 @@ static int tg3_resume(struct device *device)
 
 	rtnl_lock();
 
-	if (!netdev || !netif_running(dev))
+	if (!dev || !netif_running(dev))
 		goto unlock;
 
 	netif_device_attach(dev);
-- 
1.9.1

