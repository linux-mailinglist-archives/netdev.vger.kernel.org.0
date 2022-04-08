Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C274F90B0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiDHI0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiDHI0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:26:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F9A18503F
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01B81617A0
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 08:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FE0C385A1;
        Fri,  8 Apr 2022 08:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649406253;
        bh=BkAQF+WNtruKLmN+w4o5HizXdqJvwSsgTcHzn1s2LcI=;
        h=From:To:Cc:Subject:Date:From;
        b=DF7vHAv9s9NZFEoHTQ8oYNCLI34gqOd0SD3wsmtaE6uuVNxqhSrvGtcBnnAcq2O0F
         8TQGMZKDpDWoi4FoypHiikpeEeDJv7j41IbF/1WL3knMFq332VDhfWkif8aW+ZIOLB
         UWMHs8IfO2E3hkIWN8Es6D8b8zMzgRgsiaaRLbezI0vcxMgRELtb6aphwWpqtKR3Dl
         yTB6c5LrVi1E4u/cgGgk+gxT55nvJvpuUuTl3mume2AYXhX19EJKxOoCleYbknM92k
         X9esh9ISKb7hYAvBjXLU+LGvFkpniz3sYneYKdMK/jFXpUJLnY3X0j6d8kaGPV3Mg3
         Yg2jG5kq9kbAQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v2 net-next 0/2] net: mvneta: add support for page_pool_get_stats
Date:   Fri,  8 Apr 2022 10:23:58 +0200
Message-Id: <cover.1649405981.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool stats ethtool APIs in order to avoid driver duplicated
code.

Changes since v1:
- move stats accounting to page_pool code
- move stats string management to page_pool code

Lorenzo Bianconi (2):
  net: page_pool: introduce ethtool stats
  net: mvneta: add support for page_pool_get_stats

 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 38 +++++++++++--
 include/net/page_pool.h               | 24 ++++++++
 net/core/page_pool.c                  | 81 ++++++++++++++++++++++++++-
 4 files changed, 138 insertions(+), 6 deletions(-)

-- 
2.35.1

