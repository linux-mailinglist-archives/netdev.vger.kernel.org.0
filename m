Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283004E3427
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiCUXOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiCUXOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:14:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C2734BE18;
        Mon, 21 Mar 2022 16:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E4D861290;
        Mon, 21 Mar 2022 21:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7CEC340E8;
        Mon, 21 Mar 2022 21:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899133;
        bh=PLATsyQnK/O0pIHqhHWMWdIfCJuI1483DX+TA0bTLOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GGSFdgbJv3Cjk4DlKoaGX6GmbjYj2N+msTu/8T0fGL42WZ1/HBdFX/X/mVfDYZ+FV
         uVpb/HkEVBbm7bJRctk8RsWvHGJWwsfgcrFB1r6QkDxJVl5/2SweXcgiupjQyAbp+5
         I59ZYTIeBJQqdFcXck8LuwrOmzDOVN/PlsIYXkiq+COVbNb7Oc9A341q0YmOv2yF6B
         l6/fskCqA/xl7B8lDilPkmckO6j3CeHTGFvavHsXXqflPjJIyj3oqxRJLbifiEa+8q
         UClaFiETzaod2lfN435a4r+K/RN6h6hjuq5DQvWr/UcjipoUuD96fMjjQ/TtwH2PWX
         3ppLAJbOO1TXA==
Date:   Mon, 21 Mar 2022 14:45:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20220321144531.2b0503a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220321183941.74be2543@canb.auug.org.au>
References: <20220321183941.74be2543@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 18:39:41 +1100 Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from include/linux/string.h:253,
>                  from include/linux/bitmap.h:11,
>                  from include/linux/cpumask.h:12,
>                  from arch/x86/include/asm/cpumask.h:5,
>                  from arch/x86/include/asm/msr.h:11,
>                  from arch/x86/include/asm/processor.h:22,
>                  from arch/x86/include/asm/timex.h:5,
>                  from include/linux/timex.h:65,
>                  from include/linux/time32.h:13,
>                  from include/linux/time.h:60,
>                  from include/linux/ktime.h:24,
>                  from include/linux/timer.h:6,
>                  from include/linux/netdevice.h:24,
>                  from include/trace/events/xdp.h:8,
>                  from include/linux/bpf_trace.h:5,
>                  from drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:33:
> In function 'fortify_memset_chk',
>     inlined from 'mlx5e_xmit_xdp_frame' at drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:438:3:
> include/linux/fortify-string.h:242:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   242 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Caused by commit
> 
>   9ded70fa1d81 ("net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode")
> 
> exposed by the kspp tree.
> 
> I have applied the following fix patch for today (a better one is
> probably possible).

Hi Saeed, 

thoughts? 

Would be great to get this sorted by tomorrow.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 21 Mar 2022 18:29:24 +1100
> Subject: [PATCH] fxup for "net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode"
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 3 +--
>  include/linux/mlx5/qp.h                          | 5 +++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index f35b62ce4c07..8f321a6c0809 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -435,8 +435,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
>  		u8 num_pkts = 1 + num_frags;
>  		int i;
>  
> -		memset(&cseg->signature, 0, sizeof(*cseg) -
> -		       sizeof(cseg->opmod_idx_opcode) - sizeof(cseg->qpn_ds));
> +		memset(&cseg->trailer, 0, sizeof(cseg->trailer));
>  		memset(eseg, 0, sizeof(*eseg) - sizeof(eseg->trailer));
>  
>  		eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
> diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
> index 61e48d459b23..8bda3ba5b109 100644
> --- a/include/linux/mlx5/qp.h
> +++ b/include/linux/mlx5/qp.h
> @@ -202,6 +202,9 @@ struct mlx5_wqe_fmr_seg {
>  struct mlx5_wqe_ctrl_seg {
>  	__be32			opmod_idx_opcode;
>  	__be32			qpn_ds;
> +
> +	struct_group(trailer,
> +
>  	u8			signature;
>  	u8			rsvd[2];
>  	u8			fm_ce_se;
> @@ -211,6 +214,8 @@ struct mlx5_wqe_ctrl_seg {
>  		__be32		umr_mkey;
>  		__be32		tis_tir_num;
>  	};
> +
> +	); /* end of trailer group */
>  };
>  
>  #define MLX5_WQE_CTRL_DS_MASK 0x3f

