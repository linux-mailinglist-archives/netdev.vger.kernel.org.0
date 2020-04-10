Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310D31A48CB
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 19:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgDJRHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 13:07:41 -0400
Received: from forward102o.mail.yandex.net ([37.140.190.182]:36264 "EHLO
        forward102o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgDJRHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 13:07:41 -0400
Received: from mxback23j.mail.yandex.net (mxback23j.mail.yandex.net [IPv6:2a02:6b8:0:1619::223])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id 7C73B66812FF
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 20:07:38 +0300 (MSK)
Received: from iva3-dd2bb2ff2b5f.qloud-c.yandex.net (iva3-dd2bb2ff2b5f.qloud-c.yandex.net [2a02:6b8:c0c:7611:0:640:dd2b:b2ff])
        by mxback23j.mail.yandex.net (mxback/Yandex) with ESMTP id eUPHwBbeHh-7co4nNua;
        Fri, 10 Apr 2020 20:07:38 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586538458;
        bh=cB/wo3zqUkJM62WSu4Nnrfon8hPrQzUJVUGU9rqBliQ=;
        h=Subject:To:From:Date:Message-Id;
        b=MX3kji+RUS0QBGHo24xlSK0fImKwj5GEflb9Ri7V9YMpCIzxIvhp4WfyigIIlKv0p
         aesGYev+3AMbdRjpBJnlGMi7dT8K/laqfe9nDeFDTCLBoNAoLSgBC0TNSEkZ6UMYKk
         N7kYZ/KrSWzRZWp4pSQVuG8SWzmhDGedOlHTajLw=
Authentication-Results: mxback23j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva3-dd2bb2ff2b5f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id C9C58pVBNQ-7bW4GRZg;
        Fri, 10 Apr 2020 20:07:37 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Konstantin Kharlamov <Hi-Angel@yandex.ru>
To:     netdev@vger.kernel.org
Subject: [PATCH] scsi: cxgb3i: move docs to functions documented
Date:   Fri, 10 Apr 2020 20:07:32 +0300
Message-Id: <20200410170732.411665-1-Hi-Angel@yandex.ru>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move documentation for push_tx_frames near the push_tx_frames function,
and likewise for release_offload_resources.

Signed-off-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 524cdbcd29aa..6c6b301cb5ec 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -375,6 +375,11 @@ static inline void make_tx_data_wr(struct cxgbi_sock *csk, struct sk_buff *skb,
 	}
 }
 
+static void arp_failure_skb_discard(struct t3cdev *dev, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+}
+
 /**
  * push_tx_frames -- start transmit
  * @c3cn: the offloaded connection
@@ -385,12 +390,6 @@ static inline void make_tx_data_wr(struct cxgbi_sock *csk, struct sk_buff *skb,
  * connection's lock held.  Returns the amount of send buffer space that was
  * freed as a result of sending queued data to T3.
  */
-
-static void arp_failure_skb_discard(struct t3cdev *dev, struct sk_buff *skb)
-{
-	kfree_skb(skb);
-}
-
 static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 {
 	int total_size = 0;
@@ -886,11 +885,6 @@ static int alloc_cpls(struct cxgbi_sock *csk)
 	return -ENOMEM;
 }
 
-/**
- * release_offload_resources - release offload resource
- * @c3cn: the offloaded iscsi tcp connection.
- * Release resources held by an offload connection (TID, L2T entry, etc.)
- */
 static void l2t_put(struct cxgbi_sock *csk)
 {
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
@@ -902,6 +896,11 @@ static void l2t_put(struct cxgbi_sock *csk)
 	}
 }
 
+/**
+ * release_offload_resources - release offload resource
+ * @c3cn: the offloaded iscsi tcp connection.
+ * Release resources held by an offload connection (TID, L2T entry, etc.)
+ */
 static void release_offload_resources(struct cxgbi_sock *csk)
 {
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
-- 
2.26.0

