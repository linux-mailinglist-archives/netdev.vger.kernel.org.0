Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3805E262BE3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIIJbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:31:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbgIIJbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:31:35 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 76F664DA791D137299A7
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 17:31:33 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 17:31:27 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] hsr: avoid newline at end of message in NL_SET_ERR_MSG_MOD
Date:   Wed, 9 Sep 2020 17:38:21 +0800
Message-ID: <20200909093821.54820-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clean follow coccicheck warning:
net//hsr/hsr_netlink.c:94:8-42: WARNING avoid newline at end of message
in NL_SET_ERR_MSG_MOD
net//hsr/hsr_netlink.c:87:30-57: WARNING avoid newline at end of message
in NL_SET_ERR_MSG_MOD
net//hsr/hsr_netlink.c:79:29-53: WARNING avoid newline at end of message
in NL_SET_ERR_MSG_MOD

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/hsr/hsr_netlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 06c3cd988760..0e4681cf71db 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -76,7 +76,7 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		proto = nla_get_u8(data[IFLA_HSR_PROTOCOL]);
 
 	if (proto >= HSR_PROTOCOL_MAX) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported protocol\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported protocol");
 		return -EINVAL;
 	}
 
@@ -84,14 +84,14 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		proto_version = HSR_V0;
 	} else {
 		if (proto == HSR_PROTOCOL_PRP) {
-			NL_SET_ERR_MSG_MOD(extack, "PRP version unsupported\n");
+			NL_SET_ERR_MSG_MOD(extack, "PRP version unsupported");
 			return -EINVAL;
 		}
 
 		proto_version = nla_get_u8(data[IFLA_HSR_VERSION]);
 		if (proto_version > HSR_V1) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Only HSR version 0/1 supported\n");
+					   "Only HSR version 0/1 supported");
 			return -EINVAL;
 		}
 	}
-- 
2.16.2.dirty

