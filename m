Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243853522F4
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhDAWyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbhDAWyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 18:54:51 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B302C0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 15:54:51 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo1600926wmq.4
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 15:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0BEtX5LP70nyJG7ya7uvmx8BAaUk54UVHdYb+hbUjBs=;
        b=jR1ReMLzfCWK0Xu07vixNKC21cEJ1DjSSt1hDh5pFus1JJCq8uZBINGON10rB8T8iK
         AQkchLHKsX2b41MEGieZHthAWQEf1nPpBNilRfhFSBHHgD0T7mdth3GFft+/VXU5zu8y
         BiGaLu7ix+D3tKjA+0tY//pMY3yXqC0zJhBHXXKFw5Oog27mPI0k3E7T6mNyAQs+vyQ+
         PF+sHJYyyzrVARfWCIOi8AtvqDGTS9+mIb4GJDsBlQn1kg9mjvdcJ3dmmnPNZ+egbZUh
         k3TrwFpoz0LromUYxeZw7R3M5iAr886P4Gha+Wf/xd2K+VTo5w1xKzQjo90peZ/srIoc
         VvTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0BEtX5LP70nyJG7ya7uvmx8BAaUk54UVHdYb+hbUjBs=;
        b=BdHNp7C9mk1JTcEqA+6WNSRHsGxzpkO9LTQbSIfrVn5AtNj93GyXvGA5otloy3wYxU
         SML+SenPbRdqqcuNjihBGl7yqfB7eHRrtBUW3Qqo66DYDkemTZZ8EjS0HfIXnmDOFw9b
         Kb4r+iB3B4O7plCnpScZ4UE3g8WMLT8cS2Be1iesORcKWZ/VKpEOBClxLAjDkXZH+SAE
         s0LLSB9YoTJ1CMK1Vi3hm8RBSiRS/grBdYQjPmEoz6yyN0dUqSB34YEi7Z6SfQIPIAO6
         mhmtqY9MWucUsnW1+VTslan/yvS+QMYhJO0BR1ZPKt+wV64GgPwiuo5uNQpr0kPgdAvf
         c8qg==
X-Gm-Message-State: AOAM533XQ4M8+VZij200OsDeQS461AHT7RZ2NHLjBDjD5UNnxvVtrLpt
        7BeMGdey+GG9wCJZ7tglfoThec6MvN28RpJW
X-Google-Smtp-Source: ABdhPJwUO2MjKgKoczgMCMwi9Rcz76HK1m97B6/qN75Cprlfcyfwp097a4M3zlalijgP4c+p7E/Nhw==
X-Received: by 2002:a05:600c:4d95:: with SMTP id v21mr9899485wmp.20.1617317684206;
        Thu, 01 Apr 2021 15:54:44 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id f2sm10688468wmp.20.2021.04.01.15.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 15:54:43 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: initialize local variables in net/ipv6/mcast.c and net/ipv4/igmp.c
Date:   Thu,  1 Apr 2021 23:54:41 +0100
Message-Id: <20210401225441.3948-1-phil@philpotter.co.uk>
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

