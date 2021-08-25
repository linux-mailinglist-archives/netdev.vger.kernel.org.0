Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA77B3F6FBE
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbhHYGpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:45:34 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15211 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238416AbhHYGpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:45:33 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Gvbzx1rxtz1DDBH;
        Wed, 25 Aug 2021 14:44:13 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/5] ethtool: add support to set/get tx spare buf size
Date:   Wed, 25 Aug 2021 14:40:51 +0800
Message-ID: <1629873655-51539-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add support for ethtool to set/get tx spare buf size.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 include/uapi/linux/ethtool.h | 1 +
 net/ethtool/ioctl.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index b6db6590baf0..266e95e4fb33 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -231,6 +231,7 @@ enum tunable_id {
 	ETHTOOL_RX_COPYBREAK,
 	ETHTOOL_TX_COPYBREAK,
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
+	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
 	 * tunable_strings[] in net/ethtool/common.c
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f2abc3152888..9fc801298fde 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2377,6 +2377,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
 	switch (tuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
 	case ETHTOOL_TX_COPYBREAK:
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
 		if (tuna->len != sizeof(u32) ||
 		    tuna->type_id != ETHTOOL_TUNABLE_U32)
 			return -EINVAL;
-- 
2.8.1

