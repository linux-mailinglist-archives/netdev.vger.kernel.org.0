Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C354A257BA3
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgHaPHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgHaPHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:07:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CE9C061573;
        Mon, 31 Aug 2020 08:07:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 5so743155pgl.4;
        Mon, 31 Aug 2020 08:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3SmJLKrDgXgBqccBxSJYmecCh5R7fxNCtI0sf/gEQxk=;
        b=UF7wi/z4/ARHOa8+CaY6JSik6HOqhrgezgftNqzT7SaTb81ikq2YfSr7X65gtCk/dm
         xFJBJBX00+bs6N6zMHky48iZgSaPuXc/9Yjkzuan/P4/zZGLSQeds9/Q0z0HkFosFDp6
         SE55tZ9COhiysM9+4BtN0MExypkHY/suyxUZph5P6GYEjkHQolmnNMlRzDj9otAXg1oW
         kh7e8tsBbRpgsKovVvwi7u97M6Ug9Tt7XHPXQujl01u0sYuRcWPGGSJeHfVwqqjHDKSX
         5/5IRPuMXWyKfJJ3n+nnPZqBxOBKPhkG8v2XdTbZzyWQT6TNAMNR26gXzh5Wu0hCVoU+
         OcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3SmJLKrDgXgBqccBxSJYmecCh5R7fxNCtI0sf/gEQxk=;
        b=japBdJsRJ6PYjbsryStIlirNOkVSWJFDriIeEGuQmlkV/I0te0bSqNa4FV29jxKmVS
         LaPX4JC45j5Cz5Zkpg7K2gAYpDZ8IR00LKsmCJea8ZNnhLzswPf9mTgWQp5Heicpgnki
         Wou+MjDV7XqRZ2ctfFw90YL6R6/uS1lpV05Yu21ef6oCF6ORTRbPaiOoixB+tyDs1obd
         c08Y60KnfJqGiBvSKPcz1qDd148s7ur1tuY/rAxxi8C6Qsosvk6CyNIGtgfBXyIsS+sy
         Fv29UmPUO5xQw94XjitiP7vxJIkY2xwVjUeuQoIHeRiBW1BnIZUp1yM8uXdjQrDbHol7
         fUbw==
X-Gm-Message-State: AOAM531yMd6XNFSr11Nj045K+H+mD7RoR2X+cLJ4toluFAwZ/ojNe562
        m2iL3cWIdEgt/Xb+E0vhr8Mbr23Eru9ZmA==
X-Google-Smtp-Source: ABdhPJz2fYwgR9K6KffXJTRCePR05PyLS82TB+AUykU0gSOs1iW5yQsF0wtJQzJZwtfWLp7g31mk+Q==
X-Received: by 2002:aa7:8f03:: with SMTP id x3mr1543464pfr.256.1598886463096;
        Mon, 31 Aug 2020 08:07:43 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id v22sm8353792pfe.75.2020.08.31.08.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:07:42 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        brouer@redhat.com
Subject: [PATCH bpf-next] bpf: change bq_enqueue() return type from int to void
Date:   Mon, 31 Aug 2020 17:07:30 +0200
Message-Id: <20200831150730.35530-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The bq_enqueue() functions for {DEV, CPU}MAP always return
zero. Changing the return type from int to void makes the code easier
to follow.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/cpumap.c | 4 +---
 kernel/bpf/devmap.c | 9 ++++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 8d2a8623d2a7..e486a84b1fce 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -708,7 +708,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
 /* Runs under RCU-read-side, plus in softirq under NAPI protection.
  * Thus, safe percpu variable access.
  */
-static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
+static void bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 {
 	struct list_head *flush_list = this_cpu_ptr(&cpu_map_flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
@@ -729,8 +729,6 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 
 	if (!bq->flush_node.prev)
 		list_add(&bq->flush_node, flush_list);
-
-	return 0;
 }
 
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a42052b85c35..ce29ff7ba51f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -421,8 +421,8 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 /* Runs under RCU-read-side, plus in softirq under NAPI protection.
  * Thus, safe percpu variable access.
  */
-static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
-		      struct net_device *dev_rx)
+static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
+		       struct net_device *dev_rx)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
@@ -441,8 +441,6 @@ static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 
 	if (!bq->flush_node.prev)
 		list_add(&bq->flush_node, flush_list);
-
-	return 0;
 }
 
 static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
@@ -462,7 +460,8 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
-	return bq_enqueue(dev, xdpf, dev_rx);
+	bq_enqueue(dev, xdpf, dev_rx);
+	return 0;
 }
 
 static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
-- 
2.25.1

