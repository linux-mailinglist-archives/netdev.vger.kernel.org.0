Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4A76BD835
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCPSfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCPSfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:35:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5213A9DC7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 11:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D0EC62085
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5362BC433D2;
        Thu, 16 Mar 2023 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678991714;
        bh=f6t1hSKI3jWPmhfqU82kvOrffYW0q4rVmER6H6BoW0c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hLehwFCXQyjPIxIk5diigjuMvn0NwVeNGRxWjZvh+sotfUa2AJz4MsyZAiIiiSKep
         OQTk4bmNqB490DH7MvjkdtpHSS78wcDccTLMZ9I7CU9PkksoI4VokKM/Y9i2zHBBkS
         AwYP48RvV6zFW9zMIaEfzpr7pWFzmZm5whrL/2cybxcWvnNMCy8ldVWuf9mCN/sYrl
         LJJ5Bg1l6M+f43BBP4V4sxYFVE3cSwBKD+m1kT7CTnTXfnlzunT2ithlgD+RmN6v62
         i+a+OmAPSOAStafiAoN1RiJeocVxX1keiycnxUsrs+s9mnl2CSfJdbeePEI3oZhe36
         z1Z2vUs5Lsd6Q==
Message-ID: <56f4f269-db99-9c97-cc42-c6969c49b3da@kernel.org>
Date:   Thu, 16 Mar 2023 12:35:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 net-next 0/8] inet: better const qualifier awareness
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Simon Horman <simon.horman@corigine.com>,
        eric.dumazet@gmail.com
References: <20230316153202.1354692-1-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/23 9:31 AM, Eric Dumazet wrote:
> inet_sk() can be changed to propagate const qualifier,
> thanks to container_of_const()
> 
> Following patches in this series add more const qualifiers.
> 
> Other helpers like tcp_sk(), udp_sk(), raw_sk(), ... will be handled
> in following series.
> 
> Eric Dumazet (8):
>   inet: preserve const qualifier in inet_sk()
>   ipv4: constify ip_mc_sf_allow() socket argument
>   udp: constify __udp_is_mcast_sock() socket argument
>   ipv6: constify inet6_mc_check()
>   udp6: constify __udp_v6_is_mcast_sock() socket argument
>   ipv6: raw: constify raw_v6_match() socket argument
>   ipv4: raw: constify raw_v4_match() socket argument
>   inet_diag: constify raw_lookup() socket argument
> 
>  include/linux/igmp.h        | 2 +-
>  include/net/addrconf.h      | 2 +-
>  include/net/inet_sock.h     | 5 +----
>  include/net/raw.h           | 2 +-
>  include/net/rawv6.h         | 2 +-
>  include/trace/events/sock.h | 4 ++--
>  include/trace/events/tcp.h  | 2 +-
>  net/ipv4/igmp.c             | 4 ++--
>  net/ipv4/ip_output.c        | 5 +++--
>  net/ipv4/raw.c              | 4 ++--
>  net/ipv4/raw_diag.c         | 2 +-
>  net/ipv4/udp.c              | 4 ++--
>  net/ipv6/mcast.c            | 8 ++++----
>  net/ipv6/ping.c             | 2 +-
>  net/ipv6/raw.c              | 2 +-
>  net/ipv6/udp.c              | 6 +++---
>  net/mptcp/sockopt.c         | 2 +-
>  security/lsm_audit.c        | 4 ++--
>  18 files changed, 30 insertions(+), 32 deletions(-)
> 

For the set:

Reviewed-by: David Ahern <dsahern@kernel.org>

