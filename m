Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB6B30182E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAWUF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbhAWUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:14 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939A1C061788
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:33 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id i187so2042224lfd.4
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Axi2g6I6F47I8bzDu1p5LN7RII40A/s6odd4OB1z8JY=;
        b=xo3tLdxWKGXck/ItrYfHG9ZHiEH02+cSemduNlDPZyJVbfH4pvlIHcpHxmpnXK3W7h
         tJFMYyGNFqBdsLevaN5bg5wYNmBbxX2zWCctYp3kZ8izy9grDUGdPFEO0oGq53rxbSu2
         CI6lRfJLYs/YyX951ESC3fYOsv0/0D0aAulykJg0mAqWW1v6fj+h11Wgmr0RBQUNZO55
         wAFPp2qmhJlkI10Em5TsI1H0uOVBbtf4yvW+SX9egZtwBT+s0Gw4dvByQLp9pVhLrvRJ
         FGgWh8DK2s8pPhDCN1SPrMj8T9+dX/5tOqfSiCXXWmuNs1sbLbwqOCMmVAnc5YqWSJce
         xdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Axi2g6I6F47I8bzDu1p5LN7RII40A/s6odd4OB1z8JY=;
        b=ul+1FAAUWi4WatjbSzR7KpgRtX1k2yFll6u87kFS+Ls1oGW7tyeHYM5jU40fuPHQlQ
         cXRFanrFReLZs2QATPvo+thN7DWVIVvr6nlVsW/pzxAYQYtxu0cLkDnud+SNouNe8xKG
         GfegqVWd/AAVn1c88B5KLtN1YGVfMjBNT3DETX7LG1Mn+3A1NgT/QFAi8PjOqN12vk1A
         V0kWpG4hOsAnQ67jQEbbvfuAG3eTXivsUWXlPMwZEtfAz6CqBtDaJxZaL3r14VpSEzdv
         IRBWRWNRtDb1/Z38XCMWqktDzcJOWnABMzhoet9Z/9nLj/dqf5L5PVI6++hlRme6zBHS
         Ol/w==
X-Gm-Message-State: AOAM5319syZdzaepetxjjhMlAOdvq6lnY0a5MngAwXzsKQzn/UcoNrlY
        RHNfiBuiqITRCj+oo2puewI3pQ==
X-Google-Smtp-Source: ABdhPJyxAtVv0dW6QA7LJA69XQDyjNPAG1q/EYaawE7Rj8c6BgB3GKwHgT48htWKND/963/MmddcDg==
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr3513321lfu.253.1611431972171;
        Sat, 23 Jan 2021 11:59:32 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:31 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 02/16] gtp: set initial MTU
Date:   Sat, 23 Jan 2021 20:59:02 +0100
Message-Id: <20210123195916.2765481-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GTP link is brought up with a default MTU of zero.  This can lead to
some rather unexpected behaviour for users who are more accustomed to
interfaces coming online with reasonable defaults.

This patch sets an initial MTU for the GTP link of 1500 less worst-case
tunnel overhead.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c04e271f184..5a048f050a9c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -612,11 +612,16 @@ static const struct net_device_ops gtp_netdev_ops = {
 
 static void gtp_link_setup(struct net_device *dev)
 {
+	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
+					  sizeof(struct udphdr) +
+					  sizeof(struct gtp0_header);
+
 	dev->netdev_ops		= &gtp_netdev_ops;
 	dev->needs_free_netdev	= true;
 
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
+	dev->mtu = ETH_DATA_LEN - max_gtp_header_len;
 
 	/* Zero header length. */
 	dev->type = ARPHRD_NONE;
@@ -626,11 +631,7 @@ static void gtp_link_setup(struct net_device *dev)
 	dev->features	|= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	/* Assume largest header, ie. GTPv0. */
-	dev->needed_headroom	= LL_MAX_HEADER +
-				  sizeof(struct iphdr) +
-				  sizeof(struct udphdr) +
-				  sizeof(struct gtp0_header);
+	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
 }
 
 static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-- 
2.27.0

