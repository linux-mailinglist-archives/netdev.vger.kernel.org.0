Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26741C869
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345308AbhI2Pbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345296AbhI2Pbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:32 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD5C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:51 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y35so10243601ede.3
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2i/Mqwrz2agOlxgqYa9F+/vKQmuJbhOqcjJMyfrNYyo=;
        b=C2IjEoffpGzSN986MX3VjrSwh4V5Sec4sf/GS1MI7lsHMdDQFYBqJUILzG3pbVrtnS
         Nlb8Pbm+FyVaQ0GBoiFLLzjg9cTjL4oqvoMq4I5/AAhsD63uwl5BU/Brm0wUFNOFkCxM
         8/Aimz1NsSaUYxOlS3MYlzdQLWmhv7QYRgImIBWZE57FUxxKzE5oId1kW7fIY4w6ZVH5
         zrPYCHuWKTdyfQIQ9YuNxSzIEQ/R0CVn8bMAIQeHB+Ao++L/gVt9ELDlZ0/q4oL6IakO
         vN79C9y6c9CBWvbC4+wQvmEszDwjnDjPxxnzPEFl1NKUHVjKODdWdzNVUUnEeuPxrjTm
         YkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2i/Mqwrz2agOlxgqYa9F+/vKQmuJbhOqcjJMyfrNYyo=;
        b=oPHYQa8JhyTs6TBLf/NF2FfoBVF6cE60hkCQy7ybwSNbkKVYNjFY7xmO1s8cy0BDrV
         QwGskpdPapPSzn3c7PxgySZEqZdDIi3d6Qqk9TSrclhWUmwcnbXuYLSauYDbyF02x4uz
         wLHyUCLWFJq6C8eY/af4bcWgeVpQ1yb12Hv4R1hlKuMGJx/1gDHppxIz0TPkJz1/nKW+
         Qg1Dwbfzhx44QHHHg+9sx9J7Y/jupi5NJkeCmkYDMl/GiuLfEzJG6EiH/wmX/vnLDJP7
         pTJT/hnM3BIAqDqImypZ2t/rsRt4EJhNWhaxHCFIfpxZcwjQO2VDbWh+yTu1rlWKRMVt
         EE0A==
X-Gm-Message-State: AOAM532+5x0qs0FFLdUBY/ugYIb9Pp0ExbHgrgWZ/DYt/yMkb1VgPtQB
        jXqqOQYtRvO5DEnEpGUxzdxGZJam45I/TAf7
X-Google-Smtp-Source: ABdhPJzdNekr0Zr/Ia4zabuqF/7qzdpcinQ481D36HK6nBIHxSFhbSBLy+lvZrrnEVE6Mc7K7C6vmw==
X-Received: by 2002:a17:907:20c8:: with SMTP id qq8mr309526ejb.339.1632929334954;
        Wed, 29 Sep 2021 08:28:54 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:54 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 02/11] ip: export print_rta_gateway version which outputs prepared gateway string
Date:   Wed, 29 Sep 2021 18:28:39 +0300
Message-Id: <20210929152848.1710552-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
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

