Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DCF2FA373
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404995AbhAROlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393075AbhAROkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:40:36 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B2CC061575;
        Mon, 18 Jan 2021 06:39:56 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id h10so10298024pfo.9;
        Mon, 18 Jan 2021 06:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BQpIDmpmqR2mhiXRTWsYQzQxNoPXxseuWN2BDaNXzQc=;
        b=ZhQ+6o4Ht6DtwDqPCRE5w8+NsbM5JnEbbNQoT0Hq200JUEbWvnvL/iK7sh4BPZ7jbh
         Z0qJKs+NUgflx49bja/2NeA4fZYhDaSC6yVyfa3XIb0LLG35ncRMPsyIBxU3ahca8Tgb
         jFjmmvwD8jYNoxD0gOi/sPR7eiWZKJeZZ5MvBIkhynueZ3FYv8NG1T6DvzBxIS70BYp9
         RwqrdVf1ze4lxxIA/B0RrRp/Azg216BM0cWIGEOB0Djlj4aUXSepmdSYZxqdkTL2o8pG
         SLey/ayWv2ULjAcTWYl6UcGzgmdkf9ameNFwM+YVMI3NMQRuv8MQDO1oJTBQLmn9FjwI
         hcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BQpIDmpmqR2mhiXRTWsYQzQxNoPXxseuWN2BDaNXzQc=;
        b=EUqJ2sLFS5YkCZId2cY8IYoFNmfJ29jdM2yIcQRXhLAJVH5VkNYFp4Ng0X0/wvUGNK
         7sFVjuYordmOAOegXCv2oTw2PgnZW11B621BmAbGyVZkPPYJHwfCroPGnDxw7cED+eHb
         JALF2+JxDVMOY19gg2itwIVpfywNQqVYR8ImlXXqvFYnxoJ2b9EiZ0LSI8FFTvYm7c1b
         YfLg5rgob/jZTzDvY2PBocVW7OEJcEkSnzazRylLlJcFONyiil0cFmFP/8ntT8sB48Xu
         JkK/qpfNYxjlwg9FzByfkemrqdgnc9P1YiBTM8FGgMz9tP826d6cj2/3eEidCMaKXynR
         4dGQ==
X-Gm-Message-State: AOAM530xk8muwYKbfQVXWEfVget/u42cUn1WrsBhi78EDukPUXsWlnFM
        u1twP3wpy6Cee9SuiHDcSTE=
X-Google-Smtp-Source: ABdhPJxnyv3ZffDGzg5YpRKik0DeLOfZXZlZ0mNAAQgZ+VsddMNyRm36u5dTkOTCjja7XY3Xfuqchw==
X-Received: by 2002:a62:e704:0:b029:1b9:cb4:7626 with SMTP id s4-20020a62e7040000b02901b90cb47626mr637227pfh.52.1610980795610;
        Mon, 18 Jan 2021 06:39:55 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id c14sm15405219pfd.37.2021.01.18.06.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 06:39:55 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org, christian.brauner@ubuntu.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dong.menglong@zte.com.cn, daniel@iogearbox.net, gnault@redhat.com,
        ast@kernel.org, nicolas.dichtel@6wind.com, ap420073@gmail.com,
        edumazet@google.com, pabeni@redhat.com, jakub@cloudflare.com,
        bjorn.topel@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, rdna@fb.com, maheshb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: core: init every ctl_table in netns_core_table
Date:   Mon, 18 Jan 2021 22:39:30 +0800
Message-Id: <20210118143932.56069-2-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118143932.56069-1-dong.menglong@zte.com.cn>
References: <20210118143932.56069-1-dong.menglong@zte.com.cn>
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

