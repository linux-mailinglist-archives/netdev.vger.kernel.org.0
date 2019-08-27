Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC39F292
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfH0SnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:43:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55420 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730435AbfH0SnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:43:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so133621wmf.5
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mTLg+GADpFhVe3bvABgvD4qLIycEtZFZr3LYiiiApsQ=;
        b=eLRWFXu2wRDkv6LR5NyPYiFjE6s7vxe88lN63dZGmF4g48n3MMJPhrgWA9msDxZrAl
         E8L8BOy3t8PnzWXZlBlhGrzzf0IY48+0UVi2WNwQw4upThwaNOH7OxgcgSY1iFXZykIp
         DMA6biUmWCnzWoA1DSQRswXgyCvjW/SfFDuyJOAoMpb77haCJVODJFTZ1P9cA/774SNW
         njcZj8Hk5Ir+vvRn6ZU/YKzPs+T1xy6J8gQtWMVGgm1BTF90jquGqL76UDs4liwoRtDR
         gYilafcdW8i0QKDv8RKtwO/6RdvrSmwn1qpM97NM09vKsjBtQzsbrCthIs70ZEx+T2yM
         x60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mTLg+GADpFhVe3bvABgvD4qLIycEtZFZr3LYiiiApsQ=;
        b=gL5s/TU0gfCqmRVue3qN34diMYUmJ2L25UkTw12zZiqFCGvd6A1LuKpaQFukhA6EFM
         xVImA4rsTPM3buyYPE8um6QFTiBE+fwVve08pNwe1/2ETPEmdZCKi1KiaX0WgxV8ebS8
         Mf6rRHWS0/ReQaaB4nj6SWIWkbRJY/TWq7USQRodwx1cojDDVg9LqmkaQeXLGm6UrIrg
         MAKLmGNQPyIs2PqdRJDq3ZVo846+AvKLvwaYoba/+NSkj73Cl8aflafceog6BlQTF38h
         X3tXJTYWSpvThK2ve78VEZlHaMBm2+QUSDWjCwGk4CRRLzxM/W/uswsu84czbX0u3hmM
         ahEw==
X-Gm-Message-State: APjAAAUy5p4nRjDl/KzHkJb3MCBy6aa46/n00gU8k+ofn9anUygDemOd
        1phPSRoCEZgNYRl5j8/CItg=
X-Google-Smtp-Source: APXvYqwW3FXvDwNq9gsiHg/SN7sLp2NjO6/bY0IvC5QxJ1rx+fQJd8IQB4qVqWU6/nvmBbOlyfyN9w==
X-Received: by 2002:a1c:cb0b:: with SMTP id b11mr412562wmg.95.1566931387667;
        Tue, 27 Aug 2019 11:43:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0? (p200300EA8F047C0004DC3C3331AAF4C0.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0])
        by smtp.googlemail.com with ESMTPSA id i93sm33273528wri.57.2019.08.27.11.43.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:43:07 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: add support for EEE on RTL8125
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
Message-ID: <cc93aedc-aa1b-fe52-414d-34c17e6feace@gmail.com>
Date:   Tue, 27 Aug 2019 20:42:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds EEE support for RTL8125 based on the vendor driver.
Supported is EEE for 100Mbps and 1Gbps. Realtek recommended to not yet
enable EEE for 2.5Gbps due to potential compatibility issues. Also
ethtool doesn't support yet controlling EEE for 2.5Gbps and 5Gbps.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d9adc45fa..b00dbee0c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2271,6 +2271,12 @@ static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
 	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_1111, 0x0003);
 }
 
+static void rtl8125_config_eee_mac(struct rtl8169_private *tp)
+{
+	r8168_mac_ocp_modify(tp, 0xe040, 0, BIT(1) | BIT(0));
+	r8168_mac_ocp_modify(tp, 0xeb62, 0, BIT(2) | BIT(1));
+}
+
 static void rtl8168f_config_eee_phy(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
@@ -2301,6 +2307,16 @@ static void rtl8168h_config_eee_phy(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xa42, 0x14, 0x0000, 0x0080);
 }
 
+static void rtl8125_config_eee_phy(struct rtl8169_private *tp)
+{
+	struct phy_device *phydev = tp->phydev;
+
+	rtl8168h_config_eee_phy(tp);
+
+	phy_modify_paged(phydev, 0xa6d, 0x12, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
+}
+
 static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
 {
 	static const struct phy_reg phy_reg_init[] = {
@@ -3672,6 +3688,9 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
 	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+
+	rtl8125_config_eee_phy(tp);
+	rtl_enable_eee(tp);
 }
 
 static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
@@ -3741,6 +3760,9 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xad4, 0x17, 0x0010, 0x0000);
 	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+
+	rtl8125_config_eee_phy(tp);
+	rtl_enable_eee(tp);
 }
 
 static void rtl_hw_phy_config(struct net_device *dev)
@@ -5263,6 +5285,8 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 
 	rtl_udelay_loop_wait_low(tp, &rtl_mac_ocp_e00e_cond, 1000, 10);
 
+	rtl8125_config_eee_mac(tp);
+
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
 	udelay(10);
 }
-- 
2.23.0


