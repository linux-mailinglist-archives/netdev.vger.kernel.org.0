Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAF729855D
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 02:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421172AbgJZBfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 21:35:06 -0400
Received: from regular1.263xmail.com ([211.150.70.202]:54596 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1419368AbgJZBfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 21:35:06 -0400
Received: from localhost (unknown [192.168.167.8])
        by regular1.263xmail.com (Postfix) with ESMTP id 6D107544;
        Mon, 26 Oct 2020 09:34:54 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P23417T140694083577600S1603676083967458_;
        Mon, 26 Oct 2020 09:34:50 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <34c35003ad9d1d5b3dca08563e9eae32>
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
Subject: [PATCH v2] net/core/dev.c : Use skb_is_gso
Date:   Mon, 26 Oct 2020 09:34:35 +0800
Message-Id: <20201026013435.1910386-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20201023135709.0f89fd59@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201023135709.0f89fd59@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trivial fix to use func skb_is_gso in place of
test for skb_shinfo(skb)->gso_size.

Signed-off-by: Yi Li <yili@winhong.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9499a414d67e..55f66e108059 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3205,7 +3205,7 @@ int skb_checksum_help(struct sk_buff *skb)
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
 		goto out_set_summed;
 
-	if (unlikely(skb_shinfo(skb)->gso_size)) {
+	if (unlikely(skb_is_gso(skb))) {
 		skb_warn_bad_offload(skb);
 		return -EINVAL;
 	}
-- 
2.25.3



