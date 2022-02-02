Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515984A77DA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346620AbiBBSYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346618AbiBBSYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:24:18 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0622C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 10:24:17 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a19so16179pfx.4
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 10:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TJQk21gs38dXDB+VTkPqjs2ndlqsdX921kBQ0rDx4Fc=;
        b=V5UyAFjKQcvyZSDwefeGK7aOjQ7OT8/7K+Y0ftRgONCcSH0j1edGiS1WserNDDauMi
         n/oWk6EubDuPpmNVMlazj7glqAcltXDgQgyCXcaVeQ+kCU7sSICnSCvl0hXHGJ4H8J+U
         U3mE97XFiE1sNk2nbWEIna56QvkyH2GAQT9zpMVhh2a2prKNdOtDcO2UWWUSbI6T2fUC
         dDY6xPX0DJJSIBjundZl3xOnNe4UXR5x9kC5Ryn8AEgCxwhaElIMpz82P63L8zHchLX/
         A79hwk0WElngdVlLP4ZhNL5bqJ3UGv6Lm1kDs8F37j0LLftJYZN4vY1FCnNralBoTZhS
         Vhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TJQk21gs38dXDB+VTkPqjs2ndlqsdX921kBQ0rDx4Fc=;
        b=dOk5SS2a1q0g/e1ZNtICJ4WdSbJZV4IMOqVmklGylwl4r0k3qOrvgAD0fB1fm2ONng
         edwGQ0kwi6qvdErOQgGgr97cXW8IAWQu//N4bWBBuQpg5qYoK33r7p7x6MWcCngLht9f
         9an1zrT20VZ5KIyQ76iBn/ZcSFinD0gTzFGQ+QewuS6rmVN/+OGQn9fIp7XcLiU7dmsd
         l2xjfGtDbxNc44NnJsV9fzUxlOvGXV/tZV1hkRiJQ0jMIaC+qWPLdOuDxoFv25ThLp+x
         KCmwkkfKY/t6fyig6T3Hmn2BPcVgwD+FzrkbCqlF61PhS2gI1ZJRaMAgWgAqGaeNZn15
         b+Vg==
X-Gm-Message-State: AOAM532pH8Bge7+B115ZIHoXg7kVzszAAPgH8Aav6eko62UbCRPl68v3
        i+b9AwwhIsqwTwKLShR88v4=
X-Google-Smtp-Source: ABdhPJz8y0xVIHbo3OTS3b4j3JFeZ9YATlSNo2dVbL1dlKNll9BQYT2FH7K0pq0GCnhK2IX/rLtP9w==
X-Received: by 2002:a63:8443:: with SMTP id k64mr24894123pgd.516.1643826257430;
        Wed, 02 Feb 2022 10:24:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id q19sm25527474pfn.159.2022.02.02.10.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 10:24:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH iproute2] iplink: add ip-link documentation
Date:   Wed,  2 Feb 2022 10:24:11 -0800
Message-Id: <20220202182411.1839660-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Add documentation for gro_max_size.

Also make clear gso_max_size/gso_max_segs can be set after device creation.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Coco Li <lixiaoyan@google.com>
---
 man/man8/ip-link.8.in | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 19a0c9cab811666a9dce0372a4cb1b19db02d1a5..5f5b835cb2e335b68c4e3ace7bfd40683ae1c67b 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -36,11 +36,14 @@ ip-link \- network device configuration
 .RB "[ " numrxqueues
 .IR QUEUE_COUNT " ]"
 .br
-.BR "[ " gso_max_size
+.RB "[ " gso_max_size
 .IR BYTES " ]"
 .RB "[ " gso_max_segs
 .IR SEGMENTS " ]"
 .br
+.RB "[ " gro_max_size
+.IR BYTES " ]"
+.br
 .BI type " TYPE"
 .RI "[ " ARGS " ]"
 
@@ -83,6 +86,13 @@ ip-link \- network device configuration
 .RB "[ " txqueuelen
 .IR PACKETS " ]"
 .br
+.RB "[ " max_gso_size
+.IR BYTES " ]"
+.RB "[ " max_gso_segs
+.IR SEGMENTS " ]"
+.RB "[ " max_gro_size
+.IR BYTES " ]"
+.br
 .RB "[ " name
 .IR NEWNAME " ]"
 .br
@@ -402,6 +412,11 @@ packet the new device should accept.
 specifies the recommended maximum number of a Generic Segment Offload
 segments the new device should accept.
 
+.TP
+.BI gro_max_size " BYTES "
+specifies the maximum size of a packet built by GRO stack
+on this device.
+
 .TP
 .BI index " IDX "
 specifies the desired index of the new virtual device. The link
-- 
2.35.0.rc2.247.g8bbb082509-goog

