Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC9B2D758D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgLKM1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405247AbgLKM05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:26:57 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1363CC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:17 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id s11so10670013ljp.4
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WLizZ4UdUCyVcfP2HmrWjFnwcFxh8nxr6cVF2v4pr4U=;
        b=Pz9SkYEyERb2ubP9I48atwnVn0kje04ImX38nJwpYAC7xaVXEqMIrEkxUJvjF1Cspy
         nNrNL44cvyuydrB8qNUx8E+AnyUkoms356HW8UGEDYA0AN/OuTr2kijw745CF5Z8+oAH
         ZNYFbe4zsomA8Ss0y64jEeM9FM5XlS4MdEojbx1RvecH1FmWbVpW1WUXpbmXCj0qkYMW
         k65nJero24T6HV7x/xhpjJLhozcW8lKUC4p0gFlJ6kByX+lp4mgt6jRE/vxpbHoOmNdx
         Nqr3a+W9idPDae8GJD8a+WUqDJVMPrUcfjod6jkEEXQRft1O2isoi2m9/grxVTsenUUj
         3JTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WLizZ4UdUCyVcfP2HmrWjFnwcFxh8nxr6cVF2v4pr4U=;
        b=IUKlVK65+ZGvI0QWl/aBwkHSMzV9conKFqqGkeCxTF8bIdotcQjWJTuyTdqtlroOoP
         Zkvci25gttqfst2g9FVicL6CU80wKv8jCC4DnT4Gry5vjM2eFUQ4FChNUtdJNeL+qljm
         ImrnnB8B6g1kt9tDkm51Nh6sU0VM/AvnG5IiaLP6LnI6C4Vqmrj1w9PyPlBoiO4AtGW1
         hQnbDMUFI7V3cWmbROXKlv+eAtF6yE6/DY+9thIC1ARBjs7mALpAC9puab57Fr4zKQ1+
         KwWL8vEXmRwwfJAXgFgnzxtPgx68+0TXM/NwdhY5LiSK+xEl6xR5Y9b21qIFrMqQSLse
         Sstg==
X-Gm-Message-State: AOAM533wHsvbUNoPy49l6OJYrHVFhLJM283QjLWsqq9+G+SkKnNUM4fg
        U2FGTpB/HrIKgGgwi3Mp81TFK96gYu8c6Q==
X-Google-Smtp-Source: ABdhPJwTEEEBl1n6StIbBTFcUdpMRHvXHOmUf0Ee7PN8byQ21LO5lqHycwUMjHrL3EN1EiseHqjAMg==
X-Received: by 2002:a05:651c:316:: with SMTP id a22mr5031112ljp.473.1607689575428;
        Fri, 11 Dec 2020 04:26:15 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:15 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 01/12] gtp: set initial MTU
Date:   Fri, 11 Dec 2020 13:26:01 +0100
Message-Id: <20201211122612.869225-2-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
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

