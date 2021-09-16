Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544C340ECBE
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhIPVmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbhIPVmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:42:08 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDDFC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:40:47 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id w29so11716297wra.8
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Z6BKfFbl7LMRo66b1N/jfXXC13JLghX+xmovn6fl1rM=;
        b=BHpaTolr1Br9nxpWDuZ3GCot0rR/PDtA1xqDIdnG+s6NW/ivkhRYJ2U43ln4bUMFHM
         c7/gVuCwfucgJ5yX6o3gr863fKSILS7aRuH57XQRGAs4Hq8g5/Rjk48+gFxp27F37faF
         I6JsAGYTbDO4X7E/kaX2cqW1grSH5R11KrTTYQfVk+USzI618ROCiCLC55NjcvDJCzXP
         39+/Y3QCVJPhjghLdq9IU3D7jfM8p1PqMWyOR6bB3nI8pR4+OGfc1Vb49wIbYb/9oLEX
         QhHzLySffUUzLq9vY7fZIQ777PlNFzJp6cD2C4QAznk7j/VHP+WydFa1YsPAkSm+eKMO
         vq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Z6BKfFbl7LMRo66b1N/jfXXC13JLghX+xmovn6fl1rM=;
        b=xilxi7Opft1InEAp1WstoXDs31hUVOfhBLOTgO5bFquZ0xd5UA/fFwlfH+jLh/FjEj
         ZywU6RPud1DtEy50dod7sWrsEjdyFNjxMfaELYMZCETtJWQ9n2sf27Oii0QzprlDKTKY
         RLgzvsyYoE675t0/0DFmAFM3el7i8NLoknfEqLZQci+tfwHw1vS4MRmbQ/pmxFGAwxHI
         0e/5Er5o+RELvrWsl6JEUCNcjL1h+fKDmTDF5cS2eWFBG8PNr3B4E74r9ahD/A4xZass
         mg7FF8kVgAQgS6ujbGYeWCf/+J8ZufpIujK9XPcSGtahPewHxKiz1ydKYZHMz6Gt6tYe
         ynQA==
X-Gm-Message-State: AOAM533LpOK30CoggC+rKqC2+9DDkkXfR106gb9nSaqDdR95z85IT0MG
        Ydz+3VduT7Vd5p4VFDuiGO8dDUGULTQ=
X-Google-Smtp-Source: ABdhPJwql43FgYl4pZecagg1+3vDJA4nHgMN+CsNtKArpyhN8ByVrn49uboeztR6nyERMcQ7XesZTw==
X-Received: by 2002:a05:6000:168b:: with SMTP id y11mr4136676wrd.350.1631828445965;
        Thu, 16 Sep 2021 14:40:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:1510:9d4f:bc4b:635b? (p200300ea8f08450015109d4fbc4b635b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:1510:9d4f:bc4b:635b])
        by smtp.googlemail.com with ESMTPSA id g1sm4680307wrr.2.2021.09.16.14.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 14:40:45 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] sky2: Stop printing VPD info to debugfs
Message-ID: <bbaee8ab-9b2e-de04-ee7b-571e094cc5fe@gmail.com>
Date:   Thu, 16 Sep 2021 23:40:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sky2 is parsing the VPD and adds the parsed information to its debugfs
file. This isn't needed in kernel, userspace tools like lspci can be
used to display such information nicely. Therefore remove this from
the driver.

lspci -vv:

Capabilities: [50] Vital Product Data
	Product Name: Marvell Yukon 88E8070 Gigabit Ethernet Controller
	Read-only fields:
		[PN] Part number: Yukon 88E8070
		[EC] Engineering changes: Rev. 1.0
		[MN] Manufacture ID: Marvell
		[SN] Serial number: AbCdEfG970FD4
		[CP] Extended capability: 01 10 cc 03
		[RV] Reserved: checksum good, 9 byte(s) reserved
	Read/write fields:
		[RW] Read-write area: 1 byte(s) free
	End

Relevant part in debugfs file:

0000:01:00.0 Product Data
Marvell Yukon 88E8070 Gigabit Ethernet Controller
 Part Number: Yukon 88E8070
 Engineering Level: Rev. 1.0
 Manufacturer: Marvell
 Serial Number: AbCdEfG970FD4

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/marvell/sky2.c | 84 +----------------------------
 1 file changed, 1 insertion(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e9fc74e54..3cb9c1271 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4440,86 +4440,6 @@ static const struct ethtool_ops sky2_ethtool_ops = {
 
 static struct dentry *sky2_debug;
 
-
-/*
- * Read and parse the first part of Vital Product Data
- */
-#define VPD_SIZE	128
-#define VPD_MAGIC	0x82
-
-static const struct vpd_tag {
-	char tag[2];
-	char *label;
-} vpd_tags[] = {
-	{ "PN",	"Part Number" },
-	{ "EC", "Engineering Level" },
-	{ "MN", "Manufacturer" },
-	{ "SN", "Serial Number" },
-	{ "YA", "Asset Tag" },
-	{ "VL", "First Error Log Message" },
-	{ "VF", "Second Error Log Message" },
-	{ "VB", "Boot Agent ROM Configuration" },
-	{ "VE", "EFI UNDI Configuration" },
-};
-
-static void sky2_show_vpd(struct seq_file *seq, struct sky2_hw *hw)
-{
-	size_t vpd_size;
-	loff_t offs;
-	u8 len;
-	unsigned char *buf;
-	u16 reg2;
-
-	reg2 = sky2_pci_read16(hw, PCI_DEV_REG2);
-	vpd_size = 1 << ( ((reg2 & PCI_VPD_ROM_SZ) >> 14) + 8);
-
-	seq_printf(seq, "%s Product Data\n", pci_name(hw->pdev));
-	buf = kmalloc(vpd_size, GFP_KERNEL);
-	if (!buf) {
-		seq_puts(seq, "no memory!\n");
-		return;
-	}
-
-	if (pci_read_vpd(hw->pdev, 0, vpd_size, buf) < 0) {
-		seq_puts(seq, "VPD read failed\n");
-		goto out;
-	}
-
-	if (buf[0] != VPD_MAGIC) {
-		seq_printf(seq, "VPD tag mismatch: %#x\n", buf[0]);
-		goto out;
-	}
-	len = buf[1];
-	if (len == 0 || len > vpd_size - 4) {
-		seq_printf(seq, "Invalid id length: %d\n", len);
-		goto out;
-	}
-
-	seq_printf(seq, "%.*s\n", len, buf + 3);
-	offs = len + 3;
-
-	while (offs < vpd_size - 4) {
-		int i;
-
-		if (!memcmp("RW", buf + offs, 2))	/* end marker */
-			break;
-		len = buf[offs + 2];
-		if (offs + len + 3 >= vpd_size)
-			break;
-
-		for (i = 0; i < ARRAY_SIZE(vpd_tags); i++) {
-			if (!memcmp(vpd_tags[i].tag, buf + offs, 2)) {
-				seq_printf(seq, " %s: %.*s\n",
-					   vpd_tags[i].label, len, buf + offs + 3);
-				break;
-			}
-		}
-		offs += len + 3;
-	}
-out:
-	kfree(buf);
-}
-
 static int sky2_debug_show(struct seq_file *seq, void *v)
 {
 	struct net_device *dev = seq->private;
@@ -4529,9 +4449,7 @@ static int sky2_debug_show(struct seq_file *seq, void *v)
 	unsigned idx, last;
 	int sop;
 
-	sky2_show_vpd(seq, hw);
-
-	seq_printf(seq, "\nIRQ src=%x mask=%x control=%x\n",
+	seq_printf(seq, "IRQ src=%x mask=%x control=%x\n",
 		   sky2_read32(hw, B0_ISRC),
 		   sky2_read32(hw, B0_IMSK),
 		   sky2_read32(hw, B0_Y2_SP_ICR));
-- 
2.33.0

