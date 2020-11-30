Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A22C7C1B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgK3AXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK3AXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:23:09 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD57CC0617A7
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:56 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id l1so5498481pld.5
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i/b3F1OiqGDBMwbHm3iD7dfFR9hiS2R0OKWSeitmuMk=;
        b=vlIoijCeUukxQ9A7L2qOSEglAx6kuV5A539p8wicOhJWQIY30UQkUHOqgTYFZG53yI
         +Lc2S1USCywTK2kkQLHNIL7gpnUywyWccztjcsUBAeGGRKyYN7Ta5qi/18EEeAjxIJSJ
         FP0UoGInexrL3pc+Hqzxf5vTQyf25lvhwPkZJOckZEczCQX3w+QE2yEA+A9N84SU37Z0
         Iy7kXifztOTugNNSolVXgyEAYF8Y+PtZtru52DpH545vgyC/B2xRkckuWR/F31N3lfrk
         1jEpVZGI4BgTcKalFr/D7f5hdRDL7oo583fs/7NAJbkANXnhayhbKvUUE3wZTSQHVY6B
         x5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i/b3F1OiqGDBMwbHm3iD7dfFR9hiS2R0OKWSeitmuMk=;
        b=siwnD6OWI214Scs9MbEgCOkGmk8Jrm+5Ly/CoLBPJAds2SdV8r9QZhsK0G2ZwZWAaZ
         Uxr2L+kcOYqlyzQ4I545S8pZ/1pSOyKI12QvbLsLvWZv/TRYuMUswssaU9koXCb74XMd
         Bh+3qDM+jABuFJkYlI0S+rSBCu5lydN+0nin1zk3w8XMdziVyUO4mEnmC8W+jbo1fDvE
         oDvfJEaJPIAQlkc4Swd1/cTAWpt4pZUFeTuEqfX+mZcsFqUhQGtwjl/jCl8aJXfBH+/9
         642u99NfAx3HpTTXQ6yxYE6vCKe0rUSkCTwOW3+6/edQaS7hM3MTc+97NtfyTYTn7HIC
         psNA==
X-Gm-Message-State: AOAM5318dV+ewUqRrpg7Hwdq1MghAzWs6Q5v0cwMVDx9hDmu7f+ymObR
        47ACiIz/EXQM5R3VRQQbZ71jujDmn11W4pev
X-Google-Smtp-Source: ABdhPJxAQtQYys2wwJI+5uatLVqomub9iU5xr3PUUzJiWtnxMTUoCEYSBoIatf9denxicfZYlVcmXQ==
X-Received: by 2002:a17:90a:2941:: with SMTP id x1mr22627396pjf.25.1606695715889;
        Sun, 29 Nov 2020 16:21:55 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d3sm20746129pji.26.2020.11.29.16.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 16:21:54 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 5/5] f_u32: fix compiler gcc-10 compiler warning
Date:   Sun, 29 Nov 2020 16:21:35 -0800
Message-Id: <20201130002135.6537-6-stephen@networkplumber.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130002135.6537-1-stephen@networkplumber.org>
References: <20201130002135.6537-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With gcc-10 it complains about array subscript error.

f_u32.c: In function ‘u32_parse_opt’:
f_u32.c:1113:24: warning: array subscript 0 is outside the bounds of an interior zero-length array ‘struct tc_u32_key[0]’ [-Wzero-length-bounds]
 1113 |    hash = sel2.sel.keys[0].val & sel2.sel.keys[0].mask;
      |           ~~~~~~~~~~~~~^~~
In file included from tc_util.h:11,
                 from f_u32.c:26:
../include/uapi/linux/pkt_cls.h:253:20: note: while referencing ‘keys’
  253 |  struct tc_u32_key keys[0];
      |

This is because the keys are actually allocated in the second element
of the parent structure.

Simplest way to address the warning is to assign directly to the keys
in the containing structure.

This has always been in iproute2 (pre-git) so no Fixes.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/f_u32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index e0a322d5a11c..2ed5254a40d5 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -1110,7 +1110,7 @@ static int u32_parse_opt(struct filter_util *qu, char *handle,
 				}
 				NEXT_ARG();
 			}
-			hash = sel2.sel.keys[0].val & sel2.sel.keys[0].mask;
+			hash = sel2.keys[0].val & sel2.keys[0].mask;
 			hash ^= hash >> 16;
 			hash ^= hash >> 8;
 			htid = ((hash % divisor) << 12) | (htid & 0xFFF00000);
-- 
2.29.2

