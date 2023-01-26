Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44AF67C143
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 01:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjAZACl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 19:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjAZACk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 19:02:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF922CC47
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 16:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13E2C616E0
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBAAC433EF;
        Thu, 26 Jan 2023 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674691358;
        bh=3KzmZko+eM2DxuiAqLozwKe3kMJ7loFT5jDbJaVqhBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Bv/bAyqkSbny1zvNFBC9wD+/+JLEaeQNesQDLDpnj6W2/8pGl3A/GQViVY5QeWvYF
         NJ941ejHt9rDzajmBlNiEPkfehm9OM7ylK7dhvVxPQcNxIBepHziK3hF75n2R4nw5a
         +od4EHLUHaGQRcS6/tkwnA+V6McsRb5XOcbAXrgZ1ixnQjD3mbTlueV3jT96eRJ28T
         2a3P/GfLwMze8xzbVOqxKs9u5K2tnOdi2NSb1JLH7UzNRLUzpPFXLYydJ7yeS94G9x
         e6MGLNaxvhfczQLpSmjYZUukQyl6M/0ZtEwGRk4C53tMiaxx9MxSuBJVlOvwj2bk/2
         Q7lZktW5IR0Yg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] tools: ynl: prevent reorder and fix flags
Date:   Wed, 25 Jan 2023 16:02:32 -0800
Message-Id: <20230126000235.1085551-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
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

Some codegen improvements for YAML specs.

First, Lorenzon discovered when switching the XDP feature family
to use flags instead of pure enum that the kdoc got garbled.
The support for enum and flags is therefore unified.

Second when regenerating all families we discussed so far I noticed
that some netlink policies jumped around. We need to ensure we don't
render code based on their ordering in a hash.

Jakub Kicinski (3):
  tools: ynl: support kdocs for flags in code generation
  tools: ynl: rename ops_list -> msg_list
  tools: ynl: store ops in ordered dict to avoid random ordering

 tools/net/ynl/ynl-gen-c.py | 50 +++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 22 deletions(-)

-- 
2.39.1

