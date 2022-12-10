Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B3D648EF6
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLJNxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLJNxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:53:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9F214D21
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 05:53:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FF29B82A35
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 13:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A36C433EF;
        Sat, 10 Dec 2022 13:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670680418;
        bh=L0sHNCkQYdvC02/TymdYxy3uImPhKq5MuvsIdVdOMNI=;
        h=From:To:Cc:Subject:Date:From;
        b=PPnOeZ5XZEDCf2O0ES4P8WsOdSNuCqVng8nrHy3trYvNgGXmBaHNpudzszD1UAi3T
         jZNH8dEqkudB4f5cfjqaWCEuZtbMNZRFHXCsS44Jdtu5SYpfluplIMNy5XRMmxtVTD
         0sCF4sLjXziX0cS39e/OwR5+CS9yvvfr7Ez/R3aQkdrobuqEWDXRJjB21+rGNb+tml
         ykNu787iTw9f4QpqV4HeTlo1AMdyETBTF6j/LNV/qjQpBz+i5F/D5gSZsBiYf9beTy
         zOvxZpHMpZcJ/AO5CvewmOv4rb4E5RzLv8KF6HqMcMUeeuIoFu/skkiSRK4DDJPOhi
         l6o9I8RF4D/hg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 0/2] enetc: unlock XDP_REDIRECT for XDP non-linear
Date:   Sat, 10 Dec 2022 14:53:09 +0100
Message-Id: <cover.1670680119.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
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
Remove xdp_redirect_sg counter and the related ethtool entry since it is
no longer used.

Changes since v2:
- remove xdp_redirect_sg ethtool counter
Changes since v1:
- drop Fixes tag
- unlock XDP_REDIRECT
- populate missing XDP metadata

Please note this patch is just compile tested

Lorenzo Bianconi (2):
  net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
  net: ethernet: enetc: get rid of xdp_redirect_sg counter

 drivers/net/ethernet/freescale/enetc/enetc.c  | 25 ++++++++-----------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  1 -
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 --
 3 files changed, 10 insertions(+), 18 deletions(-)

-- 
2.38.1

