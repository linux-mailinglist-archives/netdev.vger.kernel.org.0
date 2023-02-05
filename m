Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D229B68B183
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 21:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjBEUMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 15:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBEUL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 15:11:59 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE341BACF;
        Sun,  5 Feb 2023 12:11:56 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A9B55C01F5;
        Sun,  5 Feb 2023 15:11:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 05 Feb 2023 15:11:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=umbraculum.org;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1675627916; x=
        1675714316; bh=hA3dCPmbSRjezrNAShgEdpiu7lZnljDCdF+ebyU75Mc=; b=X
        rpyY0ibRff82kZxjCR07DZM8l97UAL+cuBtEf7FlU9W0q7dhDOcOdTK2V8yHyeUL
        QB4QirwmFz/oEACLImPViizYz2qmqzlg609kAw/LIomX52i1mrmD/3Xn2zspNFH6
        P2E5TQLTpqXfxevuXRxYQxlY38gis1wH5X0O+ZmpbBAcFpzLHQGweTRLRJJ0aMq3
        PfZ7qqWKj+HDZcZ4nuw7WfcZD1K7ebfWV6glzolfgHx57+vEeJHIt13smbjlJX8t
        mPlk3ffY6zip3KgOZqA9iB16ObBIkDzF/jY9kiF+7hCtqWJlOTJf9UZiOWK2sRll
        EIWfuppFzHgDXDuO4oesg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1675627916; x=1675714316; bh=hA3dCPmbSRjez
        rNAShgEdpiu7lZnljDCdF+ebyU75Mc=; b=U06os4K0gcRBVtqN+2+EQRYaZmYUp
        CkOosO2+A4mwYAqSRJlZkGAvOFQRm92Nptew/WeABgHHDBrD69ShAhm30A+Y0YpY
        iX+Ww8AfnLiwbtpXozjohasUU4NwQOk7w0nhCVKoXSeTACHlQWH5dSIz0xqT0gT3
        v9jEmR2rmZjnYaINAhkcoLZQDnLzjqlzSFCY477uhKHLXRJAlJxMaSVy8peEdkhE
        pPbzGbCTAZnDr6zYCT54s2obie84XHNOOT8SLscyPiXb7dtBVWlk0rl+9MXKTc8s
        t08oGMzphvzPGk7zRoOn/GtVDm2qg+vAyILfqAT4WEs1hql9eb99ZFx6Q==
X-ME-Sender: <xms:jA3gY1LtS1E0nDeYQmd8zpjhJstiCtjAmc3t6ESWTe8ynqQZyoJN0A>
    <xme:jA3gYxLUGQB2GDn79olIRCSSILAzN4oq17MK78CsNsgiayce6k6-yWIV95OuXok9C
    EpnXiIXMLd6NZO7HVM>
X-ME-Received: <xmr:jA3gY9vPf1P5AiaZVA-Ueon4ZbhEuo0k22bh2KcIFUKVv-Dhg8wa0LSJkg8f5EZi3hofpQ4w6jRROzrceze3gjXxDBBxAbzolAWMlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeggedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflohhn
    rghsucfuuhhhrhcuvehhrhhishhtvghnshgvnhcuoehjshgtsehumhgsrhgrtghulhhumh
    drohhrgheqnecuggftrfgrthhtvghrnhepieevleeguedviefgfedtjeeuuddtjeekheff
    ueffhfejieevleffffekjeffgedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepjhhstgesuhhmsghrrggtuhhluhhmrdhorhhg
X-ME-Proxy: <xmx:jA3gY2au8S4JVqajdDOtPfZwMWpOIM2dv2GhW00fwVjsAuglNBbtHQ>
    <xmx:jA3gY8ap4pWrUX8SUX6doIG36W2xj_Q46ABiFq8GYqffgXLJoYVshQ>
    <xmx:jA3gY6DJeC3si3tWw-1GTbnoxQ5bKR55-phZa_W3AYuu0pwmSQeA8A>
    <xmx:jA3gY8rr5nm5g2i6VN5u2lU0b0DDi-YF8cmyHNeiczTxF_Vt4KqzEQ>
Feedback-ID: i06314781:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Feb 2023 15:11:53 -0500 (EST)
From:   Jonas Suhr Christensen <jsc@umbraculum.org>
To:     netdev@vger.kernel.org
Cc:     jsc@umbraculum.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Wang Qing <wangqing@vivo.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Date:   Sun,  5 Feb 2023 21:11:27 +0100
Message-Id: <20230205201130.11303-2-jsc@umbraculum.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230205201130.11303-1-jsc@umbraculum.org>
References: <20230205201130.11303-1-jsc@umbraculum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing conversion of address when unmapping dma region causing
unmapping to silently fail. At some point resulting in buffer
overrun eg. when releasing device.

Fixes: fdd7454ecb29 ("net: ll_temac: Fix support for little-endian platforms")

Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1066420d6a83..74423adbe50d 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -299,6 +299,7 @@ static int temac_dcr_setup(struct temac_local *lp, struct platform_device *op,
 static void temac_dma_bd_release(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
+	struct cdmac_bd *bd;
 	int i;
 
 	/* Reset Local Link (DMA) */
@@ -307,9 +308,14 @@ static void temac_dma_bd_release(struct net_device *ndev)
 	for (i = 0; i < lp->rx_bd_num; i++) {
 		if (!lp->rx_skb[i])
 			break;
-		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
+
+		bd = &lp->rx_bd_v[i];
+		dma_unmap_single(ndev->dev.parent, be32_to_cpu(bd->phys),
 				 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
+		bd->phys = 0;
+		bd->len = 0;
 		dev_kfree_skb(lp->rx_skb[i]);
+		lp->rx_skb[i] = NULL;
 	}
 	if (lp->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
-- 
2.39.1

