Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4617BB94
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfGaIZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:25:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51758 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfGaIZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:25:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so59800522wma.1;
        Wed, 31 Jul 2019 01:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P6ek7nCICloFfkqqmazjjgTrHsnrmhfYJ1DCm67jzWo=;
        b=fwRJHyPAgvG2HVANNI5oru7wb9ZEELk200qyHKkBMZMdPB/MYbp1BQmynFAKIarO3E
         5QmzW8wq5sH/Sn1zGB3ZfTmsLErvg3+wRD/+lkbNms5PMHzZMl74KnUiGh+eUlzghPja
         Ro4oQ1Te1cZHmNa4yPvSbo8RMYekAlDRn893/DS62iZJrhqiTdZkj+S08l6sZZN+4ZPF
         QRuuDnFJbLMHdB4tHZIEZCyEL3cEViOJGco4Dr8IFWdeSWv5RIzG0dObOXEcHTXHw5gj
         Yh7e10pIrxCsBenstH6ESFddpe/iDoK8M9TvFQobmPSA8Knwl1oifLPxkIJbiGfKAnhw
         +P3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P6ek7nCICloFfkqqmazjjgTrHsnrmhfYJ1DCm67jzWo=;
        b=pKMBhc6ejXIAmTCa8GjrTvBf5yGJ4h/i6i+WRt9pWaMqProeW8t53IdYR7l/sA4NK2
         FlRm4lMJOKQjSycnLWCYPmVgRBDgkpmkd/+pEQLtixWsrVVnAYPGn62AlYRw/1f4sQTG
         a39MA8fL0oS3fTX5ZITPARZTw1FrmbDLqRrLZHsFaDXu+zqPXVsd1VcXymV5rTNMwfAQ
         MyAX++QM8GV8G6nVxedu8lmfFcMuq8GHqNbOWtwwmS0MH6Yy8ISdnv7eC5igk7aEbmpR
         8Rpnsy5ZQgauFvqQklsUHO0KBy7IbF2ZuX9XXW1MVbYo1CQkTNa6dLQkCjxGCds6mF2A
         0IXA==
X-Gm-Message-State: APjAAAXt2g1+ZsjL91TLN0riVmOojEANbRDKfQELZmeiGlFkgp5Dk26X
        rzyLQeoTmuSUZA+Rutsqy+3mqsUEDwI=
X-Google-Smtp-Source: APXvYqwNd/1iCGmmS4m5hrC0ENbW1WABEWYgEB5eBdOpPjhGk2I7hMFJco+zTMkQBOHp1LLgoclolg==
X-Received: by 2002:a1c:6c08:: with SMTP id h8mr20660524wmc.62.1564561546821;
        Wed, 31 Jul 2019 01:25:46 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c78sm93223959wmd.16.2019.07.31.01.25.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 01:25:46 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 3/6] net: dsa: mv88e6xxx: introduce invalid_port_mask in mv88e6xxx_info
Date:   Wed, 31 Jul 2019 10:23:48 +0200
Message-Id: <20190731082351.3157-4-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731082351.3157-1-h.feurstein@gmail.com>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this it is possible to mark certain chip ports as invalid. This is
required for example for the MV88E6220 (which is in general a MV88E6250
with 7 ports) but the ports 2-4 are not routed to pins.

If a user configures an invalid port, an error is returned.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  9 +++++++++
 drivers/net/dsa/mv88e6xxx/chip.h | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c8c176da0f1c..9fdcc21f0858 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2469,6 +2469,14 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	/* Setup Switch Port Registers */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
+		/* Prevent the use of an invalid port. */
+		if (mv88e6xxx_is_invalid_port(chip, i) &&
+		    !dsa_is_unused_port(ds, i)) {
+			dev_err(chip->dev, "port %d is invalid\n", i);
+			err = -EINVAL;
+			goto unlock;
+		}
+
 		if (dsa_is_unused_port(ds, i)) {
 			err = mv88e6xxx_port_set_state(chip, i,
 						       BR_STATE_DISABLED);
@@ -4270,6 +4278,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		 */
 		.num_ports = 7,
 		.num_internal_phys = 2,
+		.invalid_port_mask = BIT(2) | BIT(3) | BIT(4),
 		.max_vid = 4095,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 2cc508a1cc32..359d258d7151 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -106,6 +106,11 @@ struct mv88e6xxx_info {
 	unsigned int g2_irqs;
 	bool pvt;
 
+	/* Mark certain ports as invalid. This is required for example for the
+	 * MV88E6220 (which is in general a MV88E6250 with 7 ports) but the
+	 * ports 2-4 are not routet to pins.
+	 */
+	unsigned int invalid_port_mask;
 	/* Multi-chip Addressing Mode.
 	 * Some chips respond to only 2 registers of its own SMI device address
 	 * when it is non-zero, and use indirect access to internal registers.
@@ -571,6 +576,11 @@ static inline unsigned int mv88e6xxx_num_gpio(struct mv88e6xxx_chip *chip)
 	return chip->info->num_gpio;
 }
 
+static inline bool mv88e6xxx_is_invalid_port(struct mv88e6xxx_chip *chip, int port)
+{
+	return (chip->info->invalid_port_mask & BIT(port)) != 0;
+}
+
 int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 int mv88e6xxx_update(struct mv88e6xxx_chip *chip, int addr, int reg,
-- 
2.22.0

