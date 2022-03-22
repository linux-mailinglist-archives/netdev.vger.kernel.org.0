Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C324E3806
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 05:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbiCVEld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 00:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbiCVElc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 00:41:32 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1D266CB2
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:40:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so616150wmp.5
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pfAFSXsYW7IurbNR8wiZcNvhd8iQJitOFky0jQmj+GE=;
        b=GB0vdPxqx9g/nL6zny38I6ell/fxNm0856f+it1P/cHryW4h7EUjl20n9hqqPbv6gE
         XaKNlbfTILuAY276lEIKB6hxzl0t9v2pdPpVpnGzX3DObxCSAM/u9/Gt2H+FuQSMJ3rb
         eImTS4p3ijkvovwsccZlCo6PvInQnPyGYwY/BsAOssHELUEqozZn3fBJV+H6g+u7Eil7
         zEkUDAk0/Fbh1bwMu+8kFNy9dOEzjqv68NQ8hkhsisVPxWjN3uX5FfOukWR2iy1qAbHS
         8JhJm/tQlLWSlS+Pw8VGA0ONWTFvtfFrtFfgojhQKkNzd4KFZgj59+NXWnT6ukHLqI39
         /zuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pfAFSXsYW7IurbNR8wiZcNvhd8iQJitOFky0jQmj+GE=;
        b=DP0/Az98cLiVezHgZYb667co9LrH4AF7Zsl0X9nfDoe3mKezS0OeiLqU0H+htpaGZ6
         +sJY5uzGNkM9tT/YU5RXebWbYwXxoP077wvD0OSA05OWsN2Fgn27g2+O141RBuFP/6Gm
         0+eKCnLM+uCEbkZmx7OelBhP6RG4XMhNSV42meCNliYC+C1Xv+tTzJXXmcb6e6+Sj6Ge
         5WiOFPTIzEAIbVmwK7dityFOSYTEhOfT07ryIuyqGexsQ+7TnVviswqoyVnytKDnoagr
         n9LjeDLt3HrwFNAWNTOulgKyrZxGe5LusrdT7FgNAjQxfLeuTSidS+tSUq1QiHFcFoVr
         kmtQ==
X-Gm-Message-State: AOAM530STIGtv7dkQ45u6LMZEmB+pEdjXGky2Pwpu0JQb6VGr8SOTzey
        1zXxidI+VwLir7NlIltVtNaO2C+9jLKftw==
X-Google-Smtp-Source: ABdhPJzJpW6G30eMBgFHG1gZcorVr0WYMEHf2ZZqFbkwGbpg+s93m3HPrMzICxda0iQCV4prA4agQA==
X-Received: by 2002:a05:600c:a0a:b0:350:564b:d55e with SMTP id z10-20020a05600c0a0a00b00350564bd55emr1914081wmp.124.1647923999746;
        Mon, 21 Mar 2022 21:39:59 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id 185-20020a1c19c2000000b0038a1d06e862sm1011015wmz.14.2022.03.21.21.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 21:39:59 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net-next,v2] net: geneve: add missing netlink policy and size for IFLA_GENEVE_INNER_PROTO_INHERIT
Date:   Tue, 22 Mar 2022 06:39:54 +0200
Message-Id: <20220322043954.3042468-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing netlink attribute policy and size calculation.
Also enable strict validation from this new attribute onwards.

Fixes: 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

v2: add .strict_start_type on geneve policy (suggested by Jakub Kicinski)
---
 drivers/net/geneve.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 8f30660224c5..7db6c135ac6c 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1262,6 +1262,7 @@ static void geneve_setup(struct net_device *dev)
 }
 
 static const struct nla_policy geneve_policy[IFLA_GENEVE_MAX + 1] = {
+	[IFLA_GENEVE_UNSPEC]		= { .strict_start_type = IFLA_GENEVE_INNER_PROTO_INHERIT },
 	[IFLA_GENEVE_ID]		= { .type = NLA_U32 },
 	[IFLA_GENEVE_REMOTE]		= { .len = sizeof_field(struct iphdr, daddr) },
 	[IFLA_GENEVE_REMOTE6]		= { .len = sizeof(struct in6_addr) },
@@ -1275,6 +1276,7 @@ static const struct nla_policy geneve_policy[IFLA_GENEVE_MAX + 1] = {
 	[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_TTL_INHERIT]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_DF]		= { .type = NLA_U8 },
+	[IFLA_GENEVE_INNER_PROTO_INHERIT]	= { .type = NLA_FLAG },
 };
 
 static int geneve_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -1780,6 +1782,7 @@ static size_t geneve_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_TTL_INHERIT */
+		nla_total_size(0) +	 /* IFLA_GENEVE_INNER_PROTO_INHERIT */
 		0;
 }
 
-- 
2.32.0

