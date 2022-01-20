Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132094955D9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377791AbiATVMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377784AbiATVMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:07 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C82FC061746
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:07 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i65so6732253pfc.9
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+3obGd755fkb4WLBRvKFVMCj+KdKngjztSAqkM6Xwmk=;
        b=UmDHmzTf4buu0zHDjBqOqbiRurotKOAM19rOkybKy9KjlGV+0a4ctZa2nd0uhLzAG6
         WG7WuxKImpfah9OM/zv+XH2AfeYUshojhOFl6X6JdIbIJ9+24729YwbzgXAivFR2Yr0c
         +sU6eDBA0aV69xFSD/rRD9Pk/+etNzO7bc+XHp98OzEpAnBZtddKAyk4rkiSQQWafx8E
         5ZXLxR79AdvCmy19LlXCfZ1T34CD0kT3oMHPfzfrWNVrZ7JiFTTbFyNrBynTSe13fuG8
         sApVuHNkdIWDqTPNtGvxp3Go6W5YXAVeocQEqJ00M7Gssmu+8B426UVUgjtc5Y1VPhAu
         zpRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+3obGd755fkb4WLBRvKFVMCj+KdKngjztSAqkM6Xwmk=;
        b=3pluOvRins1hJVlMaWY8E8vShm7Y+XcPVRBDzlmiTr2klPlx05VcILye7uvpCaQvIo
         RawIhmW+SiirhYkZuP7lefph+7qaUCbQ0xxJ+4lM9NUjnJfvAo3YyaA/8iDZnsqQcHSR
         hiD0KUxOvzqX4JQk6f5sZ+y0oeNARmO/nSIMqaPW5+nGUv2Vu99WhS/61jN5cFf7f6y7
         8KIhAXF8jmoSgB9bJzsupupmS67uEUymfO0C67VILV2scxlr71P2WBSAA6b8htV9xZ/q
         7c1GFl3PjFyjBNqo9GkvV+aESAYkNwuLA1XzwloGmNqivisVp0FHKIma3ema0+bonGor
         d7KQ==
X-Gm-Message-State: AOAM5318Pj7unJ1q3Pmcd8Y2ji+kPPFprYTS3XpdaN/rXBF6/EfHb5VL
        YJ5AyZ0cs+twr6rhQ7p/EgqD2hEmOc3m6A==
X-Google-Smtp-Source: ABdhPJwz6BnW24bEFqa2HMDtuzWkt4j/XKsLtQOl6RI5JZuMk+qX2ouqSLQe8wBxvcuFgtQ3a5oqtA==
X-Received: by 2002:a63:91c4:: with SMTP id l187mr228600pge.513.1642713126470;
        Thu, 20 Jan 2022 13:12:06 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:12:06 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 10/11] libbpf: fix clang warning about format non-literal
Date:   Thu, 20 Jan 2022 13:11:52 -0800
Message-Id: <20220120211153.189476-11-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add format attribute to the format string in print routines.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 lib/bpf_libbpf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index 50ef16bd4612..921716aec8c6 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -23,12 +23,14 @@
 
 #include "bpf_util.h"
 
-static int verbose_print(enum libbpf_print_level level, const char *format, va_list args)
+static int __attribute__((format(printf, 2, 0)))
+verbose_print(enum libbpf_print_level level, const char *format, va_list args)
 {
 	return vfprintf(stderr, format, args);
 }
 
-static int silent_print(enum libbpf_print_level level, const char *format, va_list args)
+static int __attribute__((format(printf, 2, 0)))
+silent_print(enum libbpf_print_level level, const char *format, va_list args)
 {
 	if (level > LIBBPF_WARN)
 		return 0;
-- 
2.30.2

