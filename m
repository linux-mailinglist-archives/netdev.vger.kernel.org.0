Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF447A619
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbhLTIgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:36:48 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30075 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbhLTIgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 03:36:47 -0500
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JHXtC3TsMz1DJtQ;
        Mon, 20 Dec 2021 16:33:39 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 16:36:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 16:36:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>
Subject: [PATCH ethtool-next 2/2] ethtool: netlink: add support to get/set tx copybreak buf size
Date:   Mon, 20 Dec 2021 16:31:55 +0800
Message-ID: <20211220083155.39882-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211220083155.39882-1-huangguangbin2@huawei.com>
References: <20211220083155.39882-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add support for "ethtool --set-tunable <dev> tx-buf-size xxx"
and "ethtool --get-tunable <dev> tx-buf-size" to set/get
tx copybreak buf size.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 0dc3559..5d718a2 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5009,6 +5009,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_ID_UNSPEC]		= "Unspec",
 	[ETHTOOL_RX_COPYBREAK]		= "rx-copybreak",
 	[ETHTOOL_TX_COPYBREAK]		= "tx-copybreak",
+	[ETHTOOL_TX_COPYBREAK_BUF_SIZE] = "tx-buf-size",
 	[ETHTOOL_PFC_PREVENTION_TOUT]	= "pfc-prevention-tout",
 };
 
@@ -5048,6 +5049,11 @@ static struct ethtool_tunable_info tunables_info[] = {
 	  .size		= sizeof(u16),
 	  .type		= CMDL_U16,
 	},
+	{ .t_id         = ETHTOOL_TX_COPYBREAK_BUF_SIZE,
+	  .t_type_id    = ETHTOOL_TUNABLE_U32,
+	  .size         = sizeof(u32),
+	  .type         = CMDL_U32,
+	},
 };
 #define TUNABLES_INFO_SIZE	ARRAY_SIZE(tunables_info)
 
@@ -5961,6 +5967,7 @@ static const struct option args[] = {
 		.help	= "Get tunable",
 		.xhelp	= "		[ rx-copybreak ]\n"
 			  "		[ tx-copybreak ]\n"
+			  "		[ tx-buf-size ]\n"
 			  "		[ pfc-precention-tout ]\n"
 	},
 	{
@@ -5969,6 +5976,7 @@ static const struct option args[] = {
 		.help	= "Set tunable",
 		.xhelp	= "		[ rx-copybreak N]\n"
 			  "		[ tx-copybreak N]\n"
+			  "		[ tx-buf-size N]\n"
 			  "		[ pfc-precention-tout N]\n"
 	},
 	{
-- 
2.33.0

