Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC75729A465
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 07:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506149AbgJ0F74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 01:59:56 -0400
Received: from regular1.263xmail.com ([211.150.70.198]:44908 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506142AbgJ0F74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 01:59:56 -0400
Received: from localhost (unknown [192.168.167.172])
        by regular1.263xmail.com (Postfix) with ESMTP id EC06E78E;
        Tue, 27 Oct 2020 13:59:28 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P1837T139708105488128S1603778346100706_;
        Tue, 27 Oct 2020 13:59:28 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <7c394adef3686add6546bbc777ac276e>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: kuba@kernel.org
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yi Li <yili@winhong.com>
Subject: [PATCH v3] net: core: Use skb_is_gso() in skb_checksum_help()
Date:   Tue, 27 Oct 2020 13:59:04 +0800
Message-Id: <20201027055904.2683444-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20201026092403.5e0634f3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201026092403.5e0634f3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes, just minor refactoring.

Signed-off-by: Yi Li <yili@winhong.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..9e7f071b846c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3206,7 +3206,7 @@ int skb_checksum_help(struct sk_buff *skb)
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
 		goto out_set_summed;
 
-	if (unlikely(skb_shinfo(skb)->gso_size)) {
+	if (unlikely(skb_is_gso(skb))) {
 		skb_warn_bad_offload(skb);
 		return -EINVAL;
 	}
-- 
2.25.3



