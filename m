Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCD74CAE9E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbiCBT0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238002AbiCBT0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:26:13 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB4DC1175
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:25:29 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AA48E3F60F
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646249128;
        bh=KE7cA2DH2YKQP2Gc57E040M9nuLXTd4XcLilkBUwOrw=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=I41jrS7wEjcSy0G+jxzxKf/L+uALLOGTdGHRJzb5RCJJe5LwHrFcQ2M5PIVw2/UMT
         QN0WsJUKJ0yitn7w9xHDW2lNrasO9gSdNhfNK6RAabJcTB62x0Z2zYYbytpykONp/E
         eX74Plj5CFuJEC/vAcJUK08zX0CXGqnXrdZZcIIzGJjOquT0smIxEi1IsggbfL9uQZ
         l7zh3B3VyeO+5WOWzO9UjMpCDvpIyus/Y8MVF1nxWPEN1eWJD0Vm8Kgm/yXyYowsde
         BJP9P+5MQwjmcddNaGX5XbjoSOgwbvRpr67t8QKKqfYv3YG2zEyk4W5cWmlNpNlRDI
         m12S34JOgu6sA==
Received: by mail-ed1-f70.google.com with SMTP id cm27-20020a0564020c9b00b004137effc24bso1548143edb.10
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:25:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KE7cA2DH2YKQP2Gc57E040M9nuLXTd4XcLilkBUwOrw=;
        b=oXKs3eP863cBvH7pcqnc4MAH5uEccvley5fePnEu+qtiC5haSQXssG4BmYwAaJxYCP
         3feOpc+9q329gF42CLRknjqiEWhp9fvUwq1xtljUQb0oR4ODS2KNzPNGVaSaTXPLWu3Z
         7ttbpBeiIhu6tkdp1VD4RQxcAQLFuYHt9jnr9M8ESNGTD0yHE4yxvAhU0WMUXAD7Sb/G
         eKMtHbl49N2YydJXCdZ4wKsE7Mq07ESoP6c7pzSL4XFH7/d5xi2siDx4Y/dH7x55Xpnx
         of6d6MGmwxOT9axgaMDfL1tMeND4bCUZGLqldM01CH228Ko6YKv5DpJjxTwxKIvAFUrl
         QLrw==
X-Gm-Message-State: AOAM532qTcgpJ2Xz3pHM/Ru1W8QjzjFclF7pBl9ROsWUXHVAbemhYiS0
        LEqhPVhsFF3cypyPxzj/2ee5HluqT+PS0gMY/utLvgx20r33XvCHox/895exP3Ck8wusqXwiLh/
        ZuJm7OcRABiEEWBV/Qc01S2TjAQsdZMsUqA==
X-Received: by 2002:a05:6402:369c:b0:413:2bc0:3f00 with SMTP id ej28-20020a056402369c00b004132bc03f00mr30801303edb.126.1646249128345;
        Wed, 02 Mar 2022 11:25:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzj6ncNvbB8cHRaUtjFkSKVI4lc6ShTlpArR4gywnj3ywk9IVqiotnQYISrRs1enqnteey6vg==
X-Received: by 2002:a05:6402:369c:b0:413:2bc0:3f00 with SMTP id ej28-20020a056402369c00b004132bc03f00mr30801289edb.126.1646249128190;
        Wed, 02 Mar 2022 11:25:28 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id i14-20020a50cfce000000b00415b0730921sm1482765edk.42.2022.03.02.11.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:25:27 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2 1/6] nfc: llcp: nullify llcp_sock->dev on connect() error paths
Date:   Wed,  2 Mar 2022 20:25:18 +0100
Message-Id: <20220302192523.57444-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nullify the llcp_sock->dev on llcp_sock_connect() error paths,
symmetrically to the code llcp_sock_bind().  The non-NULL value of
llcp_sock->dev is used in a few places to check whether the socket is
still valid.

There was no particular issue observed with missing NULL assignment in
connect() error path, however a similar case - in the bind() error path
- was triggereable.  That one was fixed in commit 4ac06a1e013c ("nfc:
fix NULL ptr dereference in llcp_sock_getname() after failed connect"),
so the change here seems logical as well.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 0b93a17b9f11..e92440c0c4c7 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -764,6 +764,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->local = NULL;
 
 put_dev:
+	llcp_sock->dev = NULL;
 	nfc_put_device(dev);
 
 error:
-- 
2.32.0

