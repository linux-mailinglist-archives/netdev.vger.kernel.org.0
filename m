Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B03AEA67
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhFUNwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhFUNwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:52:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9622BC061574;
        Mon, 21 Jun 2021 06:50:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i4so4884728plt.12;
        Mon, 21 Jun 2021 06:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Vevo7ejaXcssHHgQzGNwjoQOcpQ59e4oftezJZAjPA=;
        b=DF7TJVGQac5fB/7fndmVtAxkhZw0fe30wtM/heScSiU0oQ4TWzckN7FY2znSYD8t+v
         u1rx2N06N1Fa7EMzSVa7y4uJFW36yt/r+I6NkXWdB0uy2Z5H979fa7dhxBaTXUWSVwsn
         TVWWPrEnhBB1Kxbab7eyoSagGbP76cjaPMMAFVYoS+r8K26q+0dr5388IKUWmFx4J83b
         Xwa29Hy9mAJlx8OIdGvSsFFouiwXFQ9OaQy4RKFBHXVjG0M3mvOmrE/JVB9rW79xojZx
         nAIqQmADurAap0myndKnvCQG3hTSdkkWNqyEaw+7X7W+IVREEoBpjQ+T1g3Xs12R2uqz
         tDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Vevo7ejaXcssHHgQzGNwjoQOcpQ59e4oftezJZAjPA=;
        b=BSA6RlVPl0TXOZ2fjsN0aldOPwbotN5+QQ0YWQVhHAjLGMPB+PDTWrtZtfj2iSZFrh
         dPWVUJcFTCJoIUc+UUvahB+dVhwE3nTStHTKNYW8x19oQePSzZ/l4t5PHJFEKJaDqWqb
         JKUeW76I4CNgU5QaJXpVgit3SdtaPYHanGSu7MSKEva13jgKxbhXJQxOCa/fhqmT4AGk
         lvOUFJ8NhnQG2xdSBKadVOX0VUU0CkMSM3WT2mOoGEClVZJSBNpDtscIsiDLm89nldLp
         5vGcbv4SVA7yeAL/Yyv0VKj5+YjdC4jlJA/AZat9HeBQ9oZF5u76ZMuSd7ZRiwlB8CwV
         dNPw==
X-Gm-Message-State: AOAM530t5mspsMmpBcm0iKVNtdrMUZqSuXWnf8kH8qHvpj7O4xJ3Idzs
        OD4UYE/SOwbq5R67EgSqIL8=
X-Google-Smtp-Source: ABdhPJz1CHl2x+3Mv02b7BoUpsfSsssHxHoLH0khC5l65hvcSPpsJpHMbYHYXTFMj0TSl4Dngg51cw==
X-Received: by 2002:a17:90b:3142:: with SMTP id ip2mr37487283pjb.63.1624283429175;
        Mon, 21 Jun 2021 06:50:29 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s42sm6678504pfw.184.2021.06.21.06.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:50:28 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 08/19] staging: qlge: reorder members of qlge_adapter for optimization
Date:   Mon, 21 Jun 2021 21:48:51 +0800
Message-Id: <20210621134902.83587-9-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before reordering, pahole shows,
    /* size: 21168, cachelines: 331, members: 69 */
    /* sum members: 21144, holes: 4, sum holes: 18 */
    /* padding: 6 */
    /* paddings: 6, sum paddings: 24 */
    /* forced alignments: 1 */
    /* last cacheline: 48 bytes */

After reordering following pahole's suggestion,
    /* size: 21152, cachelines: 331, members: 69 */
    /* sum members: 21144, holes: 1, sum holes: 2 */
    /* padding: 6 */
    /* paddings: 6, sum paddings: 24 */
    /* forced alignments: 1 */
    /* last cacheline: 32 bytes */

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 926af25b14fa..9177baa9f022 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2081,8 +2081,8 @@ struct qlge_adapter *netdev_to_qdev(struct net_device *ndev)
  */
 struct qlge_adapter {
 	struct ricb ricb;
-	unsigned long flags;
 	u32 wol;
+	unsigned long flags;
 
 	struct nic_stats nic_stats;
 
@@ -2103,6 +2103,8 @@ struct qlge_adapter {
 	spinlock_t adapter_lock;
 	spinlock_t stats_lock;
 
+	u32 intr_count;
+
 	/* PCI Bus Relative Register Addresses */
 	void __iomem *reg_base;
 	void __iomem *doorbell_area;
@@ -2123,7 +2125,6 @@ struct qlge_adapter {
 
 	int tx_ring_size;
 	int rx_ring_size;
-	u32 intr_count;
 	struct msix_entry *msi_x_entry;
 	struct intr_context intr_context[MAX_RX_RINGS];
 
@@ -2162,6 +2163,7 @@ struct qlge_adapter {
 	u32 max_frame_size;
 
 	union flash_params flash;
+	u16 device_id;
 
 	struct workqueue_struct *workqueue;
 	struct delayed_work asic_reset_work;
@@ -2171,7 +2173,6 @@ struct qlge_adapter {
 	struct delayed_work mpi_idc_work;
 	struct completion ide_completion;
 	const struct nic_operations *nic_ops;
-	u16 device_id;
 	struct timer_list timer;
 	atomic_t lb_count;
 	/* Keep local copy of current mac address. */
-- 
2.32.0

