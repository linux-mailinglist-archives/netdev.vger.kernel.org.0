Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4116752CF
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjATKxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjATKxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:53:54 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008B44DBD4
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:53:52 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30KApJel2373803
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 10:51:20 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30KApEDd4049249
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 11:51:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674211874; bh=WE6qZG5iNFuNSzU3WrmZnUUJhI0MdWV9WtqYjeTaqm8=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=ERhzrL7Z9Fhi8O2/IIzPetIVDYX2Sxc41EtA8kh7535iLP38AAa4Hqc+DQhIS+Ssh
         z2/Qv9g49RVWsrlrKa7QKe1IoXLVi62Dn+C28Pbtn2pmobiJFKZHZLJxn7q578/kxq
         yAbCByW18oOY3sbkX0dUvkrMiFFvNDG8ofqYVGjA=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30KApCV04049248;
        Fri, 20 Jan 2023 11:51:12 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v2 net 0/3] fixes for mtk_eth_soc
Date:   Fri, 20 Jan 2023 11:49:44 +0100
Message-Id: <20230120104947.4048820-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v1:
- only power down on changes, fix from Russel
- dropped bogus uncondional in-band patch
- added pcs poll patch from Alexander
- updated tags


Fix mtk_eth_soc sgmii configuration.

This has been tested on a MT7986 with a Maxlinear GPY211C phy
permanently attached to the second SoC mac.

Alexander Couzens (2):
  net: mediatek: sgmii: ensure the SGMII PHY is powered down on
    configuration
  mtk_sgmii: enable PCS polling to allow SFP work

Bjørn Mork (1):
  net: mediatek: sgmii: fix duplex configuration

 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  4 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 46 ++++++++++++++-------
 2 files changed, 35 insertions(+), 15 deletions(-)

-- 
2.30.2

