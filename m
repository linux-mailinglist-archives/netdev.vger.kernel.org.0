Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73255834C6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiG0VVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiG0VVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:21:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E2E50199
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38262B82281
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 21:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B6AC433D6;
        Wed, 27 Jul 2022 21:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658956875;
        bh=hsXWvrOQMYYiYAKmb1RQ9cRC/SAAdiV4e8gFyATgBZc=;
        h=From:To:Cc:Subject:Date:From;
        b=EEvL5aPwbxkTIK0fAlzahjWAu8MzgvdIF3U3LIGA8rCYsvL0YGXFb7ylm/lRQg5pq
         lVIl2MS7rFWOv7yN1KzxvMNpVRaUGf6TMooAqwGwW6T1fuU0khqWqZYozE4suAT+Ly
         NhH1XzA5l/ltONaK1Z/JyI41gJQCpiUtIjdslVHgx8BZ8Fv7c1iqfjVwzTCj9AgDmT
         PjPz04hMVLaPMi7l3k4RXha7m0UqmZxkf7AOkiNfbtJtmkX7IcKW06ezmw+IYWWjeC
         gVeBNV0NRw95deBfi09BdzJC/LtE/FEmOUnBPhVjNs0XcBNqxGSAvHNluvpaXWSqx1
         6nyHHvU7qKn1g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net-next 0/3] mtk_eth_soc: introduce xdp multi-frag support
Date:   Wed, 27 Jul 2022 23:20:49 +0200
Message-Id: <cover.1658955249.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mtk_eth_soc driver to xdp_return_frame_bulk APIs.

Lorenzo Bianconi (3):
  net: ethernet: mtk_eth_soc: introduce mtk_xdp_frame_map utility
    routine
  net: ethernet: mtk_eth_soc: introduce xdp multi-frag support
  net: ethernet: mtk_eth_soc: add xdp tx return bulking support

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 193 +++++++++++++-------
 1 file changed, 128 insertions(+), 65 deletions(-)

-- 
2.37.1

