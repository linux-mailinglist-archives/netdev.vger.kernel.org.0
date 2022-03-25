Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C484E7509
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245023AbiCYOaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiCYOaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:30:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C8E49FBB
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D0B9B82889
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1F0C340E9;
        Fri, 25 Mar 2022 14:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648218511;
        bh=hlilWdCJBP0C/0AcOiLsAfbq1qZFCY/G0STmP7ntXsM=;
        h=From:To:Cc:Subject:Date:From;
        b=lvBEZ08+Zf9WjvjPziwXelhON4/ZP7AO8E8K04heDAsLnBeY9uAi7h9sUP3rHMepv
         i+FxUwZekQdic4+ieU9DKZ9dx06aYYqwv4U+3QU9D+DgfQNa1BqwBaf1h1CBhuxloF
         5iLLqg14yafVC81C/UrqzP7Jtm4zR9G3YhPS015r4N3BLplcLP9YflRXSVlhs8RcFr
         vlYhh5RFFsN40+qb4mG7KJvT7N93d4pb5LFAdE46OhHkqhLDGP3/y2oWFfx0t22Ha/
         qgr/BAml2Bx7vp+E1BwvnvhwVNGdCCmKL/QuK+QytXDXvfrVNIxwn9L0n0z2MPLaXr
         qS4NxCmM78HQg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jbrouer@redhat.com, magnus.karlsson@intel.com, toke@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC net-next 0/2] Introduce xdp tx mb support for i40e and ixgbe
Date:   Fri, 25 Mar 2022 15:28:10 +0100
Message-Id: <cover.1648218138.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the capability to map non-linear xdp frames in ndo_xdp_xmit and XDP_TX
for i40e and ixgbe drivers.

Lorenzo Bianconi (2):
  ixgbe: add xdp frags support to ndo_xdp_xmit
  i40e: add xdp frags support to ndo_xdp_xmit

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 86 +++++++++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 99 ++++++++++++-------
 2 files changed, 124 insertions(+), 61 deletions(-)

-- 
2.35.1

