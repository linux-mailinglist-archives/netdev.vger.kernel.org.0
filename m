Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9211032B395
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449780AbhCCEDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:37 -0500
Received: from mail-m965.mail.126.com ([123.126.96.5]:38502 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838858AbhCBPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 10:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=AKhH1hGn/SetFzBA90
        1kGZ6R2lMlKuE156bgqNwOLN0=; b=ldRwi93Nz9dXJZ6qj693cTruGobDyM13Yp
        jPcP7QdnTqVpuDYoGfIAv9oTZ8MoGDy9yPnMJCG0dKp3aAFI898o70sulJM+6rbS
        MJMCrj7KYbHrGZ3teTxz9yQxsSp/uYU13Ciu7heiB+0gE4vLcRZNZqaLzHqm1+5S
        DL9m+gjiA=
Received: from localhost.localdomain (unknown [125.33.197.31])
        by smtp10 (Coremail) with SMTP id NuRpCgDXgpuKED5gFm0klQ--.48141S4;
        Tue, 02 Mar 2021 18:16:44 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net, kuba@kernel.org, drt@linux.ibm.com,
        sukadev@linux.ibm.com, netdev@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] rtnetlink: using dev_base_seq from target net
Date:   Tue,  2 Mar 2021 18:16:07 +0800
Message-Id: <20210302101607.18560-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NuRpCgDXgpuKED5gFm0klQ--.48141S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUbo7KDUUUU
X-Originating-IP: [125.33.197.31]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi2QxJ-lpEBATCrgAAsQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 0edc0b2ba..1bdcb33fb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2147,7 +2147,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 out_err:
 	cb->args[1] = idx;
 	cb->args[0] = h;
-	cb->seq = net->dev_base_seq;
+	cb->seq = tgt_net->dev_base_seq;
 	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 	if (netnsid >= 0)
 		put_net(tgt_net);
-- 
2.17.1

