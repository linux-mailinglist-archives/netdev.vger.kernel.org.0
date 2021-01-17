Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E262F9195
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 10:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhAQJyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 04:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbhAQJxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 04:53:44 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2B9C061573;
        Sun, 17 Jan 2021 01:53:04 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id d4so6997576plh.5;
        Sun, 17 Jan 2021 01:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQpIDmpmqR2mhiXRTWsYQzQxNoPXxseuWN2BDaNXzQc=;
        b=QwIGfya5487IxpKUy2awClUDzH18/9jrPFlsm5JrBDHuR/CbYC7M/c3n7gNL6YL8Xn
         L+oRJOGig7Nr9kWsGNM/JH0+ut/dlCaCM5WIRwAyDEaCGnw8PWMW8M0P3DVqUFVMvbgH
         zsk037xx1l1NY7zdlAm/SKvVbDYct8RIIMN5dgBSV1ypMEo3V4fMWTeTA5vPfOOXm3b1
         tlWsYA8SqcW3cGZdIDw9FuimMHzjk8TCK7rnXrEv4izbngvOsmmUVi6Vxzme5BazihpV
         OwK2zYgnM7U5inF7DEB1A+ehh2CO2mYaz2DceEHDUAG2n6PEZ7Js+D8b12edasZ19jJz
         0LsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQpIDmpmqR2mhiXRTWsYQzQxNoPXxseuWN2BDaNXzQc=;
        b=FN2D4PsBKmkJOus5wHGRWMoDT0E81Zd1xEEjGaqkttkEfvxoZ7MWuMd+chRTJ92Wqk
         yppAoZupIq3IQ2piwwc99/sH9DXVKZUX3loOZEZEXJjwjmXsHDPQn+i7pBneXHQrY8ui
         1Mj+avb0Cy7xULmM80/g/qaDgaffo2uhYvoyYy892BJ4pifBFKYnzLIbjalFoXnGSSDs
         KkMaUQ9AFmnismf2uvG3qa7iQLBYoG5HkMt0xH5aaslOPvoD7RzXdEFkY1hHi8fEW7it
         hgPyk0tokLcS7GwM1uG95qRlP/bi1C+Q5LoAbHNxY3wNxCRNJPnfBxQJoTlnoYE1Da/t
         rjbA==
X-Gm-Message-State: AOAM5302E+rM8VxUWi7L+8mTaBob/vlG6mnaC/wxTGfVu7jmA3pP3rrW
        gA7DhjNxmT5K7gIzHRhtQJc=
X-Google-Smtp-Source: ABdhPJwBNZSDztLC0X6MXetQHJKOgoi96UXsmCBifxGvu57gupLxnzyKyVHFO7IAwuO0mrU+BpILYg==
X-Received: by 2002:a17:902:b28b:b029:de:6639:5cdb with SMTP id u11-20020a170902b28bb02900de66395cdbmr14081771plr.14.1610877182759;
        Sun, 17 Jan 2021 01:53:02 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id a2sm13194459pgi.8.2021.01.17.01.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 01:53:02 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk, rdna@fb.com,
        nicolas.dichtel@6wind.com, maheshb@google.com,
        keescook@chromium.org, dong.menglong@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: core: init every ctl_table in netns_core_table
Date:   Sun, 17 Jan 2021 17:52:28 +0800
Message-Id: <20210117095228.173512-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

For now, there is only one element in netns_core_table, and it is inited
directly in sysctl_core_net_init. To make it more flexible, we can init
every element at once, just like what ipv4_sysctl_init_net() did.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/core/sysctl_net_core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d86d8d11cfe4..966d976dee84 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -606,15 +606,19 @@ static __net_init int sysctl_core_net_init(struct net *net)
 
 	tbl = netns_core_table;
 	if (!net_eq(net, &init_net)) {
+		int i;
+
 		tbl = kmemdup(tbl, sizeof(netns_core_table), GFP_KERNEL);
 		if (tbl == NULL)
 			goto err_dup;
 
-		tbl[0].data = &net->core.sysctl_somaxconn;
+		/* Update the variables to point into the current struct net */
+		for (i = 0; i < ARRAY_SIZE(netns_core_table) - 1; i++) {
+			tbl[i].data += (void *)net - (void *)&init_net;
 
-		/* Don't export any sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns) {
-			tbl[0].procname = NULL;
+			/* Don't export any sysctls to unprivileged users */
+			if (net->user_ns != &init_user_ns)
+				tbl[i].procname = NULL;
 		}
 	}
 
-- 
2.30.0

