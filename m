Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2459D325924
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhBYV6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:58:36 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:33832 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234840AbhBYV5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 16:57:36 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id FOYQlNUJ2lChfFOYYlkbgi; Thu, 25 Feb 2021 22:52:22 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614289943; bh=BCMzyFPGjvLZKNUS2sizrsXN5C/G8I7qiN9C3GvALOQ=;
        h=From;
        b=G/sqbnbhoBrcJVq4yhhyZ1gRfCNRus6HLixJb3gvcg+gdfpPzgd5whGJLColg977R
         60z3nofAlamkDuTthuedA2r3ngmYH6sx8R9uPzzQdn3gjl7SC4VEtogzcc5QEVgbGM
         7jeMlyzif3LpyaZ8aFMTuZe+07D5WlByeDV6SJN3/t2BqsrlA4vh+cWQVg63KCzVSM
         Ce4doVJeeEBLkgFB0KhcguInW0xHITeKXi106NVTBoG4rZmMBN+xh4skXjUJ4HEAng
         8rMTBvXxyiYoqh+sNNTK2899ZSWKGdPqfeqyDyO8jXZRibZvhKE94wtGu9FH1MlyWA
         7iQzwU/MRZU4g==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=60381c17 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=YyHhdtpqV3cun0yf7GkA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 4/6] can: c_can: use 32-bit write to set arbitration register
Date:   Thu, 25 Feb 2021 22:51:53 +0100
Message-Id: <20210225215155.30509-5-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225215155.30509-1-dariobin@libero.it>
References: <20210225215155.30509-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfN5b3Rqft8U7sYPJxUkdMUWC1LS8OtnTPA11KZdrUvwXZNfnsJYRZ+Vn1uNUlhHDizOz33lXjueok4cZYUrttT9Of6L/P+Tc2dGCGoMKxQQs8KeSBVNo
 KtBLeHv0L07u/tTEJao2Ybhh4h/HrROJe/uHI3wOI8wwhIF9FSJCR9hgWWNJAtUzDYCwJWpVZPXit6HjCQOVeB0eo0BjmghmLlZOjLZPuK7+6Cg4rIDZIvCC
 66o1nWgRniRAB8bjRte8XAxfZlxz8VtKCWDBverXiPHJmT57HaoZXGqUPDb4dZP8pufWDWCKWxdC9g2kF9XZU44SEzytO5YXEOzklNzuetTB57xyr5xlX/e0
 Qi5W0claOPGkj+gpYTFmL3d36ZCQzR+C/U+pk2eNa0D53ZPiphE8MbFmgwTlfgCeuADde47OEwf+E8SddSKXeLFN9xhYmsu88aZehVdgu+g36I6NPDfA+RXB
 eDavfma1gpo6Vw/7NkzILVDeSq/GkSe5UQGvTlkhzhtGyp0+Y0GkZuEVSCE83lzB+NJLHfRMsZhofZe5qg6rfaIMuXpvJhl8FtSEQ7ffmCnGB0jDWBrkaTs2
 smhF7ZLVjFugHl7vQ9rhfodC41wttg2vza7XzPP2RJcHa2qLtamUv3W7jzPVULpTK1o91l/DmcN48RD5epR8j8h8kUjVmTK0tRw/C0kWLn8bLA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arbitration register is already set up with 32-bit writes in the
other parts of the code except for this point.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

 drivers/net/can/c_can/c_can.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 69526c3a671c..7081cfaf62e2 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -297,8 +297,7 @@ static void c_can_inval_msg_object(struct net_device *dev, int iface, int obj)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
 
-	priv->write_reg(priv, C_CAN_IFACE(ARB1_REG, iface), 0);
-	priv->write_reg(priv, C_CAN_IFACE(ARB2_REG, iface), 0);
+	priv->write_reg32(priv, C_CAN_IFACE(ARB1_REG, iface), 0);
 	c_can_inval_tx_object(dev, iface, obj);
 }
 
-- 
2.17.1

