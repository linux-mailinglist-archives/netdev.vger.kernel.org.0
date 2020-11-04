Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261802A666E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgKDOb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730042AbgKDObu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:31:50 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D7FC0401C2
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:31:48 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id x7so22293551wrl.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K0xwbWgfzNb+siGOnTIoHV8a22y8LDX4Jm2bW67sNRs=;
        b=Gfkh6YfCE72+ydlSJ/wl7fWmXAUOkTbF24ca29DtpQjcRnzH2tuzCLv3xTT37WI3E1
         ADY32e7KnYdz09JC2n7Ffr6URAzF0HDjz3MxA71JqOiTjEJKepuLYN7K9nZmvk90RRF5
         bZvEQXcMAZxU5w4Fq/D2ZYzLxto9L/ffmiYoUHwmxRx3xQJCsnyQm0R1J82N+6Qv96lg
         4L6uz/yaCUq28ORAzFXzKYqwYUAI4KFP3Xe+fN5bYN+SO0YZxbxQqMmXL0vXA4KoP5PA
         iu5k47/kJGsNgbsFX6Pl/x+Ll9JjfG9MKhHtPAPufCLMKlT9HNlOfqHZVL1eALx65NZ8
         TmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K0xwbWgfzNb+siGOnTIoHV8a22y8LDX4Jm2bW67sNRs=;
        b=g7EaILlz+8jisPTcNCgOAfZwlaMRvxTOcTuw/rRD3bJvOmE/pBV4t6XtBHW38HpN0n
         x175Eq/Ugp0H4RT+Fwzh7Cn6d/EESq4uCss3d1ejJCvJ9xd1K/G+XE3VfYdr2/PwgkPc
         unxtFg95giqF0xdC4mCPAiYsU5J8xSmt5a0ZzWSDPpsEEu7sto0SzmQuVGTQPlUXE49P
         8xI9ZvVhMlK2XBv67R2JiVd4lR8KcC0NOwXPfh/6Ropi0ymTdXiVna8M/8lzVynEisPG
         TZo6fJA9hVwZlQUq1thUToxrdsuW42cnxZPpDWY8zPAfvnx3FUwWwDLtVlMIPX4hhOBM
         m9tA==
X-Gm-Message-State: AOAM532QezPt7bV2pYe8Iosbozn+3a4YO0st1/FRNyWpNeR7JqMQHjgq
        rB8OL/xWBk6TYDulAq0Kv00=
X-Google-Smtp-Source: ABdhPJwl5X8jvdS+mUXZcO0Nb3rEd3NCzr93XMi5XApyMil2tE6bG73j3OHe5qt6fBIyVpvdh0u7gw==
X-Received: by 2002:a5d:474f:: with SMTP id o15mr5595878wrs.100.1604500307652;
        Wed, 04 Nov 2020 06:31:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:d177:63da:d01d:cf70? (p200300ea8f232800d17763dad01dcf70.dip0.t-ipconnect.de. [2003:ea:8f23:2800:d177:63da:d01d:cf70])
        by smtp.googlemail.com with ESMTPSA id k84sm2508318wmf.42.2020.11.04.06.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:31:47 -0800 (PST)
Subject: [PATCH net-next v2 10/10] net: remove ip_tunnel_get_stats64
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
References: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Message-ID: <1d40c040-7b4b-9531-2cb0-0e8e3f954e25@gmail.com>
Date:   Wed, 4 Nov 2020 15:31:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After having migrated all users remove ip_tunnel_get_stats64().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/net/ip_tunnels.h  | 2 --
 net/ipv4/ip_tunnel_core.c | 9 ---------
 2 files changed, 11 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 02ccd3254..1b7905eb7 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -274,8 +274,6 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict);
 int ip_tunnel_change_mtu(struct net_device *dev, int new_mtu);
 
-void ip_tunnel_get_stats64(struct net_device *dev,
-			   struct rtnl_link_stats64 *tot);
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


