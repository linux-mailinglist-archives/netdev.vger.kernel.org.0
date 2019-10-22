Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B34CE0C9A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbfJVTbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:31:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34805 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:31:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so14227496wrr.1
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 12:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wSMEXejgCIcwwOT5GveClNuwI8GMCN1kEPWycEylMM8=;
        b=CAEg3AOijmJuZhbOzda7g6ms+GTvzLGwPohwBmslpMEXB0Dn5bnlKG59PvMVUY1FcI
         mNGsdYJeYnHtOogiwFu+xQHIqvFKYiMzftOveX1ODPH+jDT/f+LoRs0jha/YS1fWDHwL
         WFEwhEve87zlNK4t0G4YQbMG5CAtTMBKYRsrb6zWOs2KiCWHd2/AbqVwiCG2GN/RAsKE
         xYLqqKSrH7gf7DcILX0YOs76iyQ4MDJicGvupLTLsgvWa6kkWtfViVYG4BxnXHjiBBqN
         t9xAkzLbwGFkleNTGIqTNpouIYMABsF+Aqaos9hikRiQDY+Ijz1BfLCmPMB+eNoWtXEk
         +28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wSMEXejgCIcwwOT5GveClNuwI8GMCN1kEPWycEylMM8=;
        b=EmLOZ6pWixtP26rM0PL+mhkodHU/Uzz8Mv9E1MeqqqgD54gFAaGW2Edz6orF7lNh7g
         XvWkCZEPUd66CvE/paOmSjhLviSSSmkpwLWc4RFDRShWyXe4JUpYHdQb03OFKgHd4OKl
         FiZxKugTegtIyc+2RdJyOb/E9r+X7YKzqsZD5iQtdBaPhO3q+1bE/8/3CnvWRTW+kdEN
         JuxeJpZVHqizYfvsQgNqVDEhGsD2pYaLHGG4oALJ80BfCPnvO5RPn2la7ktyN1SKsjLs
         KvwkEu51BXVoIxNd6E5v/ClTuJkkZXeJUGp/GjWz1fcuCBSRJAIqcUPnEBp7oPlzJWMy
         agiA==
X-Gm-Message-State: APjAAAXWaac/fLyOKMLl/LGii2lQ/GEsca9PVw+O9Rwflccd+7h8vO+E
        ttFeGr/bmufFH1DF4HFIwna4Tqdn
X-Google-Smtp-Source: APXvYqyYZbKJxRpgjWZURp4Rcr+ISbqYE4DQNKJ/IPw69CL2iNZhWG/pxZuYvNYNc8QbaTWItH/oTw==
X-Received: by 2002:a05:6000:11c4:: with SMTP id i4mr4830022wrx.277.1571772663607;
        Tue, 22 Oct 2019 12:31:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:d16f:4cec:8adc:ea59? (p200300EA8F266400D16F4CEC8ADCEA59.dip0.t-ipconnect.de. [2003:ea:8f26:6400:d16f:4cec:8adc:ea59])
        by smtp.googlemail.com with ESMTPSA id g5sm19230348wmg.12.2019.10.22.12.31.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 12:31:02 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: never set PCI_EXP_DEVCTL_NOSNOOP_EN
Message-ID: <25be979c-a8ff-063a-1f8e-0765b2375401@gmail.com>
Date:   Tue, 22 Oct 2019 21:30:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting PCI_EXP_DEVCTL_NOSNOOP_EN for certain chip versions had been
added to the vendor driver more than 10 years ago, and copied from
there to r8169. It has been removed from the vendor driver meanwhile
and I think we can safely remove this too.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 57942383b..c317af9c6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5345,19 +5345,6 @@ static void rtl_hw_start_8125(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8168(struct rtl8169_private *tp)
 {
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_11:
-	case RTL_GIGA_MAC_VER_12:
-	case RTL_GIGA_MAC_VER_13:
-	case RTL_GIGA_MAC_VER_16:
-	case RTL_GIGA_MAC_VER_17:
-		pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
-					 PCI_EXP_DEVCTL_NOSNOOP_EN);
-		break;
-	default:
-		break;
-	}
-
 	if (rtl_is_8168evl_up(tp))
 		RTL_W8(tp, MaxTxPacketSize, EarlySize);
 	else
-- 
2.23.0

