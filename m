Return-Path: <netdev+bounces-6927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BED6718B61
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D3531C20F22
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DDE19513;
	Wed, 31 May 2023 20:41:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F59B1640F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:41:38 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415CF123
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:41:35 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5162d2373cdso72179a12.3
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685565694; x=1688157694;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ZMOfcKnGqcoImGsFokF3a5xOY3TD6y7Yu6hFt34Z+w=;
        b=lY57rS3++ULwGCtZYxRpIcN/35SceHimFVdnEXN2dmnqogmwzjz0wcsaC6kX9Jpm8e
         e9WDXrpsrDLyExKkEANdvDEmGWY3yBqd3sYmXgeaN1uAgDaYE5hEopPr4RHay3ysS5hp
         RsS1XfL5Q03c2herf92H8avY6m5bWhKUWJgq1hVrOydFqKOzS3pI0zzTIr+9b+LydoaB
         brOHtQ5QI4mvMBk6tB3MMAHw+Is8ntdquuq4U0mtluPbi2baaNQxMIGVsBxNiXMGs7ey
         Tz2EDcC7SG+xm1vIsEVBqaUOELpPg/nZXNgyAM1vJ1Gbv08pA1jqJfWXJYzHku0Srz+u
         0oww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685565694; x=1688157694;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8ZMOfcKnGqcoImGsFokF3a5xOY3TD6y7Yu6hFt34Z+w=;
        b=Y8RNQdlJtBAAh8iwxplUddiFslu2chQFddr06AKpHNgTehMpxESugXE7g6Ew4pBrL6
         zAJu5T66nfKFPXOH0Qr97In1iFsl29iI6bRtl/pld0vEkOQ9bgPOzQGgUB2YfmZulydQ
         +RNW73Scr7h5yZV9oucj9ScE14nfoLrIlrwywKmHEUT+jrXiwG8GjIJs389pmJS1IaFl
         mAUXaaFbd/UhSoit60H9AaBQtVvEmnjbhtgtYKQQUp//zVBT4UjEYpw4b9lmUC2lx0j4
         zFcazluyGS2w1Sja+BKzpYUFVAk6QRnAl2kwjlYlLMwBv9OmgsgZrXuqGPuoWz0+hQu6
         vBNg==
X-Gm-Message-State: AC+VfDzB4l0wl3oZWJ7UpBkn5Sc8TTS03cOwiUhMWyZ+vUEwbl5dRjnA
	1KH55/GnxQaTEHA6HFhSYyY=
X-Google-Smtp-Source: ACHHUZ5Es4yuKMFu/FyfDG4W8UdKxBYoFoHYs7LZLSMjvgu+ULoxR9Cbk8NWTRF9rTYMHZ9EvAFoqA==
X-Received: by 2002:a17:907:94c7:b0:96f:aed9:2535 with SMTP id dn7-20020a17090794c700b0096faed92535mr6154119ejc.9.1685565693434;
        Wed, 31 May 2023 13:41:33 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c18f:4600:8999:532:b66e:c213? (dynamic-2a01-0c23-c18f-4600-8999-0532-b66e-c213.c23.pool.telefonica.de. [2a01:c23:c18f:4600:8999:532:b66e:c213])
        by smtp.googlemail.com with ESMTPSA id kb9-20020a1709070f8900b00967004187b8sm9522831ejc.36.2023.05.31.13.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 13:41:33 -0700 (PDT)
Message-ID: <f0596a19-d517-e301-b649-304f9247b75a@gmail.com>
Date: Wed, 31 May 2023 22:41:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>, David Miller <davem@davemloft.net>,
 Realtek linux nic maintainers <nic_swsd@realtek.com>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: use dev_err_probe in all appropriate places
 in rtl_init_one()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In addition to properly handling probe deferrals dev_err_probe()
conveniently combines printing an error message with returning
the errno. So let's use it for every error path in rtl_init_one()
to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 40 +++++++++--------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5e6308d57..9445f04f8 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5196,44 +5196,35 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "enable failure\n");
-		return rc;
-	}
+	if (rc < 0)
+		return dev_err_probe(&pdev->dev, rc, "enable failure\n");
 
 	if (pcim_set_mwi(pdev) < 0)
 		dev_info(&pdev->dev, "Mem-Wr-Inval unavailable\n");
 
 	/* use first MMIO region */
 	region = ffs(pci_select_bars(pdev, IORESOURCE_MEM)) - 1;
-	if (region < 0) {
-		dev_err(&pdev->dev, "no MMIO resource found\n");
-		return -ENODEV;
-	}
+	if (region < 0)
+		return dev_err_probe(&pdev->dev, -ENODEV, "no MMIO resource found\n");
 
 	rc = pcim_iomap_regions(pdev, BIT(region), KBUILD_MODNAME);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "cannot remap MMIO, aborting\n");
-		return rc;
-	}
+	if (rc < 0)
+		return dev_err_probe(&pdev->dev, rc, "cannot remap MMIO, aborting\n");
 
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
 
 	txconfig = RTL_R32(tp, TxConfig);
-	if (txconfig == ~0U) {
-		dev_err(&pdev->dev, "PCI read failed\n");
-		return -EIO;
-	}
+	if (txconfig == ~0U)
+		return dev_err_probe(&pdev->dev, -EIO, "PCI read failed\n");
 
 	xid = (txconfig >> 20) & 0xfcf;
 
 	/* Identify chip attached to board */
 	chipset = rtl8169_get_mac_version(xid, tp->supports_gmii);
-	if (chipset == RTL_GIGA_MAC_NONE) {
-		dev_err(&pdev->dev, "unknown chip XID %03x, contact r8169 maintainers (see MAINTAINERS file)\n", xid);
-		return -ENODEV;
-	}
-
+	if (chipset == RTL_GIGA_MAC_NONE)
+		return dev_err_probe(&pdev->dev, -ENODEV,
+				     "unknown chip XID %03x, contact r8169 maintainers (see MAINTAINERS file)\n",
+				     xid);
 	tp->mac_version = chipset;
 
 	tp->dash_type = rtl_check_dash(tp);
@@ -5253,10 +5244,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	rtl_hw_reset(tp);
 
 	rc = rtl_alloc_irq(tp);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "Can't allocate interrupt\n");
-		return rc;
-	}
+	if (rc < 0)
+		return dev_err_probe(&pdev->dev, rc, "Can't allocate interrupt\n");
+
 	tp->irq = pci_irq_vector(pdev, 0);
 
 	INIT_WORK(&tp->wk.work, rtl_task);
-- 
2.40.1


