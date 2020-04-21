Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291781B213D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgDUIPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgDUIPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:15:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECE2C061A0F;
        Tue, 21 Apr 2020 01:15:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y25so6284994pfn.5;
        Tue, 21 Apr 2020 01:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WrK5RDoX+ITS5jlanPN4W/vCSCVtaPWzKdj2s4nN0ho=;
        b=D2i7tbj3BJWJR2VD/nZjbnjbB5PA4de2EK+UTsGT84gbRv3ruxoUojCrV7iZLxTZVf
         TKZNHUP3RHuFNeILfHW/4CmNgAxjvVe+hFzNy556VIMrgWpqwKPPouOSwoq/2/VR2FdG
         YhFIX8CN+tKfhU8mftdG2kGn5NvmvoyYgi/Sqkv3WsPPkq37g/Z3eUejLMAppcLnF8XG
         leSIOtIHniHgd2VIJInm0mviLiwbLJgVeRZTMb8LX+XTaitS0g1PBbYVS1s95ngZLGJT
         YaEzEnl/4+zV+MrzDYHHzpwnXgpXTdiKfnTA8IErmP9HVH/9pzch8FEk8FtK3k4Eizim
         qwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WrK5RDoX+ITS5jlanPN4W/vCSCVtaPWzKdj2s4nN0ho=;
        b=Vj8K1BVV6no+uHAhpElbgxcvbeR3mUwCcB8nsWvzp3U/Izf4+8fe9QQeAo5guWtNla
         1Cuc1g9ow5d8oeXhoXcmANyOwhGVJSfK2UboKhVCnExt5KrVXI9PQ5atO3LqxoUk5+yO
         yElb9nxOJpJIPiySn6Q0vOGkG7pwonkzoBh/IdL3E3EXtFk8YfK4wyrfw/V/FsGbAO8/
         GPUj8PmFjewYvrtu4DKq3xKe9uihNmolw/xTg19U9GxHNhNNYxmGnGP5i/blrrMGHdpJ
         N0A8uSrYemrjKWrwUMLlomwx9T6Bu6Yn6m6ObJ3pW5CiK9aWDaXXBiCR8QWga0p31MSc
         VGNA==
X-Gm-Message-State: AGi0PuYatED161O6aS+G1nFWhdEMdVC3y964P5tkJTKbtzQOB+cGPd82
        g4wNlWJaRDZTJzpM8VReXke/HBP15nA=
X-Google-Smtp-Source: APiQypJnOxmujskatWfve2JobXmI+b2FIYwEk5/pCzcNvD+ScmA05B7k1/kU0T3pZmJsKe+1p43H6Q==
X-Received: by 2002:aa7:85c2:: with SMTP id z2mr19853810pfn.25.1587456953747;
        Tue, 21 Apr 2020 01:15:53 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id m4sm1733803pfm.26.2020.04.21.01.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:15:53 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] do not typedef socklen_t on Android
Date:   Tue, 21 Apr 2020 01:15:49 -0700
Message-Id: <20200421081549.108375-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is present in bionic header files regardless of compiler
being used (likely clang)

Test: builds
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 libiptc/libip4tc.c | 2 +-
 libiptc/libip6tc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index 55540638..08147055 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -22,7 +22,7 @@
 #define inline
 #endif
 
-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if !defined(__ANDROID__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))
 typedef unsigned int socklen_t;
 #endif
 
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index b7dd1e33..91676c4a 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -23,7 +23,7 @@
 #define inline
 #endif
 
-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if !defined(__ANDROID__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))
 typedef unsigned int socklen_t;
 #endif
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

