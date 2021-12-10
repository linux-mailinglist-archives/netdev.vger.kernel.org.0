Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E833D46F985
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 04:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbhLJDR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 22:17:27 -0500
Received: from m12-18.163.com ([220.181.12.18]:33453 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhLJDR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 22:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KcZ2J
        GLNcfeFuDTWZPM8WYKImwoSiEQRcN6kpocNOiQ=; b=Mjbmdl5heNvtb4sKdQvQY
        hvi2x1eM7D97koCQdO8/LhkK6WMrWFmSkGn+rrYTPDk8uty5gUCUjFk1T9+qrOwf
        0vEAcHkGBewMFV82YCw66jF/NBvIBVI5hoi6HsdTq1GknxuQIO3bRK1SUpn75jZU
        q6AyGFKMCBm7E4g29O5GLc=
Received: from localhost.localdomain (unknown [120.243.48.4])
        by smtp14 (Coremail) with SMTP id EsCowABHnx+txbJh9cusAA--.18941S4;
        Fri, 10 Dec 2021 11:13:15 +0800 (CST)
From:   lizhe <sensor1010@163.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, sensor1010@163.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/netfilter/x_tables.c: Use kvalloc to make your code better
Date:   Thu,  9 Dec 2021 19:12:44 -0800
Message-Id: <20211210031244.13372-1-sensor1010@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABHnx+txbJh9cusAA--.18941S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruFW3uryUGry7JrWkAr43Wrg_yoW3Jrb_Ca
        4vqw4vgr95trWkK3y8CanxZrWDK3y8Ar4SvFySv39xJ348Wr4F93ykWr9I9F43uw4UCryU
        Gw4DKF1ag347WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjKL95UUUUU==
X-Originating-IP: [120.243.48.4]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/xtbBXgxlq1aD9n8iYwAAsB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kvzalloc () instead of kvmalloc () and memset

Signed-off-by: lizhe <sensor1010@163.com>
---
 net/netfilter/x_tables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 25524e393349..8d6ffed7d526 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1189,11 +1189,10 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	if (sz < sizeof(*info) || sz >= XT_MAX_TABLE_SIZE)
 		return NULL;
 
-	info = kvmalloc(sz, GFP_KERNEL_ACCOUNT);
+	info = kvzalloc(sz, GFP_KERNEL_ACCOUNT);
 	if (!info)
 		return NULL;
 
-	memset(info, 0, sizeof(*info));
 	info->size = size;
 	return info;
 }
-- 
2.25.1


