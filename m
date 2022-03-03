Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89104CC4E0
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbiCCSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbiCCSRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:19 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E43C1A39C5
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:33 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o26so5239989pgb.8
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AzWpD7xNa7+zx0UcvxGkSN22TQN1GOmZtYxWLfXwVx4=;
        b=GjE8VK+esd2uJ5oJzRFNpWoBrtupkaOOIw/zK50PD8SC0g1OodXJMxAbEXO4usyZC6
         M1FOiu8rIEHp7nxbF6d4yzM1eD0JVHKUw8yu4uPq//A0J0V2SxQ3FiZUCf6enzVgEVqi
         EqqXl7IEJr2im81U2H64uFi4jZjqWpWCSFIyOkTzaHE84kg7XX/Y3J79FE9H7IKv1IEU
         fwEMWcKu71UlTLqQ2iXFYQLd+o7Lch14Exj7BuOBpQ8zBVPxxmFpVgDfTXn2BVYStmf0
         ikwDj/YzUMAEsVpwWBQY7CKagpLBcslwRl73ZP8D4YqIjK/7LBt03AcsfNIG0FJcNeH5
         SErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AzWpD7xNa7+zx0UcvxGkSN22TQN1GOmZtYxWLfXwVx4=;
        b=CputGwj8Y51feYHJDM00jrFLkfBHtnx9MHt+5ow2QTS85qGw0F7i8vG2pzw/8zVnav
         gODs3VlZXCzYSQSPFOpqylwujD8sjqWi9QYOKYZHhcYD3I53xVp+/kHjF8lDLqDYc1OF
         fiquIWD7Jl+NwffWzvXU9dzD1tiMEspVI02+4GBPWtwD9sPNkKj74stJrIq9+0PyHlFm
         6KNViZ2CmmilVwSjjvvKwVVxwms+ig7Y+Za003mUMSrSHzNBZP3MHYw+xnPdmE7ImJNN
         xMOc5G3bR4j/ukwQDV3QnBVvoK36NZ+bcg+sb5GrudgNguGOXvTdRtfZJIGPrZ/qaKgn
         Va3w==
X-Gm-Message-State: AOAM532Ra+GamaK6XsG9RLN55NZ9cO1hDzQTvUnz1qOc0y8Y9zNpmCsU
        sGPJMoBPRejjuDXS2qev8Nw=
X-Google-Smtp-Source: ABdhPJxrYXDWb2s+FQLH0UXJelbHpPcCPqp57Yjeajm5m9m/RevXZ7gRQ6Fitp3F6xSbj/UhG3EKUg==
X-Received: by 2002:a63:204d:0:b0:378:c9e5:bea6 with SMTP id r13-20020a63204d000000b00378c9e5bea6mr15316846pgm.573.1646331393105;
        Thu, 03 Mar 2022 10:16:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:32 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 04/14] ipv6: add struct hop_jumbo_hdr definition
Date:   Thu,  3 Mar 2022 10:15:57 -0800
Message-Id: <20220303181607.1094358-5-eric.dumazet@gmail.com>
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

Following patches will need to add and remove local IPv6 jumbogram
options to enable BIG TCP.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..95f405cde9e539d7909b6b89af2b956655f38b94 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -151,6 +151,17 @@ struct frag_hdr {
 	__be32	identification;
 };
 
+/*
+ * Jumbo payload option, as described in RFC 2676 2.
+ */
+struct hop_jumbo_hdr {
+	u8	nexthdr;
+	u8	hdrlen;
+	u8	tlv_type;	/* IPV6_TLV_JUMBO, 0xC2 */
+	u8	tlv_len;	/* 4 */
+	__be32	jumbo_payload_len;
+};
+
 #define	IP6_MF		0x0001
 #define	IP6_OFFSET	0xFFF8
 
-- 
2.35.1.616.g0bdcbb4464-goog

