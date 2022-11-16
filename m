Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1D562B49F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiKPIIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238541AbiKPIIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:08:12 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B04012601;
        Wed, 16 Nov 2022 00:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CNx2EvBgaSK9aSDl5n7dtYqaf36QTyssctQ2Sm28n8U=; b=ZvCTo5bQnviRC3drDP+mYi53W4
        7OIeHEzA2qnZFksv8PlwXvuLGT5ngY6IuQcT2k+AfJqp1o1FWWjKjqEhV+565WRvEHpC6XNQa25zl
        wnSgaPe1yhwOF1ayNGyShB+FlRhEt7l6XRNNWXx/OIbiwJrnaSC23e2YwD5ZrdoeXFXc=;
Received: from p200300daa72ee10015f07c5633889601.dip0.t-ipconnect.de ([2003:da:a72e:e100:15f0:7c56:3388:9601] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ovDSM-002Xoe-HJ; Wed, 16 Nov 2022 09:07:38 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: dsa: tag_mtk: assign per-port queues
Date:   Wed, 16 Nov 2022 09:07:33 +0100
Message-Id: <20221116080734.44013-6-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116080734.44013-1-nbd@nbd.name>
References: <20221116080734.44013-1-nbd@nbd.name>
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

