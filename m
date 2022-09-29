Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0A5EEC58
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 05:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiI2DKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 23:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiI2DKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 23:10:46 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ADC6745C
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 20:10:44 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s26so286652pgv.7
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 20:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=js3pbXWSBqel2AvQwQ1CywbyWFKRerRzV8zVe/xxRBg=;
        b=eZYd6oMWTHWIQQ/raXZ5Kjdf905Vx1eVDLeAzCDlqWjZMcVN29HCDhEaPkOQOt5s+0
         0fjGzkyeUvVArAPSHza41H5r51Npjw52vz7CITzjOweTlHZv0BpirlMtqe6oFQQv6j3h
         CYrHpDxrJz9Rsnw75Z8hFEUxmr4CKGPeaHo6ugPhCdbm88g9rK28kGQc+UsodJ/WZTdj
         uhQnnD+/UqRJPGoDxYCh5FBhQ15eBbxnXnyEN1ulV4H7rhsoin72U5gv2xt9Ub14EdI+
         e/8ZRYLuhknGV4Qe1ECenmK3YOZ6QWzHBtZBJ7lCTgR9jz6Sb5OIkHtNzMA4rMZXfVY/
         5hBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=js3pbXWSBqel2AvQwQ1CywbyWFKRerRzV8zVe/xxRBg=;
        b=ZxWzT5N4gDKBOQLZevq2Skkw5LLfpHawXWEMdB7Tw8EfDeYHe0oKzZCvGcARHO13UD
         BkiEDB6Etpu5FOLiCZOrYUNKBoJ5oa8uN4EvMjmbFSI26PmIBVg71i2F0qE0/kLQUjt1
         gVZy9yTu5tTQgVkcT0/B6s838BZovcfRbkTt/uDNrqx+hVI6Ga6Z993pZzde9awRvsUF
         3h5optDCWYo5PiF3lPomXUz5Et3yHaetm2P7U2ude8VUuWLHuLxNGCA72yW2iW0N/lds
         QXE+/gKhzDvMLS5SUdz73VYRZSZFM6vp8rMqcOc1DVsTafKPG4ds0CQmWhnGI2oHS/WG
         kTAA==
X-Gm-Message-State: ACrzQf0tFVivkOl8qk7AP8a21+/gGGP7K2eOQuKHlgTGb4DejFwe3jfH
        6cssL1mlUU4BZw7uYj4syVs=
X-Google-Smtp-Source: AMsMyM7XYYgnu84dUXc7+X1FsHcIcwj7w118+Ylo7pluxXDxbh2aQhiwUbDJmLVabbwLQ5qTFAbf4g==
X-Received: by 2002:a63:84c6:0:b0:439:4687:b63f with SMTP id k189-20020a6384c6000000b004394687b63fmr968541pgd.532.1664421043497;
        Wed, 28 Sep 2022 20:10:43 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z15-20020a63e10f000000b004340d105fd4sm4392733pgh.21.2022.09.28.20.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 20:10:42 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:10:36 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <YzUMrAgm5eieW1hS@Laptop-X1>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
 <20220927072130.6d5204a3@kernel.org>
 <YzOz9ePdsIMGg0s+@Laptop-X1>
 <20220928094757.GA3081@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928094757.GA3081@localhost.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 11:47:57AM +0200, Guillaume Nault wrote:
> On Wed, Sep 28, 2022 at 10:39:49AM +0800, Hangbin Liu wrote:
> > On Tue, Sep 27, 2022 at 07:21:30AM -0700, Jakub Kicinski wrote:
> > > On Tue, 27 Sep 2022 12:13:03 +0800 Hangbin Liu wrote:
> > > > @@ -3382,6 +3401,12 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
> > > >  		if (err)
> > > >  			goto out_unregister;
> > > >  	}
> > > > +
> > > > +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> > > > +				      0, pid, nlh->nlmsg_seq);
> > > > +	if (nskb)
> > > > +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
> > > > +
> > > >  out:
> > > >  	if (link_net)
> > > >  		put_net(link_net);
> > > 
> > > I'm surprised you're adding new notifications. Does the kernel not
> > > already notify about new links? I thought rtnl_newlink_create() ->
> > > rtnl_configure_link() -> __dev_notify_flags() sends a notification,
> > > already.
> > 
> > I think __dev_notify_flags() only sends notification when dev flag changed.
> > On the other hand, the notification is sent via multicast, while this patch
> > is intend to unicast the notification to the user space.
> 
> In rntl_configure_link(), dev->rtnl_link_state is RTNL_LINK_INITIALIZING
> on device cretation, so __dev_notify_flags() is called with gchanges=~0
> and notification should be always sent. It's just a matter of passing the
> portid and the nlmsghdr down the call chain to make rtnl_notify() send
> the unicast message together with the multicast ones.

To update __dev_notify_flags() with nlmsghdr, we also need to update
rtnl_configure_link(), which is called by some drivers.

> 
> Now for device modification, I'm not sure there's a use case for
> unicast notifications. The caller already knows which values it asked
> to modify, so ECHO doesn't bring much value compared to a simple ACK.

And the __dev_notify_flags() is only used when the dev flag changed.

It looks no much change if we call it when create new link:
rtnl_newlink_create() -> rtnl_configure_link() -> __dev_notify_flags()

But when set link, it is only called when flag changed
do_setlink() -> dev_change_flags() -> __dev_notify_flags().

Unless you want to omit the ECHO message when setting link.

At latest, when call rtnl_delete_link(), there is no way to call
__dev_notify_flags(). So we still need to use the current way.

As a summarize, we need to change a lot of code if we use __dev_notify_flags()
to notify user, while we can only use it in one place. This looks not worth.

WDYT?

Thanks
Hangbin
