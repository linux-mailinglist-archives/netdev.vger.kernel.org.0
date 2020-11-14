Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3942B30D3
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgKNU41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNU41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 15:56:27 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A82C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:27 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id ie6so1972701pjb.0
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zuduy78hiRWXj0Su7y2s/YY1V2NM9LU2XpQjYtX5aeU=;
        b=gZTImP1CdoZTuxxMutA1yYx82h21Y3B9XGBx/92btA3O8ky2mlWM0sY0effYevenm1
         qKb6QnyT0EG6lhA6BNRsppnewvgf81d2aCbTWQSxb/ZURlKMljUp70wgQJWjFTrL8QnS
         ryh8qguLlNdauqBhGJCL9YuJn4/oqHsmnGTOnaDANRk1z/54DWBvWdGZvHOM3+yGM1Zl
         HVgNwKwzf41nAELw5jWT21wgXles46hY29LVL8EIcE1v4+UnUid2q1UVV3MOBP8v6svZ
         bNy+KL9aLlB3Nf3eeSDIY7jYo96fdyr9eOC3LuGQLRxxAtDwCyjISzYDmEFzAO4+2UR0
         cc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zuduy78hiRWXj0Su7y2s/YY1V2NM9LU2XpQjYtX5aeU=;
        b=tyW3V8nonRdAUu9GJUIJaZ2HmuwvNSNzOwI+k4wJnj7qG4kfRb5ymsVt2q7Dlhc8dg
         4Jiw00eASIqNnGHPOH9CGucWJ3jnB2kIajAFa9stEcxzanE3XLbClmVY50kAUz7v5VNw
         OFYEW0vPjVTeoc3HufDhXCNLsMpUojUUMxASj3gNiHdf/4PDmwE/gjBBR4zQLmPu+GSq
         u3h/ZcBDI9bK8IFOpxqXQmmAphxo9s/b/5Kc4ur3oEp88g18S5u4oMu9CsEG3DECeoPs
         EUFTzGsSs1WZDDTYzcQLdUBO0MKipLQOFZ57R2zZlw7Rwou1oOs3Ductn9EqC2LlH9vH
         WpwQ==
X-Gm-Message-State: AOAM532puefJVjYNOHbNAmCefbqHVDG/XoFdtYDW4cuRYnFdb0MVOtfG
        2ekspWQKMJz6qlsXlmK9Jvk=
X-Google-Smtp-Source: ABdhPJxBAEER2z3qtg0rAN7gMg9UpVYxkZz5Aw7XZKKcySPbg72k3ayzm3EEXWzmMusKGQZaxgih+A==
X-Received: by 2002:a17:90a:fa04:: with SMTP id cm4mr1785949pjb.24.1605387386788;
        Sat, 14 Nov 2020 12:56:26 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id l133sm13810394pfd.112.2020.11.14.12.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 12:56:26 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 3/3] ICMPv6: define PROBE message types
Date:   Sat, 14 Nov 2020 12:56:25 -0800
Message-Id: <79daad5387301cc857b42ff402b6e7e0975edc9c.1605386600.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
References: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
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

