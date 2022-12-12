Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33682649C73
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiLLKly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiLLKk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:40:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E2511821;
        Mon, 12 Dec 2022 02:35:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 516C760F97;
        Mon, 12 Dec 2022 10:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62DC433F1;
        Mon, 12 Dec 2022 10:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841314;
        bh=HvNKuWYFW8umeX/fI6aXrzjdk4JcPKrYu3UMnlPw/N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETx9z1jFVQZxak2GQCaa2RqnOYgD+rS+4mKJmtNWGGvpu36BjRed4wvUqpmxn6HG6
         rY4pJh0pRAsuMJ83ZeZY+6JtGueUr9ZBIkGHg7xU16+WMjJoEwcDFApNK1SlQgDE8g
         BXAbpIbVA+3VpoDiTErQ0F+x+/EULy3+VcLgknwd+HNcM/2u0Ju0hyXSGYeGGeo7g2
         KSdMxkdA1kfbFeyCgJUMvZ2l/pgys3HgqMAfzeXhg65Q8yKapkcJ4hmaQLZBnRMalP
         bpDoEe3JBQ/GDG7SOJA8QNF0r7u9XUyorW6WBZGfLsk1I4nTxAa5DCVQeLHmlgPw4J
         Gt3TQ/Nno3eMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 5/7] selftests: net: Use "grep -E" instead of "egrep"
Date:   Mon, 12 Dec 2022 05:35:01 -0500
Message-Id: <20221212103504.299281-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103504.299281-1-sashal@kernel.org>
References: <20221212103504.299281-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6a30d3e3491dc562384e9f15b201a8a25b57439f ]

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E
fix this using "grep -E" instead.

  sed -i "s/egrep/grep -E/g" `grep egrep -rwl tools/testing/selftests/net`

Here are the steps to install the latest grep:

  wget http://ftp.gnu.org/gnu/grep/grep-3.8.tar.gz
  tar xf grep-3.8.tar.gz
  cd grep-3.8 && ./configure && make
  sudo make install
  export PATH=/usr/local/bin:$PATH

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/1669864248-829-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/toeplitz.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/toeplitz.sh b/tools/testing/selftests/net/toeplitz.sh
index 0a49907cd4fe..da5bfd834eff 100755
--- a/tools/testing/selftests/net/toeplitz.sh
+++ b/tools/testing/selftests/net/toeplitz.sh
@@ -32,7 +32,7 @@ DEV="eth0"
 # This is determined by reading the RSS indirection table using ethtool.
 get_rss_cfg_num_rxqs() {
 	echo $(ethtool -x "${DEV}" |
-		egrep [[:space:]]+[0-9]+:[[:space:]]+ |
+		grep -E [[:space:]]+[0-9]+:[[:space:]]+ |
 		cut -d: -f2- |
 		awk '{$1=$1};1' |
 		tr ' ' '\n' |
-- 
2.35.1

