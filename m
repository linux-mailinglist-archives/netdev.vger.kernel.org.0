Return-Path: <netdev+bounces-3428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D268D707188
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDFF81C20EFA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D8731F0E;
	Wed, 17 May 2023 19:09:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F219E31EFE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:09:35 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066F9D07A;
	Wed, 17 May 2023 12:09:24 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-643a6f993a7so839983b3a.1;
        Wed, 17 May 2023 12:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684350563; x=1686942563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f6WVov+bnLXMOL8DiXreTcMhdqSvbTR7Fd9X+LdYwyE=;
        b=YpRgYw9tZWbaGZGYQP8w0uwt9hrh31TWFjUosBsvefsC9kZK2gHgyp5HraBcnEUxSi
         4HMB0hKB8tURZqUIRjGoQ9CdUhAENhAfeuBzY36WvUv1edukhQ4V0m0u9kBUVN1Tljf/
         07gJz8/AmHK1mfX4mGmM4uimc2yy88HjLUkNIB6D7mjwzSdy5PYIbZK3HRGxX3XOSiR/
         bPOpdcVRmc+6jTrKQh6s2H0vCttxJ+9MvQmcVa4W3bh+2wSqQCglZXVxgypps2itsopf
         R46txHwiya0Ud8gHGhNqi8FGRFX0Xx37Sp4uKWrUwgtdBGqLb4wjNCkamINzmplxES7e
         OQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350563; x=1686942563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f6WVov+bnLXMOL8DiXreTcMhdqSvbTR7Fd9X+LdYwyE=;
        b=MlypYVVM9xJLUZuBg7VoKUol1ogRllDIbhi9y1K5nUSq1TvvsfHcCCE8rKkMnK1bEh
         ocUkkw+Jhhnh2i8lGcas4v/2vB2ysn26LkwGMwlFNMxWtrUHXA4j+5OuNiXH50lwnWna
         HE9re8lC5K4YAbE7nw13dKXiqhwfIBvps4O9Ttc5MlpxhnVj8TKq2edEZfJjVIZqyqc9
         gdPDN7Pufad18vlerM3dpeKKvpJz/jvTYS/pjg8htECfEHK0Ee6XY74k6Yk0kb5/2U96
         bP416kR+AYKEa1RuSgR09AB3Z+1cDI7wAcqtKmfZapiVR3B9YQvRt50HLmlrgEJjZR7p
         pOrg==
X-Gm-Message-State: AC+VfDxKzLXm5n69SzsvRef6VMfSuEMWpuEt2jJj4DGy8Fe+fJi4gncY
	8m3rSnVxC/pnS09V1Ggsn9I=
X-Google-Smtp-Source: ACHHUZ5uN9up1EecQ7C/PmmncKVL/vnGeQt/VLMkiDtcE7xE8yeWl1itRLU5lJ1pWt2L5v+36LAVbA==
X-Received: by 2002:a05:6a20:8e07:b0:101:8f00:595f with SMTP id y7-20020a056a208e0700b001018f00595fmr34785076pzj.44.1684350563288;
        Wed, 17 May 2023 12:09:23 -0700 (PDT)
Received: from localhost.localdomain ([111.201.128.95])
        by smtp.gmail.com with ESMTPSA id p24-20020a62ab18000000b0063b5776b073sm15550842pff.117.2023.05.17.12.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:09:22 -0700 (PDT)
From: Yeqi Fu <asuk4.q@gmail.com>
To: mw@semihalf.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Yeqi Fu <asuk4.q@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: [PATCH] net: mvpp2: Fix error checking
Date: Thu, 18 May 2023 03:08:11 +0800
Message-Id: <20230517190811.367461-1-asuk4.q@gmail.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The function debugfs_create_dir returns ERR_PTR if an error occurs,
and the appropriate way to verify for errors is to use the inline
function IS_ERR. The patch will substitute the null-comparison with
IS_ERR.

Suggested-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Signed-off-by: Yeqi Fu <asuk4.q@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 75e83ea2a926..9c53f378edda 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -593,7 +593,7 @@ static int mvpp2_dbgfs_c2_entry_init(struct dentry *parent,
 	sprintf(c2_entry_name, "%03d", id);
 
 	c2_entry_dir = debugfs_create_dir(c2_entry_name, parent);
-	if (!c2_entry_dir)
+	if (IS_ERR(c2_entry_dir))
 		return -ENOMEM;
 
 	entry = &priv->dbgfs_entries->c2_entries[id];
@@ -626,7 +626,7 @@ static int mvpp2_dbgfs_flow_tbl_entry_init(struct dentry *parent,
 	sprintf(flow_tbl_entry_name, "%03d", id);
 
 	flow_tbl_entry_dir = debugfs_create_dir(flow_tbl_entry_name, parent);
-	if (!flow_tbl_entry_dir)
+	if (IS_ERR(flow_tbl_entry_dir))
 		return -ENOMEM;
 
 	entry = &priv->dbgfs_entries->flt_entries[id];
@@ -646,11 +646,11 @@ static int mvpp2_dbgfs_cls_init(struct dentry *parent, struct mvpp2 *priv)
 	int i, ret;
 
 	cls_dir = debugfs_create_dir("classifier", parent);
-	if (!cls_dir)
+	if (IS_ERR(cls_dir))
 		return -ENOMEM;
 
 	c2_dir = debugfs_create_dir("c2", cls_dir);
-	if (!c2_dir)
+	if (IS_ERR(c2_dir))
 		return -ENOMEM;
 
 	for (i = 0; i < MVPP22_CLS_C2_N_ENTRIES; i++) {
@@ -660,7 +660,7 @@ static int mvpp2_dbgfs_cls_init(struct dentry *parent, struct mvpp2 *priv)
 	}
 
 	flow_tbl_dir = debugfs_create_dir("flow_table", cls_dir);
-	if (!flow_tbl_dir)
+	if (IS_ERR(flow_tbl_dir))
 		return -ENOMEM;
 
 	for (i = 0; i < MVPP2_CLS_FLOWS_TBL_SIZE; i++) {
-- 
2.37.2


