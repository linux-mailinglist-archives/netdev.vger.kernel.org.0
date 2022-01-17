Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FFE490FEC
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241801AbiAQRug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241755AbiAQRub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:31 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27174C06161C
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:31 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t32so11529653pgm.7
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s84gFD6K8nRbdQ0hYrguj6cIm1G19Cm9TiBvajI/L5k=;
        b=vmNaGihsPygJDRrlTf5JqQ3BYMQfcGgdU9J27WmCEkmFi1kQ9JyNZY87qz8qZG5SJt
         7mqXxLTNSdDyw4OHx5IW968rbKJPEI1oAPdiHYQGV7YU3jC3GUO88OT8LhxjHcfw7aLk
         EtQQ9IvJUu+hE80FCBGtJB2+JyEek+M6ngybJ2yjljvA9Cko8hCP1kRUcNiz8CVGDx8X
         4ZwGcVlLqdSit5tA0aKRHkOGpULdQOBGkapc86nQ4BESPYOQag79Kzh+sXFgaKg6RDty
         zF1VuEAqBPGoQP+E8Bt4uw/PrCi4h8BfYe6eXWxv8ThC4ZSw0V3KXshPQjYMC3UwqRpH
         ic/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s84gFD6K8nRbdQ0hYrguj6cIm1G19Cm9TiBvajI/L5k=;
        b=qi7e+0YjWbYdP3ooYLfQt1HC3VgGOR9nd28nWudO/T6hUY1ylJf4Gwu2IMmfDe/ZtF
         tiFHXeeAMxoFFNNqtFNzLCHrhxFGru64VuxmqRbipfcEXjNi3BOyTnDDPIYn5qQb5bPF
         LuheWBrs9YAUUMXV78/dYOODZOqRLy8g7qsjSmpFQycvgDOcWcf20rFASc5xTJ+Yzpju
         R4oGwChf9vSNTA0NjjdqnX7n6IaDK17yL34zgrKvqkIW5j9O0GZIX2ue83et37AGPSaV
         w0lNInfNY4HBC0mGRSAH9qu+b5eo5hHlc/QEWXmTDMrt1QiQ4eKtBT4CTcbDmE3yUuhO
         2iQA==
X-Gm-Message-State: AOAM533HyZzJogbaJEpzrWiqBi3GLl2CoSa8JTaP7vsydXzeEkWzzmux
        5SutC6mDjUsyCKdGCptEtFxEhYk2Vzs6IA==
X-Google-Smtp-Source: ABdhPJxfNNlu2fnYPY2XOvRnEkrCNrep/OStYyLVRQwEPatWN3YA3y3WaoAHNCBoAevZE1YuxrPhXw==
X-Received: by 2002:a63:7546:: with SMTP id f6mr20055977pgn.480.1642441830362;
        Mon, 17 Jan 2022 09:50:30 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:29 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 09/11] tunnel: fix clang warning
Date:   Mon, 17 Jan 2022 09:50:17 -0800
Message-Id: <20220117175019.13993-10-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
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

