Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828EC2B09DB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgKLQZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:25:44 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:49867 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728426AbgKLQZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:25:44 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 27D78C1A;
        Thu, 12 Nov 2020 11:25:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 12 Nov 2020 11:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=message-id:subject:from:to:cc:date
        :in-reply-to:references:content-type:mime-version
        :content-transfer-encoding; s=fm1; bh=lTrA/ibKC1bvcuK0sZ5lkhA1wG
        S/djcco4JP4O82Pxs=; b=kmktew7BseoEE+Gjdfz9SDyp4JO5WzG7n72sYr2zLI
        kQqhvct/KXnCIpISBDiLeUjIhczSc62e7oy4VFWKGDiUEx4gipxugpxWBa069ZPk
        Gj523ssN4ob/bq2bIValoycyiqwJj/OtfFu3dx62/TKgN60wlV94NK6sj038Dksd
        00xMkUSqBoTFFToZ8iTjQY92PgTBQeTA9+RmHaEorRJwCa8xGbqMAILZVDJ/nTPz
        h7P0s99mp1WeLXRzgR8W0Xixg0TQDYbfAUhXPcEi2vO+qeuO2chQ4e2WuBE+XlU2
        /fV2QgcocSNrKLBrOlU8PBCOXNZHe5+GYaBWTDslCdyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=lTrA/ibKC1bvcuK0sZ5lkhA1wGS/djcco4JP4O82P
        xs=; b=HYr4Swv87lpvDmsmd4m3UpQ71BRkfH60t2inYBUg8NEBfncbdN4CbQXcA
        LWFhKravfLD62wO8QNeRQgsJ3kPtNDhtxAIPAjQBUeXtPEUZdOol7h/eN6JwzCXv
        miSxbV6Pbhv4115MKc2H4bJfYs+UvvbQQs1Uo8NLkgPaG4zA6cdWvWUCAg1KGhz6
        gZi2gphGtzvTu+VS/Gzb5z3uGPvBqZBymisTP82SbaHJsj3LdysRCBnqKZfwPX00
        32cq9+k4oiTa+LMPYDnxm128xJOX/ibU8O5zsoOZan65WupzVQiWZnyWfwWFVoEz
        4SQqkfnT/O6TUkWlK8MI4LSJew3LA==
X-ME-Sender: <xms:BWKtXx0lvOYV9Tr3sqsOYpol6J1OsWiXJ6li7B5zzWgJjSlRFml3AA>
    <xme:BWKtX4H3JewlRPoMOMet5L3M_CusRn3Xv_6RwS-7sd5xanYujdVv0imuzttWxNN9s
    S0MfIEbdWCd73vnGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthekredttderjeenucfhrhhomhepufgrmhhu
    vghlucfovghnughoiigrqdflohhnrghsuceoshgrmhesmhgvnhguohiirghjohhnrghsrd
    gtohhmqeenucggtffrrghtthgvrhhnpefgvedvvdffhfeihedukeegheeludduhfehuddt
    gefftddugeffjeetjeduteduvdenucfkphepjeehrddujedvrddujedvrdelheenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmsehmvghn
    ughoiigrjhhonhgrshdrtghomh
X-ME-Proxy: <xmx:BWKtXx6g1KiagMIG24p4KbcZzFT_Mo2ZXKlH5n7aB57q6-T_bXScaA>
    <xmx:BWKtX-2M7s6eN1tyIeZGBfDUsiNG5fnx6jGs8MMIhanoB4vXyLFYig>
    <xmx:BWKtX0Gz7hpDBe9iKOwynm54rLZu9_sx-3ZCf7EvGAHqPdUl9kZU9w>
    <xmx:BmKtX5SHSr5VdnwDIP-ZVwPHl_6CUUeD8hDcA_wUTzlWzt1Kp6toNA>
Received: from [192.168.0.2] (unknown [75.172.172.95])
        by mail.messagingengine.com (Postfix) with ESMTPA id 112583280063;
        Thu, 12 Nov 2020 11:25:40 -0500 (EST)
Message-ID: <6514889a7af123eed01e3471ae1c48252e9aa296.camel@mendozajonas.com>
Subject: Re: [PATCH v2] net/ncsi: Fix netlink registration
From:   Samuel Mendoza-Jonas <sam@mendozajonas.com>
To:     Joel Stanley <joel@jms.id.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 08:25:39 -0800
In-Reply-To: <20201112061210.914621-1-joel@jms.id.au>
References: <20201112061210.914621-1-joel@jms.id.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 16:42 +1030, Joel Stanley wrote:
> If a user unbinds and re-binds a NC-SI aware driver the kernel will
> attempt to register the netlink interface at runtime. The structure
> is
> marked __ro_after_init so registration fails spectacularly at this
> point.

Reviewed-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>

> 
>  # echo 1e660000.ethernet >
> /sys/bus/platform/drivers/ftgmac100/unbind
>  # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/bind
>   ftgmac100 1e660000.ethernet: Read MAC address 52:54:00:12:34:56
> from chip
>   ftgmac100 1e660000.ethernet: Using NCSI interface
>   8<--- cut here ---
>   Unable to handle kernel paging request at virtual address 80a8f858
>   pgd = 8c768dd6
>   [80a8f858] *pgd=80a0841e(bad)
>   Internal error: Oops: 80d [#1] SMP ARM
>   CPU: 0 PID: 116 Comm: sh Not tainted 5.10.0-rc3-next-20201111-
> 00003-gdd25b227ec1e #51
>   Hardware name: Generic DT based system
>   PC is at genl_register_family+0x1f8/0x6d4
>   LR is at 0xff26ffff
>   pc : [<8073f930>]    lr : [<ff26ffff>]    psr: 20000153
>   sp : 8553bc80  ip : 81406244  fp : 8553bd04
>   r10: 8085d12c  r9 : 80a8f73c  r8 : 85739000
>   r7 : 00000017  r6 : 80a8f860  r5 : 80c8ab98  r4 : 80a8f858
>   r3 : 00000000  r2 : 00000000  r1 : 81406130  r0 : 00000017
>   Flags: nzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
>   Control: 00c5387d  Table: 85524008  DAC: 00000051
>   Process sh (pid: 116, stack limit = 0x1f1988d6)
>  ...
>   Backtrace:
>   [<8073f738>] (genl_register_family) from [<80860ac0>]
> (ncsi_init_netlink+0x20/0x48)
>    r10:8085d12c r9:80c8fb0c r8:85739000 r7:00000000 r6:81218000
> r5:85739000
>    r4:8121c000
>   [<80860aa0>] (ncsi_init_netlink) from [<8085d740>]
> (ncsi_register_dev+0x1b0/0x210)
>    r5:8121c400 r4:8121c000
>   [<8085d590>] (ncsi_register_dev) from [<805a8060>]
> (ftgmac100_probe+0x6e0/0x778)
>    r10:00000004 r9:80950228 r8:8115bc10 r7:8115ab00 r6:9eae2c24
> r5:813b6f88
>    r4:85739000
>   [<805a7980>] (ftgmac100_probe) from [<805355ec>]
> (platform_drv_probe+0x58/0xa8)
>    r9:80c76bb0 r8:00000000 r7:80cd4974 r6:80c76bb0 r5:8115bc10
> r4:00000000
>   [<80535594>] (platform_drv_probe) from [<80532d58>]
> (really_probe+0x204/0x514)
>    r7:80cd4974 r6:00000000 r5:80cd4868 r4:8115bc10
> 
> Jakub pointed out that ncsi_register_dev is obviously broken, because
> there is only one family so it would never work if there was more
> than
> one ncsi netdev.
> 
> Fix the crash by registering the netlink family once on boot, and
> drop
> the code to unregister it.
> 
> Fixes: 955dc68cb9b2 ("net/ncsi: Add generic netlink family")
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> v2: Implement Jakub's suggestion
>  - drop __ro_after_init change
>  - register netlink with subsys_intcall
>  - remove unregister function
> 
>  net/ncsi/ncsi-manage.c  |  5 -----
>  net/ncsi/ncsi-netlink.c | 22 +++-------------------
>  net/ncsi/ncsi-netlink.h |  3 ---
>  3 files changed, 3 insertions(+), 27 deletions(-)
> 
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index f1be3e3f6425..a9cb355324d1 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -1726,9 +1726,6 @@ struct ncsi_dev *ncsi_register_dev(struct
> net_device *dev,
>         ndp->ptype.dev = dev;
>         dev_add_pack(&ndp->ptype);
>  
> -       /* Set up generic netlink interface */
> -       ncsi_init_netlink(dev);
> -
>         pdev = to_platform_device(dev->dev.parent);
>         if (pdev) {
>                 np = pdev->dev.of_node;
> @@ -1892,8 +1889,6 @@ void ncsi_unregister_dev(struct ncsi_dev *nd)
>         list_del_rcu(&ndp->node);
>         spin_unlock_irqrestore(&ncsi_dev_lock, flags);
>  
> -       ncsi_unregister_netlink(nd->dev);
> -
>         kfree(ndp);
>  }
>  EXPORT_SYMBOL_GPL(ncsi_unregister_dev);
> diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
> index adddc7707aa4..bb5f1650f11c 100644
> --- a/net/ncsi/ncsi-netlink.c
> +++ b/net/ncsi/ncsi-netlink.c
> @@ -766,24 +766,8 @@ static struct genl_family ncsi_genl_family
> __ro_after_init = {
>         .n_small_ops = ARRAY_SIZE(ncsi_ops),
>  };
>  
> -int ncsi_init_netlink(struct net_device *dev)
> +static int __init ncsi_init_netlink(void)
>  {
> -       int rc;
> -
> -       rc = genl_register_family(&ncsi_genl_family);
> -       if (rc)
> -               netdev_err(dev, "ncsi: failed to register netlink
> family\n");
> -
> -       return rc;
> -}
> -
> -int ncsi_unregister_netlink(struct net_device *dev)
> -{
> -       int rc;
> -
> -       rc = genl_unregister_family(&ncsi_genl_family);
> -       if (rc)
> -               netdev_err(dev, "ncsi: failed to unregister netlink
> family\n");
> -
> -       return rc;
> +       return genl_register_family(&ncsi_genl_family);
>  }
> +subsys_initcall(ncsi_init_netlink);
> diff --git a/net/ncsi/ncsi-netlink.h b/net/ncsi/ncsi-netlink.h
> index 7502723fba83..39a1a9d7bf77 100644
> --- a/net/ncsi/ncsi-netlink.h
> +++ b/net/ncsi/ncsi-netlink.h
> @@ -22,7 +22,4 @@ int ncsi_send_netlink_err(struct net_device *dev,
>                           struct nlmsghdr *nlhdr,
>                           int err);
>  
> -int ncsi_init_netlink(struct net_device *dev);
> -int ncsi_unregister_netlink(struct net_device *dev);
> -
>  #endif /* __NCSI_NETLINK_H__ */


