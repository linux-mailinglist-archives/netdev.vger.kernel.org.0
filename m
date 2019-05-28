Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FB32C687
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfE1Mbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:32 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58359 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727111AbfE1MbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 55AA725CC;
        Tue, 28 May 2019 08:22:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=UsyKIcPtGP/ohcmDT7p4YiTjmlwK0d3k9nuUAfdCgm0=; b=MEy+T99Q
        4XaFMI9XsScJiMQn71XeAIpFO31Sif4Hyqu8NvBEH5L6VG9e0NId+LXn03Ft1qXs
        lJXNBmBaMYYq8vy0nllVqRNC/T7Hg0Bvpj8YuEpjtHUV25CcDZc1ccT8Ra5DLHrU
        sFERRYKWXBzUynIPD7x2AZ/IfhQr6yh8NODsHWq+aM86zn1cGNHDUaWnMp722jyj
        I62Q0RZ4+tacIp7LrXAOtnNrVXywl/Z1l8IgWl140DrEyUvTa9xa1yHWEgrmXevR
        kSFRtjtYzI1eVgubARofQnA5djAcJx6DogjI20USN3Rs4kPU2IdOtxiQg2rbPkXj
        6Jbhur1PkGq2pA==
X-ME-Sender: <xms:IyjtXGKSN_lj5MhB7lzJE1_EwWoutCLgrjHuV7PXctjWSSE6j_A0NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeel
X-ME-Proxy: <xmx:IyjtXC3jNRgr1AaIUS7QOHlxNWK0I6UHhS_IlH6HW0yRoS2IpLzsFw>
    <xmx:IyjtXG-Qdo-2Gc1SL-07YUDTCCtDktij7e_GaJhQx1QXZIk0HCdx3g>
    <xmx:IyjtXPh1Uw7JeAtaCIC-OPn4xLLrsclSoQlec6OGjwCPXt2RwF10YA>
    <xmx:IyjtXGHlB-U489-jphDf_x0axOD56LowOkCWl_6BpaOzEn-x3JewMw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE2CD380073;
        Tue, 28 May 2019 08:22:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 10/12] mlxsw: Add layer 2 discard trap IDs
Date:   Tue, 28 May 2019 15:21:34 +0300
Message-Id: <20190528122136.30476-11-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add the trap IDs used to report layer 2 drops.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/trap.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 451216dd7f6b..a7965acdca81 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -64,6 +64,13 @@ enum {
 	MLXSW_TRAP_ID_NVE_ENCAP_ARP = 0xBD,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
+	MLXSW_TRAP_ID_DISCARD_ING_PACKET_SMAC_MC = 0x140,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VTAG_ALLOW = 0x148,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VLAN = 0x149,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_STP = 0x14A,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_UC = 0x150,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_MC_NULL = 0x151,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_LB = 0x152,
 	MLXSW_TRAP_ID_ACL0 = 0x1C0,
 	/* Multicast trap used for routes with trap action */
 	MLXSW_TRAP_ID_ACL1 = 0x1C1,
-- 
2.20.1

