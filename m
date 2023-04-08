Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D916DB9A9
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 10:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjDHIYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 04:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDHIYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 04:24:19 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A80D524;
        Sat,  8 Apr 2023 01:24:17 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F3E783200909;
        Sat,  8 Apr 2023 04:24:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 08 Apr 2023 04:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:content-type:content-type:date:date:from
        :from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1680942254; x=1681028654; bh=2y
        BXVbSSdNHxtHfP7iplYUCfsDs2K4dPwS9gffca2v0=; b=qnziuNy0ypINMNUC4t
        LbshO8S4cz6pwpGvCspmYV8wYjIpSuusui+BrXV4fv+dTwsa2Hgws1HVzMI6uMn/
        Vnlgx7xzz4w5igYnarE5MndhiUDXG/rwyJC3l7QesOVY0/PZw0w9jy8kJwIXS3Jx
        UykvuJKZi+snphDZ0gRhv7V2uGbg5fNbh+dAQp/PLQUmniuaUYJHnEpbmCK69cVJ
        f6IXEDN2jtrmMGEOfzSYGaiheZxhF16z3jd+GEJuWFLQ3/+ynjYfVfS04QKhrz/0
        9pb4LMqeKoHrNyiuze4/LXIqaAqdhP6jcboVdnKRSSlawrQ1Pt3YfDNqTNcYejX0
        6zrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1680942254; x=1681028654; bh=2yBXVbSSdNHxtHfP7iplYUCfsDs2K4dPwS9
        gffca2v0=; b=lOV+UeK7Ut1d7PEJcKYvd7u5/u5xwSNj3qL6ZLo9nr3ibF6KPWN
        vEttAkDc8R/a2Q+FW32kt+6BGxD4RtcOTWgYpzmVQ4S02EOTcAd6J+7ia2jJxtlX
        YfFzoQ/cpGWDi66GsGHly9XGa0F1kSBkqnHHOu84yD1zKQmvgSXFcsXKZsCI/g6r
        350sYwgK6vipF5aS8yVJAlgSnbN4TFzqiWN5H7or/cvkm/4Pw9R+xAIYjf+DyZFl
        gtMXpKln51uaxBhCFCMiIpqAzZi/q1dPWgCozsDEyQbfN7YBdbWJmnE6TQN7pjpn
        GuiDj7suuKQundmDfmOiJCaf7dDM3m+TKqg==
X-ME-Sender: <xms:riQxZFi8pSkoas4z9F1eS0S03eDjD4m9tirqbMu9L8mNzILUopfSrg>
    <xme:riQxZKBd3ttPf339ZJupeAEuu99A5Ovlv-hH8a3LhFctovtUuCRCNpKVeJlYmf0xW
    Bvak4W9qlSLF_TdvcM>
X-ME-Received: <xmr:riQxZFH1q2z7OSmY-nFxVDEwri27FDQ-pi9cjFhppXHajf1fi1d9DchBmVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehttdertddttddvnecuhfhrohhmpeflohhshhcuvfhr
    ihhplhgvthhtuceojhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgheqnecuggftrf
    grthhtvghrnhepudelkeevueetjeegudehgfevheffvdffieelieeggfffgeeuffehteek
    jefgueevnecuffhomhgrihhnpehshihstghtlhdrnhgvthenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjohhshhesjhhoshhhthhrihhplhgv
    thhtrdhorhhg
X-ME-Proxy: <xmx:riQxZKSlLW3UJ14ICgjjfi-iIWYLXFuyZwgTdcPT_ihlcF0MHzwJfQ>
    <xmx:riQxZCyjtKbclMqKFN26mgdbesWf6pY2bWrjrxFjZPcht6JIRHMCrg>
    <xmx:riQxZA6e-VqZYx9_2_HxphS8aEWOYr5Aez9tOQoJP-bycFz8KBVs5A>
    <xmx:riQxZNyPGu_7yUoEKarrGlmDtFADZzFKpvMeCLAeIfE1vIT-bsv-OQ>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 8 Apr 2023 04:24:10 -0400 (EDT)
Date:   Sat, 8 Apr 2023 17:24:07 +0900
From:   Josh Triplett <josh@joshtriplett.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] net: ipv6: Add Kconfig option to set default value of
 accept_dad
Message-ID: <3072adab06f9c5f45cc72d2068d1aed0100436ff.1680941918.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel already supports disabling Duplicate Address Detection (DAD)
by setting net.ipv6.conf.$interface.accept_dad to 0. However, for
interfaces available at boot time, the kernel brings up the interface
and sets up the link-local address before processing sysctls set on the
kernel command line; thus, setting
sysctl.net.ipv6.conf.default.accept_dad=0 on the kernel command line
does not suffice to affect such interfaces.

Add a configuration option to set the default value of accept_dad for
new interfaces.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

I'm in a virtualized environment, and I'm trying to bring up network
interfaces (including IPv6) extremely quickly and have them be
immediately usable. I tried many different approaches to disable DAD on
the interface, but I didn't find *any* way to successfully disable DAD
before the kernel brought up the link-local address for eth0 and set it
as tentative.

I've verified that this option *does* successfully cause the link-local
address for interfaces to not show up as "tentative".

If this approach isn't appealing, or if there's a better way to
accomplish this, I'd welcome suggestions for alternative approaches.

 Documentation/networking/ip-sysctl.rst |  4 +++-
 net/ipv6/Kconfig                       | 10 ++++++++++
 net/ipv6/addrconf.c                    |  4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 87dd1c5283e6..302f1f208339 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2496,11 +2496,13 @@ accept_dad - INTEGER
 
 	 == ==============================================================
 	  0  Disable DAD
-	  1  Enable DAD (default)
+	  1  Enable DAD
 	  2  Enable DAD, and disable IPv6 operation if MAC-based duplicate
 	     link-local address has been found.
 	 == ==============================================================
 
+	Default: 1 if CONFIG_IPV6_DAD_DEFAULT_DISABLE is not set, otherwise 0.
+
 	DAD operation and mode on a given interface will be selected according
 	to the maximum value of conf/{all,interface}/accept_dad.
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 658bfed1df8b..3535e1b6a38f 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -48,6 +48,16 @@ config IPV6_OPTIMISTIC_DAD
 
 	  If unsure, say N.
 
+config IPV6_DAD_DEFAULT_DISABLE
+	bool "IPv6: Disable Duplicate Address Detection by default"
+	help
+	  If enabled, this sets the default value of the
+	  net.ipv6.conf.default.accept_dad sysctl to 0, disabling Duplicate
+	  Address Detection (DAD). This allows the modified default to be
+	  picked up early enough to affect interfaces that exist at boot time.
+
+	  If unsure, say N.
+
 config INET6_AH
 	tristate "IPv6: AH transformation"
 	select XFRM_AH
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index faa47f9ea73a..e931c836a5dd 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -274,7 +274,11 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.proxy_ndp		= 0,
 	.accept_source_route	= 0,	/* we do not accept RH0 by default. */
 	.disable_ipv6		= 0,
+#ifdef CONFIG_IPV6_DAD_DEFAULT_DISABLE
+	.accept_dad		= 0,
+#else
 	.accept_dad		= 1,
+#endif
 	.suppress_frag_ndisc	= 1,
 	.accept_ra_mtu		= 1,
 	.stable_secret		= {
-- 
2.40.0

