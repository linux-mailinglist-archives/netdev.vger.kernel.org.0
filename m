Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF83B976
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfFJQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:32:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45467 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfFJQc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:32:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so9830195wre.12
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Ic5PlwGSWhh6JUvNjGvBJ9knGjzB4Va/zSsXrcJHQM=;
        b=gbZG2H4oFPTRclJD8QoVHT2Iga3QBwTsHbFJy+tHu67aIq2BOrhwrb1ExptLELJncD
         yoN1zbN5KEkK7XwmH4W1yekmexi1oW6gEL8Zu48GvPTVSePLTJ7aBh6lNPG6I0YPhfUB
         3HEMs+aRM3dYWyBBg7dSaVtHkAxyP13/oJsPDy2B6Gbh+B5KdTFZWe5VV3X5xKWN/XI+
         1MTumgcpOSAksQJGCiTl2dLYOZqz5m0QGtsZa+lHfvpmY/cMLxa4yyGh7BOKfjyJ2MVy
         VOC2RNJFu5Je640YotxoPRT3W0nXa9HkwCYPS0go6zkAO5KKH7O6N9GC4tkOu+/hNfjD
         JPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Ic5PlwGSWhh6JUvNjGvBJ9knGjzB4Va/zSsXrcJHQM=;
        b=bNvuLMwEgPVuULStlQaPLsqWchM75ONiLx8xr8IprVVGBwsVk9TXe0YOMDtYQp1xoX
         hJtlty+H6Q1j69hzbt1uhpQwcrO0Zor/UtgH1B7tff7r/0vdhTGgiiHbrtjZxZMEzgyj
         vsYTWw2RQyB+dXySyuDc70IB4adQKqd25NGKAjaLFm4Peyi0kVavGS1Q9RC7XFwPYB/z
         aFiEEVEGSoIdFmFTTXnWZ7TR56xxQypbYaxO2I15EJfJcxq/YdQJtrdyDiVaVCD/Vhxi
         DNsLeijijI4FDM6ZyIISXem3otrCJQ/NcNmFYN9x/dOUni2wA/KuhIjhdF1bDV8rWzwl
         M5ag==
X-Gm-Message-State: APjAAAWcqa04R4R2UqHiknfg+p1wYgkBivZ/+P/qNTF+l3BBgbsGi+Ob
        YdoWNMNUBj/9h81UDzxnWKjpU3nz
X-Google-Smtp-Source: APXvYqya4J68p3AyTUB08i5jnI0v5svpK1gzCleqHDNLB8kvaJ5h/8+6ulZtf5/5fklYVx9Ze02eVw==
X-Received: by 2002:adf:e8cb:: with SMTP id k11mr44704134wrn.244.1560183947036;
        Mon, 10 Jun 2019 09:25:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id r5sm21369797wrg.10.2019.06.10.09.25.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 09:25:46 -0700 (PDT)
Subject: [PATCH next 4/5] r8169: remove member coalesce_info from struct
 rtl_cfg_info
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Message-ID: <bc9b0740-f71f-346d-43c8-6a91cb202ad7@gmail.com>
Date:   Mon, 10 Jun 2019 18:24:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prepare removal of struct rtl_cfg_info, set the coalesce
config based on the chip version number.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4a53276da..65ae575ba 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6461,18 +6461,14 @@ static const struct net_device_ops rtl_netdev_ops = {
 
 static const struct rtl_cfg_info {
 	unsigned int has_gmii:1;
-	const struct rtl_coalesce_info *coalesce_info;
 } rtl_cfg_infos [] = {
 	[RTL_CFG_0] = {
 		.has_gmii	= 1,
-		.coalesce_info	= rtl_coalesce_info_8169,
 	},
 	[RTL_CFG_1] = {
 		.has_gmii	= 1,
-		.coalesce_info	= rtl_coalesce_info_8168_8136,
 	},
 	[RTL_CFG_2] = {
-		.coalesce_info	= rtl_coalesce_info_8168_8136,
 	}
 };
 
@@ -6850,7 +6846,11 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->max_mtu = jumbo_max;
 
 	rtl_set_irq_mask(tp);
-	tp->coalesce_info = cfg->coalesce_info;
+
+	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
+		tp->coalesce_info = rtl_coalesce_info_8169;
+	else
+		tp->coalesce_info = rtl_coalesce_info_8168_8136;
 
 	tp->fw_name = rtl_chip_infos[chipset].fw_name;
 
-- 
2.21.0


