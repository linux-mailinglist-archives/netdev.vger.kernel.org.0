Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3470B4935DE
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352249AbiASHxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:53:16 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55312
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352215AbiASHxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 02:53:11 -0500
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DF7D13FFDD
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642578789;
        bh=RM6CEuGCpivOsBpPPs3hkt8u1ijpOzgu/V3oCSO4jiM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Ue7KA/6jXfRUvNGexglmYZadzYejZrCAR4nRVbSaeB7JnKnmmPYm8akSqqWUvGKuZ
         +rJaXZplTe4WJ6brWrO13VP8AcO0FY/INMphguv+biB24s+GLIT3Nw/wP+3QgEkc70
         JXp8VX5tVb99Is2pRZDDehTN3qG6UcVNW1JHzWhs0AcOIrh2h9KJGEbUzQ3WzLH6fy
         SFLXyJW1WDNPrSztFIjbYrZMqhFnpvBR14pY4fd3iRT98vHjrt1DoFwL878ToisLY0
         vRgJQXjMvJ3T2LkneMw12QYgQXDFIjlqwxNkly/yWpkCA8akQ8sgkjip3IG/Q3S6cA
         gWUOvMav4dvfA==
Received: by mail-ed1-f69.google.com with SMTP id el8-20020a056402360800b00403bbdcef64so1470263edb.14
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:53:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RM6CEuGCpivOsBpPPs3hkt8u1ijpOzgu/V3oCSO4jiM=;
        b=YrhllgJTt5L/XDZ6Udv9W+Q0D9iL0oOTkKDIIgqcIvTMUE8g5wNo8pf3AQCzTquvIH
         cGzcBNu/qqbpo/DSEBaYzOoJ9MVPYnSx48USQiNTsvqRENLRcqBAq760McMDR6VAVAm1
         Q9+mRgveX7PNiunfuiphdYpPROtPt2J4CDTecbmplNSvJJc8bDMXj5f4m7zw48G60U8q
         G/JuZkX/zdvC7eZFCSNsX+aIUGOEcsDDame3+dHhWkZFfCyaP4WmjgbVst6xq1yN4E/1
         Of2ENiE5ff1wpT2b9kfZ5nKCFxzcxdklPuelKtycQS5TX4u9W98IXB3MQyIB+aOthrA6
         P6jQ==
X-Gm-Message-State: AOAM533g2elSaSkQ6YbnErmwIpXnOKihvk8dnkjH4EcByIyDyA5gNfTt
        qmvK2HwSvxC/N2aUFLjscVlm9CIUrwX8TtChAltUw615IHXEM9vtQJd8hTtWFq5+FI9572J4pX4
        rmT0XtkD1nz+2S3vmVKZvSBFhtKqgUxWxXQ==
X-Received: by 2002:a17:907:e93:: with SMTP id ho19mr11025872ejc.168.1642578789629;
        Tue, 18 Jan 2022 23:53:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJEcV3S0JFKK4d5B6hmyTEOPZMdJTa8RrL6S17NZ6W29g8Vt3dq4Dv7WMzhmOsFjUA/eVO+g==
X-Received: by 2002:a17:907:e93:: with SMTP id ho19mr11025863ejc.168.1642578789450;
        Tue, 18 Jan 2022 23:53:09 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id w17sm805286edr.68.2022.01.18.23.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:53:08 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] nfc: llcp: protect nfc_llcp_sock_unlink() calls
Date:   Wed, 19 Jan 2022 08:53:00 +0100
Message-Id: <20220119075301.7346-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
References: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
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
index 60985d1834a5..2d4cdce88a54 100644
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

