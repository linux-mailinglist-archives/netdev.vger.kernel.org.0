Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3B914DE5A
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 17:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgA3QEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 11:04:54 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60213 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727330AbgA3QEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 11:04:54 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Jan 2020 18:04:47 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00UG4khh004757;
        Thu, 30 Jan 2020 18:04:47 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/3] netfilter: flowtable: Fix setting forgotten NF_FLOW_HW_DEAD flag
Date:   Thu, 30 Jan 2020 18:04:37 +0200
Message-Id: <1580400277-6305-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1580400277-6305-1-git-send-email-paulb@mellanox.com>
References: <1580400277-6305-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the refactor this was accidently removed.

Fixes: ae29045018c8 ("netfilter: flowtable: add nf_flow_offload_tuple() helper")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c8b70ff..83e1db3 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -675,6 +675,7 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 {
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
-- 
1.8.3.1

