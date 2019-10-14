Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB2D6167
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 13:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfJNLek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 07:34:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12358 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbfJNLej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 07:34:39 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191014113438epoutp01e6b1845c15ab7b2a75e0ae25a35fdf98~NgETOHExx3102131021epoutp01B
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 11:34:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191014113438epoutp01e6b1845c15ab7b2a75e0ae25a35fdf98~NgETOHExx3102131021epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571052878;
        bh=gf2qJABaMWfMWjFiR+zwX+nr8GwXpv4GRejuLznSm/Q=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Ti7hzs2nTkWgRguCHG0OH4FOPhxEuFo2hFDvTnHId8RuO2d0qM4XCSzligIAWlOaE
         Nu0q5psN2Yu4W9KiCcY+0caLkLODaJqKVAJ0/Af2fBSXih8kk05TsJcFt1AvF6g0YQ
         tRyyTqcn6VzsJlnOdQjsP64lhiMsSkhUTO/asmyE=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20191014113437epcas5p475242e84737ef3c428d395ffff7fb96f~NgESvndv10522205222epcas5p4h;
        Mon, 14 Oct 2019 11:34:37 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.A7.04480.D4D54AD5; Mon, 14 Oct 2019 20:34:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20191014113437epcas5p2143d7e85d5a50dad79a4a60a9d666fe4~NgESVwHHK2579225792epcas5p2F;
        Mon, 14 Oct 2019 11:34:37 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191014113437epsmtrp18bc220f6f4e9bdffd288cb47f25bc757~NgESVDIto0909409094epsmtrp1b;
        Mon, 14 Oct 2019 11:34:37 +0000 (GMT)
X-AuditID: b6c32a4b-cbbff70000001180-ee-5da45d4d5640
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.DF.03889.C4D54AD5; Mon, 14 Oct 2019 20:34:37 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191014113435epsmtip27fa5e187947b3d40dc0af4124130e886~NgEQn_itW2251522515epsmtip2X;
        Mon, 14 Oct 2019 11:34:35 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        eugen.hristev@microchip.com, ludovic.desroches@microchip.com,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH] can: m_can: add support for handling arbitration error
Date:   Mon, 14 Oct 2019 17:04:04 +0530
Message-Id: <1571052844-22633-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7bCmuq5v7JJYg2WN0hZzzrewWBz4cZzF
        YtX3qcwWl3fNYbN4sfY6q8X6RVNYLI4tELNYtPULu8XyrvvMFrMu7GC1uLGe3WLpvZ2sDjwe
        W1beZPL4eOk2o8edH0sZPfr/Gnj0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXRtvGHUwFq4Ur
        pj58xdjA2CrQxcjJISFgIrFvejd7FyMXh5DAbkaJBXNnsEA4nxglTs0+AOV8Y5S42LaNDaZl
        w/NGqJa9jBLHV9xkgnBamCRWzGhiBaliE9CTuPR+MliHiECoxLLeCawgRcwCTUwSXZt7mUES
        wgLuEl/ON4IVsQioSvS3/mYEsXkFPCR+t05gglgnJ3HzXCczSLOEwBo2idcNi6DucJE4OmE6
        C4QtLPHq+BZ2CFtK4mV/G5SdLbFwdz9QDQeQXSHRNkMYImwvceDKHLAws4CmxPpd+iBhZgE+
        id7fT5ggqnklOtqEIKrVJKY+fccIYctI3Hm0GeoAD4kJPf1gtpBArMSFFZ1sExhlZiEMXcDI
        uIpRMrWgODc9tdi0wDgvtVyvODG3uDQvXS85P3cTIzgtaHnvYNx0zucQowAHoxIPr0La4lgh
        1sSy4srcQ4wSHMxKIrwMExbECvGmJFZWpRblxxeV5qQWH2KU5mBREuedxHo1RkggPbEkNTs1
        tSC1CCbLxMEp1cCYpX7wuuGiN1aHNArb2V3W+Bpf5Mzk5vpePfOU08xvhy9vYHq9SuXORI/Q
        IyceNra8MpMM2anGOflfUeLi6RemzKuJvT9dObqceWnfkxj1g/+lX37xPOYtdj9P3XiT9tov
        5vHKHu+VVGy8zeqEV6UZ/H8aG33y/seaz/cdhU5/vVkhtPiD4c+ZSizFGYmGWsxFxYkAHyzH
        +gcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWy7bCSvK5v7JJYgxY1iznnW1gsDvw4zmKx
        6vtUZovLu+awWbxYe53VYv2iKSwWxxaIWSza+oXdYnnXfWaLWRd2sFrcWM9usfTeTlYHHo8t
        K28yeXy8dJvR486PpYwe/X8NPPq2rGL0+LxJLoAtissmJTUnsyy1SN8ugSujbeMOpoLVwhVT
        H75ibGBsFehi5OSQEDCR2PC8kR3EFhLYzSgxqTmki5EDKC4jsfhzNUSJsMTKf8+BSriASpqY
        JPqau9hAEmwCehKX3k8Gs0UEwiV2TuhiArGZBXqYJFrvJoDYwgLuEl/ON4LVsAioSvS3/mYE
        sXkFPCR+t05gglggJ3HzXCfzBEaeBYwMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcx
        gsNOS2sH44kT8YcYBTgYlXh4TyQvjhViTSwrrsw9xCjBwawkwsswYUGsEG9KYmVValF+fFFp
        TmrxIUZpDhYlcV75/GORQgLpiSWp2ampBalFMFkmDk6pBsaOmYujXH7UOSWz2W99c2I3j5er
        9eqCy1nrCmr9vcwT70r4pi8vCV68f/YHTW6n74udvi/hvLx8u3HMonfa3AqPN+3j2jYp7uwx
        7fX7N8RPXvlqz8aefy6J+dJX/m7iec+8+StrEs+NqOOzGv65xIQZ79yzqqrOfSGrhO/dF6Yz
        r6v9XSP3y0FeiaU4I9FQi7moOBEAx16cSzcCAAA=
X-CMS-MailID: 20191014113437epcas5p2143d7e85d5a50dad79a4a60a9d666fe4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191014113437epcas5p2143d7e85d5a50dad79a4a60a9d666fe4
References: <CGME20191014113437epcas5p2143d7e85d5a50dad79a4a60a9d666fe4@epcas5p2.samsung.com>
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
 drivers/net/can/m_can/m_can.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index b95b382eb308..7efafee0eec8 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -778,6 +778,39 @@ static inline bool is_lec_err(u32 psr)
 	return psr && (psr != LEC_UNUSED);
 }
 
+static inline bool is_protocol_err(u32 irqstatus)
+{
+	if (irqstatus & IR_ERR_LEC_31X)
+		return 1;
+	else
+		return 0;
+}
+
+static int m_can_handle_protocol_error(struct net_device *dev, u32 irqstatus)
+{
+	struct net_device_stats *stats = &dev->stats;
+	struct m_can_priv *priv = netdev_priv(dev);
+	struct can_frame *cf;
+	struct sk_buff *skb;
+
+	/* propagate the error condition to the CAN stack */
+	skb = alloc_can_err_skb(dev, &cf);
+	if (unlikely(!skb))
+		return 0;
+
+	if (priv->version >= 31 && (irqstatus & IR_PEA)) {
+		netdev_dbg(dev, "Protocol error in Arbitration fail\n");
+		stats->tx_errors++;
+		priv->can.can_stats.arbitration_lost++;
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
@@ -792,6 +825,11 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	    is_lec_err(psr))
 		work_done += m_can_handle_lec_err(dev, psr & LEC_UNUSED);
 
+	/* handle protocol errors in arbitration phase */
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
+	    is_protocol_err(irqstatus))
+		work_done += m_can_handle_protocol_error(dev, irqstatus);
+
 	/* other unproccessed error interrupts */
 	m_can_handle_other_err(dev, irqstatus);
 
-- 
2.17.1

