Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A26AEB4E
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731945AbfIJNTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:19:16 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44275 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731873AbfIJNTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:19:14 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so37358626iog.11;
        Tue, 10 Sep 2019 06:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PGf4uqNtKhSgsYrUbUsOONN58CSfCRcWAwzaxOjGmVg=;
        b=PnRrXJk1vGkVSH4RJbFU/bGuZOC90NTU/3gOMV+zZC/EDMwAZ94YDZLKMa5NZNVvGp
         Nark+svCyBwBQkKzbtHvoIiQj2bMD7KZ2nN7G/jhCHNA2ga9OwfKo7CAcMnDWrwrZhIG
         b8cXnAJ+LgzYg7gLXNcYwd+jpisaWeOsJmwrXomoUveL4F9THMr5g1l8kc7d+PkbqIPh
         SMqlZwGVysEviSfC5bSoVG92599Kl62n+Lim1K5mZUwb5rVGGdnLoEHO59v7UKVshgAU
         6b6G+EtK9EIJb8UdYsyHNkgRoVmcfAXkW6NfzBGjUeERRdmMkRcpbzeYidv5ekF5PsQe
         A3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PGf4uqNtKhSgsYrUbUsOONN58CSfCRcWAwzaxOjGmVg=;
        b=tQ/dnS2gLwDsA21wrGqMlSt4h+yxxPZCoULB/Aj0Ag3HR+CJWI309Vzw5LhMlsGXIR
         EFySZBPuVfC/29gerqHGuNVdzwGyP9y4G1JgJau1pJsXP2BChJUJID9nobxp15XRq4hK
         PnlXLyCgcups9dtx/tE85X6dbZge0Y1MQQIwvSlUPceYFs0ioLbbQ8KKc69twkQkNkEV
         GqTzPcRRzBbeNPbziLaWLXRfmVFa5rKAF7oWt41ayYfyhjZ1xI4YxgpJ3JT6okI/pYrS
         uskdtGDHgFn9tgfNSdOFYHOxgPASq7BCGGXVdU7KSU7WVafQzlLlCyrCwqqCZh7gwnEZ
         1q/w==
X-Gm-Message-State: APjAAAVv41y2EA924CkNY4jz+gi3YYIppgeaYSK5aD/mrqUtBOcmen22
        kk6jshjqTYMldzqkJxASjNHMxNTxmw==
X-Google-Smtp-Source: APXvYqxpS11UZsb95xfaXrUDUBIZUQ5TVthp7oU8ZtwbTGyvsfIB+P7Ohmpr574/AwJb1bsxGgreSA==
X-Received: by 2002:a5e:d60e:: with SMTP id w14mr5593278iom.215.1568121553332;
        Tue, 10 Sep 2019 06:19:13 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id f7sm13642740ioc.31.2019.09.10.06.19.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 06:19:12 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 2/3] net: dsa: microchip: add ksz9567 to ksz9477 driver
Date:   Tue, 10 Sep 2019 08:18:35 -0500
Message-Id: <20190910131836.114058-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190910131836.114058-1-george.mccollister@gmail.com>
References: <20190910131836.114058-1-george.mccollister@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the KSZ9567 7-Port Gigabit Ethernet Switch to the
ksz9477 driver. The KSZ9567 supports both SPI and I2C. Oddly the
ksz9567 is already in the device tree binding documentation.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Marek Vasut <marex@denx.de>
---

Changes since v1:
	- Added Reviewed-by.

 drivers/net/dsa/microchip/ksz9477.c     | 9 +++++++++
 drivers/net/dsa/microchip/ksz9477_i2c.c | 1 +
 drivers/net/dsa/microchip/ksz9477_spi.c | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 187be42de5f1..50ffc63d6231 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1529,6 +1529,15 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
 	},
+	{
+		.chip_id = 0x00956700,
+		.dev_name = "KSZ9567",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x7F,	/* can be configured as cpu port */
+		.port_cnt = 7,		/* total physical port count */
+	},
 };
 
 static int ksz9477_switch_init(struct ksz_device *dev)
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 79867cc2474b..0b1e01f0873d 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -77,6 +77,7 @@ MODULE_DEVICE_TABLE(i2c, ksz9477_i2c_id);
 static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9477" },
 	{ .compatible = "microchip,ksz9897" },
+	{ .compatible = "microchip,ksz9567" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 2e402e4d866f..f4198d6f72be 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -81,6 +81,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9893" },
 	{ .compatible = "microchip,ksz9563" },
 	{ .compatible = "microchip,ksz8563" },
+	{ .compatible = "microchip,ksz9567" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
-- 
2.11.0

