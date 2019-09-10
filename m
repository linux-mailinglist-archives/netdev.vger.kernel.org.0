Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA571AE413
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 08:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406449AbfIJG4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 02:56:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2201 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732669AbfIJG4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 02:56:22 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DDE2491D75819BC1BAC8;
        Tue, 10 Sep 2019 14:56:18 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Tue, 10 Sep 2019 14:56:09 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net 1/2] sctp: remove redundant assignment when call sctp_get_port_local
Date:   Tue, 10 Sep 2019 15:13:42 +0800
Message-ID: <20190910071343.18808-2-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190910071343.18808-1-maowenan@huawei.com>
References: <20190910071343.18808-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are more parentheses in if clause when call sctp_get_port_local
in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
do cleanup.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/sctp/socket.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9d1f83b10c0a..766b68b55ebe 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 	 * detection.
 	 */
 	addr->v4.sin_port = htons(snum);
-	if ((ret = sctp_get_port_local(sk, addr))) {
+	if (sctp_get_port_local(sk, addr))
 		return -EADDRINUSE;
-	}
 
 	/* Refresh ephemeral port.  */
 	if (!bp->port)
-- 
2.20.1

