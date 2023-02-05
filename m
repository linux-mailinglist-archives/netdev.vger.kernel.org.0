Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5701F68B185
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 21:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBEUMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 15:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBEUMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 15:12:15 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4DA1CAC2;
        Sun,  5 Feb 2023 12:12:06 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 12C005C0203;
        Sun,  5 Feb 2023 15:12:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 05 Feb 2023 15:12:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=umbraculum.org;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1675627926; x=
        1675714326; bh=8VsSZkkMWRvOWY9tZMEtwmU5JOkYF2mh7pXIeChgG2k=; b=H
        C8dXG0Se47RIJ5bO3VHAWnq/HJZudqoLWuZa4DtftBAnHjJ8tYiERb+VMRkHkRMT
        ftHkKj36BpCDFaVJIq7U4QE+wQ71lje+ErsvratdtRHyh2HF/8c6twLyNlUKrYbg
        1aUb7MmKhR6RzcMTNRUIJzYD5JpErH/h65tlhtbWvDkPc058aRjH3yv0fR7Z+uYZ
        u3S3YH0r17dclPXWsA10NIdA9xs5WZTEUlh1nty7gjrxVIDdeQlMYULpkeWWxb+z
        nR4Iomu4Yq/ReiRI/sC5OqnrfNKYjRcJMjyHV8zhNB45yWHsr3LzaT57B7ywrx6E
        ia/LUJ9OI5kenyHIjUbnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1675627926; x=1675714326; bh=8VsSZkkMWRvOW
        Y9tZMEtwmU5JOkYF2mh7pXIeChgG2k=; b=YFlgDVbNZHteGZ2l+rJyXJF6Vev9d
        NHdN9mfQUBoWOls0i73h/7xlmFMeWmlDUKAn5sfBsGgG8zwI4oHOuzLYWDhorNh0
        0xBN62elFUYtPdicmkR8snyKE3jhja/jkxXHLDuXoiXPRiiJFPDZ2RMaeavIDkgT
        jMpWALeCGG09Sk1doQr8Yc/fOFkWr5FYU3pp01OcIkSjkoKE0cNEKq85nNiFaago
        67XOaE9kS7Dt7DR0SsBA7H/o9HMoya+XvLOjrf8pq3y7pZ+3hDwp4+LgZcezTjWZ
        GlkiERW0scoq8ENX6upe6sTzlvZDYj5hnkCng5Hr+zpYzEhA4254ZRgdA==
X-ME-Sender: <xms:lQ3gY1O4yC1WQpbvpzl0egyG9o6TFY021cNYDNFXTd-Pfa1BWcTkVA>
    <xme:lQ3gY38piwIh5aJj6sl6GJYucRoAZrpkwdv9-_5kOPqpM-IY_aXXRaUKALr1TUNm-
    010PSMitU0qsXqumtI>
X-ME-Received: <xmr:lQ3gY0Qd_Xb2ihrLRfQRDxanUMkWcJ9wFegx_xkUo3HHa4nxCJ-jKIVJTL_Y-3NHSagiwwl3EKWHttJPbqEri931X3uGppRAP13ntw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeggedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflohhn
    rghsucfuuhhhrhcuvehhrhhishhtvghnshgvnhcuoehjshgtsehumhgsrhgrtghulhhumh
    drohhrgheqnecuggftrfgrthhtvghrnhepieevleeguedviefgfedtjeeuuddtjeekheff
    ueffhfejieevleffffekjeffgedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepjhhstgesuhhmsghrrggtuhhluhhmrdhorhhg
X-ME-Proxy: <xmx:lQ3gYxv6o0m73p0GCEPHdEItPI3RHVYfWiSk787GqwZPQwCKG4L_Nw>
    <xmx:lQ3gY9eDreQYWBql7hyk3AiO0s1WeTKThepOOd5L5DZEO6p5L_fbsw>
    <xmx:lQ3gY93obr_J5lwzl4VZqeIIle3gFczpbIOTCf1dhhdoNx17RykF4A>
    <xmx:lg3gYw-pZrPPFmNUXT95b3HQ6y1Iqt68zO9t0Wb_PPfZw348eVP29Q>
Feedback-ID: i06314781:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Feb 2023 15:12:03 -0500 (EST)
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
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/2] net: ll_temac: Reset buffer on dma_map_single() errors
Date:   Sun,  5 Feb 2023 21:11:28 +0100
Message-Id: <20230205201130.11303-3-jsc@umbraculum.org>
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

To avoid later calls to dma_unmap_single() on address'
that fails to be mapped, free the allocated skb and
set the pointer of the address to NULL. Eg. when a mapping
fails temac_dma_bd_release() will try to call dma_unmap_single()
on that address if the structure is not reset.

Fixes: d07c849cd2b9 ("net: ll_temac: Add more error handling of dma_map_single() calls")

Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 74423adbe50d..df43f5bc3bd3 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -376,8 +376,11 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 					      XTE_MAX_JUMBO_FRAME_SIZE,
 					      DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr))
+		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr)) {
+			dev_kfree_skb(lp->rx_skb[i]);
+			lp->rx_skb[i] = NULL;
 			goto out;
+		}
 		lp->rx_bd_v[i].phys = cpu_to_be32(skb_dma_addr);
 		lp->rx_bd_v[i].len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
 		lp->rx_bd_v[i].app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
-- 
2.39.1

