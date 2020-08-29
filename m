Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF77256634
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgH2JKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:10:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58502 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726258AbgH2JKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 05:10:39 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BC1E14AA4C4907C8CD60;
        Sat, 29 Aug 2020 17:10:35 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 17:10:29 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Use helper macro IP_MAX_MTU in __ip_append_data()
Date:   Sat, 29 Aug 2020 05:09:18 -0400
Message-ID: <20200829090918.17614-1-linmiaohe@huawei.com>
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

What 0xFFFF means here is actually the max mtu of a ip packet. Use help
macro IP_MAX_MTU here.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/ip_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 329a0ab87542..f0f234727547 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -996,7 +996,7 @@ static int __ip_append_data(struct sock *sk,
 
 	fragheaderlen = sizeof(struct iphdr) + (opt ? opt->optlen : 0);
 	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen;
-	maxnonfragsize = ip_sk_ignore_df(sk) ? 0xFFFF : mtu;
+	maxnonfragsize = ip_sk_ignore_df(sk) ? IP_MAX_MTU : mtu;
 
 	if (cork->length + length > maxnonfragsize - fragheaderlen) {
 		ip_local_error(sk, EMSGSIZE, fl4->daddr, inet->inet_dport,
-- 
2.19.1

