Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C212AA7A9
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgKGTff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:35:35 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:36877 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728663AbgKGTfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:35:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 94E2ACCF;
        Sat,  7 Nov 2020 14:35:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 07 Nov 2020 14:35:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=GMx5WuDXEk8Gn
        TjKqIS6xBPu5RBIAbEvVL3CSj1TKNg=; b=Sl9UwgHiYfSKzSGCXJ/SzY8ARAXT8
        NncxjI92lktr7uU7rn2VqvsjdoDk2H50LzT++31FQM0tQhH+T1auTZlpt0MsJgdY
        NGMldNnNaecFrAgcse6oNNF8R/CJCPz7JYhaW1x9sX3xKXXDxrLRdxgyUmb4Ole5
        9HTKUlZKnYzBIvq4cTNaLciPHf9HpTwilR5RI7/iC3H3kQsYbnn7yrOyBWX1s13p
        l46qcAvjf+LmnSrYv/u3zkFrh5i+8wEIOFZkgX9nw8DlZ1qnoiKSNzr3yaZjrHxW
        7X0qn7bm3R5/HgpTDGJKC8KNYVXGzmvbRiSti9iLSQJOGu8bDub8c2+EQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GMx5WuDXEk8GnTjKqIS6xBPu5RBIAbEvVL3CSj1TKNg=; b=bekIypqk
        pV35JmbJuP2YV3g1ILKOPa5nNibmO+ytnfExzCwOb/JT/AlwJhD120bR3Ld2c661
        U72xS76P9B2vPLjzUBkFeSbzR31LsPtVMOYrTlmoXzv/qXGOoeUSjTiAbz0mnWV9
        mnJoRuOHIQyyAIiA2tEj+VdSidnD/xQqMAJNO9E76eG+YOTdr/1t7W1YBk+LmNHv
        9rGS9dqlHY7PIOyMKynNlISuAgFivXERxqs225VYeOC+0dpsk3Gjn7KfHHwlEl5u
        Qm5mdm9fP0piJH3UiPhgZj/A8Yp+EurxMznCUUIRCEYNkcGqJs26k47tcwktWCUF
        MY7yrdRxXugFBg==
X-ME-Sender: <xms:A_emX5oT9QhtodD_qPCbX4Wv9D5_weMZP47EAXsvEBLhVeQbVzasNg>
    <xme:A_emX7rQ4-UeQcAuxHE_i-iqp-osvSyXewsQ0j5orH9zxWhQWWXdOKHcEvR1qi4FB
    m1lcbkv3oWL1ibbtxY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecuggftrf
    grthhtvghrnhepieefjeeuieeggeehkeettdeltdehffffjeehtdehlefhtdffteegleeg
    geduhfejnecukfhppeekiedrvdegvddrkedrudeijeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhufhhfhidrtgig
X-ME-Proxy: <xmx:A_emX2NTXz7GCJbBpqQ0mvKMA9vWOWeTkcQjH0JjTIzH6ZbM8nFEaA>
    <xmx:A_emX07fqDGwJj7tGR1ak3WZSl-rCWCP7PRnKtzOdjh6FWw_yhvXgA>
    <xmx:A_emX47sspmYoGd-dimpsZcvJ6POauseIG84hb0jm_i51hUuNunDaQ>
    <xmx:A_emXz3VqSE1wT8ZoPgpG1nmpiVAOetWi_hxFIOlR7N4d23T_yLxCQ>
Received: from neo.luffy.cx (lfbn-idf1-1-619-167.w86-242.abo.wanadoo.fr [86.242.8.167])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4D0630614AA;
        Sat,  7 Nov 2020 14:35:30 -0500 (EST)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 2545FA17; Sat,  7 Nov 2020 20:35:30 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net-next v2 1/3] net: evaluate net.ipvX.conf.all.ignore_routes_with_linkdown
Date:   Sat,  7 Nov 2020 20:35:13 +0100
Message-Id: <20201107193515.1469030-2-vincent@bernat.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201107193515.1469030-1-vincent@bernat.ch>
References: <20201107193515.1469030-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
ignores a route whose interface is down. It is provided as a
per-interface sysctl. However, while a "all" variant is exposed, it
was a noop since it was never evaluated. We use the usual "or" logic
for this kind of sysctls.

Tested with:

    ip link add type veth # veth0 + veth1
    ip link add type veth # veth1 + veth2
    ip link set up dev veth0
    ip link set up dev veth1 # link-status paired with veth0
    ip link set up dev veth2
    ip link set up dev veth3 # link-status paired with veth2

    # First available path
    ip -4 addr add 203.0.113.${uts#H}/24 dev veth0
    ip -6 addr add 2001:db8:1::${uts#H}/64 dev veth0

    # Second available path
    ip -4 addr add 192.0.2.${uts#H}/24 dev veth2
    ip -6 addr add 2001:db8:2::${uts#H}/64 dev veth2

    # More specific route through first path
    ip -4 route add 198.51.100.0/25 via 203.0.113.254 # via veth0
    ip -6 route add 2001:db8:3::/56 via 2001:db8:1::ff # via veth0

    # Less specific route through second path
    ip -4 route add 198.51.100.0/24 via 192.0.2.254 # via veth2
    ip -6 route add 2001:db8:3::/48 via 2001:db8:2::ff # via veth2

    # H1: enable on "all"
    # H2: enable on "veth0"
    for v in ipv4 ipv6; do
      case $uts in
        H1)
          sysctl -qw net.${v}.conf.all.ignore_routes_with_linkdown=1
          ;;
        H2)
          sysctl -qw net.${v}.conf.veth0.ignore_routes_with_linkdown=1
          ;;
      esac
    done

    set -xe
    # When veth0 is up, best route is through veth0
    ip -o route get 198.51.100.1 | grep -Fw veth0
    ip -o route get 2001:db8:3::1 | grep -Fw veth0

    # When veth0 is down, best route should be through veth2 on H1/H2,
    # but on veth0 on H2
    ip link set down dev veth1 # down veth0
    ip route show
    [ $uts != H3 ] || ip -o route get 198.51.100.1 | grep -Fw veth0
    [ $uts != H3 ] || ip -o route get 2001:db8:3::1 | grep -Fw veth0
    [ $uts = H3 ] || ip -o route get 198.51.100.1 | grep -Fw veth2
    [ $uts = H3 ] || ip -o route get 2001:db8:3::1 | grep -Fw veth2

Without this patch, the two last lines would fail on H1 (the one using
the "all" sysctl). With the patch, everything succeeds as expected.

Also document the sysctl in `ip-sysctl.rst`.

Fixes: 0eeb075fad73 ("net: ipv4 sysctl option to ignore routes when nexthop link is down")
Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 Documentation/networking/ip-sysctl.rst | 3 +++
 include/linux/inetdevice.h             | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 2aaf40b2d2cd..dd2b12a32b73 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1554,6 +1554,9 @@ igmpv3_unsolicited_report_interval - INTEGER
 
 	Default: 1000 (1 seconds)
 
+ignore_routes_with_linkdown - BOOLEAN
+        Ignore routes whose link is down when performing a FIB lookup.
+
 promote_secondaries - BOOLEAN
 	When a primary IP address is removed from this interface
 	promote a corresponding secondary IP address instead of
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 3515ca64e638..3bbcddd22df8 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -126,7 +126,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 	  IN_DEV_ORCONF((in_dev), ACCEPT_REDIRECTS)))
 
 #define IN_DEV_IGNORE_ROUTES_WITH_LINKDOWN(in_dev) \
-	IN_DEV_CONF_GET((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
+	IN_DEV_ORCONF((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
 
 #define IN_DEV_ARPFILTER(in_dev)	IN_DEV_ORCONF((in_dev), ARPFILTER)
 #define IN_DEV_ARP_ACCEPT(in_dev)	IN_DEV_ORCONF((in_dev), ARP_ACCEPT)
-- 
2.29.2

