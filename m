Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5040B3D67F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390614AbfFKTJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:09:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38589 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388777AbfFKTJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:09:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so14237579wrs.5
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1py4XRh1jOAy2JIX2f85a/7FnYk5OkufV2gBQGkiXWs=;
        b=GnOiy4NkiGcYeNcP25w7+wC7d9I8jQzbAUVoYnMkoKmqOnbJPOORvWTl+h1KsH7Ehc
         4h27byn2tBmloxOhvMBRXiMcYpktoExz/kNhHQDYhtu7QyjDkHGSdeRRvSHxQwoZnYOY
         1d3PCf+yRJEbc25YtsoR7V/X49JrgQoJ6pviJLb0RNIFg5G6UL7utb3D3wjz8fJKi+Tp
         //oQa4rcxyBlC5zINY3qK505y7Iw8G+sbbMxFvT4oNGxb4OPR/VDcku98uw4Fd47eQ48
         5+onyRTkOkWQ7yjXanIQ908l8DWX5gGIXMCC67zDVlfkN5lUC3CV5G3VXEG1y7GOAmy/
         PCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1py4XRh1jOAy2JIX2f85a/7FnYk5OkufV2gBQGkiXWs=;
        b=qVbuc5oFfqcUCEn/r2pxgkH1DMLyfKjAf9eQD7n7c5J8YiPRMRQkZKEHw0udRR+hdd
         m/AXnAXygyFHowHBfnqkjG6eagA/F19jgPAVLXgAjei7ihtmLtBS2J1E0rhttHD5ay16
         /tiFjIUOkXWcwBXFEBPi/HC3uWRHQzo5HZ4UfhLgDTMgCv65tAcjfRYpCZhMYiGXvTCw
         t/GxvssK0Vf9xv8gKhozlYBs1IQ14XrBXn8gcNltZmYI8I17Yk6M+O1cN6E2yGpcRdhz
         b57JOUZ9IFsg5QJ+bOUdkzHfjL8kFm5zy3/Q+TigTE01ZO+qRWpzxyCzqQ3JZ4tibLYn
         rtnw==
X-Gm-Message-State: APjAAAWQy2UA2LUG7e4mhJVqPacFXBkdLUU8CGVzs+KS+zXbBEsVe9jK
        pi86cXx7f4biXmQK0Pa/t+O3U0J8
X-Google-Smtp-Source: APXvYqy3G7qIgnR1V2A/ERalJaZ1Ci3F9pQCiXC9BIFAFHmYVnneseCDugdo62i2t01W53XEqMqImw==
X-Received: by 2002:adf:d081:: with SMTP id y1mr5340233wrh.34.1560280169344;
        Tue, 11 Jun 2019 12:09:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:a5df:cfdb:a73:647? (p200300EA8BF3BD00A5DFCFDB0A730647.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:a5df:cfdb:a73:647])
        by smtp.googlemail.com with ESMTPSA id o1sm19139185wre.76.2019.06.11.12.09.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 12:09:28 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: let mdio read functions return -ETIMEDOUT
Message-ID: <c48b74a5-d888-8338-095d-82d8a4adee6e@gmail.com>
Date:   Tue, 11 Jun 2019 21:04:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of a timeout currently ~0 is returned. Callers often just check
whether a certain bit is set and therefore may behave incorrectly.
So let's return -ETIMEDOUT in case of a timeout.

r8168_phy_ocp_read is used in r8168g_mdio_read only, therefore we can
apply the same change.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ca26cd659..3d44a0769 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -814,7 +814,7 @@ static void r8168_phy_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 	rtl_udelay_loop_wait_low(tp, &rtl_ocp_gphy_cond, 25, 10);
 }
 
-static u16 r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
+static int r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
 {
 	if (rtl_ocp_reg_failure(tp, reg))
 		return 0;
@@ -822,7 +822,7 @@ static u16 r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
 	RTL_W32(tp, GPHY_OCP, reg << 15);
 
 	return rtl_udelay_loop_wait_high(tp, &rtl_ocp_gphy_cond, 25, 10) ?
-		(RTL_R32(tp, GPHY_OCP) & 0xffff) : ~0;
+		(RTL_R32(tp, GPHY_OCP) & 0xffff) : -ETIMEDOUT;
 }
 
 static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
@@ -905,7 +905,7 @@ static int r8169_mdio_read(struct rtl8169_private *tp, int reg)
 	RTL_W32(tp, PHYAR, 0x0 | (reg & 0x1f) << 16);
 
 	value = rtl_udelay_loop_wait_high(tp, &rtl_phyar_cond, 25, 20) ?
-		RTL_R32(tp, PHYAR) & 0xffff : ~0;
+		RTL_R32(tp, PHYAR) & 0xffff : -ETIMEDOUT;
 
 	/*
 	 * According to hardware specs a 20us delay is required after read
@@ -945,7 +945,7 @@ static int r8168dp_1_mdio_read(struct rtl8169_private *tp, int reg)
 	RTL_W32(tp, EPHY_RXER_NUM, 0);
 
 	return rtl_udelay_loop_wait_high(tp, &rtl_ocpar_cond, 1000, 100) ?
-		RTL_R32(tp, OCPDR) & OCPDR_DATA_MASK : ~0;
+		RTL_R32(tp, OCPDR) & OCPDR_DATA_MASK : -ETIMEDOUT;
 }
 
 #define R8168DP_1_MDIO_ACCESS_BIT	0x00020000
-- 
2.21.0

