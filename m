Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B881893EB
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgCRCJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:09:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35432 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgCRCJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:09:58 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B3438517F73A5BFE45DC;
        Wed, 18 Mar 2020 10:09:49 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Mar 2020 10:09:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        <pabeni@redhat.com>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <mptcp@lists.01.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] mptcp: Remove set but not used variable 'can_ack'
Date:   Wed, 18 Mar 2020 02:01:57 +0000
Message-ID: <20200318020157.178956-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

net/mptcp/options.c: In function 'mptcp_established_options_dss':
net/mptcp/options.c:338:7: warning:
 variable 'can_ack' set but not used [-Wunused-but-set-variable]

commit dc093db5cc05 ("mptcp: drop unneeded checks")
leave behind this unused, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/mptcp/options.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 63c8ee49cef2..8ba34950241c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -335,7 +335,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	struct mptcp_sock *msk;
 	unsigned int ack_size;
 	bool ret = false;
-	bool can_ack;
 	u8 tcp_fin;
 
 	if (skb) {
@@ -364,7 +363,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	/* passive sockets msk will set the 'can_ack' after accept(), even
 	 * if the first subflow may have the already the remote key handy
 	 */
-	can_ack = true;
 	opts->ext_copy.use_ack = 0;
 	msk = mptcp_sk(subflow->conn);
 	if (!READ_ONCE(msk->can_ack)) {



