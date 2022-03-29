Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6064EA6EE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiC2FKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiC2FKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5093462FC;
        Mon, 28 Mar 2022 22:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EDD0CE18CA;
        Tue, 29 Mar 2022 05:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A8EC34113;
        Tue, 29 Mar 2022 05:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530525;
        bh=18LOwxv9Crwm5nuEP3OKoqUwMwIaZcaevvmmZ1Z0ICg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQiF9mAvkz9VlCBkW7KDYUP5v4m1XcqqY3FsWVo36/wiVumjtBMZpDGfV2YERHIAg
         LCJGW67mTL1r2mDNLlXS8DNjgfyC/26KPZlvU13HuYMUC2j1UwIl76BlWWzJgWkavO
         TsouoDdUeF4TSwAQ+x2yN61IXs23Hes6MuzXqkP+k+nHALn4am05uCc4XmorUSOnao
         eQMke+VT2FI8hOPEwK615pvDlx9e5u6TV+v7Ox60TupjgV1W6Vrbn7fRilpOw4Gr98
         EA10jWjXcXNNp76C1rEJ9J6mxvIG6h3iMleQA7qVOF+m92cOjtI04W4FW2aDEH443o
         y0+RRTbMH79iA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 03/14] docs: netdev: move the patch marking section up
Date:   Mon, 28 Mar 2022 22:08:19 -0700
Message-Id: <20220329050830.2755213-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329050830.2755213-1-kuba@kernel.org>
References: <20220329050830.2755213-1-kuba@kernel.org>
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

We want people to mark their patches with net and net-next in the subject.
Many miss doing that. Move the FAQ section which points that out up, and
place it after the section which enumerates the trees, that seems like
a pretty logical place for it. Since the two sections are together we
can remove a little bit (not too much) of the repetition.

v2: also remove the text for non-git setups, we want people to use git.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index f7e5755e013e..fd5f5a1a0846 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -35,6 +35,17 @@ mainline tree from Linus, and ``net-next`` is where the new code goes
 - https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 - https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 
+How do I indicate which tree (net vs. net-next) my patch should be in?
+----------------------------------------------------------------------
+To help maintainers and CI bots you should explicitly mark which tree
+your patch is targeting. Assuming that you use git, use the prefix
+flag::
+
+  git format-patch --subject-prefix='PATCH net-next' start..finish
+
+Use ``net`` instead of ``net-next`` (always lower case) in the above for
+bug-fix ``net`` content.
+
 How often do changes from these trees make it to the mainline Linus tree?
 -------------------------------------------------------------------------
 To understand this, you need to know a bit of background information on
@@ -90,20 +101,6 @@ and note the top of the "tags" section.  If it is rc1, it is early in
 the dev cycle.  If it was tagged rc7 a week ago, then a release is
 probably imminent.
 
-How do I indicate which tree (net vs. net-next) my patch should be in?
-----------------------------------------------------------------------
-Firstly, think whether you have a bug fix or new "next-like" content.
-Then once decided, assuming that you use git, use the prefix flag, i.e.
-::
-
-  git format-patch --subject-prefix='PATCH net-next' start..finish
-
-Use ``net`` instead of ``net-next`` (always lower case) in the above for
-bug-fix ``net`` content.  If you don't use git, then note the only magic
-in the above is just the subject text of the outgoing e-mail, and you
-can manually change it yourself with whatever MUA you are comfortable
-with.
-
 I sent a patch and I'm wondering what happened to it - how can I tell whether it got merged?
 --------------------------------------------------------------------------------------------
 Start by looking at the main patchworks queue for netdev:
-- 
2.34.1

