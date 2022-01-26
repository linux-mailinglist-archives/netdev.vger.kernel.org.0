Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A949C410
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbiAZHLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiAZHLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:11:06 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD87C06161C;
        Tue, 25 Jan 2022 23:11:06 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id b5so8924088qtq.11;
        Tue, 25 Jan 2022 23:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RjxNj/myb3M2Lao7EHl6J9lNWX3kPOqbaZl/DPICdls=;
        b=bBKo/ChzjuMxtxpte2jXmcp/t9bTMGFqN+vB8q//VlJFPNWnnWX/aQQf1cuB2nFIAh
         whuln3gSdgn1K6Nr/hkxMVGvbG9WaXHtEjGnfdaCzX/l10R1mYNHUe3PTCZc0n2Xz+Yw
         VZqxUrabNDSI9t6dUtRE66iIH4aoDPYxqGRfKws0PRHPRJdWYCT7cIdEZJ7KyR4PhiRR
         hIIgVeKBTJTI1Hc6Jr9uQOZvPITGMy+n+jSRo5Rgz7N/R5X6ID1Y+ppjGrmW07XHPW5p
         50bXghk/OdDn+Vg+c1AZ78R7WWq96+YkYfoDvWfv58Fiqv7DNCL0UH3N5mWiQ/nFuE4W
         oXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RjxNj/myb3M2Lao7EHl6J9lNWX3kPOqbaZl/DPICdls=;
        b=WZLvzZoO1yWVF/KdSazwJda2uixrFjwB/xRoYoT/r+glroB7bvE9ohxjlOnHfHumGi
         C9tHvoRHNWzc74F7jOSnmNjzWoauVUycYYMOo6+cn91DSkJWKNd1HqvKqZ2OfB5N/imc
         QHg9sV6JFy1LbGs6IygTN9K7izONq6lGWR0yAfDdFxagRDKCJzIECEJQtUOMR0qV6D4R
         Oiw9e5AYfWVA6Iut/vAZTcG0xwcMX4CZaL95taxjcFwb3N5Y8gMIpwtRihmo/aY6j8mN
         IKPCYfkRqlS2P20UaCYK9nGBPpcbofgI4mE2pCwJxHY2tepBSy4OgGP+Rzk/OGKGvaYC
         gxRw==
X-Gm-Message-State: AOAM530nWYPX4bGRKf+Qjpls+vaTnr79kFl3vAW9P7pCU7jYE4lxfgoo
        ZwtQk56gpq8ruo5Fp9R7ir9prOGnNOo=
X-Google-Smtp-Source: ABdhPJxVftBzv/RlBGaQrACFNIcQy0HHpKNuToYS9XGsE6OAygGlCdZF3LC0npchFuPc2S5pF0fDww==
X-Received: by 2002:a05:622a:115:: with SMTP id u21mr8722814qtw.263.1643181065929;
        Tue, 25 Jan 2022 23:11:05 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id w18sm10487315qkp.96.2022.01.25.23.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:11:05 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu xin <xu.xin16@zte.com.cn>
Subject: [PATCH resend] ipv4: Namespaceify min_adv_mss sysctl knob
Date:   Wed, 26 Jan 2022 07:10:58 +0000
Message-Id: <20220126071058.1168074-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

Different netns has different requirement on the setting of min_adv_mss
sysctl which the advertised MSS will be never lower than.

Enable min_adv_mss to be configured per network namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 7855764..8fea3cb 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -87,6 +87,7 @@ struct netns_ipv4 {
 
 	u32 ip_rt_min_pmtu;
 	int ip_rt_mtu_expires;
+	int ip_rt_min_advmss;
 
 	struct local_ports ip_local_ports;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ff6f91c..e42e283 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -112,14 +112,13 @@
 
 #define DEFAULT_MIN_PMTU (512 + 20 + 20)
 #define DEFAULT_MTU_EXPIRES (10 * 60 * HZ)
-
+#define DEFAULT_MIN_ADVMSS 256
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
 static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
-static int ip_rt_min_advmss __read_mostly	= 256;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
 
@@ -1298,9 +1297,10 @@ static void set_class_tag(struct rtable *rt, u32 tag)
 
 static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 {
+	struct net *net = dev_net(dst->dev);
 	unsigned int header_size = sizeof(struct tcphdr) + sizeof(struct iphdr);
 	unsigned int advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
-				    ip_rt_min_advmss);
+				    net->ipv4.ip_rt_min_advmss);
 
 	return min(advmss, IPV4_MAX_PMTU - header_size);
 }
@@ -3535,13 +3535,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "min_adv_mss",
-		.data		= &ip_rt_min_advmss,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 	{ }
 };
 
@@ -3569,6 +3562,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
+	{
+		.procname   = "min_adv_mss",
+		.data       = &init_net.ipv4.ip_rt_min_advmss,
+		.maxlen     = sizeof(int),
+		.mode       = 0644,
+		.proc_handler   = proc_dointvec,
+	},
 	{ },
 };
 
@@ -3631,6 +3631,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	/* Set default value for namespaceified sysctls */
 	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
+	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
 	return 0;
 }
 
-- 
2.15.2

