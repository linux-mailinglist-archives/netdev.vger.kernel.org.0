Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E241B4CAF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 20:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgDVScT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 14:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgDVScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 14:32:18 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F27C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 11:32:17 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id q31so1400255qvf.11
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 11:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V+OphPo7mH5Eg5Naogxzvva7HjJF1L3rfjswatX+P68=;
        b=OXfdv2NYssgGmtvjHo7w+o1GAhnLEc8Gc41ZYhNYqk4uwt7iZCGA7KafCPevi/rQwi
         DvxSZmaK/5gSH1jUR68gkccKrG6BmH9njUMESShNngphbAR7Z2rBToMn78I/S46wR6ch
         NzAXjNKnthpr4oN9lJpgSOnAK75qLrd9x3bfuyB5KXJP0v2dhI6sqZrGEaHEFwtNKfhn
         PkhXqjOiAHgGXx+RnV3Hqmy1Znb+h2CMpLW+5NaBKtjL2PVJPKIoix8eYKKgdbJ5pKud
         kLyaH4PiBGCHDUn/EyFSrFQexkU/4Xk7fiNQq4As1Bt3SDFYS2MYzYASXnVA2h/qlRqF
         kYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V+OphPo7mH5Eg5Naogxzvva7HjJF1L3rfjswatX+P68=;
        b=fXP3MSKuZBBlsjYwbW5UWquc9PDJx4mHIKnsK3Y4hPPwHHmZMBNFi0QrjOhnNlqbCy
         LpD6032h2E6NGzuLSJKkm6JicW9NGhdQmaQ4d4MuXdR35MTjx/xNoTeA+mxPJCf/HA+z
         yS4ZlRHKcP5EHjUHSfPwFzOK1KCdGU+d+jMhPeHWWeLvP7A63NRFBvEKwqGHw3mTToo1
         V7T8DwTC74rrE5EPhK6da0gM0WBxHqQjf94PUXt+Wpa+uQ3ZdRbsPkwGZXxg6xVhEWM4
         ZtLlcc5gFpxp/h2DRB57sFJ/DDfXsSLm9jVuvZbSDO8xrxtocm5bBulFM5eQGNvHL/9Q
         LO/g==
X-Gm-Message-State: AGi0PuZ+3l734rQZscY9yqCJK/JhBmIjIJBszoelR4KYVjzFR0I50/hy
        U2D4ppRPDPCWRJ1NLjJ3JyBNtg==
X-Google-Smtp-Source: APiQypJb6iev3TOHARMeO1MFv4mG/4SPS8Zn2fzYlmp+qUxUJPLl+wdCU6tEWvR0JnRfGPVmHQR4Bw==
X-Received: by 2002:a0c:ed26:: with SMTP id u6mr273531qvq.220.1587580336669;
        Wed, 22 Apr 2020 11:32:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id o13sm4513672qke.77.2020.04.22.11.32.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 11:32:15 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jRKAQ-0001gW-OO; Wed, 22 Apr 2020 15:32:14 -0300
Date:   Wed, 22 Apr 2020 15:32:14 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 02/24] net/mlx5: Update cq.c to new cmd
 interface
Message-ID: <20200422183214.GW26002@ziepe.ca>
References: <20200420114136.264924-1-leon@kernel.org>
 <20200420114136.264924-3-leon@kernel.org>
 <20200422164948.GB492196@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422164948.GB492196@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 07:49:48PM +0300, Leon Romanovsky wrote:
> >  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
> >  			u32 *in, int inlen)
> >  {
> > -	u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {0};
> > -
> >  	MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
> >  	MLX5_SET(modify_cq_in, in, uid, cq->uid);
> > -	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
> > +	return mlx5_cmd_exec_in(dev, modify_cq, in);
> >  }
> >  EXPORT_SYMBOL(mlx5_core_modify_cq);
> >
> 
> This hunk needs this fixup:
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> index 1a6f1f14da97..8379b24cb838 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> @@ -187,9 +187,11 @@ EXPORT_SYMBOL(mlx5_core_query_cq);
>  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
>                         u32 *in, int inlen)
>  {
> +       u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {};
> +
>         MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
>         MLX5_SET(modify_cq_in, in, uid, cq->uid);
> -       return mlx5_cmd_exec_in(dev, modify_cq, in);
> +       return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
>  }
>  EXPORT_SYMBOL(mlx5_core_modify_cq);

Why doesn't this one work with the helper?

Jason
