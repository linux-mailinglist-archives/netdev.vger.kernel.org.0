Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8874CC4EC
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbiCCSRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbiCCSRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:36 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C41A39DA
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so5644664pjl.4
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jPmr3gnK1AlLQRyI/oWCnKd6ewHGXGMist7/1+3ySOk=;
        b=NsfITdRLM4D6e5az1M1E0ToHuep7BoevrlZYglz1rhz68mzk6Y7Pw5Y0MpjmyehSC5
         xCAly3sM/gKLZCP51sMKlByScJoMtZZpkHWX5bCpI+lbRfIWfWCP7E2S71OijDAUBnVx
         UHwfWrfRJqTV0cnvWd0TH62vg9yJ/cApHwmkqp/i9DhXLGhPddWq4G7PKYeA9k1rUg5d
         4rpGSb8YWAXiqkYCLzRrc7ByYosyDXcw2J2096I28LEs/ZSOlYLDnjTzHbHkA/FgRx64
         +Xuq+BI88mXyjVkJdDBsfO4WuwoYRDocJromktsZa4ZxdFvLy0o1gmB53vNX2sutFNlq
         N+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jPmr3gnK1AlLQRyI/oWCnKd6ewHGXGMist7/1+3ySOk=;
        b=hXlbprV3SQYnCFF++kDq9W7vELUx4qEyWNAZiNt1Oh3N4SNqQ0cubYD2X7Gge/wF9F
         Gg/AneoO7PnZU4wqQ1wXaiPgox8Q4Pz9QuAUfxq0cUXyK2BrBN0DKIIMyDgduE3AdmVM
         PRP+K3vb2ovH7XruHkX3wrImykd9gfxnCV8TDQMnLIVeOy2F9jzKzUOQ4QcXF2U2XdxT
         Ngh8hXFEtwHtVmVSZUn/4K9DP8TJpMzLiU/xlALqCN6mtP3LK1peP0mOdHmO9vVz0hWe
         /Bsej2AFZF5dh5yyolX3Rfgcn/RpZ3lwVBhCI33qxvBi7py4guvLtlboH5GtxB8NDoY/
         8IMw==
X-Gm-Message-State: AOAM530rpKna5Gq5czp7HJN62+o3ux0kn1SFu/FEez8v8TsM7kg2sCVc
        HgdB1BAvkofa+cHM5ehudUw=
X-Google-Smtp-Source: ABdhPJzmgqfy8W/uR+sRU70gHdKOjxZDC7Lo8SIo78tp5BYRErc5zS6OSRaQpk67KkQB/PvEo3Rucg==
X-Received: by 2002:a17:90b:228a:b0:1bc:7ca4:efaf with SMTP id kx10-20020a17090b228a00b001bc7ca4efafmr6668205pjb.245.1646331410263;
        Thu, 03 Mar 2022 10:16:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 11/14] macvlan: enable BIG TCP Packets
Date:   Thu,  3 Mar 2022 10:16:04 -0800
Message-Id: <20220303181607.1094358-12-eric.dumazet@gmail.com>
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

Inherit tso_ipv6_max_size from lower device.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d87c06c317ede4d757b10722a258668d24a25f1d..d921cd84b23818c3d4ea88134c77a2365e6d9caa 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -902,6 +902,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->hw_enc_features    |= dev->features;
 	netif_set_gso_max_size(dev, lowerdev->gso_max_size);
 	netif_set_gso_max_segs(dev, lowerdev->gso_max_segs);
+	netif_set_tso_ipv6_max_size(dev, lowerdev->tso_ipv6_max_size);
 	dev->hard_header_len	= lowerdev->hard_header_len;
 	macvlan_set_lockdep_class(dev);
 
-- 
2.35.1.616.g0bdcbb4464-goog

