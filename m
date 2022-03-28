Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497EC4EA278
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 23:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiC1Vfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 17:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiC1Vff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 17:35:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC076172882
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 14:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91684CE1748
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 21:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4B2C340F0;
        Mon, 28 Mar 2022 21:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648502947;
        bh=8ZO3SkL/qvXcelKaPBSmURvZQzFSBu7EGGEVe2vb/Vk=;
        h=From:To:Cc:Subject:Date:From;
        b=aZqUUoqLmSo8JGaLPAfR7gGhvIaUUAjo1bk8Et5GEqjRi0PXZ/mhO0+e1tLoyZP9l
         XjmD7+QMVotq9+lz2TPAcZFYmh/NEbnyWoUpCe90vdwpGHBmTcpSBp6wE8iJE2WJk7
         OT8HNop37AnfCgg0M/AFOjSyFPp24edHrYh0q1jRB7QE9CfcefCvDgUoW4F7boAtZ7
         geZ6VWxR7b2CZBWqOByfOM3gABzxWDT87+Vnqwe+5oiEeGmNpsdNhUOv1YSXc0MWV2
         pAFI0wQrXhaD89vaPFGi2FPSLDtTuL9it66fJ26l7ZJEvup1v3KE0DNJM25d5h/lVX
         8iDkfhaC4MwEg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, paolo@vger.kernel.org, shuah@kernel.org,
        naresh.kamboju@linaro.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] Revert "selftests: net: Add tls config dependency for tls selftests"
Date:   Mon, 28 Mar 2022 14:29:04 -0700
Message-Id: <20220328212904.2685395-1-kuba@kernel.org>
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

This reverts commit d9142e1cf3bbdaf21337767114ecab26fe702d47.

The test is supposed to run cleanly with TLS is disabled,
to test compatibility with TCP behavior. I can't repro
the failure [1], the problem should be debugged rather
than papered over.

Link: https://lore.kernel.org/all/20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/ [1]
Fixes: d9142e1cf3bb ("selftests: net: Add tls config dependency for tls selftests")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index cecb921a0dbf..ead7963b9bf0 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -43,6 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
-CONFIG_TLS=m
 CONFIG_CRYPTO_SM4=y
 CONFIG_AMT=m
-- 
2.34.1

