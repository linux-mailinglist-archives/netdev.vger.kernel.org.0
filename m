Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DCB224414
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgGQTSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:18:23 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:34857 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgGQTSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:18:23 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06HJI4fi018272;
        Fri, 17 Jul 2020 12:18:05 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     borisp@mellanox.com, daniel@iogearbox.net, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next v2] crypto/chtls: Enable tcp window scaling option
Date:   Sat, 18 Jul 2020 00:46:40 +0530
Message-Id: <20200717191639.1601-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable tcp window scaling option in hw based on sysctl settings
and option in connection request.

v1->v2:
- Set window scale option based on option in connection request.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 07641b30f317..27569679ed65 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1041,6 +1041,7 @@ static void chtls_pass_accept_rpl(struct sk_buff *skb,
 	opt2 |= CONG_CNTRL_V(CONG_ALG_NEWRENO);
 	opt2 |= T5_ISS_F;
 	opt2 |= T5_OPT_2_VALID_F;
+	opt2 |= WND_SCALE_EN_V(WSCALE_OK(tp));
 	rpl5->opt0 = cpu_to_be64(opt0);
 	rpl5->opt2 = cpu_to_be32(opt2);
 	rpl5->iss = cpu_to_be32((prandom_u32() & ~7UL) - 1);
-- 
2.18.1

