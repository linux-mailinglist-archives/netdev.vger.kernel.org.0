Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36BF59B0D2
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 00:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiHTWq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 18:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiHTWq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 18:46:26 -0400
Received: from mail.base45.de (mail.base45.de [IPv6:2001:67c:2050:320::77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C41222BC;
        Sat, 20 Aug 2022 15:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pFonu2+lyt11nAqs0JC7/r1UiLi62A30gEOaW5uexqQ=; b=a0O0grs72eKVIeOH7cGcs0m6J/
        alQ0bRsmg/rpD6yDbdNXZmd1/uWpAhUFoQ1V45N0XKO4hptMrRfJqVuPYQ0YfQ3BhJXXPPXceYR34
        Qy/OsSVMvaAJPoifh4u46vFjwAX4vO4l3JNNAcHJReINVNM75MrYUGBZWGF+48NdFomcg/SKQ4Q8K
        SRdV/MmDNlhF5lGXwq4bUxyou4zrbYE5t8koViEqrY9t8SMgRVIw2KPSThLGp77F9edumEqRDnBQ7
        XVDl8t54PRsr4E4rL7clp+s4Mkn5YVJNigScqtKJPZAf6vHbmOVOgsEvJxR6xVoagB8qnbOh+xOLA
        lYWPK/Pg==;
Received: from [2a02:2454:9869:1a:9eb6:54ff:0:fa5] (helo=cerator.lan)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oPXE4-00G2sh-OA; Sat, 20 Aug 2022 22:45:56 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH 0/4] net: mediatek: sgmii: add support to change interface parameter while running
Date:   Sun, 21 Aug 2022 00:45:34 +0200
Message-Id: <20220820224538.59489-1-lynxis@fe80.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When connecting the SGMII interface to a 2.5gbit ethernet phy (e.g. rtl8221
or a SFP slot) the SGMII interface need to change the SGMII connection
parameters (speed, autoneg, duplex, ..) while running to match the phy speed.

Alexander Couzens (4):
  net: mediatek: sgmii: fix powering up the SGMII phy
  net: mediatek: sgmii: ensure the SGMII PHY is powered down on
    configuration
  net: mediatek: sgmii: mtk_pcs_setup_mode_an: don't rely on register
    defaults
  net: mediatek: sgmii: set the speed according to the phy interface in
    AN

 drivers/net/ethernet/mediatek/mtk_sgmii.c | 40 ++++++++++++++++-------
 1 file changed, 29 insertions(+), 11 deletions(-)

-- 
2.35.1

