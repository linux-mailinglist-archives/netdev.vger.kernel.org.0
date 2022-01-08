Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4364885F3
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiAHUq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiAHUq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:56 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FD1C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:56 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w7so8625035plp.13
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oE56p6dh9NZJSgcsByBhA6EECdcU/rGK68wqrYdFJ6c=;
        b=yIhQaifi4/nMnCqNKLvP7ShaWqySYwAFyNfsoiyO+7JJbdfHUg6D0wt1hZRG9dlhMK
         swNcatOuDGxD14XdN6vHcsMkjY2VbIsZnp/fZsati7MZTh8R0gs+TX5wtoZRv4ado537
         lSN/E7teE8fkN1EcjuTJLH2/tfqHsywqpiFWLCkobTTygaXELS8TQe9znPEV8EXAQ3Gk
         kEY5pUEPRDWHQQE/PEqkv9Vf5iKIhfFmj6I365jAnPvXLmy2URL+7tN5QDoe6TFJbrVq
         Z7dGYn9fER4cU8gyXb7NLlp3xqq3xSv5VQL6lGgvUvMBDW3whAode3G6IOtVBRQGXUO1
         zd7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oE56p6dh9NZJSgcsByBhA6EECdcU/rGK68wqrYdFJ6c=;
        b=xwqfBXkQXJK/kTj7AICspSv+HLbdcSwvOP0TFlpYZXWtwLkKaTnTKW2btR3NIbdJTJ
         q9ar/fjqaPLBjKbYeGI2R0R0mq38VzsKGXvqy4ZuG4SU8Mr2Smt3idwt1wCSG2ORsYXm
         QOtawe1/koQxsLGlJuCHP9QswBC7nYRtc5tXfuu3Jw0RIP1Y5HBZRMw7r4aKZXPqja/d
         BLPW0iYco8R3aIOjPUPeUrB4Oinh2CwGkyLma1/cZE/cIB0A8ek4dTRfdaOWotS9r0Hj
         UV9ySEsx39VddMtpq+Z+e0hoTuYBre5HW0vNTq7/Gs+o2XqA8oc5+yJyuN2UWlXQ1Px1
         aMlA==
X-Gm-Message-State: AOAM5300CVB9HdcmB2YXZOmSeA9J1hpRAxuos30ZXg+kEuIjYro7xkjV
        +fE/7hd/nBd9xzlP72BdPxmiu1dz2Z7FlQ==
X-Google-Smtp-Source: ABdhPJy0e6687ucK+wJllEkwc0zVHzNkG77s8y8v4G+QxsatbQwsJPXXx0n0y4K5pjw0lvHOk6zgSA==
X-Received: by 2002:a63:b949:: with SMTP id v9mr21984879pgo.79.1641674815811;
        Sat, 08 Jan 2022 12:46:55 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:55 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>, gnault@redhat.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 04/11] m_vlan: fix formatting of push ethernet src mac
Date:   Sat,  8 Jan 2022 12:46:43 -0800
Message-Id: <20220108204650.36185-5-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was reported as a clang warning:
    CC       m_vlan.o
m_vlan.c:282:32: warning: converting the enum constant to a boolean [-Wint-in-bool-context]
                if (tb[TCA_VLAN_PUSH_ETH_SRC &&
                                             ^

But it is really a bug in the code for displaying the pushed
source mac.

Fixes: d61167dd88b4 ("m_vlan: add pop_eth and push_eth actions")
Cc: gnault@redhat.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/m_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 221083dfc0da..1b2b1d51ed2d 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -279,8 +279,8 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 				    ETH_ALEN, 0, b1, sizeof(b1));
 			print_string(PRINT_ANY, "dst_mac", " dst_mac %s", b1);
 		}
-		if (tb[TCA_VLAN_PUSH_ETH_SRC &&
-		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN]) {
+		if (tb[TCA_VLAN_PUSH_ETH_SRC] &&
+		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN) {
 			ll_addr_n2a(RTA_DATA(tb[TCA_VLAN_PUSH_ETH_SRC]),
 				    ETH_ALEN, 0, b1, sizeof(b1));
 			print_string(PRINT_ANY, "src_mac", " src_mac %s", b1);
-- 
2.30.2

