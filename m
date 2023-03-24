Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC52F6C7CFB
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjCXLGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjCXLGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:06:06 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73101F4A3;
        Fri, 24 Mar 2023 04:06:03 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ABE8E1C0005;
        Fri, 24 Mar 2023 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679655962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jLvVIFKHhdFYQm5gzIRuT+iG4SFwU4maOCdMYLv9IZQ=;
        b=aUSL3P8MFwercyjL/z9RCeEcNx0IEG/OdfYIoe0pVweMT8vPXNq/qnmTzHTeSxQhX21nxa
        qkNuCS7sDvcg93SRzY9EYnre/0+zenV1qOqxaZ0sUnkUYVAQD8luMNeJvhXRqjNhD0Ion/
        ypRV0YgfTpoeWwgH++RXBAa+UKXt4zrJC44kUjA4S1uMj0dELg+P2ppboE3e0zLsFmYcSi
        mZcibcjFyQWZKrmdHn81CVFUOeXJQ+Q/JIcp/Iy0k+jLWxwrpzsHfwNntq3FevKMT0i8Uf
        nZzon3QPB+c+B+B1j39+CkoLVu5u+AYvaJZEJr3i70Q6/0fjUk5u71rKMv68/w==
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
Subject: [PATCH wpan-next 0/2] ieee802154: Handle imited devices
Date:   Fri, 24 Mar 2023 12:05:56 +0100
Message-Id: <20230324110558.90707-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As rightly pointed out by Alexander a few months ago, ca8210 devices
will not support sending frames which are not pure datagrams (hardMAC
wired to the softMAC layer). In order to not confuse users and clarify
that scanning and beaconing is not supported on these devices, let's add
a flag to prevent them to be used with the new APIs.

Miquel Raynal (2):
  net: ieee802154: Handle limited devices with only datagram support
  ieee802154: ca8210: Flag the driver as being limited

 drivers/net/ieee802154/ca8210.c |  3 ++-
 include/net/cfg802154.h         |  3 +++
 net/ieee802154/nl802154.c       | 10 ++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.34.1

