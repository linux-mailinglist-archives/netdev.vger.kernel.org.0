Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A34D40E6
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbiCJFsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbiCJFsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:41 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F99912E160
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:30 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so1071254pjb.3
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gtAHZRigkzO4a1Jgu5OwYx4SbI+nNslUCVxlgRRzKWg=;
        b=HlSyzdDLZIO8ckhDwEJvl1HNqb2NPFL+6Dv7TwtDxt8sPTVOvUGuSZTk11CbbmHFXh
         mpNUKHAQBPR9Y+S8TAzarcRibOV3NJrTmc4M3g9uUL7hDECyJSdkcKl395tsLenlj6xS
         u9i/tKxpjGJTQR1sWQiOpeL6xR/ewMO/hqv1iFSwaE0wzm1ZusRiTQRaapa/CIYoZENt
         vDiDe7bCwrgH3SVMFqPYkVJEAmY5tXUcKnpVv4iamVxioChL842eH+eCF97XhjrY9xiR
         9HVSCrQuEY0i9JZtnIJ1hESVKUj+lm59aQlbcHaKlUYzxGqs7RrddL5wbyWjvpaWEe0X
         fz9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gtAHZRigkzO4a1Jgu5OwYx4SbI+nNslUCVxlgRRzKWg=;
        b=P4sK7rgPcSdWwcbyPgX261wvk5hxJBqpHhqne23rW94l+EfzjTITczQ4nFzfjYk1cW
         mZgCbpljnkNFNuqfYFG/yM9ijK1sQxiPzHl2z7wYr68Ef2q7K1kjJImdpZbRHz8AIBqg
         23Ne4ix3ocgi0pUo4qGVMvTqsiNIQEtU3JSptF1RD60o7zlOwZ8RTi9mf4rHRhgjUrrj
         PKrI73GqnNNq3tDn9B7Uo6jDsiMGhzhQ3lrfj2v1RWhZVAtP6A3rNXMzij/ZDCjpBdpd
         ilY10MYhcDDtVSWW4FsiAnXRsRAWwpUoaKZl8ZZdgLT+IinILuxuXGc0rcA5cRZidG3z
         dQqg==
X-Gm-Message-State: AOAM5310GWrT2ODmuxWfdSMROZbtE+bOL81DxoTgVwRBviRTmXgxv5Ym
        LUq2OdtknUV59fBSFo3G9n8=
X-Google-Smtp-Source: ABdhPJw+y1YOSdrOqLUyZmcQ5CdKNvJXYnhKlWT+pUeE8GuBeCxzgi/qNbSI3RnMXooOwdFiZLww3Q==
X-Received: by 2002:a17:902:d643:b0:151:6f2c:cfb4 with SMTP id y3-20020a170902d64300b001516f2ccfb4mr3287650plh.120.1646891249818;
        Wed, 09 Mar 2022 21:47:29 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:29 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 11/14] macvlan: enable BIG TCP Packets
Date:   Wed,  9 Mar 2022 21:47:00 -0800
Message-Id: <20220310054703.849899-12-eric.dumazet@gmail.com>
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

Inherit tso_ipv6_max_size from lower device.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 33753a2fde292f8f415eefe957d09be5db1c4d55..0a41228d4efabb6bcd36bc954cecb9fe3626b63a 100644
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

