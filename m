Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882DA4B02ED
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiBJCCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:02:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiBJCAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9E9D7D;
        Wed,  9 Feb 2022 17:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5393B82384;
        Thu, 10 Feb 2022 00:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC03DC340F0;
        Thu, 10 Feb 2022 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453414;
        bh=qiy2E63xVa7aC8GpFfZNLgYRs3T3bXfU69vEgfTtdsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GauRYauZlU145G0R6Mwp34gk3/1KAZC/ASVri3egxm4W87M2/Cp5vICs4FbIx/ykr
         h7/bBkby5LE/43lkD6wmARusEOa3rmIlkJYvu7wXSPtistr7lQZGVqAi1k5COxT5+b
         rO6/zS9PlYLk7/V6sWqdQpVjmqN/q+v9jzaEySP8MPth4eNM5FMmwm3APoy+MNZxYx
         hMy1jWxLRweep/2H2PvtXXbXD7g9+0yiaTyyhHwZN/yIAuYHs0/ByH2lbbmgOZlxhc
         Pa3tjD16rPOkY4qO2PaPeoLOmsdPY7RgyL132yNFgDHEg22iMMAs7f+5oioLkfZ2RH
         UokXOLp3UPnwA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/11] net: ping6: remove a pr_debug() statement
Date:   Wed,  9 Feb 2022 16:36:39 -0800
Message-Id: <20220210003649.3120861-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
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

We have ftrace and BPF today, there's no need for printing arguments
at the start of a function.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/ping.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 9256f6ba87ef..86a72f7a61cf 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -59,8 +59,6 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct pingfakehdr pfh;
 	struct ipcm6_cookie ipc6;
 
-	pr_debug("ping_v6_sendmsg(sk=%p,sk->num=%u)\n", inet, inet->inet_num);
-
 	err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
 				  sizeof(user_icmph));
 	if (err)
-- 
2.34.1

