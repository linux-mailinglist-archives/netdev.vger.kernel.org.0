Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B7E11F8CD
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 17:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLOQO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 11:14:59 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:54402 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfLOQO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 11:14:59 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 47bTy93mZ6z9vbYZ
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 16:14:57 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yD2M6BdbaL_Z for <netdev@vger.kernel.org>;
        Sun, 15 Dec 2019 10:14:57 -0600 (CST)
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com [209.85.219.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 47bTy92Txhz9vbYX
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 10:14:57 -0600 (CST)
Received: by mail-yb1-f199.google.com with SMTP id g12so4585704ybc.20
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 08:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gpouca8jqDFr8BHpnbtfPrT2Ta2ckDjVl8T1ZQEgkC8=;
        b=DL3JMZnf2Pp3CLccrKKH0lblDNSv/m7F52ij0QxV9ZThYqPKJWScvPEd1SjK8PU+qh
         Udp2rWKF3Pomakz4zSEMbGffFrmTm7Nbo0T4/k4wATzmxjhMYISzZMg5kiyMuBL44pkK
         c8JsCxHoijJcRQ35DHZIv5k6c25nIDbiIEFbmvZ6LURhUkYjFveHy1KieZdrv57LvnaL
         YWaowyeyTtoG4z56+Pj+7L9G6qKmIVeg/R9O7rdudP8m6CuUkAVBGkL3thO/G8lL3S+Y
         rJd9tdaLpo3dxP5JWzEJ7IjinBDpDp+ELvqAFNzHnF0Bc397uNpYM/GVHwg4YAF2UdO+
         SBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gpouca8jqDFr8BHpnbtfPrT2Ta2ckDjVl8T1ZQEgkC8=;
        b=O4MahrGESGFhzNw6YL0mKJaaNV4GeyjjlfZK8nres2PqyXg+BVxkRtEOmEs0OhL6xv
         xC9NaT8r/wurJOmADgBfamDD7R6f2PdODpZl44zaW719FjTRBljybOgBXd1pDmaqojTA
         z3/E0aeYzyzNodB4SgTxhUCROkvjSyk8z6geLoLgbeWKWE4ONx//HPmGXtfOM02YHS1M
         V7JrwszhPw/THW3VPHTx9HYFiGdC25dwdk7D9XTfIm9vE7HlroRczaJWHahoIyUIp5uI
         odgqONQF6sqSqXYs8fKr/jhIRaV70jT9LnBhOT908A5ExxH8UlvhjCzRXz4B4Pwu1oRF
         06PA==
X-Gm-Message-State: APjAAAUNcWxrAUXaHSH0Qsl12CygWoG5rdpU/PQR9uh/n6xHOljmHdE9
        /U6ldEGvehjfpZAkpcBB4ZdA08tNe7DhTk30dLAoJywz7uu6q+UGSZYGjDSDOxiu01UyV16mQTd
        7Bl0py+L4zAuZRLfds7JQ
X-Received: by 2002:a81:984f:: with SMTP id p76mr15512631ywg.346.1576426496861;
        Sun, 15 Dec 2019 08:14:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqw75t1xFCOcVUpu4w5BNjONs2rWreOwnnmCOphU2WWakVMiD5dMHUhT+fZQhYCBT70ebyNogQ==
X-Received: by 2002:a81:984f:: with SMTP id p76mr15512617ywg.346.1576426496604;
        Sun, 15 Dec 2019 08:14:56 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id s31sm7036304ywa.30.2019.12.15.08.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 08:14:56 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fore200e: Fix incorrect checks of NULL pointer dereference
Date:   Sun, 15 Dec 2019 10:14:51 -0600
Message-Id: <20191215161451.24221-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fore200e_send and fore200e_close, the pointers from the arguments
are dereferenced in the variable declaration block and then checked
for NULL. The patch fixes these issues by avoiding NULL pointer
dereferences.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/atm/fore200e.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index f1a500205313..8fbd36eb8941 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1414,12 +1414,14 @@ fore200e_open(struct atm_vcc *vcc)
 static void
 fore200e_close(struct atm_vcc* vcc)
 {
-    struct fore200e*        fore200e = FORE200E_DEV(vcc->dev);
     struct fore200e_vcc*    fore200e_vcc;
+    struct fore200e*        fore200e;
     struct fore200e_vc_map* vc_map;
     unsigned long           flags;
 
     ASSERT(vcc);
+    fore200e = FORE200E_DEV(vcc->dev);
+
     ASSERT((vcc->vpi >= 0) && (vcc->vpi < 1<<FORE200E_VPI_BITS));
     ASSERT((vcc->vci >= 0) && (vcc->vci < 1<<FORE200E_VCI_BITS));
 
@@ -1464,10 +1466,10 @@ fore200e_close(struct atm_vcc* vcc)
 static int
 fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
-    struct fore200e*        fore200e     = FORE200E_DEV(vcc->dev);
-    struct fore200e_vcc*    fore200e_vcc = FORE200E_VCC(vcc);
+    struct fore200e*        fore200e;
+    struct fore200e_vcc*    fore200e_vcc;
     struct fore200e_vc_map* vc_map;
-    struct host_txq*        txq          = &fore200e->host_txq;
+    struct host_txq*        txq;
     struct host_txq_entry*  entry;
     struct tpd*             tpd;
     struct tpd_haddr        tpd_haddr;
@@ -1480,9 +1482,18 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
     unsigned char*          data;
     unsigned long           flags;
 
-    ASSERT(vcc);
-    ASSERT(fore200e);
-    ASSERT(fore200e_vcc);
+    if (!vcc)
+        return -EINVAL;
+
+    fore200e = FORE200E_DEV(vcc->dev);
+    fore200e_vcc = FORE200E_VCC(vcc);
+
+    if (!fore200e)
+        return -EINVAL;
+
+    txq = &fore200e->host_txq;
+    if (!fore200e_vcc)
+        return -EINVAL;
 
     if (!test_bit(ATM_VF_READY, &vcc->flags)) {
 	DPRINTK(1, "VC %d.%d.%d not ready for tx\n", vcc->itf, vcc->vpi, vcc->vpi);
-- 
2.20.1

