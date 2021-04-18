Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DE63637C3
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhDRVM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:12:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35252 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhDRVMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:12:25 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5CFBC63E8A;
        Sun, 18 Apr 2021 23:11:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: [PATCH net-next 3/3] net: ethernet: mtk_eth_soc: handle VLAN pop action
Date:   Sun, 18 Apr 2021 23:11:45 +0200
Message-Id: <20210418211145.21914-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210418211145.21914-1-pablo@netfilter.org>
References: <20210418211145.21914-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not hit EOPNOTSUPP when flowtable offload provides a VLAN pop action.

Fixes: efce49dfe6a8 ("netfilter: flowtable: add vlan pop action offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
efce49dfe6a8 is coming in the nf-next PR for net-next.

 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 2759c875c791..ae16299f7fe8 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -232,6 +232,8 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 			data.vlan.proto = act->vlan.proto;
 			data.vlan.num++;
 			break;
+		case FLOW_ACTION_VLAN_POP:
+			break;
 		case FLOW_ACTION_PPPOE_PUSH:
 			if (data.pppoe.num == 1)
 				return -EOPNOTSUPP;
-- 
2.20.1

