Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898BF4935D4
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352197AbiASHxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:53:10 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:38494
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352190AbiASHxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 02:53:08 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 959993F1E9
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642578787;
        bh=hsf4OWBu8gj1asXGvoAW6jPDrjEeTDLfH6tpVV1berI=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=VZjG057EcIilUeAT/ICp+xIDLWs40XjCvGvkbY3rGpVuIXD6N2lWRsOeQES+uaQH3
         d35RFradZII3dl2jjqwd983JBN6V0iFi/6E+mxtOjLBOUmK5lNfGxSKrstP/3nAn6W
         YbY/bACj/l9mEhApOsxBsf0pva+LHvMtTfVkHYkh03hQvvuB+qJLQfPBOeCByN4fzu
         l4bJdiM98velGcUJxf4cwKSAWQJLCo4rDRBGglJPJZVNuFLJ7bTE1CPW3APAOVCrxJ
         xMGiREZDknqgPIvkOoL0hdGOyLzifOomlLDmFiVaqAS4yiKnxTWcV1ESiYDHVxugTB
         GNEO1pJ32+DSw==
Received: by mail-ed1-f72.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso1452704edt.20
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:53:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hsf4OWBu8gj1asXGvoAW6jPDrjEeTDLfH6tpVV1berI=;
        b=5sDF0enLNCawm68W7DQO6AYPlPrZ8MVZk6extj1cGaz2z9Nwk6jGRzYL4BUudsWfDk
         /rNZ611yE9GH55A7JUuFDpRZd3YhcMrEiiNENHNho0aRbxd4ZB95EZNvg2QUbD5WCeJ9
         CSADC/MTgfJz+37RHeIf8QkwNakGfKDAmOqKX23bxw6lp/mVbT7AGtXrV4lbjvMNfDJd
         INYJVWYr/+H/eZBHLzI8PE+Pn11DvXi6gKC0TC5NvaNvLpjJlatX2bksA4KQSVprlGEb
         0Emmc8l7z9pKCSzX0s+6AzA8wN5IufSsPrmHCf8Z+sD0Vi+qLncX5uXmmMtQjVpVKSBL
         J9OQ==
X-Gm-Message-State: AOAM533qrqnUVQUIEDErc2SbmRbMnnOeOAukWQ4D83Ef2abcfzKHArCJ
        yBkTmjcHT+f5LVq7RtDnDIQhzft4jUf/VtY3UErVZXVK/JiIG7YJ9UZ8du4FWWe5QwexuuB17Zo
        V1e/pADhhi52+gFg/7m8WS2RgBGyS4qwl4A==
X-Received: by 2002:a05:6402:11c9:: with SMTP id j9mr28608486edw.385.1642578786590;
        Tue, 18 Jan 2022 23:53:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyns4WRsOdrGoSiLkUgMsRyEIUWZN7UKVXPDT+SQgr4x790RZ4Ep5Cqmw1oA9YvBvJZNQYpwg==
X-Received: by 2002:a05:6402:11c9:: with SMTP id j9mr28608483edw.385.1642578786471;
        Tue, 18 Jan 2022 23:53:06 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id w17sm805286edr.68.2022.01.18.23.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:53:06 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] nfc: llcp: simplify llcp_sock_connect() error paths
Date:   Wed, 19 Jan 2022 08:52:57 +0100
Message-Id: <20220119075301.7346-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
References: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
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
index d951d4f0c87f..a1b245b399f8 100644
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

