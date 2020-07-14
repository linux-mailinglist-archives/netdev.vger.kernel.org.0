Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53321F26B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgGNNYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgGNNYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:24:02 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D435C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:24:02 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id k17so11557040lfg.3
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sxi/o3f0P5JQ40jJX/xPS0UF1hNrlzQvkms8dM2CJOQ=;
        b=J1x0HSZCkO+ZU70vZ5icibQwOQ2QfnHZYX3JOJ1hxHrzaXbuTdlE0nPcmfOVpH5Acc
         qFZVrpOMU0w/7HZTfOAU29WG45KmEeS7b7kX23Qb6uhoiMRCRrMOahWcHdlZ9gUOQfe0
         OsLLHnJYYY5ANGRcBsoqBHRJ9iPol/mDRWbvx/YXZ/8IgU3ecoa/06pqjr895P/FZUyj
         zMp1pV8lA7nrrlvXqlXlNZ1vOU9QMWKpcp827ARcvY6fjJvd263P05tWf76EwmEzw6r1
         7uz/JK8Asf1GkDCdr+vki+UmZoO79ZRjvS/FHtD1VE+03slUk/4VwxsxK8k8FJIkUxEf
         N5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sxi/o3f0P5JQ40jJX/xPS0UF1hNrlzQvkms8dM2CJOQ=;
        b=XWxU4UzqlYHn6ojcnOlh2wS97DfgS0l0E3ukK2X50w7hcz4Y53/ydOrVJPd0AmKnQN
         GN5hVdeLRR1BQEHhn6mg8dKeri4XdnzmiTlmFv/011qdxP+xAg77ZjA2bz/PSqbGeHyP
         whuecoWimDsp/HWSqplE0JeTB91o6h7KOAGifUcFsghjWXjo8BEdW7EaPfNhV7XLtm4S
         DtKaib7hGlcg9Ca4PQMD0lAGtW/QbFDA5W7AetcgbBSRdfdenP7u6nkETeNLD7o7LjTz
         n0hv8ZAejvahFTjmoBn4S8JklCeNEo0Y7I0wj0BbO/ebPPvvomKKI86RdPfn/imMfrU+
         nStg==
X-Gm-Message-State: AOAM530xtEPuLi4DLENoEs5ko1CBEyVEN5JlC+ZRTNtQuz9lbbAekXTG
        UDsEaACpiuSQyzSZj+xDtU69FhaUdqI=
X-Google-Smtp-Source: ABdhPJwpgpsJB1RCxrEfnpoQr1yBgtmK7yQ1ob/qMXqQZWeip/h2tj5ahdlx+Twet1QxC0p+0OaESw==
X-Received: by 2002:ac2:48b8:: with SMTP id u24mr2191288lfg.145.1594733040582;
        Tue, 14 Jul 2020 06:24:00 -0700 (PDT)
Received: from dau-pc-work.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id a17sm909293lji.5.2020.07.14.06.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 06:24:00 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH iproute2] misc: make the pattern matching case-insensitive
Date:   Tue, 14 Jul 2020 16:23:48 +0300
Message-Id: <20200714132347.36012-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.27.0
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

