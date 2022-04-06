Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA044F6D4E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbiDFVuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiDFVtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:49:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F58A25FD
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123D861B6F
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 21:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393C7C385A3;
        Wed,  6 Apr 2022 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649281078;
        bh=MZkV9vG8ymPGa120OYlY1KzRfaLklUgFeoaTRo1/MPA=;
        h=From:To:Cc:Subject:Date:From;
        b=ts0GCRKkhzfRkAamEb2dD1iK4kX/LNF/bUj8rMJ53Bs4FkGGPT0t8+fsLkSFcZsD4
         HUcJ/p6KHhNhhjuwjAaMWGe3E6sJbS8pllYgCn1FkXyTwZr7iZGPTRyoF2yl8WxdSm
         Si09IDRJruCVvcLvViTLsGaRFPdzC8tB96r9EUBGUh2w22540y9X7mJLSj7eTLWSNF
         oMgiEM3djtWWGADy+rtvw3+ZUJZthhpOatquD9lUhNXk0GD2Kxn1XaNVbLcLCuEcaC
         3o+a61u4WHQv1EhMnAsxXxHJW9KjxLttW2htjvuFSvlMFjf7kdPAMymQL55jf5iHGx
         m4GKMYcmv7dDw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: create a net/core/ internal header
Date:   Wed,  6 Apr 2022 14:37:51 -0700
Message-Id: <20220406213754.731066-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
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

We are adding stuff to netdevice.h which really should be
local to net/core/. Create a net/core/dev.h header and use it.
Minor cleanups precede.

Jakub Kicinski (3):
  net: hyperv: remove use of bpf_op_t
  net: unexport a handful of dev_* functions
  net: extract a few internals from netdevice.h

 drivers/net/hyperv/netvsc_bpf.c |  6 +--
 include/linux/netdevice.h       | 72 +-------------------------
 net/core/dev.c                  |  7 +--
 net/core/dev.h                  | 91 +++++++++++++++++++++++++++++++++
 net/core/dev_addr_lists.c       |  2 +
 net/core/dev_ioctl.c            |  2 +
 net/core/link_watch.c           |  1 +
 net/core/net-procfs.c           |  2 +
 net/core/net-sysfs.c            |  1 +
 net/core/rtnetlink.c            |  2 +
 net/core/sock.c                 |  2 +
 net/core/sysctl_net_core.c      |  2 +
 12 files changed, 110 insertions(+), 80 deletions(-)
 create mode 100644 net/core/dev.h

-- 
2.34.1

