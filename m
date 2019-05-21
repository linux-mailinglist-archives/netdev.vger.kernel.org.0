Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9398325851
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfEUTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:31:05 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36803 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbfEUTbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:31:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id a17so21982339qth.3
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u6/zSX/Gw7YsP1ocusCRs1UUOU2UPlGX11FqD3iD25E=;
        b=KZtg/OFwgJ9uZ3aafbgSNIETQWscYJ6EzScqQ7s3C0vOZyrbfpuNCeHZ0itYjayF/5
         HH4rDYr9wI+6CBZ9C1rBgROzkku6K9fH07xZ0zSjc1Uidofk3sEsNC8fmrWIN9nVS6Dp
         QtiJbbP01QB3fyep17JOMhmuGzjph060mFXyLLwapdUjurwFMdtzviAc47Sf3fKYbmAF
         sqfhhkrowb8wTPEOVFKZaF2F05e26gb5N6i+JyIymdPkl7LB8W2f7QTCCkslmj7Juhw2
         5TUhzfeL2OkLj+NS0QF1oQwK25CrzL/rpdXbg7R/J/0+L+4CLaujBtwE2btmvEil6nqK
         3uIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6/zSX/Gw7YsP1ocusCRs1UUOU2UPlGX11FqD3iD25E=;
        b=tqVj2ozt+DSMGM9Ja2NZNZyDpLF2qJParpYjSl1SHVksFLP3dwAyvPRFwzcB2ALYFd
         1ozceshWYtkEDMspf4McWZi+rN2Abl+gUwmP+Xjgp3Xhb2YI0jm8C5DOUllBIBZGGS2V
         wg6VL4f4x27LpIa9v9cD6J/7AWwLQJ9D4QZnNiHZJXtSsD5/+sB66j/qkbMnk/Wc4GAq
         mEBrd+ads04J4oW7ZAUab4lqWptoIz2kp55KqMUDB3W6VWN1xZ1WS2Cvk9UBAAzZz2xT
         w8Gq0s+XFfSi4dzePRq2SyMiQI3weSTHdLoagKIgkUGZoOxep5FnhRgfuFoIBtxsNuGV
         dw3g==
X-Gm-Message-State: APjAAAVI6dNhzbGQiouldGWTMEEoilbRmWBNKgSh3ZEV+kSKvx+lzUwh
        LMlAy6MV9MvI0QNxwxXviSca5bHz
X-Google-Smtp-Source: APXvYqyxwPohvoay1JQhRMJwqHdcG3Dbllj2ivK3BDTW/Nvj59pQAxdFAdhgVnw8O3BjVVxyciaatw==
X-Received: by 2002:ac8:31e2:: with SMTP id i31mr70130930qte.294.1558467060121;
        Tue, 21 May 2019 12:31:00 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s3sm12196985qtb.12.2019.05.21.12.30.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:30:59 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 6/9] net: dsa: mv88e6xxx: add default bus operations
Date:   Tue, 21 May 2019 15:30:01 -0400
Message-Id: <20190521193004.10767-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prepare the introduction of alternative busses, add a
default mv88e6xxx_bus_ops pointer to the mv88e6xxx_chip structure.

A bus may set the default operations if they aren't already set.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 10 ++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h |  3 +++
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 +++
 drivers/net/dsa/mv88e6xxx/smi.h  | 18 ------------------
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 28414db979b0..96e1886e05f0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -59,7 +59,10 @@ int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val)
 
 	assert_reg_lock(chip);
 
-	err = mv88e6xxx_smi_read(chip, addr, reg, val);
+	if (unlikely(!(chip->ops && chip->ops->read)))
+		return -EOPNOTSUPP;
+
+	err = chip->ops->read(chip, addr, reg, val);
 	if (err)
 		return err;
 
@@ -75,7 +78,10 @@ int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val)
 
 	assert_reg_lock(chip);
 
-	err = mv88e6xxx_smi_write(chip, addr, reg, val);
+	if (unlikely(!(chip->ops && chip->ops->write)))
+		return -EOPNOTSUPP;
+
+	err = chip->ops->write(chip, addr, reg, val);
 	if (err)
 		return err;
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index faa3fa889f19..860816ebb7ee 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -204,6 +204,9 @@ struct mv88e6xxx_chip {
 	/* This mutex protects the access to the switch registers */
 	struct mutex reg_lock;
 
+	/* The default registered bus operations */
+	const struct mv88e6xxx_bus_ops *ops;
+
 	/* The MII bus and the address on the bus that is used to
 	 * communication with the switch
 	 */
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 96f7d2685bdc..77c40596b678 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -154,5 +154,8 @@ int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
 	chip->bus = bus;
 	chip->sw_addr = sw_addr;
 
+	if (!chip->ops)
+		chip->ops = chip->smi_ops;
+
 	return 0;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/smi.h b/drivers/net/dsa/mv88e6xxx/smi.h
index 35e6403b65dc..566bfa174354 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.h
+++ b/drivers/net/dsa/mv88e6xxx/smi.h
@@ -38,22 +38,4 @@
 int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
 		       struct mii_bus *bus, int sw_addr);
 
-static inline int mv88e6xxx_smi_read(struct mv88e6xxx_chip *chip,
-				     int dev, int reg, u16 *data)
-{
-	if (chip->smi_ops && chip->smi_ops->read)
-		return chip->smi_ops->read(chip, dev, reg, data);
-
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_smi_write(struct mv88e6xxx_chip *chip,
-				      int dev, int reg, u16 data)
-{
-	if (chip->smi_ops && chip->smi_ops->write)
-		return chip->smi_ops->write(chip, dev, reg, data);
-
-	return -EOPNOTSUPP;
-}
-
 #endif /* _MV88E6XXX_SMI_H */
-- 
2.21.0

