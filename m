Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A51648B4AD
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344894AbiAKRy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344907AbiAKRyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:51 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21007C061757
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:51 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so6715528pjj.2
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PsvdTqbhqt6fDLNJxGBf0YgetV/tZW999PPm+FRuyGo=;
        b=JwmwEJjt372KiiJ30TnJlzt4WpfC7ep7zc2bfN/kJS9S+N18VDyTAAD158cwCo2CWv
         93CDo9sM245aG3Fz3t+BqjPAuKbJaCWJabKIBNKLvan9cyGOB/iyC7FD8WZO0r/fb3pM
         w0jLNZP9swK9SoSloxTmlW5KTgaZNBj8h+Vk3mO9BOrkdshTf2GcfTn9g2QWCcIVYz8B
         DrzmpIATEAWFO1w5a+EAHVeDDFGGAgWyDw3mMsnFPhroTbcOITUNC+7ZdLU846PYnk64
         tYoGWpe9ImAajGgDPFOaDXkERw1O0PscL3vJXxUZB9wSpclf7d5NDSGQp373Gj3h9g1G
         sGuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PsvdTqbhqt6fDLNJxGBf0YgetV/tZW999PPm+FRuyGo=;
        b=jIOFC1RJF5Bxe95evAVAIvBROOnw0a8jMBhFpmsXRwaYF02ObptafAA4gMm8rpVzqJ
         IBns9+9l5XBpTOeuMgM/8FqUWc7HmzsxQSjlVWOS7HoWknM3tTQolMPnYwcr0H72Tkzf
         yDfKcJ9kzOkZM8GCcuxiG+IYgNAfPqVoNNM3kRD7fHZ7luMlYGQYM6X6VSBDNnE1Ar0J
         CbwwgitooHKPS0OTyWbiYdCgKmIp73jyyU2VBxBPcJSUDHzzt0UBBnuMR51DowvuLySB
         GJLPYKCTGgDduNFvJ164jei1vH5R1uI7hkaQXpbbquSiRASPae06XfzEAr64heb8b2Bb
         zU0g==
X-Gm-Message-State: AOAM531dndUPIKbtzORh/tl3goXCRlb+z2YZd1ExfoVsKaDN/PKhqRYI
        2lY060BaJlrHZekoiMGTilYrGba5Z2VyLQ==
X-Google-Smtp-Source: ABdhPJzYBxYeBJDvryHoWmX9J8F+1x6vIzQZHgnj+bWUwyKRdbcULIsz6vmu7nMU+KjpJaXCyDolQA==
X-Received: by 2002:a17:902:c9d2:b0:14a:3335:accd with SMTP id q18-20020a170902c9d200b0014a3335accdmr5574705pld.94.1641923690346;
        Tue, 11 Jan 2022 09:54:50 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:49 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 09/11] tunnel: fix clang warning
Date:   Tue, 11 Jan 2022 09:54:36 -0800
Message-Id: <20220111175438.21901-10-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fix clang warning about passing non-format string.

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

