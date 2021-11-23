Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C8945A9E9
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbhKWRZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbhKWRZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:25:21 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD0DC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 09:22:12 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id 8so20553118qtx.5
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 09:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TNdEWF5Of05cbhpzUIl8KrkzEbU6BhRMutrDV+qEhac=;
        b=CrK0Kbrr5wAJ/uDdCi+GTV3sP5wpcV9mZ8iyQnCvtd7dTLpj+G+yvSlKKxkEHiRBRd
         KmNzNEVYJioB78UpQdJt7MWrrbsCszujy0zg8jVjqujIJiJoaqx6zWP5CkPnm410+60Y
         m+Iar/rxSXMz4igYHrpg3WrSvLtHPiRw9FGFSrFjGP4YhXunxt2QLDBAHe54zWDe5YMT
         MpgnOKDF/GRv0Vpvz8pQXJAMTIG73ZwtgzbGOElVV7qT/ZvCX+VeQQWsB56+WunvfOXI
         Vp2LWMe3OIELuwYPgpWJ++ve07RgwV8Gq+IfYpmUvp5+v+EyVSPm0pNRwlOIC+8Yqbw4
         QIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TNdEWF5Of05cbhpzUIl8KrkzEbU6BhRMutrDV+qEhac=;
        b=JM1qGwuViEw3V3Cc/q26KT7GIIkpDeKcYFqrlWRexdWfOjCV22K1Txvd8/RPlhPs6H
         NeOl88PWMBrLRX0saRZtxppiGK85PfFSe+7DZzWDmRT4j5Da8BySL6qTSt2Ke0jSmSTZ
         bvoKZXEEhkSVkbDMeOGxCx3nZ88VTx4PfUgFnImc6yi2/3Q8AOj/JBmpo1ggOjI+tosa
         mTZNHiatPYttpR2MAyQJQEatC7uN4Q8fVXbFr4fr0ZSkss7USxzcvj5ycnf9qTVMm3RA
         9eSnR/0jm2bhIRUfvg3zSWb+GDaRszvekNYsR6I6riT055/miqLE/ktKGYYmpuivxjRv
         jGZA==
X-Gm-Message-State: AOAM530Rd3buUaLjUqzB/uJnM/Kqce7rSpEDW4MlJHmLt2UzCxrDB4eh
        eyiVq0t05IOwfyR5OZN/bz6DQg==
X-Google-Smtp-Source: ABdhPJxjL2u3bFniinDwOfD9luh2VOn/IgFUgJ4aDPUcpEVHoiI3b814dTtnVxbvf/W1y90TjY4kwA==
X-Received: by 2002:ac8:7c4b:: with SMTP id o11mr8100097qtv.358.1637688132064;
        Tue, 23 Nov 2021 09:22:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id x190sm6284902qkb.115.2021.11.23.09.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 09:22:11 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpZUg-000DpU-Nz; Tue, 23 Nov 2021 13:22:10 -0400
Date:   Tue, 23 Nov 2021 13:22:10 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com
Subject: Re: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-11-22
Message-ID: <20211123172210.GE5112@ziepe.ca>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
 <163767001205.10565.2852083634552212032.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163767001205.10565.2852083634552212032.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:20:12PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by Tony Nguyen <anthony.l.nguyen@intel.com>:
> 
> On Mon, 22 Nov 2021 13:11:16 -0800 you wrote:
> > Shiraz Saleem says:
> > 
> > Currently E800 devices come up as RoCEv2 devices by default.
> > 
> > This series add supports for users to configure iWARP or RoCEv2 functionality
> > per PCI function. devlink parameters is used to realize this and is keyed
> > off similar work in [1].
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net-next,1/3] devlink: Add 'enable_iwarp' generic device param
>     https://git.kernel.org/netdev/net-next/c/325e0d0aa683
>   - [net-next,2/3] net/ice: Add support for enable_iwarp and enable_roce devlink param
>     https://git.kernel.org/netdev/net-next/c/e523af4ee560
>   - [net-next,3/3] RDMA/irdma: Set protocol based on PF rdma_mode flag
>     https://git.kernel.org/netdev/net-next/c/774a90c1e1a3

Isn't 15 hours of review time a bit aggressive for patches that
introduce new devlink uAPI?!?!

Jason
