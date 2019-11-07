Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF1BF34D3
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389470AbfKGQnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51119 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389434AbfKGQnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1DD5D21B6B;
        Thu,  7 Nov 2019 11:43:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=YHAyfqaBxyn7gXhP7DOdZbHS4xAUgrP9ql8f9nBoqvI=; b=f0OwQ/rB
        prBvIZZixCR3HSJU3VIcGPVeJ0+gbnAYUbnJwyHD/vVNqAwxwWqoXLqhtrFLrnWU
        FIsiZtnWW1P1b3u13yQZGDV4QokTTNuJZtwJ4Ml46bq1kl1wuscJtLbjicKGI3E1
        NbQSjcI8sNgsFKZ1UvOc+xXLsWh/vx+3SYSNzVLoXry7oSISQDYrnad1Iv06rzNZ
        frGR8vEck+tJNmG4PtR1oR+JCAWJVHrLm5ARjnET1l9qVrCHLC9b+laYihPwJzvf
        mi4uWMPZoYVDdSnRHGkViA+dxs4JN107w4OcS5IEoILBFbnYFi3/3Wa4VliLRriU
        1tAnoF8FZwsjag==
X-ME-Sender: <xms:oUnEXQRp55ZgUONCXSdATNPw-SkwV7d4_b-oQu0MsuW28U5VmiiX7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:oknEXRzJ2YjsHf4M1xzunEW01vZWadVqL4dYfCrXzTtanxJiOVs5sg>
    <xmx:oknEXc7_WpqXSF6p0bob0bk8hHl3f8VvX6Ghxeo9Yr1P2IZos6KpfA>
    <xmx:oknEXVx1XItOUOZDMuX3mdXjga50gpPQH5UDY6eSmpS4IeIVcAlK-Q>
    <xmx:oknEXcY2ocPVxIjY3OPc2ecrYkWWZHbv5IWCMvDweNzyKle3bUc_Dw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9852780061;
        Thu,  7 Nov 2019 11:43:12 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/12] devlink: Add layer 3 generic packet traps
Date:   Thu,  7 Nov 2019 18:42:09 +0200
Message-Id: <20191107164220.20526-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add packet traps that can report packets that were dropped during layer
3 forwarding.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink-trap.rst | 41 +++++++++++++++++++++++
 include/net/devlink.h                     | 27 +++++++++++++++
 net/core/devlink.c                        |  9 +++++
 3 files changed, 77 insertions(+)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index 8e90a85f3bd5..dc3dc87217c9 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -162,6 +162,47 @@ be added to the following table:
      - ``drop``
      - Traps packets that the device decided to drop because they could not be
        enqueued to a transmission queue which is full
+   * - ``non_ip``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to
+       undergo a layer 3 lookup, but are not IP or MPLS packets
+   * - ``uc_dip_over_mc_dmac``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed and they have a unicast destination IP and a multicast destination
+       MAC
+   * - ``dip_is_loopback_address``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed and their destination IP is the loopback address (i.e., 127.0.0.0/8
+       and ::1/128)
+   * - ``sip_is_mc``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed and their source IP is multicast (i.e., 224.0.0.0/8 and ff::/8)
+   * - ``sip_is_loopback_address``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed and their source IP is the loopback address (i.e., 127.0.0.0/8 and ::1/128)
+   * - ``ip_header_corrupted``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed and their IP header is corrupted: wrong checksum, wrong IP version
+       or too short Internet Header Length (IHL)
+   * - ``ipv4_sip_is_limited_bc``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed and their source IP is limited broadcast (i.e., 255.255.255.255/32)
+   * - ``ipv6_mc_dip_reserved_scope``
+     - ``drop``
+     - Traps IPv6 packets that the device decided to drop because they need to
+       be routed and their IPv6 multicast destination IP has a reserved scope
+       (i.e., ffx0::/16)
+   * - ``ipv6_mc_dip_interface_local_scope``
+     - ``drop``
+     - Traps IPv6 packets that the device decided to drop because they need to
+       be routed and their IPv6 multicast destination IP has an interface-local scope
+       (i.e., ffx1::/16)
 
 Driver-specific Packet Traps
 ============================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6bf3b9e0595a..df7814d55bf9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -569,6 +569,15 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_ROUTE,
 	DEVLINK_TRAP_GENERIC_ID_TTL_ERROR,
 	DEVLINK_TRAP_GENERIC_ID_TAIL_DROP,
+	DEVLINK_TRAP_GENERIC_ID_NON_IP_PACKET,
+	DEVLINK_TRAP_GENERIC_ID_UC_DIP_MC_DMAC,
+	DEVLINK_TRAP_GENERIC_ID_DIP_LB,
+	DEVLINK_TRAP_GENERIC_ID_SIP_MC,
+	DEVLINK_TRAP_GENERIC_ID_SIP_LB,
+	DEVLINK_TRAP_GENERIC_ID_CORRUPTED_IP_HDR,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_SIP_BC,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_RESERVED_SCOPE,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -607,6 +616,24 @@ enum devlink_trap_group_generic_id {
 	"ttl_value_is_too_small"
 #define DEVLINK_TRAP_GENERIC_NAME_TAIL_DROP \
 	"tail_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_NON_IP_PACKET \
+	"non_ip"
+#define DEVLINK_TRAP_GENERIC_NAME_UC_DIP_MC_DMAC \
+	"uc_dip_over_mc_dmac"
+#define DEVLINK_TRAP_GENERIC_NAME_DIP_LB \
+	"dip_is_loopback_address"
+#define DEVLINK_TRAP_GENERIC_NAME_SIP_MC \
+	"sip_is_mc"
+#define DEVLINK_TRAP_GENERIC_NAME_SIP_LB \
+	"sip_is_loopback_address"
+#define DEVLINK_TRAP_GENERIC_NAME_CORRUPTED_IP_HDR \
+	"ip_header_corrupted"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_SIP_BC \
+	"ipv4_sip_is_limited_bc"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_MC_DIP_RESERVED_SCOPE \
+	"ipv6_mc_dip_reserved_scope"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE \
+	"ipv6_mc_dip_interface_local_scope"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97e9a2246929..9bbe2162f22f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7602,6 +7602,15 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(BLACKHOLE_ROUTE, DROP),
 	DEVLINK_TRAP(TTL_ERROR, EXCEPTION),
 	DEVLINK_TRAP(TAIL_DROP, DROP),
+	DEVLINK_TRAP(NON_IP_PACKET, DROP),
+	DEVLINK_TRAP(UC_DIP_MC_DMAC, DROP),
+	DEVLINK_TRAP(DIP_LB, DROP),
+	DEVLINK_TRAP(SIP_MC, DROP),
+	DEVLINK_TRAP(SIP_LB, DROP),
+	DEVLINK_TRAP(CORRUPTED_IP_HDR, DROP),
+	DEVLINK_TRAP(IPV4_SIP_BC, DROP),
+	DEVLINK_TRAP(IPV6_MC_DIP_RESERVED_SCOPE, DROP),
+	DEVLINK_TRAP(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
-- 
2.21.0

