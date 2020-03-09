Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF8017EC37
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgCIWkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:40:19 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40688 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgCIWkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:40:18 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so10958416qka.7
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 15:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qmG0HdA9RQDeW3xbv0dzsyDRiAImEmqalHR9xDHSVbg=;
        b=oya7aVnqZVvr9HAQDQIQ/RxOMdQaVp9D/sc9EUqPRDFMUTYawDZjSIZTsWm7ah44V3
         zT5sUh87X2Ml3FGehmihanCvBjU8YVczufn/8UWhY2ELYuei+wvFG9h31pYWrss4fgnS
         OImopwWazcHiMDPW+2AjaZToLx8vbVwJyGQeGePZWVxcubal8pvs5f0XAo62Ef35iHox
         wYnabLQdN7x3jZCLvYnED6/X1fffP2jhisLmQ9+dqABRhpzJtXyfamjXPTmP7FTXq3FT
         pTrvWD4l0BqAkzLp9W9Eq1qqiCDT1AqTEiInupBICLP+bfOLLO6w3V6LyctcThvDSNxi
         lUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qmG0HdA9RQDeW3xbv0dzsyDRiAImEmqalHR9xDHSVbg=;
        b=O2oUPaPOsEFejBfLtVVEh0ztwZrtK6a9+PVCx3+4tQrRGDet47QKrAAbByNqpiC/fj
         jNSoCxxwRYINFeUXSQ1aiR8gJHDzWG0J7xrOn3v4W9VL7NPACLKYq9Lzf98a2Iu2na3c
         x5rNBP+eKUjwvOkGCwiIM7ky4iAKFWvzpfXHBKS/MIqgr3MZsFsAx57gspN+YMDgNhcu
         0rqnwstTPyFrnniCg4nQs90hCT97MoGkrDEPS6A6T+dZpdOHUNpo/pO5eBMc2i4KTr/U
         83laORs06wouid3kMZfdPRE2KMDQ3acWItl0/i8JbUmRNteHhuuKPmNqh5yWJZFSeSCR
         R17A==
X-Gm-Message-State: ANhLgQ0zITRI4Y0AISFYzNA0WUOmRDg6UgRl3f5bBE7i3LdpxIevmM5V
        rP0QV/6k1Zl/zXvNNDT5JdM=
X-Google-Smtp-Source: ADFU+vvod7/pnHz/hqc62ibDt2yQQ2d0BWHPbNIk6bFR3f8eCsdsJL8P/+0KywEYX5kqfxb0Uz5fIw==
X-Received: by 2002:a37:98c7:: with SMTP id a190mr17345089qke.498.1583793616958;
        Mon, 09 Mar 2020 15:40:16 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.158])
        by smtp.gmail.com with ESMTPSA id t1sm21026673qtr.94.2020.03.09.15.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:40:15 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 20CCFC314F; Mon,  9 Mar 2020 19:40:13 -0300 (-03)
Date:   Mon, 9 Mar 2020 19:40:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next ct-offload v2 06/13] net/mlx5: E-Switch,
 Introduce global tables
Message-ID: <20200309224013.GK2546@localhost.localdomain>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-7-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583676662-15180-7-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 08, 2020 at 04:10:55PM +0200, Paul Blakey wrote:
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -149,7 +149,12 @@ struct mlx5_flow_handle *
>  	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
>  		struct mlx5_flow_table *ft;
>  
> -		if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
> +		if (attr->dest_ft) {
> +			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
> +			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
> +			dest[i].ft = attr->dest_ft;
> +			i++;
> +		} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
>  			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
>  			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
>  			dest[i].ft = mlx5_esw_chains_get_tc_end_ft(esw);
> @@ -202,8 +207,11 @@ struct mlx5_flow_handle *
>  	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
>  		flow_act.modify_hdr = attr->modify_hdr;
>  
> -	fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
> -					!!split);
> +	if (attr->chain || attr->prio)
> +		fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
> +						!!split);
> +	else
> +		fdb = attr->fdb;

I'm not sure how these/mlx5 patches are supposed to propagate to
net-next, but AFAICT here it conflicts with 
96e326878fa5 ("net/mlx5e: Eswitch, Use per vport tables for mirroring")

>  	if (IS_ERR(fdb)) {
>  		rule = ERR_CAST(fdb);
>  		goto err_esw_get;
