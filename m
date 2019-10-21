Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E15DDEB8C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfJUMFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:05:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33163 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbfJUMFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 08:05:17 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20191021120514epoutp0443438bbd138cd892d532eefcbe3ae51e~PqABW9iGr0292302923epoutp04H
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:05:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20191021120514epoutp0443438bbd138cd892d532eefcbe3ae51e~PqABW9iGr0292302923epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571659514;
        bh=eION/f0Ms9Y49xzcf6LTMM0EdjvsR4RvafdknSwNs2k=;
        h=From:To:Cc:Subject:Date:References:From;
        b=N36qU5OrYTP3gqJa9Z/kHl3omqRINNbGFE7BCSfdBW0D0d+v5nlU572qg23ba+JIV
         c96J02APiH/Qi7wwWCfHMMEefTZ10KQ/OpA9FbNwhvNQJBMsUfLThXdbaHKETXdf/s
         GDmhz6S2NKELzlsDZELIExbmmq8vgKOslJ8dlxTc=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191021120513epcas5p14267e3272efd912f4d743c3941bd1bf1~PqAAwvva40695206952epcas5p13;
        Mon, 21 Oct 2019 12:05:13 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.A7.04480.9FE9DAD5; Mon, 21 Oct 2019 21:05:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60~PqAAec8Xk1113111131epcas5p2I;
        Mon, 21 Oct 2019 12:05:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191021120513epsmtrp16f2e2f34d3c8bc7e51b53b96e0e16197~PqAAduvk42573625736epsmtrp1h;
        Mon, 21 Oct 2019 12:05:13 +0000 (GMT)
X-AuditID: b6c32a4b-cbbff70000001180-8c-5dad9ef9e249
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.CF.04081.9FE9DAD5; Mon, 21 Oct 2019 21:05:13 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191021120511epsmtip231b786b1a318310976b8dac13f821ad4~Pp-_tQGCt0303503035epsmtip2s;
        Mon, 21 Oct 2019 12:05:11 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        eugen.hristev@microchip.com, ludovic.desroches@microchip.com,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH v3] can: m_can: add support for one shot mode
Date:   Mon, 21 Oct 2019 17:34:40 +0530
Message-Id: <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWy7bCmuu7PeWtjDW7c1baYc76FxeLAj+Ms
        Fqu+T2W2uLxrDpvFi7XXWS3WL5rCYnFsgZjFoq1f2C2Wd91ntph1YQerxY317BZL7+1kdeDx
        2LLyJpPHx0u3GT3u/FjK6NH/18Cjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4Mqb0NDEVXBSt
        OLt/EmsD4wXBLkZODgkBE4kTt9rZuhi5OIQEdjNKXLp6hAUkISTwiVHi9ZtSiMQ3Ronbyyew
        wHRceg5TtJdR4taKMIiiFiaJwytugyXYBPQkLr2fzAZiiwiESizrncAKUsQs0MQk0bW5lxkk
        ISxgK7H50l8mEJtFQFXi5M83YHFeAQ+JtrnT2SC2yUncPNfJDNIsIbCFTWLulaesEAkXiQXb
        jjFD2MISr45vYYewpSRe9rdB2dkSC3f3A13EAWRXSLTNEIYI20scuDIHLMwsoCmxfpc+SJhZ
        gE+i9/cTJohqXomONiGIajWJqU/fMULYMhJ3Hm2GusxD4sO2E6yQcIiVePbrB/sERplZCEMX
        MDKuYpRMLSjOTU8tNi0wzkst1ytOzC0uzUvXS87P3cQITgla3jsYN53zOcQowMGoxMPrMH1N
        rBBrYllxZe4hRgkOZiUR3jsGa2OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ805ivRojJJCeWJKa
        nZpakFoEk2Xi4JRqYMxqduK7L7gx1/X45s//X76y2fnroovk51kt/poT7fbUFr/6dzma40C+
        +wTWTeqV935ayBe+O5z9WTFkhe0N5uDw05KT2ssfnTnuLPTvQNP5PbYW33TNT/77INVmGWe0
        8Pjre5suPhWYk/uk+q26xF6drmsTv/h3re+sm+9WkulZ8PWZDduP44uVWIozEg21mIuKEwGT
        6kdcBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsWy7bCSvO7PeWtjDXoahC3mnG9hsTjw4ziL
        xarvU5ktLu+aw2bxYu11Vov1i6awWBxbIGaxaOsXdovlXfeZLWZd2MFqcWM9u8XSeztZHXg8
        tqy8yeTx8dJtRo87P5YyevT/NfDo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujCk9TUwFF0Ur
        zu6fxNrAeEGwi5GTQ0LAROLS8yMsXYxcHEICuxkl2mavYu5i5ABKyEgs/lwNUSMssfLfc3aI
        miYmiR1/T7OAJNgE9CQuvZ/MBmKLCIRL7JzQxQRiMwv0MEm03k0AsYUFbCU2X/oLFmcRUJU4
        +fMNM4jNK+Ah0TZ3OhvEAjmJm+c6mScw8ixgZFjFKJlaUJybnltsWGCYl1quV5yYW1yal66X
        nJ+7iREcelqaOxgvL4k/xCjAwajEw+swfU2sEGtiWXFl7iFGCQ5mJRHeOwZrY4V4UxIrq1KL
        8uOLSnNSiw8xSnOwKInzPs07FikkkJ5YkpqdmlqQWgSTZeLglGpgVMm69XBxHOvrD5dzUp9f
        CH6goOzYplnvPbPUjcuq6tvRcJ/Dz3gXrFvGG115vbGv8pqc0+c3rfEdG1/Pmme708bo01Sp
        6a17r7/Ybnm9XuvvpZOvvDwmLo+dlPpfax3/mcIz8VfqLnbcuj/xvr6veMiCV8k/4pOtjf5M
        /fauvOncRPt3YtmntiuxFGckGmoxFxUnAgB+bzbDOQIAAA==
X-CMS-MailID: 20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60
References: <CGME20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60@epcas5p2.samsung.com>
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

changes in v3: 
- resolving build errors for net-next branch

changes in v2:
- rebase to net-next

 drivers/net/can/m_can/m_can.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 562c8317e3aa..75e7490c4299 100644
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
@@ -1135,7 +1136,7 @@ static void m_can_chip_config(struct net_device *dev)
 	if (cdev->version == 30) {
 	/* Version 3.0.x */
 
-		cccr &= ~(CCCR_TEST | CCCR_MON |
+		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_DAR |
 			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) |
 			(CCCR_CME_MASK << CCCR_CME_SHIFT));
 
@@ -1145,7 +1146,7 @@ static void m_can_chip_config(struct net_device *dev)
 	} else {
 	/* Version 3.1.x or 3.2.x */
 		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_BRSE | CCCR_FDOE |
-			  CCCR_NISO);
+			  CCCR_NISO | CCCR_DAR);
 
 		/* Only 3.2.x has NISO Bit implemented */
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
@@ -1165,6 +1166,10 @@ static void m_can_chip_config(struct net_device *dev)
 	if (cdev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		cccr |= CCCR_MON;
 
+	/* Disable Auto Retransmission (all versions) */
+	if (cdev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		cccr |= CCCR_DAR;
+
 	/* Write config */
 	m_can_write(cdev, M_CAN_CCCR, cccr);
 	m_can_write(cdev, M_CAN_TEST, test);
@@ -1310,7 +1315,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 	m_can_dev->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 					CAN_CTRLMODE_LISTENONLY |
 					CAN_CTRLMODE_BERR_REPORTING |
-					CAN_CTRLMODE_FD;
+					CAN_CTRLMODE_FD |
+					CAN_CTRLMODE_ONE_SHOT;
 
 	/* Set properties depending on M_CAN version */
 	switch (m_can_dev->version) {
-- 
2.17.1

