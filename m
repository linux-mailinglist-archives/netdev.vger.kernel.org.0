Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FAAE2322
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfJWTJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:09:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38919 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731267AbfJWTJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 15:09:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so7211773wra.6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 12:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8T5uobR29ngBq+o6MSXEFDrW+y2OcR5m7yzsiWadG2c=;
        b=N77HtyKY7Dtuv/YiOEq4wNA2jgrD6L918t2vBgJb4qeg64GDzPq1B3ZxIW6OAgPDpF
         smYl5zaPmt59jBWwoHSHWds40OtlULQsaqS9RjkoODvDNt5ZLcwXoJj33++XeV21qv6e
         1il46QrtjIATt/vqbgKgjz/FeMo+C3qlbxdYzlcDIYjXnl7zspxG79V14msG9n+28S0X
         35ZU5YykJrcaVcBEYqyiyFjodQ8Q4wiBDRTAXD14eGCPZ7p3cpoG123PKKI4ruN/Jx4T
         JdnwxE4APwfZ5H2ZjxfXIGiW6MEQtezUofulRXo+7bMJLGPAn4naQICQXOukV3rykH7j
         w7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8T5uobR29ngBq+o6MSXEFDrW+y2OcR5m7yzsiWadG2c=;
        b=euFcg908udDRbms1XHCT2MuJrKabrrOJUvFUOFeXZLNk0YiRWEBxToFcBeonwF3ilt
         rprxye6NhuUzcKe+8paWwewpStNN0HjtoIDtrPt8kssFmFFlZjR9IOZ0xY3yuwbaP0FR
         EBn0vI0R/qGP6s/AuB7S2BEhc87XywRLeXE9aTsLcbJnfHj/BygseBL0HmPa+owSkQiX
         +jAqm8+ydjgiCSTAabSYbUrZhuNGuPoGzFFEWwnYRSbSUFB7hegF9I7wfiJ0wSKyY/If
         gdN7/1vunBiue7XEq1OhdIt9u+JaPE0CsQvNRRG1Zq2om0S6kuQXiY9Fo5nSUzy/8Ebe
         LXdA==
X-Gm-Message-State: APjAAAXt7K0hvJAe1EDBtQjs3AdBlqcgZiHoCTmWNoC1xj4ilQyReplD
        zhuyZjrgZAVKqXgr4Vwf1Xk+SSe8
X-Google-Smtp-Source: APXvYqw2aGHsVwufkUp7XjbiIunbhel8WR428G/JSkDrP8LrSQpLHBbhVOZbdBJ8YsON1pXsRUfepw==
X-Received: by 2002:a5d:6250:: with SMTP id m16mr247777wrv.322.1571857778544;
        Wed, 23 Oct 2019 12:09:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:2dc9:419b:b5f1:8890? (p200300EA8F2664002DC9419BB5F18890.dip0.t-ipconnect.de. [2003:ea:8f26:6400:2dc9:419b:b5f1:8890])
        by smtp.googlemail.com with ESMTPSA id w9sm15865930wrt.85.2019.10.23.12.09.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 12:09:37 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: align fix_features callback with vendor
 driver
Message-ID: <a6e8ef26-8748-6876-6bc4-57570096753f@gmail.com>
Date:   Wed, 23 Oct 2019 21:09:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch aligns the fix_features callback with the vendor driver and
also disables IPv6 HW checksumming and TSO if jumbo packets are used
on RTL8101/RTL8168/RTL8125.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c317af9c6..43ffd4f49 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1558,7 +1558,7 @@ static netdev_features_t rtl8169_fix_features(struct net_device *dev,
 
 	if (dev->mtu > JUMBO_1K &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06)
-		features &= ~NETIF_F_IP_CSUM;
+		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO);
 
 	return features;
 }
-- 
2.23.0

