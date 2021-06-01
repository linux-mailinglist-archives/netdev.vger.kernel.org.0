Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D046396E06
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhFAHjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:39:17 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:32900 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAHjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:39:16 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1517bRh15010689, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1517bRh15010689
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 1 Jun 2021 15:37:27 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 1 Jun 2021 15:37:27 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 1 Jun 2021
 15:37:26 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: support pauseparam of ethtool_ops
Date:   Tue, 1 Jun 2021 15:37:12 +0800
Message-ID: <1394712342-15778-366-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/01/2021 07:21:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzYvMSCkV6TIIDA2OjIyOjAw?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/01/2021 07:19:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164034 [Jun 01 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/01/2021 07:21:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support get_pauseparam and set_pauseparam of ethtool_ops.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 75 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f6abb2fbf972..21e6b9b6776c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8967,6 +8967,79 @@ static int rtl8152_set_ringparam(struct net_device *netdev,
 	return 0;
 }
 
+static void rtl8152_get_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	u16 bmcr, lcladv, rmtadv;
+	u8 cap;
+
+	if (usb_autopm_get_interface(tp->intf) < 0)
+		return;
+
+	mutex_lock(&tp->control);
+
+	bmcr = r8152_mdio_read(tp, MII_BMCR);
+	lcladv = r8152_mdio_read(tp, MII_ADVERTISE);
+	rmtadv = r8152_mdio_read(tp, MII_LPA);
+
+	mutex_unlock(&tp->control);
+
+	usb_autopm_put_interface(tp->intf);
+
+	if (!(bmcr & BMCR_ANENABLE)) {
+		pause->autoneg = 0;
+		pause->rx_pause = 0;
+		pause->tx_pause = 0;
+		return;
+	}
+
+	pause->autoneg = 1;
+
+	cap = mii_resolve_flowctrl_fdx(lcladv, rmtadv);
+
+	if (cap & FLOW_CTRL_RX)
+		pause->rx_pause = 1;
+
+	if (cap & FLOW_CTRL_TX)
+		pause->tx_pause = 1;
+}
+
+static int rtl8152_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	u16 old, new1;
+	u8 cap = 0;
+	int ret;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&tp->control);
+
+	if (pause->autoneg && !(r8152_mdio_read(tp, MII_BMCR) & BMCR_ANENABLE)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (pause->rx_pause)
+		cap |= FLOW_CTRL_RX;
+
+	if (pause->tx_pause)
+		cap |= FLOW_CTRL_TX;
+
+	old = r8152_mdio_read(tp, MII_ADVERTISE);
+	new1 = (old & ~(ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM)) | mii_advertise_flowctrl(cap);
+	if (old != new1)
+		r8152_mdio_write(tp, MII_ADVERTISE, new1);
+
+out:
+	mutex_unlock(&tp->control);
+	usb_autopm_put_interface(tp->intf);
+
+	return ret;
+}
+
 static const struct ethtool_ops ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo = rtl8152_get_drvinfo,
@@ -8989,6 +9062,8 @@ static const struct ethtool_ops ops = {
 	.set_tunable = rtl8152_set_tunable,
 	.get_ringparam = rtl8152_get_ringparam,
 	.set_ringparam = rtl8152_set_ringparam,
+	.get_pauseparam = rtl8152_get_pauseparam,
+	.set_pauseparam = rtl8152_set_pauseparam,
 };
 
 static int rtl8152_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
-- 
2.26.3

