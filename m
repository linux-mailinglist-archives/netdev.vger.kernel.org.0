Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15595635C3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiGAOgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiGAOfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:36 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416DA70E7C;
        Fri,  1 Jul 2022 07:31:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8C872FF805;
        Fri,  1 Jul 2022 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+48KAEYT4N3CTgfihOqyVd6PFG2dWE2Syu7PlW90HYs=;
        b=gvg59R9W7kKyLHvlsGFPCM8fjgNJ+AQTAPWThmB2gLY2pM9TC3l+fRWu/2q/Q/UHfW7pCJ
        3MIYRBCfOFdJrRDuM+FP0obmkqUvCP93g5G0mnjNMoxEk8PT7eyNSkJ6Gprcsg38uAYuj8
        HqYnqNR3H2+foEDPJJfigX0W+RR+KDS5HH2zdLENHWk1fjWT9mODb1QbpNFXwZrFRFmCY0
        PXgfLSJoQccjCOsU9GwuEuez8OMmJkRFAZZO4WAqMCxCPGNr23K1992/kyAN8HBB0V0+BH
        DoPDv7UBYd3lO0cEOaJnKfoBLi2+qHMggA6/3CJKpUozcMBuu7bwiW1pJRAEYQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 05/20] net: ieee802154: Define frame types
Date:   Fri,  1 Jul 2022 16:30:37 +0200
Message-Id: <20220701143052.1267509-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
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

A 802.15.4 frame can be of different types, here is a definition
matching the specification. This enumeration will be soon be used when
adding scanning support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c3294b..13167851b1c3 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -69,6 +69,17 @@ struct ieee802154_hdr_fc {
 #endif
 };
 
+enum ieee802154_frame_type {
+	IEEE802154_BEACON_FRAME,
+	IEEE802154_DATA_FRAME,
+	IEEE802154_ACKNOWLEDGEMENT_FRAME,
+	IEEE802154_MAC_COMMAND_FRAME,
+	IEEE802154_RESERVED_FRAME,
+	IEEE802154_MULTIPURPOSE_FRAME,
+	IEEE802154_FRAGMENT_FRAME,
+	IEEE802154_EXTENDED_FRAME,
+};
+
 struct ieee802154_hdr {
 	struct ieee802154_hdr_fc fc;
 	u8 seq;
-- 
2.34.1

