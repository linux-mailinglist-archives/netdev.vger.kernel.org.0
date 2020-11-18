Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F6F2B735B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgKRArW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKRArV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:47:21 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C29C061A48;
        Tue, 17 Nov 2020 16:47:21 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id oc3so142119pjb.4;
        Tue, 17 Nov 2020 16:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dXRBv5PHzve2HVPaP5kpA6YTo3UMeEjMxAdlm/Mznh8=;
        b=QdP1Lpc/xVXK79Jig01UuC9v1Wo1u8NyVMEA8Ueayqas6eh7BR8syi54nQjhwvzBfr
         yI7bbF+4gDXs4VguPwldcPJVeb0qlqzDUZ1f39nmJzKCx0LBDq6Cxuvhx5wl6XMN/4SB
         7uyAEt4nvMpO2nu39Kw1JaNZlnyDqW5eBRuGUz8zpJS78FwjzpUbbQTeZSdeQ8Lv6kvR
         fr04nkVxt7wIum7AolVM/taHld0/H8JE50r3I2SzNG/4hessmOYtjjwE92+m2Qv3e2sU
         hY7VsBNm4FL6Ke0dLn0HFA7gy+usl6ac1RvcE8bht9BU4X4/1Q+OKMJxQ3MAeCjHQXS0
         Ghjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dXRBv5PHzve2HVPaP5kpA6YTo3UMeEjMxAdlm/Mznh8=;
        b=B/wS/+bxpykfoj9AE974PuaWb2wy8QPo010u4+9qMljFUNYJ1kqbL0LpujlLyK96YZ
         IUuoIcAIaAavhmVmG11f471emleBh9pxofLJr0y4TvVsbqc4kJ8+onVSdfIEl+ntccRp
         gmIb00Y2vBuoRZKK6jP4ZZI7o8q1BMcVEpvMZOSCscOE+O9uRPBeifgaMrk5Veqetbpr
         +niK3CtdcZkTdB2kJzK+3z+rNq7xzvNSK5meaAuMo81K3JR1QVqzuHI1IgqPMs4veP+s
         H1nxdqSquXcJShKXoHxOHgD0qGsL2aCU+vePzO14nRbY/j07ICTEfw5jsIbpSuTFX9yD
         zwMg==
X-Gm-Message-State: AOAM533MxmNJzP3TD2ZaOCOvT7x0Ag6svPj2fDRD2eXJ9qYYPMJCryB8
        XW3UJ1syNsS9UzcoJ2I9ClE=
X-Google-Smtp-Source: ABdhPJwCiLmHyXiPZLS25i7e3K+epfYwguYS/GGL7DtkTcOEeoKoJSlpfY/NfHG8S1CpH5+BiLtANw==
X-Received: by 2002:a17:90a:c914:: with SMTP id v20mr1573190pjt.112.1605660441000;
        Tue, 17 Nov 2020 16:47:21 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id e7sm19688469pgj.19.2020.11.17.16.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 16:47:20 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 2/3] ICMPv6: define PROBE message types
Date:   Tue, 17 Nov 2020 16:47:18 -0800
Message-Id: <a810d633e2fdd0b907ed91d3c5d3d2c7c2dd3564.1605659597.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
References: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The types of ICMPV6 Extended Echo Request and ICMPV6 Extended Echo Reply
are defined in sections 2 and 3 of RFC8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Switch to correct base tree

Changes since v2:
 - Switch to net-next tree 67c70b5eb2bf7d0496fcb62d308dc3096bc11553

Changes since v3:
 - Reorder patches to add defines first
---
 include/uapi/linux/icmpv6.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index 0564fd7ccde4..54dbafdedca1 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -140,6 +140,12 @@ struct icmp6hdr {
 #define ICMPV6_UNK_OPTION		2
 #define ICMPV6_HDR_INCOMP		3
 
+/*
+ *	Codes for EXT_ECHO (Probe)
+ */
+#define ICMPV6_EXT_ECHO_REQUEST		160
+#define ICMPV6_EXT_ECHO_REPLY		161
+
 /*
  *	constants for (set|get)sockopt
  */
-- 
2.29.2

