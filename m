Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864BD352E84
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhDBRg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbhDBRgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:36:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DBBC061788
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 10:36:22 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x13so5294840wrs.9
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 10:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0BEtX5LP70nyJG7ya7uvmx8BAaUk54UVHdYb+hbUjBs=;
        b=QzyT0nwPq9hlb8VwH4ggoTbr7mhqKsQiDxFKCItRTgFQpRHrRCC5eIc3RAr3mwHONj
         TWVJdo9T+M+otRaMnL/CAIOHmsi+8JaiYmyCYFF7B1QdNXtKy2N5hOJL5mZcmZBEyIrM
         IdvGPF8LZMPE5GaOpqSGg90+4N/bC6o8qRQ20m0ceN6wr0NszNaeXSqeKJ3+JWcV+qem
         iksvIY+cj9RLrxCEjrl64693mGdouMHEdIqf4EVP7H2d9zpiD730J0VWCG3rEeRu1//R
         vMtkfFQLxdOtzq+jQmOpLmzlW4lH9wJUAK6olOkFwcUpls5JLYLfNujbWPDceoCeS5tH
         FZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0BEtX5LP70nyJG7ya7uvmx8BAaUk54UVHdYb+hbUjBs=;
        b=gzDBylGe/fhWZpBO1XOsQW44RZooq1J6x8aaj5dnuwrwyDTZrkGbMicXn7YFAotR1H
         z59sXujd2j2znocz0qOBaDGf1rGn0zG/HZ0FUkLrWBqS+hS6gXqdo9iRlMv8zN/UHjwf
         h2GMBkyadO+hw78qylnm9Ixtr2tYSZsy47x4L3ZQVakuOKoEnQzZFPZeGO0b9+HG1bq6
         egh08BmXRkZSuFWBW24bo55Reky90OZyh/LRRYvYpmeZ4V8JX9A5Xrv/A1oMYQm4/BKb
         hzjAAKCm19lkUgSTf4S5Hv12l3bSO4xJ9LcM7cw7ee2nSdHk7swpFe+BnwrYkAd5tFfR
         gklA==
X-Gm-Message-State: AOAM532IRnLo5v2PGzUGHsrZf2/BzcPVPy/4t+RHD42R+8/1ao2ivGS+
        AjH5b5PEkF9jA75K3uJ/BF7/hQ==
X-Google-Smtp-Source: ABdhPJw36IoyUozGPz5B0NBKHhCpGWbRGV4z0TBLH3V+fiomyeu1Qa24ShXVDV2sdlY2fy4YjAW40g==
X-Received: by 2002:a5d:6152:: with SMTP id y18mr16444764wrt.255.1617384981241;
        Fri, 02 Apr 2021 10:36:21 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id m5sm15616659wrq.15.2021.04.02.10.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 10:36:20 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: initialize local variables in net/ipv6/mcast.c and net/ipv4/igmp.c
Date:   Fri,  2 Apr 2021 18:36:17 +0100
Message-Id: <20210402173617.895-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use memset to initialize two local buffers in net/ipv6/mcast.c,
and another in net/ipv4/igmp.c. Fixes a KMSAN found uninit-value
bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51

Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 net/ipv4/igmp.c  | 2 ++
 net/ipv6/mcast.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7b272bbed2b4..bc8e358a9a2a 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1131,6 +1131,8 @@ static void ip_mc_filter_add(struct in_device *in_dev, __be32 addr)
 	char buf[MAX_ADDR_LEN];
 	struct net_device *dev = in_dev->dev;
 
+	memset(buf, 0, sizeof(buf));
+
 	/* Checking for IFF_MULTICAST here is WRONG-WRONG-WRONG.
 	   We will get multicast token leakage, when IFF_MULTICAST
 	   is changed. This check should be done in ndo_set_rx_mode
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 6c8604390266..ad90dc28f318 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -658,6 +658,8 @@ static void igmp6_group_added(struct ifmcaddr6 *mc)
 	struct net_device *dev = mc->idev->dev;
 	char buf[MAX_ADDR_LEN];
 
+	memset(buf, 0, sizeof(buf));
+
 	if (IPV6_ADDR_MC_SCOPE(&mc->mca_addr) <
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
@@ -694,6 +696,8 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 	struct net_device *dev = mc->idev->dev;
 	char buf[MAX_ADDR_LEN];
 
+	memset(buf, 0, sizeof(buf));
+
 	if (IPV6_ADDR_MC_SCOPE(&mc->mca_addr) <
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
-- 
2.30.2

