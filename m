Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF706E936A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbjDTLwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjDTLwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B633E69
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACF7063D9B
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C70FC433EF;
        Thu, 20 Apr 2023 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681991568;
        bh=ozCpAG+ISulou2Zh7SyotCKoU3h5FCbK6fgEN2FikXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXFNLcFp6vEhFiYyBCUzpHXwgmTjDlS4kB13+lqgfGQmSxFK1ZH/eqhTvPjuU/TPB
         P9GJR7mvRA7+UOSHldWmExYjJ8K633tAVDJ+xi+Xbk7fYQWtjWwqiz0swDOVdA+ddT
         nVj+WywQtrtX+bOS+p/7oi7vpLF6zOvSMyH3uGXZdzFEUbq2hCRIz5atQmT5rHzPfg
         FsJmsvyD8KkwcxyV/QYPo8pb53EJ/dx8up2uT4ex2/1PTh9wXY9LPXzQ3L1btUYG31
         TTH+5zFlQqME5DiFuMwfOBYxp9Ov7D9WjOJLRhVT8sRvFhDe+C6TR77XbGu2hYAJ2K
         8eZYD8qAxRU6w==
Date:   Thu, 20 Apr 2023 14:52:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 3/5] net/mlx5e: Compare all fields in IPv6
 address
Message-ID: <20230420115243.GC4423@unreal>
References: <cover.1681976818.git.leon@kernel.org>
 <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
 <ZEEdY+qtAQQaFbZP@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEEdY+qtAQQaFbZP@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 01:09:23PM +0200, Simon Horman wrote:
> On Thu, Apr 20, 2023 at 11:02:49AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Fix size argument in memcmp to compare whole IPv6 address.
> > 
> > Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > index f7f7c09d2b32..4e9887171508 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > @@ -287,7 +287,7 @@ static inline bool addr6_all_zero(__be32 *addr6)
> >  {
> >  	static const __be32 zaddr6[4] = {};
> >  
> > -	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
> > +	return !memcmp(addr6, zaddr6, sizeof(zaddr6));
> 
> 1. Perhaps array_size() is appropriate here?

It is overkill here, sizeof(zaddr6) is constant and can't overflow.

  238 /**
  239  * array_size() - Calculate size of 2-dimensional array.
  240  * @a: dimension one
  241  * @b: dimension two
  242  *
  243  * Calculates size of 2-dimensional array: @a * @b.
  244  *
  245  * Returns: number of bytes needed to represent the array or SIZE_MAX on
  246  * overflow.
  247  */
  248 #define array_size(a, b)        size_mul(a, b)

> 2. It's a shame that ipv6_addr_any() or some other common helper
>    can't be used.

I didn't use ipv6_addr_any() as it required from me to cast "__be32 *addr6"
to be "struct in6_addr *" just to replace one line memcmp to another one
line function.

Do you want me to post this code instead?

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 55b38544422f..a7c8e38658a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -945,7 +945,8 @@ static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
 	}
 
 	if (!x->xfrm_vec[0].reqid && sel->proto == IPPROTO_IP &&
-	    addr6_all_zero(sel->saddr.a6) && addr6_all_zero(sel->daddr.a6)) {
+	    ipv6_addr_any((struct in6_addr *)sel->saddr.a6) &&
+	    ipv6_addr_any((struct in6_addr *)sel->daddr.a6)) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported policy with reqid 0 without at least one of upper protocol or ip addr(s) different than 0");
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 4e9887171508..097001ce5dc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -283,12 +283,6 @@ mlx5e_ipsec_pol2dev(struct mlx5e_ipsec_pol_entry *pol_entry)
 	return pol_entry->ipsec->mdev;
 }
 
-static inline bool addr6_all_zero(__be32 *addr6)
-{
-	static const __be32 zaddr6[4] = {};
-
-	return !memcmp(addr6, zaddr6, sizeof(zaddr6));
-}
 #else
 static inline void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index dbe87bf89c0d..e48113923c12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -721,7 +721,8 @@ static void setup_fte_addr4(struct mlx5_flow_spec *spec, __be32 *saddr,
 static void setup_fte_addr6(struct mlx5_flow_spec *spec, __be32 *saddr,
 			    __be32 *daddr)
 {
-	if (addr6_all_zero(saddr) && addr6_all_zero(daddr))
+	if (ipv6_addr_any((struct in6_addr *)saddr) &&
+	    ipv6_addr_any((struct in6_addr *)daddr))
 		return;
 
 	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
@@ -729,14 +730,14 @@ static void setup_fte_addr6(struct mlx5_flow_spec *spec, __be32 *saddr,
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
 	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, 6);
 
-	if (!addr6_all_zero(saddr)) {
+	if (!ipv6_addr_any((struct in6_addr *)saddr)) {
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), saddr, 16);
 		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
 				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), 0xff, 16);
 	}
 
-	if (!addr6_all_zero(daddr)) {
+	if (!ipv6_addr_any((struct in6_addr *)daddr)) {
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), daddr, 16);
 		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,


Thanks

> 
> >  }
> >  #else
> >  static inline void mlx5e_ipsec_init(struct mlx5e_priv *priv)
> > -- 
> > 2.40.0
> > 
