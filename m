Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA3B3F271B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238581AbhHTG6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 02:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238492AbhHTG6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 02:58:37 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0357C061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 23:57:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v2so12491136edq.10
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vktROwdfT/2W3HLGzWkFifgLXqdoBqZ18sow34pIXJc=;
        b=sN6fC/++0BAFLYXaTS0QbiVZEEevvpfvw9hqYlfpbsDBZIdSdQDF/ZZakZj3RX8Ysm
         iCH/USyAdh6h1p1xUn6806Rs9YoBrCvk7HMiuhil0Br5SmX1k6SBLRxygKY3/9X5u9lf
         3czYGOOkRjjKDbZ7PPYyVhsviXZ+acAcfQib8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vktROwdfT/2W3HLGzWkFifgLXqdoBqZ18sow34pIXJc=;
        b=GunGXWRr/zXJ2s81EA/NPomLW2bm17aGY2GwUeKA0Sltur6iayHlqVOnUgCP1Pg8FL
         1dMnWn/1Ieq+bSLf/UOnq4JsOYUieI2/GvoKXWCeeOcq9F38gdJ3yASEU6GnUd7ok02O
         dtXfMnrk7d5jOvyYKRBBySH85+Waa8bRlSi7cglqNudy9aZNR/iht2U6NRXerK13w5be
         Zok/wPTNRZl55DS8t5wiPm8ElQkMKMKjEhaiz2sniEP0pAchhKqpFNofamoNlsGYjnhG
         nQ7oDD58c8bZyZ5l5Bo1pzGu7sI2gXU7frDhfTKAXLTCMbWGy0QB3Y71dR2dKUXtrOBj
         HwsQ==
X-Gm-Message-State: AOAM532Yz/1+/ZVl30sQTRUzxBV8bwauy59nmL65LH0Jq6VCajd67XDw
        bENlVv8Crkj/oWyZSAGEcoTALg==
X-Google-Smtp-Source: ABdhPJwsRnKJaYTjDWrtS6drI4s2jw3vNhBvYSf0AABuBHXvET7UJEQjIMwXbfgajRxhPiSwakGE0g==
X-Received: by 2002:aa7:c0c6:: with SMTP id j6mr9439846edp.146.1629442678056;
        Thu, 19 Aug 2021 23:57:58 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id z6sm2984637edc.52.2021.08.19.23.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 23:57:57 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH v2] net: usb: pegasus: fixes of set_register(s) return value evaluation;
Date:   Fri, 20 Aug 2021 09:57:53 +0300
Message-Id: <20210820065753.1803-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
    Kicinski;
  - hurried up and removed redundant assignment in pegasus_open() before yet
    another checker complains;

Fixes: 8a160e2e9aeb ("net: usb: pegasus: Check the return value of get_geristers() and friends;")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/pegasus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 652e9fcf0b77..9f9dd0de33cb 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -446,7 +446,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
-	return 0;
+	return ret;
 fail:
 	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
@@ -835,7 +835,7 @@ static int pegasus_open(struct net_device *net)
 	if (!pegasus->rx_skb)
 		goto exit;
 
-	res = set_registers(pegasus, EthID, 6, net->dev_addr);
+	set_registers(pegasus, EthID, 6, net->dev_addr);
 
 	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
 			  usb_rcvbulkpipe(pegasus->usb, 1),
-- 
2.30.2
