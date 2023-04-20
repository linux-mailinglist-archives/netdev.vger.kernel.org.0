Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A2B6E9247
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbjDTLUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbjDTLT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164EC7D9A;
        Thu, 20 Apr 2023 04:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B83861781;
        Thu, 20 Apr 2023 11:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF70C433D2;
        Thu, 20 Apr 2023 11:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681989403;
        bh=LaJPr1LbyYIqkAFj4HBeE8AN2LEDlB4LmtV6S1Pju+Y=;
        h=From:To:Cc:Subject:Date:From;
        b=m+dEtnuK2idwlHhPRW8G1jSSwz9WuwCy3euTg4boKovIP5KQjqBsyckKLWq4Z1dOg
         8gKBq+al1KJUGN5U9F+059IfdMPemyd9OYJZslOHjF0LP0pToHl4fjXYzYp1uTiBRg
         ggA+ZOztYv7P/TpYv7LAC+4IPiPiNcFilS3twXYITGOxK9nkl/1f+zBfQ5iJ2nUkA2
         gQwO7NtYKKddcNdjY3L7o3nPVtmsOjqUuVPZArbr2bQJq1YtBObjOFBSgO81UEHRCP
         cRWmrz4Xbhepi52zO2XXtXZ5l//8O80k3ZPjqCB13g4r8yn7nkA6m/ZxQeLt47oBcC
         0raPYs1RyS9mQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, mtahhan@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next 0/2] add page_pool support for page recycling in veth driver
Date:   Thu, 20 Apr 2023 13:16:20 +0200
Message-Id: <cover.1681987376.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool support in veth driver in order to recycle pages
in veth_convert_skb_to_xdp_buff routine and avoid reallocating the skb
through the page allocator when we run a xdp program on the device and
we receive skbs from the stack.

Lorenzo Bianconi (2):
  net: veth: add page_pool for page recycling
  net: veth: add page_pool stats

 drivers/net/Kconfig |  2 ++
 drivers/net/veth.c  | 74 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 8 deletions(-)

-- 
2.40.0

