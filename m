Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F4965B40F
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbjABPTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbjABPTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:19:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4797A10B0
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:19:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E065060FF4
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AC4C433F1;
        Mon,  2 Jan 2023 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672672751;
        bh=knSu+/O5cCSrRF+pGMwIPmfkx4XeadWS286DamWqvGA=;
        h=From:To:Cc:Subject:Date:From;
        b=aQ6ihy0e5IEBMnb+1Ytx9NKIE70ctojY/i9VYdDgU9UDi8FqFZGzKHXuhtSDebqPW
         rX5WldV8MHKWJv8OWy/7sGvBpvmpR9y76IiTXRIDS3slRur9dASYz0EKL5u4iP3l1x
         AM/GeYsTyJ7TqJkixeamfPWGXwV21odxVXFC576K3ZEde34YUdlpmXGsVJJJ7tlBAd
         CF30PM6GIGHmW129zaoppP7mZNWAUMFf9TE4MGWGH5E3l7UwKEscLSJvau3EG0RlaP
         m1er27t249w/xH292exp+mbLZ3iq1YwX3+Or20dxJFHIMdG1v3BY+6mrkHx8xeb5W6
         fkCVLMMo6CfoA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: [PATCH net-next 0/3] enetc: unlock XDP_REDIRECT for XDP non-linear buffers
Date:   Mon,  2 Jan 2023 16:18:50 +0100
Message-Id: <cover.1672672314.git.lorenzo@kernel.org>
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

