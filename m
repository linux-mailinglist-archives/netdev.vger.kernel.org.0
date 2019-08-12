Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72CF8A6F9
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfHLTUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:20:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38964 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfHLTUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 15:20:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so15447510wra.6
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 12:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nnkw3EWX2EFFH32j4yzzs8cffS7W5aMdUKZ7t3ZeW3I=;
        b=Jc0Pw5aWPakjL0KI2VfWx6tjV4RQ5vQMxsLxO6bJ2lT5odsRmQEI3VLSis/yb3X78P
         iIyE1Ay69/ZwWJoYJJYnrDSxBNj0M87mISdJPkLKvGXsKhruoNHD+QdvBSvOV1jQDQkn
         Pj3cty+idTFqVl+nNdNmj1UBlOJVx85rjE/Ga8s0xKTferC8GnQbKde+Ae8SnpKriZqS
         wS+fcC48/NfHOI+SMOuBo51CZ7TPOpRjtSLvfO3QiqaHVdsc3lnGcWgC6oIvIIGjshBg
         WU3HtlOFXs2mB/NijvyXfR4ZGE41nCfB2YypvZT2ESz6ODJp7vl/ZdgLuTR7qfyzAvWv
         Z22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nnkw3EWX2EFFH32j4yzzs8cffS7W5aMdUKZ7t3ZeW3I=;
        b=tSkvSfgw4crHEPBRNuiasxtYnSeUQ8/IgeM0RMENQK42J+TiRkuRyUOPse0UnQXFHn
         4hfyCJPaf6OD9LE16osRXr8gASax96prlojB3rR7sQLqyMK6ZbS5Kv1DM+u0iIGflH3f
         /ai0q7M74GvNQbSNpbaV/AFeb2OFgoEwmB1Rm12MsL3DZkystkFTs0d0IYosm+hiZXZK
         TgVr4fhASm45H97OD5Pti99yK57ir9kTXuBrJd1QTp/h31q+Z0AP1FxtjRiW5qZs6VYT
         J2hXk47106S4eCY1rNQm21xLWXh7rZRhHw+NxLVl5GUbg3vG0PfEPS40c93L+82GLDuN
         aZwg==
X-Gm-Message-State: APjAAAWqDtYsuPQeu3cVPIono93ZX+QJltbpptTGKTiFa6QqFiXnB9az
        vXSbHzZ6ErmY9jnEbbK9gRlGZvCp
X-Google-Smtp-Source: APXvYqyJ98a2Rgg45Nf3VfyErQJrqEHDxxjsr58Lrn+mDLRKVtN3oKlmI7TzSdcpyB2eXRVSEysJAw==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr18157685wrp.113.1565637610867;
        Mon, 12 Aug 2019 12:20:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id 74sm863828wma.15.2019.08.12.12.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 12:20:10 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: consider AN_RESTART status when reading link
 status
Message-ID: <46efcf9f-0938-e017-706c-fb5a400f6fbb@gmail.com>
Date:   Mon, 12 Aug 2019 21:20:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After configuring and restarting aneg we immediately try to read the
link status. On some systems the PHY may not yet have cleared the
"aneg complete" and "link up" bits, resulting in a false link-up
signal. See [0] for a report.
Clause 22 and 45 both require the PHY to keep the AN_RESTART
bit set until the PHY actually starts auto-negotiation.
Let's consider this in the generic functions for reading link status.
The commit marked as fixed is the first one where the patch applies
cleanly.

[0] https://marc.info/?t=156518400300003&r=1&w=2

Fixes: c1164bb1a631 ("net: phy: check PMAPMD link status only in genphy_c45_read_link")
Tested-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-c45.c    | 14 ++++++++++++++
 drivers/net/phy/phy_device.c | 12 +++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index b9d414578..58bb25e4a 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -219,6 +219,20 @@ int genphy_c45_read_link(struct phy_device *phydev)
 	int val, devad;
 	bool link = true;
 
+	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		if (val < 0)
+			return val;
+
+		/* Autoneg is being started, therefore disregard current
+		 * link status and report link as down.
+		 */
+		if (val & MDIO_AN_CTRL1_RESTART) {
+			phydev->link = 0;
+			return 0;
+		}
+	}
+
 	while (mmd_mask && link) {
 		devad = __ffs(mmd_mask);
 		mmd_mask &= ~BIT(devad);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index b039632de..163295dbc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1741,7 +1741,17 @@ EXPORT_SYMBOL(genphy_aneg_done);
  */
 int genphy_update_link(struct phy_device *phydev)
 {
-	int status;
+	int status = 0, bmcr;
+
+	bmcr = phy_read(phydev, MII_BMCR);
+	if (bmcr < 0)
+		return bmcr;
+
+	/* Autoneg is being started, therefore disregard BMSR value and
+	 * report link as down.
+	 */
+	if (bmcr & BMCR_ANRESTART)
+		goto done;
 
 	/* The link state is latched low so that momentary link
 	 * drops can be detected. Do not double-read the status
-- 
2.22.0

