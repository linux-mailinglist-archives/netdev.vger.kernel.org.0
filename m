Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6858832B3ED
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840306AbhCCEID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244928AbhCCCr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 21:47:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A59C64E89;
        Wed,  3 Mar 2021 02:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614739605;
        bh=QT/8bmf5dPEmthQP7Fe5jfJ3tysWF75GUfb5X2QJnyk=;
        h=From:To:Cc:Subject:Date:From;
        b=MlBFf39bQ/XA8vTyNYOThxb5g6HDj6Jksv7hvdMawfbb8VJDQtKyf+Ne99LwxwmLS
         LzTNUqea4QusETyQ90NhHOicasQVi0jowqGR+JoUAEZ48xS09MiTtedbd6v0E6jNGM
         McodoPs2pG0p1ckmsxtoCrUhcLDfOVo7egOqSUAPgxkl5eDAv2gpcsLc3w60XPXeyZ
         4W31w0rGopB5hxLmPQtdzNiCnzdAQH9g06d/WZlknP0ayvF9YO89QxlNxLFIqPSGqj
         M0gNK9dky1KApbF4b0028nAdlpyv6xYmr/PA0F17tVJtkf8V2mcVu+GKsiNfa4dNym
         50YPhTAN+hCSA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: networking: drop special stable handling
Date:   Tue,  2 Mar 2021 18:46:43 -0800
Message-Id: <20210303024643.1076846-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leave it to Greg.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst       | 72 ++-----------------
 Documentation/process/stable-kernel-rules.rst |  6 --
 Documentation/process/submitting-patches.rst  |  5 --
 3 files changed, 6 insertions(+), 77 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index a64c01b52b4c..91b2cf712801 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -142,73 +142,13 @@ Please send incremental versions on top of what has been merged in order to fix
 the patches the way they would look like if your latest patch series was to be
 merged.
 
-How can I tell what patches are queued up for backporting to the various stable releases?
------------------------------------------------------------------------------------------
-Normally Greg Kroah-Hartman collects stable commits himself, but for
-networking, Dave collects up patches he deems critical for the
-networking subsystem, and then hands them off to Greg.
-
-There is a patchworks queue that you can see here:
-
-  https://patchwork.kernel.org/bundle/netdev/stable/?state=*
-
-It contains the patches which Dave has selected, but not yet handed off
-to Greg.  If Greg already has the patch, then it will be here:
-
-  https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
-
-A quick way to find whether the patch is in this stable-queue is to
-simply clone the repo, and then git grep the mainline commit ID, e.g.
-::
-
-  stable-queue$ git grep -l 284041ef21fdf2e
-  releases/3.0.84/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
-  releases/3.4.51/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
-  releases/3.9.8/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
-  stable/stable-queue$
-
-I see a network patch and I think it should be backported to stable. Should I request it via stable@vger.kernel.org like the references in the kernel's Documentation/process/stable-kernel-rules.rst file say?
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-No, not for networking.  Check the stable queues as per above first
-to see if it is already queued.  If not, then send a mail to netdev,
-listing the upstream commit ID and why you think it should be a stable
-candidate.
-
-Before you jump to go do the above, do note that the normal stable rules
-in :ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`
-still apply.  So you need to explicitly indicate why it is a critical
-fix and exactly what users are impacted.  In addition, you need to
-convince yourself that you *really* think it has been overlooked,
-vs. having been considered and rejected.
-
-Generally speaking, the longer it has had a chance to "soak" in
-mainline, the better the odds that it is an OK candidate for stable.  So
-scrambling to request a commit be added the day after it appears should
-be avoided.
-
-I have created a network patch and I think it should be backported to stable. Should I add a Cc: stable@vger.kernel.org like the references in the kernel's Documentation/ directory say?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-No.  See above answer.  In short, if you think it really belongs in
-stable, then ensure you write a decent commit log that describes who
-gets impacted by the bug fix and how it manifests itself, and when the
-bug was introduced.  If you do that properly, then the commit will get
-handled appropriately and most likely get put in the patchworks stable
-queue if it really warrants it.
-
-If you think there is some valid information relating to it being in
-stable that does *not* belong in the commit log, then use the three dash
-marker line as described in
-:ref:`Documentation/process/submitting-patches.rst <the_canonical_patch_format>`
-to temporarily embed that information into the patch that you send.
-
-Are all networking bug fixes backported to all stable releases?
+Are there special rules regarding stable submissions on netdev?
 ---------------------------------------------------------------
-Due to capacity, Dave could only take care of the backports for the
-last two stable releases. For earlier stable releases, each stable
-branch maintainer is supposed to take care of them. If you find any
-patch is missing from an earlier stable branch, please notify
-stable@vger.kernel.org with either a commit ID or a formal patch
-backported, and CC Dave and other relevant networking developers.
+While it used to be the case that netdev submissions were not supposed
+to carry explicit ``CC: stable@vger.kernel.org`` tags that is no longer
+the case today. Please follow the standard stable rules in
+:ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`,
+and make sure you include appropriate Fixes tags!
 
 Is the comment style convention different for the networking content?
 ---------------------------------------------------------------------
diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index 3973556250e1..003c865e9c21 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -35,12 +35,6 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 Procedure for submitting patches to the -stable tree
 ----------------------------------------------------
 
- - If the patch covers files in net/ or drivers/net please follow netdev stable
-   submission guidelines as described in
-   :ref:`Documentation/networking/netdev-FAQ.rst <netdev-FAQ>`
-   after first checking the stable networking queue at
-   https://patchwork.kernel.org/bundle/netdev/stable/?state=*
-   to ensure the requested patch is not already queued up.
  - Security patches should not be handled (solely) by the -stable review
    process but should follow the procedures in
    :ref:`Documentation/admin-guide/security-bugs.rst <securitybugs>`.
diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
index 8c991c863628..91de63b201c1 100644
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -250,11 +250,6 @@ should also read
 :ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`
 in addition to this file.
 
-Note, however, that some subsystem maintainers want to come to their own
-conclusions on which patches should go to the stable trees.  The networking
-maintainer, in particular, would rather not see individual developers
-adding lines like the above to their patches.
-
 If changes affect userland-kernel interfaces, please send the MAN-PAGES
 maintainer (as listed in the MAINTAINERS file) a man-pages patch, or at
 least a notification of the change, so that some information makes its way
-- 
2.26.2

