Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9E48DBA1
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiAMQWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:22:43 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:35195 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbiAMQWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:22:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0V1l-8yE_1642090951;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V1l-8yE_1642090951)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 00:22:39 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] samples/bpf: xdpsock: Use swap() instead of open coding it
Date:   Fri, 14 Jan 2022 00:22:28 +0800
Message-Id: <20220113162228.5576-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean the following coccicheck warning:

./samples/bpf/xdpsock_user.c:632:22-23: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 samples/bpf/xdpsock_user.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index aa50864e4415..30065c703c77 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -626,11 +626,8 @@ static void swap_mac_addresses(void *data)
 	struct ether_header *eth = (struct ether_header *)data;
 	struct ether_addr *src_addr = (struct ether_addr *)&eth->ether_shost;
 	struct ether_addr *dst_addr = (struct ether_addr *)&eth->ether_dhost;
-	struct ether_addr tmp;
 
-	tmp = *src_addr;
-	*src_addr = *dst_addr;
-	*dst_addr = tmp;
+	swap(*src_addr, *dst_addr);
 }
 
 static void hex_dump(void *pkt, size_t length, u64 addr)
-- 
2.20.1.7.g153144c

