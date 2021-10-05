Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E58C421EB4
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhJEGML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:12:11 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50745 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhJEGML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 02:12:11 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 87BD5580C41;
        Tue,  5 Oct 2021 02:10:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 05 Oct 2021 02:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FNZqYi
        1w285dZn8olYyH8fSQVGVA9Ej35FiVAnMbEC0=; b=bPiJ2vYSH71pOE+r1ACtDl
        U+VWTCg1qDZW1IfOz7EuTVDyJSNvs6MkOGzAr2Np2JqTPdDf04BLflUQpWwnY2xt
        loIHpNxirlaOceujhpyV/2V0eJMIYBN70VAJzGmNECD8deHE8BAwOt2BtVuY++yk
        jlr5H0fbEbLoq2TeqgY5ToZKXfUI3kM7eUwSRicEi3LHmwRa9cmQYYLwNFr4hpuf
        5Jx8XUo0e3GBfCFNEQabJjJbBpNVQjRRp3N+RSqq/Vy741Uj9yUCBQdZmqdaOmBo
        7QNpBi4uRJ+n+0GuMAr0a6hSflsvu1pSFvtncQKMLaQ/jXpEfdN7dF9fx743dKWQ
        ==
X-ME-Sender: <xms:S-xbYXH8-SBvPPC8F3Q8H-eLPqfM7g4VmqjGKf1kQnRNtYJA6TflHg>
    <xme:S-xbYUUeYKFmrWdmKsqifi5Y5Lu8SofIPVDCRaKM2r3V6mAb0aiMWv9iBG99vLMTI
    _ab4TgOlIYpFew>
X-ME-Received: <xmr:S-xbYZI5G8aQ9pLQkjySlknpHd7_bG_jtPG7ys72dqfFP7Ws_DY9JX1o_B62MHaP3xG0nYUVO3g8S_fkU9f8y2juWZ9MeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelfedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdfhudeuhefgkeekhfehuddtvdevfeetheetkeelvefggeetveeuleeh
    keeunecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:S-xbYVEbzMKFkzwIuX9BwUxhRgO20Pr0mPG8J2onVv481SmCsDOz-A>
    <xmx:S-xbYdUrYvqKa0hAxaZlCUU0KEjXpQ95HQjIHGZ-YWh7YBgYfAiiUA>
    <xmx:S-xbYQOkcG4lgcXRIiOkXs-XuJouN1HbSxjQjXIlRCXvrgoZMV_Ltw>
    <xmx:TOxbYeuTA2dO-HN84kIZlLyNCLQqjqyUBxF914r3h9fhwvcKjgS1Sw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Oct 2021 02:10:19 -0400 (EDT)
Date:   Tue, 5 Oct 2021 09:10:15 +0300
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
Message-ID: <YVvsR4CxOW09k8KX@shredder>
References: <cover.1633284302.git.leonro@nvidia.com>
 <06ebba9e115d421118b16ac4efda61c2e08f4d50.1633284302.git.leonro@nvidia.com>
 <YVsNfLzhGULiifw2@shredder>
 <YVshg3a9OpotmOQg@unreal>
 <YVsxqsEGkV0A5lvO@shredder>
 <YVtPruw9kzOQvhZu@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVtPruw9kzOQvhZu@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 10:02:06PM +0300, Leon Romanovsky wrote:
> On Mon, Oct 04, 2021 at 07:54:02PM +0300, Ido Schimmel wrote:
> > On Mon, Oct 04, 2021 at 06:45:07PM +0300, Leon Romanovsky wrote:
> > > On Mon, Oct 04, 2021 at 05:19:40PM +0300, Ido Schimmel wrote:
> > > > On Sun, Oct 03, 2021 at 09:12:06PM +0300, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > 
> > > > > After changes to allow dynamically set the reload_up/_down callbacks,
> > > > > we ensure that properly supported devlink ops are not accessible before
> > > > > devlink_register, which is last command in the initialization sequence.
> > > > > 
> > > > > It makes devlink_reload_enable/_disable not relevant anymore and can be
> > > > > safely deleted.
> > > > > 
> > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > [...]
> > > > 
> > > > > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > > > > index cb6645012a30..09e48fb232a9 100644
> > > > > --- a/drivers/net/netdevsim/dev.c
> > > > > +++ b/drivers/net/netdevsim/dev.c
> > > > > @@ -1512,7 +1512,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > > >  
> > > > >  	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
> > > > >  	devlink_register(devlink);
> > > > > -	devlink_reload_enable(devlink);
> > > > >  	return 0;
> > > > >  
> > > > >  err_psample_exit:
> > > > > @@ -1566,9 +1565,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
> > > > >  	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
> > > > >  	struct devlink *devlink = priv_to_devlink(nsim_dev);
> > > > >  
> > > > > -	devlink_reload_disable(devlink);
> > > > >  	devlink_unregister(devlink);
> > > > > -
> > > > >  	nsim_dev_reload_destroy(nsim_dev);
> > > > >  
> > > > >  	nsim_bpf_dev_exit(nsim_dev);
> > > > 
> > > > I didn't remember why devlink_reload_{enable,disable}() were added in
> > > > the first place so it was not clear to me from the commit message why
> > > > they can be removed. It is described in commit a0c76345e3d3 ("devlink:
> > > > disallow reload operation during device cleanup") with a reproducer.
> > > 
> > > It was added because devlink ops were accessible by the user space very
> > > early in the driver lifetime. All my latest devlink patches are the
> > > attempt to fix this arch/design/implementation issue.
> > 
> > The reproducer in the commit message executed the reload after the
> > device was fully initialized. IIRC, the problem there was that nothing
> > prevented these two tasks from racing:
> > 
> > devlink dev reload netdevsim/netdevsim10
> > echo 10 > /sys/bus/netdevsim/del_device
> > 
> > The title also talks about forbidding reload during device cleanup.
> 
> It is incomplete title and reproducer.

How can the reproducer be incomplete when it reproduced the issue 100%
of the time?

> In our verification, we observed more than 40 bugs related to devlink
> reload flows and races around it.

I assume these bugs are related to mlx5. syzkaller is familiar with the
devlink messages [1] and we are using it to fuzz over both mlxsw and
netdevsim. syzbot is also fuzzing over netdevsim and I'm not aware of
any open bugs.

[1] https://github.com/google/syzkaller/blob/master/sys/linux/socket_netlink_generic_devlink.txt

> 
> > 
> > > 
> > > > 
> > > > Tried the reproducer with this series and I cannot reproduce the issue.
> > > > Wasn't quite sure why, but it does not seem to be related to "changes to
> > > > allow dynamically set the reload_up/_down callbacks", as this seems to
> > > > be specific to mlx5.
> > > 
> > > You didn't reproduce because of my series that moved
> > > devlink_register()/devlink_unregister() to be last/first commands in
> > > .probe()/.remove() flows.
> > 
> > Agree, that is what I wrote in the next paragraph of my reply.
> > 
> > > 
> > > Patch to allow dynamically set ops was needed because mlx5 had logic
> > > like this:
> > >  if(something)
> > >     devlink_reload_enable()
> > > 
> > > And I needed a way to keep this if ... condition.
> > > 
> > > > 
> > > > IIUC, the reason that the race described in above mentioned commit can
> > > > no longer happen is related to the fact that devlink_unregister() is
> > > > called first in the device dismantle path, after your previous patches.
> > > > Since both the reload operation and devlink_unregister() hold
> > > > 'devlink_mutex', it is not possible for the reload operation to race
> > > > with device dismantle.
> > > > 
> > > > Agree? If so, I think it would be good to explain this in the commit
> > > > message unless it's clear to everyone else.
> > > 
> > > I don't agree for very simple reason that devlink_mutex is going to be
> > > removed very soon and it is really not a reason why devlink reload is
> > > safer now when before.
> > > 
> > > The reload can't race due to:
> > > 1. devlink_unregister(), which works as a barrier to stop accesses
> > > from the user space.
> > > 2. reference counting that ensures that all in-flight commands are counted.
> > > 3. wait_for_completion that blocks till all commands are done.
> > 
> > So the wait_for_completion() is what prevents the race, not
> > 'devlink_mutex' that is taken later. This needs to be explained in the
> > commit message to make it clear why the removal is safe.
> 
> Can you please suggest what exactly should I write in the commit message
> to make it clear?
> 
> I'm too much into this delvink stuff already and for me this patch is
> trivial. IMHO, that change doesn't need an explanation at all because
> coding pattern of refcount + wait_for_completion is pretty common in the
> kernel. So I think that I explained good enough: move of
> devlink_register/devlink_unregister obsoletes the devlink_reload_* APIs.
> 
> I have no problem to update the commit message, just help me with the
> message.

I suggest something like:

"
Commit a0c76345e3d3 ("devlink: disallow reload operation during device
cleanup") added devlink_reload_{enable,disable}() APIs to prevent reload
operation from racing with device probe / dismantle.

After recent changes to move devlink_register() to the end of device
probe and devlink_unregister() to the beginning of device dismantle,
these races can no longer happen. Reload operations will be denied if
the devlink instance is unregistered and devlink_unregister() will block
until all in-flight operations are done.

Therefore, remove these devlink_reload_{enable,disable}() APIs. Tested
with the reproducer mentioned in cited commit.
"
