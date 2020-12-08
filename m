Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3E52D23BD
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgLHGoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbgLHGoa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 01:44:30 -0500
Date:   Tue, 8 Dec 2020 08:43:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607409829;
        bh=JInkcczCl5fMUHtopA+CGViwiiQqF1W2Uzi5FVY1DXE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=g3Q4PgbMsAMrTdkCrWNYp8rPedIbJgzy++A/va75wxVW1dFlPaxjdW4REkmN4Qud8
         VzmyLVPdibo81+UzaGV1WTeSaJaophD3E+iO5shZHhOwJ09k4ONjZQQU9P8Kxo0CsT
         zOF8FyHmbBDZ3WRMHump/qx1PCLgnyDJp5Tj+lpEc9lJeE2irJzQpUtTAF/1SGFNb1
         +B57h7/HeHG7iUpM8f50T4CrF57j2UybAPX+VRWgig0pTif8KDG5YNnHfotdfuaBh1
         9MjPjvO1b7qd2vZcuLhsDwXp+VKF07tCiqrXGqpvsxo/EwJaKIlTW9bwky6ffQBmr1
         HvUCkZUUkl3ag==
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC PATCH net-next 01/13] RDMA/mlx4: remove bogus dev_base_lock
 usage
Message-ID: <20201208064342.GC4430@unreal>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
 <20201206235919.393158-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206235919.393158-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 01:59:07AM +0200, Vladimir Oltean wrote:
> The dev_base_lock does not protect dev->dev_addr, so it serves no
> purpose here.
>
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 3 ---
>  1 file changed, 3 deletions(-)

Agree with the description, most likely the authors wanted to ensure
that "dev" doesn't disappear, but it is not correct way to do and not
needed in that flow.

Thanks for the patch,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
