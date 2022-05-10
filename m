Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638F4520C18
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiEJDgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiEJDg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:28 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98687179098
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 7so13577044pga.12
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kdkb9iJD2Cf92mUwdfbtRZPbJe3zJ/RvlmfMXNxr0ow=;
        b=SInbUuC2eH3c4oHZ+XyURjW5UU+icOUfDzy2Mmo9Zi8hDzF/os8M2VS+CcLnBNW1ws
         tYQualE4yWSyvyi98n3ds7krpR6QZA+f+HBV6Woe7vrpDsxa3bvIQye3LPkdbbYxqDvl
         lZOiRBWopgEJF8kUjmrXop9zXK4Igp/iMlB4IM8LNQ3G+G59FePXjJO+y9HvwdAp7IFH
         NVvE1oKmSEuakmhZzE8Oeel4lrfSuR48Bv/QQvCVZYAyx1Alk2DeASuNPcCJylvK5owp
         wMn7jt0EqBdSd7ORZ2hdPK3sybd1wwV4DeGg+UUJa4lXaBdjjY12/vdu+hjwaBn+O79H
         AuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kdkb9iJD2Cf92mUwdfbtRZPbJe3zJ/RvlmfMXNxr0ow=;
        b=m+0AYlQpXxufPF+7X0OYHWD/UCUrYBN0VqgJG6NSDH8Xjt9oM2mkBspAIgYed/yBBz
         cIo57PZddAGW7Mso+wHWFpiYgFvmAoE3Yru1/q+qKHtmS/Wnmcx29mZMu5e75/xVMkHU
         ZUHXc3DRkRKagJqSjQ9vibZZU2UWzB3mkOhx4+FqIyPUgkIznxYasXsqNF7tHL27XNOJ
         JCeBzCe4R8WdG0BjlORM44rHv40Kw7zmj7TGu6/cFvEOu5Sgss1ANMsrFLi5RaXXqLcz
         l/w9YqsnqrTzjYg18kxgaIcNcCEBu1nndcUhDBzuDTXETooYgTKzA9+TXlH525OTHe3T
         d1oQ==
X-Gm-Message-State: AOAM533f67ED/ZaC6iTzHX7QaLKnuYqQFP+NQqHjqiZmNKzTI9k8vX11
        5UvleKKNvYbAk3hayZUNleQ=
X-Google-Smtp-Source: ABdhPJzw0XhV/PfentsiA+2Juj5QCeek2peoP3WF/zODFpqwwgKUZdilE1VzE5hNe9RaHSLtUFQwpA==
X-Received: by 2002:a63:3:0:b0:3c3:79e4:156 with SMTP id 3-20020a630003000000b003c379e40156mr15117754pga.506.1652153551142;
        Mon, 09 May 2022 20:32:31 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:30 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 05/13] ipv6: add struct hop_jumbo_hdr definition
Date:   Mon,  9 May 2022 20:32:11 -0700
Message-Id: <20220510033219.2639364-6-eric.dumazet@gmail.com>
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

Following patches will need to add and remove local IPv6 jumbogram
options to enable BIG TCP.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..63d019953c47ea03d3b723a58c25e83c249489a9 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -151,6 +151,17 @@ struct frag_hdr {
 	__be32	identification;
 };
 
+/*
+ * Jumbo payload option, as described in RFC 2675 2.
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
2.36.0.512.ge40c2bad7a-goog

