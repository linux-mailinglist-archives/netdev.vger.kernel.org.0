Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1AB2C1901
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbgKWWzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:55:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387933AbgKWWzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606172112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a0OtA5Iq4NqvlIu8lUkfVDZHwl0Vuf5SQX9Ysya8MhQ=;
        b=K9pLpOcg8Tfos/Eaq4JRSr+dzbgq+5Hg+zzCG6tOdeZQLFQr06pKR+vd+sYIBvfs48vRhX
        2EGx64wLDesUnJoZhqAVUHqh6+c4uNyYisdApB/97IaZVnYUAuDkFpcsZ7m+KLL4U8QXA1
        V7wQvfyxqt/uKFgArRfcyxkXVumSQB4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-sEcEMjM-OpKDEQTYAaGMVw-1; Mon, 23 Nov 2020 17:55:09 -0500
X-MC-Unique: sEcEMjM-OpKDEQTYAaGMVw-1
Received: by mail-wr1-f69.google.com with SMTP id r12so922569wrl.3
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:55:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a0OtA5Iq4NqvlIu8lUkfVDZHwl0Vuf5SQX9Ysya8MhQ=;
        b=ZsrFrxJ9b7BTabRLBxM9GMk3mEJ7XpkLyl2fTkGpxldVKEX637sSd4WVF1eG1c2oqp
         ivbwRzV6aNFmGw90VVb2UR1IDsvRLYG7UGoVJeV4we1n+JJELlVYizHwk1d83ZCqwu9Y
         xhVxkgM64VAnHm85W0yP58iw5vRSaDEcS0ellNP7i5fhEZ8IzQVCUEC/m/jTUFmuDaGG
         f1eiIM8sdVK3JK7w31Dg2N1fAGdsgVkFpm3p7HNozAhk9JsGBoSvtJH3m/Z50HVzfdhJ
         5oLFmsJWscyLDCpOycuzu3ycVQcYkwntCAxmApTN9Ow8X+9Lf9QpWoQruY8XPlW9dKZA
         mtFw==
X-Gm-Message-State: AOAM531/2plHcMM7IgogQ4WFWqc7dyhu+oazUzU62miOA/pOYnG4N4Ez
        o4mQVYxkuiv0V9ldGVvehjdisySvU4ahDxsj4MOJXiL41s3OHr0ABLRQLrAYANK7GK9pE17Ibz7
        9LF20ZcRjByaw8J4v
X-Received: by 2002:a5d:4046:: with SMTP id w6mr1961982wrp.51.1606172108369;
        Mon, 23 Nov 2020 14:55:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQsS3jYxSKcktGLshl9mY10WagGxMEkX3oz8FWWkgBnuGCHUwGHWPoih9L2PAC0WZ+yLZJtA==
X-Received: by 2002:a5d:4046:: with SMTP id w6mr1961973wrp.51.1606172108166;
        Mon, 23 Nov 2020 14:55:08 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id k81sm2471319wma.2.2020.11.23.14.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 14:55:07 -0800 (PST)
Date:   Mon, 23 Nov 2020 23:55:05 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
Message-ID: <20201123225505.GA21345@linux.home>
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 06:24:46PM +1000, Russell Strong wrote:
> From 2f27f92d5a6f4dd69ac4af32cdb51ba8d2083606 Mon Sep 17 00:00:00 2001
> From: Russell Strong <russell@strong.id.au>
> Date: Sat, 21 Nov 2020 18:12:43 +1000
> Subject: [PATCH] DSCP in IPv4 routing v2
> 
> This patch allows the use of DSCP values in routing

Thanks. There are some problems with this patch though.

About the email:
  * Why did you duplicate email headers in the body?
  * For the subject, please put the "v2" in the "[PATCH ... ]" part.
  * You're modifying many files, but haven't Cc-ed any of their authors
    or maintainers.
  * The patch content is corrupted.

> Use of TOS macros are replaced with DSCP macros
> where the change does not change the user space API
> with one exception:
> 
> net/ipv4/fib_rules.c has been changed to accept a
> wider range of values ( dscp values ).  Previously
> this would have returned an error.

Have you really verified that replacing each of these RT_TOS calls had
no unwanted side effect?

RT_TOS didn't clear the second lowest bit, while the new IP_DSCP does.
Therefore, there's no guarantee that such a blanket replacement isn't
going to change existing behaviours. Replacements have to be done
step by step and accompanied by an explanation of why they're safe.

BTW, I think there are some problems with RT_TOS that need to be fixed
separately first.

For example some of the ip6_make_flowinfo() calls can probably
erroneously mark some packets with ECT(0). Instead of masking the
problem in this patch, I think it'd be better to have an explicit fix
that'd mask the ECN bits in ip6_make_flowinfo() and drop the buggy
RT_TOS() in the callers.

Another example is inet_rtm_getroute(). It calls
ip_route_output_key_hash_rcu() without masking the tos field first.
Therefore it can return a different route than what the routing code
would actually use. Like for the ip6_make_flowinfo() case, it might
be better to stop relying on the callers to mask ECN bits and do that
in ip_route_output_key_hash_rcu() instead.

I'll verify that these two problems can actually happen in practice
and will send patches if necessary.

> iproute2 already supports setting dscp values through
> ip route add dsfield <dscp value> lookup ......
> 
> Signed-off-by: Russell Strong <russell@strong.id.au>
> ---
>  .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  2 +-
>  drivers/net/geneve.c                          |  4 ++--
>  drivers/net/ipvlan/ipvlan_core.c              |  2 +-
>  drivers/net/ppp/pptp.c                        |  2 +-
>  drivers/net/vrf.c                             |  2 +-
>  drivers/net/vxlan.c                           |  4 ++--
>  include/net/ip.h                              |  2 +-
>  include/net/route.h                           |  6 ++----
>  include/uapi/linux/ip.h                       |  2 ++
>  net/bridge/br_netfilter_hooks.c               |  2 +-
>  net/core/filter.c                             |  4 ++--
>  net/core/lwt_bpf.c                            |  2 +-
>  net/ipv4/fib_frontend.c                       |  2 +-
>  net/ipv4/fib_rules.c                          |  2 +-
>  net/ipv4/icmp.c                               |  6 +++---
>  net/ipv4/ip_gre.c                             |  2 +-
>  net/ipv4/ip_output.c                          |  2 +-
>  net/ipv4/ip_tunnel.c                          |  6 +++---
>  net/ipv4/ipmr.c                               |  6 +++---
>  net/ipv4/netfilter.c                          |  2 +-
>  net/ipv4/netfilter/ipt_rpfilter.c             |  2 +-
>  net/ipv4/netfilter/nf_dup_ipv4.c              |  2 +-
>  net/ipv4/route.c                              | 20 +++++++++----------
>  net/ipv6/ip6_output.c                         |  2 +-
>  net/ipv6/ip6_tunnel.c                         |  4 ++--
>  net/ipv6/sit.c                                |  4 ++--
>  net/xfrm/xfrm_policy.c                        |  2 +-
>  27 files changed, 49 insertions(+), 49 deletions(-)

