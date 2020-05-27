Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B621E453C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388854AbgE0OIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388615AbgE0OIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 10:08:24 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836B7C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:08:24 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s1so24384554qkf.9
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=etrg2Yr/wr2u2uYYMqGL8Bnr5EbtXJpXUK8GYIXSdck=;
        b=Ft7j3+A/t4Uy4Emd0iicGCYeiGYAKRVkB0ZRHxZVqom2un8ZEDJeWk84lHyJ/Lmkz0
         xS9o+sGI0ZCZX0i/Arm/wOhLXBi7HaBbhPkwW6Xiwi2zc+qr/wkblLDzv5erUp7tE6vT
         gb8TjlddH3qD9fGUf9kYR5dhJ61QNsM+ef2J9JoezGVtaW+3+uXEzvVfwOkrCEntHH1h
         xb6AbfeTtrHF/KNHCQKmmGZ/4cjupYRBAGUojzJWtvDrJI2DTDodef+alHhGzDvoHabh
         CBuVufzpdFW2tXppOGaUBduM2pFbunFMZcu2TklcAG1/zdk8UgKZ1eI0BSgftd4H7LDM
         wgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=etrg2Yr/wr2u2uYYMqGL8Bnr5EbtXJpXUK8GYIXSdck=;
        b=oN1iUnh2wZ1FhlI4RTZt8sfG/Sj1c/1GyuHjAW1wyQ04on+gROVtXHFhOf/syVbEaM
         jfW1ZdqjbG7b+2qEnUZ+jR9qBRzk0MCjK+kP30TybCIzqOGkc4i4KO28bK8r3xQRJQKe
         TgkBEPPjowlwaIkfwa0o+lO8WuE+7E/K0tdHPI6D0PLn/oXrkM0DYRmlAlct6jMG3FZi
         jOKZEW1YCwQZtkNIxVZKVFu4LAiUahf5w5yiK1UGqukqqdipgwPF5VwirdJFjelqGTSo
         qKCYI7fI5OvYxIpF9SJx4X19PWzMjtiDcd+lGq+ZqETYW5slX/M4fTpjDyLdjkJ4jh7h
         secg==
X-Gm-Message-State: AOAM5324l1Dd9bxc5aUm5QhOEfBBaC8rzKkrEkqk2ktNIKu6JGdzHZI+
        AlBFNx67kjE4kMjkyAR/pug=
X-Google-Smtp-Source: ABdhPJygDEbK5sc+RiV4LOj8SGzqbUfPjeO6wGK+z5pySPXWfGEMol6/vvUEv9wrWaGoJCtIuVsZcQ==
X-Received: by 2002:a37:4d87:: with SMTP id a129mr4251140qkb.260.1590588503780;
        Wed, 27 May 2020 07:08:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id h5sm2262053qkk.108.2020.05.27.07.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 07:08:23 -0700 (PDT)
Subject: Re: [PATCH net-next] mlx5: fix xdp data_meta setup in
 mlx5e_fill_xdp_buff
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
 <159058704935.247267.18235681992710936316.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <41538e35-cc81-73b5-a63d-42a7176c1e74@gmail.com>
Date:   Wed, 27 May 2020 08:08:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <159058704935.247267.18235681992710936316.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 7:44 AM, Jesper Dangaard Brouer wrote:
> The helper function xdp_set_data_meta_invalid() must be called after
> setting xdp->data as it depends on it.
> 
> The bug was introduced in 39d6443c8daf ("mlx5, xsk: Migrate to
> new MEM_TYPE_XSK_BUFF_POOL"), and cause the kernel to crash when
> using BPF helper bpf_xdp_adjust_head() on mlx5 driver.
> 
> Fixes: 39d6443c8daf ("mlx5, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
> Reported-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 6b3c82da199c..dbb1c6323967 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1056,8 +1056,8 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
>  				u32 len, struct xdp_buff *xdp)
>  {
>  	xdp->data_hard_start = va;
> -	xdp_set_data_meta_invalid(xdp);
>  	xdp->data = va + headroom;
> +	xdp_set_data_meta_invalid(xdp);
>  	xdp->data_end = xdp->data + len;
>  	xdp->rxq = &rq->xdp_rxq;
>  	xdp->frame_sz = rq->buff.frame0_sz;
> 
> 

good catch. I looked right past that yesterday.

Tested-by: David Ahern <dsahern@gmail.com>
