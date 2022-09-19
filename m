Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9215BC4B3
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiISIsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiISIsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:48:37 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51D122509;
        Mon, 19 Sep 2022 01:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wyupJayZSIFm4y9yPMluAd5MbviJpk1Su8GT/MLhOjk=; b=tzfQxWbqUmiJCTkn6p5176GEvQ
        Nr6iSRPO7XqqBoc37yt3n2c+COIOanKNp8KNtjNY+RguFlz0Wsy9QxyYFIKZqIE9Oxh1eY0kmRJYx
        /JsBRFyUcGpPsBDIYiCwkqm8BRd3ETaTlz1G3hCxFRxaxCF7oawUnvoiXw2E2ZKAXoU+lfOMRDxix
        jk9K3Qx2pruXgvmesvP0GU8Lo8Hl6aHL4KBsjqHXs5KZqtKIEB1PaaN4Y2in7gGCPbRaY0tZL0tnl
        gOTd3gam97FlNbNM0VVv75owScUUoaMFORiruwkKmUKeRBGiVSGO2Ff1EnF7FjoqVzb97WmF72S2a
        e3Erp5ig==;
Received: from dynamic-089-204-138-189.89.204.138.pool.telefonica.de ([89.204.138.189] helo=localhost.localdomain)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oaCHH-0015f0-Lm; Mon, 19 Sep 2022 08:37:19 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/5] net: mediatek: sgmii stability
Date:   Mon, 19 Sep 2022 10:37:07 +0200
Message-Id: <20220919083713.730512-1-lynxis@fe80.eu>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:
 - add & improve comments on unexpected hw behaviour
 - add patch refactor power cycling into mtk_pcs_config()

Alexander Couzens (5):
  net: mediatek: sgmii: fix powering up the SGMII phy
  net: mediatek: sgmii: ensure the SGMII PHY is powered down on
    configuration
  net: mediatek: sgmii: mtk_pcs_setup_mode_an: don't rely on register
    defaults
  net: mediatek: sgmii: set the speed according to the phy interface in
    AN
  net: mediatek: sgmii: refactor power cycling into mtk_pcs_config()

 drivers/net/ethernet/mediatek/mtk_sgmii.c | 41 ++++++++++++++++-------
 1 file changed, 28 insertions(+), 13 deletions(-)

-- 
2.37.3

