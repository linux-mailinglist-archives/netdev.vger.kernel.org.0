Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EA437B8C2
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 11:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhELJB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 05:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhELJBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 05:01:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4E5C061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:00:16 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b21so12219970plz.0
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3kWHPcIPxH6xBkkqHQHnZ5kOv8FqcXruq/cEL3UVw7M=;
        b=G9jELljQx8bfPFQgV09BFJPqJsR7t/r2Bc+QbIjnanawd1yA8JotPayDk8jj9ZsI3w
         CWu6TzdO2/oBMbl9FvFug9sral6dZ+UWTFDCq6NUX1JqleSRyPxJMRl1/w5Vru8KO9V6
         B+mf4jSpgsfDeNymOmEjpXCQaXfTUPjf3AH38B2Y/LfPykvL0Mke7XgGdcgMMuQFaqEz
         +LBInGjUUlkBIeeI1zzpNOMhWMZjQQX6jM/2bxFALB+yUSc9jrUeMgpWW+1PNVvz+Q06
         L7YmDByLxPFCFbxB8xIVbaisPlCKAG89c5txm2nspRIf0VGj0rh109vPg7sOTHYGcRrz
         TZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3kWHPcIPxH6xBkkqHQHnZ5kOv8FqcXruq/cEL3UVw7M=;
        b=QCTAM7UW25pAkbD2DQ2YmIphLZfSqdD9W999+2wC7bdkkZ8KRaP8hBxbwJbZuNWM1d
         9/1Q1WmeXYE/cKIKBfhtvdH52PdjTUN8fIgkIoK/O+0Gdv5GkdUiAxuyUdip68prvXBK
         z6FlVzJhbOnod3yryNSV62tRBp4n1fU47PwKFJFobJwSGw7W/HfLBUFmhKIzwJu7wdy0
         QbhMRgkbQkBtFyVOX8/IpFn7MZmJRA3Nup09ICVWYu37z9mie1dOPg/3Q5dE/W4rqYHp
         JiogoGg3wnyKrsTIo7kD1vYq03YlpStgQEOkus9pALn166n36z5bZp/3A/VjqoWTBgpp
         MiQA==
X-Gm-Message-State: AOAM533q93+J5wX2gF3CdeKOV4v15H73cvU/SMLo61Y/x1AJhZ8qnfUE
        OQ08MDbi907uYLI5p/Bjf7AkfPvzezGoYUJf2qo=
X-Google-Smtp-Source: ABdhPJw5unNIrm8AlyzVJWadRGzuCq/mSIwsUwXgykIEgKAPyXkM3E0K8KT6ekqg87HCPnpIyDpQ3w==
X-Received: by 2002:a17:902:6b8c:b029:ea:f54f:c330 with SMTP id p12-20020a1709026b8cb02900eaf54fc330mr34224760plk.10.1620810016394;
        Wed, 12 May 2021 02:00:16 -0700 (PDT)
Received: from fedora.localdomain (ec2-18-166-64-72.ap-east-1.compute.amazonaws.com. [18.166.64.72])
        by smtp.gmail.com with ESMTPSA id d13sm5523391pfn.136.2021.05.12.02.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 02:00:16 -0700 (PDT)
From:   Jim Ma <majinjing3@gmail.com>
To:     kuba@kernel.org, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, Jim Ma <majinjing3@gmail.com>
Subject: [PATCH] tls splice: remove inappropriate flags checking for MSG_PEEK
Date:   Wed, 12 May 2021 17:00:11 +0800
Message-Id: <7faf1af984494296416646af7b44851dfb450866.1620808650.git.majinjing3@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function tls_sw_splice_read, before call tls_sw_advance_skb
it checks likely(!(flags & MSG_PEEK)), while MSG_PEEK is used
for recvmsg, splice supports SPLICE_F_NONBLOCK, SPLICE_F_MOVE,
SPLICE_F_MORE, should remove this checking.

Signed-off-by: Jim Ma <majinjing3@gmail.com>
---
 net/tls/tls_sw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1dcb34dfd56b..7b59ec9a24c5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2018,8 +2018,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (copied < 0)
 		goto splice_read_end;
 
-	if (likely(!(flags & MSG_PEEK)))
-		tls_sw_advance_skb(sk, skb, copied);
+	tls_sw_advance_skb(sk, skb, copied);
 
 splice_read_end:
 	release_sock(sk);
-- 
2.31.1

