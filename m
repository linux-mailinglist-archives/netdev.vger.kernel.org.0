Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE131CC955
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 10:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgEJIRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 04:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgEJIRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 04:17:19 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E39C208DB;
        Sun, 10 May 2020 08:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589098639;
        bh=r7BRAdnn3wClLyHBb6b5Txno2vhOO4/e0T6yw8USNQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cnjWFLSb1eRJUlRpoiEfdxWjih/sRUDZ2XfJ4StqZXBXi1Kx32LONVDJRronbftjI
         CvuEKXr3R5MLpgWcQNRpjOkBUNySLpmw5wHTQJkgMFEuZyK2ShwCrR6us01Bcrd72c
         oE71LaMeZal9l/Su5PQb/3keB3jnB0HQxuYClfJc=
Date:   Sun, 10 May 2020 11:17:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 1/4] {IB/net}/mlx5: Simplify don't trap code
Message-ID: <20200510081714.GA199306@unreal>
References: <20200504053012.270689-1-leon@kernel.org>
 <20200504053012.270689-2-leon@kernel.org>
 <20200508195838.GA9696@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508195838.GA9696@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 04:58:38PM -0300, Jason Gunthorpe wrote:
> On Mon, May 04, 2020 at 08:30:09AM +0300, Leon Romanovsky wrote:
> > +	flow_act->action &=
> > +		~MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
> > +	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> > +	handle = _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
> > +	if (IS_ERR_OR_NULL(handle))
> > +		goto unlock;
>
> I never like seeing IS_ERR_OR_NULL()..
>
> In this case I see callers of mlx5_add_flow_rules() that crash if it
> returns NULL, so this can't be right.
>
> Also, I don't see an obvious place where _mlx5_add_flow_rules()
> returns NULL, does it?

You are right, I'll replace this IS_ERR_OR_NULL() to be IS_ERR() once
will take it to mlx5-next.

Is it ok?

Thanks

>
> Jason
