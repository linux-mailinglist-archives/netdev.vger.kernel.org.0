Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1F75635D5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiGAOg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiGAOgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:36:07 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C245C42EF8;
        Fri,  1 Jul 2022 07:31:32 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CB0E1FF80E;
        Fri,  1 Jul 2022 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9IkosSLmaRWjWduk0OBGQ/RHOhyIjPodagqLxqYK6J4=;
        b=LQXbQGsbAy+kRhgtp4euA1y4TVkis+IShPMnLtSai4XVfs4ckHVroMx/OZIIV/jd83WoKk
        e+oJJ1SArclpROylhhy/E+vt+c1Z4sDbJj0P3CiJ3OQExpv/2b4+u0JexYNv+bGPMjyZ2e
        QF/M0PeojhIsuqeOfV28qExeeGmmiCMc0oKYmuA+aLAM0O/ZYEUA5cjtYXcXWD+ESQB3hT
        dk7TpvOOP2Ptt5J9Vw/bZkItLdyxcEHC3VXKlNA2rlMCWEGQvOvSa+PZxt3zhk+Hb032QK
        mwshKdvDyYgkvUCA5zhOjpHgpIBoUAwwWym0M9AQjJm0QvEaCWyYoqfLvsz5eA==
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
Subject: [PATCH wpan-next 18/20] ieee802154: ca8210: Flag the driver as being limited
Date:   Fri,  1 Jul 2022 16:30:50 +0200
Message-Id: <20220701143052.1267509-19-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a hardMAC device wired to Linux 802154 softMAC
implementation. It is a bit limited in the sense that it cannot handle
anything else that datagrams. Let's flag it like this to prevent using
unsupported features such as scan/beacons handling.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 42c0b451088d..12f3564c8f8d 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2943,7 +2943,8 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->flags =
 		WPAN_PHY_FLAG_TXPOWER |
 		WPAN_PHY_FLAG_CCA_ED_LEVEL |
-		WPAN_PHY_FLAG_CCA_MODE;
+		WPAN_PHY_FLAG_CCA_MODE |
+		WPAN_PHY_FLAG_DATAGRAMS_ONLY;
 }
 
 /**
-- 
2.34.1

