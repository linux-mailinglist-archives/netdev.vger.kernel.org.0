Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7861A12DF
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgDGRnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:43:21 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50514 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGRnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:43:21 -0400
Received: by mail-pj1-f68.google.com with SMTP id v13so72169pjb.0
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 10:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dx+tbWSKJSlTR6JClGE4+hKpHGCcyOAr+fA/UbcPQzA=;
        b=IOyJxyhNN0KERtZMjd52N0xqcwP9vpXUObsG9o7fewHR5DId9UCxal6STf0YHIgCeK
         BfbJjQIrZFe/nRYrCCWPZJ6lFjXNLF1TJNXrEQb/cEWViWF9NGoQKvrSiyUwUhEgwoAT
         GUZsq6cWqaxzzDhiVnhrj9CKw/W62kAJ6A4Po=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dx+tbWSKJSlTR6JClGE4+hKpHGCcyOAr+fA/UbcPQzA=;
        b=sxoP6TK9BWMobj5bDG/X24KTr5pbpUiz2PSPqcAyCg1PdWqYyf/KAaX1OeaBec8kNw
         JaJxerFPqbJIsnqZKJRtZouXXDwKzlVDnvVQwdZ9qF+49nIrOSd7E/XlqjEGQVDVDNd5
         PKskwAwjwnYz8Y7Ik2VTHRb7JqoQpIeAeriJCVUlniGB9c70Josjmg333QiHUmXb3Uuy
         Lgs823FeLmAhK3Z2TPRR39aVkMtLBx7tj7+uQeKM7nOgHekvYoX1xDR7rZl7mqYRiTJM
         i802GpJMTQA0b0n+jG/0IjO4w60cavjZeeNrR8MeGloKZqPosmQfxqGyDXD8f5juDIfH
         wOrQ==
X-Gm-Message-State: AGi0PuZTCofEwZFCRYBzzIN2s0yxeSV3lv33alxU+2ECpJn5Pk/kiFny
        0x4SDtRFSRhPDxfCAcV22YYQaOmMq1w=
X-Google-Smtp-Source: APiQypKLtEP+ms4szlGcbm/osf86ZHrW4TITBsJw+Jl4CXS1bFcncccVWuC8acY0ryK1zI7m7MDsCg==
X-Received: by 2002:a17:90a:868b:: with SMTP id p11mr563298pjn.34.1586281399469;
        Tue, 07 Apr 2020 10:43:19 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id m3sm14021996pgt.27.2020.04.07.10.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 10:43:18 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH iproute2 1/2] man: add ip-netns(8) as generation target
Date:   Tue,  7 Apr 2020 10:43:05 -0700
Message-Id: <20200407174306.145032-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for adding new variable substitutions. Unify the sed rules while
we're at it, since there's no need to write this out 4 times.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 man/man8/.gitignore                    |  1 +
 man/man8/Makefile                      | 10 ++--------
 man/man8/{ip-netns.8 => ip-netns.8.in} |  0
 3 files changed, 3 insertions(+), 8 deletions(-)
 rename man/man8/{ip-netns.8 => ip-netns.8.in} (100%)

diff --git a/man/man8/.gitignore b/man/man8/.gitignore
index 0c3d15047fde..7b08e9114455 100644
--- a/man/man8/.gitignore
+++ b/man/man8/.gitignore
@@ -1,4 +1,5 @@
 # these pages are built
 ip-address.8
 ip-link.8
+ip-netns.8
 ip-route.8
diff --git a/man/man8/Makefile b/man/man8/Makefile
index 0269e17406b7..9c62312396a2 100644
--- a/man/man8/Makefile
+++ b/man/man8/Makefile
@@ -1,17 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
-TARGETS = ip-address.8 ip-link.8 ip-route.8
+TARGETS = ip-address.8 ip-link.8 ip-netns.8 ip-route.8
 
 MAN8PAGES = $(TARGETS) $(filter-out $(TARGETS),$(wildcard *.8))
 
 all: $(TARGETS)
 
-ip-address.8: ip-address.8.in
-	sed "s|@SYSCONFDIR@|$(CONFDIR)|g" $< > $@
-
-ip-link.8: ip-link.8.in
-	sed "s|@SYSCONFDIR@|$(CONFDIR)|g" $< > $@
-
-ip-route.8: ip-route.8.in
+%: %.in
 	sed "s|@SYSCONFDIR@|$(CONFDIR)|g" $< > $@
 
 distclean: clean
diff --git a/man/man8/ip-netns.8 b/man/man8/ip-netns.8.in
similarity index 100%
rename from man/man8/ip-netns.8
rename to man/man8/ip-netns.8.in
-- 
2.26.0.292.g33ef6b2f38-goog

