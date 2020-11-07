Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F1D2AA800
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgKGU4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgKGU4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:16 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3A7C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:16 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id d12so3311285wrr.13
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=5Jpd8MyUKg1H1iYmLx0Vs/UrPW9/4+4JcaA/CtXlnF0=;
        b=qvBaZvylSLknklKSyf8Tn7UjcNb2NB5NAxI7PZAg0UvBWFhAIXVkXd95VxaT6yTfP5
         upxuR57oFY+fwA51pSrATaS4qIOBJh4D88MoH6fgkTlWA5LUS3dKyYwHocWrdAHoB2UO
         TraKPUlgKWVP8f9bnHigcIk3LXY/Kyrq2t/bjQIV2ntIyTWygDvvpSjlmSYYxMoS+Zx1
         E3EOvS6/t9PkROdqIS9Fi38oLnS/xpOqeJZjwZB7xgiyVcu5k4Y+Jcu0xbzYyELP5Jbw
         +EDgaxnGTlqqhqXznoa83pgJKVD2xBuDY2pODVPb6f+VWV4KehNJAyuUPBKUYEqtKYzV
         ArTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=5Jpd8MyUKg1H1iYmLx0Vs/UrPW9/4+4JcaA/CtXlnF0=;
        b=gmO8dKEfBBOS5SVdcMiR0jhqdch9I7s3gOtc2GyyPqV313eNOKojAhbPZP8dw6DNBV
         gQHbvRYRlRIgQjZqqY74wrSJeaEjtosaviOg6VTxdoHMasy3APP6Rf5L/K1flknQii01
         kG6a1s5ILYyPm2TrViG4Y0MLcaOrx9y9xDJmmlXn4WoQI6d8cjWrzJbPRujGCKEINBXP
         GM85SeuV3hVGof9QAcnmoU3+q+Ekxy56z7Do6RMaSGGyxMY/+g8gZLffNPrfdQxX1EGe
         YkmAjRsUYLBMlDlStSk/G5iOU6wqT/COXmEgCQxQzhu/6T+hnre7zOehQDy02WhRkFPl
         kNnQ==
X-Gm-Message-State: AOAM531bp4SHAPEylV6OVXw9hBEg9TYBviUqcXaZJFVGBDVKNZXF1d44
        JVATzLd8F6YRR4IzpN5Z0/8=
X-Google-Smtp-Source: ABdhPJxEXB65Krwh00LfzZlO3I9jG/KtFbZ7Mu9oyAgkhd2gkkr4etad3WlBVMAerho9PYjTH0M2eQ==
X-Received: by 2002:a5d:660a:: with SMTP id n10mr9662367wru.59.1604782574951;
        Sat, 07 Nov 2020 12:56:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id r18sm8636088wrj.50.2020.11.07.12.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:14 -0800 (PST)
Subject: [PATCH net-next v3 09/10] ipv4/ipv6: switch to dev_get_tstats64
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Message-ID: <ecb84c1d-985f-08e5-dc1f-c46e55615c50@gmail.com>
Date:   Sat, 7 Nov 2020 21:54:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace ip_tunnel_get_stats64() with the new identical core function
dev_get_tstats64().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ipv4/ip_gre.c  | 6 +++---
 net/ipv4/ipip.c    | 2 +-
 net/ipv6/ip6_gre.c | 6 +++---
 net/ipv6/sit.c     | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index e70291748..a68bf4c6f 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -920,7 +920,7 @@ static const struct net_device_ops ipgre_netdev_ops = {
 	.ndo_start_xmit		= ipgre_xmit,
 	.ndo_do_ioctl		= ip_tunnel_ioctl,
 	.ndo_change_mtu		= ip_tunnel_change_mtu,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_iflink		= ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl		= ipgre_tunnel_ctl,
 };
@@ -1275,7 +1275,7 @@ static const struct net_device_ops gre_tap_netdev_ops = {
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= ip_tunnel_change_mtu,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_iflink		= ip_tunnel_get_iflink,
 	.ndo_fill_metadata_dst	= gre_fill_metadata_dst,
 };
@@ -1308,7 +1308,7 @@ static const struct net_device_ops erspan_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= ip_tunnel_change_mtu,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_iflink		= ip_tunnel_get_iflink,
 	.ndo_fill_metadata_dst	= gre_fill_metadata_dst,
 };
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 75d35e76b..d5bfa087c 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -347,7 +347,7 @@ static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_start_xmit	= ipip_tunnel_xmit,
 	.ndo_do_ioctl	= ip_tunnel_ioctl,
 	.ndo_change_mtu = ip_tunnel_change_mtu,
-	.ndo_get_stats64 = ip_tunnel_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl	= ipip_tunnel_ctl,
 };
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 931b186d2..8cf659994 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1391,7 +1391,7 @@ static const struct net_device_ops ip6gre_netdev_ops = {
 	.ndo_start_xmit		= ip6gre_tunnel_xmit,
 	.ndo_do_ioctl		= ip6gre_tunnel_ioctl,
 	.ndo_change_mtu		= ip6_tnl_change_mtu,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_iflink		= ip6_tnl_get_iflink,
 };
 
@@ -1828,7 +1828,7 @@ static const struct net_device_ops ip6gre_tap_netdev_ops = {
 	.ndo_set_mac_address = eth_mac_addr,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_change_mtu = ip6_tnl_change_mtu,
-	.ndo_get_stats64 = ip_tunnel_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
 
@@ -1896,7 +1896,7 @@ static const struct net_device_ops ip6erspan_netdev_ops = {
 	.ndo_set_mac_address =	eth_mac_addr,
 	.ndo_validate_addr =	eth_validate_addr,
 	.ndo_change_mtu =	ip6_tnl_change_mtu,
-	.ndo_get_stats64 =	ip_tunnel_get_stats64,
+	.ndo_get_stats64 =	dev_get_tstats64,
 	.ndo_get_iflink =	ip6_tnl_get_iflink,
 };
 
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 5e2c34c0a..4dc5f9366 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1396,7 +1396,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_uninit	= ipip6_tunnel_uninit,
 	.ndo_start_xmit	= sit_tunnel_xmit,
 	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
-	.ndo_get_stats64 = ip_tunnel_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
 };
-- 
2.29.2


