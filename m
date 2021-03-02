Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB9032B3D4
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838441AbhCCEH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:27 -0500
Received: from smtp-17.italiaonline.it ([213.209.10.17]:52771 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2359539AbhCBWAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 17:00:50 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id HCz0lBDmUlChfHCzBlGa0q; Tue, 02 Mar 2021 22:55:21 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614722121; bh=gGBb0if76oFz8ZwaKKCbLEQjDj90X/5zDbKBMeSdiUc=;
        h=From;
        b=T8B5ZefqPk3DmSIj78XmxkBIraj5oovEoTGNwI3NQdUftYczqjyYwtVeOPeO0WjdN
         VwEmR+E4viE9hJ+/PB3cjONepFPkrLiwZziq0ESRarJzX72x0/1TmMaAtLenEs83ZT
         Wzt67w6HL10O/lEaTI4YTXCCKaHYkCLHpWD9GYiZkO8X7yxBaXYELOz6dCBXJWjBQ1
         SgMbyxHWD59HsSTkUFw94hwmjRkyXAgLM8zit3wzkAJfclg+c2J5yF0pzPX5LrwF/t
         FNffUmH3lWqs4Eftd3fymewl0OEd/5RR5ArHTwjVG++usdo889HwlQY9Gbi2gGAgnh
         I5LbG2BSsV8fA==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603eb449 cx=a_exe
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
Subject: [PATCH v4 4/6] can: c_can: use 32-bit write to set arbitration register
Date:   Tue,  2 Mar 2021 22:54:33 +0100
Message-Id: <20210302215435.18286-5-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210302215435.18286-1-dariobin@libero.it>
References: <20210302215435.18286-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfALmbl+rhBfE4zafOS7jLa8Q+n7eEyC7LfLeVholBUrNRtsS4icLPd420gn24S1iGl7/F2v00nn0ztIvFSw3x2OYNtzQTD+NsS91Pkgzz4XXw7X7w5Kh
 Ld+nTL/fnRIOd2U6NtS717z6EmJmhr1XP2E5U0g2VjUil6TI4YchvC4rxhexKDqP7OXB870P9TvtyPnrZ0t58oNvdFkKJI0MjNTy8kqwluXWoM7wUTqMlEzf
 YzUul0/BzolOjdq+0a8bVBiRdpiDCU1xoPvuGmoC/OvRZLg9DnNrHPxrq2h5ed3wCW3mdzYT2eNzakA0L5sxAGCnRgljyNTMvfrMzmX0mf9MCrysHWZdxel3
 QO6FtueafHelSduDqQCCly6SXty2mvxmyax2fZrk1LRWHw9zyhoM+bZr37K/LkLGWhHgNdvDKQTZfZrkbsOcH9fskjhZFee6dfHeYbtHYGKAcBKcFLDY/ac5
 FeSnJPVy6air3fx2bIRbZKwtxmDb5d1/TXRKls0wMva5mkpKbG+Ou/cGkIBUxUBeqE+gm30oTIMIYPjU1gttCS2gUG1qa8jcpaYvc/MDP1p+ihVbLQHBgJ2n
 5n9qaOGsri2Ub3j93+jY0nbyb1SFsnrlzIQyU0hT5fZrURLIMUwQNPVyNIscuxpQ/m3ZYN3lp7obxDu2o+UwrELXMQqJCfbm+FAiVX+H3tqdWQ==
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
index 6c6d0d0ff7b8..77b9aee56154 100644
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

