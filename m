Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE5A1AFBFB
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgDSQ31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgDSQ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:29:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E4EC061A0C;
        Sun, 19 Apr 2020 09:29:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d17so3831450pgo.0;
        Sun, 19 Apr 2020 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0FiYUfEJjdc2qCXXLulXM9aMdQx537xDQqCGw0jD4yQ=;
        b=jXLgxdKlSxG1q+KJVknY8KH+LOVrwgIXqfkbVXb1AyPU5A2XFZiItsMW4HDDiTHC4K
         uQsjbGuE5effVjnpC7Gnq7gi2j64euL2zx/fO3Uh6skqEfV6e0CGUdLKqlBfV5klDRqb
         BK3bCArjuwvKonXLHd5qmT4eyKdBvauvfR7LkMBbGPWoGkZs6Enr4rb5c02lgS+8wMva
         0zEDVyBWzz45zwBnNqCZ9ZnXriRz/9GbHJsTU2rzf9LDC/as6FzKGcuqbdz+jTQrEGzq
         SDGTjr/lLFYImJI7iYvo/9X6YA+bIVVGuJA0LWNrgf6i8qdMupqKIo+h7s52AKx0d5to
         BN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0FiYUfEJjdc2qCXXLulXM9aMdQx537xDQqCGw0jD4yQ=;
        b=cpEY4buKRVAsvzVUX9LiIetvhpGfLDpqHyQ2jTg4Iwf1RNIrmF8+hgjlM5VrKshM/6
         Kd9H+kSEsvnm1Le95KfwY00H1qa9Cu0S8e3p3DyvauDVuwv0ZHFI8Ja/tI7OMPEyOY+F
         i4JowPAwQVAgozGOdp4fMMLkjX35EbExxSfP4bLUDjJWdpRVeJO4sfOra+F+0cJim4FJ
         YpGhzQizsRvMduwKtzGWFewzavTKeZn64XzNqs0aV/9wLmqfVYAxd1VI0LO6mC4bvcPx
         8ThVX4WW8wlF5d2mInIC93Z5I1GLNRst3lpET+eg4UygU5piQtx5OuE17V+abmYI5Vgx
         QVUQ==
X-Gm-Message-State: AGi0Pua4SUx3AKaCeaHM4TCNhtvgEfYsKHjaCw9O/KrqwGCkiLfR94Zz
        px36T+8vEkB/qmImeAqSQ2E=
X-Google-Smtp-Source: APiQypK1N/mC/hRovML5gGDssyc7j0IQSUwmDtRMCItqXJMWAZ3Z5O6cGwYu07wdf7ow+A62kfIJPQ==
X-Received: by 2002:a62:dd4e:: with SMTP id w75mr1576877pff.221.1587313766325;
        Sun, 19 Apr 2020 09:29:26 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:610d:f65:24cf:c6c4:f8fd:66fc])
        by smtp.gmail.com with ESMTPSA id x16sm11319197pfc.61.2020.04.19.09.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 09:29:25 -0700 (PDT)
From:   Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     aishwaryarj100@gmail.com
Subject: [PATCH] net: qed: Remove unneeded cast from memory allocation
Date:   Sun, 19 Apr 2020 21:59:17 +0530
Message-Id: <20200419162917.23030-1-aishwaryarj100@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove casting the values returned by memory allocation function.

Coccinelle emits WARNING: casting value returned by memory allocation
function to struct pointer is useless.

This issue was detected by using the Coccinelle.

Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_roce.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 37e70562a964..475b89903f46 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -736,9 +736,9 @@ static int qed_roce_sp_destroy_qp_responder(struct qed_hwfn *p_hwfn,
 
 	p_ramrod = &p_ent->ramrod.roce_destroy_qp_resp;
 
-	p_ramrod_res = (struct roce_destroy_qp_resp_output_params *)
-	    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev, sizeof(*p_ramrod_res),
-			       &ramrod_res_phys, GFP_KERNEL);
+	p_ramrod_res = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+					  sizeof(*p_ramrod_res),
+					  &ramrod_res_phys, GFP_KERNEL);
 
 	if (!p_ramrod_res) {
 		rc = -ENOMEM;
@@ -872,10 +872,10 @@ int qed_roce_query_qp(struct qed_hwfn *p_hwfn,
 	}
 
 	/* Send a query responder ramrod to FW to get RQ-PSN and state */
-	p_resp_ramrod_res = (struct roce_query_qp_resp_output_params *)
-	    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
-			       sizeof(*p_resp_ramrod_res),
-			       &resp_ramrod_res_phys, GFP_KERNEL);
+	p_resp_ramrod_res =
+		dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+				   sizeof(*p_resp_ramrod_res),
+				   &resp_ramrod_res_phys, GFP_KERNEL);
 	if (!p_resp_ramrod_res) {
 		DP_NOTICE(p_hwfn,
 			  "qed query qp failed: cannot allocate memory (ramrod)\n");
@@ -920,8 +920,7 @@ int qed_roce_query_qp(struct qed_hwfn *p_hwfn,
 	}
 
 	/* Send a query requester ramrod to FW to get SQ-PSN and state */
-	p_req_ramrod_res = (struct roce_query_qp_req_output_params *)
-			   dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+	p_req_ramrod_res = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
 					      sizeof(*p_req_ramrod_res),
 					      &req_ramrod_res_phys,
 					      GFP_KERNEL);
-- 
2.17.1

