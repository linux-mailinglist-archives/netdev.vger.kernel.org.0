Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0D02F07F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbfE3EEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbfE3DRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:17:50 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F1324730;
        Thu, 30 May 2019 03:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186270;
        bh=slmTQXCo492YJ3HiWSXk9l4HgBA82vvXctiuhGrpyGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cu3Ho/WHOYre62LRCNMxeTqF5yzLUbv3eQGH2eyfT4/wDwoMtAb/r2919PfNTgBHK
         VKKPH7uitwMQ5f+S5G3mbKlQABBqiXiPQvrzbW14SbTuSyQre64gbM9Z6AUA3tVZ2O
         F9fBZTGKywWzC1O+l9wXR74X1qr7sX7MKlpSq/wI=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 6/9] ip route: Export print_rt_flags and print_rta_if
Date:   Wed, 29 May 2019 20:17:43 -0700
Message-Id: <20190530031746.2040-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530031746.2040-1-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Export print_rt_flags and print_rta_if for use by the nexthop
command.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/ip_common.h | 3 ++-
 ip/iproute.c   | 5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index df279e4f7b9a..1c90770be548 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -156,5 +156,6 @@ int name_is_vrf(const char *name);
 #endif
 
 void print_num(FILE *fp, unsigned int width, uint64_t count);
-
+void print_rt_flags(FILE *fp, unsigned int flags);
+void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix);
 #endif /* _IP_COMMON_H_ */
diff --git a/ip/iproute.c b/ip/iproute.c
index 440b1fc8b413..c5a473704d95 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -349,7 +349,7 @@ static void print_rtax_features(FILE *fp, unsigned int features)
 			    "features", "%#llx ", of);
 }
 
-static void print_rt_flags(FILE *fp, unsigned int flags)
+void print_rt_flags(FILE *fp, unsigned int flags)
 {
 	open_json_array(PRINT_JSON,
 			is_json_context() ?  "flags" : "");
@@ -394,8 +394,7 @@ static void print_rt_pref(FILE *fp, unsigned int pref)
 	}
 }
 
-static void print_rta_if(FILE *fp, const struct rtattr *rta,
-			const char *prefix)
+void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix)
 {
 	const char *ifname = ll_index_to_name(rta_getattr_u32(rta));
 
-- 
2.11.0

