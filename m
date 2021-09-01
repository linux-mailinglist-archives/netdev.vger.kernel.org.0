Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6243FE43F
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbhIAUsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhIAUsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:48:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4C3C061764
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 13:47:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x16so799242pfh.2
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WJ+KTbtxL5NhEb3PLLI/YCaMbaL5oHeHgo83ZaRNSU=;
        b=d2Vt+IYj0gjOjykYd/5TUPMQ3QnbWFFhYchD8hBemCfeSsGoO3r67u0QxszNLEEGJ5
         L1RbVETlxD9KXUmBhsBLKzDivWCS2wBHEfeH2NPUr4+3MW0gV0UyvdZCGVV5q281qMLx
         +oYF/noRyJbbsfSCfe+R1VnvGoDqQXtXAZ0DisI7NE20/P1tket5XASyYjTmf0YvYWN1
         CdJqmbKiAicU1L1C/pWzp7SMN2zmPXX5f6nmAuh0wgoBZT9ddU+++7ikIBkEr7ih2j2O
         jHyAXZ3PvMxtY4D6xVHvg3U/wwjMH3A6myPywLoloqI/MuWWV6Fq3v8jmJCn9IAqEAX9
         eE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WJ+KTbtxL5NhEb3PLLI/YCaMbaL5oHeHgo83ZaRNSU=;
        b=rISnTv8/Yasw0zmzvnw2WjHWwLva1tJIRhgVyd/ShxNU8Gl0ki80g6t1DCIbZxdTZZ
         123wPI6BW4Fwbo2cFJjRGx2v/aEtCzw4h1ooiCrKC6k4iXKnPouANU3NHHa14Yn0dfjY
         VtqQIKDC9hEWPvbTtoClm23rNCOrdyVgEjVsuM/f6KQFcAV/RBSjlS3tHX541BJNCiw2
         Uu+5SA6x73mF06Tmy1au5co5tAWI1khGObaRn0b4bokgLQmfdlLk3T2xquFLWXMOzY7A
         fLaJ9H/RAwgQitIE47um94IwpdRG6e/RoJdovrVsUUz8yJq8oJ4/JeNFFGCkw5KcG4Yb
         UBKQ==
X-Gm-Message-State: AOAM531bsa+7dfxdXz40ZgxsdCoqlPVJtxSESqWwX0IA+fxY2BTj77tv
        itRt1CNGrtjvtTgnf5x+xrhMhAuPSiv8EA==
X-Google-Smtp-Source: ABdhPJz1N8/pTPuuQvqJKdukxWu0WVCTBNRLidVf/xlXR8fkGwdpUNfA+fx3+SFUPkUfdo2a06Amhw==
X-Received: by 2002:a63:1247:: with SMTP id 7mr867925pgs.366.1630529227221;
        Wed, 01 Sep 2021 13:47:07 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g26sm565073pgb.45.2021.09.01.13.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:47:06 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 3/4] ip: remove routef script
Date:   Wed,  1 Sep 2021 13:47:00 -0700
Message-Id: <20210901204701.19646-4-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901204701.19646-1-sthemmin@microsoft.com>
References: <20210901204701.19646-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

This script is old and limited to IPv4.
Using ip route command directly is better option.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/Makefile       |  2 +-
 ip/routef         | 10 ----------
 man/man8/routef.8 |  1 -
 man/man8/routel.8 | 12 ++----------
 4 files changed, 3 insertions(+), 22 deletions(-)
 delete mode 100755 ip/routef
 delete mode 100644 man/man8/routef.8

diff --git a/ip/Makefile b/ip/Makefile
index e27dfa097877..bcc5f816b319 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -18,7 +18,7 @@ RTMONOBJ=rtmon.o
 include ../config.mk
 
 ALLOBJ=$(IPOBJ) $(RTMONOBJ)
-SCRIPTS=routel routef
+SCRIPTS=routel
 TARGETS=ip rtmon
 
 all: $(TARGETS) $(SCRIPTS)
diff --git a/ip/routef b/ip/routef
deleted file mode 100755
index c251e7b87efd..000000000000
--- a/ip/routef
+++ /dev/null
@@ -1,10 +0,0 @@
-#! /bin/sh
-# SPDX-License-Identifier: GPL-2.0
-
-if [ -z "$*" ] ; then
-	exec ip -4 ro flush  scope global  type unicast
-else
-	echo "Usage: routef"
-	echo
-	echo "This script will flush the IPv4 routing table"
-fi
diff --git a/man/man8/routef.8 b/man/man8/routef.8
deleted file mode 100644
index c2a70598923f..000000000000
--- a/man/man8/routef.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/routel.8
diff --git a/man/man8/routel.8 b/man/man8/routel.8
index 2270eacb51fb..b32eeafcf69d 100644
--- a/man/man8/routel.8
+++ b/man/man8/routel.8
@@ -2,21 +2,13 @@
 .SH "NAME"
 .LP
 routel \- list routes with pretty output format
-.br
-routef \- flush routes
 .SH "SYNTAX"
 .LP
 routel [\fItablenr\fP [\fIraw ip args...\fP]]
-.br
-routef
 .SH "DESCRIPTION"
 .LP
-These programs are a set of helper scripts you can use instead of raw iproute2 commands.
-.br
-The routel script will list routes in a format that some might consider easier to interpret then the ip route list equivalent.
-.br
-The routef script does not take any arguments and will simply flush the routing table down the drain. Beware! This means deleting all routes which will make your network unusable!
-
+The routel script will list routes in a format that some might consider easier to interpret
+then the ip route list equivalent.
 .SH "AUTHORS"
 .LP
 The routel script was written by Stephen R. van den Berg <srb@cuci.nl>, 1999/04/18 and donated to the public domain.
-- 
2.30.2

