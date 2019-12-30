Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B0A12D0C0
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfL3OcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:32:17 -0500
Received: from fd.dlink.ru ([178.170.168.18]:40704 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbfL3OcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:32:16 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 3FF421B21941; Mon, 30 Dec 2019 17:32:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 3FF421B21941
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716334; bh=YK6u2SeWu80P0OI5Ey+MvrHZ5A/LDUTcrFuPYPEXrWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=EA1crrXz1GwC40iHZFRzzrND2voKAaX5s5KNo+7EyC2gZUcG2Nrjc4J5R+YsyRh06
         3M7soGsBe8fekotFvSmHiI68RHQYOvGtoowoMl69q5Lhna24DPRstIeT68HlIUPMSq
         80rUdu6Z0FPseMgsyeha9yefLk78RcRjbsZhBi5c=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 5C4301B2181E;
        Mon, 30 Dec 2019 17:31:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 5C4301B2181E
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 5FCF01B229D0;
        Mon, 30 Dec 2019 17:31:23 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:23 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 11/19] net: dsa: tag_lan9303: add .flow_dissect() callback
Date:   Mon, 30 Dec 2019 17:30:19 +0300
Message-Id: <20191230143028.27313-12-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes Rx packet hashing on RPS-enabled systems.
Misc: fix lan9303_netdev_ops identation.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_lan9303.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index eb0e7a32e53d..d328a44381a9 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -128,12 +128,20 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
+static void lan9303_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
+{
+	*offset = LAN9303_TAG_LEN;
+	*proto = *(__be16 *)(skb->data + 2);
+}
+
 static const struct dsa_device_ops lan9303_netdev_ops = {
-	.name = "lan9303",
-	.proto	= DSA_TAG_PROTO_LAN9303,
-	.xmit = lan9303_xmit,
-	.rcv = lan9303_rcv,
-	.overhead = LAN9303_TAG_LEN,
+	.name		= "lan9303",
+	.proto		= DSA_TAG_PROTO_LAN9303,
+	.xmit		= lan9303_xmit,
+	.rcv		= lan9303_rcv,
+	.flow_dissect	= lan9303_flow_dissect,
+	.overhead	= LAN9303_TAG_LEN,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.24.1

