Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E274CAEAD
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241187AbiCBT0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240398AbiCBT0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:26:32 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF9AC1C8A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:25:37 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CEF743F5FB
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 19:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646249135;
        bh=k1fbxXsPvGzkuFTuMvPObzXkHdaiukX+p5UqHJ6OWe0=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PLYvzh17ADSUr1aiV9fmKtJnTScgSkeChmd0EwyYWDVsVOGK2x0qjqwdUFpCWG4bY
         nBwqr5G5JKiuSbIA+QesQqMuqXo2ShkdUUs7tbiX99nLDu2s6rFw5hxlExAkrThCLT
         g/quANbgfIVDbPsv2hY80x9kTyW0M/NgrsLTIOrmjghlfUShfYOWOxg1mx8arotdi7
         PMmkiu4vlxPqd7Os5QHKlmRh+TFepSNxWO6guRJO4RHhA+7RGjWE7lIxiIYizvW10G
         VHZdxalRMno3kWtqbp/ldpy18pbnx2QQA72Qhyi0hoUkXfXGE8Iw+SO20AU/ZsbP/6
         dSBZthGbUXIeQ==
Received: by mail-ej1-f72.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso1489730ejs.12
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:25:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1fbxXsPvGzkuFTuMvPObzXkHdaiukX+p5UqHJ6OWe0=;
        b=J82XGEqkSk8sz8PhQzIuLTGyQb4mN1vguU9yhae1HG2EbGQjR2Pzpy9e8QYAws3vmV
         X1O2mEsnxPV5AvlZJ6zv1jvhOF6Vsrw8wf+4khK8W/1pLX02oLBt6Gki8qbbp50WtOge
         IB4cvnqT5q2AD1rqa5fF2eRKpOnBxmDAYaC2nigY1pUG65Inwt7sM1oz67ONAdmUC9U3
         /Sv2d55Bmkl7k+mupiURxZ5SR8Ip3IHZoU5ixaac1tWnrs+7J5WYiPdeasGUa89ylyxX
         2egpmqIS428GK+7JhLVCLjfCK1hlSzXm3XB3lOP+eo+/N1Ubrms3vOOwPL2eCkx7HQ8V
         JMiQ==
X-Gm-Message-State: AOAM531H9CdnCX1ZIDjgfQF5LSN/ZVl3CRb69QDpjf8nb2S9KkEzkRFp
        C4LGwwgb0+CmMNMb9TLMLRbPPaTmd+KpE6uOzNs1iNm/OgipBZVMbUM/MJY9ZFprlJGdmv9abDj
        YOxk3T8ZwTTjTb45sNuBHSiqbv0k3fhUI9w==
X-Received: by 2002:a17:906:18b2:b0:6d0:ee54:1add with SMTP id c18-20020a17090618b200b006d0ee541addmr24364521ejf.499.1646249134540;
        Wed, 02 Mar 2022 11:25:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQ2Yzk4nLxgx+97QWgQ7U+3qiE+VAfZ5ZxF3hEUaZA9fAEq5MaAHHtVajBlFnerH2vg2MVHw==
X-Received: by 2002:a17:906:18b2:b0:6d0:ee54:1add with SMTP id c18-20020a17090618b200b006d0ee541addmr24364498ejf.499.1646249134294;
        Wed, 02 Mar 2022 11:25:34 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id i14-20020a50cfce000000b00415b0730921sm1482765edk.42.2022.03.02.11.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:25:33 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2 5/6] nfc: llcp: protect nfc_llcp_sock_unlink() calls
Date:   Wed,  2 Mar 2022 20:25:22 +0100
Message-Id: <20220302192523.57444-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

