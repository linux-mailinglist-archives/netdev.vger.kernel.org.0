Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A58548F6D4
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 13:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiAOM23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 07:28:29 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:47530
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231182AbiAOM1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 07:27:04 -0500
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9482A402B3
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642249620;
        bh=XW443xLXNMd7fKnAwsj5MsweNUN/P9g1RwySZfWsL7A=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kAyFx/JNGNxvnqNVk79wHaTbGDFtnx4sATPuW9MUSya73fwOhaTTQX6fMDvfiyixf
         3Lh5AjlQXxmiwgAVGb4XaFUPtfywNOsGtQ/7fjQp7gGM+Vjw2JUmmCGevwxHM/cP4w
         EFJgnrFxn9CxXugv9iJt4ayv3z67Qo6gJ4GwNH/3d5AzTnOarPeP08r+VUO+s4uWcY
         KY8Yvxcg4QSymHZu0M2vDTNmUfDa+orosq696XND6t4HumAq83hgUPcMryUne1h02o
         g4Jdg5GDk5UGwE7inGND/sTKRImBpAip73040+BWCTbrDIBb9ndoNqqsdsvi57Pep9
         6cO/+YlHWzLig==
Received: by mail-wm1-f70.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so509252wmb.7
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 04:27:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XW443xLXNMd7fKnAwsj5MsweNUN/P9g1RwySZfWsL7A=;
        b=MgB0VMOD8JLKaNmFsmoQ+CjDSX2QDZsl38+bLI87OiNAhNvkOpMzPj8nHSIihn/SeZ
         2x8ZgoKbSsWCM8dR5DW7G+k70mKO+VAKq39D8IrU7MSDQyIrUGE5uSERn8JbyeBt+AgU
         BrVvueh52ZBBmFPGKQJxxma6ZMZMrHx9iT4PgLS3vWpvAdu4ZvfDjg6xff5Rcqa4cIsi
         AASXrtdgDv3SpcvQhJJdd6ykKaTQ5oTwpyrvXRagm/98Ba086XokyYszzUZ/qJ+fI08r
         3eg64oUnpkKqkrL1YBT4gD1/d4NnTQ+iGeVKhLYHuJn/ikc63f11XFlMznI3/JL+JM3C
         PBCw==
X-Gm-Message-State: AOAM531qyXKNBGm9B6UYw0iLoO4cKQSgpy07O6VNQQN30uP1E+O6YLXo
        b+5DD7Lqv//rEcPJjbJLfi2QeHnWZUnAJH3gnrXA+vdJB0U29LSswGFnSWTViHyXe9aPNjvj6p+
        GX0oxKILNt8yi01h2u7aUc+YtVSeEMJMVKw==
X-Received: by 2002:adf:e810:: with SMTP id o16mr918249wrm.148.1642249619802;
        Sat, 15 Jan 2022 04:26:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmyGxwz6Gt13RegtMp19MSWLXNTMDHakRk1jf3lOXKJSBHxsTjjfU5CLCgc4+yB+jzAl2W2w==
X-Received: by 2002:adf:e810:: with SMTP id o16mr918237wrm.148.1642249619675;
        Sat, 15 Jan 2022 04:26:59 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id bk17sm7878476wrb.105.2022.01.15.04.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 04:26:58 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] nfc: llcp: use centralized exiting of bind on errors
Date:   Sat, 15 Jan 2022 13:26:47 +0100
Message-Id: <20220115122650.128182-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coding style encourages centralized exiting of functions, so rewrite
llcp_sock_bind() error paths to use such pattern.  This reduces the
duplicated cleanup code, make success path visually shorter and also
cleans up the errors in proper order (in reversed way from
initialization).

No functional impact expected.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_sock.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index fdf0856182c6..c9d5c427f035 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -108,21 +108,13 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
 	if (!llcp_sock->service_name) {
-		nfc_llcp_local_put(llcp_sock->local);
-		llcp_sock->local = NULL;
-		llcp_sock->dev = NULL;
 		ret = -ENOMEM;
-		goto put_dev;
+		goto sock_llcp_put_local;
 	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
-		nfc_llcp_local_put(llcp_sock->local);
-		llcp_sock->local = NULL;
-		kfree(llcp_sock->service_name);
-		llcp_sock->service_name = NULL;
-		llcp_sock->dev = NULL;
 		ret = -EADDRINUSE;
-		goto put_dev;
+		goto free_service_name;
 	}
 
 	llcp_sock->reserved_ssap = llcp_sock->ssap;
@@ -132,6 +124,19 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	pr_debug("Socket bound to SAP %d\n", llcp_sock->ssap);
 
 	sk->sk_state = LLCP_BOUND;
+	nfc_put_device(dev);
+	release_sock(sk);
+
+	return 0;
+
+free_service_name:
+	kfree(llcp_sock->service_name);
+	llcp_sock->service_name = NULL;
+
+sock_llcp_put_local:
+	nfc_llcp_local_put(llcp_sock->local);
+	llcp_sock->local = NULL;
+	llcp_sock->dev = NULL;
 
 put_dev:
 	nfc_put_device(dev);
-- 
2.32.0

