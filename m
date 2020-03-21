Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E844418DFD5
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgCUL3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:29:37 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47584 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgCUL3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:29:37 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2D31C411A4;
        Sat, 21 Mar 2020 19:29:19 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next 3/3] net/sched: act_ct: add nf_conn_acct for SW act_ct flowtable offload
Date:   Sat, 21 Mar 2020 19:29:18 +0800
Message-Id: <1584790158-9752-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584790158-9752-1-git-send-email-wenxu@ucloud.cn>
References: <1584790158-9752-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkxLS0tLSEpPTEpJTklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mgg6Dzo4NzgrOBMTKRAfIQ0#
        NygaCg1VSlVKTkNPTEJLSk5CSUxKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpOSUw3Bg++
X-HM-Tid: 0a70fcdabf602086kuqy2d31c411a4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_conn_acct counter for the software act_ct flowtable offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 56b66d2..0386c6b 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -536,6 +536,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow_offload_refresh(nf_ft, flow);
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
+	flow_offload_update_acct(flow, 1, skb->len, dir);
 
 	return true;
 }
-- 
1.8.3.1

