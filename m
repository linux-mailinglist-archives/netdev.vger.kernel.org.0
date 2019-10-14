Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36118D613C
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 13:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbfJNLZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 07:25:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64856 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730064AbfJNLZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 07:25:37 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191014112534epoutp01e205c9bf7011db950704415fcc107d13~Nf8ZUQ3Yn2427224272epoutp01j
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 11:25:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191014112534epoutp01e205c9bf7011db950704415fcc107d13~Nf8ZUQ3Yn2427224272epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571052334;
        bh=hTQaHSOqj4sU/pT0l/ISHmiDV0BTtmWO7XPAAgh3lbs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=a13vBRzpfY2U59nAja5PoV2tfW7S+NT4OgVYbU6epEHqa5zK7n0z+bPK5+FoaAjYa
         kaetwPPgGPobcCGlSX07ZAmm+NnWc8RaIy0J0IgMXzLoo65fM/YpfIncLPsUr78PHB
         AwPrxQfIx/WRFo3gVOVb+2ycbd1i04iX3vEEG0LA=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191014112534epcas5p2876869cfd34c41d5445c9f94c5845e5b~Nf8YoAhW80758507585epcas5p2A;
        Mon, 14 Oct 2019 11:25:34 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.F5.04480.D2B54AD5; Mon, 14 Oct 2019 20:25:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20191014112533epcas5p1c18bb35f34950256b625e467924b2acd~Nf8YJihFn2990029900epcas5p10;
        Mon, 14 Oct 2019 11:25:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191014112533epsmtrp2334246f8d030707ba7616a333064e926~Nf8YIjuX43164431644epsmtrp2d;
        Mon, 14 Oct 2019 11:25:33 +0000 (GMT)
X-AuditID: b6c32a4b-cbbff70000001180-63-5da45b2dcdf9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.C1.04081.D2B54AD5; Mon, 14 Oct 2019 20:25:33 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191014112531epsmtip23d1a77b4d5d0c40bbaba04801a1da67a~Nf8WHwat02272122721epsmtip2H;
        Mon, 14 Oct 2019 11:25:31 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        eugen.hristev@microchip.com, ludovic.desroches@microchip.com,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH v2] can: m_can: add support for one shot mode
Date:   Mon, 14 Oct 2019 16:54:48 +0530
Message-Id: <1571052288-22554-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWy7bCmhq5e9JJYg7udjBZzzrewWBz4cZzF
        YtX3qcwWl3fNYbN4sfY6q8X6RVNYLI4tELNYtPULu8XyrvvMFrMu7GC1uLGe3WLpvZ2sDjwe
        W1beZPL4eOk2o8edH0sZPfr/Gnj0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxrbDl5gK2kQr
        7t14xdzAOFmwi5GTQ0LARGLbuhb2LkYuDiGB3YwSv1bfhnI+MUr8X/6KEcL5xijR9KGXFaal
        o3M3mC0ksJdRYukKP4iiFiaJRXeOgiXYBPQkLr2fzAZiiwiESizrncAKUsQs0MQk0bW5lxkk
        ISxgK/F/dgsTiM0ioCpxYtVedhCbV8BDYtGHLhaIbXISN891MoM0SwhsYJP4P+clVMJFYsb8
        DewQtrDEq+NboGwpic/v9rJB2NkSC3f3A9VzANkVEm0zhCHC9hIHrswBCzMLaEqs36UPEmYW
        4JPo/f2ECaKaV6KjTQiiWk1i6tN3jBC2jMSdR5uhhntI7PyyghESDrES0+ftYZnAKDMLYegC
        RsZVjJKpBcW56anFpgXGeanlesWJucWleel6yfm5mxjBSUHLewfjpnM+hxgFOBiVeHgV0hbH
        CrEmlhVX5h5ilOBgVhLhZZiwIFaINyWxsiq1KD++qDQntfgQozQHi5I47yTWqzFCAumJJanZ
        qakFqUUwWSYOTqkGxriy/T+aJCsSZz0JtrYqMzq3u8CJZ8c/Nlm3b5HnHm9KUCjpO7J+0o3W
        96bBm1ZUfbed9+VfZqrvvbnJfboquwpF5p8Kv6yz9cjTM+Uicbr326TXZU4M+i59fYLXLE7e
        6Tnml1LWsT3eddNo8wVpaZ6IG5NvzrDbnJ7rN2357vN8srqX395j9FViKc5INNRiLipOBAD5
        LeB8BgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSvK5u9JJYg/c/pCzmnG9hsTjw4ziL
        xarvU5ktLu+aw2bxYu11Vov1i6awWBxbIGaxaOsXdovlXfeZLWZd2MFqcWM9u8XSeztZHXg8
        tqy8yeTx8dJtRo87P5YyevT/NfDo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujG2HLzEVtIlW
        3LvxirmBcbJgFyMnh4SAiURH527WLkYuDiGB3YwSW282M3YxcgAlZCQWf66GqBGWWPnvOTuI
        LSTQxCSx6ZQeiM0moCdx6f1kNhBbRCBcYueELiYQm1mgh0mi9W4CiC0sYCvxf3YLWJxFQFXi
        xKq9YHN4BTwkFn3oYoGYLydx81wn8wRGngWMDKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS
        83M3MYIDT0tzB+PlJfGHGAU4GJV4eE8kL44VYk0sK67MPcQowcGsJMLLMGFBrBBvSmJlVWpR
        fnxRaU5q8SFGaQ4WJXHep3nHIoUE0hNLUrNTUwtSi2CyTBycUg2MrFWKUVvfzb9Vf/zKSy+l
        rIVzjBapKwk23QrNX8DzZcr0D6+K3CQWTFOP7j+XwC+eYCqiybDqWbP6TP2Cnv+TV6VIL+5q
        +lj9/+PNSpX0P0syluVcNrH+W8C0bfOOoCU/Zz2J1Nqan3DA0ne/wPI76dc2r/tbr3RhmWT+
        0r/zJiyYvuf67qhMFSWW4oxEQy3mouJEAGBJnEA4AgAA
X-CMS-MailID: 20191014112533epcas5p1c18bb35f34950256b625e467924b2acd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191014112533epcas5p1c18bb35f34950256b625e467924b2acd
References: <CGME20191014112533epcas5p1c18bb35f34950256b625e467924b2acd@epcas5p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the CAN Specification (see ISO 11898-1:2015, 8.3.4
Recovery Management), the M_CAN provides means for automatic
retransmission of frames that have lost arbitration or that
have been disturbed by errors during transmission. By default
automatic retransmission is enabled.

The Bosch MCAN controller has support for disabling automatic
retransmission.

To support time-triggered communication as described in ISO
11898-1:2015, chapter 9.2, the automatic retransmission may be
disabled via CCCR.DAR.

CAN_CTRLMODE_ONE_SHOT is used for disabling automatic retransmission.

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
---

changes in v2:
 - rebase to net-next

 drivers/net/can/m_can/m_can.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 386e7eb..7efafee 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -123,6 +123,7 @@ enum m_can_reg {
 #define CCCR_CME_CANFD_BRS	0x2
 #define CCCR_TXP		BIT(14)
 #define CCCR_TEST		BIT(7)
+#define CCCR_DAR		BIT(6)
 #define CCCR_MON		BIT(5)
 #define CCCR_CSR		BIT(4)
 #define CCCR_CSA		BIT(3)
@@ -1173,7 +1174,7 @@ static void m_can_chip_config(struct net_device *dev)
 	if (cdev->version == 30) {
 	/* Version 3.0.x */
 
-		cccr &= ~(CCCR_TEST | CCCR_MON |
+		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_DAR |
 			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) |
 			(CCCR_CME_MASK << CCCR_CME_SHIFT));
 
@@ -1183,7 +1184,7 @@ static void m_can_chip_config(struct net_device *dev)
 	} else {
 	/* Version 3.1.x or 3.2.x */
 		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_BRSE | CCCR_FDOE |
-			  CCCR_NISO);
+			  CCCR_NISO | CCCR_DAR);
 
 		/* Only 3.2.x has NISO Bit implemented */
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
@@ -1203,6 +1204,10 @@ static void m_can_chip_config(struct net_device *dev)
 	if (cdev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		cccr |= CCCR_MON;
 
+	/* Disable Auto Retransmission (all versions) */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		cccr |= CCCR_DAR;
+
 	/* Write config */
 	m_can_write(cdev, M_CAN_CCCR, cccr);
 	m_can_write(cdev, M_CAN_TEST, test);
@@ -1348,7 +1353,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 	m_can_dev->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 					CAN_CTRLMODE_LISTENONLY |
 					CAN_CTRLMODE_BERR_REPORTING |
-					CAN_CTRLMODE_FD;
+					CAN_CTRLMODE_FD |
+					CAN_CTRLMODE_ONE_SHOT;
 
 	/* Set properties depending on M_CAN version */
 	switch (m_can_dev->version) {
-- 
2.7.4

