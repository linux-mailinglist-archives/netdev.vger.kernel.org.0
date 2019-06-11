Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED453D4F6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406731AbfFKSFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:05:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41924 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406685AbfFKSFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:05:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so14059877wrm.8
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 11:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1mgqXIhxVpVrTgZ5BA2dhl7Fczm2z4z9/zB5X/VsZR0=;
        b=cVtP2S67AhDzPwru6qssFki5a6ZHf/9E01sDRMY/pO3gl0xSsefKPaLpkmr1Ozfr5j
         WkDRBWv10yrV9cV8wg06qrIJHC1e0vhwut6Zc2qnb2dpDZ6yy2yYIh3vUg2zHFtqq2ru
         jsQTNVrMMkUCol3u8ttQEVB85EsTaCwZkeodq4crRVnF3H5KLdAt7SFEm797KV/xIKNP
         2WAofLhsihdkHUN32pI3sLkM244+Zti41FHSfRfoGiLYMzqnq2CFulEdkZwgumutE1+6
         L0WF/HhvBp3HiiQIpm4ejLzv6i8TG9gqUd86zIAE1eFoDyAXxzVg7UHAKkCeWjFboI2Q
         902A==
X-Gm-Message-State: APjAAAWwLX/YOQl4qk4tLyFvUSJ4Ra6T9XW/twza5T5zQnM06leGp1zz
        IpiN7KWCFiacCb0guzlBS7XU1cD/8Ik=
X-Google-Smtp-Source: APXvYqy/uN166v8hNnny2SHPR0kO8+mli0UYl9uMhrQZeHr8D0okmDT3Ys6WaVH5rwrgZJ9LVGrVrQ==
X-Received: by 2002:adf:ea12:: with SMTP id q18mr13919005wrm.128.1560276316420;
        Tue, 11 Jun 2019 11:05:16 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id f20sm2907320wmh.22.2019.06.11.11.05.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 11:05:15 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next] Makefile: pass -pipe to the compiler
Date:   Tue, 11 Jun 2019 20:05:13 +0200
Message-Id: <20190611180513.30772-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the -pipe option to GCC, to use pipes instead of temp files.
On a slow AMD G-T40E CPU we get a non negligible 6% improvement
in build time.

real    1m15,111s
user    1m2,521s
sys     0m12,465s

real    1m10,861s
user    1m2,520s
sys     0m12,901s

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 48f469b0..6c35e7c2 100644
--- a/Makefile
+++ b/Makefile
@@ -48,7 +48,7 @@ HOSTCC ?= $(CC)
 DEFINES += -D_GNU_SOURCE
 # Turn on transparent support for LFS
 DEFINES += -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
-CCOPTS = -O2
+CCOPTS = -O2 -pipe
 WFLAGS := -Wall -Wstrict-prototypes  -Wmissing-prototypes
 WFLAGS += -Wmissing-declarations -Wold-style-definition -Wformat=2
 
-- 
2.21.0

