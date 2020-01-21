Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1CE143F07
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAUONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54891 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbgAUONX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:23 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so1426144pjb.4
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lLPfkaHUdJk91hEn7ISh5HhzYqtAwjmDshBoNiXJGwM=;
        b=jFX8o9Q/idu//qa1Y7rnAbcYrIfzg5QCxYjfbhoH4+FZOY49OKFDnz70lvOAo9m2Zf
         SCgfg9Il5433FGuGfFHrVNwwocF/4Ub+rWCwZSbPCcy+abODklgr8aacq5fj6HOQhNtv
         QvzX09wB8em+j66y2f6pIT4hDTLkakh/J36an1eIp+0MwJPzygJgLmAMfG1iPErRSG0b
         wGj38fqDwLoWYH5Gg28AHi2gzxXZ6blS0mz/yH9Qx6EU/GfdxCEOrefrqheENqYgDfHY
         4ZhYX/MZD6WjJ0yO4MeI/yvou1jKg9KXOUfOzN1D7FWbV4a1yqwMPnkmKbECzruWe/kU
         Vx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lLPfkaHUdJk91hEn7ISh5HhzYqtAwjmDshBoNiXJGwM=;
        b=du71eCvmERXkjQ+3AB7Qd4vMKbFg2k5twdLkOnb8SyKC6rs4jFgFLYdk/J1cKXPlLj
         r/ZQgn/ZAhuxeno35ls/of1fTLgbl3/elKMr689V5KWMOgMRccdixKyxI0dxtrPd+EKQ
         ffy+ko/g7LXWediZfpKM4Cq33NvCQPPthLWr5kjxAruiPAEmi6GIkI7TvOxfxH/uMZlf
         klkO9sKxEVNmP+HEYH+1F3tMazVS38X8DkktnT0TeIMGmLYW8dzOh4lEGJoK9riY//Ug
         IeajkmJMOKzoN11c64BHa/TSgpaE9ovNahKLucH4twulGu3c37fha83ZEU2Z0EA2EnZ6
         lrCQ==
X-Gm-Message-State: APjAAAWnw3kJ+76BH0bmK36DGMxqg3qqIVMKKge9Egrh2fqkvzpNSvDL
        DS3M0TgTp/ek/JbcX6cFiKaacUTX3fCf2A==
X-Google-Smtp-Source: APXvYqxEiUUZtVf2nHi6612TSYhil1ZhxrqNSayxdV06OARHsasIHF/pq5ihgNnKQ7J0b1d6UIlJhQ==
X-Received: by 2002:a17:90a:2763:: with SMTP id o90mr5438539pje.110.1579616002673;
        Tue, 21 Jan 2020 06:13:22 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:22 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v4 04/10] pie: use u8 instead of bool in pie_vars
Date:   Tue, 21 Jan 2020 19:42:43 +0530
Message-Id: <20200121141250.26989-5-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Linux best practice recommends using u8 for true/false values in
structures.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 397c7abf0879..f9c6a44bdb0c 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -21,8 +21,8 @@ struct pie_params {
 	u32 limit;		/* number of packets that can be enqueued */
 	u32 alpha;		/* alpha and beta are between 0 and 32 */
 	u32 beta;		/* and are used for shift relative to 1 */
-	bool ecn;		/* true if ecn is enabled */
-	bool bytemode;		/* to scale drop early prob based on pkt size */
+	u8 ecn;			/* true if ecn is enabled */
+	u8 bytemode;		/* to scale drop early prob based on pkt size */
 	u8 dq_rate_estimator;	/* to calculate delay using Little's law */
 };
 
-- 
2.17.1

