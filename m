Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BE9367E13
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhDVJp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbhDVJp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:45:56 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE52C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 02:45:22 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s15so52683043edd.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 02:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=InL6JkjcoekxNOoclWCb17Bs9BWbgksVUpeKoXAFNFE=;
        b=J7mMK5yAhWb0ur7UgcTIW/757x26JAj//w2lEOlF1s6bCNRqOfyRCrqK3eC1DiXKiD
         qROQcZyL5AjPBHDYqumfURnH/i19AtWJJmmpARTLxYcZLZ8WSKh1CZqfJAeEvN+pWl0v
         7jeiqZOApKC83/CXEj/Edk0Mpx3wn2utkm+TUxiEUSS10xL8Mh2JFcYBepBRDmOQU/Mi
         /73KdlO7DV63y0oHmhDLCG3eZA+M1l5FGiU90zkj3mbA+LJVuPsAunsAu7l8uyQzn5Ja
         Lbuh4wRW9uyPrRhzc7vWmgI7ejLhYq47NoYdgwfWMLxQDzyr3JfiPULA+sjh7bfWIjwD
         2YVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=InL6JkjcoekxNOoclWCb17Bs9BWbgksVUpeKoXAFNFE=;
        b=CZRptVm2kmslgqXLH8LVyk+PlYzePj8sPHJvh9g20HPzQAEoBfRqz6yrs2xTYOrxxQ
         l65It5WYDgEk+ixHsD/qr1elSh2BnVXXLWNFc/HK36/XxpGHilqXh81wp94pqpoD5d3l
         nM0zTO2QH92cD5T0FqKCtD4Yrm8DlDduFyfST2WtLzc/cez1ixbrFNQLFQyjs55vjfhn
         M1S2Cl+ubNyHkBa7G/2x2FPGy2I7bnoGT/1Rjwuvos8pKwRxyUXnTTAURHwpZ7q/lVW/
         i1b7G27Y2o5Fj9YAHCqy5uyQuBitYD3siHNN+n1Y1NrGqhG5IJHWmf6AOMgndXvzkfHn
         ouLQ==
X-Gm-Message-State: AOAM531/GbcqCmtmZIzKDAPxvSzgKRxeXry60sGpxqh2edXSUDnclCbA
        tbwSxWhVJk8tGsPMlubJ1QE8r0+kiOY=
X-Google-Smtp-Source: ABdhPJzzsq8kjDxeOQloJcxiCuybvJIgpWuFsy3DucjgYkMH3WbYTUVWjHLhl5Vn6RrFNgLHTWyJCQ==
X-Received: by 2002:a05:6402:2219:: with SMTP id cq25mr2680989edb.60.1619084720619;
        Thu, 22 Apr 2021 02:45:20 -0700 (PDT)
Received: from [192.168.1.115] ([77.124.203.106])
        by smtp.gmail.com with ESMTPSA id w6sm1473542eje.107.2021.04.22.02.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 02:45:20 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net/mlx4: Treat VFs fair when handling
 comm_channel_events
To:     Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <1619072500-13789-1-git-send-email-hans.westgaard.ry@oracle.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <f4807945-4a7c-c701-86ae-bd2bb01af781@gmail.com>
Date:   Thu, 22 Apr 2021 12:45:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1619072500-13789-1-git-send-email-hans.westgaard.ry@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 9:21 AM, Hans Westgaard Ry wrote:
> Handling comm_channel_event in mlx4_master_comm_channel uses a double
> loop to determine which slaves have requested work. The search is
> always started at lowest slave. This leads to unfairness; lower VFs
> tends to be prioritized over higher VFs.
> 
> The patch uses find_next_bit to determine which slaves to handle.
> Fairness is implemented by always starting at the next to the last
> start.
> 
> An MPI program has been used to measure improvements. It runs 500
> ibv_reg_mr, synchronizes with all other instances and then runs 500
> ibv_dereg_mr.
> 
> The results running 500 processes, time reported is for running 500
> calls:
> 
> ibv_reg_mr:
>               Mod.   Org.
> mlx4_1    403.356ms 424.674ms
> mlx4_2    403.355ms 424.674ms
> mlx4_3    403.354ms 424.674ms
> mlx4_4    403.355ms 424.674ms
> mlx4_5    403.357ms 424.677ms
> mlx4_6    403.354ms 424.676ms
> mlx4_7    403.357ms 424.675ms
> mlx4_8    403.355ms 424.675ms
> 
> ibv_dereg_mr:
>               Mod.   Org.
> mlx4_1    116.408ms 142.818ms
> mlx4_2    116.434ms 142.793ms
> mlx4_3    116.488ms 143.247ms
> mlx4_4    116.679ms 143.230ms
> mlx4_5    112.017ms 107.204ms
> mlx4_6    112.032ms 107.516ms
> mlx4_7    112.083ms 184.195ms
> mlx4_8    115.089ms 190.618ms
> 
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> ---
> v1 -> v2:
>   - removed set but not user varible,
>     reported by 'kernel test robot'
>   - fixed reversed Christmas tree,
>     removed else,
>     removed extra varibles in printout,
>     moved next_slave to struct mlx4_mfunc_master_ctx,
>     as suggested by Tariq Toukan
>   drivers/net/ethernet/mellanox/mlx4/cmd.c  | 69 ++++++++++++++++++-------------
>   drivers/net/ethernet/mellanox/mlx4/mlx4.h |  1 +
>   2 files changed, 41 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
> index c678344d22a2..8d751383530b 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
> @@ -2241,43 +2241,52 @@ void mlx4_master_comm_channel(struct work_struct *work)
>   	struct mlx4_priv *priv =
>   		container_of(mfunc, struct mlx4_priv, mfunc);
>   	struct mlx4_dev *dev = &priv->dev;
> -	__be32 *bit_vec;
> +	u32 lbit_vec[COMM_CHANNEL_BIT_ARRAY_SIZE];
> +	u32 nmbr_bits;
>   	u32 comm_cmd;
> -	u32 vec;
> -	int i, j, slave;
> +	int i, slave;
>   	int toggle;
> +	bool first = true;
>   	int served = 0;
>   	int reported = 0;
>   	u32 slt;
>   
> -	bit_vec = master->comm_arm_bit_vector;
> -	for (i = 0; i < COMM_CHANNEL_BIT_ARRAY_SIZE; i++) {
> -		vec = be32_to_cpu(bit_vec[i]);
> -		for (j = 0; j < 32; j++) {
> -			if (!(vec & (1 << j)))
> -				continue;
> -			++reported;
> -			slave = (i * 32) + j;
> -			comm_cmd = swab32(readl(
> -					  &mfunc->comm[slave].slave_write));
> -			slt = swab32(readl(&mfunc->comm[slave].slave_read))
> -				     >> 31;
> -			toggle = comm_cmd >> 31;
> -			if (toggle != slt) {
> -				if (master->slave_state[slave].comm_toggle
> -				    != slt) {
> -					pr_info("slave %d out of sync. read toggle %d, state toggle %d. Resynching.\n",
> -						slave, slt,
> -						master->slave_state[slave].comm_toggle);
> -					master->slave_state[slave].comm_toggle =
> -						slt;
> -				}
> -				mlx4_master_do_cmd(dev, slave,
> -						   comm_cmd >> 16 & 0xff,
> -						   comm_cmd & 0xffff, toggle);
> -				++served;
> +	for (i = 0; i < COMM_CHANNEL_BIT_ARRAY_SIZE; i++)
> +		lbit_vec[i] = be32_to_cpu(master->comm_arm_bit_vector[i]);
> +	nmbr_bits = dev->persist->num_vfs + 1;
> +	if (++master->next_slave >= nmbr_bits)
> +		master->next_slave = 0;
> +	slave = master->next_slave;
> +	while (true) {
> +		slave = find_next_bit((const unsigned long *)&lbit_vec, nmbr_bits, slave);
> +		if  (!first && slave >= master->next_slave)
> +			break;
> +		if (slave == nmbr_bits) {
> +			if (!first)
> +				break;
> +			first = false;
> +			slave = 0;
> +			continue;
> +		}
> +		++reported;
> +		comm_cmd = swab32(readl(&mfunc->comm[slave].slave_write));
> +		slt = swab32(readl(&mfunc->comm[slave].slave_read)) >> 31;
> +		toggle = comm_cmd >> 31;
> +		if (toggle != slt) {
> +			if (master->slave_state[slave].comm_toggle
> +			    != slt) {
> +				pr_info("slave %d out of sync. read toggle %d, state toggle %d. Resynching.\n",
> +					slave, slt,
> +					master->slave_state[slave].comm_toggle);
> +				master->slave_state[slave].comm_toggle =
> +					slt;
>   			}
> +			mlx4_master_do_cmd(dev, slave,
> +					   comm_cmd >> 16 & 0xff,
> +					   comm_cmd & 0xffff, toggle);
> +			++served;
>   		}
> +		slave++;
>   	}
>   
>   	if (reported && reported != served)
> @@ -2389,6 +2398,8 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
>   		if (!priv->mfunc.master.vf_oper)
>   			goto err_comm_oper;
>   
> +		priv->mfunc.master.next_slave = 0;
> +
>   		for (i = 0; i < dev->num_slaves; ++i) {
>   			vf_admin = &priv->mfunc.master.vf_admin[i];
>   			vf_oper = &priv->mfunc.master.vf_oper[i];
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
> index 64bed7ac3836..6ccf340660d9 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
> @@ -603,6 +603,7 @@ struct mlx4_mfunc_master_ctx {
>   	struct mlx4_slave_event_eq slave_eq;
>   	struct mutex		gen_eqe_mutex[MLX4_MFUNC_MAX];
>   	struct mlx4_qos_manager qos_ctl[MLX4_MAX_PORTS + 1];
> +	u32			next_slave; /* mlx4_master_comm_channel */
>   };
>   
>   struct mlx4_mfunc {
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq
