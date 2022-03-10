Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363C24D40EB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbiCJFsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239660AbiCJFsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2262312E169
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:28 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p17so3923945plo.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aBQM8wNOxbvrRsNnfmdlVwJl6wi5pr+JOyZvAg1e78=;
        b=NKmd7RPcJOLxKP4oaFt1g8b9YAgP8ZNOfHhYNev+d7+7HGlTWgDnoDaWFVECdOoLU/
         z1CJCg4zo/TWDTBeu7ihQkto1semeJOh6kvbiC0x+rBzBcCzglsTdi8qROFbQNrUWLi1
         /7uff6FCCyyIjRtPl2iUV/LPITC86E0qEBQyys3Hj96XLA7Opn/IUW9Uj+KxCUolzayl
         6VMeVBU4JGzcXYTxMulfg9MmmMVr3pFbvZ0mgS9woSnQbFlosSz0U0CqGJtpcGc+oeN3
         gp4HdfKKJoFa8Jmrm11US6od/4rxyLTtvQIrpLz7BbSp4cXTxyZk9ZeVlKTIqSutYUlX
         0UnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aBQM8wNOxbvrRsNnfmdlVwJl6wi5pr+JOyZvAg1e78=;
        b=0cIGBZkCLTa+8NBiZ85+hkX0fsbVrOS2/j7dobuOjHOaAwCVThnWoG2M7bmh3o4Dk7
         Ty90O67aZopBqlRp5/uGXsOxddkccmjsk9B4COVtbatmvW3BWLEWuMvmDg6R1lRUq44K
         JawMRdkvWM9IEbnLTGkPADPDciAYd4Ru73yb9PAE/v5uUDT1DQaU8AxkdeE/ieZoKaQD
         ycujorsPPevR6INhhO8z5Gni2EBNg1zLedMy+IbU0fj9xplEpnAcNXPOXEMEGVbuC2TK
         03HbL5wj0q32BGi3/9x6llrUm4J9Uuh29H898FLHx+8bev8+dVoPZv3UAhkc1DcXe+I4
         dEWA==
X-Gm-Message-State: AOAM533qIbRq1zNUNLvA1w4hTc3Og/R8QsCDUZDqAhUCpoXnVUJFVy25
        fEwsVfjyJm4JZhf6PzOO8to=
X-Google-Smtp-Source: ABdhPJwwb5IrdvL1ddhIYEqhZdPq1csF+PgUXvixWiCDDx/N4oRwXxH0iuJdyTLUIq3ZVzccRvcRAg==
X-Received: by 2002:a17:902:e80d:b0:151:e043:a2c3 with SMTP id u13-20020a170902e80d00b00151e043a2c3mr3379261plg.64.1646891247961;
        Wed, 09 Mar 2022 21:47:27 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 10/14] bonding: update dev->tso_ipv6_max_size
Date:   Wed,  9 Mar 2022 21:46:59 -0800
Message-Id: <20220310054703.849899-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
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

