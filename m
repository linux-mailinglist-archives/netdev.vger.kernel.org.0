Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D24E490FED
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbiAQRuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiAQRuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:32 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599D6C06173E
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:32 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q75so3821614pgq.5
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+3obGd755fkb4WLBRvKFVMCj+KdKngjztSAqkM6Xwmk=;
        b=YifXfObLp8mELHTj52CRs6o3kcWukAQ65Z5U6JH2G4pIffuoojBHhAAxAKhgOirqE5
         o881PVgenWNKxJvzkB/6UhPkj9ISEC8chx9XHrz4AMLt8MCo1b03UjJBAisg8OwONYHy
         UWQcGH2QoPjnproplAm99O9svxSUGP+COp244R2WvS0QIDyT8h6OqE0LPbiY/0UqVfKT
         VSA6/LHltyBlmTkcCgjgazwH/vc2qdrvqGvNyB7nJOgfGL0aOaoH0lKMHHVQi8nZH86D
         EqFmBCXm/RrlpNGI9RzqBjyyDfVUwAzfMkHAOH6ZgADRHqywszrjj2wCWx04dAJaRL/x
         5RLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+3obGd755fkb4WLBRvKFVMCj+KdKngjztSAqkM6Xwmk=;
        b=JQsVy9BsfL47hCkoP35Ghv/IiVYLwBZVUfQ5E7FAahEW2F1tC2A62pYRhrL+/hyU5W
         u9Cr67RjKM+1ZGgwh7czxLvarmDh1/u2MzSfxfZQ9Ca/xICSYDM+W9ygjhJGFQwwpUA3
         Bg66TUcdjb/+NB4YIHWvAoFz0BISjXU8Krpcr/BAgLabvtiBOznvNWuzy7+L54g3YqbC
         nLZth2cdclZr8MQDElvTPJvG531UVMG8P2Lv/NTH0tj9i50CF1GlYQB7msfG1goVgwGM
         JMphDkdZ9eYXpwn4ELGOTmFR81Iu85iUsdURvGhwZ/8fEmkFwiFZjYuLgTdWWsG9X69n
         XChg==
X-Gm-Message-State: AOAM530z0/nq8iOrVbHCjQpHbpzyoesBxPL8evyLVRcZFuy7r1xx7HKc
        qI8qPztsEl/UXNXhyHhJ+sYVONUh8TROmQ==
X-Google-Smtp-Source: ABdhPJwqf3+qmdJJvOwI43UOIf/C9ZTjCNb46EPgx3o1mI0iNqRodK9sGp7L7zyCeaIaWzibOtAFzA==
X-Received: by 2002:aa7:8394:0:b0:4be:ab79:fcfa with SMTP id u20-20020aa78394000000b004beab79fcfamr22157065pfm.3.1642441831551;
        Mon, 17 Jan 2022 09:50:31 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:30 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 10/11] libbpf: fix clang warning about format non-literal
Date:   Mon, 17 Jan 2022 09:50:18 -0800
Message-Id: <20220117175019.13993-11-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
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

