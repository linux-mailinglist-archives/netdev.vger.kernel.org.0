Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE51CC41B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 21:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgEITYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 15:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727938AbgEITYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 15:24:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF20C061A0C;
        Sat,  9 May 2020 12:24:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u22so2141848plq.12;
        Sat, 09 May 2020 12:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M4Oe4Dk3DbCTP15byX+DxLWXqt3IX/iRR8DOHvy9acw=;
        b=KAWPC3grx3ucDT8gr12CGzLegybd5M83xbTzyOBBltPgBQ06eSR/QGhwNtsVzkN4lt
         XgwiH5/LXEHdvIHp30sfIudhLR4i+zQH7oXfc0EW0DzXI42RmsysgMZS/yXPY29NX4zN
         2Y9TgXKoleOvQWuoxq77PcFODf3EmO0527LCLl7DGSNKyG3fl9Qqu2sPEi3g+P69zkMs
         YmX1REQAwt31pu84OWARKwQOxlRXOYmTU16bXpG6VvP7qDY0ZlCqYTGx7qnzZId+ki8K
         nsaSWMwaIMhpzS5y63I5HisN5udJvxHLUqXu6E/fqo2lsbPJAOW08t6Mc0wT/RCgRCdz
         DkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M4Oe4Dk3DbCTP15byX+DxLWXqt3IX/iRR8DOHvy9acw=;
        b=FrSfXdZECUaSUpXehu3UrPpwtv7gV+dc15j33DbLpEZ9Pf5j7SHvXfRtvn7H4u2GpL
         zWbkYPNs52AUGXifJI5zslWkYr+1Zq9vbi0+y/eVdy2dOrkOx4nqFLajE/v0SX4amPEF
         f2VZBBB7wwhpf55yG+8K+OBwhhCe/hJxN7TYtbU8SkOqZyOJalRe9wk/WJ6MaEBPOoWq
         pkSccfATXNZMhFha6pc46WrV7Nf6jANMixft+xJO8EU9ji4njFWS4D7S7eWQkoNOGT3j
         lD1MmGiLplV84o6+QDndxU2u/YoZ0J0jnKJoyQCRKdu3cDyNFEmIy+pon5OkPDXuTlMS
         sjoA==
X-Gm-Message-State: AGi0PuZ4FQiFWydGSLF4haisNW4wQMabqdz0s4mYr/zcKYeKOAQx6crK
        KyDXzopYlGGjxX3lDdyXz0O2SAKy
X-Google-Smtp-Source: APiQypKw0e4lvP2OM4+CmR/F9eKQZEne+8f5j+93fce5nbNvAqx3iWGriIehozf6HYgcQ8WRhgi/ng==
X-Received: by 2002:a17:90a:2e17:: with SMTP id q23mr12104044pjd.43.1589052248288;
        Sat, 09 May 2020 12:24:08 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id g74sm5204415pfb.69.2020.05.09.12.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 12:24:07 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v2] do not typedef socklen_t on Android
Date:   Sat,  9 May 2020 12:23:56 -0700
Message-Id: <20200509192356.164100-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
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
index 55540638..78a896f7 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -22,7 +22,7 @@
 #define inline
 #endif
 
-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if !defined(__BIONIC__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))
 typedef unsigned int socklen_t;
 #endif
 
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index b7dd1e33..06cd6237 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -23,7 +23,7 @@
 #define inline
 #endif
 
-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if !defined(__BIONIC__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))
 typedef unsigned int socklen_t;
 #endif
 
-- 
2.26.2.645.ge9eca65c58-goog

