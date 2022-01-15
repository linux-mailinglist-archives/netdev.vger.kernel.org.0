Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD6248F6C0
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 13:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiAOM1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 07:27:05 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60826
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229452AbiAOM1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 07:27:03 -0500
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 27F583F1E5
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642249622;
        bh=yrlNFOS5f9IRjvA5fm0IVEgclHgNp68QGUe5Q3pp8Vc=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=HmgUJJgucw4IqWlwOu8h94ZI16bOPZ28Mgi1y+Tsj5jjeyEYwQkz8Ki8Q5zbmkVcm
         4Ei1Xx647ng7xyj9RBOnS7pgwJYjgNA8GU+o+0Kv5+iDtxQCBzI5tJ1T+eZ3y7L3hG
         jg9oxDAO7ROflhpD/sozM2kjuq2rAsHBxxJ2Le0KAjX396u7JjxfOaD2KLghGCBRvv
         AUDjpaNKUng4m7lAUyz9Urqr3YsMDa/JY03BVSPjolsOwGj8V2O+jxuQ8or3O8Pcy/
         Eglqm7HbdUMBgy4kQZqrSNCRyuBHwtAG1xfwL+kn6/ouRsWVMH3SfoSihiUv2zbbgJ
         8rtxWJieGCJug==
Received: by mail-wm1-f71.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso7203696wmq.6
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 04:27:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yrlNFOS5f9IRjvA5fm0IVEgclHgNp68QGUe5Q3pp8Vc=;
        b=Jmw+O9NHV3K+2XxDAaElBXUC4vxb5q6RiFrkY+CeaCCTUo+NBlyOPb0jp+hhwr2fwW
         wQT3yT9pMqbyBds1G051jkTiKyj0vZ0rOXj/K9VPNtWWEZpMexYEYNj+AXbqiv/PpE2u
         GyY/Q9o4tXtVCyeiyz29tI+YiRA1Y/UGSdCrBGv9xkkIZ9sgo/XhFdW3VdeyqolIhTr2
         wzmEYD9ghGLn4bcro+K7D08GxhpF5w06GTyEDn/8nNJdeqZCb71STkGgDGJkmbpGhOMJ
         EK/ro6lu9/NKevoSvGo22dc0n3SbLwJOuMcNh3UQXyhdUhS9PghfJrvTD4u4RIPLHaq8
         vfrQ==
X-Gm-Message-State: AOAM53391uFeak9TXuHW9kCeM5MwSmayx0mrM7DXMOE8ZoCHDiA3YiPb
        IRvgXC/9NQdjaCdsZ2XeDpq2GZFOMsCXY0nWuG4xG3mwpULXR4YsCieBBkWgo6uA0szfQM2D+QS
        cO+MSINK5dRar/Z7iKELv3qMMMnVUeENQog==
X-Received: by 2002:adf:f0d1:: with SMTP id x17mr12129014wro.223.1642249621083;
        Sat, 15 Jan 2022 04:27:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuosj48Z96wc9CpVVg353GMRvCJEBxDaoKE+PY1MPfJ8vkd7s+FLfB9jQET/3Y31fE7LgFfQ==
X-Received: by 2002:adf:f0d1:: with SMTP id x17mr12129002wro.223.1642249620903;
        Sat, 15 Jan 2022 04:27:00 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id bk17sm7878476wrb.105.2022.01.15.04.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 04:27:00 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] nfc: llcp: use test_bit()
Date:   Sat, 15 Jan 2022 13:26:48 +0100
Message-Id: <20220115122650.128182-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use test_bit() instead of open-coding it.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 5ad5157aa9c5..b70d5042bf74 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -383,7 +383,7 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 			pr_debug("WKS %d\n", ssap);
 
 			/* This is a WKS, let's check if it's free */
-			if (local->local_wks & BIT(ssap)) {
+			if (test_bit(ssap, &local->local_wks)) {
 				mutex_unlock(&local->sdp_lock);
 
 				return LLCP_SAP_MAX;
-- 
2.32.0

