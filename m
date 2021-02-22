Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED5321AD5
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 16:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhBVPJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 10:09:23 -0500
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:25212 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhBVPJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 10:09:03 -0500
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2021 10:09:00 EST
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea6033c64cc72-ebc28; Mon, 22 Feb 2021 22:57:16 +0800 (CST)
X-RM-TRANSID: 2eea6033c64cc72-ebc28
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.0.144.162])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16033c6477e4-d7395;
        Mon, 22 Feb 2021 22:57:16 +0800 (CST)
X-RM-TRANSID: 2ee16033c6477e4-d7395
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] net: tap: remove redundant assignments
Date:   Mon, 22 Feb 2021 22:57:48 +0800
Message-Id: <20210222145748.10496-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function tap_get_user, the assignment of 'err' at both places
is redundant, so remove one.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/tap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1f4bdd944..3e9c72738 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -625,7 +625,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	struct tap_dev *tap;
 	unsigned long total_len = iov_iter_count(from);
 	unsigned long len = total_len;
-	int err;
+	int err = -EINVAL;
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int vnet_hdr_len = 0;
 	int copylen = 0;
@@ -636,7 +636,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
 
-		err = -EINVAL;
 		if (len < vnet_hdr_len)
 			goto err;
 		len -= vnet_hdr_len;
@@ -657,7 +656,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 			goto err;
 	}
 
-	err = -EINVAL;
 	if (unlikely(len < ETH_HLEN))
 		goto err;
 
-- 
2.20.1.windows.1



