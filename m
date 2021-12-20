Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEAF47A618
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhLTIgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:36:47 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15941 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbhLTIgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 03:36:47 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHXtB6tWczZcgR;
        Mon, 20 Dec 2021 16:33:38 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 16:36:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 16:36:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>
Subject: [PATCH ethtool-next 1/2] ethtool: netlink: add support to set/get rx buf len
Date:   Mon, 20 Dec 2021 16:31:54 +0800
Message-ID: <20211220083155.39882-2-huangguangbin2@huawei.com>
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

Add support for "ethtool -G <dev> rx-buf-len xxx" and "ethtool -g <dev>"
to set/get rx-buf-len.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 ethtool.c       | 1 +
 netlink/rings.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 55dac51..0dc3559 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5724,6 +5724,7 @@ static const struct option args[] = {
 			  "		[ rx-mini N ]\n"
 			  "		[ rx-jumbo N ]\n"
 			  "		[ tx N ]\n"
+			  "             [ rx-buf-len N]\n"
 	},
 	{
 		.opts	= "-k|--show-features|--show-offload",
diff --git a/netlink/rings.c b/netlink/rings.c
index b8c458f..119178e 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -46,6 +46,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32(tb[ETHTOOL_A_RINGS_RX_MINI], "RX Mini:\t");
 	show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO], "RX Jumbo:\t");
 	show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
+	show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");
 
 	return MNL_CB_OK;
 }
@@ -98,6 +99,12 @@ static const struct param_parser sring_params[] = {
 		.handler	= nl_parse_direct_u32,
 		.min_argc	= 1,
 	},
+	{
+		.arg            = "rx-buf-len",
+		.type           = ETHTOOL_A_RINGS_RX_BUF_LEN,
+		.handler        = nl_parse_direct_u32,
+		.min_argc       = 1,
+	},
 	{}
 };
 
-- 
2.33.0

