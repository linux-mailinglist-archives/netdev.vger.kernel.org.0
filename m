Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BB765D4CD
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbjADN5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbjADN51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:57:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7A627B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 05:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12599B815EB
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7328FC4339B;
        Wed,  4 Jan 2023 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672840643;
        bh=ULMqxSGiIlX+/vux/X6HAR0+72sLzqqAu1BBPAQ/aJM=;
        h=From:To:Cc:Subject:Date:From;
        b=iig7TcatptADBsul5/4oGD7qGhhU3PSjQW9sHCe2CU8hMoJBEXIKaKNRLSJ3KZGwr
         nemel/aDK/iu03C2wfaZ86cM9G4ooDD0OtERqkbdTp/A9wCRL+E/7ipc/xUYmd8Au8
         7UgZgoiDaKn9ysoGJGnX/P32inX8XCRjBlD9SjgsHDQO6xRVjOYdQRgvjBoRAtbUWe
         DaGpEdWaEHIBMy/kbjVE5d5VKL6z7fxllD2bYroaYMJRXTvJKP6Mx/nhNf7w6Pomj1
         w5kAThbsxuyRU9F/YAJPMIhJgYaYIKRZxDLkSSiDulg8WRMUmcxcu1Vk/BdKSc7nOg
         7qxMgefVXQUQg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: [PATCH v2 net-next 0/3] enetc: unlock XDP_REDIRECT for XDP non-linear buffers
Date:   Wed,  4 Jan 2023 14:57:09 +0100
Message-Id: <cover.1672840490.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlock XDP_REDIRECT for S/G XDP buffer and rely on XDP stack to properly
take care of the frames.
Rely on XDP_FLAGS_HAS_FRAGS flag to check if it really necessary to access
non-linear part of the xdp_buff/xdp_frame.

Changes since v1:
- rebase on top of net-next

Lorenzo Bianconi (3):
  net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
  net: ethernet: enetc: get rid of xdp_redirect_sg counter
  net: ethernet: enetc: do not always access skb_shared_info in the XDP
    path

 drivers/net/ethernet/freescale/enetc/enetc.c  | 38 +++++++++----------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  1 -
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 -
 3 files changed, 18 insertions(+), 23 deletions(-)

-- 
2.39.0

