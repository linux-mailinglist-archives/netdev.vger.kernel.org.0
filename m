Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FD1520C1D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiEJDhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbiEJDgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBBC1D8135
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 15so13599839pgf.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3Dsd59N+6kEn6Kc3V/BT0dF8qv2VGnxNUcT+/bT0K8=;
        b=kMynRZAD2EvxShtQgIj8268ZxGho5VHPfxorHYZXWxrqgUXnkloGmfm646OTk/7xfK
         Vo9iIY3Ki0NqSEtiVIzoTgQ+ICI9g4kM1GHT+AkTnoDntEUA1hvaRzsuWy1Uvt6CHPMo
         3uesQsSotqCiF0PwzNYcaHICdJefqCak2s2C0Uc1xxq+OYQ6z0hxHgLslQUPuAIjuRg3
         WJZWVjyB6YcSCG5WgUVwd5GjQaRsAOkglTb9naMS4Vo3b8WficrWSO/xmuuMqBPH8U7i
         i/8XVKkeV8anPN7wP8xTr8nKRVbdmNQ2ThNtnQ0U4rVB3uNqwKHwGt2yuW7K7WF3vr8D
         FYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3Dsd59N+6kEn6Kc3V/BT0dF8qv2VGnxNUcT+/bT0K8=;
        b=h5hCVyzPAW5h8akOdykYNcDsuC7r7zQRBxYqD712B8MXTVweE/A7QcaPzAk38yre3J
         a8HoG7TO4GJXqajKiJSeUlVyOgKOpfcFwqb6YgK/dna2qfi62F/uTnfH6HURxQxKDPWN
         3NEQgMkQI7zU6LljFaywiMTSNwDwXlb/SBcpwkZf7UtRVBc5WGPEKZ+tdrvXF89SLGtL
         pXpHG/+Oe6V78Hm5wu6L5lbVtTDJwowjeU1XI01wDYHknmISOcPseZ0+FHo4JOnQTEo1
         JGA1QQWj/iLYJZOvnFBdukICk5wn6ZRbOIGZWlqxYrITXJgRGz/gjHQkzW909j3mE8i4
         y72g==
X-Gm-Message-State: AOAM532HP8mka/sdtoW2ot9CL+fCsu0pYmv7CXLGpkGvzn8vQN1Bmcx8
        ylnu90QG3ZZ0tWwNvdhzBQE=
X-Google-Smtp-Source: ABdhPJw/lmwGPVjWJxaHjYV8UhO15VySBeirZDyWnl5Mg3HmK6CC0K2XEHZg96Fx7gajr4YNbyFJew==
X-Received: by 2002:a63:2f47:0:b0:3c6:a5fc:8f8d with SMTP id v68-20020a632f47000000b003c6a5fc8f8dmr8179825pgv.327.1652153560149;
        Mon, 09 May 2022 20:32:40 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:39 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 11/13] veth: enable BIG TCP packets
Date:   Mon,  9 May 2022 20:32:17 -0700
Message-Id: <20220510033219.2639364-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
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

Set the TSO driver limit to GSO_MAX_SIZE (512 KB).

This allows the admin/user to set a GSO limit up to this value.

ip link set dev veth10 gso_max_size 200000

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/veth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f474e79a774580e4cb67da44b5f0c796c3ce8abb..466da01ba2e3e97ba9eb16586b6d5d9f092b3d76 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1647,6 +1647,7 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_features = VETH_FEATURES;
 	dev->hw_enc_features = VETH_FEATURES;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
 /*
-- 
2.36.0.512.ge40c2bad7a-goog

