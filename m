Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6346F6F06D7
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 15:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbjD0Npv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 09:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243690AbjD0Nps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 09:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF454699
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9545617C2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD07CC433D2;
        Thu, 27 Apr 2023 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682603139;
        bh=2pNv0Y1V6med9itiHIgMzKtaNpBgSChPkAiSDVob1K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSi9L/ZuGmpkMRat//FdBuCwoH1PL1gwN5OwzF4JnS72NPMekHP6oiE7I0Xvilijm
         HDBff6kDoryK0zikqE3t894xvNFZ3kiXMOh5rv/7LAl7rIDjnOHnqyMjM6iQx604YO
         Jlaug0endVQA37DBDEk+anNVRVRHlmOGF87H9zMQvSMnA3V3tLjBdJIiW6Uvoes4zK
         Xh7IXHliC4Fzeyc2iN+wDgV0riO1ALCOc/vrw5KRwn/JipFnHThoXO8XRdhNhVGel7
         i7jlySxbD3cllMrOReiA4/hIIosvSMIY81vzF3IUbeCzIrf5+RuFOPbeU/TtoYn9AX
         Mu2iqCJRKJfBw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] Documentation: net: net.core.txrehash is not specific to listening sockets
Date:   Thu, 27 Apr 2023 15:45:26 +0200
Message-Id: <20230427134527.18127-4-atenart@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230427134527.18127-1-atenart@kernel.org>
References: <20230427134527.18127-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The net.core.txrehash documentation mentions this knob is for listening
sockets only, while sk_rethink_txhash can be called on SYN and RTO
retransmits on all TCP sockets.

Remove the listening socket part.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 Documentation/admin-guide/sysctl/net.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 466c560b0c30..4877563241f3 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -386,8 +386,8 @@ Default : 0  (for compatibility reasons)
 txrehash
 --------
 
-Controls default hash rethink behaviour on listening socket when SO_TXREHASH
-option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
+Controls default hash rethink behaviour on socket when SO_TXREHASH option is set
+to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
 
 If set to 1 (default), hash rethink is performed on listening socket.
 If set to 0, hash rethink is not performed.
-- 
2.40.0

