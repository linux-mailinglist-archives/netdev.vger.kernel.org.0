Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D482D07CE
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 00:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgLFXAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 18:00:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbgLFXAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 18:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607295522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sWrhr1El9eOSsOpZA9zzstTEamBu/vnA/pkLu5UU6kY=;
        b=fW00XGQCSQ+4xIPrpq4Oqkhnre9C5qlTIgtoE0A9wTV975Egemdv/s4TghpJ0aRK9IJn/O
        BtBvmASc4JCUywwnbAvvfTtvKP3XJqmWvTEhwG0QjXdbNN/2CmfajQqRxkNcaMiUf44HmT
        WxV6Nzs0eDkzcr0F0jsg/KpAVXu02Q0=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-reAAO_kHPPGWj-zJmMQHjA-1; Sun, 06 Dec 2020 17:58:41 -0500
X-MC-Unique: reAAO_kHPPGWj-zJmMQHjA-1
Received: by mail-oo1-f70.google.com with SMTP id 4so4907762ooc.21
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 14:58:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sWrhr1El9eOSsOpZA9zzstTEamBu/vnA/pkLu5UU6kY=;
        b=HWD88J/ldzNUWeDb2huWYAX+lo9pHAHZ2xABN62ajnL0536Uy7lBzHwr1BqNQNqAMb
         L3BVlCZC2ONdNKBKftiUrE3F8gnpKsClN55IB+hlcm0scycGXNUIsT1koafiImAaAt7U
         TYORyLkLq4lTFN/8K0Fb9aFlwGbrrO3peeeVUFN1j9i4LhYtvsQhqmVyDwLB5Y9KyNGY
         XeJs9Ao4+j85Pj7MUXXahpn1OuANmCWPc90ep6h/o16cYqfOkjFK0YbDG3DUD9Ffsbel
         KFXNCFuDw0IoIZwihLTGMslwlRLXSYdhRbI76pFI7TrkLAYlAQSr5rQnzNVSKBd9im9P
         mNhw==
X-Gm-Message-State: AOAM532MDj6ibR8XlFGMCcfIA8aO0b/0EapL4nxhTBd14q7CF0n7oGS/
        1TXA/XcZ17fsdBlM8RExBpJ/J1bMUgUbEIqRJux9VoUVpa8ja35SPLjZKIBwJygFD9xHir76SnI
        EB80+qKI8XWdLG14hmmbC7E2J87JEMhjP
X-Received: by 2002:a9d:6642:: with SMTP id q2mr1529199otm.172.1607295520117;
        Sun, 06 Dec 2020 14:58:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFjrP7fjG7K6RqFUTklmAxpUj3bDI+O5asZbCjh9AKM+aECc2/3qZ4D3yD/JZ/Pljng4IC3mfTIewL/PlQLLg=
X-Received: by 2002:a9d:6642:: with SMTP id q2mr1529191otm.172.1607295519852;
 Sun, 06 Dec 2020 14:58:39 -0800 (PST)
MIME-Version: 1.0
References: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
 <20201123162639.5d692198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKfmpSdv5onOGk=VtEO1fWxxhaVvi96Tz-wCFcNE5R9cdXNgkg@mail.gmail.com> <20201206164924.baczz7eyxz6czro2@lion.mk-sys.cz>
In-Reply-To: <20201206164924.baczz7eyxz6czro2@lion.mk-sys.cz>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Sun, 6 Dec 2020 17:58:29 -0500
Message-ID: <CAKfmpSc1ZQ+FgBtn3XHkC2sTCFMoCq5BenCWswQmuWQs7A3Q=g@mail.gmail.com>
Subject: Re: LRO: creating vlan subports affects parent port's LRO settings
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Limin Wang <lwang.nbl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 6, 2020 at 11:49 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Sat, Dec 05, 2020 at 07:04:06PM -0500, Jarod Wilson wrote:
> > On Mon, Nov 23, 2020 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 19 Nov 2020 20:37:27 -0500 Limin Wang wrote:
> > > > Under relatively recent kernels (v4.4+), creating a vlan subport on a
> > > > LRO supported parent NIC may turn LRO off on the parent port and
> > > > further render its LRO feature practically unchangeable.
> > >
> > > That does sound like an oversight in commit fd867d51f889 ("net/core:
> > > generic support for disabling netdev features down stack").
> > >
> > > Are you able to create a patch to fix this?
> >
> > Something like this, perhaps? Completely untested copy-pasta'd
> > theoretical patch:
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 8588ade790cb..a5ce372e02ba 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9605,8 +9605,10 @@ int __netdev_update_features(struct net_device *dev)
> >         features = netdev_fix_features(dev, features);
> >
> >         /* some features can't be enabled if they're off on an upper device */
> > -       netdev_for_each_upper_dev_rcu(dev, upper, iter)
> > -               features = netdev_sync_upper_features(dev, upper, features);
> > +       netdev_for_each_upper_dev_rcu(dev, upper, iter) {
> > +               if (netif_is_lag_master(upper) || netif_is_bridge_master(upper))
> > +                       features = netdev_sync_upper_features(dev,
> > upper, features);
> > +       }
> >
> >         if (dev->features == features)
> >                 goto sync_lower;
> > @@ -9633,8 +9635,10 @@ int __netdev_update_features(struct net_device *dev)
> >         /* some features must be disabled on lower devices when disabled
> >          * on an upper device (think: bonding master or bridge)
> >          */
> > -       netdev_for_each_lower_dev(dev, lower, iter)
> > -               netdev_sync_lower_features(dev, lower, features);
> > +       if (netif_is_lag_master(dev) || netif_is_bridge_master(dev)) {
> > +               netdev_for_each_lower_dev(dev, lower, iter)
> > +                       netdev_sync_lower_features(dev, lower, features);
> > +       }
> >
> >         if (!err) {
> >                 netdev_features_t diff = features ^ dev->features;
> >
> > I'm not sure what all other upper devices this excludes besides just
> > vlan ports though, so perhaps safer add upper device types to not do
> > feature sync on than to choose which ones to do them on?
>
> I'm not sure excluding devices from feature sync is the right way,
> whether it's an explicit list types or default. The logic still makes
> sense to me. Couldn't we address the issue by either setting features in
> NETIF_F_UPPER_DISABLES) by default for a new vlan (and probably macvlan)
> device? Or perhaps inheriting their values from the lower device.

Yeah, I think you're right, excluding devices entirely from sync is a
bad idea, it should be only certain features that don't get sync'd for
devices that say they don't want them (i.e., vlan devs and macvlan
devs). I'll do a bit more reading of the code and ponder. I'm not
familiar with the intricacies of NETIF_F_UPPER_DISABLES just yet.

-- 
Jarod Wilson
jarod@redhat.com

