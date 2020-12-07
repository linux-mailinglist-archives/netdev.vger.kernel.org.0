Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58AA2D095B
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 04:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgLGDUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 22:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLGDUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 22:20:54 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BE1C0613D1
        for <netdev@vger.kernel.org>; Sun,  6 Dec 2020 19:20:07 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id x13so3754494oto.8
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 19:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z59kgYchFG/7MhKEJwSEAUBMwVUZzDGVXVSWjoCMOgc=;
        b=B59EfF6zmD3fAQeKytnVrvKESEjIb/5J0nl44I3OUHeIengvNYVWWj2GSFO/vfoLjT
         oe+3HkELPPj3ghR2jLLkvrc9SR/h0FRgEiisRHTcr07T8mScqkVBCUY+E/Lc638+eGLy
         FBt+HRbsCEf5TX2K9JBTb3fyk5QQCWy/pj+NJNBHd7SMfUMexM2Y7Hedk2PsRK+E4CGn
         C+mJq2HUv57ThKH+b72OKpyVJC+DZ2xhjYLo6cNEyqHldVppcSdaRv5+Mf135VBZ8GJu
         xjXWnDga8hoOe1i+wwif5IvfGTTMqIXQdJ9XTtHrUOkZ573nQH6QhGYhDVR1Q0hiO2F0
         H/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z59kgYchFG/7MhKEJwSEAUBMwVUZzDGVXVSWjoCMOgc=;
        b=Ydc1eJhSkX/xLOCRn5y8pCEWCRTOq9Jk6rH13PM2APKwMhefboz8yvTG6e650NRWEU
         H7WQ7T4nfBVbXmPtgOEJvcyEAzeil682oWidJO54Y9/L0t7uChr4NLR7NMniQ2ISl95I
         uKKiTa2dS9HnlKo6PnTid16LCIBw3YsmPpSOYvTPc0yFbmnVwVT3MI7qvhCtM1ILymG7
         FgqnMfH586O83kpmZ+1q2nmIGGTCEpSvsOHYyjSBtju0uMsr11jGUDFnR7KmJroFD54R
         QpL3M1HXkJ4+UP8qsvPv3b38rRzntR9GbRq8CKq8ETo4Jbk7Jj2KkYpU7iT0BYvYacb6
         oFkQ==
X-Gm-Message-State: AOAM532UhSOZmfY+VgtXiu3x/iTQcBzYdLUQFbN+1XADBs7MGCYORuZk
        lrhBhlo3q4aEJFyQ+CV53Gy05DAU4+2W8QAMYqk=
X-Google-Smtp-Source: ABdhPJzzSfMTFY6YQOnE4+RaGsPjUTmujUBo4SLDow4kuyt+BEh282XcY9XzSCsS3H4nyn3ay5XP/JTnf4fvv3ZrnRo=
X-Received: by 2002:a9d:2921:: with SMTP id d30mr3820759otb.307.1607311207330;
 Sun, 06 Dec 2020 19:20:07 -0800 (PST)
MIME-Version: 1.0
References: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
 <20201123162639.5d692198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKfmpSdv5onOGk=VtEO1fWxxhaVvi96Tz-wCFcNE5R9cdXNgkg@mail.gmail.com>
 <20201206164924.baczz7eyxz6czro2@lion.mk-sys.cz> <CAKfmpSc1ZQ+FgBtn3XHkC2sTCFMoCq5BenCWswQmuWQs7A3Q=g@mail.gmail.com>
In-Reply-To: <CAKfmpSc1ZQ+FgBtn3XHkC2sTCFMoCq5BenCWswQmuWQs7A3Q=g@mail.gmail.com>
From:   Limin Wang <lwang.nbl@gmail.com>
Date:   Sun, 6 Dec 2020 22:19:56 -0500
Message-ID: <CACpdL32DhF7T_AHPM94BXO5vr_mAT4yC2ff2Mcfwjgd9z+90+Q@mail.gmail.com>
Subject: Re: LRO: creating vlan subports affects parent port's LRO settings
To:     Jarod Wilson <jarod@redhat.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I might be wrong. One potential issue I found in
netdev_sync_upper_features() is that it depends on the wanted_feature
of upper_dev

if (!(upper->wanted_features & feature)
   && (features & feature)) {
netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
  &feature, upper->name);
features &= ~feature;
}
}
Suppose a new vlan device will have the LRO bit in its features
because lower_dev (real_dev) supports LRO ( assuming with proposed
changes above), if the vlan_dev's wanted_feature doesn't include LRO,
the NETIF_F_LRO may still be dropped due to this.
One could manually use "ethtool -K vlan_dev lro on" to enable LRO in
the subport's wanted_features, but that has to be done on all
vlan_dev's of the same real_dev. (it is not uncommon that a parent
port may have hundreds of vlan subports)
Does that mean the vlan_dev->wanted_feature has to include LRO bit at
creation time to avoid explicitly setting later on for each and every
vlan subports?

On Sun, Dec 6, 2020 at 5:58 PM Jarod Wilson <jarod@redhat.com> wrote:
>
> On Sun, Dec 6, 2020 at 11:49 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > On Sat, Dec 05, 2020 at 07:04:06PM -0500, Jarod Wilson wrote:
> > > On Mon, Nov 23, 2020 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Thu, 19 Nov 2020 20:37:27 -0500 Limin Wang wrote:
> > > > > Under relatively recent kernels (v4.4+), creating a vlan subport on a
> > > > > LRO supported parent NIC may turn LRO off on the parent port and
> > > > > further render its LRO feature practically unchangeable.
> > > >
> > > > That does sound like an oversight in commit fd867d51f889 ("net/core:
> > > > generic support for disabling netdev features down stack").
> > > >
> > > > Are you able to create a patch to fix this?
> > >
> > > Something like this, perhaps? Completely untested copy-pasta'd
> > > theoretical patch:
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 8588ade790cb..a5ce372e02ba 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -9605,8 +9605,10 @@ int __netdev_update_features(struct net_device *dev)
> > >         features = netdev_fix_features(dev, features);
> > >
> > >         /* some features can't be enabled if they're off on an upper device */
> > > -       netdev_for_each_upper_dev_rcu(dev, upper, iter)
> > > -               features = netdev_sync_upper_features(dev, upper, features);
> > > +       netdev_for_each_upper_dev_rcu(dev, upper, iter) {
> > > +               if (netif_is_lag_master(upper) || netif_is_bridge_master(upper))
> > > +                       features = netdev_sync_upper_features(dev,
> > > upper, features);
> > > +       }
> > >
> > >         if (dev->features == features)
> > >                 goto sync_lower;
> > > @@ -9633,8 +9635,10 @@ int __netdev_update_features(struct net_device *dev)
> > >         /* some features must be disabled on lower devices when disabled
> > >          * on an upper device (think: bonding master or bridge)
> > >          */
> > > -       netdev_for_each_lower_dev(dev, lower, iter)
> > > -               netdev_sync_lower_features(dev, lower, features);
> > > +       if (netif_is_lag_master(dev) || netif_is_bridge_master(dev)) {
> > > +               netdev_for_each_lower_dev(dev, lower, iter)
> > > +                       netdev_sync_lower_features(dev, lower, features);
> > > +       }
> > >
> > >         if (!err) {
> > >                 netdev_features_t diff = features ^ dev->features;
> > >
> > > I'm not sure what all other upper devices this excludes besides just
> > > vlan ports though, so perhaps safer add upper device types to not do
> > > feature sync on than to choose which ones to do them on?
> >
> > I'm not sure excluding devices from feature sync is the right way,
> > whether it's an explicit list types or default. The logic still makes
> > sense to me. Couldn't we address the issue by either setting features in
> > NETIF_F_UPPER_DISABLES) by default for a new vlan (and probably macvlan)
> > device? Or perhaps inheriting their values from the lower device.
>
> Yeah, I think you're right, excluding devices entirely from sync is a
> bad idea, it should be only certain features that don't get sync'd for
> devices that say they don't want them (i.e., vlan devs and macvlan
> devs). I'll do a bit more reading of the code and ponder. I'm not
> familiar with the intricacies of NETIF_F_UPPER_DISABLES just yet.
>
> --
> Jarod Wilson
> jarod@redhat.com
>
