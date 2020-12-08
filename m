Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B052D367A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbgLHWvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbgLHWvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:51:37 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1299C0613CF;
        Tue,  8 Dec 2020 14:50:57 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so13598616pga.7;
        Tue, 08 Dec 2020 14:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czPRgCP4Rbvj8nQm8kV+1nNwcp4eHqLkAIVxs9WjDpk=;
        b=VXzD6wwNroEMOtTsjKAFrXV3Ykmq11SgT6QT0T+yMgGu3gUnx9joMIFzmJ0oQMo7TD
         Y5zrQy4AqY3a4iWw4A9W6JapbweHMdHprj+tNKbhbmUVCwwVXDTDKbBJ+IqVFXL34dCv
         +q5rmn7SjQ77tXvhz0niCCqULV+ynvw+ss4Pvqswb/ABCLgp/VFdbUlfvyO5umzwfebV
         J0YMrDVHBQI7WG0314/DMIqNeyZ4oGKFvsOAdEE2UMaSxqZtwjTWsRFpmI3INj3VU9ok
         3KxfDDr/DC5KbpF6lVuHTb1/R6MS3Ow6n6n+iRYSrSPyeO8iRxhr19mR44oDzZdN00yH
         ncEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czPRgCP4Rbvj8nQm8kV+1nNwcp4eHqLkAIVxs9WjDpk=;
        b=A1jSbT1UUKxVjdz62X5bXXZpomzoByDv3zs9lXxjqAzqKsJ2qoZl7hA/2EdiGNjlhI
         afsVmh1WEOf7SgOHoHmaV+2f6gWJ9pq0jakyyhaDUgaGVibNBk3Hv0blxG20mrC2z9nb
         R/EIjoICeWVtN3eH4hBUAflIMsz+vVIbgNh1xCzwcD0RoaduyYuKgOYj0TU0jrpCjDqj
         4Gz447Vxv1xyMRp9bO3ofUH8RKt3wCpOqO8revQQIizydcY2c3/JmUYvhRTdnEhQhDP8
         0LYIccRsoaDSUuzHMFyi+7ERiYH96Ljg8ax+M/+gQDQCQ3OWgIWSvtXqBSABZvk+WyO0
         NDsQ==
X-Gm-Message-State: AOAM533dbHZD0Sdpse3aYvbwiGSI7wy+B0vNfmnVRvXqhob0eexCDnFj
        DyH2SVqlVnr1csmsDxXfk6E=
X-Google-Smtp-Source: ABdhPJzmnlwG1nSzxgXgEJFyCnxe2OHLK9eZDpCtUOcjYeK4XTm8lup1A/VwsyO5pFxGEDNEPMP/oQ==
X-Received: by 2002:a63:1c53:: with SMTP id c19mr261553pgm.392.1607467857445;
        Tue, 08 Dec 2020 14:50:57 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:55ef:9b8b:7388:ced5])
        by smtp.gmail.com with ESMTPSA id dw16sm194135pjb.35.2020.12.08.14.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 14:50:56 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net: lapbether: Consider it successful if (dis)connecting when already (dis)connected
Date:   Tue,  8 Dec 2020 14:50:44 -0800
Message-Id: <20201208225044.5522-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the upper layer instruct us to connect (or disconnect), but we have
already connected (or disconnected), consider this operation successful
rather than failed.

This can help the upper layer to correct its record about whether we are
connected or not here in layer 2.

The upper layer may not have the correct information about whether we are
connected or not. This can happen if this driver has already been running
for some time when the "x25" module gets loaded.

Another X.25 driver (hdlc_x25) is already doing this, so we make this
driver do this, too.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index b6be2454b8bd..605fe555e157 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -55,6 +55,9 @@ struct lapbethdev {
 
 static LIST_HEAD(lapbeth_devices);
 
+static void lapbeth_connected(struct net_device *dev, int reason);
+static void lapbeth_disconnected(struct net_device *dev, int reason);
+
 /* ------------------------------------------------------------------------ */
 
 /*
@@ -167,11 +170,17 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 	case X25_IFACE_DATA:
 		break;
 	case X25_IFACE_CONNECT:
-		if ((err = lapb_connect_request(dev)) != LAPB_OK)
+		err = lapb_connect_request(dev);
+		if (err == LAPB_CONNECTED)
+			lapbeth_connected(dev, LAPB_OK);
+		else if (err != LAPB_OK)
 			pr_err("lapb_connect_request error: %d\n", err);
 		goto drop;
 	case X25_IFACE_DISCONNECT:
-		if ((err = lapb_disconnect_request(dev)) != LAPB_OK)
+		err = lapb_disconnect_request(dev);
+		if (err == LAPB_NOTCONNECTED)
+			lapbeth_disconnected(dev, LAPB_OK);
+		else if (err != LAPB_OK)
 			pr_err("lapb_disconnect_request err: %d\n", err);
 		fallthrough;
 	default:
-- 
2.27.0

