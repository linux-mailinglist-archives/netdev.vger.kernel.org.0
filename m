Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD413122AA
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBGI20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:28:26 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:55889 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230051AbhBGIYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:24:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 958975801A6;
        Sun,  7 Feb 2021 03:23:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=durX5d6NI8cC2uK0fr5jIDaWAs32TUQoOX+SvmGJqhA=; b=Qxlio/re
        aub+8xUEj4ReEI/sG0dasYP2OMCnftylOW/m/b1whcl9RkhPtDQOA7OY/9/MPFcR
        IuTlOd2JSeqUG9IoyAnwgE2YcKXruVa0Z2DA6/kwDF6vdVP72HKg54BYe/FpYuGN
        AGEiI8HqYeLy1XXzeRaudFQxjqat3VRYGv2X1gpfRJp3ySvcF82jXlE+P+C7evrd
        iGKbxn4ut37B4RXPF/PuSi9QoydWWWrstXs3YsttMlT83G9u3i6GSQeaHpA7OCxd
        Ex03dhHx9F+DIOo84t+MVFPNZZu55M1ozlHyp1p32fKAyMDgWgEZVjZ247OKfk3e
        B7hYkdYZAocmsw==
X-ME-Sender: <xms:jKMfYA8wmlAylQiuzHrxaFD52mx4RG5fy1akuYKHUOE3B74m422Bqw>
    <xme:jKMfYIsMnnCznjpnmjNALCMG7ocZENOgR_FCVfeCV7aTvXxhR_zgS0s5hxQcwo0LN
    uTDxiz-rncgkSU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jKMfYGCRFAQ1rba2X9A0MQ9FU6YkqiaRJVEgYv2QIqV0NouOZbYhoA>
    <xmx:jKMfYAeSwcD07Ev2mF14wKbRPxqQCc-XEMQXnDo3t9b5f670miHTnw>
    <xmx:jKMfYFM7VegPPssTf7D0Spb9fM0AVy68ysmtYdCKRvJ0FLK729FHkw>
    <xmx:jKMfYOiRiklDAerAXU1aIRXbX2Y4dqQlsBvxi5kxkCSeR6Pmc01msg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5B5F1080057;
        Sun,  7 Feb 2021 03:23:37 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] IPv4: Extend 'fib_notify_on_flag_change' sysctl
Date:   Sun,  7 Feb 2021 10:22:51 +0200
Message-Id: <20210207082258.3872086-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add the value '2' to 'fib_notify_on_flag_change' to allow sending
notifications only for failed route installation.

Separate value is added for such notifications because there are less of
them, so they do not impact performance and some users will find them more
important.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 3 ++-
 net/ipv4/fib_trie.c                    | 6 ++++++
 net/ipv4/sysctl_net_ipv4.c             | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 61a358301f12..cd0ec577a5b5 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -180,7 +180,7 @@ min_adv_mss - INTEGER
 
 fib_notify_on_flag_change - INTEGER
         Whether to emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/
-        RTM_F_TRAP flags are changed.
+        RTM_F_TRAP/RTM_F_OFFLOAD_FAILED flags are changed.
 
         After installing a route to the kernel, user space receives an
         acknowledgment, which means the route was installed in the kernel,
@@ -197,6 +197,7 @@ fib_notify_on_flag_change - INTEGER
 
         - 0 - Do not emit notifications.
         - 1 - Emit notifications.
+        - 2 - Emit notifications only for RTM_F_OFFLOAD_FAILED flag change.
 
 IP Fragmentation:
 
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 80147caa9bfd..25cf387cca5b 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1053,6 +1053,12 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 
 	fa_match->offload = fri->offload;
 	fa_match->trap = fri->trap;
+
+	/* 2 means send notifications only if offload_failed was changed. */
+	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
+	    fa_match->offload_failed == fri->offload_failed)
+		goto out;
+
 	fa_match->offload_failed = fri->offload_failed;
 
 	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e5798b3b59d2..f55095d3ed16 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1361,7 +1361,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 	{ }
 };
-- 
2.29.2

