Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297BB41D8F3
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350568AbhI3LlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350447AbhI3LlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43616C06176C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l8so21219946edw.2
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2i/Mqwrz2agOlxgqYa9F+/vKQmuJbhOqcjJMyfrNYyo=;
        b=h6evyg7kFns6vckrf2GQZNpAbZWAf8DXuKoTZdoeWdw642ZKHtPYis2oGl20QJGIwL
         5/GDCW2Inyfddtv63p27sSllSEFrFW6RI8/euJYYIsUbU7VK3CPutDqus8Ta2aBpdcb9
         +2l58HnkZr51WNjtMYAGeSkukcWuNtkuxKCXAdPfkt2BH2AMS7+tI0A+EyMXX6IhcX8M
         MflHibPuT5hY8Ab0nzjjiBdYSYJElX8l9ShbVvLk98t5zqTQiK3YZlqzLhRRigeltaIV
         OTJuApKXH2T0aGb0V/lqAtHpP5yVCyM1E5eUz73UjWuvwcYMlfdSdXTx/vFvDe/7M2bl
         lRYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2i/Mqwrz2agOlxgqYa9F+/vKQmuJbhOqcjJMyfrNYyo=;
        b=Pacnm8hvdpd6HAo2oOzNqm2K8NxojeBSoOvQs5MIeXMfuHXa4yhuXnWZdUV5pcfwpA
         5mvYx/qdhhYK8YppnmKPJ7NhvgxwJkg2TRB/0y6Bxl5T4/WWNwochrVdima0uQvD31bb
         BM1ajcFpDkBZV1WVjlrCLPG+iAEhcveHpkIxMeydZ/T13HAy3KDMBHJ/chKJGeKyBkpS
         INq1vfdanMoRZGWykNzSggxYTJxF/YJvAB8LPchnXCH9rNPAyBqvQwWL+G89yJwsV7Al
         1I1afJNBhpw2QPcozcOYCXvVcSM5spOWYQEVmSQRVLSF7hsEJznInaJA5cQxIp26cpIF
         IqLQ==
X-Gm-Message-State: AOAM532RkKa+t0P++XCOAWeEU9tHnchR2n9lCuPcFN4nMULn6c0Zeoo8
        lldR6vUmOo40zbWUpnteCn79Ppu399FlPy1+
X-Google-Smtp-Source: ABdhPJz3pCPBo1T6AP4HOER9TIXEXwBPp86QgatObIY+nzjmbLc/cW7tOQ3rCgDu7J4aBwH1sBRlRA==
X-Received: by 2002:a17:906:5908:: with SMTP id h8mr6134618ejq.508.1633001965508;
        Thu, 30 Sep 2021 04:39:25 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:25 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 02/12] ip: export print_rta_gateway version which outputs prepared gateway string
Date:   Thu, 30 Sep 2021 14:38:34 +0300
Message-Id: <20210930113844.1829373-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Export a new __print_rta_gateway that takes a prepared gateway string to
print which is also used by print_rta_gateway for consistent format.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ip_common.h |  1 +
 ip/iproute.c   | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index d3d50cbca74d..a02a3b96f7fd 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -169,6 +169,7 @@ int name_is_vrf(const char *name);
 void print_num(FILE *fp, unsigned int width, uint64_t count);
 void print_rt_flags(FILE *fp, unsigned int flags);
 void print_rta_ifidx(FILE *fp, __u32 ifidx, const char *prefix);
+void __print_rta_gateway(FILE *fp, unsigned char family, const char *gateway);
 void print_rta_gateway(FILE *fp, unsigned char family,
 		       const struct rtattr *rta);
 #endif /* _IP_COMMON_H_ */
diff --git a/ip/iproute.c b/ip/iproute.c
index f2bf4737b958..3c933df4dd29 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -547,13 +547,11 @@ static void print_rta_newdst(FILE *fp, const struct rtmsg *r,
 	}
 }
 
-void print_rta_gateway(FILE *fp, unsigned char family, const struct rtattr *rta)
+void __print_rta_gateway(FILE *fp, unsigned char family, const char *gateway)
 {
-	const char *gateway = format_host_rta(family, rta);
-
-	if (is_json_context())
+	if (is_json_context()) {
 		print_string(PRINT_JSON, "gateway", NULL, gateway);
-	else {
+	} else {
 		fprintf(fp, "via ");
 		print_color_string(PRINT_FP,
 				   ifa_family_color(family),
@@ -561,6 +559,13 @@ void print_rta_gateway(FILE *fp, unsigned char family, const struct rtattr *rta)
 	}
 }
 
+void print_rta_gateway(FILE *fp, unsigned char family, const struct rtattr *rta)
+{
+	const char *gateway = format_host_rta(family, rta);
+
+	__print_rta_gateway(fp, family, gateway);
+}
+
 static void print_rta_via(FILE *fp, const struct rtattr *rta)
 {
 	size_t len = RTA_PAYLOAD(rta) - 2;
-- 
2.31.1

