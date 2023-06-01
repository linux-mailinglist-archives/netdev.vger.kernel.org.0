Return-Path: <netdev+bounces-6953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B0E719000
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ABF61C20F0E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 01:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE521854;
	Thu,  1 Jun 2023 01:27:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F461846
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:27:29 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA12132;
	Wed, 31 May 2023 18:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685582849; x=1717118849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QL2OZ313EwmN60TzyZOc3z6kVjQbJz7AAINlpj/2q9k=;
  b=tbMhZeBGPeKXjGUskbPd9dz8ppClVpAYf+ZNcVggJH9mVD/7WE2fCyXJ
   hZXMMxpP+BpybF4tZfgUNp+hUUVvsaHaczeC1tXEPlEfgRNWFbxt6Ge7I
   elfDd8xXIvTyR/6IV2q93Sc18cPmgUn+ZNIAS/Eu7TOcybad0J/UTz5Bk
   c=;
X-IronPort-AV: E=Sophos;i="6.00,207,1681171200"; 
   d="scan'208";a="337792469"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 01:27:25 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com (Postfix) with ESMTPS id 3035F410E9;
	Thu,  1 Jun 2023 01:27:23 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 1 Jun 2023 01:27:22 +0000
Received: from 88665a182662.ant.amazon.com.com (10.95.246.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 1 Jun 2023 01:27:19 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <akihirosuda@git.sr.ht>
CC: <akihiro.suda.cz@hco.ntt.co.jp>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <segoon@openwall.com>, <suda.kyoto@gmail.com>
Subject: Re: [PATCH linux v2] net/ipv4: ping_group_range: allow GID from 2147483648 to 4294967294
Date: Wed, 31 May 2023 18:27:08 -0700
Message-ID: <20230601012708.69681-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <168557950756.14226.6470993129419598644-0@git.sr.ht>
References: <168557950756.14226.6470993129419598644-0@git.sr.ht>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.246.21]
X-ClientProxiedBy: EX19D044UWB001.ant.amazon.com (10.13.139.171) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
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
> v1->v2: Simplified the patch (Thanks to Kuniyuki Iwashima for suggestion)

Changelog should be placed under '---'.

Also could you use 'net' instead of 'linux' in Subject so that
patchwork will be happy ?

https://patchwork.kernel.org/project/netdevbpf/patch/168557950756.14226.6470993129419598644-0@git.sr.ht/


> 
> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
> Signed-off-by: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
> ---
>  Documentation/networking/ip-sysctl.rst | 4 ++--
>  include/net/ping.h                     | 6 +-----
>  net/ipv4/sysctl_net_ipv4.c             | 8 ++++----
>  3 files changed, 7 insertions(+), 11 deletions(-)
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
> index 9233ad3de0ad..bc7779262e60 100644
> --- a/include/net/ping.h
> +++ b/include/net/ping.h
> @@ -16,11 +16,7 @@
>  #define PING_HTABLE_SIZE 	64
>  #define PING_HTABLE_MASK 	(PING_HTABLE_SIZE-1)
>  
> -/*
> - * gid_t is either uint or ushort.  We want to pass it to
> - * proc_dointvec_minmax(), so it must not be larger than MAX_INT
> - */
> -#define GID_T_MAX (((gid_t)~0U) >> 1)
> +#define GID_T_MAX (((gid_t)~0U) - 1)
>  
>  /* Compatibility glue so we can support IPv6 when it's compiled as a module */
>  struct pingv6_ops {
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 40fe70fc2015..bb49d9407c45 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -34,8 +34,8 @@ static int ip_ttl_min = 1;
>  static int ip_ttl_max = 255;
>  static int tcp_syn_retries_min = 1;
>  static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
> -static int ip_ping_group_range_min[] = { 0, 0 };
> -static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
> +static long ip_ping_group_range_min[] = { 0, 0 };
> +static long ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };

nit: s/long/unsigned long/

Then, add

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks!


>  static u32 u32_max_div_HZ = UINT_MAX / HZ;
>  static int one_day_secs = 24 * 3600;
>  static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
> @@ -165,7 +165,7 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
>  {
>  	struct user_namespace *user_ns = current_user_ns();
>  	int ret;
> -	gid_t urange[2];
> +	unsigned long urange[2];
>  	kgid_t low, high;
>  	struct ctl_table tmp = {
>  		.data = &urange,
> @@ -178,7 +178,7 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
>  	inet_get_ping_group_range_table(table, &low, &high);
>  	urange[0] = from_kgid_munged(user_ns, low);
>  	urange[1] = from_kgid_munged(user_ns, high);
> -	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> +	ret = proc_doulongvec_minmax(&tmp, write, buffer, lenp, ppos);
>  
>  	if (write && ret == 0) {
>  		low = make_kgid(user_ns, urange[0]);
> -- 
> 2.38.4


