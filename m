Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB30F4CDAD8
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbiCDRfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241291AbiCDRe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:34:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875821D0D7F
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3882BB82A7D
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 17:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EB6C340E9;
        Fri,  4 Mar 2022 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646415235;
        bh=9CM6lOB2aBHDVx0tnc1cbmZr65bzFE0jK5WH7VGsh90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BPWs9DIf5Qp5VAXdnBa8/B1OZB9EbPuJBdZ7IP5c1+xzURlIohXTcEPUuL1ktVLTK
         Ix7T18CQMm7aqBoGHJyCM72odeOf1ILF5UcIIsvk6nbjdbPzxO2J8DQQwdJ+e54g21
         7oBV9Bpcs1vzgGNsTZZPum5aOBgmW5uKTFMEv47xwDqnWo3VwS44AQA055qG8teJIM
         fZ9m2f2NIvJ3yj3EAeg7cJCkxPlHB8fifQ9mRNNKfz6RC/5yrcnOxr/TcbqgCVxYSG
         EyujFUELuECrGTLkqlvEJ18mkH2n2hkHSId9FV3VqpvGQW586idYKlV44CAr96y+mc
         /4KVMZe90TF+g==
Date:   Fri, 4 Mar 2022 19:33:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shangyan Zhou <sy.zhou@hotmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3] rdma: Fix res_print_uint() and add res_print_u64()
Message-ID: <YiJNfx85POmhzGQV@unreal>
References: <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
 <OSAPR01MB7567AF3E28F7D2D72FFA876BE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB7567AF3E28F7D2D72FFA876BE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 08:46:37PM +0800, Shangyan Zhou wrote:
> Use the corresponding function and fmt string to print unsigned int32
> and int64.
> 
> Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
> ---
>  rdma/res-cq.c |  2 +-
>  rdma/res-mr.c |  2 +-
>  rdma/res-pd.c |  2 +-
>  rdma/res.c    | 15 ++++++++++++---
>  rdma/res.h    |  4 +++-
>  rdma/stat.c   |  4 ++--
>  6 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/rdma/res-cq.c b/rdma/res-cq.c
> index 9e7c4f51..475179c8 100644
> --- a/rdma/res-cq.c
> +++ b/rdma/res-cq.c
> @@ -112,7 +112,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
>  	print_dev(rd, idx, name);
>  	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
>  	res_print_uint(rd, "cqe", cqe, nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
> -	res_print_uint(rd, "users", users,
> +	res_print_u64(rd, "users", users,
>  		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
>  	print_poll_ctx(rd, poll_ctx, nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
>  	print_cq_dim_setting(rd, nla_line[RDMA_NLDEV_ATTR_DEV_DIM]);
> diff --git a/rdma/res-mr.c b/rdma/res-mr.c
> index 1bf73f3a..a5b1ec5d 100644
> --- a/rdma/res-mr.c
> +++ b/rdma/res-mr.c
> @@ -77,7 +77,7 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
>  	print_key(rd, "rkey", rkey, nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
>  	print_key(rd, "lkey", lkey, nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
>  	print_key(rd, "iova", iova, nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
> -	res_print_uint(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
> +	res_print_u64(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
>  	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
>  	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
>  	print_comm(rd, comm, nla_line);
> diff --git a/rdma/res-pd.c b/rdma/res-pd.c
> index df538010..6fec787c 100644
> --- a/rdma/res-pd.c
> +++ b/rdma/res-pd.c
> @@ -65,7 +65,7 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
>  	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
>  	print_key(rd, "local_dma_lkey", local_dma_lkey,
>  		  nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
> -	res_print_uint(rd, "users", users,
> +	res_print_u64(rd, "users", users,
>  		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
>  	print_key(rd, "unsafe_global_rkey", unsafe_global_rkey,
>  		  nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
> diff --git a/rdma/res.c b/rdma/res.c
> index 21fef9bd..62599095 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -51,7 +51,7 @@ static int res_print_summary(struct rd *rd, struct nlattr **tb)
>  
>  		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
>  		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
> -		res_print_uint(
> +		res_print_u64(
>  			rd, name, curr,
>  			nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
>  	}
> @@ -208,13 +208,22 @@ void print_key(struct rd *rd, const char *name, uint64_t val,
>  	print_color_hex(PRINT_ANY, COLOR_NONE, name, " 0x%" PRIx64 " ", val);
>  }
>  
> -void res_print_uint(struct rd *rd, const char *name, uint64_t val,
> +void res_print_uint(struct rd *rd, const char *name, uint32_t val,
>  		    struct nlattr *nlattr)

It is res_print_u32() now and not res_print_uint().
But it is nitpicking.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
