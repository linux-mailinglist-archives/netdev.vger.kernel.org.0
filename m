Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974716EA1E8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbjDUCvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbjDUCvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E132D76AA;
        Thu, 20 Apr 2023 19:51:04 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b35789313so1362748b3a.3;
        Thu, 20 Apr 2023 19:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045464; x=1684637464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwtUCKMDpoTm9KXX0yGrXQSd2H3Fgy9ECPbB0fz8oGo=;
        b=cRJhfKuPjaED++LchZsJzv3xv2rfNzoPZmErb4pfag5q1r7/g5SiDmE5lJmQZdSg0C
         Y6H3eUOTI/N7cG2u7vHVCwtPtgx76TWwDthHKaUOdDXhqudG4ncOx5I+9HxyuIZoZXUA
         l5fM8XwbhWUdkztqx8ommuepL9dKuw0aAlRQW1czU4ZdFsz/H4Zw7Tuh5Ku5izmM2d9q
         Z7969/wHOFjZxsOGYWplKZaPsPhyWaXjQTglVTt1+pL5RbrritkAgmQUq7LLwmquHLnz
         i4X6DFh92x3Wyahf1P+N6mOzZwxfZUpIpurZWY0cweTU2+OjGoMijp8Qsydoc98mIrsh
         kt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045464; x=1684637464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AwtUCKMDpoTm9KXX0yGrXQSd2H3Fgy9ECPbB0fz8oGo=;
        b=QVi1A6bCmvREN7v5pKkB0br0UliXxXlTLtYKBsT9g11V/U/lOBycP5zcA/bJEIEuCG
         QhbqR6F2cJSXT0ISLUNLmWfTNOJeIjztxLE92rjAggzf9DUl7B60XTsVJ/YGBAmddTUD
         I7Vd+fKYAvHgEyyR7rLWD04qiyCGfVAybRf4KoOxOnI0dHVpvPs6l+T/HyNodpr+ThYA
         MtXPDLEWGfRFmWApQfrG3Rl7HBGLnDYT5dSYwfepf1EqE+we21TlTfDARd6RW1314CRd
         0/8Xj5+rHh0NTLgtzZH2o60y517wscuvdHhL0M8+VW9nIatvTKGvOSkPUuZ1LeDlW5O2
         R3+Q==
X-Gm-Message-State: AAQBX9frGwRCgePWPDYhZ9fNICwlzSmCA2wHIiJdRL0zDogUYhHb8Inh
        o0v7XYR99Kk6dvUSbfJlEpw=
X-Google-Smtp-Source: AKy350YsvomD8llNpTPI6MKfV1GUHF1tBZbXiJWJQloLPuSmO9Ene9EfjX1LBH5Zt7qlTvFL5MsGTA==
X-Received: by 2002:a05:6a21:6da7:b0:f2:6984:b8d with SMTP id wl39-20020a056a216da700b000f269840b8dmr1152992pzb.29.1682045463979;
        Thu, 20 Apr 2023 19:51:03 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id q10-20020a63d60a000000b0051eff0a70d7sm1647561pgg.94.2023.04.20.19.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:03 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>,
        Srujana Challa <schalla@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, netdev@vger.kernel.org
Subject: [PATCH 07/22] net: octeontx2: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:31 -1000
Message-Id: <20230421025046.4008499-8-tj@kernel.org>
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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: Srujana Challa <schalla@marvell.com>
Cc: Geetha sowjanya <gakula@marvell.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c     |  5 ++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c    | 13 +++++--------
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c    |  5 ++---
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 8683ce57ed3f..207041c81184 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3013,9 +3013,8 @@ static int rvu_flr_init(struct rvu *rvu)
 			    cfg | BIT_ULL(22));
 	}
 
-	rvu->flr_wq = alloc_workqueue("rvu_afpf_flr",
-				      WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
-				       1);
+	rvu->flr_wq = alloc_ordered_workqueue("rvu_afpf_flr",
+					      WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!rvu->flr_wq)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 179433d0a54a..7b3114105757 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -271,8 +271,7 @@ static int otx2_pf_flr_init(struct otx2_nic *pf, int num_vfs)
 {
 	int vf;
 
-	pf->flr_wq = alloc_workqueue("otx2_pf_flr_wq",
-				     WQ_UNBOUND | WQ_HIGHPRI, 1);
+	pf->flr_wq = alloc_ordered_workqueue("otx2_pf_flr_wq", WQ_HIGHPRI);
 	if (!pf->flr_wq)
 		return -ENOMEM;
 
@@ -593,9 +592,8 @@ static int otx2_pfvf_mbox_init(struct otx2_nic *pf, int numvfs)
 	if (!pf->mbox_pfvf)
 		return -ENOMEM;
 
-	pf->mbox_pfvf_wq = alloc_workqueue("otx2_pfvf_mailbox",
-					   WQ_UNBOUND | WQ_HIGHPRI |
-					   WQ_MEM_RECLAIM, 1);
+	pf->mbox_pfvf_wq = alloc_ordered_workqueue("otx2_pfvf_mailbox",
+						   WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!pf->mbox_pfvf_wq)
 		return -ENOMEM;
 
@@ -1063,9 +1061,8 @@ static int otx2_pfaf_mbox_init(struct otx2_nic *pf)
 	int err;
 
 	mbox->pfvf = pf;
-	pf->mbox_wq = alloc_workqueue("otx2_pfaf_mailbox",
-				      WQ_UNBOUND | WQ_HIGHPRI |
-				      WQ_MEM_RECLAIM, 1);
+	pf->mbox_wq = alloc_ordered_workqueue("otx2_pfaf_mailbox",
+					      WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!pf->mbox_wq)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index ab126f8706c7..1f16e0dcbb3e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -297,9 +297,8 @@ static int otx2vf_vfaf_mbox_init(struct otx2_nic *vf)
 	int err;
 
 	mbox->pfvf = vf;
-	vf->mbox_wq = alloc_workqueue("otx2_vfaf_mailbox",
-				      WQ_UNBOUND | WQ_HIGHPRI |
-				      WQ_MEM_RECLAIM, 1);
+	vf->mbox_wq = alloc_ordered_workqueue("otx2_vfaf_mailbox",
+					      WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!vf->mbox_wq)
 		return -ENOMEM;
 
-- 
2.40.0

