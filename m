Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E453FE43D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhIAUsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhIAUsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:48:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F43C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 13:47:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso620996pjq.4
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BidK7xPrerg6Gymyud5dTvFiiB0Y7sTgtHAJBav52rA=;
        b=DDGXFPWHTCNljHa6bWc11tyFLy/JTVpipElLG2XDKcH/qXhJq9mGfDUfbJcIjdGsT8
         I5ZPSf+O9lPL64NL6f/G/DGt8Wa1vqCiXSQ6P+6KXb3nPdWvbjILNHZsJHlSf80R8hla
         vTrx8hbPYkOhigARP7g/W3qzOG82rqLhMJi7b4jDkvf61YEEKPAEYzVLpTJFknEyFnf/
         x/sVElQLdwGCpdp83DDcNM/IF9tXrvnTJTCIBQ+O9ZSOcHOqGWZ1GjsKzTm2/Fv/eU38
         T+jdUSuQBjg+7oGmgiOJVvuCaIGpXF2atAlnbrGsHLdkdGP/cUBOim/FM9u0JOgVYVK6
         tAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BidK7xPrerg6Gymyud5dTvFiiB0Y7sTgtHAJBav52rA=;
        b=chpWsfKCCKXrNpnPVTaKHXcjQUcFkRPPxW3+3D7zkA+jGPQwbGCawdgQsDPxpKxsWO
         7WwoS7BuZNqcWAeTp7vUzO7NMKaLr6n0oxIzGU21xW7ijbTc6Qp1BABfe62EZAjfmV8D
         TirvKJRVbmtrLpqNVjH6135HaLPJLx1SPulckUZLnFbn7tOCedh3oCIw+mMb9YJVE/j9
         S9R6H1l3p0Dlyz/WXArsHqhXiM4in+oSJBNAX0VWsiEkYnDo+VdRSeZ4AW+qQxcFZtbF
         FoIPiF+O+Tm8GhWTZUkWgyYrZEqnHUJERsVNFMBDFhsD7MmVlnVR9q8fPiznJE1MBoe6
         eLvw==
X-Gm-Message-State: AOAM533hvY1vX0fHSSxEyTgaHmrK53rHV7iVoHJVATd19YKS/VaaXTxI
        R0ckPtk9nzPRk0HOnt5GCWr5y1tA3Zx2mQ==
X-Google-Smtp-Source: ABdhPJyCioJU7aOQ59w45tBmv4xLnYD1LbF7CPK408ZkAiB8LZxYiAieo5S16ZrzO1R+JnPVJ1N+4g==
X-Received: by 2002:a17:90b:88e:: with SMTP id bj14mr1256184pjb.115.1630529224705;
        Wed, 01 Sep 2021 13:47:04 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g26sm565073pgb.45.2021.09.01.13.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:47:04 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 1/4] ip: remove old rtpr script
Date:   Wed,  1 Sep 2021 13:46:58 -0700
Message-Id: <20210901204701.19646-2-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901204701.19646-1-sthemmin@microsoft.com>
References: <20210901204701.19646-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

This script was a one off hack for a special case.
Now that ip commands have better formatting, there is no
real reason for it.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/Makefile     |  2 +-
 ip/rtpr         |  5 -----
 man/man8/rtpr.8 | 25 -------------------------
 3 files changed, 1 insertion(+), 31 deletions(-)
 delete mode 100755 ip/rtpr
 delete mode 100644 man/man8/rtpr.8

diff --git a/ip/Makefile b/ip/Makefile
index 2ae9df89b5a6..a3b4249e7e06 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -18,7 +18,7 @@ RTMONOBJ=rtmon.o
 include ../config.mk
 
 ALLOBJ=$(IPOBJ) $(RTMONOBJ)
-SCRIPTS=ifcfg rtpr routel routef
+SCRIPTS=ifcfg routel routef
 TARGETS=ip rtmon
 
 all: $(TARGETS) $(SCRIPTS)
diff --git a/ip/rtpr b/ip/rtpr
deleted file mode 100755
index 7e48674bcf53..000000000000
--- a/ip/rtpr
+++ /dev/null
@@ -1,5 +0,0 @@
-#! /bin/sh
-# SPDX-License-Identifier: GPL-2.0
-
-exec tr "[\\\\]" "[
-]"
diff --git a/man/man8/rtpr.8 b/man/man8/rtpr.8
deleted file mode 100644
index 87f291ab50ac..000000000000
--- a/man/man8/rtpr.8
+++ /dev/null
@@ -1,25 +0,0 @@
-.TH RTPR 8 "18 September, 2015"
-
-.SH NAME
-rtpr \- replace backslashes with newlines.
-
-.SH DESCRIPTION
-.B rtpr
-is a trivial shell script which converts backslashes in standard input to newlines. It's sole purpose is to be fed with input from
-.B ip
-when executed with it's
-.B --oneline
-flag.
-
-.SH EXAMPLES
-.TP
-ip --oneline address show | rtpr
-Undo oneline converted
-.B ip-address
-output.
-
-.SH SEE ALSO
-.BR ip (8)
-
-.SH AUTHORS
-Stephen Hemminger <shemming@brocade.com>
-- 
2.30.2

