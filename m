Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274994FBFF9
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243642AbiDKPOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347677AbiDKPOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:14:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416873152B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBA11B80EEB
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 15:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6179CC385AA;
        Mon, 11 Apr 2022 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649689919;
        bh=s5B7vALr+vSz0uveBMbZ/pOyY2Xy+Fl921aZ5Kua4HE=;
        h=From:To:Cc:Subject:Date:From;
        b=nsYbjxdDEM/tv8FGArjA7Xfs6mr4g/pusrd258flAEB3zyGkNSLONsNRSp8/OgQWU
         m4xeXgc+AkSw89ixTagqEe8KrtbHnuBhpZ1YC8jUFvgDkEW49CuDNVdfKGVWGQ0p4P
         oMS0xoEFDIz5FBf1AiwYAIT5+I/wYm7PAk/Nr0nVSFy+NSPulkVaFJCeiYU+XJExSZ
         aH5b0f3I1CvssXCaSGwSYYeyPidp8F+d42UTlASvxBIMLIb2cND+Xo2a/UFt3VAcso
         acIZTiTXytwQHFs44Zn7IEWaHeMXRyX5Jousgeubzc2Dl9HaozSXhVBdTY8O42BWZj
         xfUaKsFkgDJjw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v4 net-next 0/2] net: mvneta: add support for page_pool_get_stats
Date:   Mon, 11 Apr 2022 17:11:40 +0200
Message-Id: <cover.1649689580.git.lorenzo@kernel.org>
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

Changes since v3:
- get rid of wrong for loop in page_pool_ethtool_stats_get()
- add API stubs when page_pool_stats are not compiled in

Changes since v2:
- remove enum list of page_pool stats in page_pool.h
- remove leftover change in mvneta.c for ethtool_stats array allocation

Changes since v1:
- move stats accounting to page_pool code
- move stats string management to page_pool code

Lorenzo Bianconi (2):
  net: page_pool: introduce ethtool stats
  net: mvneta: add support for page_pool_get_stats

 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 20 ++++++++-
 include/net/page_pool.h               | 21 +++++++++
 net/core/page_pool.c                  | 63 ++++++++++++++++++++++++++-
 4 files changed, 103 insertions(+), 2 deletions(-)

-- 
2.35.1

