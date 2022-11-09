Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0624A623037
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiKIQe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiKIQew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:34:52 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384821A05E;
        Wed,  9 Nov 2022 08:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CNx2EvBgaSK9aSDl5n7dtYqaf36QTyssctQ2Sm28n8U=; b=VOzMv9ZbI1H3uX1yYfBGtAh3xN
        xAtjtcjwrDAzIMopqcbRnIq5FDn4TYwmuVdg9rfGaGWC16JkG2SU8uPgSqz+sCZST6PEzBX2dFwNO
        BUnvv4DBPKDN99s5U3EYjgYcCTFIy8eSa2Vjmy4XC8XIU+dObGIyvYT67QXfYcESuROk=;
Received: from p200300daa72ee100054f3c61b16ef6e7.dip0.t-ipconnect.de ([2003:da:a72e:e100:54f:3c61:b16e:f6e7] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oso26-000l4N-Fp; Wed, 09 Nov 2022 17:34:34 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 05/12] net: dsa: tag_mtk: assign per-port queues
Date:   Wed,  9 Nov 2022 17:34:19 +0100
Message-Id: <20221109163426.76164-6-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
References: <20221109163426.76164-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keeps traffic sent to the switch within link speed limits

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/dsa/tag_mtk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 415d8ece242a..5953356b829d 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -25,6 +25,8 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	u8 xmit_tpid;
 	u8 *mtk_tag;
 
+	skb_set_queue_mapping(skb, dp->index);
+
 	/* Build the special tag after the MAC Source Address. If VLAN header
 	 * is present, it's required that VLAN header and special tag is
 	 * being combined. Only in this way we can allow the switch can parse
-- 
2.38.1

