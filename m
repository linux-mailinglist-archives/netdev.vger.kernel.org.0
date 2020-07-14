Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A0E21F8AA
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgGNR7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgGNR7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 13:59:19 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14039C061755;
        Tue, 14 Jul 2020 10:59:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w17so7327043ply.11;
        Tue, 14 Jul 2020 10:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=91FjHag+3XaZgvhfpG7MdugD127Z0nPtRrgH7hl2774=;
        b=Duuja7Als4Pl6fx9THJSzj2Z8JzD0eHBm2EvpCebLybRTC3v++/qxdEsWyVeA8NZRT
         75lCIuxEvI0Da0/P0tzwOqdmxGeTSAg/Ozcb4Nil8AW5BEtuMqHLapiFAPD2C2Dz2aSC
         FOeTZvOnQ1Dou9wsZYWzQ1ni7A/mKbFZ2DYpb9J82BYQDImWC64xAba0qbC3lxvxZNGu
         DQeVcNzviGI4+PJVjqffY8fBKEvjh4gp6h8YN1kzWkZLC4TJT4Ov8MILwenp7w7/HXkN
         64lNB92kO0Stl353M5HNXlbxdMQZ+jka1QibslVHl4ZFoN4YB/O6G6Ku8Ci2cgiT/Dup
         XnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=91FjHag+3XaZgvhfpG7MdugD127Z0nPtRrgH7hl2774=;
        b=k6E7c054NF7pkmbMHwzi0UdkyJ1ijo/f+9OlYPuWMzLzJDi73Qp46YPioAol5zNPxc
         Y8EUwE/+I20OKVXxNuqwIkBh2ojt/1qbwsHXYHMvc9vwc3r2qxP0IH6m3g5ZbXN4SN6T
         38RsUNGMvh3ikqPKcKfHDsW/FJfUfKYhvIILDicP+VhFRvV8yZvFwxtW7MhrjGMl/FQj
         tm0E0lFutIMB1nqDtLbH9stkRvuptNcntVCvkIyb78tXgKcaoxVAh77XjmutFQg5EWgo
         Q8GD6bRm0Rh2IEFfKdooSVz67CeRINmETr5DPbUvyYZURFYTeFarMAGOfsS/w1cBa0QJ
         znJg==
X-Gm-Message-State: AOAM532lXxACg3ut0QtWQNC9LDatbOOJ23xd7S7r4mJpbb71/ZgazdQ2
        aroKcUSs/zQXOaPE+voC+E8=
X-Google-Smtp-Source: ABdhPJyuNI2Fb/r4C3Xfff+HqzisTj70HHged34DAGvJEhqaiq1eekjxzrjmnpWtcRoF+NMsSbslkw==
X-Received: by 2002:a17:902:854c:: with SMTP id d12mr4916916plo.343.1594749558555;
        Tue, 14 Jul 2020 10:59:18 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:a2ce:c8ff:fe03:6cb0])
        by smtp.gmail.com with ESMTPSA id mg17sm3263969pjb.55.2020.07.14.10.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 10:59:17 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH net-next] net: phy: sfp: Cotsworks SFF module EEPROM fixup
Date:   Tue, 14 Jul 2020 10:59:10 -0700
Message-Id: <20200714175910.1358-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some Cotsworks SFF have invalid data in the first few bytes of the
module EEPROM.  This results in these modules not being detected as
valid modules.

Address this by poking the correct EEPROM values into the module
EEPROM when the model/PN match and the existing module EEPROM contents
are not correct.

Signed-off-by: Chris Healy <cphealy@gmail.com>
---
 drivers/net/phy/sfp.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 73c2969f11a4..2737d9b6b0ae 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1632,10 +1632,43 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 	return 0;
 }
 
+static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
+{
+	u8 check;
+	int err;
+
+	if (id->base.phys_id != SFF8024_ID_SFF_8472 ||
+	    id->base.phys_ext_id != SFP_PHYS_EXT_ID_SFP ||
+	    id->base.connector != SFF8024_CONNECTOR_LC) {
+		dev_warn(sfp->dev, "Rewriting fiber module EEPROM with corrected values\n");
+		id->base.phys_id = SFF8024_ID_SFF_8472;
+		id->base.phys_ext_id = SFP_PHYS_EXT_ID_SFP;
+		id->base.connector = SFF8024_CONNECTOR_LC;
+		err = sfp_write(sfp, false, SFP_PHYS_ID, &id->base, 3);
+		if (err != 3) {
+			dev_err(sfp->dev, "Failed to rewrite module EEPROM: %d\n", err);
+			return err;
+		}
+
+		/* Cotsworks modules have been found to require a delay between write operations. */
+		mdelay(50);
+
+		/* Update base structure checksum */
+		check = sfp_check(&id->base, sizeof(id->base) - 1);
+		err = sfp_write(sfp, false, SFP_CC_BASE, &check, 1);
+		if (err != 1) {
+			dev_err(sfp->dev, "Failed to update base structure checksum in fiber module EEPROM: %d\n", err);
+			return err;
+		}
+	}
+	return 0;
+}
+
 static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 {
 	/* SFP module inserted - read I2C data */
 	struct sfp_eeprom_id id;
+	bool cotsworks_sfbg;
 	bool cotsworks;
 	u8 check;
 	int ret;
@@ -1657,6 +1690,17 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	 * serial number and date code.
 	 */
 	cotsworks = !memcmp(id.base.vendor_name, "COTSWORKS       ", 16);
+	cotsworks_sfbg = !memcmp(id.base.vendor_pn, "SFBG", 4);
+
+	/* Cotsworks SFF module EEPROM do not always have valid phys_id,
+	 * phys_ext_id, and connector bytes.  Rewrite SFF EEPROM bytes if
+	 * Cotsworks PN matches and bytes are not correct.
+	 */
+	if (cotsworks && cotsworks_sfbg) {
+		ret = sfp_cotsworks_fixup_check(sfp, &id);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Validate the checksum over the base structure */
 	check = sfp_check(&id.base, sizeof(id.base) - 1);
-- 
2.21.3

