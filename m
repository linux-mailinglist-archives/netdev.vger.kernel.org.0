Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A9725B784
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 02:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgICAHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 20:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgICAHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 20:07:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA01C061244;
        Wed,  2 Sep 2020 17:07:02 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v15so605133pgh.6;
        Wed, 02 Sep 2020 17:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etdQESEPzizayB9lC3xmaZESCXB50mJ00LfBR9308WE=;
        b=rPxrj2arycz5jzRcUqZvd9oV5NCS7SThLH4FjF0dwugb9yI00Ya0L+9a27W7buNHAJ
         tfh7jK/uCD9eyOqGmw5jNZ0TNY3ANcaNP4IDfPiokFUSjgP8e9E2DXyyLwligjBOSjAJ
         Liz4RDJzVS9Ljx0YR++yMDsmT8Ujz8rirBuheCS3rDOv4N0rktRjV1rQSeiOdNr/6nIS
         s95bt7F6Xo7e4zL01NmVfAv44rmrD/1Fy1LUB1IJjWv4Bp2TOqUyT9aRq2vuRTHapWax
         9/wbs5KzcmGzYaVtNVLA35lCPtiMW1Vs+Kmmj8iuKXCN+UGB+rGw2NbDE4oVB+Qv2TE6
         yblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etdQESEPzizayB9lC3xmaZESCXB50mJ00LfBR9308WE=;
        b=BRO3Ex0vY/lVKvFlSZFGnmNOLDe7Q6zTrmIdDN4uibwFugePeVXfwibFO8oFtwKkeP
         6mfaKn4AdUBHnc2VPy6Sg3jfUlPOVOuXkZ90x82lI7y8oQjcmZ68HJE2+637rhIZEwv3
         VWjSRPhwDFGX47RcAno3OjfR2kzmmb67Fg4mRYkLVg7xSVoDTQ/fnjnm1bSWSRPX26QA
         6Ry1lvtu42Wa9unussT7tZ+6l2HVWBe2ZuEFqqvmiPJypBXt/K/vEF/hFc4DrBfU5Es2
         4AKOidCzGuEDUq7uF5xLqkhSZzjoPggEuMOnKDHf24BGhW2Xv6rVaPTayW72nfQlyjoo
         9Eng==
X-Gm-Message-State: AOAM533zX67KmkjHc+RQAjEoeWHJ1moXpE1lz3wYwXwWLhAXNKWCjGN2
        c3mZNtkCCetEnwxjN2dOTwU=
X-Google-Smtp-Source: ABdhPJxmVgijpf29mnOSEiRZy9zDo4qy31+Ai9t9Fmny9oAol2zG6JOfI4ciCTQEW9aiC2FlODBb/w==
X-Received: by 2002:a63:9d02:: with SMTP id i2mr355802pgd.378.1599091621877;
        Wed, 02 Sep 2020 17:07:01 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:b49f:31b6:73e2:b3d2])
        by smtp.gmail.com with ESMTPSA id b12sm468947pgr.34.2020.09.02.17.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 17:07:01 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
Date:   Wed,  2 Sep 2020 17:06:58 -0700
Message-Id: <20200903000658.89944-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PVC devices are virtual devices in this driver stacked on top of the
actual HDLC device. They are the devices normal users would use.
PVC devices have two types: normal PVC devices and Ethernet-emulating
PVC devices.

When transmitting data with PVC devices, the ndo_start_xmit function
will prepend a header of 4 or 10 bytes. Currently this driver requests
this headroom to be reserved for normal PVC devices by setting their
hard_header_len to 10. However, this does not work when these devices
are used with AF_PACKET/RAW sockets. Also, this driver does not request
this headroom for Ethernet-emulating PVC devices (but deals with this
problem by reallocating the skb when needed, which is not optimal).

This patch replaces hard_header_len with needed_headroom, and set
needed_headroom for Ethernet-emulating PVC devices, too. This makes
the driver to request headroom for all PVC devices in all cases.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---

Change from v1:

English language fix for the commit message.

Changed "Ethernet-emulated" to "Ethernet-emulating" because the device
is emulating an Ethernet device, rather than being emulated by an
Ethernet device.

I'm sorry for my poor English.

---
 drivers/net/wan/hdlc_fr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 9acad651ea1f..12b35404cd8e 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1041,7 +1041,7 @@ static void pvc_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_DLCI;
 	dev->flags = IFF_POINTOPOINT;
-	dev->hard_header_len = 10;
+	dev->hard_header_len = 0;
 	dev->addr_len = 2;
 	netif_keep_dst(dev);
 }
@@ -1093,6 +1093,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	dev->mtu = HDLC_MAX_MTU;
 	dev->min_mtu = 68;
 	dev->max_mtu = HDLC_MAX_MTU;
+	dev->needed_headroom = 10;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->ml_priv = pvc;
 
-- 
2.25.1

