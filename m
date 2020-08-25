Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18F3250FF7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 05:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgHYD0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 23:26:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728442AbgHYD0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 23:26:36 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7F79851D5EEDF7148A22;
        Tue, 25 Aug 2020 11:26:33 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Tue, 25 Aug 2020
 11:26:25 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <johannes.berg@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH v2] netlink: remove duplicated nla_need_padding_for_64bit() check
Date:   Mon, 24 Aug 2020 23:25:17 -0400
Message-ID: <20200825032517.61864-1-linmiaohe@huawei.com>
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

The need for padding 64bit is implicitly checked by nla_align_64bit(), so
remove this explicit one.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 lib/nlattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index bc5b5cf608c4..98f596bfbfd8 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -816,8 +816,7 @@ EXPORT_SYMBOL(__nla_reserve);
 struct nlattr *__nla_reserve_64bit(struct sk_buff *skb, int attrtype,
 				   int attrlen, int padattr)
 {
-	if (nla_need_padding_for_64bit(skb))
-		nla_align_64bit(skb, padattr);
+	nla_align_64bit(skb, padattr);
 
 	return __nla_reserve(skb, attrtype, attrlen);
 }
-- 
2.19.1

