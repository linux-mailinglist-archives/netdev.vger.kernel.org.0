Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630514885F7
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiAHUrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiAHUrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:47:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F25C061747
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:47:00 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so17019231pjj.2
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/oE5+nHZ47hf0eq1B8VOPvwAM1+8jomIksNPwOnPNNA=;
        b=i11ZZY/jvBM9E7qTgrqPQruU15VuLtpSdJ5hq8q/Hj+OsjwHNCTUdGKRO7WLEuTdKA
         phZjJVdre07Pre94MQOKo5NMADOnLBJmlHKr/fDEbriizIXlRiulpXuD7GeZJvbzeP6v
         uXlwUeoGtdx2R+0RnYEw9CpwGmeBpmXytR/l+eCLDnGmmZrpm8gavTRlItaVm4au8fiC
         E8mrf0qgYajGZI0ITynWcAVIaZ2vss2hja/A++1LRCKCz/hoOdiE5rbRuZEvaoFHK9Op
         6vbAQH6aI4m59oJ6kmJFppE5II2QExoATnEEefBvMQ9DZW16DUI7asFiE0Y7LY4XjD0E
         sjIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/oE5+nHZ47hf0eq1B8VOPvwAM1+8jomIksNPwOnPNNA=;
        b=6IQEZjZ1XGdD9x7AUvGVnF6XmGLMp4zQtx7o3f+7XSYwc20D8G5ukRtyJZ4gyTXm5w
         D3c4CXtVge6uIp7cZwNmgU7zbmy3UehVmDqXu6VrPb1OOJj9oChknqpVMLVJ2G6DIHhS
         c4BOrOAoUDlZ1bEpF24mCG5OQsS+DRr2lUyBL/+lsJnlEaGTWNDEmAhve2K/jDWGj0ln
         k6nTELJyPw9zlmnQwgUIVI5uTOQJESF2FunRfsqlrBUuTgE/o1g7vibHHI4CAuEcE++s
         oJ+qP+DN1X/ACaBcwpfBr59+eVM9WOdIvPWXUp+/9LZ+HJTYLigtZbOac6XT+sNqeWc6
         Klng==
X-Gm-Message-State: AOAM533CQrSSLVrSg0MCTjX6tejYhJKXhDOrRakQIkY3NRoy/4RGMhrx
        2oLDGtaP6sz2n9sGEs8I/RBCqh0UuEdAKQ==
X-Google-Smtp-Source: ABdhPJxeGH+MSTcxG6DNMDcWG1+wJVy0wYmrNRUk10yMvwJgZS85MxEm0WEBbGdK5hdcowdobptZcQ==
X-Received: by 2002:aa7:8c57:0:b0:4bc:1474:16f with SMTP id e23-20020aa78c57000000b004bc1474016fmr53211354pfd.37.1641674819784;
        Sat, 08 Jan 2022 12:46:59 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:59 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 09/11] can: fix clang warning
Date:   Sat,  8 Jan 2022 12:46:48 -0800
Message-Id: <20220108204650.36185-10-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning about passing non-format string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink_can.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index f4b375280cd7..67c913808083 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -330,8 +330,9 @@ static void can_print_nl_indent(void)
 	print_string(PRINT_FP, NULL, "%s", "\t ");
 }
 
-static void can_print_timing_min_max(const char *json_attr, const char *fp_attr,
-				     int min, int max)
+static void __attribute__((format(printf, 2, 0)))
+can_print_timing_min_max(const char *json_attr, const char *fp_attr,
+			 int min, int max)
 {
 	print_null(PRINT_FP, NULL, fp_attr, NULL);
 	open_json_object(json_attr);
-- 
2.30.2

