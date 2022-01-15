Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2848F6C1
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 13:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiAOM1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 07:27:05 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60814
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230448AbiAOM1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 07:27:02 -0500
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CD03F3F1E8
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642249618;
        bh=ePWS8huBNB8mOLwzP5l9zhhnqwr/R2aV/N6dfRb+pkA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=vnd9YjeTAkXxpN3SWdBQaa337/49tJieZIqgKEBiUQHWsuzpNxPY34sQ/iKaPtIuy
         kftQO22UqiTrGMG/MxJhOPjcVk7bvbyyiyfnHPadRsVUnmVuVyzekYEg6y0pSpNseh
         UjijZ9YXB3JbAhYa1ceOkL/G50f/h+jenmGykR92DiqW09cjMLhSDFVujHC3cD4/t+
         upyEjk3kN5x12CDupekVUT5Iyc5RByF5b2rOo9AC2sUWd2t2Dty9qc1oHxsm3mp+RE
         20e5f0hNC88RcwqBVUJMuuIt1OEzULtpV4MaY2hfytZ1WWHFVvmX7TTDyzLTwJgS1O
         wpHmt3U1o0LUg==
Received: by mail-wm1-f71.google.com with SMTP id m9-20020a05600c4f4900b0034644da3525so7326026wmq.3
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 04:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ePWS8huBNB8mOLwzP5l9zhhnqwr/R2aV/N6dfRb+pkA=;
        b=rIJG1VsSIN8aMZB7ooMGI2YltfGYYfaPlMPGCYxSLzD+IEGtjE2kAupKfO7GYM7U+n
         gOeobtYh55j8+deQCV8LeJxt7oQWi8IgFmHd94sFQS+BehIK5txAK3rReFxq4vgiF0ow
         dm4Sw5bDhS7MFcnTHev9cucoKAjC/LfWEdzp2ilgVpcDXss8kHMxmrS6FZu+/W0QvC4Z
         9ytCeeS3CPotYHeBq03IfRwh/ME7kgVkJP2fj8/nFybdcYtSy3dGWOOHj2vfCWYT/u4B
         9k/cYA298M8LTrn+xm0x2T0SdIYKB/vboGmitQf4ofgkk+vkYoqzZYKq7XFXfsqoONzt
         v2GQ==
X-Gm-Message-State: AOAM530jjuAQkQ4S+pharybp/OGS7dDdT2DOl81zTOBfTxXmb5cqZOKy
        GELQDy/+MWPZd2KcnB3bf+PlOiKsoWGbAtqQ5wjpONrfk17nfrdEVRFhcEbAPasXcZf+4b34ZZU
        MrzoB9CWRg3vfLOQvSu2QDXTQiFkhKAzooQ==
X-Received: by 2002:a5d:6f0a:: with SMTP id ay10mr12121173wrb.191.1642249618562;
        Sat, 15 Jan 2022 04:26:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbQP4Q1giAJ4uAlzrN0vo+MIFiQCq0DOWWfo4iYlUpIw0pSA9ah1HXa5NlBGI3l4j4jOixug==
X-Received: by 2002:a5d:6f0a:: with SMTP id ay10mr12121168wrb.191.1642249618445;
        Sat, 15 Jan 2022 04:26:58 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id bk17sm7878476wrb.105.2022.01.15.04.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 04:26:57 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] nfc: llcp: simplify llcp_sock_connect() error paths
Date:   Sat, 15 Jan 2022 13:26:46 +0100
Message-Id: <20220115122650.128182-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The llcp_sock_connect() error paths were using a mixed way of central
exit (goto) and cleanup

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_sock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index e92440c0c4c7..fdf0856182c6 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -712,10 +712,8 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->local = nfc_llcp_local_get(local);
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
-		nfc_llcp_local_put(llcp_sock->local);
-		llcp_sock->local = NULL;
 		ret = -ENOMEM;
-		goto put_dev;
+		goto sock_llcp_put_local;
 	}
 
 	llcp_sock->reserved_ssap = llcp_sock->ssap;
@@ -760,11 +758,13 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
+
+sock_llcp_put_local:
 	nfc_llcp_local_put(llcp_sock->local);
 	llcp_sock->local = NULL;
+	llcp_sock->dev = NULL;
 
 put_dev:
-	llcp_sock->dev = NULL;
 	nfc_put_device(dev);
 
 error:
-- 
2.32.0

