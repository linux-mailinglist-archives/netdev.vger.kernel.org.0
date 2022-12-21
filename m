Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E24A653674
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiLUSkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiLUSkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:40:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E937B26571
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 10:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77350B81C02
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFF7C43392;
        Wed, 21 Dec 2022 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671648011;
        bh=aTwTYqknW7/p/E1rglHmpaAz3Tt5tEVG6YdnfKq0/JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgUeS877+r9HDM3imiWN52CunoRpCHWb2Ogc3RFLmk3b2dw5LgAcaq9xNs1GZlTv4
         O9INvCZA7cegeGM07CuXRQ9e4Hu61iP0FVxDr+AbufHYA7F8QaiK0PgDfwZDc33sdO
         FIBAFvBBznnGUiv+gXt6pD8H2zeBsfQzrBA+aID++um++hrb+J0muMvW4WEu+sPS/U
         uAyWPTGmDgkdngEWaUhbWUQncvMjx5aze++GY2QHyGTgJ2d3YU71qnKsmcjLcEUsbW
         UDe7UzOVLXCMtgU5UUv0cLdN8jXMMxt2ayQl2P8afxE3mL/va4yzkOHPMlgR5L5W5+
         wMvIVEeJueDbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        f.fainelli@gmail.com, andrew@lunn.ch, rdunlap@infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] docs: netdev: convert to a non-FAQ document
Date:   Wed, 21 Dec 2022 10:40:07 -0800
Message-Id: <20221221184007.1170384-3-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221184007.1170384-1-kuba@kernel.org>
References: <20221221184007.1170384-1-kuba@kernel.org>
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

The netdev-FAQ document has grown over the years to the point
where finding information in it is somewhat challenging.
The length of the questions prevents readers from locating
content that's relevant at a glance.

Convert to a more standard documentation format with sections
and sub-sections rather than questions and answers.

The content edits are limited to what's necessary to change
the format, and very minor clarifications.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-netdev.rst | 215 +++++++++++---------
 1 file changed, 122 insertions(+), 93 deletions(-)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index 8f22f8a3dcd1..a91e11002b87 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -15,14 +15,15 @@ tl;dr
  - don't repost your patches within one 24h period
  - reverse xmas tree
 
-What is netdev?
----------------
-It is a mailing list for all network-related Linux stuff.  This
+netdev
+------
+
+netdev is a mailing list for all network-related Linux stuff.  This
 includes anything found under net/ (i.e. core code like IPv6) and
 drivers/net (i.e. hardware specific drivers) in the Linux source tree.
 
 Note that some subsystems (e.g. wireless drivers) which have a high
-volume of traffic have their own specific mailing lists.
+volume of traffic have their own specific mailing lists and trees.
 
 The netdev list is managed (like many other Linux mailing lists) through
 VGER (http://vger.kernel.org/) with archives available at
@@ -32,21 +33,10 @@ Aside from subsystems like those mentioned above, all network-related
 Linux development (i.e. RFC, review, comments, etc.) takes place on
 netdev.
 
-How do the changes posted to netdev make their way into Linux?
---------------------------------------------------------------
-There are always two trees (git repositories) in play.  Both are
-driven by David Miller, the main network maintainer.  There is the
-``net`` tree, and the ``net-next`` tree.  As you can probably guess from
-the names, the ``net`` tree is for fixes to existing code already in the
-mainline tree from Linus, and ``net-next`` is where the new code goes
-for the future release.  You can find the trees here:
-
-- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
-- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
+Development cycle
+-----------------
 
-How often do changes from these trees make it to the mainline Linus tree?
--------------------------------------------------------------------------
-To understand this, you need to know a bit of background information on
+Here is a bit of background information on
 the cadence of Linux development.  Each new release starts off with a
 two week "merge window" where the main maintainers feed their new stuff
 to Linus for merging into the mainline tree.  After the two weeks, the
@@ -58,9 +48,33 @@ rc2 is released.  This repeats on a roughly weekly basis until rc7
 state of churn), and a week after the last vX.Y-rcN was done, the
 official vX.Y is released.
 
-Relating that to netdev: At the beginning of the 2-week merge window,
-the ``net-next`` tree will be closed - no new changes/features.  The
-accumulated new content of the past ~10 weeks will be passed onto
+To find out where we are now in the cycle - load the mainline (Linus)
+page here:
+
+  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+
+and note the top of the "tags" section.  If it is rc1, it is early in
+the dev cycle.  If it was tagged rc7 a week ago, then a release is
+probably imminent. If the most recent tag is a final release tag
+(without an ``-rcN`` suffix) - we are most likely in a merge window
+and ``net-next`` is closed.
+
+git trees and patch flow
+------------------------
+
+There are two networking trees (git repositories) in play.  Both are
+driven by David Miller, the main network maintainer.  There is the
+``net`` tree, and the ``net-next`` tree.  As you can probably guess from
+the names, the ``net`` tree is for fixes to existing code already in the
+mainline tree from Linus, and ``net-next`` is where the new code goes
+for the future release.  You can find the trees here:
+
+- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
+- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
+
+Relating that to kernel development: At the beginning of the 2-week
+merge window, the ``net-next`` tree will be closed - no new changes/features.
+The accumulated new content of the past ~10 weeks will be passed onto
 mainline/Linus via a pull request for vX.Y -- at the same time, the
 ``net`` tree will start accumulating fixes for this pulled content
 relating to vX.Y
@@ -92,22 +106,14 @@ focus for ``net`` is on stabilization and bug fixes.
 
 Finally, the vX.Y gets released, and the whole cycle starts over.
 
-So where are we now in this cycle?
-----------------------------------
+netdev patch review
+-------------------
 
-Load the mainline (Linus) page here:
+Patch status
+~~~~~~~~~~~~
 
-  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-
-and note the top of the "tags" section.  If it is rc1, it is early in
-the dev cycle.  If it was tagged rc7 a week ago, then a release is
-probably imminent. If the most recent tag is a final release tag
-(without an ``-rcN`` suffix) - we are most likely in a merge window
-and ``net-next`` is closed.
-
-How can I tell the status of a patch I've sent?
------------------------------------------------
-Start by looking at the main patchworks queue for netdev:
+Status of a patch can be checked by looking at the main patchwork
+queue for netdev:
 
   https://patchwork.kernel.org/project/netdevbpf/list/
 
@@ -116,17 +122,20 @@ patch. Patches are indexed by the ``Message-ID`` header of the emails
 which carried them so if you have trouble finding your patch append
 the value of ``Message-ID`` to the URL above.
 
-Should I directly update patchwork state of my own patches?
------------------------------------------------------------
+Updating patch status
+~~~~~~~~~~~~~~~~~~~~~
+
 It may be tempting to help the maintainers and update the state of your
-own patches when you post a new version or spot a bug. Please do not do that.
+own patches when you post a new version or spot a bug. Please **do not**
+do that.
 Interfering with the patch status on patchwork will only cause confusion. Leave
 it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
 
-How long before my patch is accepted?
--------------------------------------
+Review timelines
+~~~~~~~~~~~~~~~~
+
 Generally speaking, the patches get triaged quickly (in less than
 48h). But be patient, if your patch is active in patchwork (i.e. it's
 listed on the project's patch list) the chances it was missed are close to zero.
@@ -134,37 +143,47 @@ Asking the maintainer for status updates on your
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
-I made changes to only a few patches in a patch series should I resend only those changed?
-------------------------------------------------------------------------------------------
-No, please resend the entire patch series and make sure you do number your
+Partial resends
+~~~~~~~~~~~~~~~
+
+Please always resend the entire patch series and make sure you do number your
 patches such that it is clear this is the latest and greatest set of patches
-that can be applied.
+that can be applied. Do not try to resend just the patches which changed.
+
+Handling misapplied patches
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-I submitted multiple versions of a patch series and it looks like a version other than the last one has been accepted, what should I do?
-----------------------------------------------------------------------------------------------------------------------------------------
+Occasionally a patch series gets applied before receiving critical feedback,
+or the wrong version of a series gets applied.
 There is no revert possible, once it is pushed out, it stays like that.
 Please send incremental versions on top of what has been merged in order to fix
 the patches the way they would look like if your latest patch series was to be
 merged.
 
-Are there special rules regarding stable submissions on netdev?
----------------------------------------------------------------
+Stable tree
+~~~~~~~~~~~
+
 While it used to be the case that netdev submissions were not supposed
 to carry explicit ``CC: stable@vger.kernel.org`` tags that is no longer
 the case today. Please follow the standard stable rules in
 :ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`,
 and make sure you include appropriate Fixes tags!
 
-I found a bug that might have possible security implications or similar. Should I mail the main netdev maintainer off-list?
----------------------------------------------------------------------------------------------------------------------------
-No. The current netdev maintainer has consistently requested that
+Security fixes
+~~~~~~~~~~~~~~
+
+Do not email netdev maintainers directly if you think you discovered
+a bug that might have possible security implications.
+The current netdev maintainer has consistently requested that
 people use the mailing lists and not reach out directly.  If you aren't
 OK with that, then perhaps consider mailing security@kernel.org or
 reading about http://oss-security.openwall.org/wiki/mailing-lists/distros
 as possible alternative mechanisms.
 
-How do I post corresponding changes to user space components?
--------------------------------------------------------------
+
+Co-posting changes to user space components
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 User space code exercising kernel features should be posted
 alongside kernel patches. This gives reviewers a chance to see
 how any new interface is used and how well it works.
@@ -189,9 +208,10 @@ user space patches should form separate series (threads) when posted
 Posting as one thread is discouraged because it confuses patchwork
 (as of patchwork 2.2.2).
 
-Any other tips to help ensure my net/net-next patch gets OK'd?
---------------------------------------------------------------
-Attention to detail.  Re-read your own work as if you were the
+Preparing changes
+-----------------
+
+Attention to detail is important.  Re-read your own work as if you were the
 reviewer.  You can start with using ``checkpatch.pl``, perhaps even with
 the ``--strict`` flag.  But do not be mindlessly robotic in doing so.
 If your change is a bug fix, make sure your commit log indicates the
@@ -206,8 +226,9 @@ Finally, go back and read
 :ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
 to be sure you are not repeating some common mistake documented there.
 
-How do I indicate which tree (net vs. net-next) my patch should be in?
-----------------------------------------------------------------------
+Indicating target tree
+~~~~~~~~~~~~~~~~~~~~~~
+
 To help maintainers and CI bots you should explicitly mark which tree
 your patch is targeting. Assuming that you use git, use the prefix
 flag::
@@ -217,8 +238,8 @@ your patch is targeting. Assuming that you use git, use the prefix
 Use ``net`` instead of ``net-next`` (always lower case) in the above for
 bug-fix ``net`` content.
 
-How do I divide my work into patches?
--------------------------------------
+Dividing work into patches
+~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Put yourself in the shoes of the reviewer. Each patch is read separately
 and therefore should constitute a comprehensible step towards your stated
@@ -231,9 +252,11 @@ just do it. As a result, a sequence of smaller series gets merged quicker and
 with better review coverage. Re-posting large series also increases the mailing
 list traffic.
 
-Is the comment style convention different for the networking content?
----------------------------------------------------------------------
-Yes, in a largely trivial way.  Instead of this::
+Multi-line comments
+~~~~~~~~~~~~~~~~~~~
+
+Comment style convention is slightly different for networking and most of
+the tree.  Instead of this::
 
   /*
    * foobar blah blah blah
@@ -246,8 +269,8 @@ Is the comment style convention different for the networking content?
    * another line of text
    */
 
-What is "reverse xmas tree"?
-----------------------------
+Local variable ordering ("reverse xmas tree", "RCS")
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Netdev has a convention for ordering local variables in functions.
 Order the variable declaration lines longest to shortest, e.g.::
@@ -259,13 +282,16 @@ Netdev has a convention for ordering local variables in functions.
 If there are dependencies between the variables preventing the ordering
 move the initialization out of line.
 
-I am working in existing code which uses non-standard formatting. Which formatting should I use?
-------------------------------------------------------------------------------------------------
-Make your code follow the most recent guidelines, so that eventually all code
+Format precedence
+~~~~~~~~~~~~~~~~~
+
+When working in existing code which uses nonstandard formatting make
+your code follow the most recent guidelines, so that eventually all code
 in the domain of netdev is in the preferred format.
 
-I have received review feedback, when should I post a revised version of the patches?
--------------------------------------------------------------------------------------
+Resending after review
+~~~~~~~~~~~~~~~~~~~~~~
+
 Allow at least 24 hours to pass between postings. This will ensure reviewers
 from all geographical locations have a chance to chime in. Do not wait
 too long (weeks) between postings either as it will make it harder for reviewers
@@ -275,8 +301,12 @@ Make sure you address all the feedback in your new posting. Do not post a new
 version of the code if the discussion about the previous version is still
 ongoing, unless directly instructed by a reviewer.
 
-What level of testing is expected before I submit my change?
-------------------------------------------------------------
+Testing
+-------
+
+Expected level of testing
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
 At the very minimum your changes must survive an ``allyesconfig`` and an
 ``allmodconfig`` build with ``W=1`` set without new warnings or failures.
 
@@ -287,43 +317,42 @@ and the patch series contains a set of kernel selftest for
 You are expected to test your changes on top of the relevant networking
 tree (``net`` or ``net-next``) and not e.g. a stable tree or ``linux-next``.
 
-Can I reproduce the checks from patchwork on my local machine?
---------------------------------------------------------------
+patchwork checks
+~~~~~~~~~~~~~~~~
 
 Checks in patchwork are mostly simple wrappers around existing kernel
 scripts, the sources are available at:
 
 https://github.com/kuba-moo/nipa/tree/master/tests
 
-Running all the builds and checks locally is a pain, can I post my patches and have the patchwork bot validate them?
---------------------------------------------------------------------------------------------------------------------
-
-No, you must ensure that your patches are ready by testing them locally
+**Do not** post your patches just to run them through the checks.
+You must ensure that your patches are ready by testing them locally
 before posting to the mailing list. The patchwork build bot instance
 gets overloaded very easily and netdev@vger really doesn't need more
 traffic if we can help it.
 
-netdevsim is great, can I extend it for my out-of-tree tests?
--------------------------------------------------------------
+netdevsim
+~~~~~~~~~
 
-No, ``netdevsim`` is a test vehicle solely for upstream tests.
-(Please add your tests under ``tools/testing/selftests/``.)
+``netdevsim`` is a test driver which can be used to exercise driver
+configuration APIs without requiring capable hardware.
+Mock-ups and tests based on ``netdevsim`` are strongly encouraged when
+adding new APIs, but ``netdevsim`` in itself is **not** considered
+a use case/user. You must also implement the new APIs in a real driver.
 
-We also give no guarantees that ``netdevsim`` won't change in the future
+We give no guarantees that ``netdevsim`` won't change in the future
 in a way which would break what would normally be considered uAPI.
 
-Is netdevsim considered a "user" of an API?
--------------------------------------------
-
-Linux kernel has a long standing rule that no API should be added unless
-it has a real, in-tree user. Mock-ups and tests based on ``netdevsim`` are
-strongly encouraged when adding new APIs, but ``netdevsim`` in itself
-is **not** considered a use case/user.
+``netdevsim`` is reserved for use by upstream tests only, so any
+new ``netdevsim`` features must be accompanied by selftests under
+``tools/testing/selftests/``.
 
-My company uses peer feedback in employee performance reviews. Can I ask netdev maintainers for feedback?
----------------------------------------------------------------------------------------------------------
+Testimonials / feedback
+-----------------------
 
-Yes, especially if you spend significant amount of time reviewing code
+Some companies use peer feedback in employee performance reviews.
+Please feel free to request feedback from netdev maintainers,
+especially if you spend significant amount of time reviewing code
 and go out of your way to improve shared infrastructure.
 
 The feedback must be requested by you, the contributor, and will always
-- 
2.38.1

