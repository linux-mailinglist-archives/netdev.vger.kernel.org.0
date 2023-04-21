Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D106EA1EA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbjDUCvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjDUCvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:13 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C8E7692;
        Thu, 20 Apr 2023 19:51:07 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-51f597c975fso1744062a12.0;
        Thu, 20 Apr 2023 19:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045466; x=1684637466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OMa4H5B7cQ31o0iO4EHjR7g/GmtbQFAxNrqAS+m3rA=;
        b=ed6rzYNuCkWaolQBt1qf/IaUHcwfXxuC5SbNdlIaF08ctYw+9Z4paHRTmDAW4FtsAi
         N8RRJRPFzktovjo7fpVlYA/p6AaCY2AgPdiXX26Trrodn72gYdhzSan2w7mBlOMVDpUJ
         Tr6WoSC7BQ3lAtWHPpOrAcdMolmjkqZdiwhEkvWcfAyx5mxkKHBVpV29sanYgaENW+iB
         +qOzsE1CiFbnqXwPWFDS3+KT81w7mLwRl1srwhsJW8DNKiJeKXelf8/Y8MuXTaCSEATO
         1sp3CO6Lcx7iYnFy96NZbqYOjwpuPOb4qGltDAHHFWPwW5qvBsQYFUJnI1/aDJL9yayh
         unVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045466; x=1684637466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2OMa4H5B7cQ31o0iO4EHjR7g/GmtbQFAxNrqAS+m3rA=;
        b=GEMcwc5ZnkdVqUCwhYmulVUNujuN8xZVGiU06LHJmc9GUc0B2oBYbs5xtgL0gm4QcS
         U2NIO7O3ZHRA+xFDq0tNwBk8s3xfa0i5mVjTQ82QaKmN53XOQRXJ3/8mxCLAItSwCBuQ
         16v3jIuHc142Kos3kR7s0a8V/f6Errf2ouevAflZcqBDgMqTI/6lEjBCCnZtWxu4GDph
         34hU23Xkn9ZQOeN0vFy1pNZXmSPoVgWz7jfThsPOAlLaD5/pUe+3nzL7bGwA/UZesiRs
         PPdiZMs9+rKmVSq2Vh+WIxBHGTfhYOzu68Tl/Rp8TlplvQRcfImLSixbyV3X8GUDieec
         tTAw==
X-Gm-Message-State: AAQBX9cNaWqTcwL6PVXsLpnebGR7mDb47aPDAk8QXjYZE/29ysL6CF/k
        llvAAKU0GPvb2RQMYf0RRDD8Gs1HXuU=
X-Google-Smtp-Source: AKy350YTA23CBRwccIcJyFzB9Mc/n2eh72ar0ILix9ZmPuI+GmvdpgvBas6cCJHx++m1HW0Azj8EOg==
X-Received: by 2002:a17:90a:ea09:b0:23f:7d05:8762 with SMTP id w9-20020a17090aea0900b0023f7d058762mr3389480pjy.23.1682045465785;
        Thu, 20 Apr 2023 19:51:05 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id jj2-20020a170903048200b001a6d08dc847sm1734028plb.173.2023.04.20.19.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:05 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/22] wifi: ath10/11/12k: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:32 -1000
Message-Id: <20230421025046.4008499-9-tj@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421025046.4008499-1-tj@kernel.org>
References: <20230421025046.4008499-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BACKGROUND
==========

When multiple work items are queued to a workqueue, their execution order
doesn't match the queueing order. They may get executed in any order and
simultaneously. When fully serialized execution - one by one in the queueing
order - is needed, an ordered workqueue should be used which can be created
with alloc_ordered_workqueue().

However, alloc_ordered_workqueue() was a later addition. Before it, an
ordered workqueue could be obtained by creating an UNBOUND workqueue with
@max_active==1. This originally was an implementation side-effect which was
broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active==1 to be
ordered"). Because there were users that depended on the ordered execution,
5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
made workqueue allocation path to implicitly promote UNBOUND workqueues w/
@max_active==1 to ordered workqueues.

While this has worked okay, overloading the UNBOUND allocation interface
this way creates other issues. It's difficult to tell whether a given
workqueue actually needs to be ordered and users that legitimately want a
min concurrency level wq unexpectedly gets an ordered one instead. With
planned UNBOUND workqueue updates to improve execution locality and more
prevalence of chiplet designs which can benefit from such improvements, this
isn't a state we wanna be in forever.

This patch series audits all callsites that create an UNBOUND workqueue w/
@max_active==1 and converts them to alloc_ordered_workqueue() as necessary.

WHAT TO LOOK FOR
================

The conversions are from

  alloc_workqueue(WQ_UNBOUND | flags, 1, args..)

to

  alloc_ordered_workqueue(flags, args...)

which don't cause any functional changes. If you know that fully ordered
execution is not ncessary, please let me know. I'll drop the conversion and
instead add a comment noting the fact to reduce confusion while conversion
is in progress.

If you aren't fully sure, it's completely fine to let the conversion
through. The behavior will stay exactly the same and we can always
reconsider later.

As there are follow-up workqueue core changes, I'd really appreciate if the
patch can be routed through the workqueue tree w/ your acks. Thanks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/ath/ath10k/qmi.c | 3 +--
 drivers/net/wireless/ath/ath11k/qmi.c | 3 +--
 drivers/net/wireless/ath/ath12k/qmi.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 90f457b8e1fe..ebedef8767cd 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -1082,8 +1082,7 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
 	if (ret)
 		goto err;
 
-	qmi->event_wq = alloc_workqueue("ath10k_qmi_driver_event",
-					WQ_UNBOUND, 1);
+	qmi->event_wq = alloc_ordered_workqueue("ath10k_qmi_driver_event", 0);
 	if (!qmi->event_wq) {
 		ath10k_err(ar, "failed to allocate workqueue\n");
 		ret = -EFAULT;
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index ab923e24b0a9..26b252e62909 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3256,8 +3256,7 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
 		return ret;
 	}
 
-	ab->qmi.event_wq = alloc_workqueue("ath11k_qmi_driver_event",
-					   WQ_UNBOUND, 1);
+	ab->qmi.event_wq = alloc_ordered_workqueue("ath11k_qmi_driver_event", 0);
 	if (!ab->qmi.event_wq) {
 		ath11k_err(ab, "failed to allocate workqueue\n");
 		return -EFAULT;
diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 979a63f2e2ab..471810877eed 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3054,8 +3054,7 @@ int ath12k_qmi_init_service(struct ath12k_base *ab)
 		return ret;
 	}
 
-	ab->qmi.event_wq = alloc_workqueue("ath12k_qmi_driver_event",
-					   WQ_UNBOUND, 1);
+	ab->qmi.event_wq = alloc_ordered_workqueue("ath12k_qmi_driver_event", 0);
 	if (!ab->qmi.event_wq) {
 		ath12k_err(ab, "failed to allocate workqueue\n");
 		return -EFAULT;
-- 
2.40.0

