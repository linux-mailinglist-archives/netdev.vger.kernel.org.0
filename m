Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EC45A20F5
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244710AbiHZGi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiHZGi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:38:26 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763D5D11E5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:38:25 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z25so800954lfr.2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=S8Zx2yVdWfQp4McVC/xuqCbg9ff1l41m3pSDDGmvNwo=;
        b=bbSruD9HgG7jOqqUnQt1Q51NPtrWDq0uWzsaGzYKBsCSHy1eg2ia4//AvC5aTLi+k5
         DT0cdNFW+w5/N7x8dMsk+mX1mK7VqrZazzyr9lygvxy1epRdp7EqGxpH3C7yolmN9K/Z
         rTRTKS2yMTHKO6MribeoZ/sKmxmDyPkZlG3Y/SxJsVEpAEZadOq/wxW3xRSa/F8uhcNu
         Yv8M91kb9tIt/TDhqO0akJplge19/w5IkLMxlBBMo1kw4aV4I/iODnN82NmgDScM3UFt
         eAJZUHaNfylSfblsd6uBktnVu8vZVG6MGC0ut4KfciZNZ+twG4JnY0KZw59saKEOkQye
         UOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=S8Zx2yVdWfQp4McVC/xuqCbg9ff1l41m3pSDDGmvNwo=;
        b=LbWHXlUuj9+pJe2t/ncTnFd9wXoWWD//wOakYgFtlW77EPmiUvxczdQNeyhpNPcwiW
         kUVovjUsBjUGdIBljGrvCsBJD00XkLcxlfU48u6zR1+ZBWwywXnmMIUV11opzaoCFaL8
         7BauyGAS34zK2dZ38HagiciFz3tWsg+Wt/6FujR1zqZs95+nM5vdbd8GwGsa3Fv5FQaa
         U5k7nYE6TNJmXj/JXi17NkNsoXi1ZOoOMkfKzwXFFW3O5VlzU2JVE02wRuMIdTWNxvI3
         azmBdw5JoedW/9zWI0ansejdyIlQCcvD2yv8VALv6BLOrcTtPKETtgPNJiY1ckGmU6Nz
         MmoQ==
X-Gm-Message-State: ACgBeo1EVDa/cCuwpY2n1/7Md9eNFvvt4YOqkDdDIyO/zXJXkbl51XHG
        A2iwBuK4poXIFGezjeVdce04QSRCUepxFX0/uUc=
X-Google-Smtp-Source: AA6agR6YKDe25/YJ3KTBVQc2OObebf3RxpVK9Mcwb1Cf8NDs0/zGdJ/LEE5xhXED2i3Vx6qpSWg05w==
X-Received: by 2002:ac2:47f3:0:b0:493:32b:d3d8 with SMTP id b19-20020ac247f3000000b00493032bd3d8mr2242480lfp.191.1661495903469;
        Thu, 25 Aug 2022 23:38:23 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id p6-20020a05651238c600b0048cc076a03dsm253161lft.237.2022.08.25.23.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 23:38:23 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v2 1/3] dsa: Implement RMU layer in DSA
Date:   Fri, 26 Aug 2022 08:38:14 +0200
Message-Id: <20220826063816.948397-2-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220826063816.948397-1-mattias.forsblad@gmail.com>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support handling of layer 2 part for RMU frames which is
handled in-band with other DSA traffic.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h             |   7 +++
 include/uapi/linux/if_ether.h |   1 +
 net/dsa/tag_dsa.c             | 109 +++++++++++++++++++++++++++++++++-
 3 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..54f7f3494f84 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -92,6 +92,7 @@ struct dsa_switch;
 struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
+	int (*inband_xmit)(struct sk_buff *skb, struct net_device *dev, int seq_no);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			     int *offset);
 	int (*connect)(struct dsa_switch *ds);
@@ -1193,6 +1194,12 @@ struct dsa_switch_ops {
 	void	(*master_state_change)(struct dsa_switch *ds,
 				       const struct net_device *master,
 				       bool operational);
+
+	/*
+	 * RMU operations
+	 */
+	int (*inband_receive)(struct dsa_switch *ds, struct sk_buff *skb,
+			int seq_no);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index d370165bc621..9de1bdc7cccc 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -158,6 +158,7 @@
 #define ETH_P_MCTP	0x00FA		/* Management component transport
 					 * protocol packets
 					 */
+#define ETH_P_RMU_DSA   0x00FB          /* RMU DSA protocol */
 
 /*
  *	This is an Ethernet frame header.
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e4b6e3f2a3db..36f02e7dd3c3 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -123,6 +123,90 @@ enum dsa_code {
 	DSA_CODE_RESERVED_7    = 7
 };
 
+#define DSA_RMU_RESV1   0x3e
+#define DSA_RMU         1
+#define DSA_RMU_PRIO    6
+#define DSA_RMU_RESV2   0xf
+
+static int dsa_inband_xmit_ll(struct sk_buff *skb, struct net_device *dev,
+			      const u8 *header, int header_len, int seq_no)
+{
+	static const u8 dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
+	struct dsa_port *dp;
+	struct ethhdr *eth;
+	u8 *data;
+
+	if (!dev)
+		return -ENODEV;
+
+	dp = dsa_slave_to_port(dev);
+	if (!dp)
+		return -ENODEV;
+
+	/* Create RMU L2 header */
+	data = skb_push(skb, 6);
+	data[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
+	data[1] = DSA_RMU_RESV1 << 2 | DSA_RMU << 1;
+	data[2] = DSA_RMU_PRIO << 5 | DSA_RMU_RESV2;
+	data[3] = seq_no;
+	data[4] = 0;
+	data[5] = 0;
+
+	/* Add header if any */
+	if (header) {
+		data = skb_push(skb, header_len);
+		memcpy(data, header, header_len);
+	}
+
+	/* Create MAC header */
+	eth = (struct ethhdr *)skb_push(skb, 2 * ETH_ALEN);
+	memcpy(eth->h_source, dev->dev_addr, ETH_ALEN);
+	memcpy(eth->h_dest, dest_addr, ETH_ALEN);
+
+	skb->protocol = htons(ETH_P_RMU_DSA);
+
+	dev_queue_xmit(skb);
+
+	return 0;
+}
+
+static int dsa_inband_rcv_ll(struct sk_buff *skb, struct net_device *dev)
+{
+	struct dsa_switch *ds;
+	int source_device;
+	u8 *dsa_header;
+	int rcv_seqno;
+	int ret = 0;
+
+	if (!dev || !dev->dsa_ptr)
+		return 0;
+
+	ds = dev->dsa_ptr->ds;
+	if (!ds)
+		return 0;
+
+	dsa_header = skb->data - 2;
+
+	source_device = dsa_header[0] & 0x1f;
+	ds = dsa_switch_find(ds->dst->index, source_device);
+	if (!ds) {
+		net_dbg_ratelimited("DSA inband: Didn't find switch with index %d", source_device);
+		return -EINVAL;
+	}
+
+	/* Get rcv seqno */
+	rcv_seqno = dsa_header[3];
+
+	skb_pull(skb, DSA_HLEN);
+
+	if (ds->ops && ds->ops->inband_receive(ds, skb, rcv_seqno)) {
+		dev_dbg_ratelimited(ds->dev, "DSA inband: error decoding packet");
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
 static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 				   u8 extra)
 {
@@ -218,9 +302,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 
 		switch (code) {
 		case DSA_CODE_FRAME2REG:
-			/* Remote management is not implemented yet,
-			 * drop.
-			 */
+			dsa_inband_rcv_ll(skb, dev);
 			return NULL;
 		case DSA_CODE_ARP_MIRROR:
 		case DSA_CODE_POLICY_MIRROR:
@@ -325,6 +407,12 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
 
+static int dsa_inband_xmit(struct sk_buff *skb, struct net_device *dev,
+			   int seq_no)
+{
+	return dsa_inband_xmit_ll(skb, dev, NULL, 0, seq_no);
+}
+
 static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	return dsa_xmit_ll(skb, dev, 0);
@@ -343,6 +431,7 @@ static const struct dsa_device_ops dsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_DSA,
 	.xmit	  = dsa_xmit,
 	.rcv	  = dsa_rcv,
+	.inband_xmit = dsa_inband_xmit,
 	.needed_headroom = DSA_HLEN,
 };
 
@@ -354,6 +443,19 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_DSA);
 
 #define EDSA_HLEN 8
 
+static int edsa_inband_xmit(struct sk_buff *skb, struct net_device *dev,
+			    int seq_no)
+{
+	u8 edsa_header[4];
+
+	edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
+	edsa_header[1] = ETH_P_EDSA & 0xff;
+	edsa_header[2] = 0x00;
+	edsa_header[3] = 0x00;
+
+	return dsa_inband_xmit_ll(skb, dev, edsa_header, 4, seq_no);
+}
+
 static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	u8 *edsa_header;
@@ -385,6 +487,7 @@ static const struct dsa_device_ops edsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_EDSA,
 	.xmit	  = edsa_xmit,
 	.rcv	  = edsa_rcv,
+	.inband_xmit = edsa_inband_xmit,
 	.needed_headroom = EDSA_HLEN,
 };
 
-- 
2.25.1

