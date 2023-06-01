Return-Path: <netdev+bounces-7110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A8F71A02B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B44A2817F6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64421101D6;
	Thu,  1 Jun 2023 14:35:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EB423422
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:35:43 +0000 (UTC)
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52548E41
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 07:35:17 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f4b0a0b557so1152251e87.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 07:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685630115; x=1688222115;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qSfNwowBIrXwCmy959sjHFBtcspDeGLD1tqwKKW+7Ys=;
        b=dYbtu3UYUAEitxKc2CkYIYDng/Qda8jQs5za7qbAiCkvL9Nd2Ob+7VHS49pYO2NoVt
         yg2kKmMl53HdnezRVuhHaUmZvwnffiuGV4GU08wGa0LTm0dWKZZ/0niXyBQJqeS1NOze
         V/KEMob2jOiZpbcfAOwOXHWpZT+qSIAqZiARx6QwTfYmosmSFTC0GcvGda7i8Znh17zz
         9BOPd/jDC3YviQI0T5alCHX8eK1sNiKmEWyirAAHRINW6nnGmEj3PwNGDnKTgMBvEZjq
         tasIt+U/qWOilP0SgQzXnCr1cpizRP9b9SvmF344OpjWylhrvJUxx+8adpmrKPjgG0v0
         cwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685630115; x=1688222115;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qSfNwowBIrXwCmy959sjHFBtcspDeGLD1tqwKKW+7Ys=;
        b=PgxDYiXifB8TClejVd34gfiR3yVFvTnxel8p0ARn62dnPSi8KfJ3aS/gPzKodnZ02F
         BcCk89xlaQivsvHkW41urtuiFd1phk9Es5WUmuSr8UNue61NiqNAsCFN/pzkzxeaguVB
         OZ1jw2wol72dwlqCMB4Ax3n9M2+DcI08T0nCGve/fBJDJhMOFCV9zRq/2CAmXO98jHxj
         JdDGEwSUD5bXb+qhZNvP2pt4PVLo1CTIgBj/lrN6z4n76bJgw3N2aew12oLUqglYS9Ar
         aVfgj8hFyd5K5TMVceyRiz/kttxhGCRwaa0y/w7RqkI9c0SnsHGcEsrLNOMYNM9UqqwH
         AIag==
X-Gm-Message-State: AC+VfDwJqCN/eJtB3wTFNHYbhvHAfVaTg9KwfrPSLtLARvIo4rSbhxer
	DOpxDTSwtNXu6lDF90Id3N3Nwg==
X-Google-Smtp-Source: ACHHUZ5kdMccQkoAlUzkaLwGRekQ/edux8f3fBn82uOO1QxrlGZsoZc+1Dp/R9dx8AQTzWnym2JCQQ==
X-Received: by 2002:ac2:5479:0:b0:4f4:c30f:fafd with SMTP id e25-20020ac25479000000b004f4c30ffafdmr73943lfn.28.1685630115372;
        Thu, 01 Jun 2023 07:35:15 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id bg22-20020a05600c3c9600b003f4283f5c1bsm9709927wmb.2.2023.06.01.07.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 07:35:15 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 01 Jun 2023 16:34:36 +0200
Subject: [PATCH net-next RFC] net: skip printing "link become ready" v6 msg
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net>
X-B4-Tracking: v=1; b=H4sIAHuseGQC/z2OywrCMBBFf6XM2kAaTRduBT/AbZGQx2iH6jQkQ
 Sql/24q6OIuDgcOd4GMiTDDsVkg4YsyTVyh3TXgB8t3FBQqg5JqLzvZCsZSNxeRR4omJuJiHsS
 jceinJ2aT0Ia30M6rTutgrTpAjTmbUbhk2Q9b7lfZVEx4o/n7of+L5nI+wXVdP68tdLChAAAA
To: mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, 
 Mat Martineau <martineau@kernel.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4914;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=GLrbycqPqRupQVxPfBAeQV/Ty59syypaKHGw+itKRJo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkeKyisVl+FfDll7sOFg0z9Ac39h4Ccw6u+9lvs
 3VxxxUncW2JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZHisogAKCRD2t4JPQmmg
 c/RaD/4o4Tn8sDVthZGvm2tBUx2KGQVHkcZAGGzkIo8G00uzwSysWhWPO15W/bJqvfl/QUk1PQu
 SNTv/14k1MprVsFlAaNnopYSG6wYUdSRDFXx9ysTX/htPfX/8fg0FMgLklW8Yxcetc7mTnab9mn
 1Qgs0YKoXG8WNwTbu8OdkTd0tRJhl2UhxHM8tjRSn7tgP3awKIzDDkjIpV+TcwfmtvrwGOEVwix
 AdreqRACDHd/Y1JjsQ+GNKolWzl89DqRKpqXFIRgGteWKBjZ4rKlUnK2XR8t4MrcivwN61slPWs
 77svn4X/Y9OF7s4xd51iWjFPZBXeG+q8iJH/5pOmad5WMGZN8/B1ror5bObph/Ay3drNx8flRW3
 B19Lde6Tf1rQQHPi9vYl1D9ZnHnfp/Iyux3jgAtvTtlGJVJ3S/m7ri+Kj9PI8OnOCvCTwP1r3PF
 HGepXXBrTfMCovEZ4hsuHVURyIrHMibgS62aFCs+T9eGDChpk9Ivuyn16vScF8O8JGL2veaL4wn
 yhd9KDfvXZbedG9i5bxEz1IO8BKTh08QVj6m6lZB8q88Hf26nfJZmZpkJiKQLo7gZExmY95Wdgc
 gTv9WfPjkgj9dyCwsQpkzNdvIJabpAc6c+RarJIkReU3YvzkYEIU6RIUi7R+IiXwDBkndJjOlbn
 86H63IHi/QwtbSQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This following message is printed in the console each time a network
device configured with an IPv6 addresses is ready to be used:

  ADDRCONF(NETDEV_CHANGE): <iface>: link becomes ready

When netns are being extensively used -- e.g. by re-creating netns with
veth to discuss with each other for testing purposes like mptcp_join.sh
selftest does -- it generates a lot of messages: more than 700 when
executing mptcp_join.sh with the latest version.

=========
== RFC ==
=========

TL;DR: can we move this message to the debug level? Or is it better with
a sysctl knob? Or something else?

When looking at commit 3c21edbd1137 ("[IPV6]: Defer IPv6 device
initialization until the link becomes ready.") which introduces this new
message, it seems it had been added to verify that the new feature was
working as expected. It could have then used a lower level than "info".

It is unclear if this message can be useful. Maybe it can be used as a
sign to know if there is something wrong, e.g. if a device is being
regularly reconfigured by accident? But even then, I don't think that
was its goal at the first place and clearly there are better ways to
monitor and diagnose such issues. Do you see any usages?

If this message is not that useful, it is probably better to simply
lower its level, similar to commit 7c62b8dd5ca8 ("net/ipv6: lower the
level of "link is not ready" messages"). If we can take this direction,
we will just need to switch from pr_info() to pr_debug().

If this message can be useful in many situations, it would be good to
have a way to turn it off because in some other situations, it floods
the logs without providing any useful input. The proposition here is to
have a new per netns sysctl knob to easily skip this specific message
when needed. If we prefer to take this direction, we will still need to
document the new knob and the modification in the MPTCP selftest should
be done in a separated commit.

Adding a new sysctl entry just for that seems a bit "heavy", maybe there
are better ways that are still easy to put in place?

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/net/netns/ipv6.h                        | 1 +
 net/ipv6/addrconf.c                             | 5 +++--
 net/ipv6/sysctl_net_ipv6.c                      | 9 +++++++++
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 3cceb3e9320b..721abf86052f 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -56,6 +56,7 @@ struct netns_sysctl_ipv6 {
 	bool skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
 	u8 icmpv6_error_anycast_as_unicast;
+	bool skip_print_link_becomes_ready;
 };
 
 struct netns_ipv6 {
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3797917237d0..9cf7b4932309 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3633,8 +3633,9 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 				idev->if_flags |= IF_READY;
 			}
 
-			pr_info("ADDRCONF(NETDEV_CHANGE): %s: link becomes ready\n",
-				dev->name);
+			if (!net->ipv6.sysctl.skip_print_link_becomes_ready)
+				pr_info("ADDRCONF(NETDEV_CHANGE): %s: link becomes ready\n",
+					dev->name);
 
 			run_pending = 1;
 		}
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 94a0a294c6a1..c9e82377a8fa 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -213,6 +213,15 @@ static struct ctl_table ipv6_table_template[] = {
 		.proc_handler	= proc_doulongvec_minmax,
 		.extra2		= &ioam6_id_wide_max,
 	},
+	{
+		.procname	= "skip_print_link_becomes_ready",
+		.data		= &init_net.ipv6.sysctl.skip_print_link_becomes_ready,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
 	{ }
 };
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index e74d3074ef90..ec7d66a0a57e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -83,6 +83,7 @@ init_partial()
 		ip netns exec $netns sysctl -q net.mptcp.pm_type=0
 		ip netns exec $netns sysctl -q net.ipv4.conf.all.rp_filter=0
 		ip netns exec $netns sysctl -q net.ipv4.conf.default.rp_filter=0
+		ip netns exec $netns sysctl -q net.ipv6.skip_print_link_becomes_ready=1
 		if [ $checksum -eq 1 ]; then
 			ip netns exec $netns sysctl -q net.mptcp.checksum_enabled=1
 		fi

---
base-commit: 6f4b98147b8dfcabacb19b5c6abd087af66d0049
change-id: 20230601-net-next-skip_print_link_becomes_ready-5bc2655daa24

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>


