Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE092C7C16
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgK3AWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgK3AWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:22:34 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DDCC0617A6
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:54 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id s63so9011064pgc.8
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d+CBUwikwpql5D28/Ydzn/tkpCccjAYgynX4fCid50M=;
        b=plkbj/W22smzmlJa5fUkgT54RGF02gbentES9oiGQ44dlffUxV+aQBvQjEdiNdOP+4
         TAcjqzmzQAhrW8FMhzU10Pc8FwPacEq8+odkH7WUrBIJiFWFqClkOzg83BGS3RHhFzPu
         g/sZ3qzttmJM+bpPckrnIUcatjzKcdHNYkc9lfFpGYfZRZo5cprdI1YqjUcN+A11Fwae
         HRlgq9l1id+tJrrx5ZXgnPFVjdFdhuRHjAjte3ieAzAsJDJdIyPj4Fra9LOt9E+Bypec
         5vDjppdWEBZxQXq3uyvI72iN+9SxjaX3P2/6RNi1oayAtNREu8rOhz6t5DznUHDTqZS4
         O8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d+CBUwikwpql5D28/Ydzn/tkpCccjAYgynX4fCid50M=;
        b=P4FRHwLQKEXpK92aernePRbXObHoS4ke+KycejNrO5Oi+mvOeU9hTzZ0GLUSUd2+P2
         KVGAFldvHbG35f7EEVKnRntljMPOumLmzLPRoMkGlixmQ67SokG552JyOyVIW3hgbqyp
         ZlvZ2Xta8rOCG7sWb5l9/bbb1SDboICYc2zpisQs+h+zLC/eHl/9mEx6eBjc1xdvqjOW
         24CvCmqNUq5a3Xb+F9BzIR77yYnFDROHowYjq6GSL0ZT5RNl+hjqJSpQAXF/pRwyJOPh
         gQF9lcqxYN8z4o41QS5OL2gxcU4wJJt23XeZ0opf5gg8iHZpLY7+XX8KTgmthr3VsyBy
         LmlA==
X-Gm-Message-State: AOAM533lWANvs//Q39rPxYk6oH5kafViDT2fq0b+4sH7DbmPWsi3Dq+V
        d0qMJVIG9AssjJ1ssaUDPaag/Gq6+2CrHgzS
X-Google-Smtp-Source: ABdhPJzU3ch2l08S6Q1ii/zd+QeeDFWM7fcS2B9W/mIDk5z6bSdEeE8LC9XWM/A8s2UmqSHqx3tK/g==
X-Received: by 2002:a63:f158:: with SMTP id o24mr1985859pgk.281.1606695713809;
        Sun, 29 Nov 2020 16:21:53 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d3sm20746129pji.26.2020.11.29.16.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 16:21:53 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 4/5] misc: fix compiler warning in ifstat and nstat
Date:   Sun, 29 Nov 2020 16:21:34 -0800
Message-Id: <20201130002135.6537-5-stephen@networkplumber.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130002135.6537-1-stephen@networkplumber.org>
References: <20201130002135.6537-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code here was doing strncpy() in a way that causes gcc 10
warning about possible string overflow. Just use strlcpy() which
will null terminate and bound the string as expected.

This has existed since start of git era so no Fixes tag.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 misc/ifstat.c | 2 +-
 misc/nstat.c  | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/misc/ifstat.c b/misc/ifstat.c
index c05183d79a13..d4a33429dc50 100644
--- a/misc/ifstat.c
+++ b/misc/ifstat.c
@@ -251,7 +251,7 @@ static void load_raw_table(FILE *fp)
 			buf[strlen(buf)-1] = 0;
 			if (info_source[0] && strcmp(info_source, buf+1))
 				source_mismatch = 1;
-			strncpy(info_source, buf+1, sizeof(info_source)-1);
+			strlcpy(info_source, buf+1, sizeof(info_source));
 			continue;
 		}
 		if ((n = malloc(sizeof(*n))) == NULL)
diff --git a/misc/nstat.c b/misc/nstat.c
index 6fdd316cce84..ecdd4ce8266d 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -136,8 +136,7 @@ static void load_good_table(FILE *fp)
 			buf[strlen(buf)-1] = 0;
 			if (info_source[0] && strcmp(info_source, buf+1))
 				source_mismatch = 1;
-			info_source[0] = 0;
-			strncat(info_source, buf+1, sizeof(info_source)-1);
+			strlcpy(info_source, buf + 1, sizeof(info_source));
 			continue;
 		}
 		/* idbuf is as big as buf, so this is safe */
-- 
2.29.2

