Return-Path: <netdev+bounces-4213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F9770BB0B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9858A280EA6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78122BA56;
	Mon, 22 May 2023 10:59:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6999B10FB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:59:57 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B12271C;
	Mon, 22 May 2023 03:59:30 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-510d967249aso9893825a12.1;
        Mon, 22 May 2023 03:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684753074; x=1687345074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QbaFtQY4U1SAGZYtnPdu7mZsLG5dGue95mqtDIfDNho=;
        b=G3CDtz9bnVsVmqFfLRO45IIz1boAbDjKVkdd+zs/OFV4laduBB9Xp3d4pSzc1CjMSb
         2mBDqIkjBHBFkNwWyLScLiPLjpaYqO2qeEIc8vMPNBapYffPuMvzMdLA7bJfYtQZN8Kx
         TvUdZTOO8OSh0c/Vq5aXLnvS23xpmTumKfQ4jl/xZAiqNirLwkbC7ML+lETlHi4UaAPv
         IxVxr6Emb5UX8YAB2w+k1c1wApD3g6EYJgvyKOAcDC8WzMrYLvT9MufipHtsLvXv9Awi
         ZoL7sKRihECyB6m7X4VOAF15oQQdwN7hix2PopHfewdLMp45IpYuyMhV+46MWUeuD6BM
         2Zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684753074; x=1687345074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QbaFtQY4U1SAGZYtnPdu7mZsLG5dGue95mqtDIfDNho=;
        b=M7mGDXfyVX4oZHVUKipHG9Fp8I7S/IJ4o4M9pYMJam7+2Q3cFn82nPJPVCo9v+upWG
         S+fcAClBmoIpRcurzvvbQOhjPT3kxWq0S4RIjKPVqvaVWKQPTxF08HvHN6NOpBQR5Vxu
         C7D4lppzBqGsIjFgvLiZYj32g5svs+wawUDNDUPXGZHBd/zOHEbE9hsEhz1yrwqkeA2a
         mrKOZO6cw0a/PJ9Vx52vUYkahvZlk5hDpZ1nIuNu8U55RyLi92gGpuOjT4GOviyrsIut
         /8CywV5LFf88hwE0ssGyAU+nJksGrYOukrZDoVeIB2aGR7ARSbE2yLcVkctGIalHolYa
         /r7A==
X-Gm-Message-State: AC+VfDxeA7uvsUIY+9FZr2mviObMpBlFofsckQhaJmVvCjpmJtcyV614
	X90DE1r1g9aby3plLCq7b5c=
X-Google-Smtp-Source: ACHHUZ78TbJq8LqXSQIeDepyLHEFHjKMiHjFjEk+Shbi+ccEXDB+bV98pAFWBAz2E91KN7IUqlorqg==
X-Received: by 2002:aa7:d956:0:b0:50b:c35b:1ef3 with SMTP id l22-20020aa7d956000000b0050bc35b1ef3mr7288765eds.38.1684753073342;
        Mon, 22 May 2023 03:57:53 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id c3-20020a50f603000000b00510d7152dc7sm3020162edn.30.2023.05.22.03.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 03:57:52 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Frank Wunderlich <frank-w@public-files.de>
Cc: Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix QoS on DSA MAC on non MTK_NETSYS_V2 SoCs
Date: Mon, 22 May 2023 13:57:43 +0300
Message-Id: <20230522105744.37227-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The commit c6d96df9fa2c ("net: ethernet: mtk_eth_soc: drop generic vlan rx
offload, only use DSA untagging") makes VLAN RX offloading to be only used
on the SoCs without the MTK_NETSYS_V2 ability (which are not just MT7621
and MT7622). The commit disables the proper handling of special tagged
(DSA) frames, added with commit 87e3df4961f4 ("net-next: ethernet:
mediatek: add CDM able to recognize the tag for DSA"), for non
MTK_NETSYS_V2 SoCs when it finds a MAC that does not use DSA. So if the
other MAC uses DSA, the CDMQ component transmits DSA tagged frames to the
CPU improperly. This issue can be observed on frames with TCP, for example,
a TCP speed test using iperf3 won't work.

The commit disables the proper handling of special tagged (DSA) frames
because it assumes that these SoCs don't use more than one MAC, which is
wrong. Although I made Frank address this false assumption on the patch log
when they sent the patch on behalf of Felix, the code still made changes
with this assumption.

Therefore, the proper handling of special tagged (DSA) frames must be kept
enabled in all circumstances as it doesn't affect non DSA tagged frames.

Hardware DSA untagging, introduced with the commit 2d7605a72906 ("net:
ethernet: mtk_eth_soc: enable hardware DSA untagging"), and VLAN RX
offloading are operations on the two CDM components of the frame engine,
CDMP and CDMQ, which connect to Packet DMA (PDMA) and QoS DMA (QDMA) and
are between the MACs and the CPU. These operations apply to all MACs of the
SoC so if one MAC uses DSA and the other doesn't, the hardware DSA
untagging operation will cause the CDMP component to transmit non DSA
tagged frames to the CPU improperly.

Since the VLAN RX offloading feature configuration was dropped, VLAN RX
offloading can only be used along with hardware DSA untagging. So, for the
case above, we need to disable both features and leave it to the CPU,
therefore software, to untag the DSA and VLAN tags.

So the correct way to handle this is:

For all SoCs:

Enable the proper handling of special tagged (DSA) frames
(MTK_CDMQ_IG_CTRL).

For non MTK_NETSYS_V2 SoCs:

Enable hardware DSA untagging (MTK_CDMP_IG_CTRL).
Enable VLAN RX offloading (MTK_CDMP_EG_CTRL).

When a non MTK_NETSYS_V2 SoC MAC does not use DSA:

Disable hardware DSA untagging (MTK_CDMP_IG_CTRL).
Disable VLAN RX offloading (MTK_CDMP_EG_CTRL).

Fixes: c6d96df9fa2c ("net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a75fd072082c..834c644b67db 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3269,18 +3269,14 @@ static int mtk_open(struct net_device *dev)
 			eth->dsa_meta[i] = md_dst;
 		}
 	} else {
-		/* Hardware special tag parsing needs to be disabled if at least
-		 * one MAC does not use DSA.
+		/* Hardware DSA untagging and VLAN RX offloading need to be
+		 * disabled if at least one MAC does not use DSA.
 		 */
 		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
 
 		val &= ~MTK_CDMP_STAG_EN;
 		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
 
-		val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
-		val &= ~MTK_CDMQ_STAG_EN;
-		mtk_w32(eth, val, MTK_CDMQ_IG_CTRL);
-
 		mtk_w32(eth, 0, MTK_CDMP_EG_CTRL);
 	}
 
-- 
2.39.2


