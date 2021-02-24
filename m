Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03277324751
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbhBXXDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:03:50 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:54901 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236169AbhBXXDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:03:49 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id F32VlxCf1lChfF32blf7XA; Wed, 24 Feb 2021 23:53:58 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614207238; bh=R0uzV0hFLidQmtjA+zBKE2NvY97+urNx6XnzVqPu0jc=;
        h=From;
        b=kjjbTaxKXGlTUPIca31seWqYudFQRFPIqihUzJvCAY7GPg2aaMWDk257FELD2XGws
         Siz2EIun6CAiRp1mWNHDIGxVPwyCFX18O6mV3K4fDjAXORK8u4Fo1vQF8X3VRfk1v/
         k6ieqa+cykBjgGI66sjY13/iXeGiFpN03/KUkCY7sJpoSBIKdNJCpd6WX+7D8uvnkH
         6zxy1NpGGgi7wEsHjO6Pz1gdF5DGpkf1J9wYtjyeIrnK4yhNd1dGGoaIHR43S877nW
         iZHmIGmsgm2Kx0OAKHeH/pJ9NRovQ5+p64rSG3kuWAJz4pZtyWK/oe9XrEPRAB0PxV
         22u2kKnopXR7Q==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=6036d906 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=YyHhdtpqV3cun0yf7GkA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/6] can: c_can: use 32-bit write to set arbitration register
Date:   Wed, 24 Feb 2021 23:52:44 +0100
Message-Id: <20210224225246.11346-5-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224225246.11346-1-dariobin@libero.it>
References: <20210224225246.11346-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfGsvJbAciFCjUGaugcCt8RndDS2Bmh1pSI6dw003dyaO0QJ+ba08ESK+hqXJyh0a33nywnbFAsMVxdOEewUalIRz6zKQaj6KJ0K6bT6vfjkHlCgloQjS
 KFxCvUcyQOicpsspdysJuLRtDVRswdsT6bfPKHUrhj1cfHtnRYWUzpcop0l8WMtIF/TMuwvQrRBJa7LuKkWGRYMN0yp9eqf6d9fHksRPlMY8COPgHSEH+s8U
 V9bzbogo3A4+Dm14qrpw7WpM/Fg7iyaFX97Q0z7Z9C30HxdWBgMmqkaFBh96QbcXcMhzTG+4qGt7DuvZorrJiYpRLRI17P2uo9qkt5H5r9zg+CRdJi4YTLav
 ATZ2ni/SYq9S9dSejN0hp+zpiDYXWjzMR2NIp2QjReNLu+8ZjUxiAv77oHI6zfSMBl66PEHrDZwucjZG27hqhS086i+ArCJH4s0z+ADL3E2gMt010fRjfB9r
 yTzuxpoIwWlsZFsAOp4SCtDWprft+WSm36AYjuTxkH9xJrnPa0L6umYZSyh3YSdD3yYvl/aTJby6iRdXWKYAuQpWmtR9XAJn0UJmjTy1b1JvKQru1vocAgn0
 U3wSuj9wSvoJqBmvaNyLuuIi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arbitration register is already set up with 32-bit writes in the
other parts of the code except for this point.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

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

