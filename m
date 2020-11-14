Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4852B30D2
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgKNU4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNU4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 15:56:20 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7873BC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:20 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id g11so6177468pll.13
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iy7ZczZosogZSJ4PXGNHEnI67HVWBlDpsF2Jd/VrDh0=;
        b=qeUrBTT0YHeBq83SWRC7Yer21IGc1/OSPeQArdJASa6wfu+qjICDBb8MkW5H7edbM5
         Xl9a27FjNRohDPD6tHvI+WvuMtrP+4UnseBHwAbseNT8F/4RpQfWiBxyZ6jQwHQMnEDF
         LrFt2l32EINVG5kixm5pwSVGGqEJwIEF/q+7sFaYwhvji0LM6WMZ0jCGQEBmMBlmOF5o
         BSjr5iGlj2DZIODVSlNbZb8HTVjo3m9qEjeitMj0CwcOIP64Pw0oTsVlt4i4RsnjldeV
         hO6i5LNb/1evSUq322JFY0YzbGwjiQajkpvg5FzTl6xvr9+pCVGVWMA4KIleZVq+MjHK
         SRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iy7ZczZosogZSJ4PXGNHEnI67HVWBlDpsF2Jd/VrDh0=;
        b=SMysTpv5IM30JHEEQJhVCDyJAyxEaM1ANTK8BgrVDIb6mwvFJKO36Tq6EJ3pd4g6sv
         mbQTWOLta5yi5e1/El4RD6cdsfr0tx0uKS8aR7CRfx1eN9MZF1m1UtNu5pesMSTiVZD5
         y9LOCXlXfvtyx4vvHgC2LkB+ikpst7NOjW66uRCvOsazPl3iQwy0N24HaQu1hHsgkp1+
         +Nr3iAJGAGyqCjVGAHHmiQBOkO5atPGppPFTRnejwEHAa+QuKZnJMSNly5+zVk6ZXy/T
         zc+LgvRI5niCTi2oyWIDw5V2NIiaC/UUcwT0cKPIDq6iCk3Lx3iktdx0ZIoNVi1xY4WP
         66wg==
X-Gm-Message-State: AOAM53222/4ltXzKpiD4PPt7xn0Ww1Jt1/Igxtm2/Dlawpmhhg7mmLMq
        noI6NnGkzdDYGrD4B0Puok8=
X-Google-Smtp-Source: ABdhPJybK2WTp16GOBCt85XDOL4iNqjxISpfjlBLv0y5CiZ2wETy11xTmTfZcpYZrWoPMLvs5hES4w==
X-Received: by 2002:a17:90a:b010:: with SMTP id x16mr6957804pjq.16.1605387380096;
        Sat, 14 Nov 2020 12:56:20 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id x30sm12152317pgc.86.2020.11.14.12.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 12:56:19 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 2/3] icmp: define PROBE message types
Date:   Sat, 14 Nov 2020 12:56:18 -0800
Message-Id: <1c13925fa0c43c03b26ed04403b4262caf580d93.1605386600.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
References: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The types of ICMP Extended Echo Request and ICMP Extended Echo Reply are
defined in sections 2 and 3 of RFC8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Switch to correct base tree

Changes since v2:
 - Switch to net-next tree 67c70b5eb2bf7d0496fcb62d308dc3096bc11553
---
 include/uapi/linux/icmp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..1a84450f667f 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -66,6 +66,9 @@
 #define ICMP_EXC_TTL		0	/* TTL count exceeded		*/
 #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
 
+/* Codes for EXT_ECHO (Probe) */
+#define ICMP_EXT_ECHO		42
+#define ICMP_EXT_ECHOREPLY	43
 
 struct icmphdr {
   __u8		type;
-- 
2.29.2

