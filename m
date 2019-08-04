Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7004280B02
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 14:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfHDMsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 08:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbfHDMsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 08:48:25 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D262070D;
        Sun,  4 Aug 2019 12:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564922903;
        bh=yj87rjALkZsmUet+qLbuZVt6WubONCVEKfTPdchgLhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NFs8EhQd7fZZqMybyc5Pl8gMTlCvdXe+005j54lsecueU3CN88bIy16/ibaZpxiZJ
         BK5KPJtVBJ6evdaHN3J2zf/ZPTFkGNTf3SUbVBvM3393pYKZhbiF5M0803FUzFgD1E
         0anLtYtkw58/wPznPh52dqiVppTA55zTZEWH1eUQ=
Date:   Sun, 4 Aug 2019 15:48:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Use refcount_t for refcount
Message-ID: <20190804124820.GH4832@mtr-leonro.mtl.com>
References: <20190802121035.1315-1-hslester96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802121035.1315-1-hslester96@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 08:10:35PM +0800, Chuhong Yuan wrote:
> Reference counters are preferred to use refcount_t instead of
> atomic_t.
> This is because the implementation of refcount_t can prevent
> overflows and detect possible use-after-free.
>
> First convert the refcount field to refcount_t in mlx5/driver.h.
> Then convert the uses to refcount_() APIs.

You can't do it, because you need to ensure that driver compiles and
works between patches. By converting driver.h alone to refcount_t, you
simply broke mlx5 driver.

NAK, to be clear.

And please don't sent series of patches as standalone patches.

Thanks,
