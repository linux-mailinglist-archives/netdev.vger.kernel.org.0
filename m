Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0482241C868
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345304AbhI2Pb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345296AbhI2Pb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:26 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB41BC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:44 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id l8so10469950edw.2
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EE38NogxNtaKTmKp2iIN72gRdSeWsh1uBV6CKHtm1Ls=;
        b=gwJUxHjAuWh4c70ATN/KX1zxDDKu3o8Nn/0ZW084x1s6QYF3ym4gdzJoT0v+jB51hO
         qRMrz73DORTn9mW677L/FWsvhElJ6riOE02/SUKvtgCty86OaIP5PICIc0LR18uXcJcF
         o5BlmAVIkGA8y00iKfXPajVd5IveH2AuDhIg3O0ci8I4pXaTLeZ6bSfhRjpMeKn6vb61
         KowilHhb5lMfPBWcSWrn10OSb5SBADuDgMPUCW1FkYhK6KitFMwdMFCyb45lKgGB+cEl
         d1TySniPVnelUmDom7mArR2VTPcWNB6nujUIFSLm1cnaxdY6ncUi5I2Q55/U8zXryhSB
         NagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EE38NogxNtaKTmKp2iIN72gRdSeWsh1uBV6CKHtm1Ls=;
        b=jf4VSIvfP3kWW+M/097PgmWArfW/Hh8uzkRB3KoETqCqPDQREVzOuFAFABR0usG8SM
         DyaCeh+xSR6rnyJhaOh24BeXtPHUp/WBDfPjxD7Of9Y14TX1VwRk8fdIBn2uLFiPJFHn
         XzulkZiS9XmAM65YxikVvkeKQ0OZEYJ3jrWG433o4n9SSlACgjyHiaoB01OLjxPlnZPX
         izVMtaLLRe0/E7mTEzKF2YEnwhG3KE7C+R3MvV754S6/0jBaLCv0zSCeFM6J6PLtrS1d
         StUQRgghiJZdIx7lEUs374HFe4fKwDT4yL5xruIxThpXtV/VAKOFMA8dC3zz119QSaCj
         rSaw==
X-Gm-Message-State: AOAM531tyXQToe/m2QQmwPeVXD/6Z4j4wkDGKp7wprNCQmUEp+HDPbKa
        vTfkEtP6DjWwp5heeYjYRTJ4DERxSc56qmCG
X-Google-Smtp-Source: ABdhPJyMeBvuACgzrwDBrqDCD4UeFEQKJ2EERxDLfvLmTl2J3Fa98iqqaahB16mGvneBhUIh+d2cQg==
X-Received: by 2002:a17:906:6c83:: with SMTP id s3mr352314ejr.13.1632929333948;
        Wed, 29 Sep 2021 08:28:53 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:53 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 01/11] ip: print_rta_if takes ifindex as device argument instead of attribute
Date:   Wed, 29 Sep 2021 18:28:38 +0300
Message-Id: <20210929152848.1710552-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need print_rta_if() to take ifindex directly so later we can use it
with cached converted nexthop objects.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ip_common.h |  2 +-
 ip/ipnexthop.c |  2 +-
 ip/iproute.c   | 12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index ad018183eac0..d3d50cbca74d 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -168,7 +168,7 @@ int name_is_vrf(const char *name);
 
 void print_num(FILE *fp, unsigned int width, uint64_t count);
 void print_rt_flags(FILE *fp, unsigned int flags);
-void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix);
+void print_rta_ifidx(FILE *fp, __u32 ifidx, const char *prefix);
 void print_rta_gateway(FILE *fp, unsigned char family,
 		       const struct rtattr *rta);
 #endif /* _IP_COMMON_H_ */
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 9478aa5298eb..a4048d803325 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -381,7 +381,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 		print_rta_gateway(fp, nhm->nh_family, tb[NHA_GATEWAY]);
 
 	if (tb[NHA_OIF])
-		print_rta_if(fp, tb[NHA_OIF], "dev");
+		print_rta_ifidx(fp, rta_getattr_u32(tb[NHA_OIF]), "dev");
 
 	if (nhm->nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
 		print_string(PRINT_ANY, "scope", "scope %s ",
diff --git a/ip/iproute.c b/ip/iproute.c
index 1e5e2002d2ed..f2bf4737b958 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -410,13 +410,13 @@ static void print_rt_pref(FILE *fp, unsigned int pref)
 	}
 }
 
-void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix)
+void print_rta_ifidx(FILE *fp, __u32 ifidx, const char *prefix)
 {
-	const char *ifname = ll_index_to_name(rta_getattr_u32(rta));
+	const char *ifname = ll_index_to_name(ifidx);
 
-	if (is_json_context())
+	if (is_json_context()) {
 		print_string(PRINT_JSON, prefix, NULL, ifname);
-	else {
+	} else {
 		fprintf(fp, "%s ", prefix);
 		color_fprintf(fp, COLOR_IFNAME, "%s ", ifname);
 	}
@@ -862,7 +862,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 		print_rta_via(fp, tb[RTA_VIA]);
 
 	if (tb[RTA_OIF] && filter.oifmask != -1)
-		print_rta_if(fp, tb[RTA_OIF], "dev");
+		print_rta_ifidx(fp, rta_getattr_u32(tb[RTA_OIF]), "dev");
 
 	if (table && (table != RT_TABLE_MAIN || show_details > 0) && !filter.tb)
 		print_string(PRINT_ANY,
@@ -946,7 +946,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 		print_rta_metrics(fp, tb[RTA_METRICS]);
 
 	if (tb[RTA_IIF] && filter.iifmask != -1)
-		print_rta_if(fp, tb[RTA_IIF], "iif");
+		print_rta_ifidx(fp, rta_getattr_u32(tb[RTA_IIF]), "iif");
 
 	if (tb[RTA_PREF])
 		print_rt_pref(fp, rta_getattr_u8(tb[RTA_PREF]));
-- 
2.31.1

