Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A023D7B17
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhG0Qfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhG0Qfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:35:40 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6CC061796;
        Tue, 27 Jul 2021 09:35:38 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id h14so22732940lfv.7;
        Tue, 27 Jul 2021 09:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpuGLwzf9MyOM5GerH7zJ+gkF+GTFvncfsEHxn0Z2qc=;
        b=phd8BdyqDObRW6cMo+qe095dPWB83sBip4Mp6fxKy2pGg/ytzKVtm7Vp3IrDA5rGfx
         aIv47pbUgPVI8oB4VwvRQLYhBtj+60VQXNK4iUoWjlBRWlpxrGwunATbv1bnnWwkoPAv
         5OVznMvqGMNvP4UjM7ke+UiSOL4NLcd+ZoibN6xR9WxLaLBR1I5D/p/zAf7VNhDIeCWU
         0buCvKBp1lRKHEcfAgNeFY9aoPb2gis9ZXzTYYv6Ys4v5guEPmFaXGzX9Jl5WMu7s+xv
         ISaGIlFgNZbRuBZOZZ0SvkoCBle63rvyl0VrllKTChHmbe7oNOFfnb5XgW8LhCoi1DA5
         7gtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpuGLwzf9MyOM5GerH7zJ+gkF+GTFvncfsEHxn0Z2qc=;
        b=ajI+JkqWiLrPSuyFYpG/tBuk/qZ54AfaNhUvPUiOF5+QwL3ZCnb7FsGqYOHjdDVxgZ
         SynttkLk1ZK3kUHW0k2fJTeu3N0g0q54dvAElBw4wx2J2mW11QdzO6FLYSBHSItEe4pN
         goVhtjp6XSt43K6XFF3iwsFnzlzqmU465Aud2BNXYq08murlyfN5FLgRVKmNv9OUNCNp
         pkiMLvW2oyTxaOdIKm1x9zmuFf6Z9wpmT15KFfow+Hg+1HVlUQ9FKtaLvb14zcciIvSm
         0Ct+ssHrBkRjG01hqWxM1R0yZrNvo8hwQSMPxiGeDYdM7MXE6NS0cpHEBz8AtvNmYlg5
         oV+w==
X-Gm-Message-State: AOAM5325nef+vaKWOfqNXN1jAjc2jpo4TnbBRK57Gp5O18SLCRwsaprz
        3uuZrZ8uSf20DLj0hKeEDXY=
X-Google-Smtp-Source: ABdhPJxhfkzJQqO9PLc2J882SQKazuZfbROC8k2BiMiioL2dq4xPajmddJ4pNgXh8GtfKFdF3TAoaQ==
X-Received: by 2002:a19:f208:: with SMTP id q8mr17190113lfh.195.1627403736339;
        Tue, 27 Jul 2021 09:35:36 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id z8sm336136lfs.177.2021.07.27.09.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:35:35 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     paul@paul-moore.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Subject: [PATCH RESEND] net: cipso: fix warnings in netlbl_cipsov4_add_std
Date:   Tue, 27 Jul 2021 19:35:30 +0300
Message-Id: <20210727163530.3057-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported warning in netlbl_cipsov4_add(). The
problem was in too big doi_def->map.std->lvl.local_size
passed to kcalloc(). Since this value comes from userpace there is
no need to warn if value is not correct.

The same problem may occur with other kcalloc() calls in
this function, so, I've added __GFP_NOWARN flag to all
kcalloc() calls there.

Reported-and-tested-by: syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Fixes: 96cb8e3313c7 ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/netlabel/netlabel_cipso_v4.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index baf235721c43..000bb3da4f77 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -187,14 +187,14 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		}
 	doi_def->map.std->lvl.local = kcalloc(doi_def->map.std->lvl.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.local == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
 	}
 	doi_def->map.std->lvl.cipso = kcalloc(doi_def->map.std->lvl.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.cipso == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
@@ -263,7 +263,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.local = kcalloc(
 					      doi_def->map.std->cat.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.local == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
@@ -271,7 +271,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.cipso = kcalloc(
 					      doi_def->map.std->cat.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.cipso == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
-- 
2.32.0

