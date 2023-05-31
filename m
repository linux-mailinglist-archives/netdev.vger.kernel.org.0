Return-Path: <netdev+bounces-6904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3EAF718A06
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7B3728123E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9F9200D6;
	Wed, 31 May 2023 19:19:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA141B8E9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:19:32 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFAA125;
	Wed, 31 May 2023 12:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685560771; x=1717096771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MkW+ntQWorEvMmMdAVskhl+rccZzzXdLQWjU4/cXKyo=;
  b=QJWHiEGajFPQIGJuOQfk4k6TgyqgyL5xvK6Mmqw24OUQIMTGDLojucLv
   hldSXJGxTvx7p8X6uQfloTuEguHZb0o63WpoZ8RSSoANxidRJIRBctn4b
   V4kQdv/ES7I4v/9D71QoA9wq/7TK1ma3PFPlrqmgGDOfGtE4nwKNI+gJv
   o=;
X-IronPort-AV: E=Sophos;i="6.00,207,1681171200"; 
   d="scan'208";a="335480403"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 19:19:25 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 679D6A6726;
	Wed, 31 May 2023 19:19:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 31 May 2023 19:19:21 +0000
Received: from 88665a182662.ant.amazon.com (10.95.246.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 31 May 2023 19:19:18 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <akihirosuda@git.sr.ht>
CC: <akihiro.suda.cz@hco.ntt.co.jp>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <segoon@openwall.com>,
	<suda.kyoto@gmail.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH linux] net/ipv4: ping_group_range: allow GID from 2147483648 to 4294967294
Date: Wed, 31 May 2023 12:19:09 -0700
Message-ID: <20230531191909.95136-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <168553315664.20663.13753087625689463092-0@git.sr.ht>
References: <168553315664.20663.13753087625689463092-0@git.sr.ht>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.246.21]
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: ~akihirosuda <akihirosuda@git.sr.ht>
Date: Wed, 31 May 2023 19:42:49 +0900
> From: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
> 
> With this commit, all the GIDs ("0 4294967294") can be written to the
> "net.ipv4.ping_group_range" sysctl.
> 
> Note that 4294967295 (0xffffffff) is an invalid GID (see gid_valid() in
> include/linux/uidgid.h), and an attempt to register this number will cause
> -EINVAL.
> 
> Prior to this commit, only up to GID 2147483647 could be covered.
> Documentation/networking/ip-sysctl.rst had "0 4294967295" as an example
> value, but this example was wrong and causing -EINVAL.
> 
> In the implementation, proc_dointvec_minmax is no longer used because it
> does not support numbers from 2147483648 to 4294967294.

Good catch.

I think we can use proc_doulongvec_minmax() instead of open coding.

With the diff below:

---8<---
# sysctl -a | grep ping
net.ipv4.ping_group_range = 0	2147483647
# sysctl -w net.ipv4.ping_group_range="0 4294967295"
sysctl: setting key "net.ipv4.ping_group_range": Invalid argument
# sysctl -w net.ipv4.ping_group_range="0 4294967294"
net.ipv4.ping_group_range = 0 4294967294
# sysctl -a | grep ping
net.ipv4.ping_group_range = 0	4294967294
---8<---

---8<---
diff --git a/include/net/ping.h b/include/net/ping.h
index 9233ad3de0ad..9b401b9a9d35 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -20,7 +20,7 @@
  * gid_t is either uint or ushort.  We want to pass it to
  * proc_dointvec_minmax(), so it must not be larger than MAX_INT
  */
-#define GID_T_MAX (((gid_t)~0U) >> 1)
+#define GID_T_MAX ((gid_t)~0U)
 
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 struct pingv6_ops {
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6ae3345a3bdf..11d401958673 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -35,8 +35,8 @@ static int ip_ttl_max = 255;
 static int tcp_syn_retries_min = 1;
 static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int tcp_syn_linear_timeouts_max = MAX_TCP_SYNCNT;
-static int ip_ping_group_range_min[] = { 0, 0 };
-static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
+static unsigned long ip_ping_group_range_min[] = { 0, 0 };
+static unsigned long ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
@@ -165,8 +165,8 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct user_namespace *user_ns = current_user_ns();
+	unsigned long urange[2];
 	int ret;
-	gid_t urange[2];
 	kgid_t low, high;
 	struct ctl_table tmp = {
 		.data = &urange,
@@ -179,7 +179,7 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
 	inet_get_ping_group_range_table(table, &low, &high);
 	urange[0] = from_kgid_munged(user_ns, low);
 	urange[1] = from_kgid_munged(user_ns, high);
-	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	ret = proc_doulongvec_minmax(&tmp, write, buffer, lenp, ppos);
 
 	if (write && ret == 0) {
 		low = make_kgid(user_ns, urange[0]);
---8<---


> 
> proc_douintvec is not used either, because it does not support
> multi-element vectors, despite its function name.
> Commit 4f2fec00afa6 ("sysctl: simplify unsigned int support") says
> "*Do not* add support for them".
> 
> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
> Signed-off-by: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
> ---
>  Documentation/networking/ip-sysctl.rst |  4 +-
>  include/net/ping.h                     |  6 ---
>  net/ipv4/sysctl_net_ipv4.c             | 52 +++++++++++++++++++++-----
>  3 files changed, 44 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 6ec06a33688a..80b8f73a0244 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1352,8 +1352,8 @@ ping_group_range - 2 INTEGERS
>  	Restrict ICMP_PROTO datagram sockets to users in the group range.
>  	The default is "1 0", meaning, that nobody (not even root) may
>  	create ping sockets.  Setting it to "100 100" would grant permissions
> -	to the single group. "0 4294967295" would enable it for the world, "100
> -	4294967295" would enable it for the users, but not daemons.
> +	to the single group. "0 4294967294" would enable it for the world, "100
> +	4294967294" would enable it for the users, but not daemons.
>  
>  tcp_early_demux - BOOLEAN
>  	Enable early demux for established TCP sockets.
> diff --git a/include/net/ping.h b/include/net/ping.h
> index 9233ad3de0ad..37b1d7baeb7b 100644
> --- a/include/net/ping.h
> +++ b/include/net/ping.h
> @@ -16,12 +16,6 @@
>  #define PING_HTABLE_SIZE 	64
>  #define PING_HTABLE_MASK 	(PING_HTABLE_SIZE-1)
>  
> -/*
> - * gid_t is either uint or ushort.  We want to pass it to
> - * proc_dointvec_minmax(), so it must not be larger than MAX_INT
> - */
> -#define GID_T_MAX (((gid_t)~0U) >> 1)
> -
>  /* Compatibility glue so we can support IPv6 when it's compiled as a module */
>  struct pingv6_ops {
>  	int (*ipv6_recv_error)(struct sock *sk, struct msghdr *msg, int len,
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 40fe70fc2015..5f077156ec50 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -34,8 +34,6 @@ static int ip_ttl_min = 1;
>  static int ip_ttl_max = 255;
>  static int tcp_syn_retries_min = 1;
>  static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
> -static int ip_ping_group_range_min[] = { 0, 0 };
> -static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
>  static u32 u32_max_div_HZ = UINT_MAX / HZ;
>  static int one_day_secs = 24 * 3600;
>  static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
> @@ -167,24 +165,56 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
>  	int ret;
>  	gid_t urange[2];
>  	kgid_t low, high;
> +	size_t slen = 256; /* total bytes including '\0' */
> +	char *s = kmalloc(slen, GFP_KERNEL); /* clobbered by strsep */
>  	struct ctl_table tmp = {
> -		.data = &urange,
> -		.maxlen = sizeof(urange),
> +		.data = s,
> +		.maxlen = slen,
>  		.mode = table->mode,
> -		.extra1 = &ip_ping_group_range_min,
> -		.extra2 = &ip_ping_group_range_max,
>  	};
>  
> +	if (unlikely(!s))
> +		return -ENOMEM;
> +
>  	inet_get_ping_group_range_table(table, &low, &high);
>  	urange[0] = from_kgid_munged(user_ns, low);
>  	urange[1] = from_kgid_munged(user_ns, high);
> -	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> -
> +	/* proc_dointvec_minmax is no longer used because it does not support
> +	 * numbers from 2147483648 to 4294967294.
> +	 *
> +	 * proc_douintvec is not used either, because it does not support
> +	 * multi-element vectors, despite its function name.
> +	 * Commit 4f2fec00afa6 ("sysctl: simplify unsigned int support") says
> +	 * "*Do not* add support for them".
> +	 */
> +	ret = snprintf(tmp.data, slen, "%u\t%u", urange[0], urange[1]);
> +	if (ret < 0)
> +		goto done;
> +	ret = proc_dostring(&tmp, write, buffer, lenp, ppos);
> +	if (*lenp >= slen - 1) /* truncated */
> +		ret = -EINVAL;
>  	if (write && ret == 0) {
> +		char *tok[2];
> +		int i;
> +
> +		s = strim(s);
> +		tok[0] = strsep(&s, " \t");
> +		tok[1] = s;
> +		for (i = 0; i < 2; i++) {
> +			if (!tok[i]) {
> +				ret = -EINVAL;
> +				goto done;
> +			}
> +			ret = kstrtouint(tok[i], 0, &urange[i]);
> +			if (ret < 0)
> +				goto done;
> +		}
>  		low = make_kgid(user_ns, urange[0]);
>  		high = make_kgid(user_ns, urange[1]);
> -		if (!gid_valid(low) || !gid_valid(high))
> -			return -EINVAL;
> +		if (!gid_valid(low) || !gid_valid(high)) {
> +			ret = -EINVAL;
> +			goto done;
> +		}
>  		if (urange[1] < urange[0] || gid_lt(high, low)) {
>  			low = make_kgid(&init_user_ns, 1);
>  			high = make_kgid(&init_user_ns, 0);
> @@ -192,6 +222,8 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
>  		set_ping_group_range(table, low, high);
>  	}
>  
> +done:
> +	kfree(tmp.data);
>  	return ret;
>  }
>  
> -- 
> 2.38.4

