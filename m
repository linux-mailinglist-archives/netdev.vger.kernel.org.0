Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A56D82938
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 03:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfHFBce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 21:32:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728870AbfHFBce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 21:32:34 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9B9D2F8EFE862C0A34B;
        Tue,  6 Aug 2019 09:32:32 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Tue, 6 Aug 2019 09:32:26 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <socketcan@hartkopp.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <maowenan@huawei.com>
Subject: [PATCH net-next v4] net: can: Fix compiling warnings for two functions
Date:   Tue, 6 Aug 2019 09:37:01 +0800
Message-ID: <20190806013701.71159-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805.103002.641507066504156536.davem@davemloft.net>
References: <20190805.103002.641507066504156536.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two warnings in net/can, fix them by setting
bcm_sock_no_ioctlcmd and raw_sock_no_ioctlcmd as static.

net/can/bcm.c:1683:5: warning: symbol 'bcm_sock_no_ioctlcmd' was not declared. Should it be static?
net/can/raw.c:840:5: warning: symbol 'raw_sock_no_ioctlcmd' was not declared. Should it be static?

Fixes: 473d924d7d46 ("can: fix ioctl function removal")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 v1->v2: change patch description typo error, 'warings' to 'warnings'.
 v2->v3: change subject of patch.
 v3->v4: change the alignment of two functions. 
 net/can/bcm.c | 4 ++--
 net/can/raw.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index bf1d0bbecec8..eb1d28b8c46a 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1680,8 +1680,8 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	return size;
 }
 
-int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
-			 unsigned long arg)
+static int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
+				unsigned long arg)
 {
 	/* no ioctls for socket layer -> hand it down to NIC layer */
 	return -ENOIOCTLCMD;
diff --git a/net/can/raw.c b/net/can/raw.c
index da386f1fa815..a30aaecd9327 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -837,8 +837,8 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	return size;
 }
 
-int raw_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
-			 unsigned long arg)
+static int raw_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
+				unsigned long arg)
 {
 	/* no ioctls for socket layer -> hand it down to NIC layer */
 	return -ENOIOCTLCMD;
-- 
2.20.1

