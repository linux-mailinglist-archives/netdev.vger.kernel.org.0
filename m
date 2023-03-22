Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85076C407D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCVCmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVCmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:42:43 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEC13D907
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679452962; x=1710988962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nr2My2wwDiyrHuHSYLUTOgbP/SccfEExjjmMx96Ku8c=;
  b=WzEUe60WMptTEs6c3Y9fjqM04pbGLqhRj0WlNxw4BGq9ddrI9JlxEEIu
   Gr+egpVUwy7FsnVBkfQhugE9ldBd38YFjZmBt5tJahdG2RmyyffmJIYv6
   R7kuRj2nrMPX+lsJIP/U4gfCeibc1LXBCPwDmf78TOf0kTsMcPTCn9ElP
   g=;
X-IronPort-AV: E=Sophos;i="5.98,280,1673913600"; 
   d="scan'208";a="271396508"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 02:42:36 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id 56077444BB;
        Wed, 22 Mar 2023 02:42:34 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Wed, 22 Mar 2023 02:42:33 +0000
Received: from 88665a182662.ant.amazon.com (10.94.217.231) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 22 Mar 2023 02:42:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <dsahern@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next 1/2] ipv6: Remove in6addr_any alternatives.
Date:   Tue, 21 Mar 2023 19:42:21 -0700
Message-ID: <20230322024221.37953-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1d6392a2-ae42-ef7f-30b1-bd5d28b1a586@kernel.org>
References: <1d6392a2-ae42-ef7f-30b1-bd5d28b1a586@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.217.231]
X-ClientProxiedBy: EX19D042UWA001.ant.amazon.com (10.13.139.92) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Ahern <dsahern@kernel.org>
Date:   Tue, 21 Mar 2023 20:22:53 -0600
> On 3/21/23 7:22 PM, Kuniyuki Iwashima wrote:
> > Some code defines the IPv6 wildcard address as a local variable.
> > Let's use in6addr_any instead.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  5 ++---
> >  include/net/ip6_fib.h                                 |  9 +++------
> >  include/trace/events/fib.h                            |  5 ++---
> >  include/trace/events/fib6.h                           |  5 +----
> >  net/ethtool/ioctl.c                                   |  9 ++++-----
> >  net/ipv4/inet_hashtables.c                            | 11 ++++-------
> >  6 files changed, 16 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> > index a108e73c9f66..6a88f6b02678 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> > @@ -98,7 +98,6 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
> >  #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
> >  	else if (ip_version == 6) {
> >  		int ipv6_size = MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6);
> > -		struct in6_addr zerov6 = {};
> >  
> >  		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
> >  				     outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6);
> > @@ -106,8 +105,8 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
> >  				     outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6);
> >  		memcpy(&tun_attr->dst_ip.v6, daddr, ipv6_size);
> >  		memcpy(&tun_attr->src_ip.v6, saddr, ipv6_size);
> > -		if (!memcmp(&tun_attr->dst_ip.v6, &zerov6, sizeof(zerov6)) ||
> > -		    !memcmp(&tun_attr->src_ip.v6, &zerov6, sizeof(zerov6)))
> > +		if (!memcmp(&tun_attr->dst_ip.v6, &in6addr_any, sizeof(in6addr_any)) ||
> > +		    !memcmp(&tun_attr->src_ip.v6, &in6addr_any, sizeof(in6addr_any)))
> 
> I think ipv6_addr_any can be used here.

Exactly, will fix all in v2.

Thank you!


> 
> >  			return 0;
> >  	}
> >  #endif
> >
> 
> 
> > @@ -3233,20 +3232,20 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
> >  
> >  		v6_spec = &fs->h_u.tcp_ip6_spec;
> >  		v6_m_spec = &fs->m_u.tcp_ip6_spec;
> > -		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr))) {
> > +		if (memcmp(v6_m_spec->ip6src, &in6addr_any, sizeof(in6addr_any))) {
> >  			memcpy(&match->key.ipv6.src, v6_spec->ip6src,
> >  			       sizeof(match->key.ipv6.src));
> >  			memcpy(&match->mask.ipv6.src, v6_m_spec->ip6src,
> >  			       sizeof(match->mask.ipv6.src));
> >  		}
> > -		if (memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
> > +		if (memcmp(v6_m_spec->ip6dst, &in6addr_any, sizeof(in6addr_any))) {
> >  			memcpy(&match->key.ipv6.dst, v6_spec->ip6dst,
> >  			       sizeof(match->key.ipv6.dst));
> >  			memcpy(&match->mask.ipv6.dst, v6_m_spec->ip6dst,
> >  			       sizeof(match->mask.ipv6.dst));
> >  		}
> > -		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr)) ||
> > -		    memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
> > +		if (memcmp(v6_m_spec->ip6src, &in6addr_any, sizeof(in6addr_any)) ||
> > +		    memcmp(v6_m_spec->ip6dst, &in6addr_any, sizeof(in6addr_any))) {
> 
> and this group as well.
> 
> >  			match->dissector.used_keys |=
> >  				BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
> >  			match->dissector.offset[FLOW_DISSECTOR_KEY_IPV6_ADDRS] =
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 6edae3886885..74caaa0c148b 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -826,13 +826,11 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
> >  				      unsigned short port, int l3mdev, const struct sock *sk)
> >  {
> >  #if IS_ENABLED(CONFIG_IPV6)
> > -	struct in6_addr addr_any = {};
> > -
> >  	if (sk->sk_family != tb->family) {
> >  		if (sk->sk_family == AF_INET)
> >  			return net_eq(ib2_net(tb), net) && tb->port == port &&
> >  				tb->l3mdev == l3mdev &&
> > -				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> > +				ipv6_addr_equal(&tb->v6_rcv_saddr, &in6addr_any);
> >  
> >  		return false;
> >  	}
> > @@ -840,7 +838,7 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
> >  	if (sk->sk_family == AF_INET6)
> >  		return net_eq(ib2_net(tb), net) && tb->port == port &&
> >  			tb->l3mdev == l3mdev &&
> > -			ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> > +			ipv6_addr_equal(&tb->v6_rcv_saddr, &in6addr_any);
> >  	else
> >  #endif
> >  		return net_eq(ib2_net(tb), net) && tb->port == port &&
> 
> and these 2.
