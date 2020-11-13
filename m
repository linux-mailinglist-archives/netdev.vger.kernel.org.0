Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728232B27AD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKMWD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgKMV7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 16:59:48 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5888FC061A04
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:47 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id s2so5186840plr.9
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IN7rpw9q0JUsF9aEcFszlZaNaJxBWQen+ZVeNEucJp4=;
        b=PYPvz+qxL9VXB2q6SV/oUk/lYCCzrXiQ9z6bkpcIF2tPmxcCJivXiYjViNikMh1Fvw
         lYGoii2qZEI0Ec7e1Iu1NYK9CcwgkMxkKNTQuGRFhtcUNWY1SWitMKlKAFjm1O/ikAH/
         61+iHgCGdoMjoFVbUxr/7HelUqnCgoWmMgFW1uUqkyn9b/HnVIEvw6SFNsuuo752JCxc
         E7xFlh/MKh28VVYL5qC07TYSu1h+DN3yiUPbd5YojwKUKEVM/aizelk2OOZz7HVvJmiF
         QXXgnZknycfzFcYKshBDnrVWc5vDa9i7OwwRZxp38P1Ad/soChF1YTyOw+wJARJRvtZc
         91pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IN7rpw9q0JUsF9aEcFszlZaNaJxBWQen+ZVeNEucJp4=;
        b=NQeXGhNZzWmJj7E9ZGqu3OruaHIjfoaYnlIdBSR6DzIyq1Kx9+QzT+4qJkmSoo4P/Q
         xxOqyZpLHMoyRHO2MG0ZvVjBNrhBOkNvrKLAcf81UHyKPP1dTLpAMsiZtde8JeL8sSgS
         0QugVKMdhdIlUy6WXxxqtPrkntttX5t+z0g8Enw2PFh7SWE1D4s6EfL/JNHYLbhZwspi
         V07g+KhElAir1e12YaygI8skAzPdCtXvmLZ+UuxDapILRgnrN2s1WyhCQVzNLmQGWzmI
         oaHpBfpybKsilB9xavzHiAM5QqE1/JXaNATFkFYJUA3OT+EtHtKCgGHVOHC14jkcx8Fs
         4kPQ==
X-Gm-Message-State: AOAM5338n0SIVXRBrLn3/4Gn9qIQwcc9XceK1WaAFURVAo82S2yP4/Dg
        jbHyUl87qXIxsxJKaS1Vej1+R7fFGwt6W1kQ
X-Google-Smtp-Source: ABdhPJyq++1yLpKRTvv6AbIjqcuhvQDAJPl4CUFkpHmV+QRnTrOrchki2QNC54GuUKnAXfLpu4NP7g==
X-Received: by 2002:a17:902:70cc:b029:d7:e8ad:26d4 with SMTP id l12-20020a17090270ccb02900d7e8ad26d4mr3854819plt.33.1605304787020;
        Fri, 13 Nov 2020 13:59:47 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id a25sm10754186pfg.138.2020.11.13.13.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 13:59:46 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] ICMPv6: define probe message types
Date:   Fri, 13 Nov 2020 13:59:45 -0800
Message-Id: <55eb7b376f03af953f79810794c6349632189eae.1605303918.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
References: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The types of ICMPv6 Extended Echo Request and ICMPv6 Extended Echo Reply
messages are defined by sections 2 adn 3 of RFC8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmpv6.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index c1661febc2dc..183a8b3feb92 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -139,6 +139,12 @@ struct icmp6hdr {
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

