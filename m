Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A6C2B2AFE
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgKNDYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgKNDYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:24:18 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB306C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:24:18 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id j5so5474050plk.7
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=woxCj4aYOv76RczeGQM14d6wQBOSJs+MuH5i0NJX+Z0=;
        b=q8WeKkXdmJ2REexhrpLjN0Y2yUvxm+pRbetz+N3/GvNOSVFATs1Xhr7MXh9Nq20HtA
         yUuSW5CNY1VlqX9Nx2y0+q9EasuWt5RrMcw4KwumVywgq8XMRcE537zbKm7G0Xsu2pwB
         iz3Wo9stiiO+8Q84yk8DGPKF9oloU1D9DGdBRav81hyhWNlK5T1vck01Hdme7UVNa8Rf
         Ojk6WoTswsR1VWqLn0r+AU5hmYV8Ggmm5gaN//WEJIOqWXk8XdW6aFjkZ0mI/fbvJ5d9
         EUBpmU2Dc9wCySW4BmFjHIi6kPcqiWJlOCGDeKWdsdVpW6+xFZ24hbK4w7M4kPhTvZqU
         WvGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=woxCj4aYOv76RczeGQM14d6wQBOSJs+MuH5i0NJX+Z0=;
        b=KbQqSJV9KuROVLjDLfYiFszET31M+cxX/aL9JiAnEbjLcR53F5/pYhICwKwQpdHUf7
         AoHzNj2KstE14r/2Fdq2nOHI0NbcSlpxESzX8SHGx9HrxxBu3FVI64GT1tir6+FVCywn
         xY2GGUm7FtOjBqOE2W2U+J3cGzDxKbzHCLyq21FF8MCy18/WO/L6cWxqmUtk7/9YXwA3
         vGp+twC5OrtmZICj2xbMc8WfZPoPIZTbcoW8wr17EvkaaAzUGBtamPL6V4909rqtFA3U
         WX4/4m3h4ucDhxpJ8eHSvsIe3zPcow7R7NBy39u2TraK06Og9voqGetMZOgODzIQcNlb
         Bfzw==
X-Gm-Message-State: AOAM533MZ19rIcsNsM1uJycTpwXF6Mtc7CF05hHAf6HOEBDM3/PnfAiI
        sAzqTVWDETXjF/Uee6fmhMI=
X-Google-Smtp-Source: ABdhPJzjy08E2Hh066hScD8HfYDgtWh0+uOeCnGs2fXdla5fUXTNtkygUQIrTQFwvk6rDnHD3UnmmA==
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr6414301pjk.36.1605324258510;
        Fri, 13 Nov 2020 19:24:18 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id k8sm9934442pgi.39.2020.11.13.19.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 19:24:18 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 3/3] ICMPv6: define probe message types
Date:   Fri, 13 Nov 2020 19:24:17 -0800
Message-Id: <03d35bcb7aa843ede4fb3bc224b7eba85c12d522.1605323689.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
References: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
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
---
 include/linux/icmpv6.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index ba45e6bc076..c6186774584 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -137,6 +137,12 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
 #define ICMPV6_UNK_NEXTHDR		1
 #define ICMPV6_UNK_OPTION		2
 
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

