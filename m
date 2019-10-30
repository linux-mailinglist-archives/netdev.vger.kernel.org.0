Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66008E9553
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfJ3Db6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:31:58 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40910 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfJ3Db6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:31:58 -0400
Received: by mail-oi1-f195.google.com with SMTP id r27so763031oij.7
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Js5mhtuVxa+fjcz/j4M/kSo/xpHf0NeCctBJIyrTp4o=;
        b=atTwazZTlNVrzdKzWI2wh/c4RutSsWaJnyo9voicFesNdGZKPbrFejATv/ca/lje6K
         a+LId0L1Cx5R3YP+ZqmVyQ5XLNhdZ1mqp3GAwVOqgwkhOgyLOUDbhyRtdRPCgEokjUhb
         MZWFC1EBYqdNPEtorMs6S3CgMaQuTySCyfkCqvMFvQVr/7Zm/Td5hPwL6aGGPDvUvVPi
         +ISJ70elASqEGok6W3kaTkDYe3DPSBOldcvKAxtMFfBQQ4sy4NTUEzxwf7ZD3kidniew
         B6umjy4gOe/yF7H+PfhBWv5HmEmDbUYRxnrmQYWfYEzDBiBCY8o6cD/H7jfLtYtA0kS1
         0spA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Js5mhtuVxa+fjcz/j4M/kSo/xpHf0NeCctBJIyrTp4o=;
        b=rjpCgXkRamOoWNE8SZXCQ2JXob0FiTfoLs8JF5CuLbqcxP5+RKqlKFzOLAftnJPTDC
         U/aUnFMqKrFgOp5p1sNGt8vBOTZm3aMalRXf3eOlO6aMJ0q1PlqWoPVhLRiuQyIAO9VH
         JzchcZ4j/CP/XItaGw0zEwJqfz7wC1vRy5nu7bU5eP5uGKZXLrZbsZrtJkC8Enyw1Rnd
         pE6ikNoR6qL/fkYFx7PvH+n7UWr2w0Rf8lWkBzLLVs/G4UnQ0Mitm/6XD+aJ/wnboSCK
         FLzxn+5TQBUhNyvL0Ft8kGvxhw0jQQjCIibj+Q9taHSgDw+P+c2Bx1KWjJg9ZlYUG9VY
         10zw==
X-Gm-Message-State: APjAAAVBOxqEOofBPByrynKknoQpZ3o8E9VDfyT9nqoNs+/2biQwkrgH
        pe9TGCl7hkV4p5LTAJlpReI=
X-Google-Smtp-Source: APXvYqw9FI7viEFDrE0daM6/D1IHviDKghpkzWZQCOPB9R5YTiYnjC20ixphk9Jf9xeG70X/v1bQJQ==
X-Received: by 2002:a54:448b:: with SMTP id v11mr7120522oiv.155.1572406317005;
        Tue, 29 Oct 2019 20:31:57 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id a9sm358996otc.75.2019.10.29.20.31.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Oct 2019 20:31:56 -0700 (PDT)
Date:   Tue, 29 Oct 2019 20:31:54 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/2] mlxsw: spectrum_buffers: Calculate the size
 of the main pool
Message-ID: <20191030033154.GA43266@ubuntu-m2-xlarge-x86>
References: <20191023060500.19709-1-idosch@idosch.org>
 <20191023060500.19709-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023060500.19709-3-idosch@idosch.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 09:05:00AM +0300, Ido Schimmel wrote:
> From: Petr Machata <petrm@mellanox.com>
> 
> Instead of hard-coding the size of the largest pool, calculate it from the
> reported guaranteed shared buffer size and sizes of other pools (currently
> only the CPU port pool).
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  .../mellanox/mlxsw/spectrum_buffers.c         | 46 ++++++++++++++-----
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
> index 637151682cf2..5fd9a72c8471 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
> @@ -35,6 +35,7 @@ struct mlxsw_sp_sb_cm {
>  };
>  
>  #define MLXSW_SP_SB_INFI -1U
> +#define MLXSW_SP_SB_REST -2U
>  
>  struct mlxsw_sp_sb_pm {
>  	u32 min_buff;
> @@ -421,19 +422,16 @@ static void mlxsw_sp_sb_ports_fini(struct mlxsw_sp *mlxsw_sp)
>  		.freeze_size = _freeze_size,				\
>  	}
>  
> -#define MLXSW_SP1_SB_PR_INGRESS_SIZE	13768608
> -#define MLXSW_SP1_SB_PR_EGRESS_SIZE	13768608
>  #define MLXSW_SP1_SB_PR_CPU_SIZE	(256 * 1000)
>  
>  /* Order according to mlxsw_sp1_sb_pool_dess */
>  static const struct mlxsw_sp_sb_pr mlxsw_sp1_sb_prs[] = {
> -	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC,
> -		       MLXSW_SP1_SB_PR_INGRESS_SIZE),
> +	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
> -	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC,
> -			   MLXSW_SP1_SB_PR_EGRESS_SIZE, true, false),
> +	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST,
> +			   true, false),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
> @@ -445,19 +443,16 @@ static const struct mlxsw_sp_sb_pr mlxsw_sp1_sb_prs[] = {
>  			   MLXSW_SP1_SB_PR_CPU_SIZE, true, false),
>  };
>  
> -#define MLXSW_SP2_SB_PR_INGRESS_SIZE	34084800
> -#define MLXSW_SP2_SB_PR_EGRESS_SIZE	34084800
>  #define MLXSW_SP2_SB_PR_CPU_SIZE	(256 * 1000)
>  
>  /* Order according to mlxsw_sp2_sb_pool_dess */
>  static const struct mlxsw_sp_sb_pr mlxsw_sp2_sb_prs[] = {
> -	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC,
> -		       MLXSW_SP2_SB_PR_INGRESS_SIZE),
> +	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
> -	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC,
> -			   MLXSW_SP2_SB_PR_EGRESS_SIZE, true, false),
> +	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST,
> +			   true, false),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
>  	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
> @@ -471,11 +466,33 @@ static const struct mlxsw_sp_sb_pr mlxsw_sp2_sb_prs[] = {
>  
>  static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
>  				const struct mlxsw_sp_sb_pr *prs,
> +				const struct mlxsw_sp_sb_pool_des *pool_dess,
>  				size_t prs_len)
>  {
> +	/* Round down, unlike mlxsw_sp_bytes_cells(). */
> +	u32 sb_cells = mlxsw_sp->sb->sb_size / mlxsw_sp->sb->cell_size;

This causes a link time error on arm32. It can be simply reproduced with
the following configs + multi_v7_defconfig:

CONFIG_MLXSW_CORE=y
CONFIG_MLXSW_PCI=y
CONFIG_NET_SWITCHDEV=y
CONFIG_VLAN_8021Q=y
CONFIG_MLXSW_SPECTRUM=y

arm-linux-gnueabi-ld: drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.o: in function `mlxsw_sp_buffers_init':
spectrum_buffers.c:(.text+0x1c88): undefined reference to `__aeabi_uldivmod'

It can be solved by something like this but I am not sure if that is
proper or not since div_u64 returns a u64, which would implicitly get
converted to u32. I can submit it as a formal patch if needed but I
figured I would reach out first in case you want to go in a different
direction.

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 33a978af80d6..968f0902e4fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -470,7 +470,7 @@ static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
 				size_t prs_len)
 {
 	/* Round down, unlike mlxsw_sp_bytes_cells(). */
-	u32 sb_cells = mlxsw_sp->sb->sb_size / mlxsw_sp->sb->cell_size;
+	u32 sb_cells = div_u64(mlxsw_sp->sb->sb_size, mlxsw_sp->sb->cell_size);
 	u32 rest_cells[2] = {sb_cells, sb_cells};
 	int i;
 	int err;
