Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFAC4955D8
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377790AbiATVML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377780AbiATVMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:06 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E93CC06161C
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:06 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id h23so6332349pgk.11
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s84gFD6K8nRbdQ0hYrguj6cIm1G19Cm9TiBvajI/L5k=;
        b=CRDWgt7Qv9rNcLZWDEqFPw+QeZRgFqMNw2ACHaQ0rzwFQFqQNsy8J8b3wplYGamfZ8
         12vN31S0TXmNzebjEe5lZCka/OmUFozcTeAWOvWJVBskGwSe+FJqZmeIwiFcuXKBFTSL
         tDwFPgoooZewYtLXw5jp/p9WWXYDHXs5Esbut/psrd9gl+aIFvGVMgJ7XcPkBhTODitd
         tsmUddZl5i6nPxnT3lNzgXvvULjHSr8G1e9vFI9A3yAkIhtCBkjjeF1EUirwcOy9hROt
         bm9chghgcYvclkuiQpZHK55rOFE4L1u+2UZNN8Z73eULE5zYv5LMZEWKvh0KUL11mkuH
         xHew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s84gFD6K8nRbdQ0hYrguj6cIm1G19Cm9TiBvajI/L5k=;
        b=2jGb5lLcqC+JALE+ALkPG2meZ8I9XeXjxK1+95cprMkK8aJx5QEe5EfIlSHp4X+sWp
         2rDxjVbBMuKdXFBbONCn46+U/QAfhwKneYGCT0OrUKBn05u877ya8ll2dD9UUu5H/tSS
         Tk6aR/eBAMqyf23jR7ev4sLvLe7V9akgz9rOJgc02wnQ7INk3RH6T4ZYEFH1golSeGwH
         Ecfr1InWed+/ISzJn7iJO12kR0l6wyr0yQKhiP8rTOl68HM1+MX7w43NAG7SxxLW8Dln
         28UFhZws3n3y9/QWCsPUQUqTU60hXXkFerJ2QQnDHj4Qo10VaXFPZeJ2Pp5MD+vF1ner
         V2Bw==
X-Gm-Message-State: AOAM531rPK5NNNRwiiC5O1TdpnWKS8eMjI7HN8JnUe3KNtVWbQXzIwmT
        tgl9s3vhz78NNxV00ccqQzh8/SoGcvhkcQ==
X-Google-Smtp-Source: ABdhPJzLrN4uFnf3DVg6t0NGBv76dY1VoDJ2TqXzWQjB7S0Cq8CGtRcIaVptGjjjNZxLyApop3mmew==
X-Received: by 2002:a63:9f1a:: with SMTP id g26mr503460pge.524.1642713125614;
        Thu, 20 Jan 2022 13:12:05 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:12:05 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 09/11] tunnel: fix clang warning
Date:   Thu, 20 Jan 2022 13:11:51 -0800
Message-Id: <20220120211153.189476-10-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fix clang warning about passing non-format string split the
print into two calls.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/tunnel.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/ip/tunnel.c b/ip/tunnel.c
index 88585cf3177b..f2632f43babf 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -298,14 +298,7 @@ void tnl_print_endpoint(const char *name, const struct rtattr *rta, int family)
 			value = "unknown";
 	}
 
-	if (is_json_context()) {
-		print_string(PRINT_JSON, name, NULL, value);
-	} else {
-		SPRINT_BUF(b1);
-
-		snprintf(b1, sizeof(b1), "%s %%s ", name);
-		print_string(PRINT_FP, NULL, b1, value);
-	}
+	print_string_name_value(name, value);
 }
 
 void tnl_print_gre_flags(__u8 proto,
-- 
2.30.2

