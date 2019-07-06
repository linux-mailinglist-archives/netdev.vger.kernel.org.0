Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157D8612FC
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 23:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfGFVBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 17:01:18 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48843 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbfGFVBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 17:01:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 59F8320D87;
        Sat,  6 Jul 2019 17:01:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 06 Jul 2019 17:01:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=T1AD/dD0ZS82vDmE9744+y/ael
        U6ZkgxyzFSdfGRtBA=; b=h6pE+hJoPGRbCNJMtspyZ/kor3OezaIrl4TI8TDmvV
        8PXuFOr+N9uqNJLHqAzRJ5Ku32tVjJFWDIG38O/uQ7gJnObQQdYAkWHsVJA0xmxG
        2qa9o1ZRz66zKH+l24pl++7zb1v5yv8YKrXLhw4QiMDKgvuauwpqu6OKVIj/Pe7B
        cCGlNIVaRIt/FfO4a3RlzVEG3GlH2OO0OlrNxHU1LR2xP3panzwgEWpotKWSKA6W
        nOLEvqSQcvc4v+8MQb46X/qbzwDUY/hK4/bdFG0PQVWaOZhbqcyk9Bl3Z9CG2OX0
        GOzqUgsJrkayHvOIyDPdmV/QOJjkTPyu7cWmlQGPdIFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=T1AD/dD0ZS82vDmE9
        744+y/aelU6ZkgxyzFSdfGRtBA=; b=FdJxTa6sEeHLIcIweALOeQzf2b790SmGw
        Vfy9iZY6vj/G9jH0nYQxu24TUvxnddWc4hoM5ItztUXDJ8TqbALxPoL1e4PBkH8q
        hZ/f807agXpbxM0VBEbH2epizN7RUskaieed7hViNlgW4cIM8BUUNUpnLEbfHb/O
        GkdCSSjgf2Z3OXeBxx/jrrQvLQkWMWQZHNj0Ve11jt06eHksz9N42Cpba3BnTSmO
        8l8xWbYjeMU6Yo3rcxgRIox1S5yLZ8osLjF0FLIcivOuznKstPuzWuDZJtmzfqZH
        1iTRl6rDsugcUvhqKDgbVqpnHBYXgvI8PmbV62E6tT0x0PV2xFc4A==
X-ME-Sender: <xms:HAwhXU1bjItpVUDxDi0sCputTlkuPCgYj0edYOMLjo5e0DSvySngxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeeigdduheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeggihhntggvnhht
    uceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucfkphepkeekrd
    duvddurdeigedrieegnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhu
    fhhfhidrtgignecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HAwhXdU9Ok3g-jQSD8UQSmwkwzWFON8puqcS4NwwkmyFgTF076kwoA>
    <xmx:HAwhXWCpfop0ogqmOCwunJW0Lv641PHjQfQhuXORxLda5W_YCGF7Pg>
    <xmx:HAwhXfCHL7ZrB2FBy-X8a_pckd_sjP-fV12KpK7M7bplvsMMCdsptg>
    <xmx:HQwhXaDg1kUCIhYI5ukihNMZTRoTr4mBqTkqfnp8brSkKJjCEy62Tw>
Received: from zoro.luffy.cx (4vh54-1-88-121-64-64.fbx.proxad.net [88.121.64.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 109C2380074;
        Sat,  6 Jul 2019 17:01:16 -0400 (EDT)
Received: by zoro.luffy.cx (Postfix, from userid 1000)
        id 982E8ECE; Sat,  6 Jul 2019 23:01:13 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [net-next] bonding: fix value exported by Netlink for peer_notif_delay
Date:   Sat,  6 Jul 2019 23:01:08 +0200
Message-Id: <20190706210108.15293-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFLA_BOND_PEER_NOTIF_DELAY was set to the value of downdelay instead
of peer_notif_delay. After this change, the correct value is exported.

Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 drivers/net/bonding/bond_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index a259860a7208..b43b51646b11 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -547,7 +547,7 @@ static int bond_fill_info(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, IFLA_BOND_PEER_NOTIF_DELAY,
-			bond->params.downdelay * bond->params.miimon))
+			bond->params.peer_notif_delay * bond->params.miimon))
 		goto nla_put_failure;
 
 	if (nla_put_u8(skb, IFLA_BOND_USE_CARRIER, bond->params.use_carrier))
-- 
2.20.1

