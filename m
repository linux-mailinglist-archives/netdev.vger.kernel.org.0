Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5991C695E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgEFGuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEFGui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:50:38 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB927C061A0F;
        Tue,  5 May 2020 23:50:38 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id p25so513196pfn.11;
        Tue, 05 May 2020 23:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ydko4XrYs4w1KKatK31nfPnq11ga6bQcsiSda7KjcmE=;
        b=W406yqoHA1efuiQF2WOnQJueVHN5DzZWZ4QTMRuQjpvHq4Xi79poFnuyn3Y74eEGCW
         eGWp35uZJiTsXrMyr4b+0BFLLj/peWJQHTqDNuDkPKU5L9ZV4qewPBtAg/LENRRrMd3P
         0gbUcBsUSp99sQgcZBwGTJ23Kn+xzKwDx91964cfsgqZZvjxWL1ScXVCAsCtKTjcAjlh
         ICSd04dynZRjp9bFtLcOxRYLZ32Aa9hQGxk2eEpw9lKBZtwiAMQFpzT6WW4OIitUdKH1
         +psAdhMsuwohMl1Qz3UnM15qvVAP5lbj/F2TLiOPd/9HdqBcHOOAyjn5+3w0VLxFYSDE
         QLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ydko4XrYs4w1KKatK31nfPnq11ga6bQcsiSda7KjcmE=;
        b=EtMbfOknYPG6Rx8IBPNJ6pfXoVrRL1lpSgdwIlSiCk5W2cUBXDM6tXYi7gnB+1lOF5
         KgT7lxFvBYKdySf1rHUYRYWmyV4xSGNcN4LD+axxo1Q4zS3emqkvwGHbP0B4rL+IIz90
         OXoAjSMzT5hbrLqGXUQODuayhuIXGvZQffuh9boeJjYRPXw5nOU0i7I+BNkxQvD9VfoD
         my0gaCf2uPCj2vr4BD5Mckq0nvRGuVkQuehbhCQjihrbnKKUv7VXRymiZzhsXZVXETci
         ZySEKuaUxvZ/8vo5b5/qYNTE8eBEoaL0L8C6akRCUcz9xdAYlhLF71EvaoU84fBgU4Ja
         W4qA==
X-Gm-Message-State: AGi0PuZYelNNsYgmZ6DQ84Gd/yXYCKRxjj2MzQEvmCfxZgK84jzfChrL
        xDo4026/75LtQd17EJC96jk=
X-Google-Smtp-Source: APiQypL0to3E2l1EVPw1+VbbevsDmw05pqwYr4q2mGN9v3c81J+Uv7fWCGTb66X7c+eVOhevTUSHtQ==
X-Received: by 2002:a63:d501:: with SMTP id c1mr5677377pgg.186.1588747838073;
        Tue, 05 May 2020 23:50:38 -0700 (PDT)
Received: from DESKTOP-9405E5V.localdomain ([185.173.93.36])
        by smtp.gmail.com with ESMTPSA id v94sm3970608pjb.39.2020.05.05.23.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 23:50:37 -0700 (PDT)
From:   Huang Qijun <dknightjun@gmail.com>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Huang Qijun <dknightjun@gmail.com>
Subject: [PATCH] netfilter: fix make target xt_TCPMSS.o error.
Date:   Wed,  6 May 2020 14:50:21 +0800
Message-Id: <20200506065021.2881-1-dknightjun@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling netfilter, there will be an error
"No rule to make target 'net/netfilter/xt_TCPMSS.o'",
because the xt_TCPMSS.c in the makefile is uppercase,
and the file name of the source file (xt_tcpmss.c) is lowercase.
Therefore, change the xt_TCPMSS.c name in the makefile to all lowercase.

Signed-off-by: Huang Qijun <dknightjun@gmail.com>
---
 net/netfilter/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0e0ded87e27b..b974ade24556 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -157,7 +157,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MASQUERADE) += xt_MASQUERADE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
-- 
2.17.1

