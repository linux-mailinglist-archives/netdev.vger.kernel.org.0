Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131B14EB980
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbiC3E1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239331AbiC3E06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:26:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0ADF77;
        Tue, 29 Mar 2022 21:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE3E961557;
        Wed, 30 Mar 2022 04:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FD4C34113;
        Wed, 30 Mar 2022 04:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614313;
        bh=UsrRGzreh0yhSlb7JDzUQnpiSfmiX+Wi47jWa5ruVEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pg1VmtAQv9x8fnu25+qLYB8QZXzEsbwcjhu00JGeGXTGVacEiQ04SbTTrxtcauaos
         wEIOL4yh+IB1ejODBRF0TwpG0T+bab/6TMrhTs2c9pCfZw1wSfWZdDl4jdj/EAIGxe
         xiXky+fRMaou7sgAenGYf4pvNf9fzvCrfnLWn41SqM9eOWy7DhiMBsizqc4jELV/4Q
         arDwCqTaSTJH0I60TOmgWSnwwD6xWxHWL/DuUu+2EwyldS/v9oWZU8toB5adik0naY
         xmsKTUmCxUV9J92IJ4/ojFHB0Ov8ZBT+Y3q5MY9u6aSBvcj1AnMYpXcWrvZnUnwVoq
         BlwoQw2LAY04g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 03/14] docs: netdev: move the patch marking section up
Date:   Tue, 29 Mar 2022 21:24:54 -0700
Message-Id: <20220330042505.2902770-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
References: <20220330042505.2902770-1-kuba@kernel.org>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

