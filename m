Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A237518735A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 20:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbgCPTby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 15:31:54 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39548 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732452AbgCPTby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 15:31:54 -0400
Received: by mail-pj1-f67.google.com with SMTP id d8so9214362pje.4
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 12:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Pxzxeuq/DgFqe2dlBw1W/2xnLEJ/0TSO3oRKDopVtE4=;
        b=O1+sePdNAdHKxaeoM12HDL/N0ugk1dUSGDlhUpjnFDnBOzPxkqAQHtIQeAkb89Un5h
         uPRqLDbTcyFWLnYOqYuNsp+zHK6MUL9c8BRTp571od6z4LpNHfE0UuXVWcSYi8iikkqJ
         NSk8C8lUT5ux4Xx8FmTTCKvnIZWcY67yb3R9T9yjEPgZc2fUeYyi1yFk7FNUYAJfebvg
         IgT2vqnZVtZuzhPXCj4Vt1M2PiHsM6PeCY2IInOftGXZ1cAPnJXl3Y6O2WZIC4r3nUde
         atJEaUWh13iphuKC6AZvVfjpvIqEk58IdK8hQMxjKCuWEpSkRIXyCQyixyco/NoMN+nu
         66jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Pxzxeuq/DgFqe2dlBw1W/2xnLEJ/0TSO3oRKDopVtE4=;
        b=EkVDm9TNXojNDq70cBr7gy6a66asW2QcqiPsu1/wq3vaiAx2D5UnxUuTtvQMm/uMdl
         REhRf/2xjqaeQRont0inWbxs19Hvw0FyS+iURE/Jqvj4Nytqk2D+1RiN9h8+EBqXJqvT
         zgrzEpWMLfQjpB65Btc8AMr/YjeJmp2/OrPDLjRn8/p3szzM6gtVPo+bc0W1HvrXRn7M
         JK0/fvdk4oeK9UfA5ryEXfKq2kEyen/iXuFJckQIwqT/6ULXGOly/KMxTqyHgYn+PVc6
         EzcB8UN4ndkUW6EYupStiJMfWLK3kjyvJ1Y3tRUmX3DHn/Pj0HeGA9R9vjPE6R657axE
         JZ5w==
X-Gm-Message-State: ANhLgQ2K26dGCWAInZVTi8YZ1QpT3a23H9Nhenkd+3PScCN4DVSug1hR
        ZirFYGWp8akt/qBQyHhWJ+AuONZYA1c=
X-Google-Smtp-Source: ADFU+vt7zNNfLeMOAMGuqwBgNQUIyexNmB2tzQ9AoS6YaxwSc5fdh0Vez0/raJWyvTlQr4OsIDKM1g==
X-Received: by 2002:a17:90a:dac6:: with SMTP id g6mr1169170pjx.30.1584387107793;
        Mon, 16 Mar 2020 12:31:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w17sm656413pfi.59.2020.03.16.12.31.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:31:46 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/5] ionic: return error for unknown xcvr type
Date:   Mon, 16 Mar 2020 12:31:33 -0700
Message-Id: <20200316193134.56820-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316193134.56820-1-snelson@pensando.io>
References: <20200316193134.56820-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we don't recognize the transceiver type, return an error
so that ethtool doesn't try dumping bogus eeprom contents.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index a233716eac29..3f92f301a020 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -694,7 +694,7 @@ static int ionic_get_module_info(struct net_device *netdev,
 	default:
 		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
 			    xcvr->sprom[0]);
-		break;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -714,7 +714,19 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
 	/* The NIC keeps the module prom up-to-date in the DMA space
 	 * so we can simply copy the module bytes into the data buffer.
 	 */
+
 	xcvr = &idev->port_info->status.xcvr;
+	switch (xcvr->sprom[0]) {
+	case 0x03: /* SFP */
+	case 0x0D: /* QSFP */
+	case 0x11: /* QSFP28 */
+		break;
+	default:
+		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
+			    xcvr->sprom[0]);
+		return -EINVAL;
+	}
+
 	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
 
 	do {
-- 
2.17.1

