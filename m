Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8D633701B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 11:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhCKKfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 05:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbhCKKez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 05:34:55 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9723C061574;
        Thu, 11 Mar 2021 02:34:55 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x7so10772541pfi.7;
        Thu, 11 Mar 2021 02:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=LsOaumeF1bmcVfafAU6tzrmF1qroFKtzuGLnEEy+C7c=;
        b=r7mxmWqZUvPRxN2Tf0nBPPv6ZVCtyKY1eO85F6qwp9uURZvOD3YtUyaeNQqFKIXSM7
         7tU1ilpHcXoklZDnJIizla5vIuNpJ3YDlYO5V5PLZ7mcemz0ChUBGhho8fPCeU3+/yWd
         h+tezmrzydpuAJybKGnG7664qT43RE1urlmN+I/ynMKOVQZE/poYC3GZUB3zu3MBCHjc
         k5KICnnkd6FEWVTfBk5fPF7T+i60INsUAKKt1UUipwt7NeWOeQ+uZuk6VION2fkWazNO
         gUBRwIHFFvfTiqgbrMi91Lvbh4zMGM83BhE/6dSuoFoowivegeqn9hbarTW4r9cP297B
         QcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=LsOaumeF1bmcVfafAU6tzrmF1qroFKtzuGLnEEy+C7c=;
        b=rKgUI6VWrl7tfOooHFgxwIswfKAtGyFrrzmOPRpHxYWzEtmRmaCbS1NYODD/tm0WKm
         ihpxJtwmx4SMvRYij1sJ1r5ReNFtXBUgvnXGyHIWpN9Gf7LjOF7h8vihzW16kjqQKFoH
         V5mdoNxit7c4cVVpILHmYjS+y1ahXy/vZImHolaB7+wfIEzXKgmtufxqws7fIx0iY59f
         veBMWtDcz7dhZjwyG57TyEdlJBfxL8NtPFxcEmN1cLdgxpRQ5+L3sZt+xlRs+B+bL596
         kKctmIUYsM/lpSIRk3+RWkOc7lSuy161+2drBm8e6hd4HFrCZHyyuGUaJmmWZTMNJ18k
         w0VA==
X-Gm-Message-State: AOAM5318X3/z2uKI3+caJyAVajkDRZU+dquKt2UcgBOsNkpGyK3l3tMD
        IfM6bNlT17OLZoQiCj/Qxa4=
X-Google-Smtp-Source: ABdhPJz3RY6gWzEtcEztwFA61OFqjJ7MBX4+oYMCv7blv4qHRDObAe6Dw5PYquj4XKHmZFguzWVAMw==
X-Received: by 2002:a62:928f:0:b029:1ef:2370:2600 with SMTP id o137-20020a62928f0000b02901ef23702600mr7272144pfd.9.1615458895142;
        Thu, 11 Mar 2021 02:34:55 -0800 (PST)
Received: from localhost ([122.179.55.249])
        by smtp.gmail.com with ESMTPSA id w17sm2061414pgg.41.2021.03.11.02.34.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 02:34:54 -0800 (PST)
Date:   Thu, 11 Mar 2021 16:04:46 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, edumazet@google.com, willemb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab+huawei@kernel.org
Subject: [PATCH 1/2] net: core: datagram.c: Fix use of assignment in if
 condition
Message-ID: <20210311103446.5dwjcopeggy7k6gg@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assignment inside the if condition has been changed to
initialising outside the if condition.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/core/datagram.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 15ab9ffb27fe..7b2204f102b7 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -427,7 +427,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 		offset += n;
 		if (n != copy)
 			goto short_copy;
-		if ((len -= copy) == 0)
+		len -= copy
+		if ((len) == 0)
 			return 0;
 	}
 
@@ -439,7 +440,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 		WARN_ON(start > offset + len);
 
 		end = start + skb_frag_size(frag);
-		if ((copy = end - offset) > 0) {
+		copy = end - offset
+		if ((copy) > 0) {
 			struct page *page = skb_frag_page(frag);
 			u8 *vaddr = kmap(page);
 
@@ -452,7 +454,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 			offset += n;
 			if (n != copy)
 				goto short_copy;
-			if (!(len -= copy))
+			len -= copy
+			if (!(len))
 				return 0;
 		}
 		start = end;
@@ -464,13 +467,15 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 		WARN_ON(start > offset + len);
 
 		end = start + frag_iter->len;
-		if ((copy = end - offset) > 0) {
+		copy = end - offset;
+		if ((copy) > 0) {
 			if (copy > len)
 				copy = len;
 			if (__skb_datagram_iter(frag_iter, offset - start,
 						to, copy, fault_short, cb, data))
 				goto fault;
-			if ((len -= copy) == 0)
+			len -= copy
+			if ((len) == 0)
 				return 0;
 			offset += copy;
 		}
@@ -558,7 +563,8 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 			copy = len;
 		if (copy_from_iter(skb->data + offset, copy, from) != copy)
 			goto fault;
-		if ((len -= copy) == 0)
+		len -= copy;
+		if ((len) == 0)
 			return 0;
 		offset += copy;
 	}
@@ -571,7 +577,8 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 		WARN_ON(start > offset + len);
 
 		end = start + skb_frag_size(frag);
-		if ((copy = end - offset) > 0) {
+		copy = end - offset;
+		if ((copy) > 0) {
 			size_t copied;
 
 			if (copy > len)
@@ -581,8 +588,8 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 					  copy, from);
 			if (copied != copy)
 				goto fault;
-
-			if (!(len -= copy))
+			len -= copy
+			if (!(len))
 				return 0;
 			offset += copy;
 		}
@@ -595,14 +602,16 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 		WARN_ON(start > offset + len);
 
 		end = start + frag_iter->len;
-		if ((copy = end - offset) > 0) {
+		copy = end - offset;
+		if ((copy) > 0) {
 			if (copy > len)
 				copy = len;
 			if (skb_copy_datagram_from_iter(frag_iter,
 							offset - start,
 							from, copy))
 				goto fault;
-			if ((len -= copy) == 0)
+			len -= copy;
+			if ((len) == 0)
 				return 0;
 			offset += copy;
 		}
-- 
2.17.1

