Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830D74A7D95
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348931AbiBCBwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348900AbiBCBwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:13 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54BCC06173D
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:13 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v15-20020a17090a4ecf00b001b82db48754so1402197pjl.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HzBw9wI4YOWb+xFcRynntKbTVdRkS0O/y9EKMzYz8AE=;
        b=ZkK2UIAswCt9BgvqHxc24iqHBPWD4CWvQ1gi/0PlijwpK/j+SWff7Bl+e1xY+LHAT0
         dhBYOxhVPl8VwbvH02kUHUggQP+6tRcegBCzID8zG4tnpRIW7kpkFxxEcD6YuUkEcLVI
         31GfN5pC5NHhx7qTCJXC8dEPRRWgFCCB5sJj37gpmJCAP7c4H87Hz2zbxw4Bk3vrLsir
         ceE8JAQScC60JPa6HAmuazIzVK2Q98FPuZwtLEnM7Wxb290l73GIU9Km9+nxlRpJYU70
         wunf4+2eUBmjDRQW0mmv+EPYDLqKy8crC3xb3DnlziNG1GL96Bdzxak8NxuIkGzpmfp9
         5yhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HzBw9wI4YOWb+xFcRynntKbTVdRkS0O/y9EKMzYz8AE=;
        b=Vvz2EjtUJFsq+1pNbhem1kWDpDJw4w30b/pdJNw6e7ShiuxzfMotjmFOp5QOvl5TZF
         YeAOUcuKoXKNk4dkRuf+GCnJLLtUvzJterRrspLU9ZUIsjyLKucjJUI95z025AJrhi23
         4h0RJ8RwNFIPpajL52BEy8R1aLwI3RY6/FwyChkVaDf+oxgGj9MIQpIneETQ2JZ4sqW9
         hqVLJyB1j80voqfGASCX2JFb36L2LCfHHZbUx+HdLJOSBC7yqPMREX2dchD1XRavLk0g
         RLXvzz+BETiIn6Eo1GkmEdrdEedgQtWJE625gxTibmZvYeGoI6cW6SIvI7SE98q+bGzy
         eAIA==
X-Gm-Message-State: AOAM532W7cq5jiipl32VlQO6NXZQ99t65dJ7DFAhnH5vWiuYQ9UJfGyi
        a55VakIPa/yBhp74BTjDoiI=
X-Google-Smtp-Source: ABdhPJz5UUCi0WiJaNFjnZj4ldgqZ/eo37jSX0mU34OjQf4K09ESUXtvCtJuZT6EY7od9Hbo+TWLPQ==
X-Received: by 2002:a17:902:bc83:: with SMTP id bb3mr34258798plb.172.1643853133382;
        Wed, 02 Feb 2022 17:52:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 11/15] bonding: update dev->tso_ipv6_max_size
Date:   Wed,  2 Feb 2022 17:51:36 -0800
Message-Id: <20220203015140.3022854-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 238b56d77c369d9595d55bc681c2191c49dd2905..053ade451ab1647dc099b7ce1cfd89c333c1b60f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1419,6 +1419,7 @@ static void bond_compute_features(struct bonding *bond)
 	struct slave *slave;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int gso_max_size = GSO_MAX_SIZE;
+	unsigned int tso_ipv6_max_size = ~0U;
 	u16 gso_max_segs = GSO_MAX_SEGS;
 
 	if (!bond_has_slaves(bond))
@@ -1449,6 +1450,7 @@ static void bond_compute_features(struct bonding *bond)
 			max_hard_header_len = slave->dev->hard_header_len;
 
 		gso_max_size = min(gso_max_size, slave->dev->gso_max_size);
+		tso_ipv6_max_size = min(tso_ipv6_max_size, slave->dev->tso_ipv6_max_size);
 		gso_max_segs = min(gso_max_segs, slave->dev->gso_max_segs);
 	}
 	bond_dev->hard_header_len = max_hard_header_len;
@@ -1464,6 +1466,7 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->mpls_features = mpls_features;
 	netif_set_gso_max_segs(bond_dev, gso_max_segs);
 	netif_set_gso_max_size(bond_dev, gso_max_size);
+	netif_set_tso_ipv6_max_size(bond_dev, tso_ipv6_max_size);
 
 	bond_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	if ((bond_dev->priv_flags & IFF_XMIT_DST_RELEASE_PERM) &&
-- 
2.35.0.rc2.247.g8bbb082509-goog

