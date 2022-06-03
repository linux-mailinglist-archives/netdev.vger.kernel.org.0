Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3508A53D184
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347355AbiFCSeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347572AbiFCSeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:34:02 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4B4C6;
        Fri,  3 Jun 2022 11:21:48 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 80E4920004;
        Fri,  3 Jun 2022 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654280506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PIXgRGmTMnLX6VGt/6mVavZJMsh6eGPhFIUxtOIIG/4=;
        b=DMXDcKnOJxtPr6NWanlJwMLac5pBDUzwgz5OX5fjkiWS+nA8I95VQEQv6L3gCGHb2H/Qzd
        oRyuj16Dq8Ke+OZagrsmXbzgRwrxNfaleg+QcST/ETfD1U0qQ1M0bAJzv2RoDzTPK13lBX
        C4GhQbKE3BiW/T7JkX6gGoqjoLYjUy+AHUE3OWzj7WFXMv5XDWC0HopkGH8IeZuRW3D48O
        bHwksxBdK50z6crAHfR+CgJ5SShq2Lu2WirMrFY339fuzD8iVeBM/UMUW8167z7SGBGHlm
        OORXTZR4gijj6DVkQFaPeYtY2tfcOs95l6/wqQ9V48k9hwICF3p/Nff1laDmAA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
Date:   Fri,  3 Jun 2022 20:21:38 +0200
Message-Id: <20220603182143.692576-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220603182143.692576-1-miquel.raynal@bootlin.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current enum is wrong. A device can either be an RFD, an RFD-RX, an
RFD-TX or an FFD. If it is an FFD, it can also be a coordinator. While
defining a node type might make sense from a strict software point of
view, opposing node and coordinator seems meaningless in the ieee
802.15.4 world. As this enumeration is not used anywhere, let's just
drop it. We will in a second time add a new "node type" enumeration
which apply only to nodes, and does differentiates the type of devices
mentioned above.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/nl802154.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 145acb8f2509..0f508aaae126 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -156,7 +156,6 @@ enum nl802154_iftype {
 
 	NL802154_IFTYPE_NODE = 0,
 	NL802154_IFTYPE_MONITOR,
-	NL802154_IFTYPE_COORD,
 
 	/* keep last */
 	NUM_NL802154_IFTYPES,
-- 
2.34.1

