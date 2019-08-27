Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3D99EF6E
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfH0Pvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 11:51:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37869 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfH0Pvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 11:51:42 -0400
Received: by mail-qt1-f193.google.com with SMTP id y26so21803768qto.4
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 08:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zyOqqZfVXaCdrCD6D2ADnklikXRFi8MLAZgK4YpK3lU=;
        b=K/bbIrpgxbhTbNLLQ8Mbof1XU5jsCZUBILQwYFjwIw1Jm+QwosYS+qs1o/fHLIT86V
         7ng6HsAiMP5hq7rEGv6g0xDYI/afW50y2v0IjNTBAO9tk12JAGWnsBX9AfqiurTEDXVt
         hModd6XprgX65JEkeKN9FhmlxSIql7qa+Y3ekPNXdto6jIkuLfFcH/biv7KJg2zj/Sr+
         SP1AL7QvQPkZZUxUqcCbhI9Z+F+u/BnTWMrWlx/XZFDbJ0s4I/bDbp3BC0K3gbxL3JRu
         RLy8/4rEr01lrJM5sfQHSf6mQ+PiNq8JayhMo1Alt1yMixuHE2WjUz0nxxQcea5ulJHT
         klKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zyOqqZfVXaCdrCD6D2ADnklikXRFi8MLAZgK4YpK3lU=;
        b=F31DVA52KLu4k/u8lZtJuT1xt6Vo1LqkbfazTISygYSJwNTmVHJrld2Mmf5MTqf0KN
         k+j9juyE7MRcquxBGxl3Wy/EaKyjLiwovDGpsYBIGm7VIalkmu3Wjk9uLszjBAHfRGiL
         WQQ/ARC+5p1cLjV60W3WFtRlk3BWByVK0JfYQbnNQBB6vY9LIYP1o1dFDNsIMDsbJJr8
         CgDhrfpF+HG9tAlfGHOrTUAvfmXzFa0eRpNIFInPShry3ufQa8KMpdE4Ub9N7jmuQ+Rw
         Ih2h/Jdm0HweHhfmwMejLClxCVxlE5dAg6i9A3tGOkZrBXnCK1G7j9byu2K2CWndzoqh
         PR2g==
X-Gm-Message-State: APjAAAWb6afpG6URRM6RU8H/T+6s/rpz0cMTp2UM1YlTCcIXEv+R5wWX
        UZ5vm0qpmCHY8+Rr08xpgw9G1g==
X-Google-Smtp-Source: APXvYqxC5++4GwpcvpfYV8bMDOpFXrgbxlYFkTLHLhOEWerw6Sv4yfHLnjFTy4ys4vDT4qhURjcK+Q==
X-Received: by 2002:aed:27d1:: with SMTP id m17mr23681669qtg.111.1566921101686;
        Tue, 27 Aug 2019 08:51:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-216-168.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.216.168])
        by smtp.gmail.com with ESMTPSA id w24sm9840661qtb.35.2019.08.27.08.51.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Aug 2019 08:51:41 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1i2dky-0003wu-NZ; Tue, 27 Aug 2019 12:51:40 -0300
Date:   Tue, 27 Aug 2019 12:51:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 0/3] ODP support for mlx5 DC QPs
Message-ID: <20190827155140.GA15153@ziepe.ca>
References: <20190819120815.21225-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819120815.21225-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 03:08:12PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog
>  v3:
>  * Rewrote patches to expose through DEVX without need to change mlx5-abi.h at all.
>  v2: https://lore.kernel.org/linux-rdma/20190806074807.9111-1-leon@kernel.org
>  * Fixed reserved_* field wrong name (Saeed M.)
>  * Split first patch to two patches, one for mlx5-next and one for  rdma-next. (Saeed M.)
>  v1: https://lore.kernel.org/linux-rdma/20190804100048.32671-1-leon@kernel.org
>  * Fixed alignment to u64 in mlx5-abi.h (Gal P.)
>  v0: https://lore.kernel.org/linux-rdma/20190801122139.25224-1-leon@kernel.org
> 
> >From Michael,
> 
> The series adds support for on-demand paging for DC transport.
> 
> As DC is mlx-only transport, the capabilities are exposed
> to the user using DEVX objects and later on through mlx5dv_query_device.
> 
> Thanks
> 
> Michael Guralnik (3):
>   net/mlx5: Set ODP capabilities for DC transport to max
>   IB/mlx5: Remove check of FW capabilities in ODP page fault handling
>   IB/mlx5: Add page fault handler for DC initiator WQE

This seems fine, can you put the commit on the shared branch?

Thanks,
Jason
