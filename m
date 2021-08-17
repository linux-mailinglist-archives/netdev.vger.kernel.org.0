Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAFC3EE4B5
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 05:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhHQDBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 23:01:08 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:14217 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhHQDBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 23:01:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GpbP66357z1CXFv;
        Tue, 17 Aug 2021 11:00:10 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 11:00:24 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 17 Aug 2021 11:00:23 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH ethtool-next] netlink: settings: add two link extended substates of bad signal integrity
Date:   Tue, 17 Aug 2021 10:56:37 +0800
Message-ID: <1629168997-24103-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two link extended substates of bad signal integrity available in the
kernel.

ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST means the input
external clock signal for SerDes is too weak or lost.

ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS means the received signal for
SerDes is too weak because analog loss of signal.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 netlink/settings.c   | 4 ++++
 uapi/linux/ethtool.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/netlink/settings.c b/netlink/settings.c
index e47a38f3058f..6d10a0703861 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -639,6 +639,10 @@ static const char *const names_bad_signal_integrity_link_ext_substate[] = {
 		"Large number of physical errors",
 	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE]		=
 		"Unsupported rate",
+	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST]	=
+		"Serdes reference clock lost",
+	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS]			=
+		"Serdes ALOS",
 };
 
 static const char *const names_cable_issue_link_ext_substate[] = {
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index c6ec1111ffa3..bd1f09b23cf5 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -637,6 +637,8 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
 enum ethtool_link_ext_substate_bad_signal_integrity {
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
-- 
2.8.1

