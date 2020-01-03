Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FBF12F39C
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 04:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgACDw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 22:52:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:43986 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbgACDw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 22:52:56 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E1165D6122B42F7420C4;
        Fri,  3 Jan 2020 11:52:54 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 3 Jan 2020 11:52:44 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] ethtool: remove set but not used variable 'lsettings'
Date:   Fri, 3 Jan 2020 03:48:56 +0000
Message-ID: <20200103034856.177906-1-yuehaibing@huawei.com>
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

net/ethtool/linkmodes.c: In function 'ethnl_set_linkmodes':
net/ethtool/linkmodes.c:326:32: warning:
 variable 'lsettings' set but not used [-Wunused-but-set-variable]
  struct ethtool_link_settings *lsettings;
                                ^
It is never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ethtool/linkmodes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 0b99f494ad3b..96f20be64553 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -323,7 +323,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1];
 	struct ethtool_link_ksettings ksettings = {};
-	struct ethtool_link_settings *lsettings;
 	struct ethnl_req_info req_info = {};
 	struct net_device *dev;
 	bool mod = false;
@@ -354,7 +353,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		goto out_ops;
 	}
-	lsettings = &ksettings.base;
 
 	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
 	if (ret < 0)



