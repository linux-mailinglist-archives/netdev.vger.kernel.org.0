Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB31647CE0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLIEPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 23:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLIEPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 23:15:19 -0500
Received: from out199-17.us.a.mail.aliyun.com (out199-17.us.a.mail.aliyun.com [47.90.199.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAECACB37;
        Thu,  8 Dec 2022 20:14:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=jiapeng.chong@linux.alibaba.com;NM=0;PH=DS;RN=16;SR=0;TI=SMTPD_---0VWspzh3_1670557238;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VWspzh3_1670557238)
          by smtp.aliyun-inc.com;
          Fri, 09 Dec 2022 11:40:44 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     wei.liu@kernel.org
Cc:     paul@xen.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] xen-netback: Remove set but unused variable 'pending_idx'
Date:   Fri,  9 Dec 2022 11:40:36 +0800
Message-Id: <20221209034036.37280-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable pending_idx is not effectively used in the function, so delete
it.

drivers/net/xen-netback/netback.c:886:7: warning: variable ‘pending_idx’ set but not used.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3399
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/xen-netback/netback.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 054ac0e897f6..19d928389473 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -883,7 +883,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		struct xen_netif_tx_request txfrags[XEN_NETBK_LEGACY_SLOTS_MAX];
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		unsigned int extra_count;
-		u16 pending_idx;
 		RING_IDX idx;
 		int work_to_do;
 		unsigned int data_len;
@@ -984,7 +983,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		}
 
 		index = pending_index(queue->pending_cons);
-		pending_idx = queue->pending_ring[index];
 
 		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
 			data_len = txreq.size;
-- 
2.20.1.7.g153144c

