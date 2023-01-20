Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C71675B11
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjATRVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjATRVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:21:38 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354D510D8;
        Fri, 20 Jan 2023 09:21:37 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id vw16so15620808ejc.12;
        Fri, 20 Jan 2023 09:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u40jSdsDUNf/iyjtahOuC7vMZ2vI8Jji9vcKYxRCKQw=;
        b=TJP6csfD/IlV/97VdrGsA34Bt3VnCAfvIow5mu3sklPOQcnoDDGWLA0NS9gKnHlQiR
         TM2MXJd6hyz7UOQR1eRhOczlAsff/oe57TUQTRrkpKOywqdkGbFNBNRFSm2uso4Bo0Io
         wTErLamFFx3zv47JQuvRtW4ehKYx6L5NGMTJ9LdFLQPaGzLIGcMi3KPaE/bxV5j6AWUi
         IVpD8ssE8ONwXa/p9pvDKazMfxw4Q01whJpD7bGNrbL28XmL5TqeFd2L13pHOHApNNL/
         5iBeDs6RUWiuGhiJz3wDC+yH7QQgqJIrb69MAl/iV4g55nYvQ4cMKdchrKbjYnO848V/
         DOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u40jSdsDUNf/iyjtahOuC7vMZ2vI8Jji9vcKYxRCKQw=;
        b=ygygTLtQr7Y7vPnXe2bs9Z3ByUZq3jZM3xiaR436t/VxTxPa2ZSy4OolUQYkc1wu0/
         GcNs9dqZEeJeP2QamyWzTUSt+6QCynrnSWFcBnl1atLTzadGfsxniJYN3LWFicT04WkA
         bcAUtRwB//PtKhJMVBqYLWrwkmexUFIbohGffvNPQZXzrKEaa1kzHOTFlQKlFSCjIJS2
         ztdRA9rCa8rKRAxoE1+XWmE7IDhInpablhbXR1cVUe/aihCmHU7gIs8Jj/KMUuCBbpgu
         btREuhb4NC3j6OsutdWR/4AsZ3pn3fS0U6713E6+kjvEpZBclLA4s9adgvhCTlfflFXc
         XHiw==
X-Gm-Message-State: AFqh2krfG22C5eD07jWJIJLxnibBkjw1KOvOFtrRrJUtWPalcRPZ6u6f
        PiKPHHIXljG0GYk/thY4Jqs=
X-Google-Smtp-Source: AMrXdXvU6twa5cRzhDrJDUnpw1VVdfEuIefHjaypZ+5wnhWWNw1xPnbnE9UCtBkhdkr5gr+0fPtBuw==
X-Received: by 2002:a17:906:d8ab:b0:86f:50ff:ef25 with SMTP id qc11-20020a170906d8ab00b0086f50ffef25mr16071208ejb.63.1674235295668;
        Fri, 20 Jan 2023 09:21:35 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id e2-20020a170906314200b007c08439161dsm18082864eje.50.2023.01.20.09.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 09:21:35 -0800 (PST)
Date:   Fri, 20 Jan 2023 19:21:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
Message-ID: <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Frank,

On Fri, Jan 20, 2023 at 05:45:35PM +0100, Frank Wunderlich wrote:
> Hi,
> 
> noticed a bug while testing systemd, but it is reproducable with iproute2
> 
> tested on bananapi-r2 with kernel 5.15.80 and bananapi-r3 with kernel 6.2-rc1,
> both use mt7530 dsa driver but different configs (mt7530 vs. mt7531).
> have no other devices to test.
> 
> first create vlan on wan-port (wan and lan0 are dsa-user-ports on same gmac)
> 
> netif=wan
> ip link set $netif up
> ip link add link $netif name vlan110 type vlan id 110
> ip link set vlan110 up
> ip addr add 192.168.110.1/24 dev vlan110
> 
> vlan works now, other side pingable, vlan-tagged packets visible in tcpdump on both sides

VLAN 110 is a software VLAN, it is never committed to hardware in the
switch.

> now create the vlan-sware bridge (without vlan_filtering it works in my test)
> 
> BRIDGE=lanbr0
> ip link add name ${BRIDGE} type bridge vlan_filtering 1 vlan_default_pvid 1
> ip link set ${BRIDGE} up
> ip link set lan0 master ${BRIDGE}
> ip link set lan0 up
> 
> takes some time before it is applied and ping got lost
> 
> packets are received by other end but without vlan-tag

What happens in mt7530_port_vlan_filtering() is that the user port (lan0)
*and* the CPU port become VLAN aware. I guess it is the change on the
CPU port that affects the traffic to "wan". But I don't see yet why this
affects the traffic in the way you mention (the CPU port strips the tag
instead of dropping packets with VLAN 110).

I have 2 random things to suggest you try.

First is this

From 2991f704e6f341bd81296e91fbb4381f528f8c7f Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 20 Jan 2023 19:17:16 +0200
Subject: [PATCH] mt7530 don't make the CPU port a VLAN user port

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 616b21c90d05..7265c120c767 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1524,7 +1524,7 @@ mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 		 * for becoming a VLAN-aware port.
 		 */
 		mt7530_port_set_vlan_aware(ds, port);
-		mt7530_port_set_vlan_aware(ds, cpu_dp->index);
+//		mt7530_port_set_vlan_aware(ds, cpu_dp->index);
 	} else {
 		mt7530_port_set_vlan_unaware(ds, port);
 	}

If this works, I expect it will break VLAN tagged traffic over lan0 now :)
So I would then like you to remove the first patch and try the next one

From 1b6842c8fc57f6fda28db576170173f5c146e470 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 20 Jan 2023 19:17:51 +0200
Subject: [PATCH 2/2] tag_mtk only combine VLAN tag with MTK tag is user port
 is VLAN aware

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_mtk.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 40af80452747..ab027c233bee 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -35,14 +35,13 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * the both special and VLAN tag at the same time and then look up VLAN
 	 * table with VID.
 	 */
-	switch (skb->protocol) {
-	case htons(ETH_P_8021Q):
+	if (dsa_port_is_vlan_filtering(dp) &&
+	    skb->protocol == htons(ETH_P_8021Q)) {
 		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_8100;
-		break;
-	case htons(ETH_P_8021AD):
+	} else if (dsa_port_is_vlan_filtering(dp) &&
+		   skb->protocol == htons(ETH_P_8021AD)) {
 		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_88A8;
-		break;
-	default:
+	} else {
 		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
 		skb_push(skb, MTK_HDR_LEN);
 		dsa_alloc_etype_header(skb, MTK_HDR_LEN);
