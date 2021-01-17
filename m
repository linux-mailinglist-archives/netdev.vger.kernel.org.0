Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCED2F914E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhAQIGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:06:06 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:43593 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726412AbhAQIDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:03:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B0FC91417;
        Sun, 17 Jan 2021 03:02:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 17 Jan 2021 03:02:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=sjTQtFZ4qgSgsdg/NpibpjBWEYtcBWRQfKxVQ91DUGQ=; b=WZ9kz8Y+
        ZQbURBD4S7Wu8dUp5zGGTifWvwpTOyncd1GV5S/VkuDYh+y4/FkKri5iJQZ41kt/
        05qN3mtAFAak/xzDTmr7J02nHU5bzzNvMTGed3MA/IpGczQRxIryT7vMYSBDGgZb
        7FuGtGvHyE5JMjLEuSvI0fyVLuuk0BAenhT2lR5gkRj2oW9YBkrzNT4mOB+RCt3A
        er9mSVYpdZGDl9jXPybK6wYek1/mZ+0mD73F9D1ooAdXG8XifblQqWQkifqbzZX8
        f/W2apo7YHWJsU6C23DCaxoksRfTiSVLHuAvZ/0pqvEsiIvmRTFThPv9wEbier4C
        EjAQ73hfe2eGuw==
X-ME-Sender: <xms:LO8DYDoVpM7vT2vWf-c71kj8N-AWXBGBdfq0bcYPYzyh3jkIqQ65uA>
    <xme:LO8DYNpBXYzYr8YQLqvtlMXk_ae72o-q8LDy4TD-L3DsSED0GUX8Jea-cjLCIOAYJ
    oyZa2-TPLjJ0bQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdehgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:LO8DYAM-N0XGpWEvWPI7XlEL8zOD8kRd_2OAWgt4_8ku5VHKZ4JfUw>
    <xmx:LO8DYG6F4yNg25yU_7kZevDtGwyBeD05P9Ib9EJWFfA5H9TdbabGjA>
    <xmx:LO8DYC5obFOXu5ioJj6p1q2J0hWI_Q25U-MKupTgBMJSc2EJ3PkhBA>
    <xmx:LO8DYN29nzIj2pupOVPFNHBtvETPpmLerNbipUKjMAz69Zgtalld7g>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3142B240057;
        Sun, 17 Jan 2021 03:02:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/5] devlink: Add ecn_mark trap
Date:   Sun, 17 Jan 2021 10:02:19 +0200
Message-Id: <20210117080223.2107288-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117080223.2107288-1-idosch@idosch.org>
References: <20210117080223.2107288-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add the packet trap that can report packets that were ECN marked due to RED
AQM.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 4 ++++
 include/net/devlink.h                             | 3 +++
 net/core/devlink.c                                | 1 +
 3 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index d875f3e1e9cf..c6026b44617e 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -480,6 +480,10 @@ be added to the following table:
      - ``drop``
      - Traps packets that the device decided to drop in case they hit a
        blackhole nexthop
+   * - ``ecn_mark``
+     - ``drop``
+     - Traps ECN-capable packets that were marked with CE (Congestion
+       Encountered) code point by RED algorithm instead of being dropped
 
 Driver-specific Packet Traps
 ============================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f466819cc477..dd0c0b8fba6e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -836,6 +836,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_GTP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_ESP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_NEXTHOP,
+	DEVLINK_TRAP_GENERIC_ID_ECN_MARK,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -1061,6 +1062,8 @@ enum devlink_trap_group_generic_id {
 	"esp_parsing"
 #define DEVLINK_TRAP_GENERIC_NAME_BLACKHOLE_NEXTHOP \
 	"blackhole_nexthop"
+#define DEVLINK_TRAP_GENERIC_NAME_ECN_MARK \
+	"ecn_mark"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..f86688bfad46 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9508,6 +9508,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(GTP_PARSING, DROP),
 	DEVLINK_TRAP(ESP_PARSING, DROP),
 	DEVLINK_TRAP(BLACKHOLE_NEXTHOP, DROP),
+	DEVLINK_TRAP(ECN_MARK, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
-- 
2.29.2

