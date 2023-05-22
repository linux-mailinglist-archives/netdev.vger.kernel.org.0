Return-Path: <netdev+bounces-4383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC2170C4B4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 820E11C20B66
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A491F16432;
	Mon, 22 May 2023 17:54:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9950116414
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:54:20 +0000 (UTC)
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E787FF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:54:18 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-75b0b2d0341so129656785a.3
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1684778057; x=1687370057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wEqWElYBvjdKcr1YhIuFc5Qj3tyV8QRPx88QVWOG9EA=;
        b=dnd90+vO/uDkfZJPF6vrp2YlQ49Vpytx0Z8okkqPz9Y8zuAchNJ0DF3ab/NFdwYLDq
         Jgxoa8QHe5jivpSesZLo7MsP2lVcQhm8WgVB701mM+jHnZjcTW7xHhrg+Z04efMcAo/I
         3MD1IeBMk7Ax4kfBIiXjkW3Clk3l8CYAd4o+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684778057; x=1687370057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wEqWElYBvjdKcr1YhIuFc5Qj3tyV8QRPx88QVWOG9EA=;
        b=Pc75SkWNCTlG5Vy2mZx89QZgXkiSl26KgZalHd0pG/yztFXast7M/KiM7N6JAtaCei
         kPGm90IPRr7sSnH2GMB4A/RM+hjjCx0iKYbhIAta4RDoj5BJzt8tbNVUl5fAoBolFB4A
         kw8CpXkzmRsikrMR2iw5RyDZ6AO4GetL2ZXm8hevW9rigC8W5BZGMupJou+HxLb+5caB
         Wuh45Y1/01wtFWrjpPdp2Hrnq1puUXIeCUUYzKYAJEjWjuh4osSd5zef/NXSBXnGArGw
         v34yEjHD5x+5nFVGXa5Jd/lzsQ4xQ9+xAJYUqz2n+q+Wx9X1CuAxNcCBRwNtZTfHoinM
         4iuw==
X-Gm-Message-State: AC+VfDylHMQ2fBXeK5GGWq4hs4xXXJsWCXAesSnuSrP89gZBDEGFq6yQ
	2I4uGmb9sXsN3s5lqzDyLVIR97nw14sJPPiInoXp0w==
X-Google-Smtp-Source: ACHHUZ5zF/qY6ruJ9WoS8VTO6KgR2xwdQgJ6xH/fxNjlPBKs/pW+rbGqw9If7hjdMeqavlJio/STdA==
X-Received: by 2002:a37:ef09:0:b0:75b:23a1:463 with SMTP id j9-20020a37ef09000000b0075b23a10463mr1658318qkk.41.1684778057083;
        Mon, 22 May 2023 10:54:17 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (host-87-20-242-136.retail.telecomitalia.it. [87.20.242.136])
        by smtp.gmail.com with ESMTPSA id u11-20020ae9c00b000000b0074df476504asm1867054qkk.61.2023.05.22.10.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 10:54:16 -0700 (PDT)
From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
To: netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>
Subject: [PATCH ethtool v2, 1/1] netlink/rss: move variable declaration out of the for loop
Date: Mon, 22 May 2023 19:54:01 +0200
Message-Id: <20230522175401.1232921-1-dario.binacchi@amarulasolutions.com>
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
Changes in v2:
- Change 'int' to 'unsigned int'.
---
 netlink/rss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/netlink/rss.c b/netlink/rss.c
index 4ad6065ef698..a31c10aeca95 100644
--- a/netlink/rss.c
+++ b/netlink/rss.c
@@ -93,6 +93,7 @@ int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	bool silent;
 	int err_ret;
 	int ret;
+	unsigned int i;
 
 	silent = nlctx->is_dump || nlctx->is_monitor;
 	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
@@ -163,7 +164,7 @@ int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
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


