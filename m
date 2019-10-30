Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B6AE9AF3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 12:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfJ3Lkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 07:40:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46579 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfJ3Lkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 07:40:43 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20191030114040epoutp035b4f973245f1c6efbfd58079c01e7842~SaeJd06mh1223712237epoutp03u
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 11:40:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20191030114040epoutp035b4f973245f1c6efbfd58079c01e7842~SaeJd06mh1223712237epoutp03u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1572435640;
        bh=fcdA96fAhOZu69tylRLeTwYGvXQzPgZtuuhY+765OU8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ABv3Ut2n2+7BujH7yFVtuA0AuBmSWBvH284Iv7G43KagCFj81W0PSw3sN2TvB6XaJ
         IICWih3SG8MwR7/AJ6LjMTO2j2Md+A9gHHKYcjLMpZKV2S5mDrR0PSsId+dqWWbH9L
         3pL1kSqUz0hH/3gD8vyHFO/SUsGcdtf3HmGOFzro=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191030114040epcas5p18fd2ddd084238197f6242694a5750ef0~SaeIsO9Dw0210402104epcas5p1h;
        Wed, 30 Oct 2019 11:40:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.B7.20293.7B679BD5; Wed, 30 Oct 2019 20:40:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191030114039epcas5p434c9a7ffb715f2af2f4d3745239b5bbd~SaeIOjiJk1697616976epcas5p4p;
        Wed, 30 Oct 2019 11:40:39 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191030114039epsmtrp26d1364d554fa887d94beb3389434335c~SaeINYQAW0981509815epsmtrp2D;
        Wed, 30 Oct 2019 11:40:39 +0000 (GMT)
X-AuditID: b6c32a49-fe3ff70000014f45-6a-5db976b7dee7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.FA.25663.7B679BD5; Wed, 30 Oct 2019 20:40:39 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191030114037epsmtip1fabd0f9fcb22cabe2e38eeae9d36a063~SaeGn5Kma3254032540epsmtip1j;
        Wed, 30 Oct 2019 11:40:37 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        jhofstee@victronenergy.com, simon.horman@netronome.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH v3] can: m_can: add support for handling arbitration error
Date:   Wed, 30 Oct 2019 17:08:59 +0530
Message-Id: <1572435539-3315-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7bCmuu72sp2xBlemW1rMOd/CYrHi/T5W
        i1XfpzJbXN41h81i/aIpLBbHFohZLNr6hd1iedd9ZotZF3awWtzYyWlxYz27xdJ7O1kdeDy2
        rLzJ5PHx0m1Gj+ndD5k9+v8aePRtWcXo8XmTnMekgx/YA9ijuGxSUnMyy1KL9O0SuDK+NUxl
        KbgrVnFs732mBsZ7Ql2MnBwSAiYSd888Y+9i5OIQEtjNKHF1axc7SEJI4BOjRPMFQ4jEN0aJ
        +YtuMcF0bH25khUisZdR4mTfU2YIp4VJ4sDsflaQKjYBPYlL7yezgdgiAqESy3ongHUwC/xh
        lOg68Y8FJCEs4CVxoL0RrIhFQFVi2fxpYHFeAXeJ+0camSHWyUncPNcJtkFCYAubxLeZP1gh
        Ei4SR5/tgLKFJV4d38IOYUtJfH63lw3CzpZYuLsfaCgHkF0h0TZDGCJsL3HgyhywMLOApsT6
        XfogYWYBPone30+YIKp5JTraoEGkJjH16TtGCFtG4s6jzWwQJR4SF97LQgIrVuLt850sExhl
        ZiHMXMDIuIpRMrWgODc9tdi0wDAvtVyvODG3uDQvXS85P3cTIzg1aHnuYJx1zucQowAHoxIP
        7wRgyhBiTSwrrsw9xCjBwawkwvvNBijEm5JYWZValB9fVJqTWnyIUZqDRUmcdxLr1RghgfTE
        ktTs1NSC1CKYLBMHp1QDY2F92vL8syVPPQ2/ST7REXE/v5Vz+i3XM798l+3s8zq3/Fvmpnv3
        mhnP+vQ8WVIR+aRb79KTqa/yv+4u2clQnbR24YrIH5kpm9xldzkLvusKbT6YP2mCf/Ljw5d0
        HvCdZPN3OVy6t9N3f3PDqra9KTx39ZmXse1IzWM6HP6vwOf9nx8s/htDPZVYijMSDbWYi4oT
        AQUE4X4JAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsWy7bCSnO72sp2xBhc2ylrMOd/CYrHi/T5W
        i1XfpzJbXN41h81i/aIpLBbHFohZLNr6hd1iedd9ZotZF3awWtzYyWlxYz27xdJ7O1kdeDy2
        rLzJ5PHx0m1Gj+ndD5k9+v8aePRtWcXo8XmTnMekgx/YA9ijuGxSUnMyy1KL9O0SuDK+NUxl
        KbgrVnFs732mBsZ7Ql2MnBwSAiYSW1+uZO1i5OIQEtjNKPHqwjsghwMoISOx+HM1RI2wxMp/
        z9khapqYJBov/mIGSbAJ6Elcej+ZDcQWEQiX2DmhiwmkiFmgjUni9fcDrCAJYQEviQPtjWBF
        LAKqEsvmT2MBsXkF3CXuH2lkhtggJ3HzXCfzBEaeBYwMqxglUwuKc9Nziw0LjPJSy/WKE3OL
        S/PS9ZLzczcxgoNQS2sH44kT8YcYBTgYlXh4JwCDU4g1say4MvcQowQHs5II7zcboBBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXFe+fxjkUIC6YklqdmpqQWpRTBZJg5OqQZG4XdzhKuUw/cqdiSE
        SrW3BCmdumdntk35yLfaVXebmH/PmDbh/fFqTSFDnf0LsoKFy69YHn2ZX3Btw9TrvhP0xcvm
        XZXpeLL7SORsvs9XnNzmRhdP276uhL1imVn7aWuB5jk3Jv5YYrz3yxs20wnflgnMVfMMXu2X
        e/ZtD/OGuVccXKNyFNfdUWIpzkg01GIuKk4EAIwcxgc+AgAA
X-CMS-MailID: 20191030114039epcas5p434c9a7ffb715f2af2f4d3745239b5bbd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191030114039epcas5p434c9a7ffb715f2af2f4d3745239b5bbd
References: <CGME20191030114039epcas5p434c9a7ffb715f2af2f4d3745239b5bbd@epcas5p4.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Bosch MCAN hardware (3.1.0 and above) supports interrupt flag to
detect Protocol error in arbitration phase.

Transmit error statistics is currently not updated from the MCAN driver.
Protocol error in arbitration phase is a TX error and the network
statistics should be updated accordingly.

The member "tx_error" of "struct net_device_stats" should be incremented
as arbitration is a transmit protocol error. Also "arbitration_lost" of
"struct can_device_stats" should be incremented to report arbitration
lost.

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
---

changes in v3:
- handle arbitration lost stats even if the allocation of the skb fails

changes in v2:
- common m_can_ prefix for is_protocol_err function
- handling stats even if the allocation of the skb fails
- resolving build errors on net-next branch

 drivers/net/can/m_can/m_can.c | 42 +++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 75e7490c4299..02c5795b7393 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -778,6 +778,43 @@ static inline bool is_lec_err(u32 psr)
 	return psr && (psr != LEC_UNUSED);
 }
 
+static inline bool m_can_is_protocol_err(u32 irqstatus)
+{
+	return irqstatus & IR_ERR_LEC_31X;
+}
+
+static int m_can_handle_protocol_error(struct net_device *dev, u32 irqstatus)
+{
+	struct net_device_stats *stats = &dev->stats;
+	struct m_can_classdev *cdev = netdev_priv(dev);
+	struct can_frame *cf;
+	struct sk_buff *skb;
+
+	/* propagate the error condition to the CAN stack */
+	skb = alloc_can_err_skb(dev, &cf);
+
+	/* update tx error stats since there is protocol error */
+	stats->tx_errors++;
+
+	/* update arbitration lost status */
+	if (cdev->version >= 31 && (irqstatus & IR_PEA)) {
+		netdev_dbg(dev, "Protocol error in Arbitration fail\n");
+		cdev->can.can_stats.arbitration_lost++;
+		if (skb) {
+			cf->can_id |= CAN_ERR_LOSTARB;
+			cf->data[0] |= CAN_ERR_LOSTARB_UNSPEC;
+		}
+	}
+
+	if (unlikely(!skb)) {
+		netdev_dbg(dev, "allocation of skb failed\n");
+		return 0;
+	}
+	netif_receive_skb(skb);
+
+	return 1;
+}
+
 static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 				   u32 psr)
 {
@@ -792,6 +829,11 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	    is_lec_err(psr))
 		work_done += m_can_handle_lec_err(dev, psr & LEC_UNUSED);
 
+	/* handle protocol errors in arbitration phase */
+	if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
+	    m_can_is_protocol_err(irqstatus))
+		work_done += m_can_handle_protocol_error(dev, irqstatus);
+
 	/* other unproccessed error interrupts */
 	m_can_handle_other_err(dev, irqstatus);
 
-- 
2.17.1

