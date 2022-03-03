Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64304CC4E6
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiCCSRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiCCSRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:34 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5D91A39E2
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:48 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id p17so5319217plo.9
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aBQM8wNOxbvrRsNnfmdlVwJl6wi5pr+JOyZvAg1e78=;
        b=CmmQoHKkd7R1qYbvWj9EBEKTzS5g48bOc0U87tmu8Pi/Qqx1YTbqxZfbFWOqamHJeo
         A+DXiAn3Kd11jFExEm4lJRNe4rvtDHpheKn3UwffPG9HpmSH2RW4KFFt9QKEdlu8tZa+
         ZfSHyPcidSOqQZab5AUceUsrv6RVe2D+2HC2Sx9hoZU3fW9EuItzdb1FEDllmzhDjsdt
         jOVjgVzKJVt/dKkPObKY+zJo44QldzXxR/jt3KlE5hap5rjA5Bp8Ik7yWsWKyBxiKQw4
         0fWS8LKearRkhQjyUqY9bEovHeDSwxKQFXRBlIotEQrVXs1HXW9QpROvjm1STuZjM1fO
         /0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aBQM8wNOxbvrRsNnfmdlVwJl6wi5pr+JOyZvAg1e78=;
        b=i/88GTbwBF+iO3HvYiw4K5TswBNnsKs5OBY3C9QN+pshNQpcnm8xwX/sLkrAIviHTy
         RiG6nnuY9XSkk3qP5P9IPnylGYxzQojBgkGEDeuHPGXXt7y/Gw6BOpoNtydB+KuXrRzR
         a/aE+qppREk4uuZ670azwdQQTRxmf9+h6W3DHFKXMYABTRnAhwpuMsOQ2bPBgzYEyXGT
         12SWK6Vcw4l1iLD1OZt9XwETLl+hdblCAAYKEqKfwtVZS5eJFjw4COKKLzRsAafhtv62
         oZtJ6GcDX3YVH8i8y6ZrUSLv9kqXhE25wDu39VwwGhyNxVc3Mka6r6IZ6XmjQFuxpcH7
         UluA==
X-Gm-Message-State: AOAM531kvlLuORMs6n7QiCR4GzRbT76Ba4g5vJhcmmjMhwFxbKBbohDb
        8dnyi1dTGYoGZG3VDjkAiVU=
X-Google-Smtp-Source: ABdhPJw9t+tUOeOLe/Uvw1q+XZ6c7JbgyP69AtpICY9Pk6s+ShZH8nxM2fOgykF6DqFuVN7e503qMQ==
X-Received: by 2002:a17:90b:4d0f:b0:1bf:6a2:5637 with SMTP id mw15-20020a17090b4d0f00b001bf06a25637mr6697066pjb.106.1646331407807;
        Thu, 03 Mar 2022 10:16:47 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:47 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 10/14] bonding: update dev->tso_ipv6_max_size
Date:   Thu,  3 Mar 2022 10:16:03 -0800
Message-Id: <20220303181607.1094358-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220303181607.1094358-1-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Use the minimal value found in the set of lower devices.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/bonding/bond_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 55e0ba2a163d0d9c17fdaf47a49d7a2190959651..357188c1f00e6e3919740adb6369d75712fc4e64 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1420,6 +1420,7 @@ static void bond_compute_features(struct bonding *bond)
 	struct slave *slave;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int gso_max_size = GSO_MAX_SIZE;
+	unsigned int tso_ipv6_max_size = ~0U;
 	u16 gso_max_segs = GSO_MAX_SEGS;
 
 	if (!bond_has_slaves(bond))
@@ -1450,6 +1451,7 @@ static void bond_compute_features(struct bonding *bond)
 			max_hard_header_len = slave->dev->hard_header_len;
 
 		gso_max_size = min(gso_max_size, slave->dev->gso_max_size);
+		tso_ipv6_max_size = min(tso_ipv6_max_size, slave->dev->tso_ipv6_max_size);
 		gso_max_segs = min(gso_max_segs, slave->dev->gso_max_segs);
 	}
 	bond_dev->hard_header_len = max_hard_header_len;
@@ -1465,6 +1467,7 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->mpls_features = mpls_features;
 	netif_set_gso_max_segs(bond_dev, gso_max_segs);
 	netif_set_gso_max_size(bond_dev, gso_max_size);
+	netif_set_tso_ipv6_max_size(bond_dev, tso_ipv6_max_size);
 
 	bond_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	if ((bond_dev->priv_flags & IFF_XMIT_DST_RELEASE_PERM) &&
-- 
2.35.1.616.g0bdcbb4464-goog

