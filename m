Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE9223C38B
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 04:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHEClu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 22:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHEClu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 22:41:50 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDE8C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 19:41:49 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so23590656pgh.3
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 19:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QDmcTZDWeuwdWXnrOH109Y/AHlw1vgjhG/nuvuK0Q64=;
        b=Dsxx5vPMMpDepAwHxm/D2H2NTrw52TPNOD2td+k9ur8zIp65OjMtJ08fYnZD3D17oC
         QO4iQpXuEFSBBzhWCfQ23Mpjp7kkDd4XbZOJgHtgGbWJ9VM8q8sod13RCzu3QeeJePJz
         Oz0HS7ERQQV3YQtKmnaIP2ZtsArQLCcTBV5n4e9uESFsJ505xYzR7tQNbZTCPkO/zDE/
         ZRVyMLLnOpP4O4ffkTPyI0HBhGOCW3RTJqw37DsMAiYBoU+Q0KJjHXv8CEw4wIuhFRH+
         Pxdi/ocNSUOs8XPBvxU41gF0PwLLHEYNCsDk/0Aqfy23ewalDFmW6UewGgTQawBViT+D
         sLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QDmcTZDWeuwdWXnrOH109Y/AHlw1vgjhG/nuvuK0Q64=;
        b=raV6tH6uUKy3LnkNncjOKH+SMNPsZhFOQeF/VZGXtG2AuY5vQ8lVwvhY1T5vVWDq40
         zogebtPHvBL5n7Z6wOe5/JrdBun+NgN4m089NWLcNZhN/8Fv/DTCBVWoJXaNE4hRbuyP
         pxPz1fSFtw58LGFAGB36wPG21XZR0CLlKD1+LFADjLyoNVBKNZHlcwiRAdwU8+wtPeIl
         FTFe9LOVGvs6TwVtQ9Amm40L6NQ2wXxeMbRzPSPA25u3D+/6T18+twnI/cotYmMJbqNb
         9X6txdrhjSrHG0I37EUQtZaeoO3deiMXsS5e71rEuWv2LbVri7AbwLU9atJnGzUvXCM3
         /EHg==
X-Gm-Message-State: AOAM533uelsdHxt3+GCrEjBx+vb/VpXXjABOXZlavDkrren6wQuHKiaL
        4TuEwQm6oFYQwuyxsw4lahaPl+9S0nGPJw==
X-Google-Smtp-Source: ABdhPJxRQZk+uB2d4JqffHmZ8o2cexJlONvh3mnxsy+D5IN5L5RIqIBOxaMFDJdKAjrIlsFOqXOeXA==
X-Received: by 2002:a63:1962:: with SMTP id 34mr1102970pgz.411.1596595308941;
        Tue, 04 Aug 2020 19:41:48 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u2sm640868pjg.35.2020.08.04.19.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 19:41:48 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Andreas Karis <akaris@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] Revert "vxlan: fix tos value before xmit"
Date:   Wed,  5 Aug 2020 10:41:31 +0800
Message-Id: <20200805024131.2091206-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 71130f29979c7c7956b040673e6b9d5643003176.

In commit 71130f29979c ("vxlan: fix tos value before xmit") we want to
make sure the tos value are filtered by RT_TOS() based on RFC1349.

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |   PRECEDENCE    |          TOS          | MBZ |
    +-----+-----+-----+-----+-----+-----+-----+-----+

But RFC1349 has been obsoleted by RFC2474. The new DSCP field defined like

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |          DS FIELD, DSCP           | ECN FIELD |
    +-----+-----+-----+-----+-----+-----+-----+-----+

So with

IPTOS_TOS_MASK          0x1E
RT_TOS(tos)		((tos)&IPTOS_TOS_MASK)

the first 3 bits DSCP info will get lost.

To take all the DSCP info in xmit, we should revert the patch and just push
all tos bits to ip_tunnel_ecn_encap(), which will handling ECN field later.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a7c3939264b0..35a7d409d8d3 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2722,7 +2722,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		ndst = &rt->dst;
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2762,7 +2762,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.25.4

