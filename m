Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB036369C2
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbiKWTSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbiKWTSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:18:23 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BBBE03B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:18:22 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 356C05C007C;
        Wed, 23 Nov 2022 14:18:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Nov 2022 14:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1669231100; x=
        1669317500; bh=wyBZ1W5tmpaejlOrSbgW0D7YzKs6+LK3QdF1M/diyf8=; b=o
        pX7xL20aBlLvfq84U+etV1AMjL3HjlUwzLw2Fe9mMExNX3qQa+YeRLrF+xkp8fjk
        6WMfHfZ+72KlRYRBTldyglwlKO6iUf86o1/Ps0E9LiH7ybGR6IIOCdOPCf8+IFwJ
        LpicW/FkgCWPki+u1URB5JWQj84xOa6NxIw5KxbaArihyW0JL6kTTVDpI0Aal7jN
        nST5CGKwbx14u9Uv78YoZRzRlb6JgdMxrfwi12CbY311azhmagmSQaHpuAapHjnJ
        /P3NVknwb3vJMsSy1jOMONm+GN2px15kUCx5rvxr/rzno+9QQa7IOayY8pf+doyW
        zU8QvLpWdnX0zUjwB0F7g==
X-ME-Sender: <xms:-3F-Y_ljUyxYAEJdNl-Gf_miFqMk4acryYIssy0xxO3Pr5qLpL0yZw>
    <xme:-3F-Yy1j1SotWnjX_hR8ywtbkV9WmxpCfZnb2bO78VCBBO3rG9sG7xBLCQ2qyEC9L
    gbHV8hYUXECu-4>
X-ME-Received: <xmr:-3F-Y1oA0l7tHWw3yy8aPQUvMoQ0lm5WaYNb4vmVAqOsPykGwTSgIcp7QR9Ywk0oS3XxWhpzqU5LUB1G9sL-p0HZJ_k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedriedugdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegheekuddvueejvddtvdfgtddvgfevudektddtteevuddvkeetveeftdev
    ueejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-3F-Y3lulq-UoovJKi9H_BFQ-Nvx8rjqs0t1S5rgCHpeTxXFi4Nrwg>
    <xmx:-3F-Y92DHexprjwb9AbuJtL6USNHHQYP5fIFmCchDBBPnn63o88c3w>
    <xmx:-3F-Y2tPrMMnWIE6OkxJbikqmimMBnCxBZ0fV_kTqBz4H2kZ230WMA>
    <xmx:_HF-Y1_mnHFBe4gjh6QMMS-8u3RriPPMLL2lin8zMUrIlrnakBwAMA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Nov 2022 14:18:18 -0500 (EST)
Date:   Wed, 23 Nov 2022 21:18:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y35x9oawn/i+nuV3@shredder>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal>
 <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal>
 <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 04:34:49PM +0800, Yang Yingliang wrote:
> 
> On 2022/11/23 15:41, Leon Romanovsky wrote:
> > On Wed, Nov 23, 2022 at 02:40:24PM +0800, Yang Yingliang wrote:
> > > On 2022/11/23 4:27, Jakub Kicinski wrote:
> > > > On Tue, 22 Nov 2022 21:04:29 +0200 Leon Romanovsky wrote:
> > > > > > > Please fix nsim instead of devlink.
> > > > > > I think if devlink is not registered, it can not be get and used, but there
> > > > > > is no API for driver to check this, can I introduce a new helper name
> > > > > > devlink_is_registered() for driver using.
> > > > > There is no need in such API as driver calls to devlink_register() and
> > > > > as such it knows when devlink is registered.
> > > > > 
> > > > > This UAF is nsim specific issue. Real devices have single .probe()
> > > > > routine with serialized registration flow. None of them will use
> > > > > devlink_is_registered() call.
> > > > Agreed, the fix is to move the register call back.
> > > > Something along the lines of the untested patch below?
> > > > Yang Yingliang would you be able to turn that into a real patch?
> > > > 
> > > > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > > > index e14686594a71..26602d5fe0a2 100644
> > > > --- a/drivers/net/netdevsim/dev.c
> > > > +++ b/drivers/net/netdevsim/dev.c
> > > > @@ -1566,12 +1566,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > >    	err = devlink_params_register(devlink, nsim_devlink_params,
> > > >    				      ARRAY_SIZE(nsim_devlink_params));
> > > >    	if (err)
> > > > -		goto err_dl_unregister;
> > > > +		goto err_resource_unregister;
> > > >    	nsim_devlink_set_params_init_values(nsim_dev, devlink);
> > > > +	/* here, because params API still expect devlink to be unregistered */
> > > > +	devl_register(devlink);
> > > > +
> > > devlink_set_features() called at last in probe() also needs devlink is not
> > > registered.
> > > >    	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
> > > >    	if (err)
> > > > -		goto err_params_unregister;
> > > > +		goto err_dl_unregister;
> > > >    	err = nsim_dev_traps_init(devlink);
> > > >    	if (err)
> > > > @@ -1610,7 +1613,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > >    	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
> > > >    	devlink_set_features(devlink, DEVLINK_F_RELOAD);
> > > >    	devl_unlock(devlink);
> > > > -	devlink_register(devlink);
> > > >    	return 0;
> > > >    err_hwstats_exit:
> > > > @@ -1629,10 +1631,11 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > >    	nsim_dev_traps_exit(devlink);
> > > >    err_dummy_region_exit:
> > > >    	nsim_dev_dummy_region_exit(nsim_dev);
> > > > -err_params_unregister:
> > > > +err_dl_unregister:
> > > > +	devl_unregister(devlink);
> > > It races with dev_ethtool():
> > > dev_ethtool
> > >    devlink_try_get()
> > >                                  nsim_drv_probe
> > >                                  devl_lock()
> > >      devl_lock()
> > >                                  devlink_unregister()
> > >                                    devlink_put()
> > >                                    wait_for_completion() <- the refcount is
> > > got in dev_ethtool, it causes ABBA deadlock
> > But all these races are nsim specific ones.
> > Can you please explain why devlink.[c|h] MUST be changed and nsim can't
> > be fixed?
> I used the fix code proposed by Jakub, but it didn't work correctly, so
> I tried to correct and improve it, and need some devlink helper.
> 
> Anyway, it is a nsim problem, if we want fix this without touch devlink,
> I think we can add a 'registered' field in struct nsim_dev, and it can be
> checked in nsim_get_devlink_port() like this:

I read the discussion and it's not clear to me why this is a netdevsim
specific problem. The fundamental problem seems to be that it is
possible to hold a reference on a devlink instance before it's
registered and that devlink_free() will free the instance regardless of
its current reference count because it expects devlink_unregister() to
block. In this case, the instance was never registered, so
devlink_unregister() is not called.

ethtool was able to get a reference on the devlink instance before it
was registered because netdevsim registers its netdevs before
registering its devlink instance. However, netdevsim is not the only one
doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
others do the same thing.

When you think about it, it's strange that it's even possible for
ethtool to reach the driver when the netdev used in the request is long
gone, but it's not holding a reference on the netdev (it's holding a
reference on the devlink instance instead) and
devlink_compat_running_version() is called without RTNL.
