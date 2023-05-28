Return-Path: <netdev+bounces-5959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A58B713B25
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 853FE1C20975
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D5D567E;
	Sun, 28 May 2023 17:35:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E242F3D
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:35:18 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C0DBE
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:35:17 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5149c51fd5bso704170a12.0
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685295315; x=1687887315;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cj365/JQiEDVMfbC0p5rg2f+3RSJRHh7P6pnW9O2PUU=;
        b=VIcbye2MuIGI7s2S2jdJPzvOZyekYz7cCQoyyTxmCMeeIIXK9m2unHt46NzZ7ZnAQZ
         NCqwD3L08bTPqQRcuz3OmU/qg5IIL/GZ2nZ1t7/0rn31mq5xpOoeV6LnrkOS+xlXum2Y
         fH/cO9OL70DYIIr0fkqn+Vwc+7hcpLn1XBJeKVtmS6uHVwcH1guilrAQOx+x5/rD6g4i
         byhO5ZCt5/z1AqMX8f0aUJudl8IXd4V9Mh9e3LDFBlATzi2smIqTu152m/CnGD6/iJpo
         I2CwfrUWqOd7cqziraitOxjJAkr67VGl4l/nBvOdqXRO/WBnR3Rtyleigv9uIvXGiEbM
         xwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685295315; x=1687887315;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Cj365/JQiEDVMfbC0p5rg2f+3RSJRHh7P6pnW9O2PUU=;
        b=AQKbRwmBjdHBtGnm0wsyefJxDHtU45fF7U/3BMWYsOWJjUdvtHzhIq/Pu78o6CQix/
         ZnhsqvhgNrJO8iOZS8+LMaHItl4RQ5cVNtkdUKGvF6fv9S/JdFBYjQYHzsoyHp0fXA7b
         lTpWbIz8WRK757qITtS/mvT/bV4bQ5K61CcKKDAoi94wvci+4qw79GTvbDjOagy/cviG
         Utlp5gMCsHr+vkYUwP266ltLwWR9nLsOf4qTpB/GBfdcMubBIG+OJxSzUmvXhd48PLfn
         XqZbVOlNSKI0MOPfvNfsfvji05wNXA+VzifXHwDg+m0vbvrsHPLoDfY9b33nANJbEvxp
         ke2g==
X-Gm-Message-State: AC+VfDx+IMX2i3eqcdCvkIPwla4Sq2NDADsGpZL23DTXKMM12kFM4VdW
	xOYh7ZQHwFICzJ1gCwxkZes=
X-Google-Smtp-Source: ACHHUZ4UByKptwopJ3FW7TvGSNh//YD11SuUfodWgqnaB5Zo12qBWvo06iCGqMF+Ykx0DodBLouXxQ==
X-Received: by 2002:aa7:c40f:0:b0:514:75c3:2691 with SMTP id j15-20020aa7c40f000000b0051475c32691mr8074474edq.27.1685295314622;
        Sun, 28 May 2023 10:35:14 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6f2c:fe00:a151:3e12:d4b2:cf2f? (dynamic-2a01-0c22-6f2c-fe00-a151-3e12-d4b2-cf2f.c22.pool.telefonica.de. [2a01:c22:6f2c:fe00:a151:3e12:d4b2:cf2f])
        by smtp.googlemail.com with ESMTPSA id f22-20020a50ee96000000b0050c0d651fb1sm2158586edr.75.2023.05.28.10.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 May 2023 10:35:14 -0700 (PDT)
Message-ID: <75b54d23-fefe-2bf4-7e80-c9d3bc91af11@gmail.com>
Date: Sun, 28 May 2023 19:35:12 +0200
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
Subject: [PATCH net-next] r8169: check for PCI read error in probe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Check whether first PCI read returns 0xffffffff. Currently, if this is
the case, the user sees the following misleading message:
unknown chip XID fcf, contact r8169 maintainers (see MAINTAINERS file)

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4b19803a7..5e6308d57 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5164,6 +5164,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int jumbo_max, region, rc;
 	enum mac_version chipset;
 	struct net_device *dev;
+	u32 txconfig;
 	u16 xid;
 
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
@@ -5218,7 +5219,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
 
-	xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;
+	txconfig = RTL_R32(tp, TxConfig);
+	if (txconfig == ~0U) {
+		dev_err(&pdev->dev, "PCI read failed\n");
+		return -EIO;
+	}
+
+	xid = (txconfig >> 20) & 0xfcf;
 
 	/* Identify chip attached to board */
 	chipset = rtl8169_get_mac_version(xid, tp->supports_gmii);
-- 
2.40.1


