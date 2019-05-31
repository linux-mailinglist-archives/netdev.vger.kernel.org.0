Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B119C313A0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfEaRRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:17:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55738 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfEaRRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:17:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id 16so2074051wmg.5
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=MmpNCamRxKyBb505Dtlcwz4uww3I2Ci0X5YXkeqTIVw=;
        b=COHxbJCOSkSHzp5AymFYFDpkZQs+gfZl+UoDpybMwP1sEHbXNWHZHceJRSC2q+uFuM
         7Er3ENYEOYdyKGKzHke0Klzd604tEwhOHahGEoZU0N9XB8lhrVkB/n9806E5FzRBe4Dg
         r6XaXqwt4wdj5t6Ms7EX9XEBIWUglawSoTJ8My2KcfTEoDkrsCfd65o28NVF+OLNzVYa
         njYtMShemr905e3ex8d1nBPrbHnMin8A6shzvs371n0EXgo+afUKZyEG2Vi+lQyVE00Z
         FvWEPC4A/fhMEMWjGUiUcuy/q4toU/AZxRSxFZI8ylQ6rJJbk1RQz+3MS7HjHoe8K4V7
         ra6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MmpNCamRxKyBb505Dtlcwz4uww3I2Ci0X5YXkeqTIVw=;
        b=EtZOGJa1Ltqfw4MnAVWbDlqvqEy0+vyR7grJvJ5MrG08Bw43yOhaqP7aRGXrp7r2tt
         LcZ8/XWpFM+LB5CF5O7G1FkUaj/eKkIiTwuahowkA2C283SuG3idTDdyv8G7xxVjErdn
         JoX5LrYIkY+xlylF92q0ghCWD6UNpU2HBcEpDuORdLki+INPxS4xUNZwK4NM+SvOCYfR
         hSKD46JtBAOjhnoi/sqFtiqvjkKAClAw72FWbnrwN53nS9Oy5goHcu9pqrixm/RjXj+S
         N3Le10Y/3TQjjEOgh0pCskhc9Z7fQiGjtf4TIhbbVEoC3+RMM6TNJ+tmaEpddHVjjYSw
         3/mg==
X-Gm-Message-State: APjAAAXil0HKix0aFGNgS1BFJztTOs8zzm20/SO2+ckRfRH4AMH8oeST
        SOModyVIt2iY5rKX5ruS0Za/p9Zm
X-Google-Smtp-Source: APXvYqydaWZWbO1uOeeaVMm20l5zPe/VX7G4upoKL+/wqZk9+Iuo281NUUchyCEoRyEpL2dbyO8kUA==
X-Received: by 2002:a1c:2c89:: with SMTP id s131mr6639758wms.142.1559323043038;
        Fri, 31 May 2019 10:17:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id s62sm9154826wmf.24.2019.05.31.10.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:17:22 -0700 (PDT)
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: ethernet: improve eth_platform_get_mac_address
Message-ID: <98026ebf-4772-1d8d-1c0c-b75969172c80@gmail.com>
Date:   Fri, 31 May 2019 19:14:44 +0200
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

pci_device_to_OF_node(to_pci_dev(dev)) is the same as dev->of_node,
so we can simplify the code. In addition add an empty line before
the return statement.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethernet/eth.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 4b2b22237..b70d54829 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -549,17 +549,10 @@ unsigned char * __weak arch_get_platform_mac_address(void)
 
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
 {
-	const unsigned char *addr;
-	struct device_node *dp;
+	const unsigned char *addr = NULL;
 
-	if (dev_is_pci(dev))
-		dp = pci_device_to_OF_node(to_pci_dev(dev));
-	else
-		dp = dev->of_node;
-
-	addr = NULL;
-	if (dp)
-		addr = of_get_mac_address(dp);
+	if (dev->of_node)
+		addr = of_get_mac_address(dev->of_node);
 	if (IS_ERR_OR_NULL(addr))
 		addr = arch_get_platform_mac_address();
 
@@ -567,6 +560,7 @@ int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
 		return -ENODEV;
 
 	ether_addr_copy(mac_addr, addr);
+
 	return 0;
 }
 EXPORT_SYMBOL(eth_platform_get_mac_address);
-- 
2.21.0

