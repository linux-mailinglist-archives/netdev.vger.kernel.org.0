Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4677721A2FB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGIPGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGIPGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 11:06:49 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81672C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 08:06:49 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so2761528ljj.10
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 08:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sxi/o3f0P5JQ40jJX/xPS0UF1hNrlzQvkms8dM2CJOQ=;
        b=o/x/whIBozHpGOKBxKndeSmrUkyUkt85XUjRqC2OtL/19ugAmoF2rOX+lNu9Wy4l/q
         UcwnBzY8zFYW2Mim1N5Lzj5o+NgdJi50WPX8LLv4BjwR/NphyOXBhlAQTcPXGbRH5nhF
         1jgl51nfwiykfoDBMNAO4Y9XRYzae9iQXgE8xl56zvBjl/E4wZE2tckSzihCqbjHRGGp
         zaOBIFUIxxqdyBUIv83dtFJlBmvrhEDG5rmLE8Vur+wWmK77PqmpZ4NyHrAyJoMO/StR
         8fFE9UUbZnFbZ8wmF2B+H7g+OcxTZULqYvtuzacWhNvsKmWXZvWXhxmiWooWGI6VIXY0
         ko1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sxi/o3f0P5JQ40jJX/xPS0UF1hNrlzQvkms8dM2CJOQ=;
        b=ESh6tj4XYCXROgKsp0ZZMRJ1NuGnV0/NXKolmDC+s2OAqDbXQNhaeX0aS4oThH60m7
         ziFvleS86nWCpBTRY+0s3PZ0Giu76okXHfhv8IyZR/w2hynqLwe31UT80ot31JWS54d8
         I7S6DOxiTI06v6IgELTF2n3ucS9WkrgIjz1GoSqEeoljHp7pNOSCyA37lyMZnuWSfVJD
         FUhWfkeSanoU41JFbtbZ98GP2lCqnKdTJgyMnO3NW5DP+ZNY9/bz1LK47FmXxxxdwaEX
         K88I0pkAlzvHhqXiWzNkmXfe5AaPkrmkN3aKmIZO8lCl4Z4HtzZ4pNGli9YYtiR1AOe7
         ptug==
X-Gm-Message-State: AOAM532POU4haEWXZ27cbjEa2m0tvBgvN1vhwH19XaBaW0XxGheqHCxR
        pssnTmJ5ETmNdaOub/VgvMWdgsRFZgw=
X-Google-Smtp-Source: ABdhPJys+oo5Enxq/2LYELzVoqKDqM4T0xFalPERxMo228L50DFPMnwPZVbDyH5Y5ICjZ8w+bvPJLQ==
X-Received: by 2002:a05:651c:547:: with SMTP id q7mr34936245ljp.437.1594307207553;
        Thu, 09 Jul 2020 08:06:47 -0700 (PDT)
Received: from dau-pc-work.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id x24sm895055ljh.21.2020.07.09.08.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 08:06:46 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH v2 iproute2] misc: make the pattern matching case-insensitive
Date:   Thu,  9 Jul 2020 18:03:43 +0300
Message-Id: <20200709150341.30892-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708082819.155f7bb7@hermes.lan>
References: <20200708082819.155f7bb7@hermes.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve the usability better use case-insensitive pattern-matching
in ifstat, nstat and ss tools.

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 man/man8/rtacct.8 | 7 +++++++
 misc/ifstat.c     | 2 +-
 misc/nstat.c      | 2 +-
 misc/ss.c         | 2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/man/man8/rtacct.8 b/man/man8/rtacct.8
index ccdbf6ca..988a6d1b 100644
--- a/man/man8/rtacct.8
+++ b/man/man8/rtacct.8
@@ -14,6 +14,13 @@ and
 .B rtacct
 are simple tools to monitor kernel snmp counters and network interface statistics.
 
+.B nstat
+can filter kernel snmp counters by name with one or several specified wildcards. Wildcards are case-insensitive and can include special symbols
+.B ?
+and
+.B *
+.
+
 .SH OPTIONS
 .B \-h, \-\-help
 Print help
diff --git a/misc/ifstat.c b/misc/ifstat.c
index 60efe6cb..03327af8 100644
--- a/misc/ifstat.c
+++ b/misc/ifstat.c
@@ -104,7 +104,7 @@ static int match(const char *id)
 		return 1;
 
 	for (i = 0; i < npatterns; i++) {
-		if (!fnmatch(patterns[i], id, 0))
+		if (!fnmatch(patterns[i], id, FNM_CASEFOLD))
 			return 1;
 	}
 	return 0;
diff --git a/misc/nstat.c b/misc/nstat.c
index 425e75ef..88f52eaf 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -114,7 +114,7 @@ static int match(const char *id)
 		return 1;
 
 	for (i = 0; i < npatterns; i++) {
-		if (!fnmatch(patterns[i], id, 0))
+		if (!fnmatch(patterns[i], id, FNM_CASEFOLD))
 			return 1;
 	}
 	return 0;
diff --git a/misc/ss.c b/misc/ss.c
index f3d01812..5aa10e4a 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -1670,7 +1670,7 @@ static int unix_match(const inet_prefix *a, const inet_prefix *p)
 		return 1;
 	if (addr == NULL)
 		addr = "";
-	return !fnmatch(pattern, addr, 0);
+	return !fnmatch(pattern, addr, FNM_CASEFOLD);
 }
 
 static int run_ssfilter(struct ssfilter *f, struct sockstat *s)
-- 
2.26.2

