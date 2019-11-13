Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7AFBB4F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKMWDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:03:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39384 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfKMWDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 17:03:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id l7so4172107wrp.6
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 14:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5r31DwKobrQ9SSaPsklFKxvM/tsAsPnCi9BlHBU3MT4=;
        b=tbTdFb/dvgaG+hEWVLLLO76TFBhBxTgbrtQTHrwVDLnDi9d3r3Y3BZEcvbIH6fIokn
         hEGnakYdHdV8YUmhHALQxRDyya4S9rudDX/GBmhefl449VhZ5Rr3Quo59aT0sObTI405
         1fKol/HXUzRrDJbe6bhhZ0RlozdOZFFlv+PbNRBi78qHp7x5jWsuED0sG9Xj4vHPHr1/
         lpqcB4Kvtck7OgDyKMbNf6XfS+zecXATRQPHziSdgioUDVzH/ZpgjaqcrwLaF9WZ+Jav
         xsOaufuUjJtnxDGQ/tyGGzCUKCz2MZ3xaHGwoQjQivoThsdLA81jh589AzWOYWPUC8SD
         xMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5r31DwKobrQ9SSaPsklFKxvM/tsAsPnCi9BlHBU3MT4=;
        b=tLZgybcEGy6/Ptv60lZ/rQ7DdmgTCWH/o76T2m5R05IJgIh4G+uiqP2lhyMUNiYrDH
         CSvCfW/jRvehpJeT6h4Q/yi0h0WAXX2BuTxp5CnEy7+J2nuqQ3BEzuZSNAoAiCDL4oIJ
         8c+BlOERV0V47cbwzOpXK2+6KjmLl4ECu5SadLc3lQT0lUsjQ3/9Glh7hAJFl1lWlLQ0
         PQjlfBFR8+675Xw5zgyNeb8IHAZcb2APywc4psdACMFYz6FxAZuBRBu4snlTqTseZPj3
         2WLrfzkVvF9PHgyYdnlrYwkcpegOosZKgg402D+I6WjnGJX3ZS/qiy2hlpgOfO2ul52S
         JpTg==
X-Gm-Message-State: APjAAAWcwAlslAozpbZfUv5xL5/ZlibpCH2UzJp9Aa9jz3Dw5TD+KoK9
        2v06YIOC1scLfeRk6fPhUi+kJYAX
X-Google-Smtp-Source: APXvYqzuDON0vrzzo+A+caVxfmZs57dwgWk5iedfE6/pNELhzdgz2uAmz+euQx0roLI3C0SWtHar5g==
X-Received: by 2002:adf:e911:: with SMTP id f17mr1377053wrm.300.1573682610655;
        Wed, 13 Nov 2019 14:03:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:f8b2:b0b6:7d0e:ced4? (p200300EA8F2D7D00F8B2B0B67D0ECED4.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:f8b2:b0b6:7d0e:ced4])
        by smtp.googlemail.com with ESMTPSA id g4sm4057801wru.75.2019.11.13.14.03.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 14:03:30 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: use r8168d_modify_extpage in
 rtl8168f_config_eee_phy
Message-ID: <5ebacbf1-f586-25ad-8e19-a23746ded538@gmail.com>
Date:   Wed, 13 Nov 2019 23:03:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use r8168d_modify_extpage() also in rtl8168f_config_eee_phy() to
simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9a21ac962..8b33c1aa3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2324,11 +2324,7 @@ static void rtl8168f_config_eee_phy(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
 
-	phy_write(phydev, 0x1f, 0x0007);
-	phy_write(phydev, 0x1e, 0x0020);
-	phy_set_bits(phydev, 0x15, BIT(8));
-	phy_write(phydev, 0x1f, 0x0000);
-
+	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0, BIT(8));
 	r8168d_phy_param(phydev, 0x8b85, 0, BIT(13));
 }
 
-- 
2.24.0

