Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EE52EFACF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbhAHV7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHV7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 16:59:44 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8FDC061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 13:59:03 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id h4so9894344qkk.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 13:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DbwATEwdzAAGjj1KQbrvPltFbMP8EFtJQgd9wlBqTzA=;
        b=BvjdW9hN0Ay8SYnziDMOMxASCtaNK2t0eW54We4jNpTGXmMxgePjPw5TRU17haFwOX
         kbuR9lHefTBilN07iJcKypTpmUZ0B5bsDBgTstUgxGld+4Yl0sKgTg7dQdJyTBU6YTzi
         brz3A680fnCviz1Hkp2XfATz+URUkxK4UBpGvFLXSsXPL3+v+uus1gD6FmjuAhS+7j6g
         yTZrsKqMvnltYNkO2qbf6oWKRwP3g0DtFyD+7i6/l3a35s3GaJUxTa2uQrMoBGhy3PEz
         +ZWucvlX2euLz0jv97zdTuepcgOC4JCKOYfwfv4bou3DRtys2TAG9wjwWulLYtjPH3Vr
         Ug6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DbwATEwdzAAGjj1KQbrvPltFbMP8EFtJQgd9wlBqTzA=;
        b=bbjph9qnkCuCohdSlT6GoPXRlyos2WGl7kfwj4Tigo93Nvnz7V91m2b/pouGnq+QDI
         CeqcG0XGYW69zyshH6dV/KIWM9+Qc+biW4mab/p91kHwCZ7aWjsE/ktkUvJB185x5fWK
         IvVdPjSf6NZ2fJEP5lBesP4/QpACNFnUBrfFb7FYzdU9DIEWvuZ7MCfexOhyjeaN2mRb
         Wqm09+OhSCiOk2yQQ8f2lU3/LjTLjPhxyD/jUcyLBo9YQCdNk7gxVJVowwr1R6b9w/Ex
         1x3+xb4PbNvNin6cCK5u0BAXzlXGvqmbGd9dkbaKaEdI0Hqk+MPe0gus2jKLT316jnxD
         9XJA==
X-Gm-Message-State: AOAM533aoLL/ThyR+W0WVGc+K/+YmczN+r1QLjxIbHW3c8wysrr9Lr3w
        yqiGna5oxrEtHM4h4nYDufI=
X-Google-Smtp-Source: ABdhPJzy1LYn8m+rmhipY8OdIVIRSJOV3yPwlSGVJ8EOs8PzoLDYsur9n+LX9DGz7qGzoX6rZDnUtw==
X-Received: by 2002:a37:345:: with SMTP id 66mr5851442qkd.322.1610143143089;
        Fri, 08 Jan 2021 13:59:03 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f013:71a8:2c34:8038:3be4:441b])
        by smtp.gmail.com with ESMTPSA id c14sm5055910qtg.85.2021.01.08.13.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:59:02 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 22983C0095; Fri,  8 Jan 2021 18:59:00 -0300 (-03)
Date:   Fri, 8 Jan 2021 18:59:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 09/15] net/mlx5e: CT: Support offload of +trk+new ct
 rules
Message-ID: <20210108215900.GC3678@horizon.localdomain>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-10-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108053054.660499-10-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jan 07, 2021 at 09:30:48PM -0800, Saeed Mahameed wrote:
> @@ -1429,6 +1600,14 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
>  	if (err)
>  		goto err_insert;
>  
> +	nf_ct_zone_init(&ctzone, zone, NF_CT_DEFAULT_ZONE_DIR, 0);
> +	ft->tmpl = nf_ct_tmpl_alloc(&init_net, &ctzone, GFP_KERNEL);

I didn't test but I think this will add a hard dependency to
nf_conntrack_core and will cause conntrack to always be loaded by
mlx5_core, which is not good for some use cases.
nf_ct_tmpl_alloc() is defined in nf_conntrack_core.c.

762f926d6f19 ("net/sched: act_ct: Make tcf_ct_flow_table_restore_skb
inline") was done similarly to avoid this.

> +	if (!ft->tmpl)
> +		goto err_tmpl;
> +
> +	__set_bit(IPS_CONFIRMED_BIT, &ft->tmpl->status);
> +	nf_conntrack_get(&ft->tmpl->ct_general);
> +
>  	err = nf_flow_table_offload_add_cb(ft->nf_ft,
>  					   mlx5_tc_ct_block_flow_offload, ft);
>  	if (err)
