Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2C52078F4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404535AbgFXQVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404400AbgFXQVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:21:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37CC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:21:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so2875145wru.6
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Fvj72AwyNRijbUmM6vK9FeQy4FWH7FwLcIjZ8sxmU+Q=;
        b=KO48xqk0ky9oTXdWuMGD/7R4v07ZS/1rfIz3HdlFkfVqIybuD5SbuOmyYxZ/dzjoaA
         6PgP5SdHQ+bajFd3q8YoPSJA6ElSZfLEDC5b89ZxbDdii/SYOhpErgqn5UAb88hO0GeW
         3KiE2rpGVwGJc+4LHUfJZhObg6EQZcpHc3QCsgQ9roBKCeOLCau/fdP+s96Ldb+4C22P
         2cif9N58dBhHwdXMCOMXsIifljmp4PrSouGnYAp40zDS6+7R9o/ggqH5DOXrGvnPY76w
         cc34GQnisNU4YsJVd9ptqjS8ZP46i20iwKct8PNiq98qJcIdbmQzFDMOw3mRfzJixlTe
         x3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Fvj72AwyNRijbUmM6vK9FeQy4FWH7FwLcIjZ8sxmU+Q=;
        b=AliiXTbFK71zeKcoZV+6+kAZBiuH3Ay/ng9g+rTlGm8wjfQqVbWfOjxjjl9Pl9GmXK
         sMLU6z97L1wO0DP9JY/9B6nQCkA9RqWZLnwkevGXIi8cx0X9EUhNx/bGxVaMbxrSbaHF
         pr1PiK0106lBW2wQC3QrRDakJVM6Jt7DTefCW1pNCg8sLuWazxqxeVNgaFd7nNgHY8ln
         Bd7v4wfvWWgbbthPTDDNy0XT/wut7pApvJM2kGghr10Q4/9/gGfseKgpG6hLLrOpGFmW
         2p/4lFFRmcqBsK3iKNe3Q6mx6T76v5RZ4BELgz/xi8GmTwHIU1fH0Icf8Xj1n/ZscoX9
         pNaw==
X-Gm-Message-State: AOAM5329yqljOqPb3rXmi2lPYeEJd2DcYD/ipc1R8F0Vxy2CGYsTCSe3
        9g+c/w8tHxPpRz0bhaKwaXthoJE4+RLRqQ==
X-Google-Smtp-Source: ABdhPJw0LSjGzqztmBngCKCPdzk1VpteXxdZ9Gx7bU9Uuree692grjA7kB5l+BpsLx30N1UQIND3lw==
X-Received: by 2002:adf:916a:: with SMTP id j97mr12426515wrj.231.1593015693391;
        Wed, 24 Jun 2020 09:21:33 -0700 (PDT)
Received: from localhost.localdomain (82-64-167-122.subs.proxad.net. [82.64.167.122])
        by smtp.gmail.com with ESMTPSA id u186sm9037328wmu.10.2020.06.24.09.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:21:32 -0700 (PDT)
From:   Alexandre Cassen <acassen@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        quentin@armitage.org.uk
Subject: [PATCH iproute2-next] add support to keepalived rtm_protocol
Date:   Wed, 24 Jun 2020 18:21:25 +0200
Message-Id: <20200624162125.1017-1-acassen@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following inclusion in net-next, extend rtnl_rtprot_tab and rt_protos
to support Keepalived.

Signed-off-by: Alexandre Cassen <acassen@gmail.com>
---
 etc/iproute2/rt_protos |  3 ++-
 lib/rt_names.c         | 43 +++++++++++++++++++++---------------------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/etc/iproute2/rt_protos b/etc/iproute2/rt_protos
index b3a0ec8f..7cafddc1 100644
--- a/etc/iproute2/rt_protos
+++ b/etc/iproute2/rt_protos
@@ -14,7 +14,8 @@
 13	dnrouted
 14	xorp
 15	ntk
-16      dhcp
+16	dhcp
+18	keepalived
 42	babel
 186	bgp
 187	isis
diff --git a/lib/rt_names.c b/lib/rt_names.c
index 41cccfb8..c40d2e77 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -120,27 +120,28 @@ static void rtnl_tab_initialize(const char *file, char **tab, int size)
 }
 
 static char *rtnl_rtprot_tab[256] = {
-	[RTPROT_UNSPEC]   = "unspec",
-	[RTPROT_REDIRECT] = "redirect",
-	[RTPROT_KERNEL]	  = "kernel",
-	[RTPROT_BOOT]	  = "boot",
-	[RTPROT_STATIC]	  = "static",
-
-	[RTPROT_GATED]	  = "gated",
-	[RTPROT_RA]	  = "ra",
-	[RTPROT_MRT]	  = "mrt",
-	[RTPROT_ZEBRA]	  = "zebra",
-	[RTPROT_BIRD]	  = "bird",
-	[RTPROT_BABEL]	  = "babel",
-	[RTPROT_DNROUTED] = "dnrouted",
-	[RTPROT_XORP]	  = "xorp",
-	[RTPROT_NTK]	  = "ntk",
-	[RTPROT_DHCP]	  = "dhcp",
-	[RTPROT_BGP]	  = "bgp",
-	[RTPROT_ISIS]	  = "isis",
-	[RTPROT_OSPF]	  = "ospf",
-	[RTPROT_RIP]	  = "rip",
-	[RTPROT_EIGRP]	  = "eigrp",
+	[RTPROT_UNSPEC]	    = "unspec",
+	[RTPROT_REDIRECT]   = "redirect",
+	[RTPROT_KERNEL]	    = "kernel",
+	[RTPROT_BOOT]	    = "boot",
+	[RTPROT_STATIC]	    = "static",
+
+	[RTPROT_GATED]	    = "gated",
+	[RTPROT_RA]	    = "ra",
+	[RTPROT_MRT]	    = "mrt",
+	[RTPROT_ZEBRA]	    = "zebra",
+	[RTPROT_BIRD]	    = "bird",
+	[RTPROT_BABEL]	    = "babel",
+	[RTPROT_DNROUTED]   = "dnrouted",
+	[RTPROT_XORP]	    = "xorp",
+	[RTPROT_NTK]	    = "ntk",
+	[RTPROT_DHCP]	    = "dhcp",
+	[RTPROT_KEEPALIVED] = "keepalived",
+	[RTPROT_BGP]	    = "bgp",
+	[RTPROT_ISIS]	    = "isis",
+	[RTPROT_OSPF]	    = "ospf",
+	[RTPROT_RIP]	    = "rip",
+	[RTPROT_EIGRP]	    = "eigrp",
 };
 
 
-- 
2.17.1

