Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C1D48F6C8
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 13:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiAOM1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 07:27:11 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60834
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230512AbiAOM1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 07:27:03 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AFE203FFD9
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642249622;
        bh=k1fbxXsPvGzkuFTuMvPObzXkHdaiukX+p5UqHJ6OWe0=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=b4h6sU01ezgtViqkPX5VjAUI5cQBYk1VW8y5ymo//qJonPQhkGJXyW3jeBVC53Z7n
         pVO2nrrpttg62+0I+DXzKVxEQGMySjAGVaJNUYN9arOKtx2hXH2pLr2JHFOlFRoOD3
         5JL3ple6uYK5KDlAv+QOBCSJJ2Uea4LGQN2Or8b4kMthZzlpJ2cCRcOhn5zWTmy2Ci
         mrvAsIyCGDXvchcgTKA4EZbJ/Rao/70kMsczoVBcfs0lNiwOfyAIgdTxqks5H+e0UW
         VsfAW40/Cl9DXbU7DMuKi6lV/YpHioFtNfWSo8a6YV3147n+SZYZhZ4qCfQHaNLhjl
         oVp0gI82hYdDA==
Received: by mail-wm1-f72.google.com with SMTP id o185-20020a1ca5c2000000b003478a458f01so8105048wme.4
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 04:27:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1fbxXsPvGzkuFTuMvPObzXkHdaiukX+p5UqHJ6OWe0=;
        b=eU1W51E1dVKfRcaprI1OoT63lXqXZY7zD0tk6zK2a6URf+jdAt1iI3iaWkJFOzOsfy
         x29zPGFDNCr4cCDwPJt7yJiRS7xFtYDNDPl88dRRPtG9GEZrBZE0Eu2zkRCl6KBv29rz
         nLnjV5sALOmkPOKSJTRt8LVCnZaG103Ophc0XTX+F/9oOxORZ1SGeDdC1Mle6qwBocng
         +zSEQfN5jJTUGWfuMX3D711zPE8ukQFXfWvHT9DvmtLcyaUTCslk7dEJobb696AMVNxY
         yKOGGRcleCEGijNM7lAiRqyEWssV+l6pevj8HbWXnKHL4oYlZJjy3K0a0toyZYT155jv
         I1Mw==
X-Gm-Message-State: AOAM533Gu7wAdEpBGkJuMRclrJSvE6ngpnB14cUMvJsw74o7IGaG8F9L
        hErX13lgxTIPgUnC8vBYZR4F0cB/AQXQi4RWaLJwAQHajH7yQP+RkNt/KHQmlCX3R3F1TOKo1QP
        gh4pGbf/ks/eYyv6fbvWjSe0oUGhTN62DRA==
X-Received: by 2002:adf:f9cb:: with SMTP id w11mr12363535wrr.106.1642249622358;
        Sat, 15 Jan 2022 04:27:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXCX9qNHfjpMa31u9yvOahIXiFLP9Aqa1v2s/wcOF8lsTtZYY/Ms1xdIFV/FMREuwupnobnw==
X-Received: by 2002:adf:f9cb:: with SMTP id w11mr12363520wrr.106.1642249622169;
        Sat, 15 Jan 2022 04:27:02 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id bk17sm7878476wrb.105.2022.01.15.04.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 04:27:01 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] nfc: llcp: protect nfc_llcp_sock_unlink() calls
Date:   Sat, 15 Jan 2022 13:26:49 +0100
Message-Id: <20220115122650.128182-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfc_llcp_sock_link() is called in all paths (bind/connect) as a last
action, still protected with lock_sock().  When cleaning up in
llcp_sock_release(), call nfc_llcp_sock_unlink() in a mirrored way:
earlier and still under the lock_sock().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_sock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index c9d5c427f035..5c5705f5028b 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -631,6 +631,11 @@ static int llcp_sock_release(struct socket *sock)
 		}
 	}
 
+	if (sock->type == SOCK_RAW)
+		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else
+		nfc_llcp_sock_unlink(&local->sockets, sk);
+
 	if (llcp_sock->reserved_ssap < LLCP_SAP_MAX)
 		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
 
@@ -643,11 +648,6 @@ static int llcp_sock_release(struct socket *sock)
 	if (sk->sk_state == LLCP_DISCONNECTING)
 		return err;
 
-	if (sock->type == SOCK_RAW)
-		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
-	else
-		nfc_llcp_sock_unlink(&local->sockets, sk);
-
 out:
 	sock_orphan(sk);
 	sock_put(sk);
-- 
2.32.0

