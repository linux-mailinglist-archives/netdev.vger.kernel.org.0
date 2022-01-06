Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2C4863E4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbiAFLrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:47:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238456AbiAFLrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 06:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641469655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JmYlpKMr8CKpf6fyr357VXSg1khRx4NOCWbl+7kGAB4=;
        b=Y1e7gSHWtfeE9GRorafgd4pyd+iewfjatrmq2k7oafpGWG79hMMhfob/Djvs8zmr3sFe8e
        r77pjxl/eGjznAx2tAFgzasTSaGzrW2+WoBDGgC+rpylAcfdZn3A6tk/p5puTaiishB6p7
        5NE7jDNTARSZ6SS4X75zDuv2B5ilLZk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-GonDRogFOjWmdtd26v37mw-1; Thu, 06 Jan 2022 06:47:34 -0500
X-MC-Unique: GonDRogFOjWmdtd26v37mw-1
Received: by mail-wm1-f70.google.com with SMTP id n14-20020a05600c3b8e00b0034693893555so164568wms.5
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 03:47:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JmYlpKMr8CKpf6fyr357VXSg1khRx4NOCWbl+7kGAB4=;
        b=kG6L0evzBgfRbgnE9BQN9mor+bMq1cnFOJKAMqC2pKAGcZHA1To+W3tvbCfnHnrZqg
         WYqVzr3YbV38U3xYKlNQXCkCZ7N+csFoMm4STFMC2V4sot6jZW4kY+4RxNmDMsbqGEPt
         NN4/QvQAIcOUXofAwCV2T8yTDqVgnzVxL1fm1DTaC7/6TvxEC286ijHXJ1Za3Ir/C2Aq
         F6mM1/FYwwU2hIU2DPhuifwjgnnM6HsLhK+1FpLlfg3jHNBJibQuDC15KY7+wXi0gBgO
         5XxVIsh9hG79CMy0qz2wBs1GQZY/k8Vay7AG9AEtV8QoL7dcRRO8Vp32r+QGUT6fG3k3
         oYnA==
X-Gm-Message-State: AOAM531lNNRo8ZdXS6n+OGzwaLi0cPz/orCYDyf2LzYbF+9qi4jcvrPl
        zv3X25T6tTlKVNm7IiClkQlsJkhGXMIs8JoLQ5p7QZDBDCftS4Mz9AXKglmWAOklqN3nHle5Fn0
        /v3qB7ogh1cBgWM1U
X-Received: by 2002:a05:600c:3510:: with SMTP id h16mr6802783wmq.172.1641469652933;
        Thu, 06 Jan 2022 03:47:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxzSs42uoU9uXKIubR1R4am3c+BSXX/denGb51JXMMLg4BekqTtvIEqc4f+84qIQ2s1Mv1+og==
X-Received: by 2002:a05:600c:3510:: with SMTP id h16mr6802771wmq.172.1641469652735;
        Thu, 06 Jan 2022 03:47:32 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id n12sm2131015wrf.29.2022.01.06.03.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 03:47:32 -0800 (PST)
Date:   Thu, 6 Jan 2022 12:47:30 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     roid@nvidia.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH net 4/4] mlx5: Don't accidentally set RTO_ONLINK before
 mlx5e_route_lookup_ipv4_get()
Message-ID: <20220106114730.GA15145@pc-1.home>
References: <cover.1641407336.git.gnault@redhat.com>
 <a0ba792bbbf088882a55507c932f1abec915c3b6.1641407336.git.gnault@redhat.com>
 <20220106035723.o4emdnfvhipoiz5r@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106035723.o4emdnfvhipoiz5r@sx1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 07:57:23PM -0800, Saeed Mahameed wrote:
> On Wed, Jan 05, 2022 at 08:56:28PM +0100, Guillaume Nault wrote:
> > Mask the ECN bits before calling mlx5e_route_lookup_ipv4_get(). The
> > tunnel key might have the last ECN bit set. This interferes with the
> > route lookup process as ip_route_output_key_hash() interpretes this bit
> > specially (to restrict the route scope).
> > 
> > Found by code inspection, compile tested only.
> > 
> > Fixes: c7b9038d8af6 ("net/mlx5e: TC preparation refactoring for routing update event")
> > Fixes: 9a941117fb76 ("net/mlx5e: Maximize ip tunnel key usage on the TC offloading path")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> > drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 +++--
> > 1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> > index a5e450973225..bc5f1dcb75e1 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> > @@ -1,6 +1,7 @@
> > /* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> > /* Copyright (c) 2018 Mellanox Technologies. */
> > 
> > +#include <net/inet_ecn.h>
> > #include <net/vxlan.h>
> > #include <net/gre.h>
> > #include <net/geneve.h>
> > @@ -235,7 +236,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
> > 	int err;
> > 
> > 	/* add the IP fields */
> > -	attr.fl.fl4.flowi4_tos = tun_key->tos;
> > +	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;
> 
> This is TC control path, why would ecn bits be ON in TC act->tunnel info ?

As far as I understand, the value of tun_key->tos can be set by
act_tunnel_key.c, which doesn't impose any restriction on the tos value
(TCA_TUNNEL_KEY_ENC_TOS). Unless I've missed something (I'm not
familiar with the hardware offload infrastructure), tun_key->tos is
effectively under user control.

> I don't believe these bits are on and if they were, TC tunnels layer should
> clear them before calling the driver's offload callback.

We could reject TOS values that have the ECN bits set in
act_tunnel_key.c, but that'd be a much broader change, and a user
visible one. At the very least it'd be something for net-next, while
this series tries to fix bugs in net.

Also, from a logical point of view, callers of ip_route_output_key()
are responsible for properly setting or clearing the RTO_ONLINK flag.
We shouldn't have to change act_tunnel_key.c because one of the drivers
offload path might call ip_route_output_key().

Even though I agree that act_tunnel_key should ideally not accept ECN
bits in TCA_TUNNEL_KEY_ENC_TOS, it should refuse them for user
understandable reasons (decouple DSCP and ECN), not because of some
drivers implementation details.

