Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0A46048E2
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiJSONu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiJSONa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:13:30 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7C9543C3;
        Wed, 19 Oct 2022 06:56:00 -0700 (PDT)
Received: from relay10.mail.gandi.net (unknown [217.70.178.230])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 8F089CEECA;
        Wed, 19 Oct 2022 13:46:29 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AC4B6240004;
        Wed, 19 Oct 2022 13:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666187066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KiudPeN4ih8vxup9qMF9Xj0kZ8/yn8+dYzubgOF3bR4=;
        b=cvnKPKrDXr6S01qkutJhoc+rrLIw14BBLMHnTI/RHH4AdV1FheTF6g4QfA94NO111aZFUW
        Vfg9Y7fAAEJSuA7OzhhxPaonsQGiHNTQqaLeF1tuWG5hXaDixCHr++ZgKXHULPa096l5zE
        YYjrZkiUmERWQq7AgGaH29dHcdBC6pKWRfum7dsDo9LHB6E0Ch2Eg6ZTcDfUyE9R8KC5VB
        imA03L7Fhmj5ilwAmCowbR4WZgB+O32zksyF4QgUJAGRiMJOAmOO3CRbUwRAyywOJwyvbh
        UEo+3VgYJ9iHeoR2E4fjpbsGRYVpa1QfXh3wW9BriTEveqJign39EsmTenW9Tg==
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v6 0/3] IEEE 802.15.4 filtering series followup
Date:   Wed, 19 Oct 2022 15:44:20 +0200
Message-Id: <20221019134423.877169-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The filtering series v4 [1] lead to a discussion about the use of a PIB
attribute to save the required PHY filtering level instead of accessing
the MAC internals, which is bein addressed in patch 1/3 and 2/3. The
last patch has been sent alone as a v5 because of a debug message
needing rewording. Actually Stefan wanted me to rebase on top of
wpan-next without keeping a patch sent as a fix which conflicts with it,
so here it is.

Once these three patches will be merged (I don't expect much discussions
on it to be honest?) I will send the next small series bringing support
for COORD interfaces.

Cheers, Miquèl

Miquel Raynal (3):
  ieee802154: hwsim: Introduce a helper to update all the PIB attributes
  ieee802154: hwsim: Save the current filtering level and use it
  mac802154: Ensure proper scan-level filtering

 drivers/net/ieee802154/mac802154_hwsim.c | 88 +++++++++++++++---------
 net/mac802154/rx.c                       | 16 +++--
 2 files changed, 67 insertions(+), 37 deletions(-)

-- 
2.34.1

