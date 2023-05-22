Return-Path: <netdev+bounces-4363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7826E70C31D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1998B1C20B4C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673E716403;
	Mon, 22 May 2023 16:17:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B35516402
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 16:17:29 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CB1DB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:17:28 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f38d2c36fdso29406031cf.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1684772247; x=1687364247;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hXEHLolpcXfaf2OmvK4vDG9lSI8qy/yQykkSoO5i5Qo=;
        b=LEqPpteXwny2l9v+jW5R8QD630a3LXQ7WLWXYkyUnJdT6PT4ymdQAkdipeFFfiYjHh
         kI1KjxSdO1O37WbtN6VrmOfNk4EZ5IUItwPsSODHsHF+hcHiZ8O8ZqGErtz6vXvNppLK
         NEeiuHuNXcGJLBWvezwfN7WDjL4SXGuqXlRdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684772247; x=1687364247;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hXEHLolpcXfaf2OmvK4vDG9lSI8qy/yQykkSoO5i5Qo=;
        b=Fx+JlHdkGpmo+D8BalDleyltINXEg+k05p1EsoxSJBNZj+FPphx+mIW2FPB8tPFJvW
         /2YblSUZ3eHjByLT7oLVdkPhpMBzDpypgeIjhM2jU+7DZV09t4ZyHTMmtLgN+xd7oSPr
         8VNU/CCNQzz8Fh8NQ2irnBVHfnxzLPoILyjkWUnqh/MKlpj6dp3KZ6t8H3ewp8DyjaNk
         92uUQXsx8evYJXk9spOj7ay6GNFqbnv8nn3sy45vcNGIqe8PUcRRHaHTQgj7SPg2+V7Z
         9m8j0bHt3zHXVnVeh/B7vpmG3n+8aAAOtsWTwRpbUnKPnAYi8f75VB7exJr3h2NG+EJm
         6Sfw==
X-Gm-Message-State: AC+VfDwFqymHTDUFa7m91lpWxNp8bmpxFQRpRxcDwUZC1IWy9DzFDgR+
	nZXVFj8Ptp39zJqSqkZivJDDbbIY2eWBS13sToz1ZQ==
X-Google-Smtp-Source: ACHHUZ5xoqkAfZWnjHa5srwGlStLPc7+HIrFwe2pGktshMiDKXtVphPQk9sF29XdA8Z+QJS1XV73eA==
X-Received: by 2002:a05:622a:34c:b0:3f4:e11b:d19a with SMTP id r12-20020a05622a034c00b003f4e11bd19amr19241292qtw.6.1684772246867;
        Mon, 22 May 2023 09:17:26 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (host-87-20-242-136.retail.telecomitalia.it. [87.20.242.136])
        by smtp.gmail.com with ESMTPSA id m3-20020a0ce8c3000000b00623813aa1d5sm2058486qvo.89.2023.05.22.09.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 09:17:26 -0700 (PDT)
From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
To: netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>
Subject: [PATCH ethtool 1/1] netlink/rss: move variable declaration out of the for loop
Date: Mon, 22 May 2023 18:17:10 +0200
Message-Id: <20230522161710.1223759-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The patch fixes this compilation error:

netlink/rss.c: In function 'rss_reply_cb':
netlink/rss.c:166:3: error: 'for' loop initial declarations are only allowed in C99 mode
   for (unsigned int i = 0; i < get_count(hash_funcs); i++) {
   ^
netlink/rss.c:166:3: note: use option -std=c99 or -std=gnu99 to compile your code

The project doesn't really need a C99 compiler, so let's move the variable
declaration outside the for loop.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---
 netlink/rss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/netlink/rss.c b/netlink/rss.c
index 4ad6065ef698..a4a72e83fcf0 100644
--- a/netlink/rss.c
+++ b/netlink/rss.c
@@ -92,7 +92,7 @@ int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	u8 *hkey = NULL;
 	bool silent;
 	int err_ret;
-	int ret;
+	int i, ret;
 
 	silent = nlctx->is_dump || nlctx->is_monitor;
 	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
@@ -163,7 +163,7 @@ int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 			printf("    Operation not supported\n");
 			return 0;
 		}
-		for (unsigned int i = 0; i < get_count(hash_funcs); i++) {
+		for (i = 0; i < get_count(hash_funcs); i++) {
 			printf("    %s: %s\n", get_string(hash_funcs, i),
 			       (rss_hfunc & (1 << i)) ? "on" : "off");
 		}
-- 
2.32.0


