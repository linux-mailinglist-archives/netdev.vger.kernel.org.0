Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AD22911E3
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437987AbgJQMuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 08:50:21 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45067 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437936AbgJQMuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 08:50:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 649AC5C00D1;
        Sat, 17 Oct 2020 08:50:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 17 Oct 2020 08:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=AsiCvPZmp80CX94lTRtgMi5LoJ
        l7435qaXC6ZTou+94=; b=gfgDTmU1+qjr3JSOBy/dwqM+hTptrAbxski04uTrMG
        QujQx+RviLeYfTVY2wvHwt7yOH7/ytM0uYOltYsevW2OgPBpSZ/SqtO5rMmhL+yP
        mHrK3z3PkjivwiSFLhIjYovs2MztO4Lo0Y5Y3SwrDANi+ZWdlf/SsAlAKLOMUwYs
        XD3LcRf48HIr3uzcn9y9cx+vwH0rJ6JduoKh03eUiIDCxDumRpiN9/WzIKtHS5gy
        JHawXfT5Ic2+j9SmT2OhaYK3dUXVkL4U++DF8B6bdf+Y6rYjhumIGpOiuWG3CLln
        qC04QRkPzEmbr7YzjCrWAxo9s9rWfeu20y77Y8yDaZ/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AsiCvPZmp80CX94lT
        RtgMi5LoJl7435qaXC6ZTou+94=; b=Fj87FbZ7R5fsNj/ezriWzG+BHCCT7as/G
        AEr5807ZdXcutRSsr3B8duUgFIjK2sd+uoc5rexWp7vt/L+FI7nBsz0ccMoO0qQT
        sQdX3pIwxsRZkI3i/KvtkwuX1HaxjjGnP6ZtR39j0QmrglwD6UwxMj5L392BC4OD
        NHYUiIJ72zqtvah8gKxLWTyq7Xbxu/xy6+XukUTA2yu3uzfOaZbLPO75uClAb8D5
        EzmJQVx/ilPG3PbEAGlD6TMR0LWBIb8TmvDPcwAulQTEa6YjejTSEuVL8WIckyNj
        noHP5q/EpOzoKrJ3nk0ZkJrRuCWhuDXO/3Gj9tCkkOZ/KDdBmMo+A==
X-ME-Sender: <xms:iuiKXwd_cx82TzvPfnwD4UlJDlA2h-LqKYU3A32GDaI-cSNNIY6E4Q>
    <xme:iuiKXyN8t5xzRGy8RQ47uWO7L5qFqdvaGJjOWEq46T8r6HSIBQHdwVq45PRt_jx8v
    jKjXC-K3hTTLoS3z4Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieejgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepgghinhgtvghnthcu
    uegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecuggftrfgrthhtvg
    hrnhepvdeiffetueektdelveffhfdvfefgtdffhedtudekteevfffgvedtfeehveffhefg
    necukfhppeekvddruddvgedrvddukedrgeehnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepsggvrhhnrghtsehluhhffhihrdgtgi
X-ME-Proxy: <xmx:iuiKXxilS1WZR-WKqaBABbsqsJaJYLI3-W2HDH5-zxWXwQVQckQJ2A>
    <xmx:iuiKX19HjI7tPyl9898gqtOzDXO4Yeax6A1Lstk12TrG2AWiIqXrDA>
    <xmx:iuiKX8uBsSNI7sJUqiW3NYvFyIxL6mAhHcIlpeaIJJOp4MnAlO4QwA>
    <xmx:i-iKX-KI4P64qQbPTUkmK8NjX-cE7xI6LZW0GBB2PNtUcDk3NedU6g>
Received: from neo.luffy.cx (lfbn-idf1-1-134-45.w82-124.abo.wanadoo.fr [82.124.218.45])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CA213064682;
        Sat, 17 Oct 2020 08:50:18 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id F39C6919; Sat, 17 Oct 2020 14:50:16 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Andy Gospodarek <gospo@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net-next v1] net: evaluate net.conf.ipvX.all.ignore_routes_with_linkdown
Date:   Sat, 17 Oct 2020 14:50:11 +0200
Message-Id: <20201017125011.2655391-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.28.0
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
index 837d51f9e1fa..fb6e4658fd4f 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1552,6 +1552,9 @@ igmpv3_unsolicited_report_interval - INTEGER
 
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
2.28.0

