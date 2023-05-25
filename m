Return-Path: <netdev+bounces-5405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC66E711222
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 908852815D7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2721DDC9;
	Thu, 25 May 2023 17:28:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8572F1D2A2
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 17:28:02 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2C69B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:28:01 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ae3ed1b08eso16600375ad.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685035680; x=1687627680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5iBIMRBIWaYvrh9/1dsrlPKuATjxDe/L+49PDNlj8N4=;
        b=F5+l05vf1JXZMeg+J4sr628hODIXFTpfmialx42eN/4NemOxAzAAmXWyMSZ3yX4iQi
         a3XTX6gC5X0wPGcn5C9KjSuwaOIrdtiGkXx3cQb7oNyQMZFOc21JBJLS1yn8mqygogIz
         nnZI0iuJEmg3ecItR02Cv7BAXO9qVYCvNbToKK0duwwO+RLZguI4zJwBJiL61U/dXnX+
         B+mQzsqThwFhdhqErIu0VArK+2Vf3pSuhVZpO0Oza4Ny/vaDn1UMSnwqLuS6ZWzmZHMG
         hLu3hqej2QZH93Q02jQfIhIhniXPYh7ny8C7nuuwtL394WRbS8PZvD39cVcFn9nmVcQ6
         k8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685035680; x=1687627680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iBIMRBIWaYvrh9/1dsrlPKuATjxDe/L+49PDNlj8N4=;
        b=RPk8EKm4I/Tuxy3FccA4/ASVoXkHW/uqTSsFGtelGhH9BvpRj4lm6VoD+SUofcDOdD
         R684sVsYDOdl1iJlVKyxdf9+lxkeCppgnzOmbWYT92Rc5jAhDdAQHN1H9UJK6WRE5KAA
         8ohroQUx8NuzYYyFFZ7hxVU1ePuvG+kGReRqmTIaHJVojxAzBDp5qu481y/e/+mVnv+X
         lmbCZJwSRgrtTlD92NsH/ZdA7gny+axhsI1BK5C/xgoVyZCtMuWP4NDGNhytRhFuNO0O
         p976ulHCigI8SlRgnlRTaCXmzWDrioRV3XZi3cAen9KAuCf3lpO6RIhhxF4upmepTZeE
         t32g==
X-Gm-Message-State: AC+VfDyVhz1Z7gIel+o4+oc8FHaHHKs7E1CmqsWhgOpXMXcT/LWvFW2J
	i/FnSumF0bJ/Atb8RThlIZg=
X-Google-Smtp-Source: ACHHUZ5FocyASQxLLZPG14LH9wekof6WDmBDpKtvh+ZYmJg5GtJJ9y71Fr3JyeyM8xptZkPYr7qcCQ==
X-Received: by 2002:a17:903:182:b0:1af:b92d:b5fe with SMTP id z2-20020a170903018200b001afb92db5femr2551788plg.0.1685035680135;
        Thu, 25 May 2023 10:28:00 -0700 (PDT)
Received: from Osmten.. ([103.84.150.78])
        by smtp.gmail.com with ESMTPSA id s12-20020a170902a50c00b001a96496f250sm1683719plq.34.2023.05.25.10.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 10:27:59 -0700 (PDT)
From: Osama Muhammad <osmtendev@gmail.com>
To: krzysztof.kozlowski@linaro.org,
	simon.horman@corigine.com
Cc: netdev@vger.kernel.org,
	Osama Muhammad <osmtendev@gmail.com>
Subject: [PATCH v2] nfcsim.c: Fix error checking for debugfs_create_dir
Date: Thu, 25 May 2023 22:27:46 +0500
Message-Id: <20230525172746.17710-1-osmtendev@gmail.com>
X-Mailer: git-send-email 2.34.1
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

This patch fixes the error checking in nfcsim.c.
The DebugFS kernel API is developed in
a way that the caller can safely ignore the errors that
occur during the creation of DebugFS nodes.

Signed-off-by: Osama Muhammad <osmtendev@gmail.com>

---

changes since v1:
        -Dropped the error checking for debugfs_create_dir
---
 drivers/nfc/nfcsim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index 44eeb17ae48d..a55381f80cd6 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -336,10 +336,6 @@ static struct dentry *nfcsim_debugfs_root;
 static void nfcsim_debugfs_init(void)
 {
 	nfcsim_debugfs_root = debugfs_create_dir("nfcsim", NULL);
-
-	if (!nfcsim_debugfs_root)
-		pr_err("Could not create debugfs entry\n");
-
 }
 
 static void nfcsim_debugfs_remove(void)
-- 
2.34.1


