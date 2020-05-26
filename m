Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADBD1E2E32
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 21:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390044AbgEZTEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 15:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391353AbgEZTEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 15:04:22 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C508C03E96E
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 12:04:22 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k22so2302720qtm.6
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 12:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e8t8guVZHFpAEAEfeBH9ghZZNDxE1CgHbKBkfQhO7K8=;
        b=LHb/8h4cZ8wLtJv56fAt0vw8vzxiEaZ6kmx9sruNdx2LNAzZoB+MztiLkJvtygxw9j
         iIxhabS9YcYVIy3bmx3T6YW9m238ZsOyh2Rm5CkhET9wnlsKLhXlpZ9R2WMXFbXWFGUJ
         p32gfaCaMoVLdQ3e3dMnPoR+LOXAQBRnq2p3EojoLg2h2BFCp95frpbCclrgJjcCECQp
         Ag35FbKojbsowUUQZUq8qGQOE5HW05/c1a4QbBeJY+b+cvqi0m3sbm+VmqHdBxbHW978
         QJGzGlcSpJvLcXLOX9Ou7/5jrG0tfwQvD2gZ0J7Jh5iK7SDSZrErqLdiesTitoqfTATQ
         GtqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e8t8guVZHFpAEAEfeBH9ghZZNDxE1CgHbKBkfQhO7K8=;
        b=BFahBoU3FRf173HDh42SB6st/76ZlRt5OUuP9vuGdoF7ENcEGlYuSxUAurohqhr6rU
         fOmPGqsXnFPmP3WwJsNYa+cjc00IPeoqGrxsWawHxwSaqKOdigPvtceZWh8HthQ9zvmd
         cYIic/k9kgH8oarMaMIPyhKgR+5SQlsoZKoM9+dXFAfmZPxN7d4zRrTiu9sK0x/gYOIu
         hvG7Sx1EuvIrXeqisyvfbtHx9RCjvzP07EeNFSI7i6aY/3cXVp2OlRXf8e8oG9Az88kl
         ZB5Sp1dpjbN4hnNahkET/Nos+mAEY7dCQswUyZT2raWu2IsWVYJpKhc0fWYdT7Yi7NGI
         RodQ==
X-Gm-Message-State: AOAM532EPiwhsP3P5QT26DCQ4AP9Hv32FczpAHukGgmDx8FQ477l+4cd
        Z3rT4CAQibrvhwnMu3kZY2mVcw==
X-Google-Smtp-Source: ABdhPJymDvOfHg7eoUvIydpXUVyE1y9R7HrCnjGAkfFNHBGLmHfhqZai95OSEGlT6LifZ2cZqjb1Dg==
X-Received: by 2002:ac8:7313:: with SMTP id x19mr246217qto.383.1590519861066;
        Tue, 26 May 2020 12:04:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id h3sm395711qkl.28.2020.05.26.12.04.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 May 2020 12:04:20 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdes8-0004pY-0f; Tue, 26 May 2020 16:04:20 -0300
Date:   Tue, 26 May 2020 16:04:20 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next v3 0/8] Driver part of the ECE
Message-ID: <20200526190419.GA18519@ziepe.ca>
References: <20200526115440.205922-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526115440.205922-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 02:54:32PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v3:
>  * Squashed patch "RDMA/mlx5: Advertise ECE support" into
>  "RDMA/mlx5: Set ECE options during modify QP".
> v2:
> https://lore.kernel.org/linux-rdma/20200525174401.71152-1-leon@kernel.org
>  * Rebased on latest wip/jgg-rdma-next branch, commit a94dae867c56
>  * Fixed wrong setting of pm_state field in mlx5 conversion patch
>  * Removed DC support for now
> v1:
> https://lore.kernel.org/linux-rdma/20200523132243.817936-1-leon@kernel.org
>  * Fixed compatibility issue of "old" kernel vs. "new" rdma-core. This
>    is handled in extra patch.
>  * Improved comments and commit messages after feedback from Yishai.
>  * Added Mark Z. ROB tags
> v0:
> https://lore.kernel.org/linux-rdma/20200520082919.440939-1-leon@kernel.org
> 
> 
> Hi,
> 
> This is driver part of the RDMA-CM ECE series [1].
> According to the IBTA, ECE data is completely vendor specific, so this
> series extends mlx5_ib create_qp and modify_qp structs with extra field
> to pass ECE options to/from the application.
> 
> Thanks
> 
> [1]
> https://lore.kernel.org/linux-rdma/20200413141538.935574-1-leon@kernel.org
> 
> Leon Romanovsky (8):
>   net/mlx5: Add ability to read and write ECE options
>   RDMA/mlx5: Get ECE options from FW during create QP
>   RDMA/mlx5: Set ECE options during QP create
>   RDMA/mlx5: Use direct modify QP implementation
>   RDMA/mlx5: Remove manually crafted QP context the query call
>   RDMA/mlx5: Convert modify QP to use MLX5_SET macros
>   RDMA/mlx5: Set ECE options during modify QP
>   RDMA/mlx5: Return ECE data after modify QP

It seems fine, can you add the one patch to the shared branch please

Thanks,
Jason
