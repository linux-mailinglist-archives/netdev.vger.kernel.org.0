Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D2A2A1DEB
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgKAMi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgKAMi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:38:26 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F521C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 04:38:26 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id d3so6864079wma.4
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 04:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJoOvIzuc/7uU26Wna8rdxyNpzSb0ihaLCFiqgwSV/s=;
        b=q6frTauU4fPIP3xTDfmui4WU+x34OXYBMajOkeJHyBrf4czr1AsVSCy9aw4q35+Lid
         8h1WBADrmY+MlLHQMt7gVGDgpHBNgtZ4VvWA160Vqv7Sisbhd6h4Tg3O4wqzkTp6t+8Z
         DDo4tla1jgUQu+JnnpZ+PoYnZl19E8LWNw/C4rNxlo7T6jJyiujuCC7qtfUThWAYXyeF
         mRwVBo7BvcuFhziiH/4mPDm2a5hby/s1P6EfYdQ7CdA7f9bhi4ZOa0jHHK1atC0biBZh
         eL8tPRG/bSS9fGuc/sJv09Bi7J0j/yAaQhoPg5aDlXT4avKWWj9AGLKnV0d+/ipiAACP
         V1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJoOvIzuc/7uU26Wna8rdxyNpzSb0ihaLCFiqgwSV/s=;
        b=VU8XIKoO9GbXAalhzvKeG6X6IogdTvi6EYRufYV2mhanfs0ufaRqu6EaFyVbO1jDVT
         OjHjIAcJQUPDIOOdLYp83apAELozkCI3pOpDALn59Iyo0WOEmDmJFD3CLdzrGzTXbjN1
         zaHtkF35l5miCOLVqBXI9UQmw2VhWG1XbD1bMMKxoAZ91ZuNT0msrgd6xbCFbTEwnSFj
         +9Sq+sPh+dMzlS02I5bI6OHXhn1vvlDbhSQArGzPimnAg/P33FCDNA2obuanmzQujeQS
         9Hw7pt0pwjWSS5uAeYi5JENBbizElU1xLHhz/uFMxgLf6iMtG60AkSs4XEmHJ8noMxMe
         VEgg==
X-Gm-Message-State: AOAM531u6gAvWQm0zIVAawvss7rCXl1FxgcB15fnTo6pbcyngBB1Oila
        FRbz+eYYor+qqVNa8alvrB9uvhmvezk=
X-Google-Smtp-Source: ABdhPJzxjrrmVgCvJeChaFBYrVy1qU0gjA5b5UzvKKbEUopRAOEeMMIu5/EKhTOKV0g+xxtRcgpZNQ==
X-Received: by 2002:a1c:f214:: with SMTP id s20mr12235919wmc.71.1604234304594;
        Sun, 01 Nov 2020 04:38:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:dc4f:e3f6:2803:90d0? (p200300ea8f232800dc4fe3f6280390d0.dip0.t-ipconnect.de. [2003:ea:8f23:2800:dc4f:e3f6:2803:90d0])
        by smtp.googlemail.com with ESMTPSA id t6sm19904415wre.30.2020.11.01.04.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 04:38:24 -0800 (PST)
Subject: [PATCH net-next 2/5] net: make ip_tunnel_get_stats64 an alias for
 dev_get_tstats64
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Message-ID: <944fa7d0-9b0e-5ae2-d4f8-9c609f1a7c20@gmail.com>
Date:   Sun, 1 Nov 2020 13:35:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_tunnel_get_stats64() now is a duplicate of dev_get_tstats64().
Make it an alias so that we don't have to change all users of
ip_tunnel_get_stats64().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/net/ip_tunnels.h  | 4 ++--
 net/ipv4/ip_tunnel_core.c | 9 ---------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 02ccd3254..500943ba8 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -274,8 +274,8 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict);
 int ip_tunnel_change_mtu(struct net_device *dev, int new_mtu);
 
-void ip_tunnel_get_stats64(struct net_device *dev,
-			   struct rtnl_link_stats64 *tot);
+#define ip_tunnel_get_stats64 dev_get_tstats64
+
 struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 				   int link, __be16 flags,
 				   __be32 remote, __be32 local,
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 25f1caf5a..923a9fa2e 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -429,15 +429,6 @@ int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_dst,
 }
 EXPORT_SYMBOL(skb_tunnel_check_pmtu);
 
-/* Often modified stats are per cpu, other are shared (netdev->stats) */
-void ip_tunnel_get_stats64(struct net_device *dev,
-			   struct rtnl_link_stats64 *tot)
-{
-	netdev_stats_to_stats64(tot, &dev->stats);
-	dev_fetch_sw_netstats(tot, dev->tstats);
-}
-EXPORT_SYMBOL_GPL(ip_tunnel_get_stats64);
-
 static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
 	[LWTUNNEL_IP_UNSPEC]	= { .strict_start_type = LWTUNNEL_IP_OPTS },
 	[LWTUNNEL_IP_ID]	= { .type = NLA_U64 },
-- 
2.29.2


