Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81E67B924
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbjAYSTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbjAYSS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:18:58 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEE2589BD
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:18:47 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30PIGDTI135830
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 18:16:15 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30PIG8AV861909
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 19:16:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674670568; bh=F43TzIyXTbxe+nnPtDu9Xhy1PhWy9RHaTSY6Bx1CrAw=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=dDnkD1f1QPOxl4kgZp0Wll3kqEp5r9z5YAsspfJkF35CuP6a7TLaVgn2X1o5c9UZL
         rU95yB6DfmSm65t/5TQEchyxS9YBGtqJOAjE8dbrsVoP5rpSsebNT8TcL5zlAwOFkC
         Kz/Kdh+1huhMnE+hRV54NHLILxW2ZHtvQoPZDmYE=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30PIG6rl861898;
        Wed, 25 Jan 2023 19:16:06 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v4 net 0/3] fixes for mtk_eth_soc
Date:   Wed, 25 Jan 2023 19:15:59 +0100
Message-Id: <20230125181602.861843-1-bjorn@mork.no>
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

Changes since v3:
 - fill hole in struct mtk_pcs with new interface field
 - improved patch 2 commit message
 - added fixes tags
 - updated review tags
 
Changes since v2:
 - use "true" for boolean
 - fix SoB typo
 - updated tags

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

