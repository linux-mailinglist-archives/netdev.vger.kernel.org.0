Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1BDEBC2
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfJUMNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:13:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62383 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfJUMNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 08:13:55 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20191021121352epoutp0211325231582284a34fc49b4f14b7c720~PqHjjcT3J0216302163epoutp02T
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:13:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20191021121352epoutp0211325231582284a34fc49b4f14b7c720~PqHjjcT3J0216302163epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571660032;
        bh=IO3ukgqRMSs5HK7E5ErftQstNvRbP6iQqkoooqC05YU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=WI3RzQXU+oT9fDSOsey1vJ3z+3O5bHF+XP1oju1lqDfmXGM3nAHJDz0Inn/bxgVln
         m18hzfJNyk7Hsb93YukqRFVWZv9CR2Vurwj3F7hLoRWsJySGS38jWVhXvqBmJ+8rKE
         c6BASP12vqcLKnW5SqmO3MKEAUZ7WAZ9QNIAX74U=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191021121351epcas5p13ef60321fe49e17a3b527b6b0758b0eb~PqHjHSFGq1391813918epcas5p1l;
        Mon, 21 Oct 2019 12:13:51 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.B8.04480.FF0ADAD5; Mon, 21 Oct 2019 21:13:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78~PqHieWDCw2562125621epcas5p3D;
        Mon, 21 Oct 2019 12:13:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191021121350epsmtrp21c0fb01e88a9a1b608b6a547ab25a28e~PqHidg0CO2033120331epsmtrp2B;
        Mon, 21 Oct 2019 12:13:50 +0000 (GMT)
X-AuditID: b6c32a4b-cbbff70000001180-82-5dada0ff2a7a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.00.04081.EF0ADAD5; Mon, 21 Oct 2019 21:13:50 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191021121348epsmtip1c366be94b1f5180dae6dd06ecf441435~PqHgSjX1e1119511195epsmtip1K;
        Mon, 21 Oct 2019 12:13:48 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        eugen.hristev@microchip.com, ludovic.desroches@microchip.com,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        jhofstee@victronenergy.com, simon.horman@netronome.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH v2] can: m_can: add support for handling arbitration error
Date:   Mon, 21 Oct 2019 17:43:36 +0530
Message-Id: <1571660016-29726-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42LZdlhTQ/f/grWxBhsnq1nMOd/CYnHgx3EW
        ixXv97FarPo+ldni8q45bBYv1l5ntVi/aAqLxbEFYhaLtn5ht1jedZ/ZYtaFHawWN3ZyWtxY
        z26x9N5OVgc+jy0rbzJ5fLx0m9Hjzo+ljB7Tux8ye/T/NfDo27KK0ePzJjmPSQc/sAdwRHHZ
        pKTmZJalFunbJXBlnNo+kblgpmjFlx/trA2M5wS7GDk5JARMJJqe72LrYuTiEBLYzSix/t01
        KOcTo8S8J30sEM43Rom+5x9Zuxg5wFoO7SuBiO9llDi1+jsjhNPCJDHhx0N2kLlsAnoSl95P
        ZgOxRQRCJZb1TmAFKWIW2MMksXb6arCEsICXxIwzx8FsFgFViWt7ljCC2LwCHhJ79u9igzhQ
        TuLmuU5mkGYJgTNsEp3vJrNCJFwk1r5/wg5hC0u8Or4FypaS+PxuL1RztsTC3f0sEGdXSLTN
        EIYI20scuDIHLMwsoCmxfpc+SJhZgE+i9/cTJohqXomONiGIajWJqU/fMULYMhJ3Hm2GGu4h
        8frNPLBjhARiJZa+P842gVFmFsLQBYyMqxglUwuKc9NTi00LjPNSy/WKE3OLS/PS9ZLzczcx
        glOHlvcOxk3nfA4xCnAwKvHwOkxfEyvEmlhWXJl7iFGCg1lJhPeOwdpYId6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4ryTWK/GCAmkJ5akZqemFqQWwWSZODilGhjjP1yQXaQ31y3x2n/OC5/nXaoP
        +Lluq3JjbMz7mDSzpWdnbbMUuPL2wAfv07NUHuQcdjR78Sxqs7Gn7tSeA6FNE3RE1dg9Zduf
        5Lwt8st33Hqb6/vphfK6+xvXLZSrzjnWFdoUeYRxwgcH3e8B1gyyF4/YMl73tuEtLPoqf/qb
        o9iuWQ2vvq5XYinOSDTUYi4qTgQAZU62DxkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSnO6/BWtjDY52GFjMOd/CYnHgx3EW
        ixXv97FarPo+ldni8q45bBYv1l5ntVi/aAqLxbEFYhaLtn5ht1jedZ/ZYtaFHawWN3ZyWtxY
        z26x9N5OVgc+jy0rbzJ5fLx0m9Hjzo+ljB7Tux8ye/T/NfDo27KK0ePzJjmPSQc/sAdwRHHZ
        pKTmZJalFunbJXBlnNo+kblgpmjFlx/trA2M5wS7GDk4JARMJA7tK+li5OQQEtjNKNHe7QsR
        lpFY/LkaJCwhICyx8t9zdoiSJiaJNfdlQGw2AT2JS+8ns4HYIgLhEjsndDF1MXJxMAucYJI4
        9uMuK0hCWMBLYsaZ42BFLAKqEtf2LGEEsXkFPCT27N/FBrFATuLmuU7mCYw8CxgZVjFKphYU
        56bnFhsWGOallusVJ+YWl+al6yXn525iBAenluYOxstL4g8xCnAwKvHwOkxfEyvEmlhWXJl7
        iFGCg1lJhPeOwdpYId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxP845FCgmkJ5akZqemFqQWwWSZ
        ODilGhgTzZ5e6Z1XJH9n2kp7u5+Xlnaetn5+jG3fhJrkLSEmgVXVpjdin82cuq4s86Lspcwt
        flPdOb7bc32e2bch7MXHe5qFQhN9big0RfRZqb2M/FxTv3Nvu4P/inJmLvGrAmc/WKlfyT/3
        NmJfzCSNuQ9WWFlZcfrusWXNCZvtOjXK4Aqv7xr2L/+UWIozEg21mIuKEwHx7U4MSgIAAA==
X-CMS-MailID: 20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78
References: <CGME20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78@epcas5p3.samsung.com>
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

changes in v2:
- common m_can_ prefix for is_protocol_err function
- handling stats even if the allocation of the skb fails
- resolving build errors on net-next branch

 drivers/net/can/m_can/m_can.c | 37 +++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 75e7490c4299..a736297a875f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -778,6 +778,38 @@ static inline bool is_lec_err(u32 psr)
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
+	if (unlikely(!skb)) {
+		netdev_dbg(dev, "allocation of skb failed\n");
+		stats->tx_errors++;
+		return 0;
+	}
+	if (cdev->version >= 31 && (irqstatus & IR_PEA)) {
+		netdev_dbg(dev, "Protocol error in Arbitration fail\n");
+		stats->tx_errors++;
+		cdev->can.can_stats.arbitration_lost++;
+		cf->can_id |= CAN_ERR_LOSTARB;
+		cf->data[0] |= CAN_ERR_LOSTARB_UNSPEC;
+	}
+
+	netif_receive_skb(skb);
+
+	return 1;
+}
+
 static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 				   u32 psr)
 {
@@ -792,6 +824,11 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
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

