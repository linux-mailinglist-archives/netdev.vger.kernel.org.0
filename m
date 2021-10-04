Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677F742113E
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 16:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhJDOVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 10:21:36 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:47801 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233384AbhJDOVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 10:21:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 72665580A5E;
        Mon,  4 Oct 2021 10:19:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 Oct 2021 10:19:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SP8p7v
        RHek0+NLeWR4b0M3SRX5R2PEfbEShLyKtrWB8=; b=RVl7cYWwf8stiNnf5eE5ed
        fepYlcBTDeYASgwVEEKIiJh7BXL15InnRRbSvsYZT3UQrJ8BcMkLXP+R6KDYjLFc
        dal+UHDiIpncurYHzZXeb75pZhypmv7ZKmXRZnkrXDkC+HHXwEDkOjbrG+K7MfXy
        IJ9MNn6PSMwVqi5TqyIUgzH76QxFKfYbIKJCjzBnNogKtI9qK9ArDGvUHGJvhUB+
        F/rwNlOhZgvZTAlVIbL//7rSQB2B5pSLt9uRxDSIwuCfB6U84QoSZ0iN53prkrMB
        Njx5j+HDc8yenfOHnK8SATJjTkQdIuRdfDfz5HZCAuy7zi6o7ADsw/r3lQ5MlBCQ
        ==
X-ME-Sender: <xms:gA1bYW4oNPc2_Jynme6eWHXba34pvsSkvtyeDNt87grt-sS7fJjcfA>
    <xme:gA1bYf4m5g52wfUqT2EcMJvPQh7MkkXYrRGUgYsT3m6p6MMx8SZ9mw7oCZv18Qkl0
    sC_oGhiVUSG8Xc>
X-ME-Received: <xmr:gA1bYVcmj0xrb1FvTteH5Zx8sKtGprOTNQhJ2TtBcCL4EHQ8TAt5hxnBIOf7gPHz6u7I_fCWMGfXnsu5iPzsVZH73qXokw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gA1bYTLpfERgcKxtdbUE-LpPg5PMTdE9FX5flR4g-K_UXwPBCt1Gbg>
    <xmx:gA1bYaL6DfWlLR-_erVe_FdtWwHdoCrUhihq7k4rAZk5G_STnAlaUQ>
    <xmx:gA1bYUzfX_AyJqIJDzxFhbjGL3_qP-rE5FwfA3DU8jaHxbNxgDnzqQ>
    <xmx:gQ1bYf6VdGPgTJjnhNngfm6877Q2lRENVOnsCNMDDuobCYjPRLDmfA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Oct 2021 10:19:44 -0400 (EDT)
Date:   Mon, 4 Oct 2021 17:19:40 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 5/5] devlink: Delete reload enable/disable
 interface
Message-ID: <YVsNfLzhGULiifw2@shredder>
References: <cover.1633284302.git.leonro@nvidia.com>
 <06ebba9e115d421118b16ac4efda61c2e08f4d50.1633284302.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06ebba9e115d421118b16ac4efda61c2e08f4d50.1633284302.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 03, 2021 at 09:12:06PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> After changes to allow dynamically set the reload_up/_down callbacks,
> we ensure that properly supported devlink ops are not accessible before
> devlink_register, which is last command in the initialization sequence.
> 
> It makes devlink_reload_enable/_disable not relevant anymore and can be
> safely deleted.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

[...]

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index cb6645012a30..09e48fb232a9 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -1512,7 +1512,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
>  
>  	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
>  	devlink_register(devlink);
> -	devlink_reload_enable(devlink);
>  	return 0;
>  
>  err_psample_exit:
> @@ -1566,9 +1565,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
>  	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
>  	struct devlink *devlink = priv_to_devlink(nsim_dev);
>  
> -	devlink_reload_disable(devlink);
>  	devlink_unregister(devlink);
> -
>  	nsim_dev_reload_destroy(nsim_dev);
>  
>  	nsim_bpf_dev_exit(nsim_dev);

I didn't remember why devlink_reload_{enable,disable}() were added in
the first place so it was not clear to me from the commit message why
they can be removed. It is described in commit a0c76345e3d3 ("devlink:
disallow reload operation during device cleanup") with a reproducer.

Tried the reproducer with this series and I cannot reproduce the issue.
Wasn't quite sure why, but it does not seem to be related to "changes to
allow dynamically set the reload_up/_down callbacks", as this seems to
be specific to mlx5.

IIUC, the reason that the race described in above mentioned commit can
no longer happen is related to the fact that devlink_unregister() is
called first in the device dismantle path, after your previous patches.
Since both the reload operation and devlink_unregister() hold
'devlink_mutex', it is not possible for the reload operation to race
with device dismantle.

Agree? If so, I think it would be good to explain this in the commit
message unless it's clear to everyone else.

Thanks
