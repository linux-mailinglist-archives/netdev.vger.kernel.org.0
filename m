Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEA03122B4
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhBGIa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:30:27 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:47451 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbhBGI1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:27:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E0D945801DB;
        Sun,  7 Feb 2021 03:23:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=LDc81HDU/i7S1sYmF6m9XRC0h+30t67UZPD8PJmOplw=; b=cLRXfH93
        G50pgTFp4p85YWoLvww9ZIwd6UkACIwtXBHwdXGPtXPgyUBubzlcCYmfBPjkDHVg
        E55CxjpNAfH6RHwJdCbbqbn/j9jgvJdQL8VjchoBIYtS0q6eGSBHGZciVznosmD3
        yPvYLPlwQo6q5a811TvzFDVU9fj3pEb0h/Kw0dMwPTLjxQ9UH/QV1j8o1SrJew0W
        4dcFRBQDBfRf8StusosXF0AuUub0HbjEHpcM/FLjkU+La7ZDHRZH++IT0RNVfpZ6
        yQeCKiSexVE1bvfxn571Tg9GwQYgWXtT11SJLkVxpqE93qbd1/gUdgmSFVqGCT2v
        f0zoCPAUsVLjlw==
X-ME-Sender: <xms:kaMfYH1QY_H81Dt3HDJrX8yVRzGCIp_xKabbYA2HYS6DDkQ4Si6Kgg>
    <xme:kaMfYGGvy-KLYTLO0CGC8vfZbY8iZcJ8bdNqNHhnqM-koClNqVJoc9spKxFnUtSFz
    s7pPs9ifcAcp4k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:kaMfYH4qF1NOxlH0NzhiYrzbrBCrNqoJX8lHfiymuETEnn2YLZl9lg>
    <xmx:kaMfYM23FebFg4hcfHt_43m-IepObdjxug6h868Y0pDkmoSk881fOQ>
    <xmx:kaMfYKE0oe35cu6x8yeGYMI-Zu2XWB4PEuf091qTLK66yPQQfx_qAA>
    <xmx:kaMfYIau_f_Akn0rsJiyvV9Bup1z0xsXvMk16TYEiCKSxHo68e9Itw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A443F1080057;
        Sun,  7 Feb 2021 03:23:43 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] IPv6: Extend 'fib_notify_on_flag_change' sysctl
Date:   Sun,  7 Feb 2021 10:22:53 +0200
Message-Id: <20210207082258.3872086-6-idosch@idosch.org>
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
 net/ipv6/route.c                       | 6 ++++++
 net/ipv6/sysctl_net_ipv6.c             | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index cd0ec577a5b5..83ff5158005a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1798,7 +1798,7 @@ nexthop_compat_mode - BOOLEAN
 
 fib_notify_on_flag_change - INTEGER
         Whether to emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/
-        RTM_F_TRAP flags are changed.
+        RTM_F_TRAP/RTM_F_OFFLOAD_FAILED flags are changed.
 
         After installing a route to the kernel, user space receives an
         acknowledgment, which means the route was installed in the kernel,
@@ -1815,6 +1815,7 @@ fib_notify_on_flag_change - INTEGER
 
         - 0 - Do not emit notifications.
         - 1 - Emit notifications.
+        - 2 - Emit notifications only for RTM_F_OFFLOAD_FAILED flag change.
 
 IPv6 Fragmentation:
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bc75b705f54b..1536f4948e86 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6083,6 +6083,12 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 
 	f6i->offload = offload;
 	f6i->trap = trap;
+
+	/* 2 means send notifications only if offload_failed was changed. */
+	if (net->ipv6.sysctl.fib_notify_on_flag_change == 2 &&
+	    f6i->offload_failed == offload_failed)
+		return;
+
 	f6i->offload_failed = offload_failed;
 
 	if (!rcu_access_pointer(f6i->fib6_node))
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 392ef01e3366..263ab43ed06b 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -167,7 +167,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1         = SYSCTL_ZERO,
-		.extra2         = SYSCTL_ONE,
+		.extra2         = &two,
 	},
 	{ }
 };
-- 
2.29.2

