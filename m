Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77104676BA1
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 09:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjAVI37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 03:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjAVI36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 03:29:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168541714B;
        Sun, 22 Jan 2023 00:29:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D884FB80921;
        Sun, 22 Jan 2023 08:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3181C433EF;
        Sun, 22 Jan 2023 08:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674376193;
        bh=ZA8zSCJE9xvdSiVN9T0RTVdYdMvJ7sS0CBApAt9i0jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/Gg+OX+S81H15JTWMoMLXQ9QyZNrUr92DdxWUboyIDkWXZitw6OIqwEKvWbiCnXR
         CJDCDnLrLy8aFOI7P2IwYamAZ/dLN5fLQ8L/WoFNJnU641seza6anM/UgksY91QN0o
         IgwBJS8j8+7PKPazfM1+das4sHfZ+p1Dz3qPLU4qMSInDw152xnXLqW53S1liPhg/D
         w9rLPpPMpo82g0bhPlb1SAsfztq6VF1nqgL4obTG72BC9hpwyc1DIjSgGXkwpSHxgO
         OOhnIMaa3qA1rVpaCEA6kX4scC41211B58GYUp0aL8TKGha/NzcetNPFHK91hzidWt
         vtL4/ud6H8d0w==
Date:   Sun, 22 Jan 2023 10:29:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        saeedm@nvidia.com, richardcochran@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, moshet@nvidia.com, linux-rdma@vger.kernel.org,
        maxtram95@gmail.com
Subject: Re: [net-next Patch v2 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
Message-ID: <Y8zz/eDMsXEr5KMk@unreal>
References: <20230118100410.8834-1-hkelam@marvell.com>
 <20230118100410.8834-2-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118100410.8834-2-hkelam@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 03:34:06PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> The current implementation of HTB offload returns the EINVAL error
> for unsupported parameters like prio and quantum. This patch removes
> the error returning checks for 'prio' parameter and populates its
> value to tc_htb_qopt_offload structure such that driver can use the
> same.
> 
> Add prio parameter check in mlx5 driver, as mlx5 devices are not capable
> of supporting the prio parameter when htb offload is used. Report error
> if prio parameter is set to a non-default value.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
> v2*  ensure other drivers won't effect by allowing 'prio'
>      parameter in htb offload mode

<...>

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> index 2842195ee548..e16b3d6ea471 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> @@ -379,6 +379,12 @@ int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb_
>  	if (!htb && htb_qopt->command != TC_HTB_CREATE)
>  		return -EINVAL;
> 
> +	if (htb_qopt->prio) {
> +		NL_SET_ERR_MSG(htb_qopt->extack,
> +			       "prio parameter is not supported by device with HTB offload enabled.");

NL_SET_ERR_MSG_MOD()

Thanks
