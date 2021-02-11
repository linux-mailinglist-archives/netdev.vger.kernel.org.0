Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B07318897
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhBKKtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhBKKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:46:33 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61540C0613D6
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:27 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id i8so9311935ejc.7
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a9d0mkerRNl4TBDpLP0t7ZBBEkZC40UZpwzZPwQ0FXE=;
        b=oD9aeOs8h7tP/ZFVTMLBNLHCl5G/TfopWWM5PXJKXCz4taoSXBiEF5D6BytNIhhWmV
         CAxcK+ulT22vxFQJQ62kRBvzlzNi/ZFQsb3wuGOz7jhtnQneMuhENKfv2H7SPWJs0opc
         MwgrJEbhKcPXItaKjZW0BF1zqTrDh6y04z7Zy8nQkX/2u0/nlt2vrGkjCSn3ubuG3E8H
         18cdjefuwpEiK+PYO8qq9VcuKjk4sOZtBXugKjXUQPws6ocMbOtkxnazL3HI+CXmD+Zv
         kq+JGgBFZSxUHy6OqA6at3apwhGGU8ifQmOkLNhWkdltc+Q5bAmqXj0ed69ppEld0BAE
         mCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a9d0mkerRNl4TBDpLP0t7ZBBEkZC40UZpwzZPwQ0FXE=;
        b=LoeSh9h14py2K+Uk0pQo4/cvPAzT7q95nYUaLsJswjHplItOQJg7HjNIhv00KOwgwb
         lMLj9mTJWuFAdE7SBL51aNcr6y76kB4vHDjj6sfClQsGrASryBTbg1EB4QEAdcFmrQMh
         RtuSb12SwZDZFf9Q++CpppPoUWKfzucP72svZMLdLX5M+naJv5qI0/Q4GC2FqI1T5B+f
         yZm+JHAE1tSV5oRmox6i12ucxbGvoxWWwsC2hrx2hqGtT5xxBRRJAoywuz8trFxBijdp
         EbtQY3w3SrBSsGdVJAH/aAesGEAXMHixqWtAfm42Np/LQGLQ2bSJmGht4TUTYvqnY6JE
         jSKQ==
X-Gm-Message-State: AOAM532h9SC+5sXI5I8+6/CJdKDC2BjrjA+IK59Dz0DDBYw7/GDxVvbT
        LUPk4Fl6FAQy3sHudIpxLC8=
X-Google-Smtp-Source: ABdhPJyKw9xS62VlMyNQUiaYr2PfjjMouA5zUQF3Ge7hC3Gmpa926BCAzmpaIHnqW3ciFm8mHHbJ1A==
X-Received: by 2002:a17:906:16d0:: with SMTP id t16mr7601347ejd.259.1613040326044;
        Thu, 11 Feb 2021 02:45:26 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l1sm3815458eje.12.2021.02.11.02.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:45:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/6] man8/bridge.8: document the "permanent" flag for "bridge fdb add"
Date:   Thu, 11 Feb 2021 12:44:57 +0200
Message-Id: <20210211104502.2081443-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211104502.2081443-1-olteanv@gmail.com>
References: <20210211104502.2081443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge program parses "local" and "permanent" in just the same way,
so it makes sense to tell that to users:

fdb_modify:
		} else if (matches(*argv, "local") == 0 ||
			   matches(*argv, "permanent") == 0) {
			req.ndm.ndm_state |= NUD_PERMANENT;

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/bridge.8 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index b3414ae31faf..12c09a56563d 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -517,6 +517,10 @@ the interface to which this address is associated.
 - is a local permanent fdb entry
 .sp
 
+.B permanent
+- this is a synonym for "local"
+.sp
+
 .B static
 - is a static (no arp) fdb entry
 .sp
-- 
2.25.1

