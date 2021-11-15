Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812C144FFE2
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhKOIS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:18:27 -0500
Received: from smtpbguseast3.qq.com ([54.243.244.52]:35593 "EHLO
        smtpbguseast3.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhKOISM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 03:18:12 -0500
X-QQ-mid: bizesmtp41t1636964092tsmkw1nx
Received: from localhost.localdomain (unknown [113.57.152.160])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 15 Nov 2021 16:14:51 +0800 (CST)
X-QQ-SSF: 01400000002000B0B000B00B0000000
X-QQ-FEAT: z8a0vINfhrtNSltTRFQVi7zD2KGLsink0a6FYFTjNKtJPhJu3ZofsDF7kCNpW
        bsShleOKT486OHYy6j5gJrLiHYjxPGvqPqQkocHkAII3cQQX87df/+l8hQgeJiQCH0H8JH8
        zGRUDW1WpFV1ePIK5Kqs/CYPfwxyI84fBflP38HyKmU56ityOw0aiE/Tem5JI+k+REpI7yU
        OqrQMj+EICvGbB8qc+BEAz4EDS5nRhQsN/q0+0zj2+yI5rYrnNs/mOivX4EywtRi6X6tw/7
        l314oCAz4LXYJwTFR18POYt76WaOAb6moz12CWsPAZnNiMGGMDKwoJw9xYSAjR6VszpvzMi
        5mtmSo/2MItJDu1R0Q=
X-QQ-GoodBg: 2
From:   liuguoqiang <liuguoqiang@uniontech.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        liuguoqiang <liuguoqiang@uniontech.com>
Subject: [PATCH] net: return correct error code
Date:   Mon, 15 Nov 2021 16:14:48 +0800
Message-Id: <20211115081448.18564-1-liuguoqiang@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign7
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kmemdup called failed and register_net_sysctl return NULL, should
return ENOMEM instead of ENOBUFS

Signed-off-by: liuguoqiang <liuguoqiang@uniontech.com>
---
 net/ipv4/devinet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index ec73a0d52d3e..323e622ff9b7 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2591,7 +2591,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.20.1



