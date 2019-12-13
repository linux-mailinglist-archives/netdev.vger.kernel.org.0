Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD911E71D
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfLMPxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:53:46 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35983 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbfLMPxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:53:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so7183410wru.3
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 07:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Bh+I6mecRAgwy+th0pDZMYWljKJ+F1wnFIHWqlTxTSw=;
        b=qqmrNKvA1Qx+VoXYvzX1GvCIA9tWcl9qT1/QpVn+gkucv2lc8N9mOSSVOIgabUq6qH
         PweThnpHrSpLwcVL4EYF6hsWgq3qzUtWbD5YV+aDjNqADsljCkJlw6zNn8YrlZ0cSn17
         4dJaOmLE4x3ZGWdIanGYX+dc5gdz4E9bErRGdtrUBGt50tskRJLR91mnrzrf3b3DW0hz
         4x/XsaZH4yLqrDjPcGMXYg/rs3ct1mjYv/mHkK6PCCIrtNMdEmFEHqNxmL+PjcXHQSW3
         0Qtt4Er5xq5xdFeegdhrPPud6PFcwrpDdpdKcC6z1uQDdFmDyULzFEtNGix+CfmbPa/d
         yymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Bh+I6mecRAgwy+th0pDZMYWljKJ+F1wnFIHWqlTxTSw=;
        b=GAvZGngzwGV2L8bgSwyuFvgf8TqpUzM33avczRyIoqF5EPx5foPxKpjwYLNN9G+NFX
         hl0Cg6/5j3nIIfdhiaEegE9wx2EVkG52r4ZHihE4/vZW5N9TA+e1paFNAiJkdjx87rsJ
         DkGM++Gagf8ayT7Jy+N2fuEdjV1W5gO0pDJRLlvRUGXxrenhgNutbzSPvmzcs9cHgX+T
         CJCDVhA3uNVx+5CcxovBoEm7X9MKKQIhEQMUT2NvyJtjijbBjcHqt9KwAhCi62D92SiC
         1o8Tv8wb1wE4oyIZPgLxe/WQeTYQEcjkqldr/DGoGepG8dqzvirA2P/ieCTzpInf7GB1
         z35A==
X-Gm-Message-State: APjAAAUTXhuj8yscW41JyhG2xz5n8dCKj0ojT3N5j97VR1GPxK2j+naQ
        fCt2SPrt2TtHL2IL4fy11EJ9NASW
X-Google-Smtp-Source: APXvYqwuvGpNIpmResP58g6a74eJE1kYTArWDs5lLVkB68iBRIpuwlMY1idU5+BFOxLfj/MXvNoZsw==
X-Received: by 2002:adf:db84:: with SMTP id u4mr13873115wri.317.1576252423337;
        Fri, 13 Dec 2019 07:53:43 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:855:b7f7:8ed0:867f? (p200300EA8F4A63000855B7F78ED0867F.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:855:b7f7:8ed0:867f])
        by smtp.googlemail.com with ESMTPSA id f16sm10665949wrm.65.2019.12.13.07.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 07:53:42 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: check that Realtek PHY driver module is
 loaded
Message-ID: <be869014-21a1-a2e3-5a9b-93ddb01200f5@gmail.com>
Date:   Fri, 13 Dec 2019 16:53:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some users complained about problems with r8169 and it turned out that
the generic PHY driver was used instead instead of the dedicated one.
In all cases reason was that r8169.ko was in initramfs, but realtek.ko
not. Manually adding realtek.ko to initramfs fixed the issues.
Root cause seems to be that tools like dracut and genkernel don't
consider softdeps. Add a check for loaded Realtek PHY driver module
and provide the user with a hint if it's not loaded.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 67a4d5d45..f27e4da10 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6825,6 +6825,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chipset, region;
 	int jumbo_max, rc;
 
+	/* Some tools for creating an initramfs don't consider softdeps, then
+	 * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
+	 * PHY driver is used that doesn't work with most chip versions.
+	 */
+	if (!driver_find("RTL8201CP Ethernet", &mdio_bus_type)) {
+		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+		return -ENOENT;
+	}
+
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
 	if (!dev)
 		return -ENOMEM;
-- 
2.24.1

