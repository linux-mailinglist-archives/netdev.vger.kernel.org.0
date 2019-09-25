Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C14BDD62
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404576AbfIYLqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:46:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36415 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391227AbfIYLqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:46:13 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190925114611epoutp02ebf74bc0df9145e8f609a9d402ad5c6e~Hq99wLKKH1211212112epoutp02b
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 11:46:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190925114611epoutp02ebf74bc0df9145e8f609a9d402ad5c6e~Hq99wLKKH1211212112epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1569411971;
        bh=HS47KaLUho15X7wWEEKA9dUhxdfUuW8/TC3l0iwl1rI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qyGAW8VU6XqAtwwWXNODM4FZ8zrQjsAAQQV8i/dW16oNiQkl+oIKcBhsfo8+deGwO
         DzQ+JUL6V8ZmgPSGaUatfhb4npi8rajfgmWmwoJpSVqSVjqDx1FIbUtW+QeDS2hDXt
         6rANX3OFHi5GXJxNMIO/fF/0jUf3nPpps4S58vyo=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20190925114610epcas5p3f604e0aa42b25c89757c0f19b5ee5949~Hq981wlmF1049010490epcas5p3n;
        Wed, 25 Sep 2019 11:46:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.19.04647.2835B8D5; Wed, 25 Sep 2019 20:46:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758~Hq98GF5Gj1049110491epcas5p3y;
        Wed, 25 Sep 2019 11:46:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190925114609epsmtrp251be14c041d0996b412a4014cb09c426~Hq98FVKyJ1880618806epsmtrp2e;
        Wed, 25 Sep 2019 11:46:09 +0000 (GMT)
X-AuditID: b6c32a49-743ff70000001227-f7-5d8b53824e25
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.36.04081.1835B8D5; Wed, 25 Sep 2019 20:46:09 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190925114607epsmtip2a54c7283b1b38a6bdaa5dfccdaed83a5~Hq96b5ac10143401434epsmtip2T;
        Wed, 25 Sep 2019 11:46:07 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        eugen.hristev@microchip.com, ludovic.desroches@microchip.com,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH] can: m_can: add support for one shot mode
Date:   Wed, 25 Sep 2019 17:15:04 +0530
Message-Id: <1569411904-6319-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWy7bCmpm5TcHeswbU9QhZzzrewWBz4cZzF
        YtX3qcwWl3fNYbN4sfY6q8X6RVNYLI4tELNYtPULu8XyrvvMFrMu7GC1uLGe3WLpvZ2sDjwe
        W1beZPL4eOk2o8edH0sZPfr/Gnj0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxu+mg2wFX0Uq
        Hp15z9zA2CvYxcjBISFgInHsekEXIxeHkMBuRonLZ04zQzifGCV+P7jLBuF8Y5R4+qYZKMMJ
        1rHy82x2iMReRon7r9awQDgtTBJb3v0Fq2IT0JO49H4yG4gtIhAqsax3AitIEbNAE5NE1+Ze
        sCJhASuJNXd2MoHYLAKqEg2dvYwgNq+Au8SNfwvYINbJSdw81wl2lITABjaJp6/+QSVcJO5M
        +MIOYQtLvDq+BcqWkvj8bi9UTbbEwt39LBCfVki0zRCGCNtLHLgyByzMLKApsX6XPkiYWYBP
        ovf3EyaIal6JjjYhiGo1ialP3zFC2DISdx5tZoMo8ZA4dL8QJCwkECvx/8xHlgmMMrMQZi5g
        ZFzFKJlaUJybnlpsWmCYl1quV5yYW1yal66XnJ+7iRGcErQ8dzDOOudziFGAg1GJh9eBtStW
        iDWxrLgy9xCjBAezkgjvLBmgEG9KYmVValF+fFFpTmrxIUZpDhYlcd5JrFdjhATSE0tSs1NT
        C1KLYLJMHJxSDYzKf8p2BJxptn3++J9GxILm6kQ+Qb33+3uffUvWaBG72PrhmI/r4QjnPpP/
        t/eWe+tlLNE+q1NuILEoe6F4buQhwc3KN2YwnzXecHZDnKz7w1cPTr9YciVXcNLO+tj+B7Vr
        LW38Chd8XLIufsKF6GbGlb4CkX5bP5mFVF6+9XPjiUs/s5x31norsRRnJBpqMRcVJwIAOnfC
        mgUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSvG5jcHesweIGaYs551tYLA78OM5i
        ser7VGaLy7vmsFm8WHud1WL9oiksFscWiFks2vqF3WJ5131mi1kXdrBa3FjPbrH03k5WBx6P
        LStvMnl8vHSb0ePOj6WMHv1/DTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr43fTQbaCryIV
        j868Z25g7BXsYuTkkBAwkVj5eTZ7FyMXh5DAbkaJ2y03GLsYOYASMhKLP1dD1AhLrPz3nB3E
        FhJoYpJYec0IxGYT0JO49H4yG4gtIhAusXNCFxOIzSzQwyTRejcBxBYWsJJYc2cnWJxFQFWi
        obOXEcTmFXCXuPFvARvEfDmJm+c6mScw8ixgZFjFKJlaUJybnltsWGCYl1quV5yYW1yal66X
        nJ+7iREceFqaOxgvL4k/xCjAwajEw+vA2hUrxJpYVlyZe4hRgoNZSYR3lgxQiDclsbIqtSg/
        vqg0J7X4EKM0B4uSOO/TvGORQgLpiSWp2ampBalFMFkmDk6pBsZyJ93SbO51987kK7K/tw/Z
        uTgg5Mf+nKbbr6ZkeGyY4rhkTvMhvpWe02+8cZY9VbFOYOLT/SlsT6Vmlj9d9kr0qtepVwL5
        n0Vu8Zp8nCV+dtU3Dpka2e3mWTec3yucuDp7AtfhNUznT58qebU6+4/U/lin8OV5Yu59MX7y
        J5fvOLOypPnllo5jSizFGYmGWsxFxYkA34eIDDgCAAA=
X-CMS-MailID: 20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758
References: <CGME20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758@epcas5p3.samsung.com>
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
 drivers/net/can/m_can/m_can.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index deb274a19ba0..e7165404ba8a 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -150,6 +150,7 @@ enum m_can_mram_cfg {
 #define CCCR_CME_CANFD_BRS	0x2
 #define CCCR_TXP		BIT(14)
 #define CCCR_TEST		BIT(7)
+#define CCCR_DAR		BIT(6)
 #define CCCR_MON		BIT(5)
 #define CCCR_CSR		BIT(4)
 #define CCCR_CSA		BIT(3)
@@ -1123,7 +1124,7 @@ static void m_can_chip_config(struct net_device *dev)
 	if (priv->version == 30) {
 	/* Version 3.0.x */
 
-		cccr &= ~(CCCR_TEST | CCCR_MON |
+		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_DAR |
 			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) |
 			(CCCR_CME_MASK << CCCR_CME_SHIFT));
 
@@ -1133,7 +1134,7 @@ static void m_can_chip_config(struct net_device *dev)
 	} else {
 	/* Version 3.1.x or 3.2.x */
 		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_BRSE | CCCR_FDOE |
-			  CCCR_NISO);
+			  CCCR_NISO | CCCR_DAR);
 
 		/* Only 3.2.x has NISO Bit implemented */
 		if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
@@ -1153,6 +1154,10 @@ static void m_can_chip_config(struct net_device *dev)
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		cccr |= CCCR_MON;
 
+	/* Disable Auto Retransmission (all versions) */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		cccr |= CCCR_DAR;
+
 	/* Write config */
 	m_can_write(priv, M_CAN_CCCR, cccr);
 	m_can_write(priv, M_CAN_TEST, test);
@@ -1291,7 +1296,8 @@ static int m_can_dev_setup(struct platform_device *pdev, struct net_device *dev,
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 					CAN_CTRLMODE_LISTENONLY |
 					CAN_CTRLMODE_BERR_REPORTING |
-					CAN_CTRLMODE_FD;
+					CAN_CTRLMODE_FD |
+					CAN_CTRLMODE_ONE_SHOT;
 
 	/* Set properties depending on M_CAN version */
 	switch (priv->version) {
-- 
2.17.1

