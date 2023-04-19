Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F303D6E70C4
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 03:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjDSBct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDSBcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 21:32:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A44AD3F
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 18:32:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 63-20020a250042000000b00b924691cef2so6248484yba.6
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 18:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681867963; x=1684459963;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+I6XAACcGb7TjpKpFKYz635SvJuI1w0W+Zshmu9vlkQ=;
        b=dS526xIGocwS+mcYk2Uiwtyk91p3KsC9cxW2zjqo4VeZMhhf7iAfH3nJM3B92sNKDo
         m/mEInxst+j+/JBF5dgXOIJ5S4DvqNq6qq9Owul5KrvwY8FBsubthnC1snNDf7tA7ZTA
         KntnQH5F6x2k/Lc4oNpNClJBLaC8b6UBt1UbiT195p/QVypVV6N/OolP7sVncedKdg2d
         4P9A7jK69AvrNjFHsGlBo8wlvaNaddunIHeEbYklOoRxeW9bpaR8clkFTwAAyOGQhLqq
         ZbGbykUO/WTQo90sOprqPMaZUaHh/KpPxmAbElmYdfNGsDOTPbk1Jr6dogSv464UT0MR
         l5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681867963; x=1684459963;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+I6XAACcGb7TjpKpFKYz635SvJuI1w0W+Zshmu9vlkQ=;
        b=G5jldGLyda6BoqgQ1t4g/thmevaj+SWWXC97RG0bu/m3+SAQgPhcXp/9x3jOAehQs2
         RdIGKY7YriqLb5C7bG/LkTTeh4+K4obBb7THHCyAuvvR4hayWqA6IQWP7e1F6hb/C3Rn
         GofFOqxCoxQO02JYD/Sx/oVgbk+JSgTYNYtnrhGyZL6DUwwUJ8f78moOmwaJTdFZtV6x
         gNLZNA8YPgCOv8V0YQ9zc+r+jwQ04KthYpaTLr+1gByo9n2MBao+LVgy6b5hN1R9iGRf
         DdzS39/VGptpZpXYZ0wv97Np64PD6d7IzIFANGD0z15m7uaNPzASHcymvqoEwbipxFqb
         PsyA==
X-Gm-Message-State: AAQBX9fknUhnSwEBt9v+NG+aGfWLdS0oqm2e2hpih04c14tTSEKROkQ2
        S7m4Utbi8WjQqmhD207ri8f3HsuefQlDSQ3kbbJvdO74ibau23Gi9REsInDi66gZ8XZq9lgA9gg
        IDO6T4tkp/Va/bHo3+3sZECGGJfdIN8iLjDT5sLWlk20TuSBSEjpfOp8l2VOwma6u
X-Google-Smtp-Source: AKy350a/Jah111IL6lSUdJCuHyRpCrNeVUTOPxPCYlKmIa+nz3iei7+O3DZnqbP7KqNdNc/7r6TwhkUDA6dN
X-Received: from coldfire.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b34])
 (user=maheshb job=sendgmr) by 2002:a25:da89:0:b0:b8f:4f1d:be06 with SMTP id
 n131-20020a25da89000000b00b8f4f1dbe06mr13442951ybf.11.1681867963023; Tue, 18
 Apr 2023 18:32:43 -0700 (PDT)
Date:   Tue, 18 Apr 2023 18:32:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230419013238.2691167-1-maheshb@google.com>
Subject: [PATCHv2 next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICMPv6 error packets are not sent to the anycast destinations and this
prevents things like traceroute from working. So create a setting similar
to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast).

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
CC: Maciej =C5=BBenczykowski <maze@google.com>
---
 Documentation/networking/ip-sysctl.rst |  7 +++++++
 include/net/netns/ipv6.h               |  1 +
 net/ipv6/af_inet6.c                    |  1 +
 net/ipv6/icmp.c                        | 15 +++++++++++++--
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/network=
ing/ip-sysctl.rst
index 87dd1c5283e6..b2a563ef0789 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2719,6 +2719,13 @@ echo_ignore_anycast - BOOLEAN
=20
 	Default: 0
=20
+error_anycast_as_unicast - BOOLEAN
+	If set to 1, then the kernel will respond with ICMP Errors
+	resulting from requests sent to it over the IPv6 protocol destined
+	to anycast address essentially treating anycast as unicast.
+
+	Default: 0
+
 xfrm6_gc_thresh - INTEGER
 	(Obsolete since linux-4.14)
 	The threshold at which we will start garbage collecting for IPv6
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index b4af4837d80b..3cceb3e9320b 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -55,6 +55,7 @@ struct netns_sysctl_ipv6 {
 	u64 ioam6_id_wide;
 	bool skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
+	u8 icmpv6_error_anycast_as_unicast;
 };
=20
 struct netns_ipv6 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 38689bedfce7..2b7ac752afc2 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -952,6 +952,7 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.icmpv6_echo_ignore_all =3D 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_multicast =3D 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_anycast =3D 0;
+	net->ipv6.sysctl.icmpv6_error_anycast_as_unicast =3D 0;
=20
 	/* By default, rate limit error messages.
 	 * Except for pmtu discovery, it would break it.
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index f32bc98155bf..1465a211e592 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -362,9 +362,10 @@ static struct dst_entry *icmpv6_route_lookup(struct ne=
t *net,
=20
 	/*
 	 * We won't send icmp if the destination is known
-	 * anycast.
+	 * anycast unless we need to treat anycast as unicast.
 	 */
-	if (ipv6_anycast_destination(dst, &fl6->daddr)) {
+	if (!READ_ONCE(net->ipv6.sysctl.icmpv6_error_anycast_as_unicast) &&
+	    ipv6_anycast_destination(dst, &fl6->daddr)) {
 		net_dbg_ratelimited("icmp6_send: acast source\n");
 		dst_release(dst);
 		return ERR_PTR(-EINVAL);
@@ -1192,6 +1193,15 @@ static struct ctl_table ipv6_icmp_table_template[] =
=3D {
 		.mode		=3D 0644,
 		.proc_handler =3D proc_do_large_bitmap,
 	},
+	{
+		.procname	=3D "error_anycast_as_unicast",
+		.data		=3D &init_net.ipv6.sysctl.icmpv6_error_anycast_as_unicast,
+		.maxlen		=3D sizeof(u8),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dou8vec_minmax,
+		.extra1		=3D SYSCTL_ZERO,
+		.extra2		=3D SYSCTL_ONE,
+	},
 	{ },
 };
=20
@@ -1209,6 +1219,7 @@ struct ctl_table * __net_init ipv6_icmp_sysctl_init(s=
truct net *net)
 		table[2].data =3D &net->ipv6.sysctl.icmpv6_echo_ignore_multicast;
 		table[3].data =3D &net->ipv6.sysctl.icmpv6_echo_ignore_anycast;
 		table[4].data =3D &net->ipv6.sysctl.icmpv6_ratemask_ptr;
+		table[5].data =3D &net->ipv6.sysctl.icmpv6_error_anycast_as_unicast;
 	}
 	return table;
 }
--=20
2.40.0.634.g4ca3ef3211-goog

