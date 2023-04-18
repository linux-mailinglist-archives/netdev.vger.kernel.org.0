Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB3E6E6C21
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjDRSeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDRSeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:34:10 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C49618D
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681842849; x=1713378849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=foijmmpJ0qNHrmHSUur6rUaRri5E7qRcdd3FNHRlnYI=;
  b=QdsbMR/6lv2vA257z6vwnGUAC3tXftgJUTpxyoG9G3N433oX9Lgmfe9i
   XOTUzWS2vTAXe1UoP5TfTFbEx8pvDtdXlneLo2LGylLDo7ndSBhCIGPoz
   ez4qcyinM5cfWPpPQBj1IhWgMxV8AX6GctZVMzQXnX59s4GWZsZ421+nF
   c=;
X-IronPort-AV: E=Sophos;i="5.99,207,1677542400"; 
   d="scan'208";a="315440238"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 18:33:55 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id 908CA415C8;
        Tue, 18 Apr 2023 18:33:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 18:33:51 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.27) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 18:33:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <maheshb@google.com>
CC:     <corbet@lwn.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <mahesh@bandewar.net>,
        <maze@google.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <kuniyu@amazon.com>
Subject: Re: [PATCH next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
Date:   Tue, 18 Apr 2023 11:33:39 -0700
Message-ID: <20230418183339.83599-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230417204407.2463297-1-maheshb@google.com>
References: <20230417204407.2463297-1-maheshb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.101.27]
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Mahesh Bandewar <maheshb@google.com>
Date:   Mon, 17 Apr 2023 13:44:07 -0700
> ICMPv6 error packets are not sent to the anycast destinations and this
> prevents things like traceroute from working. So create a setting similar
> to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast).
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> CC: Maciej Żenczykowski <maze@google.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  7 +++++++
>  include/net/netns/ipv6.h               |  1 +
>  net/ipv6/af_inet6.c                    |  1 +
>  net/ipv6/icmp.c                        | 13 +++++++++++--
>  4 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 87dd1c5283e6..e97896d38e9f 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2719,6 +2719,13 @@ echo_ignore_anycast - BOOLEAN
>  
>  	Default: 0
>  
> +error_anycast_as_unicast - BOOLEAN
> +	If set non-zero, then the kernel will respond with ICMP Errors

s/non-zero/1/, see below to limit 0-1.


> +	resulting from requests sent to it over the IPv6 protocol destined
> +	to anycast address essentially treating anycast as unicast.
> +
> +	Default: 0
> +
>  xfrm6_gc_thresh - INTEGER
>  	(Obsolete since linux-4.14)
>  	The threshold at which we will start garbage collecting for IPv6
> diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
> index b4af4837d80b..3cceb3e9320b 100644
> --- a/include/net/netns/ipv6.h
> +++ b/include/net/netns/ipv6.h
> @@ -55,6 +55,7 @@ struct netns_sysctl_ipv6 {
>  	u64 ioam6_id_wide;
>  	bool skip_notify_on_dev_down;
>  	u8 fib_notify_on_flag_change;
> +	u8 icmpv6_error_anycast_as_unicast;
>  };
>  
>  struct netns_ipv6 {
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 38689bedfce7..2b7ac752afc2 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -952,6 +952,7 @@ static int __net_init inet6_net_init(struct net *net)
>  	net->ipv6.sysctl.icmpv6_echo_ignore_all = 0;
>  	net->ipv6.sysctl.icmpv6_echo_ignore_multicast = 0;
>  	net->ipv6.sysctl.icmpv6_echo_ignore_anycast = 0;
> +	net->ipv6.sysctl.icmpv6_error_anycast_as_unicast = 0;
>  
>  	/* By default, rate limit error messages.
>  	 * Except for pmtu discovery, it would break it.
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index f32bc98155bf..db2aef50fdf5 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -362,9 +362,10 @@ static struct dst_entry *icmpv6_route_lookup(struct net *net,
>  
>  	/*
>  	 * We won't send icmp if the destination is known
> -	 * anycast.
> +	 * anycast unless we need to treat anycast as unicast.
>  	 */
> -	if (ipv6_anycast_destination(dst, &fl6->daddr)) {
> +	if (!net->ipv6.sysctl.icmpv6_error_anycast_as_unicast &&

Please use READ_ONCE() to silence KCSAN.


> +	    ipv6_anycast_destination(dst, &fl6->daddr)) {
>  		net_dbg_ratelimited("icmp6_send: acast source\n");
>  		dst_release(dst);
>  		return ERR_PTR(-EINVAL);
> @@ -1192,6 +1193,13 @@ static struct ctl_table ipv6_icmp_table_template[] = {
>  		.mode		= 0644,
>  		.proc_handler = proc_do_large_bitmap,
>  	},
> +	{
> +		.procname	= "error_anycast_as_unicast",
> +		.data		= &init_net.ipv6.sysctl.icmpv6_error_anycast_as_unicast,
> +		.maxlen		= sizeof(u8),
> +		.mode		= 0644,
> +		.proc_handler = proc_dou8vec_minmax,

		.extra1		= SYSCTL_ZERO,
		.extra2		= SYSCTL_ONE

> +	},
>  	{ },
>  };
>  
> @@ -1209,6 +1217,7 @@ struct ctl_table * __net_init ipv6_icmp_sysctl_init(struct net *net)
>  		table[2].data = &net->ipv6.sysctl.icmpv6_echo_ignore_multicast;
>  		table[3].data = &net->ipv6.sysctl.icmpv6_echo_ignore_anycast;
>  		table[4].data = &net->ipv6.sysctl.icmpv6_ratemask_ptr;
> +		table[5].data = &net->ipv6.sysctl.icmpv6_error_anycast_as_unicast;
>  	}
>  	return table;
>  }
> -- 
> 2.40.0.634.g4ca3ef3211-goog
