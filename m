Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610F1415E7E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241050AbhIWMjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56255 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241044AbhIWMju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7AF265C0081;
        Thu, 23 Sep 2021 08:38:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 23 Sep 2021 08:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gsTuW4JhNOaao3XeBOdE+TvwKTKsuKLa4jSYU5B17jc=; b=CYtYDBjt
        kjAO5qppjEcWPpDJU6XvWrHiuaPXPw/QkLBOqMY/WN5XUhJYnQrzs0oKevb9kJTw
        3ViiNALRaIOlMgsxOt6relQQ6KAO8X1365C3WKTnPA2PdMZEBqsxawQhtZIsiSvG
        MWS+KZv+cBD1BJgIKuCi5Up3VvHOlCwh/tauWeA8wPvINX0/C3Difv7OG7PIePVA
        0v6RwGFbT4AkxeIldcHCBwSVoI8dSmM5a4X0wFjSVFP9zRk6Aih+LjPZ/InDXPHa
        2+5jHo24FazVJguHwmPNnWKS2rKQUbvRLDcblOxxXMB6qvuCM5Oen1uqAm3YlJOh
        w7mmH2g3rXZbeg==
X-ME-Sender: <xms:OnVMYXt6oKns3Q2tTCwgsE0QNigYaow5--7A6wbORriKXB0UmsIggQ>
    <xme:OnVMYYfEuEKwS9DdsIV-0YVn7pDQtplqklqm7Rp8hQV370t30Uj-4QAonc5d3M3cQ
    NJtlbEpAGMhcLw>
X-ME-Received: <xmr:OnVMYaxPEZ-76XKnkP53A2gw36mUwUycnFmLo78YpPPx29Qxs5pLuCMfWLDvL_xd8I0fd8ZanVN6isllJSseXZa6r41BYs0b1G-3USyg1RudYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OnVMYWPgZifj3MpUscmzlnVDS_ABCdAocpIg4g3jaBs9nfsPExxDYQ>
    <xmx:OnVMYX9A7iXFxdMIwTcwKkg_wCrCiPanDV-V1idsUAkPy1A5LScEkQ>
    <xmx:OnVMYWUsXkxuQBCMahpT2USwQV5ytwQx4heTm_9f-a6LXMMiAYOlnA>
    <xmx:OnVMYSnUQNhau80pnDZWapsPi5i3BjbyF04gIpyEpkpDfEYc927CEA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/14] mlxsw: reg: Add support for rtdp_ipip6_pack()
Date:   Thu, 23 Sep 2021 15:36:53 +0300
Message-Id: <20210923123700.885466-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The RTDP register is used for configuring the tunnel decapsulation
properties of NVE and IP-in-IP.

Linux tunnels verify packets before decapsulation based on the packet's
source IP, which must match tunnel remote IP.
RTDP is used to configure decapsulation so that it filters out packets that
are not IPv6 or have the wrong source IP or wrong GRE key.

For IP-in-IP entry, source IPv4 is saved as part of this register and
source IPv6 is saved by RIPS register and RTDP saves pointer to it.

Create common function for configuring both IPv4 and IPv6 and add
dedicated functions for each protocol.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 31 +++++++++++++++++++----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 22f5c26fc0e7..f9f614e3c57c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8187,19 +8187,40 @@ static inline void mlxsw_reg_rtdp_pack(char *payload,
 }
 
 static inline void
-mlxsw_reg_rtdp_ipip4_pack(char *payload, u16 irif,
-			  enum mlxsw_reg_rtdp_ipip_sip_check sip_check,
-			  unsigned int type_check, bool gre_key_check,
-			  u32 ipv4_usip, u32 expected_gre_key)
+mlxsw_reg_rtdp_ipip_pack(char *payload, u16 irif,
+			 enum mlxsw_reg_rtdp_ipip_sip_check sip_check,
+			 unsigned int type_check, bool gre_key_check,
+			 u32 expected_gre_key)
 {
 	mlxsw_reg_rtdp_ipip_irif_set(payload, irif);
 	mlxsw_reg_rtdp_ipip_sip_check_set(payload, sip_check);
 	mlxsw_reg_rtdp_ipip_type_check_set(payload, type_check);
 	mlxsw_reg_rtdp_ipip_gre_key_check_set(payload, gre_key_check);
-	mlxsw_reg_rtdp_ipip_ipv4_usip_set(payload, ipv4_usip);
 	mlxsw_reg_rtdp_ipip_expected_gre_key_set(payload, expected_gre_key);
 }
 
+static inline void
+mlxsw_reg_rtdp_ipip4_pack(char *payload, u16 irif,
+			  enum mlxsw_reg_rtdp_ipip_sip_check sip_check,
+			  unsigned int type_check, bool gre_key_check,
+			  u32 ipv4_usip, u32 expected_gre_key)
+{
+	mlxsw_reg_rtdp_ipip_pack(payload, irif, sip_check, type_check,
+				 gre_key_check, expected_gre_key);
+	mlxsw_reg_rtdp_ipip_ipv4_usip_set(payload, ipv4_usip);
+}
+
+static inline void
+mlxsw_reg_rtdp_ipip6_pack(char *payload, u16 irif,
+			  enum mlxsw_reg_rtdp_ipip_sip_check sip_check,
+			  unsigned int type_check, bool gre_key_check,
+			  u32 ipv6_usip_ptr, u32 expected_gre_key)
+{
+	mlxsw_reg_rtdp_ipip_pack(payload, irif, sip_check, type_check,
+				 gre_key_check, expected_gre_key);
+	mlxsw_reg_rtdp_ipip_ipv6_usip_ptr_set(payload, ipv6_usip_ptr);
+}
+
 /* RIPS - Router IP version Six Register
  * -------------------------------------
  * The RIPS register is used to store IPv6 addresses for use by the NVE and
-- 
2.31.1

