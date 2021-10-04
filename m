Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113C9421477
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbhJDQ4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 12:56:02 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:60401 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237561AbhJDQ4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 12:56:01 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6E75B580B5C;
        Mon,  4 Oct 2021 12:54:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 04 Oct 2021 12:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JIxAuX
        sS3WOdJAM05+0WBlHZHKSubxopXu0GVR1buSk=; b=QB4Fe61LHoLh0sc9SvUpMz
        iW5D5+aAj7kIFd/iwTLGY4tzvI56+h3cH4GY/8STVdwBhQpOVgiUSDjXK/X5/6t4
        t0YoK2zOtFf2zRto/OXMTVzAcjJgft2dAsjRMUwdAXeGgQekDxUCmCd/aasTRfIT
        8ncAlf6Nusj+DWEYe1SuS22bZa+Kckxy0fOVUFjj0SvWuLYhdkMnzt8XwvVXemY3
        CJ+lOGOjXw8SQVHRtZdoAWHENzPPIXmLntGnZfsU9IQL8QcbJaPGfnbZUHphJynv
        OQxVtE4/f//0YZQSk+fWQtSoYzxnxf+Zfeumdjm3shpVQMVxA1PJkHhyQ3T+bhKA
        ==
X-ME-Sender: <xms:szFbYQLdsrzcgKNnmRexgm8L6tLWX5d6JtztEYogH2E96wl8nDGO9A>
    <xme:szFbYQIChsxSavGZ8NWxdUrqisFeMs4bnVC-nYdTGW5Az-8RPnKL0i8zGnMZjIEHq
    _wFArndHEJ1dss>
X-ME-Received: <xmr:szFbYQv_FAi8Bg2VLAnSc_Pjnj2x34Kttdv-VfyMu3pdsP8Efcs9drLn48engdVY4vr1Ho5bUd9U6qiY5v9P7lNd8zYH1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:szFbYdblGzsrgC7dGsv88f2LYdYZTQjX1MMw481fRGD0buTK3ph5VA>
    <xmx:szFbYXbk6uzinz5-5AE0F550BJeGorzPvDZJLpVg-bIrH6iE9a8agg>
    <xmx:szFbYZDm81owxYr4Zi0SRRmrL0CzLEJH2_DQA0CeoZUyZ8OpP7s73Q>
    <xmx:tDFbYdxjfw5OuBwdI7cV8Myr1M0jvGSkbVE-WaYjVbOeUVPhABm4XA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Oct 2021 12:54:10 -0400 (EDT)
Date:   Mon, 4 Oct 2021 19:54:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <YVsxqsEGkV0A5lvO@shredder>
References: <cover.1633284302.git.leonro@nvidia.com>
 <06ebba9e115d421118b16ac4efda61c2e08f4d50.1633284302.git.leonro@nvidia.com>
 <YVsNfLzhGULiifw2@shredder>
 <YVshg3a9OpotmOQg@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVshg3a9OpotmOQg@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 06:45:07PM +0300, Leon Romanovsky wrote:
> On Mon, Oct 04, 2021 at 05:19:40PM +0300, Ido Schimmel wrote:
> > On Sun, Oct 03, 2021 at 09:12:06PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > After changes to allow dynamically set the reload_up/_down callbacks,
> > > we ensure that properly supported devlink ops are not accessible before
> > > devlink_register, which is last command in the initialization sequence.
> > > 
> > > It makes devlink_reload_enable/_disable not relevant anymore and can be
> > > safely deleted.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > [...]
> > 
> > > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > > index cb6645012a30..09e48fb232a9 100644
> > > --- a/drivers/net/netdevsim/dev.c
> > > +++ b/drivers/net/netdevsim/dev.c
> > > @@ -1512,7 +1512,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
> > >  
> > >  	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
> > >  	devlink_register(devlink);
> > > -	devlink_reload_enable(devlink);
> > >  	return 0;
> > >  
> > >  err_psample_exit:
> > > @@ -1566,9 +1565,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
> > >  	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
> > >  	struct devlink *devlink = priv_to_devlink(nsim_dev);
> > >  
> > > -	devlink_reload_disable(devlink);
> > >  	devlink_unregister(devlink);
> > > -
> > >  	nsim_dev_reload_destroy(nsim_dev);
> > >  
> > >  	nsim_bpf_dev_exit(nsim_dev);
> > 
> > I didn't remember why devlink_reload_{enable,disable}() were added in
> > the first place so it was not clear to me from the commit message why
> > they can be removed. It is described in commit a0c76345e3d3 ("devlink:
> > disallow reload operation during device cleanup") with a reproducer.
> 
> It was added because devlink ops were accessible by the user space very
> early in the driver lifetime. All my latest devlink patches are the
> attempt to fix this arch/design/implementation issue.

The reproducer in the commit message executed the reload after the
device was fully initialized. IIRC, the problem there was that nothing
prevented these two tasks from racing:

devlink dev reload netdevsim/netdevsim10
echo 10 > /sys/bus/netdevsim/del_device

The title also talks about forbidding reload during device cleanup.

> 
> > 
> > Tried the reproducer with this series and I cannot reproduce the issue.
> > Wasn't quite sure why, but it does not seem to be related to "changes to
> > allow dynamically set the reload_up/_down callbacks", as this seems to
> > be specific to mlx5.
> 
> You didn't reproduce because of my series that moved
> devlink_register()/devlink_unregister() to be last/first commands in
> .probe()/.remove() flows.

Agree, that is what I wrote in the next paragraph of my reply.

> 
> Patch to allow dynamically set ops was needed because mlx5 had logic
> like this:
>  if(something)
>     devlink_reload_enable()
> 
> And I needed a way to keep this if ... condition.
> 
> > 
> > IIUC, the reason that the race described in above mentioned commit can
> > no longer happen is related to the fact that devlink_unregister() is
> > called first in the device dismantle path, after your previous patches.
> > Since both the reload operation and devlink_unregister() hold
> > 'devlink_mutex', it is not possible for the reload operation to race
> > with device dismantle.
> > 
> > Agree? If so, I think it would be good to explain this in the commit
> > message unless it's clear to everyone else.
> 
> I don't agree for very simple reason that devlink_mutex is going to be
> removed very soon and it is really not a reason why devlink reload is
> safer now when before.
> 
> The reload can't race due to:
> 1. devlink_unregister(), which works as a barrier to stop accesses
> from the user space.
> 2. reference counting that ensures that all in-flight commands are counted.
> 3. wait_for_completion that blocks till all commands are done.

So the wait_for_completion() is what prevents the race, not
'devlink_mutex' that is taken later. This needs to be explained in the
commit message to make it clear why the removal is safe.

Thanks
