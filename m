Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45C024FCEB
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgHXLp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:45:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10315 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726624AbgHXLp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 07:45:57 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A1A3FB96423F246E1225;
        Mon, 24 Aug 2020 19:45:54 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 24 Aug 2020
 19:45:45 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Use helper macro RT_TOS() in __icmp_send()
Date:   Mon, 24 Aug 2020 07:44:37 -0400
Message-ID: <20200824114437.58332-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use helper macro RT_TOS() to get tos in __icmp_send().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/icmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index cf36f955bfe6..3b387dc3864f 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -690,9 +690,9 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		rcu_read_unlock();
 	}
 
-	tos = icmp_pointers[type].error ? ((iph->tos & IPTOS_TOS_MASK) |
+	tos = icmp_pointers[type].error ? (RT_TOS(iph->tos) |
 					   IPTOS_PREC_INTERNETCONTROL) :
-					  iph->tos;
+					   iph->tos;
 	mark = IP4_REPLY_MARK(net, skb_in->mark);
 
 	if (__ip_options_echo(net, &icmp_param.replyopts.opt.opt, skb_in, opt))
-- 
2.19.1

