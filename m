Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637D21DFE9
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGMSis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:38:48 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:7015 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgGMSis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:38:48 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06DIa8xT004006;
        Mon, 13 Jul 2020 11:38:44 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 3/3] crypto/chtls: Enable tcp window scaling option
Date:   Tue, 14 Jul 2020 00:05:57 +0530
Message-Id: <20200713183554.11719-4-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200713183554.11719-1-vinay.yadav@chelsio.com>
References: <20200713183554.11719-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable tcp window scaling option in hw based on sysctl settings.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index eedad8caa..9d6ea812b 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1061,6 +1061,7 @@ static void chtls_pass_accept_rpl(struct sk_buff *skb,
 	opt2 |= CONG_CNTRL_V(CONG_ALG_NEWRENO);
 	opt2 |= T5_ISS_F;
 	opt2 |= T5_OPT_2_VALID_F;
+	opt2 |= WND_SCALE_EN_V(!!(sock_net(sk)->ipv4.sysctl_tcp_window_scaling));
 	rpl5->opt0 = cpu_to_be64(opt0);
 	rpl5->opt2 = cpu_to_be32(opt2);
 	rpl5->iss = cpu_to_be32((prandom_u32() & ~7UL) - 1);
-- 
2.18.1

