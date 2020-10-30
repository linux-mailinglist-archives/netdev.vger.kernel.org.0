Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685C329FB51
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgJ3Caj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgJ3Cah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:30:37 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44110C0613CF;
        Thu, 29 Oct 2020 19:30:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o3so3908736pgr.11;
        Thu, 29 Oct 2020 19:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g7bH88D4g/VYGOa3hWMRp6XP+GTlXN0P1WC9N4Q2/XM=;
        b=sIPVkoX/Of6nVZG0ZQgVEkv9eNrnT5+MLWijSKMQbASTMC4PXi8b+L2jK+WSCb12I2
         rfzmY8ocgI9WK/Z4GFsF7Z2kU7rnTSDlzGasss0mN5YOb88P2MWW3SChA1B5PYj+XB2I
         kJNeB95XEqJMVTz+DpoaPPEt8njOiIgrORPkp53nZQk37TTadn2it2iO6fJm3KXzEHWg
         aroSeUO2kcm2plv5TQB9siuRYYT8neLqRjXBSV3YP+Z0mnUWzobdzdMUVQSYmmuJ6ZFp
         aKeoU2Pg/DUf8Rbac59vFyzcs01F6JFxMSIBriLKvcElFtFTnahjusIKEXJWj6thO8wF
         K7xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g7bH88D4g/VYGOa3hWMRp6XP+GTlXN0P1WC9N4Q2/XM=;
        b=NM23zp4bwwNtzSsVzMaWAYEDBoi0C5g6TxX2qA2xckqahc9TwtDOs+tZkAOSRC3O0+
         e5P9jBwaWYeGA2k3vsZnmJ1FmR5jTiHasdBAnRes8zPKsGsIin0SKl5Y1L1Uwe0+8Ddr
         NS3fVSnsXaAmHL6A/ZuQuggJoesqk/BFUuJZ+iY3MfrS0BdzoEJLE99oSYiMJu6B/Vtd
         VMyAIEtNUv8AS0x4dXnang99d0eU15P1wVPTJls3KKczAiu5koO9eSbEFVTuTX6ehwvE
         WTCw46H0LN9az/BNuDzePi+UXJ3AoF5d1awHUMTnPEXigwULpYTuvWYILH+ZWIE37Tp4
         V94w==
X-Gm-Message-State: AOAM531qoXbkw82+3cHNolDJFT3zT3gfnGjSRFfbidQFBnzswiuZK0mE
        +3zsfcqL1QBa4b9YBzFaojA=
X-Google-Smtp-Source: ABdhPJxaWSHPgJMIvnjBMqb0MKb8E8b7ORoASIJ2qcWWVTBzFsOJt3fNIkTg+R+jiGT58y7Q+xSCCA==
X-Received: by 2002:a65:5a0d:: with SMTP id y13mr230777pgs.436.1604025036855;
        Thu, 29 Oct 2020 19:30:36 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:dd13:d62a:9d03:9a42])
        by smtp.gmail.com with ESMTPSA id i24sm4216588pfd.7.2020.10.29.19.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:30:36 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v4 5/5] net: hdlc_fr: Add support for any Ethertype
Date:   Thu, 29 Oct 2020 19:28:39 -0700
Message-Id: <20201030022839.438135-6-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030022839.438135-1-xie.he.0141@gmail.com>
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the fr_rx function to make this driver support any Ethertype
when receiving skbs on normal (non-Ethernet-emulating) PVC devices.
(This driver is already able to handle any Ethertype when sending.)

Originally in the fr_rx function, the code that parses the long (10-byte)
header only recognizes a few Ethertype values and drops frames with other
Ethertype values. This patch replaces this code to make fr_rx support
any Ethertype. This patch also creates a new function fr_snap_parse as
part of the new code.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 75 +++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 9a37575686b9..e95efc14bc97 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -871,6 +871,45 @@ static int fr_lmi_recv(struct net_device *dev, struct sk_buff *skb)
 	return 0;
 }
 
+static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
+{
+	/* OUI 00-00-00 indicates an Ethertype follows */
+	if (skb->data[0] == 0x00 &&
+	    skb->data[1] == 0x00 &&
+	    skb->data[2] == 0x00) {
+		if (!pvc->main)
+			return -1;
+		skb->dev = pvc->main;
+		skb->protocol = *(__be16 *)(skb->data + 3); /* Ethertype */
+		skb_pull(skb, 5);
+		skb_reset_mac_header(skb);
+		return 0;
+
+	/* OUI 00-80-C2 stands for the 802.1 organization */
+	} else if (skb->data[0] == 0x00 &&
+		   skb->data[1] == 0x80 &&
+		   skb->data[2] == 0xC2) {
+		/* PID 00-07 stands for Ethernet frames without FCS */
+		if (skb->data[3] == 0x00 &&
+		    skb->data[4] == 0x07) {
+			if (!pvc->ether)
+				return -1;
+			skb_pull(skb, 5);
+			if (skb->len < ETH_HLEN)
+				return -1;
+			skb->protocol = eth_type_trans(skb, pvc->ether);
+			return 0;
+
+		/* PID unsupported */
+		} else {
+			return -1;
+		}
+
+	/* OUI unsupported */
+	} else {
+		return -1;
+	}
+}
 
 static int fr_rx(struct sk_buff *skb)
 {
@@ -945,35 +984,19 @@ static int fr_rx(struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IPV6);
 		skb_reset_mac_header(skb);
 
-	} else if (skb->len > 10 && data[3] == FR_PAD &&
-		   data[4] == NLPID_SNAP && data[5] == FR_PAD) {
-		u16 oui = ntohs(*(__be16*)(data + 6));
-		u16 pid = ntohs(*(__be16*)(data + 8));
-		skb_pull(skb, 10);
-
-		switch ((((u32)oui) << 16) | pid) {
-		case ETH_P_ARP: /* routed frame with SNAP */
-		case ETH_P_IPX:
-		case ETH_P_IP:	/* a long variant */
-		case ETH_P_IPV6:
-			if (!pvc->main)
-				goto rx_drop;
-			skb->dev = pvc->main;
-			skb->protocol = htons(pid);
-			skb_reset_mac_header(skb);
-			break;
-
-		case 0x80C20007: /* bridged Ethernet frame */
-			if (!pvc->ether)
+	} else if (data[3] == FR_PAD) {
+		if (skb->len < 5)
+			goto rx_error;
+		if (data[4] == NLPID_SNAP) { /* A SNAP header follows */
+			skb_pull(skb, 5);
+			if (skb->len < 5) /* Incomplete SNAP header */
+				goto rx_error;
+			if (fr_snap_parse(skb, pvc))
 				goto rx_drop;
-			skb->protocol = eth_type_trans(skb, pvc->ether);
-			break;
-
-		default:
-			netdev_info(frad, "Unsupported protocol, OUI=%x PID=%x\n",
-				    oui, pid);
+		} else {
 			goto rx_drop;
 		}
+
 	} else {
 		netdev_info(frad, "Unsupported protocol, NLPID=%x length=%i\n",
 			    data[3], skb->len);
-- 
2.27.0

