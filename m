Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3E14885F0
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiAHUqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiAHUqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1807CC06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:54 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z3so8655760plg.8
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dcd0/g4UbnpmQf2lYWpQMozVkbYSJ8CoZkn58HCH4Ik=;
        b=mfpBL//YSgiacw4Dg7ggdjtgaZC9nKSLowcdk+KvtraqZBNp/YYVn5wvwqysC6VGb5
         LqOliCousG0m2GuknH8Lx6sa4p3OwjQVpptuzuCEYLgUo7xrIUibU1smBJxSvUpDcdFT
         ZkuDmjVGUJqafmg26km99YhnrBc1/CFtxmnN+ZM6ESdA8CZqItx/vO/VXbsrz9UiBDdT
         BZclPOUgjcWvNI0i28gTo0fRwWpe5Fk/UI8gPERDJLJQoArnavefrbWs23Rm1xbweIuN
         PE4kWHcDXyw1+nLz6ivYynWn3Va2AUk0Y6tCFzqetHdYRWepPzxFhRMJdboN6IHwdzh4
         uP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dcd0/g4UbnpmQf2lYWpQMozVkbYSJ8CoZkn58HCH4Ik=;
        b=bfmq1aS40Iz49z64fnfWlQaShpXZrTlI5bIv1KF87xfSMNAiJlE11RxiTGP+TkI8yC
         otwwVEaM9/okLGti/AYKUQOwYEtenAbwOJYTRL6ODsiV1tQjzgGn06BgCMd8irRpslPK
         ARyasjHhYwSZ8KkyOXjQsXZxTnEuV7Z2qS29/kkYyxf3Qb7UJjeZcBNkG6cbzakU8P/0
         j8w3grgQfX8LIvc7zSl2TfxOmmwRjHq+Qt8F10IJNuw1qyHfK3HnkoWiMcMykszuGc/x
         ZYW3I7zsU9ASH5QWfXlnzICJQmJUjJwEp1y7NVnqVYGPuAEqW1EGdrvHfJbLoa81o/6Y
         gLjw==
X-Gm-Message-State: AOAM530O5661g7KhAkSUB1moEaDAioat08YSfphMaBr/smSmlXH1cPS3
        o4RH0Bth5zfNNN4Xs119A8CbNWboh0G3/A==
X-Google-Smtp-Source: ABdhPJzjPxy6FknhEPngXVP9FEFBGPA+74tCQZkjxsGUoDd3sPSLCtbxr+srU6ecPR7m4xLUH6wV3g==
X-Received: by 2002:a17:90a:4fa5:: with SMTP id q34mr3157890pjh.101.1641674813368;
        Sat, 08 Jan 2022 12:46:53 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:52 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 01/11] tc: add format attribute to tc_print_rate
Date:   Sat,  8 Jan 2022 12:46:40 -0800
Message-Id: <20220108204650.36185-2-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

This catches future errors and silences warning from Clang.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 48065897cee7..6d5eb754831a 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -247,7 +247,8 @@ int get_percent_rate64(__u64 *rate, const char *str, const char *dev)
 	return get_rate64(rate, r_str);
 }
 
-void tc_print_rate(enum output_type t, const char *key, const char *fmt,
+void __attribute__((format(printf, 3, 0)))
+tc_print_rate(enum output_type t, const char *key, const char *fmt,
 		   unsigned long long rate)
 {
 	print_rate(use_iec, t, key, fmt, rate);
-- 
2.30.2

