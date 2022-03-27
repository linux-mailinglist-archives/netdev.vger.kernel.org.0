Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69704E850E
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiC0Czu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiC0Czs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF70E1EC42;
        Sat, 26 Mar 2022 19:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A51660EDA;
        Sun, 27 Mar 2022 02:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEC0C340F3;
        Sun, 27 Mar 2022 02:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349649;
        bh=M5z98S+65E4DMWEg25efhFzYzd8sW4PDeLAD71pyQ4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3c9RBEiiDz0F545CkC7Cenb/oypAPgeZkZyD8h8XFPHLAWv5LDhUIFPHPYZweHM7
         jBmb+dkE6JIQmEeg3lm6khGwHeoKlCb3Ase1PxCddSnBhl5auA7br68UKe26nNDX2w
         oqH+ghiOxuq9XxgMBfoIk8qkm/5u4Tn6IONah8cRQHaZUBYIuBpVsDHB4NmGOmuc/d
         /xZRoChgJr4GysJe+eL1HZKa54Shyir7QgtysBXketE8aEp+UlkvAZCUYBJvR6zprg
         eugphDOYS5HmYlBpcdaJoFvCeiqBJEd/+vTduAoDez0S/vI42+s5RKu4O2GkE2x7ys
         R/Co+jV533zzA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 03/13] docs: netdev: move the patch marking section up
Date:   Sat, 26 Mar 2022 19:53:50 -0700
Message-Id: <20220327025400.2481365-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220327025400.2481365-1-kuba@kernel.org>
References: <20220327025400.2481365-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 28 ++++++++++++-------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index f7e5755e013e..0bff899f286f 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -35,6 +35,20 @@ mainline tree from Linus, and ``net-next`` is where the new code goes
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
+bug-fix ``net`` content.  If you don't use git, then note the only magic
+in the above is just the subject text of the outgoing e-mail, and you
+can manually change it yourself with whatever MUA you are comfortable
+with.
+
 How often do changes from these trees make it to the mainline Linus tree?
 -------------------------------------------------------------------------
 To understand this, you need to know a bit of background information on
@@ -90,20 +104,6 @@ and note the top of the "tags" section.  If it is rc1, it is early in
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

