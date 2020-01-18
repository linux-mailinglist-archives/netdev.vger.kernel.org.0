Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29F9141900
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 19:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgARSlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 13:41:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgARSlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 13:41:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VOWQE+XhPDGgi1MMb/e/wXow8yQzDUCAktcFJoWzfRY=; b=hUhWgfY/SeawDkyYfxEMzPG+lf
        xWCJWdR66QymkrQwSXPAQ0FJcnLvkX93tOASEWHmq2BLW8LgbAqrsFVSJ6pr4KeRe+kPgFvDc2pcS
        XhDONx2qYKqdjbceKjEU8zRapwSZC5bb3CMaLN3ho3/kHeHI814EHZcRQ0ExrXro0X60=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ist1p-0000JK-SV; Sat, 18 Jan 2020 19:41:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Add SERDES stats counters to all 6390 family members
Date:   Sat, 18 Jan 2020 19:40:56 +0100
Message-Id: <20200118184056.1153-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SERDES statistics are valid for all members of the 6390 family,
not just the 6390 itself. Add the needed callbacks to all members of
the family.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 04ef4d00f134..8c9289549688 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3845,6 +3845,9 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
@@ -3896,6 +3899,9 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
@@ -3946,6 +3952,9 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.phylink_validate = mv88e6390_phylink_validate,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_validate = mv88e6390_phylink_validate,
@@ -4092,6 +4101,9 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4486,6 +4498,9 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-- 
2.25.0.rc2

