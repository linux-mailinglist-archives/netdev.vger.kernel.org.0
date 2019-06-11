Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2403D680
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436458AbfFKTJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:09:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44582 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388777AbfFKTJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:09:32 -0400
Received: by mail-wr1-f68.google.com with SMTP id b17so14230481wrq.11
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dd3E+APfCq+4wzzddRBxP/cvIgwuWsL+fCAz0jhd3EA=;
        b=l/G1gRtV+0OSyHWaBV3w0bZJpWV6dM5N+4uZujztp8GOTQ4FF5jaD0y42X99HahN5A
         1VjXkERn5MWFjawGMqwWFiiqWGTy+keM4JvIoah/Q5jP9CImCVEBEnAB3hks7mEgd0Pq
         Z/2FYoUijHsMoqkkOoqwwpwmEmNRQFCpBRO73OL6SvRk1VxWxfAiixFQ0U7+qIfq2s3S
         S2lWEQ349lxdEQeUuwj5xJ8UiSXoTc+ntlfZ3WXSjT0RLx9ZTN4PtbAtGgpie8+dZmnx
         kuziFL4FCvM5HvulCRFs0MYZKogBhhfSbMDyz/nWxp8KYQBNL2Ac+dAuqH3/MZAeoUVu
         zzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dd3E+APfCq+4wzzddRBxP/cvIgwuWsL+fCAz0jhd3EA=;
        b=tXbzZyXD9nrGRsAC9cmVwDybm9C6fauZx2V8AHkTiBPvSw2JMtwRNMwj7m9CI688B2
         UU8FOKsa4271rnmxJgF0t9T2oB0JifjB4D28xKhLSdLJDhMBzkY8elEhcDFpbDTusKOH
         plGfxpbPaE9Q09F6YtqqN6JIxr778QKnKC6PSSsqgH1Epsr0zWTmbfkaSUVnbKRcOWeS
         /fYSDmEEHri+xvVeZRcx6X+wj/oTjWnI38iSuLA0HmwXm1y+RAYRqit0XpT/nA7H/VBn
         njmMz7e+9vr9QfWt/E9OqLGLCXZM3fWpYIQt57vr4TZjY4YVYK4WjKP5BAAOPW2KaENu
         5UKw==
X-Gm-Message-State: APjAAAUb77MJXCU91UwkWIW6IWKSaY69zsFocM5cBrHxKVYSxF2WqNBx
        nSRPjWqBy1YMh71EMupiMtVwm06j
X-Google-Smtp-Source: APXvYqxuj5YsZwOGGb+OkBbjRy7MNkVYekYtclMMn9WV7JXsEulGTxoXRkih88Uc6JrWwxz9AS8WeQ==
X-Received: by 2002:adf:e841:: with SMTP id d1mr51683790wrn.204.1560280171146;
        Tue, 11 Jun 2019 12:09:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:a5df:cfdb:a73:647? (p200300EA8BF3BD00A5DFCFDB0A730647.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:a5df:cfdb:a73:647])
        by smtp.googlemail.com with ESMTPSA id j189sm5729075wmb.48.2019.06.11.12.09.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 12:09:30 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve rtl_coalesce_info
Message-ID: <b3d61332-e45d-bc0c-db13-1017b92ef08a@gmail.com>
Date:   Tue, 11 Jun 2019 21:09:19 +0200
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

tp->coalesce_info is used in rtl_coalesce_info() only, so we can
remove this member. In addition replace phy_ethtool_get_link_ksettings
with a direct access to tp->phydev->speed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3d44a0769..8519f88ac 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -643,9 +643,7 @@ struct rtl8169_private {
 	void *Rx_databuff[NUM_RX_DESC];	/* Rx data buffers */
 	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
 	u16 cp_cmd;
-
 	u16 irq_mask;
-	const struct rtl_coalesce_info *coalesce_info;
 	struct clk *clk;
 
 	struct {
@@ -1785,18 +1783,16 @@ static const struct rtl_coalesce_info rtl_coalesce_info_8168_8136[] = {
 static const struct rtl_coalesce_info *rtl_coalesce_info(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	struct ethtool_link_ksettings ecmd;
 	const struct rtl_coalesce_info *ci;
-	int rc;
 
-	rc = phy_ethtool_get_link_ksettings(dev, &ecmd);
-	if (rc < 0)
-		return ERR_PTR(rc);
+	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
+		ci = rtl_coalesce_info_8169;
+	else
+		ci = rtl_coalesce_info_8168_8136;
 
-	for (ci = tp->coalesce_info; ci->speed != 0; ci++) {
-		if (ecmd.base.speed == ci->speed) {
+	for (; ci->speed; ci++) {
+		if (tp->phydev->speed == ci->speed)
 			return ci;
-		}
 	}
 
 	return ERR_PTR(-ELNRNG);
@@ -6829,11 +6825,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rtl_set_irq_mask(tp);
 
-	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
-		tp->coalesce_info = rtl_coalesce_info_8169;
-	else
-		tp->coalesce_info = rtl_coalesce_info_8168_8136;
-
 	tp->fw_name = rtl_chip_infos[chipset].fw_name;
 
 	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
-- 
2.22.0

