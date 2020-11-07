Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408B82AA7AA
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgKGTfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:35:36 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:39871 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbgKGTfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:35:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5BDDCCCB;
        Sat,  7 Nov 2020 14:35:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 07 Nov 2020 14:35:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=l5QoLWgfPvfgu
        R2DrcmcTAqfnn8C69HIG2XMVNyzjho=; b=Qp77h6hTjUVydB0/HRezSd0haTZSO
        1iYq8IiDGuW4ikV5/7f2GdjlV6CyFTUNyhjrZLYi+tEu+wk9X4/ZKmhGq1aGwnr8
        GeXlhLxvGWJVKw8v6YkzrWBgDNOlG27zqRKl1DI+nhwh7QLBIjLkFwllh39Czp0D
        hPytyV/e7iBRR60A9H8kEdm4BzFKq5z62OVKsgKsYapf59WDbfGiaohbsjDRfUWH
        A6SfZqxH1yWUdYLoo8j6A55J1ihnMIDPAvRhzBw4RTd47mMASu9itoZcsr/3310v
        UAuNDf8JS+QLeEXzboXrZ7BBggE1/Zy2lHVsgKx4FW8QfhOokBkBr7wdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=l5QoLWgfPvfguR2DrcmcTAqfnn8C69HIG2XMVNyzjho=; b=J6bTOXvF
        zinC8ieTJ/6xHJE7Yb7uRYhJIu47Gic6y8gJAUtISYrFcbNr6BhosxqagXvVpKQ9
        vFodS4bH8oL7KuzGso7Xnj9lbw418/r5o0MoHK1XgFndRud6HtrVD9z5jqJDE8OF
        hLfGHxZqu+eRWsKWM9cfsXmE4R/qoyiCcfbjwluKD6wNXmXNtBas5EYunWqxOXvI
        iV1l0g4ok2vnne6wNT6gb9BlJvpnHGkJo/pQPruT6UJsiDlWa26p8yCDraOOZQCi
        0ARs0z6XPnOSACvSyFcUGJlTqWfH4vRoCRDD4B9XGt6FJM7pxDcX+6gegh+miMyg
        BgnxAD7A6Pz63g==
X-ME-Sender: <xms:BPemX53nvEZxJWIt7AIVTnX5XAsts6avVvDsd142L-HHA-xNsL7XhQ>
    <xme:BPemXwHIN8l8udA-UXyw60chLCXc9Kb23iLw6y4kNc30VHYNXPgpj0yhUFnnUZSu4
    1YO8z-YMXvliGG-EsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecuggftrf
    grthhtvghrnhepieefjeeuieeggeehkeettdeltdehffffjeehtdehlefhtdffteegleeg
    geduhfejnecukfhppeekiedrvdegvddrkedrudeijeenucevlhhushhtvghrufhiiigvpe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhufhhfhidrtgig
X-ME-Proxy: <xmx:BPemX55mvQDWB9BqSkBvSap0j4Oy6JL83GMxjfz77LH4wBHUs0weWQ>
    <xmx:BPemX20RYl3ibDSEUvoobL8Avfq4jUU9RgnV2tLWTzRo1tMCX28mNA>
    <xmx:BPemX8EdKbErBdFzrXesBSxY8FJJF6xD3zFQwPRLEP3D1T6SkN3Xhg>
    <xmx:BfemX4hzM-LHpe-XYkEa1WqfIm16euNlRRdYsDIMhD5GnNeiY4Y9vQ>
Received: from neo.luffy.cx (lfbn-idf1-1-619-167.w86-242.abo.wanadoo.fr [86.242.8.167])
        by mail.messagingengine.com (Postfix) with ESMTPA id C61703280414;
        Sat,  7 Nov 2020 14:35:32 -0500 (EST)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id B6D3EA17; Sat,  7 Nov 2020 20:35:31 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net-next v2 2/3] net: evaluate net.ipv4.conf.all.proxy_arp_pvlan
Date:   Sat,  7 Nov 2020 20:35:14 +0100
Message-Id: <20201107193515.1469030-3-vincent@bernat.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201107193515.1469030-1-vincent@bernat.ch>
References: <20201107193515.1469030-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduced in 65324144b50b, the "proxy_arp_vlan" sysctl is a
per-interface sysctl to tune proxy ARP support for private VLANs.
While the "all" variant is exposed, it was a noop and never evaluated.
We use the usual "or" logic for this kind of sysctls.

Fixes: 65324144b50b ("net: RFC3069, private VLAN proxy arp support")
Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 include/linux/inetdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 3bbcddd22df8..53aa0343bf69 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -105,7 +105,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 
 #define IN_DEV_LOG_MARTIANS(in_dev)	IN_DEV_ORCONF((in_dev), LOG_MARTIANS)
 #define IN_DEV_PROXY_ARP(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP)
-#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_CONF_GET(in_dev, PROXY_ARP_PVLAN)
+#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP_PVLAN)
 #define IN_DEV_SHARED_MEDIA(in_dev)	IN_DEV_ORCONF((in_dev), SHARED_MEDIA)
 #define IN_DEV_TX_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), SEND_REDIRECTS)
 #define IN_DEV_SEC_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), \
-- 
2.29.2

