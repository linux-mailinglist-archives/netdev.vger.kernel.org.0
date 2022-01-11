Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3127748B4AC
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344869AbiAKRy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344895AbiAKRyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:54 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3AEC06175B
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:52 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q14so18389854plx.4
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+3obGd755fkb4WLBRvKFVMCj+KdKngjztSAqkM6Xwmk=;
        b=BzjPyT/RQIo7cUjP1ElelxKn4gj4X/NyiyI8TPryvlRB3N9ToRiQdb9X+B/ZOpdTOs
         wXkxTfeIRWxlL1QbwJcca4V6d/7kSBgQh0GvN7liNgOwBfoY+5WGrB+l7AossJRHuvTO
         xP1ZfUswRgn7kvsnGWBbWaXmSh/GTu2TqT75Wtwk71IbGqaJ9NhB4MAOekUMKnnIe35U
         CLp9aFzaEzLz5FJbJlIDpcDBivKfhxleebHpi5CngtEn7Kyn3Y32Bg0VglufmzW6LZi6
         idt1c3cWND4nRPpqCNQzsiC0YEb1D0qigUzCj6fomHIAO8hOtM/D0RW3nTScAboPbtHb
         tURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+3obGd755fkb4WLBRvKFVMCj+KdKngjztSAqkM6Xwmk=;
        b=fnet5LW8LRgZ8hyw7O3P3khf7h2gUCi9apMw6dqJfIb2VEdzuzoP109iCRJh2PtEav
         78KbdszoyWw15+ZxKZvyoIqP/WSNktT9QPV3c9aKbBVwBdk+dzh3Wcq60uJM4IuUxPje
         G8hVdtRlWgfNTHgFAoz2tzOxpPHUeSd3+OHQgLYRcUBb3BO0asAlN7zAZitTWqDQ1fcn
         eDd30AbsaHuwm9tp36zLtuOTOfQor4ZUuC+QAIDy9xKdUQJvr9MhyvlgZZ/fiilLX3re
         gdPwDUwsgTldFO68MRAu1f6hCAkVKWglujX0p+tzwOI1F5+o974nq72jfp0HqGxL3OT9
         NyMw==
X-Gm-Message-State: AOAM533Zr6JIZLHVyhdkZd7putjGwfE0ROtqK9wCZRz3S6gdw/WiTjGV
        vk+deij9eCXMjqf2bv37EVcrRfIEn1nfMQ==
X-Google-Smtp-Source: ABdhPJwWpOhFWiwN/jqk99sSGxXH3nZCHGbPTRE9E4yN+grBjfPtQsiOcyg0T5S8uLQoucfe8iO5jQ==
X-Received: by 2002:a63:7c59:: with SMTP id l25mr5000226pgn.228.1641923691271;
        Tue, 11 Jan 2022 09:54:51 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:50 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 10/11] libbpf: fix clang warning about format non-literal
Date:   Tue, 11 Jan 2022 09:54:37 -0800
Message-Id: <20220111175438.21901-11-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
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

