Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A1B2D3B62
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgLIGVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgLIGVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 01:21:45 -0500
Date:   Wed, 9 Dec 2020 08:21:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607494864;
        bh=/JNDa/e+VUwp3PfZgTT/W850EJGQatfgwghGNsJk2LQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ji0d8dHw/kMB7xyQ82EN1q6oQoQAasEjgmwq5I6KApROX2vY9gOZlP+if/FvCyTWF
         rXbBXFTa6zEVoPfMXv8WcD6LL4vHR3nfo5iml9n6N6HqbgTvDMMJfOHKXJ1bFg9AGv
         LK26PAN/WcWIr8R+X8WpIU4ToKbbQdDNWnsoSjP/b8TXtP948naZJGjt4qEcSYML+j
         PNmInj2LwZP8tbhzmEtQm71r0DW0TCZqUgD+z5o2ns8MNgsCWGB79atKwHj8yAMspE
         UtfOTTe7GATdFgRn21B0M1J60Neq7QCUg3H3mk3khw19AnYlZh7VIIaSw94onDNjR/
         wbljBNs3OX4oQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zou Wei <zou_wei@huawei.com>, saeedm@nvidia.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/mlx5_core: remove unused including
 <generated/utsrelease.h>
Message-ID: <20201209062100.GK4430@unreal>
References: <1607343240-39155-1-git-send-email-zou_wei@huawei.com>
 <20201208112226.1bb31229@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201208112226.1bb31229@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 11:22:26AM -0800, Jakub Kicinski wrote:
> On Mon, 7 Dec 2020 20:14:00 +0800 Zou Wei wrote:
> > Remove including <generated/utsrelease.h> that don't need it.
> >
> > Signed-off-by: Zou Wei <zou_wei@huawei.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > index 989c70c..82ecc161 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > @@ -30,7 +30,6 @@
> >   * SOFTWARE.
> >   */
> >
> > -#include <generated/utsrelease.h>
> >  #include <linux/mlx5/fs.h>
> >  #include <net/switchdev.h>
> >  #include <net/pkt_cls.h>

Jakub,

You probably doesn't have latest net-next.

In the commit 17a7612b99e6 ("net/mlx5_core: Clean driver version and
name"), I removed "strlcpy(drvinfo->version, UTS_RELEASE,
sizeof(drvinfo->version));" line.

The patch is ok, but should have Fixes line.
Fixes: 17a7612b99e6 ("net/mlx5_core: Clean driver version and name")

Thanks

>
>
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function ‘mlx5e_rep_get_drvinfo’:
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:66:28: error: ‘UTS_RELEASE’ undeclared (first use in this function); did you mean ‘CSS_RELEASED’?
>    66 |  strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
>       |                            ^~~~~~~~~~~
>       |                            CSS_RELEASED
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:66:28: note: each undeclared identifier is reported only once for each function it appears in
> make[6]: *** [drivers/net/ethernet/mellanox/mlx5/core/en_rep.o] Error 1
> make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core] Error 2
> make[4]: *** [drivers/net/ethernet/mellanox] Error 2
> make[3]: *** [drivers/net/ethernet] Error 2
> make[2]: *** [drivers/net] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [drivers] Error 2
> make: *** [__sub-make] Error 2
