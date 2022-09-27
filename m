Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB0C5ECF3A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 23:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiI0VXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 17:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiI0VXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 17:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE2C1E2742
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 14:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC37AB81D90
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 21:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E6C433C1;
        Tue, 27 Sep 2022 21:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664313789;
        bh=x1sqVtNxGmDjTQI9Pt13+gSuuqKsGBlbdDuYyi6/N4U=;
        h=From:To:Cc:Subject:Date:From;
        b=qThyCiWr67p888qdklvd9SFGwTPSyeD7c0NcLA6EZavvHp+SL8zM+tmj+AJSDYBMt
         4+2y3iHn/yE2Ek8JjF0ILTnF+cWUoXFlE5q/q9hWQoKQoRylY6UnplwqxefdzFHjzq
         3ysXcJJk4S7riC9qeCz48Nuz0ckAx2KYGT6QhY8/Fx+/Mdo4tA2zY9+8arYTgpKvc2
         eWtXjAtDDNIXAkTEhyqOYd9Zytw74KPZNfRjB9SDkI5y7BVAWV3T15suNOyQk16QNE
         cNBejPrchxaew25DSfeViW9VGM/gFLmPtYjJffLVEFcgoaKl0Qd6/YYxCtL8jHmBoi
         qUvpJdKfXdcVQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] docs: netlink: clarify the historical baggage of Netlink flags
Date:   Tue, 27 Sep 2022 14:23:06 -0700
Message-Id: <20220927212306.823862-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nlmsg_flags are full of historical baggage, inconsistencies and
strangeness. Try to document it more thoroughly. Explain the meaning
of the ECHO flag (and while at it clarify the comment in the uAPI).
Handwave a little about the NEW request flags and how they make
sense on the surface but cater to really old paradigm before commands
were a thing.

I will add more notes on how to make use of ECHO and discouragement
for reuse of flags to the kernel-side documentation.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Florian Westphal <fw@strlen.de>
CC: Jamal Hadi Salim <jhs@mojatatu.com>
CC: Jacob Keller <jacob.e.keller@intel.com>
CC: Florent Fourcot <florent.fourcot@wifirst.fr>
CC: Guillaume Nault <gnault@redhat.com>
CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC: Nikolay Aleksandrov <razor@blackwall.org>
CC: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/userspace-api/netlink/intro.rst | 61 +++++++++++++++----
 include/uapi/linux/netlink.h                  |  2 +-
 2 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/Documentation/userspace-api/netlink/intro.rst b/Documentation/userspace-api/netlink/intro.rst
index 8f1220756412..0955e9f203d3 100644
--- a/Documentation/userspace-api/netlink/intro.rst
+++ b/Documentation/userspace-api/netlink/intro.rst
@@ -623,22 +623,57 @@ Even though other protocols and Generic Netlink commands often use
 the same verbs in their message names (``GET``, ``SET``) the concept
 of request types did not find wider adoption.
 
-Message flags
--------------
+Notification echo
+-----------------
+
+``NLM_F_ECHO`` requests for notifications resulting from the request
+to be queued onto the requesting socket. This is useful to discover
+the impact of the request.
+
+Note that this feature is not universally implemented.
+
+Other request-type-specific flags
+---------------------------------
+
+Classic Netlink defined various flags for its ``GET``, ``NEW``
+and ``DEL`` requests in the upper byte of nlmsg_flags in struct nlmsghdr.
+Since request types have not been generalized the request type specific
+flags are rarely used (and considered deprecated for new families).
+
+For ``GET`` - ``NLM_F_ROOT`` and ``NLM_F_MATCH`` are combined into
+``NLM_F_DUMP``, and not used separately. ``NLM_F_ATOMIC`` is never used.
+
+For ``DEL`` - ``NLM_F_NONREC`` is only used by nftables and ``NLM_F_BULK``
+only by FDB some operations.
+
+The flags for ``NEW`` are used most commonly in classic Netlink. Unfortunately,
+the meaning is not crystal clear. The following description is based on the
+best guess of the intention of the authors, and in practice all families
+stray from it in one way or another. ``NLM_F_REPLACE`` asks to replace
+an existing object, if no matching object exists the operation should fail.
+``NLM_F_EXCL`` has the opposite semantics and only succeeds if object already
+existed.
+``NLM_F_CREATE`` asks for the object to be created if it does not
+exist, it can be combined with ``NLM_F_REPLACE`` and ``NLM_F_EXCL``.
+
+A comment in the main Netlink uAPI header states::
+
+   4.4BSD ADD		NLM_F_CREATE|NLM_F_EXCL
+   4.4BSD CHANGE	NLM_F_REPLACE
 
-The earlier section has already covered the basic request flags
-(``NLM_F_REQUEST``, ``NLM_F_ACK``, ``NLM_F_DUMP``) and the ``NLMSG_ERROR`` /
-``NLMSG_DONE`` flags (``NLM_F_CAPPED``, ``NLM_F_ACK_TLVS``).
-Dump flags were also mentioned (``NLM_F_MULTI``, ``NLM_F_DUMP_INTR``).
+   True CHANGE		NLM_F_CREATE|NLM_F_REPLACE
+   Append		NLM_F_CREATE
+   Check		NLM_F_EXCL
 
-Those are the main flags of note, with a small exception (of ``ieee802154``)
-Generic Netlink does not make use of other flags. If the protocol needs
-to communicate special constraints for a request it should use
-an attribute, not the flags in struct nlmsghdr.
+which seems to indicate that those flags predate request types.
+``NLM_F_REPLACE`` without ``NLM_F_CREATE`` was initially used instead
+of ``SET`` commands.
+``NLM_F_EXCL`` without ``NLM_F_CREATE`` was used to check if object exists
+without creating it, presumably predating ``GET`` commands.
 
-Classic Netlink, however, defined various flags for its ``GET``, ``NEW``
-and ``DEL`` requests. Since request types have not been generalized
-the request type specific flags should not be used either.
+``NLM_F_APPEND`` indicates that if one key can have multiple objects associated
+with it (e.g. multiple next-hop objects for a route) the new object should be
+added to the list rather than replacing the entire list.
 
 uAPI reference
 ==============
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index e0689dbd2cde..e2ae82e3f9f7 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -62,7 +62,7 @@ struct nlmsghdr {
 #define NLM_F_REQUEST		0x01	/* It is request message. 	*/
 #define NLM_F_MULTI		0x02	/* Multipart message, terminated by NLMSG_DONE */
 #define NLM_F_ACK		0x04	/* Reply with ack, with zero or error code */
-#define NLM_F_ECHO		0x08	/* Echo this request 		*/
+#define NLM_F_ECHO		0x08	/* Receive resulting notifications */
 #define NLM_F_DUMP_INTR		0x10	/* Dump was inconsistent due to sequence change */
 #define NLM_F_DUMP_FILTERED	0x20	/* Dump was filtered as requested */
 
-- 
2.37.3

