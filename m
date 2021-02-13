Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF95E31AE53
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhBMWju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhBMWjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:41 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3382AC06178B
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:26 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id y26so5327332eju.13
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TuuJ4/bqRHse6yQ8M5nj5bdMee0+7LhdDXC+eLUmYug=;
        b=DYHzEOxDwwMnsvfXZZyyMZAre/8lR3lIImW8d97y9YnF/lXK/r5JCWp7iPHX1cFg7B
         F3Qrvpmhi7ZOT6xjsTbqLytyA2+C62sGGJYg2B1eFoxGjlq9Y61JPrGhXazkfuUOUx/R
         dwu7BUBDbiNoi2LTVaWaBTfV4FHTX4eZe++OfbQKKy5ISK9pSLGEvZ2PHJHvXMM39D0Y
         mnHSLiQBvuKMbO/3NeFO/1GJZ/8rpBtvq3TYhs8qrYztcSah/9gyGNVP7TYtU1R9+REQ
         0TCjmGR6UlGg5P4r/glmbEjN5sBEuYYbVONyXuEtteac+AOWMN6poWvebeHNqtVgAQuR
         Le1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TuuJ4/bqRHse6yQ8M5nj5bdMee0+7LhdDXC+eLUmYug=;
        b=M0bLKxYjuEmE46aTFENFQiXI6qteFZTB/uk2nJewop0+WWcTJ8odt6iP86LtmP3TNy
         8il8Q5RO6Qwqneap7EmTZWdgzCmevXSEEuwo8grPXx0vU4yGrgPCEOU1XuhOR00MVKd4
         Ag7bTIuGEafq5kWYsQCNfhH0U7DjDVRoelVJ0zGv1k9FBooB5PSYQ+NMHxbhYPyluF2T
         +qQ/ZhFoJLN40mt59YjuY1qBGcvaFtRdblL1dbiuoltsQ3Y0pe9GkQwBK6O9l6coJho2
         6w1jkjI9i0UE0CNjV/PHYnmLW2dpG1Oz2eqpIu2sleYSmAgLky1ptdfeB08zUq01TezA
         G7TA==
X-Gm-Message-State: AOAM531g7DNkZ5TEsJxVsBvucCAqw0qUK1wrKHM7hF80gPyRRWbhs4sE
        6X3mzKGIEi6lSzJiM9C55SI=
X-Google-Smtp-Source: ABdhPJxrrNVDlTiyM2nAxg5zMbZXRqv4ltatn01DkVTzK3nyTfkovStRhYzdcQL1dP6EWDJfNobzew==
X-Received: by 2002:a17:906:ca43:: with SMTP id jx3mr7329520ejb.178.1613255904967;
        Sat, 13 Feb 2021 14:38:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:24 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 06/12] net: dsa: tag_ocelot: avoid accessing ds->priv in ocelot_rcv
Date:   Sun, 14 Feb 2021 00:37:55 +0200
Message-Id: <20210213223801.1334216-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Taggers should be written to do something valid irrespective of the
switch driver that they are attached to. This is even more true now,
because since the introduction of the .change_tag_protocol method, a
certain tagger is not necessarily strictly associated with a driver any
longer, and I would like to be able to test all taggers with dsa_loop in
the future.

In the case of ocelot, it needs to move the classified VLAN from the DSA
tag into the skb if the port is VLAN-aware. We can allow it to do that
by looking at the dp->vlan_filtering property, no need to invoke
structures which are specific to ocelot.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_ocelot.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 16a1afd5b8e1..225b145fd131 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -177,12 +177,10 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 				  struct net_device *netdev,
 				  struct packet_type *pt)
 {
-	struct dsa_port *cpu_dp = netdev->dsa_ptr;
-	struct dsa_switch *ds = cpu_dp->ds;
-	struct ocelot *ocelot = ds->priv;
 	u64 src_port, qos_class;
 	u64 vlan_tci, tag_type;
 	u8 *start = skb->data;
+	struct dsa_port *dp;
 	u8 *extraction;
 	u16 vlan_tpid;
 
@@ -243,9 +241,10 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	 * equal to the pvid of the ingress port and should not be used for
 	 * processing.
 	 */
+	dp = dsa_slave_to_port(skb->dev);
 	vlan_tpid = tag_type ? ETH_P_8021AD : ETH_P_8021Q;
 
-	if (ocelot->ports[src_port]->vlan_aware &&
+	if (dsa_port_is_vlan_filtering(dp) &&
 	    eth_hdr(skb)->h_proto == htons(vlan_tpid)) {
 		u16 dummy_vlan_tci;
 
-- 
2.25.1

