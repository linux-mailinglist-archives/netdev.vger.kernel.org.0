Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E985D398426
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhFBIb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhFBIbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:31:53 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD9C061574;
        Wed,  2 Jun 2021 01:30:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v12so720157plo.10;
        Wed, 02 Jun 2021 01:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wf8QgPbc3KHLrXcx5xgLcKl+CLabL/UGbZXv0BcNs0U=;
        b=Sx/iTsXozmbRZnGN9fq3bWKxG01X391EoJBxsaJx6W/MRow9PV6ZdKNdS2H/wt7ef0
         M8AXoVDNR8cR15Cf/wyjZ1OrH1vCPpckNC7sZdY/UjA/6n47n8/zN2nfGPCAV3KFrtVY
         8vwX1KFPLDm8kCxMhpo7/NiQwdwcFkbWfJGaB+3l/ED3YMZB0yVO4K0WY2wskG+u9pEn
         5Eouy1/ZtYxPYodzF9Y9mqLi7FFZWpLqTy3NUtVQ/3wcA6XqxxzskpsR///y/1Wi03RI
         XIuPPTUsXyZDa18vmGuwBhoppqi/3ukZi9Xzi7XYNwo5l9ohrbfk5SzJycfg/zMguC0f
         DbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wf8QgPbc3KHLrXcx5xgLcKl+CLabL/UGbZXv0BcNs0U=;
        b=LhDxppqVENChFFuPL/4Xt+yrWxKyV30lvbJm7SLty1vYgp70jMbo6Aqfjg4ncEe6Qs
         xQSuqy3gPvh2/0zgUeqk9jCzHETKPL1M2oAmh5/adBw9kOnd9Ij4F/jRpgVmjWSQS/UG
         vkGLvGKkoz318boCLWTg+kazuxAGCEXZ400mxagOB8hX2avvwzLb2Rorsj5kOYKPkTaZ
         wIjOpLLyvl4r/d2Ss1BbtkQT3eiXUclDV9Jr2gxuLG1QF8MJVsSJq8DHYN3duyMgtiEL
         JV8zc2Iv8PZ47JfgrP22xsWu2AnopzLJRNBc5lJaP2pw25iDpMnR5ye1dadLoEW3X7W5
         Guyg==
X-Gm-Message-State: AOAM531alHd4399Dyle4wftSBPeZg/1/l6UqvggLCEua+SiKq7QhVwSA
        l9Xee2z2pcmVMyLY5TcsXwjieK3Vi81SIj6aQTg=
X-Google-Smtp-Source: ABdhPJztetfw4tnLZiYmY+RND/gJ1qyWU1FGffINOU45V4N9UjX3b/znrBnC7z55TyUjSUNbLWc7FjL4QU+P95aE/EU=
X-Received: by 2002:a17:90a:9103:: with SMTP id k3mr4371526pjo.117.1622622609981;
 Wed, 02 Jun 2021 01:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210602031001.18656-1-wanghai38@huawei.com>
In-Reply-To: <20210602031001.18656-1-wanghai38@huawei.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 2 Jun 2021 10:29:58 +0200
Message-ID: <CAJ8uoz2sT9iyqjWcsUDQZqZCVoCfpqgM7TseOTqeCzOuChAwww@mail.gmail.com>
Subject: Re: [PATCH net-next] xsk: Return -EINVAL instead of -EBUSY after
 xsk_get_pool_from_qid() fails
To:     Wang Hai <wanghai38@huawei.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 6:02 AM Wang Hai <wanghai38@huawei.com> wrote:
>
> xsk_get_pool_from_qid() fails not because the device's queues are busy,
> but because the queue_id exceeds the current number of queues.
> So when it fails, it is better to return -EINVAL instead of -EBUSY.
>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/xdp/xsk_buff_pool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 8de01aaac4a0..30ece117117a 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -135,7 +135,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>                 return -EINVAL;
>
>         if (xsk_get_pool_from_qid(netdev, queue_id))
> -               return -EBUSY;
> +               return -EINVAL;

I guess your intent here is to return -EINVAL only when the queue_id
is larger than the number of active queues. But this patch also
changes the return code when the queue id is already in use and in
that case we should continue to return -EBUSY. As this function is
used by a number of drivers, the easiest way to accomplish this is to
introduce a test for queue_id out of bounds before this if-statement
and return -EINVAL there.

>         pool->netdev = netdev;
>         pool->queue_id = queue_id;
> --
> 2.17.1
>
